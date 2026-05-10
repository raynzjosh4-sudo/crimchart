-- ============================================================
-- 👑 CHANNEL UNREAD COUNT TRIGGER
-- Run this in Supabase Dashboard → SQL Editor → New Query
-- ============================================================

-- STEP 1: The trigger FUNCTION for messages
-- Fires after every new message is inserted into channel_messages.
-- It increments unread_count for ALL members of that channel
-- EXCEPT the sender themselves (sender_id confirmed from schema).
CREATE OR REPLACE FUNCTION increment_unread_count()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE channel_members
  SET unread_count = unread_count + 1
  WHERE 
    channel_id = NEW.channel_id
    AND user_id != NEW.sender_id;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- STEP 2: Attach the trigger to channel_messages
DROP TRIGGER IF EXISTS on_new_channel_message ON channel_messages;

CREATE TRIGGER on_new_channel_message
  AFTER INSERT ON channel_messages
  FOR EACH ROW
  EXECUTE FUNCTION increment_unread_count();

-- ============================================================
-- 👑 CHANNEL MOMENTS UNREAD TRIGGER
-- Uses author_id (confirmed from channel_moments Drift schema)
-- Tracked in a separate column so messages and moments
-- badge counts remain independent on the nav bar.
-- ============================================================

-- STEP 3: Add unread_moments_count column to channel_members (safe, non-destructive)
ALTER TABLE channel_members
  ADD COLUMN IF NOT EXISTS unread_moments_count INTEGER NOT NULL DEFAULT 0;

-- STEP 4: The trigger FUNCTION for moments
CREATE OR REPLACE FUNCTION increment_unread_moments_count()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE channel_members
  SET unread_moments_count = unread_moments_count + 1
  WHERE 
    channel_id = NEW.channel_id
    AND user_id != NEW.author_id;  -- author_id confirmed from channel_moments schema

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- STEP 5: Attach the trigger to channel_moments
DROP TRIGGER IF EXISTS on_new_channel_moment ON channel_moments;

CREATE TRIGGER on_new_channel_moment
  AFTER INSERT ON channel_moments
  FOR EACH ROW
  EXECUTE FUNCTION increment_unread_moments_count();

-- ============================================================
-- VERIFICATION: Run separately to confirm both triggers are live
-- ============================================================
-- SELECT trigger_name, event_manipulation, event_object_table
-- FROM information_schema.triggers
-- WHERE event_object_table IN ('channel_messages', 'channel_moments');
