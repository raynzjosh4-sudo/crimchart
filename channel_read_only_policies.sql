-- 1. Add is_discoverable column to channels table
ALTER TABLE public.channels ADD COLUMN IF NOT EXISTS is_discoverable boolean DEFAULT true;

-- 2. Enable Row Level Security (RLS) on the target tables
ALTER TABLE public.channel_posts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.channel_post_comments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.channel_messages ENABLE ROW LEVEL SECURITY;

-- ==========================================
-- channel_posts Policies
-- ==========================================

-- Read Access: Anyone can read public posts, or members can read any post in their channel.
CREATE POLICY "Allow public read access to channel posts"
ON public.channel_posts
FOR SELECT
USING (
  is_public = true 
  OR 
  EXISTS (
    SELECT 1 FROM public.channel_members cm 
    WHERE cm.channel_id = channel_posts.channel_id 
      AND cm.user_id = auth.uid()
  )
);

-- Write Access: Only members can create posts in the channel
CREATE POLICY "Only channel members can insert posts"
ON public.channel_posts
FOR INSERT
WITH CHECK (
  EXISTS (
    SELECT 1 FROM public.channel_members cm 
    WHERE cm.channel_id = channel_posts.channel_id 
      AND cm.user_id = auth.uid()
  )
  AND auth.uid() = author_id -- Ensure they are posting as themselves
);

-- Update Access: Only the author can update their own posts
CREATE POLICY "Authors can update their own posts"
ON public.channel_posts
FOR UPDATE
USING (auth.uid() = author_id);

-- Delete Access: Only the author can delete their own posts
CREATE POLICY "Authors can delete their own posts"
ON public.channel_posts
FOR DELETE
USING (auth.uid() = author_id);


-- ==========================================
-- channel_post_comments Policies
-- ==========================================

-- Read Access: Anyone can read comments
CREATE POLICY "Allow public read access to comments"
ON public.channel_post_comments
FOR SELECT
USING (true);

-- Write Access: Only members can comment on posts
CREATE POLICY "Only channel members can insert comments"
ON public.channel_post_comments
FOR INSERT
WITH CHECK (
  EXISTS (
    SELECT 1 FROM public.channel_members cm 
    WHERE cm.channel_id = channel_post_comments.channel_id 
      AND cm.user_id = auth.uid()
  )
  AND auth.uid() = author_id
);

-- Update Access: Only the author can update their own comments
CREATE POLICY "Authors can update their own comments"
ON public.channel_post_comments
FOR UPDATE
USING (auth.uid() = author_id);

-- Delete Access: Only the author can delete their own comments
CREATE POLICY "Authors can delete their own comments"
ON public.channel_post_comments
FOR DELETE
USING (auth.uid() = author_id);


-- ==========================================
-- channel_messages Policies
-- ==========================================

-- Read Access: Users can read messages if the channel is discoverable or if they are a member
CREATE POLICY "Allow read access to channel messages"
ON public.channel_messages
FOR SELECT
USING (
  EXISTS (
    SELECT 1 FROM public.channels c
    WHERE c.id = channel_messages.channel_id
      AND c.is_discoverable = true
  )
  OR
  EXISTS (
    SELECT 1 FROM public.channel_members cm 
    WHERE cm.channel_id = channel_messages.channel_id 
      AND cm.user_id = auth.uid()
  )
);

-- Write Access: Only members can send messages in the channel
CREATE POLICY "Only channel members can insert messages"
ON public.channel_messages
FOR INSERT
WITH CHECK (
  EXISTS (
    SELECT 1 FROM public.channel_members cm 
    WHERE cm.channel_id = channel_messages.channel_id 
      AND cm.user_id = auth.uid()
  )
  AND auth.uid() = sender_id
);

-- Update Access: Only the author can update their own messages
CREATE POLICY "Authors can update their own messages"
ON public.channel_messages
FOR UPDATE
USING (auth.uid() = sender_id);

-- Delete Access: Only the author can delete their own messages
CREATE POLICY "Authors can delete their own messages"
ON public.channel_messages
FOR DELETE
USING (auth.uid() = sender_id);
