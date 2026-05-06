-- SQL to create the channel_invitations table in Supabase
-- This table tracks cross-channel invitations

CREATE TABLE IF NOT EXISTS public.channel_invitations (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  sender_id uuid NOT NULL,
  source_channel_id uuid NOT NULL, -- The channel where the invitation is posted
  target_channel_id uuid NOT NULL, -- The channel being invited to
  created_at timestamp with time zone DEFAULT timezone('utc'::text, now()),
  
  CONSTRAINT channel_invitations_pkey PRIMARY KEY (id),
  CONSTRAINT channel_invitations_sender_id_fkey FOREIGN KEY (sender_id) REFERENCES public.profiles(id) ON DELETE CASCADE,
  CONSTRAINT channel_invitations_source_channel_id_fkey FOREIGN KEY (source_channel_id) REFERENCES public.channels(id) ON DELETE CASCADE,
  CONSTRAINT channel_invitations_target_channel_id_fkey FOREIGN KEY (target_channel_id) REFERENCES public.channels(id) ON DELETE CASCADE
);

-- Enable RLS
ALTER TABLE public.channel_invitations ENABLE ROW LEVEL SECURITY;

-- Policy: Anyone can view invitations
CREATE POLICY "Invitations are viewable by everyone" 
ON public.channel_invitations FOR SELECT 
USING (true);

-- Policy: Only authenticated users can create invitations
CREATE POLICY "Users can create invitations" 
ON public.channel_invitations FOR INSERT 
WITH CHECK (auth.uid() = sender_id);

-- Add post_type column to channel_posts if it doesn't exist
-- This allows us to distinguish invitation posts from regular posts
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'channel_posts' AND column_name = 'post_type') THEN
        ALTER TABLE public.channel_posts ADD COLUMN post_type text DEFAULT 'post';
    END IF;
END $$;

-- Add metadata column to channel_posts if it doesn't exist
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'channel_posts' AND column_name = 'metadata') THEN
        ALTER TABLE public.channel_posts ADD COLUMN metadata jsonb DEFAULT '{}'::jsonb;
    END IF;
END $$;

-- Update existing channel_moments table to support videos
DO $$
BEGIN
    -- 1. Rename image_url to media_url if image_url exists
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'channel_moments' AND column_name = 'image_url') THEN
        ALTER TABLE public.channel_moments RENAME COLUMN image_url TO media_url;
    END IF;

    -- 2. Add media_type if it doesn't exist
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'channel_moments' AND column_name = 'media_type') THEN
        ALTER TABLE public.channel_moments ADD COLUMN media_type text NOT NULL DEFAULT 'photo';
    END IF;

    -- 3. Add thumbnail_url if it doesn't exist
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'channel_moments' AND column_name = 'thumbnail_url') THEN
        ALTER TABLE public.channel_moments ADD COLUMN thumbnail_url text;
    END IF;
END $$;

-- Ensure RLS is enabled
ALTER TABLE public.channel_moments ENABLE ROW LEVEL SECURITY;

-- Re-create policies if they don't exist
DROP POLICY IF EXISTS "Moments are viewable by everyone" ON public.channel_moments;
CREATE POLICY "Moments are viewable by everyone" 
ON public.channel_moments FOR SELECT 
USING (true);

DROP POLICY IF EXISTS "Users can create moments" ON public.channel_moments;
CREATE POLICY "Users can create moments" 
ON public.channel_moments FOR INSERT 
WITH CHECK (auth.uid() = author_id);
