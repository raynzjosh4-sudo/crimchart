-- ============================================================
-- MIGRATION: Create channel_statuses table
-- PURPOSE: Stores ephemeral channel stories/statuses (24hr expiry).
--          Separate from channel_moments (highlights) and statuses (personal).
-- ============================================================

-- ✅ If you already created the table, run ONLY this line to add the new column:
ALTER TABLE public.channel_statuses
  ADD COLUMN IF NOT EXISTS comments_count integer NOT NULL DEFAULT 0;

-- ─────────────────────────────────────────────────────────────
-- Full table definition (for fresh installs only):
-- ─────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS public.channel_statuses (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  channel_id uuid NOT NULL,
  author_id uuid NOT NULL,

  caption text,
  image_urls jsonb DEFAULT '[]'::jsonb,
  video_url text,
  audio_url text,

  is_video boolean DEFAULT false,
  is_audio boolean DEFAULT false,

  views_count integer DEFAULT 0,
  likes_count integer DEFAULT 0,

  created_at timestamp with time zone NOT NULL DEFAULT timezone('utc'::text, now()),
  expires_at timestamp with time zone,

  CONSTRAINT channel_statuses_pkey PRIMARY KEY (id),
  CONSTRAINT channel_statuses_channel_id_fkey
    FOREIGN KEY (channel_id) REFERENCES public.channels(id) ON DELETE CASCADE,
  CONSTRAINT channel_statuses_author_id_fkey
    FOREIGN KEY (author_id) REFERENCES public.profiles(id) ON DELETE CASCADE
);

-- Index for fast lookups by channel (e.g., loading a channel's story bar)
CREATE INDEX IF NOT EXISTS idx_channel_statuses_channel_id
  ON public.channel_statuses (channel_id, created_at DESC);

-- Index for fast lookups by author (e.g., "my stories")
CREATE INDEX IF NOT EXISTS idx_channel_statuses_author_id
  ON public.channel_statuses (author_id, created_at DESC);

-- ============================================================
-- ROW LEVEL SECURITY
-- channel_members is the authority for access control.
-- Every policy verifies active membership — a non-member can
-- neither read nor write statuses, even with a valid author_id.
-- ============================================================

ALTER TABLE public.channel_statuses ENABLE ROW LEVEL SECURITY;

-- Policy: Only channel members can READ statuses from their channels
CREATE POLICY "Channel members can view channel statuses"
  ON public.channel_statuses FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM public.channel_members
      WHERE channel_members.channel_id = channel_statuses.channel_id
        AND channel_members.user_id = auth.uid()
    )
  );

-- Policy: Only channel members can INSERT a status.
--         Dual-check: author_id must match the caller AND they must be a member.
CREATE POLICY "Channel members can post channel statuses"
  ON public.channel_statuses FOR INSERT
  WITH CHECK (
    auth.uid() = author_id
    AND EXISTS (
      SELECT 1 FROM public.channel_members
      WHERE channel_members.channel_id = channel_statuses.channel_id
        AND channel_members.user_id = auth.uid()
    )
  );

-- Policy: Authors can delete only their own statuses (still requires active membership)
CREATE POLICY "Authors can delete their own channel statuses"
  ON public.channel_statuses FOR DELETE
  USING (
    auth.uid() = author_id
    AND EXISTS (
      SELECT 1 FROM public.channel_members
      WHERE channel_members.channel_id = channel_statuses.channel_id
        AND channel_members.user_id = auth.uid()
    )
  );
