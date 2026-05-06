-- 1. Add the permission column to the channels table
ALTER TABLE public.channels 
ADD COLUMN allow_invitations_by text DEFAULT 'all'::text;

-- 2. Update RLS on channel_invitations to prevent new ones
-- Only allow insertion if the target channel's settings permit it
DROP POLICY IF EXISTS "Only authorized users can send invitations" ON public.channel_invitations;

CREATE POLICY "Check channel invitation permissions"
ON public.channel_invitations
FOR INSERT
WITH CHECK (
  EXISTS (
    SELECT 1 FROM public.channels c
    WHERE c.id = channel_invitations.target_channel_id
    AND (
      c.allow_invitations_by = 'all'
      OR (c.allow_invitations_by = 'members' AND EXISTS (
          SELECT 1 FROM public.channel_members cm 
          WHERE cm.channel_id = c.id AND cm.user_id = auth.uid()
      ))
      OR (c.allow_invitations_by = 'none' AND c.creator_id = auth.uid())
    )
  )
);

-- 3. Trigger to delete invitations AND invitation posts if the setting is turned off
CREATE OR REPLACE FUNCTION delete_invitations_on_restriction()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.allow_invitations_by = 'none' THEN
        -- Remove structured invitation records
        DELETE FROM public.channel_invitations 
        WHERE target_channel_id = NEW.id;

        -- Remove invitation posts from the feed
        DELETE FROM public.channel_posts
        WHERE channel_id = NEW.id
          AND post_type = 'invitation';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS on_channel_permission_change ON public.channels;
CREATE TRIGGER on_channel_permission_change
AFTER UPDATE OF allow_invitations_by ON public.channels
FOR EACH ROW
EXECUTE FUNCTION delete_invitations_on_restriction();
