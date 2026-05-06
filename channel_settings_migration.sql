ALTER TABLE public.channels ADD COLUMN IF NOT EXISTS allow_status_posting_by text NOT NULL DEFAULT 'all';

-- Rename vague visibility rule columns to clear, descriptive names
ALTER TABLE public.channels RENAME COLUMN members_other_channels TO visible_to_other_channel_members;
ALTER TABLE public.channels RENAME COLUMN members_following TO visible_to_followed_users;
