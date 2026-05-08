-- ==============================================================================
-- CROWN APP - CHANNEL TAGGING MIGRATION
-- ==============================================================================
-- Implementation of a robust tagging system for posts.
-- Tracks who tagged, the source channel, the target channel, and the counts.
-- ==============================================================================

-- 1. Ensure count columns exist
ALTER TABLE public.channel_posts 
ADD COLUMN IF NOT EXISTS tags_count integer DEFAULT 0;

-- Note: public.channels already has tags_count based on current schema.

-- 2. Create the Channel Content Tags table
CREATE TABLE IF NOT EXISTS public.channel_content_tags (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  post_id uuid NOT NULL,
  user_id uuid NOT NULL,
  source_channel_id uuid NOT NULL,
  target_channel_id uuid NOT NULL,
  created_at timestamp with time zone DEFAULT timezone('utc'::text, now()),
  
  CONSTRAINT channel_content_tags_pkey PRIMARY KEY (id),
  CONSTRAINT channel_content_tags_post_id_fkey FOREIGN KEY (post_id) REFERENCES public.channel_posts(id) ON DELETE CASCADE,
  CONSTRAINT channel_content_tags_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.profiles(id) ON DELETE CASCADE,
  CONSTRAINT channel_content_tags_source_channel_id_fkey FOREIGN KEY (source_channel_id) REFERENCES public.channels(id) ON DELETE CASCADE,
  CONSTRAINT channel_content_tags_target_channel_id_fkey FOREIGN KEY (target_channel_id) REFERENCES public.channels(id) ON DELETE CASCADE,
  
  -- Prevent duplicate tagging of the same content to the same target by the same user
  CONSTRAINT channel_content_tags_unique_tag UNIQUE (post_id, user_id, target_channel_id)
);

-- 3. Enable RLS
ALTER TABLE public.channel_content_tags ENABLE ROW LEVEL SECURITY;

-- 4. RLS Policies
CREATE POLICY "Users can view all tags" 
ON public.channel_content_tags FOR SELECT 
USING (true);

CREATE POLICY "Users can tag posts if they are members of the target channel" 
ON public.channel_content_tags FOR INSERT 
WITH CHECK (
  auth.uid() = user_id AND
  EXISTS (
    SELECT 1 FROM public.channel_members 
    WHERE channel_id = target_channel_id AND user_id = auth.uid()
  )
);

CREATE POLICY "Users can remove their own tags" 
ON public.channel_content_tags FOR DELETE 
USING (auth.uid() = user_id);

-- 5. Trigger Function to update counts
CREATE OR REPLACE FUNCTION public.handle_channel_content_tag_counts()
RETURNS TRIGGER AS $$
BEGIN
  IF (TG_OP = 'INSERT') THEN
    -- Increment post tag count
    UPDATE public.channel_posts 
    SET tags_count = tags_count + 1 
    WHERE id = NEW.post_id;
    
    -- Increment target channel tag count (How many tags it has received)
    UPDATE public.channels 
    SET tags_count = tags_count + 1 
    WHERE id = NEW.target_channel_id;
    
    RETURN NEW;
  ELSIF (TG_OP = 'DELETE') THEN
    -- Decrement post tag count
    UPDATE public.channel_posts 
    SET tags_count = tags_count - 1 
    WHERE id = OLD.post_id;
    
    -- Decrement target channel tag count
    UPDATE public.channels 
    SET tags_count = tags_count - 1 
    WHERE id = OLD.target_channel_id;
    
    RETURN OLD;
  END IF;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 6. Create Triggers
DROP TRIGGER IF EXISTS on_tag_created_or_deleted ON public.channel_content_tags;
CREATE TRIGGER on_tag_created_or_deleted
AFTER INSERT OR DELETE ON public.channel_content_tags
FOR EACH ROW EXECUTE FUNCTION public.handle_channel_content_tag_counts();

-- 7. Add Index for performance
CREATE INDEX IF NOT EXISTS idx_channel_content_tags_post_id ON public.channel_content_tags(post_id);
CREATE INDEX IF NOT EXISTS idx_channel_content_tags_target_channel_id ON public.channel_content_tags(target_channel_id);
