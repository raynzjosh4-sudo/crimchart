-- 👑 CROSS-CHANNEL INVITATIONS & EXTENSIBILITY
ALTER TABLE channel_posts ADD COLUMN post_type TEXT DEFAULT 'post';
ALTER TABLE channel_posts ADD COLUMN metadata JSONB;

-- 👑 COMMUNITY POLLS & RICH MESSAGES
ALTER TABLE channel_messages ADD COLUMN message_type TEXT DEFAULT 'text';
ALTER TABLE channel_messages ADD COLUMN metadata JSONB;

-- 👑 POLLS TABLE
CREATE TABLE IF NOT EXISTS channel_polls (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  message_id UUID NOT NULL REFERENCES channel_messages (id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  total_points INTEGER NOT NULL DEFAULT 0,
  is_closed BOOLEAN NOT NULL DEFAULT FALSE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 👑 POLL OPTIONS TABLE
CREATE TABLE IF NOT EXISTS channel_poll_options (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  poll_id UUID NOT NULL REFERENCES channel_polls (id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  media_url TEXT,
  media_type TEXT DEFAULT 'image',
  points INTEGER NOT NULL DEFAULT 0,
  suggested_by UUID REFERENCES auth.users (id) ON DELETE SET NULL
);

-- 👑 CHANNEL GIFTS TABLE
CREATE TABLE IF NOT EXISTS channel_gifts (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  channel_id UUID NOT NULL REFERENCES channels (id) ON DELETE CASCADE,
  giver_id UUID NOT NULL REFERENCES auth.users (id) ON DELETE CASCADE,
  receiver_id UUID NOT NULL REFERENCES auth.users (id) ON DELETE CASCADE,
  gift_id TEXT NOT NULL,
  coin_value INTEGER NOT NULL DEFAULT 0,
  message_id UUID REFERENCES channel_messages (id) ON DELETE SET NULL,
  received_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Note: In Drift we used composite keys (channel_id, giver_id) referencing channel_members. 
-- In Supabase, usually separate FKs or a similar composite FK can be used if channel_members uses composite PK.
-- If your channel_members table in Supabase has a composite primary key of (channel_id, user_id), uncomment the next line:
-- ALTER TABLE channel_gifts ADD CONSTRAINT fk_channel_gifts_giver FOREIGN KEY (channel_id, giver_id) REFERENCES channel_members (channel_id, user_id) ON DELETE CASCADE;
