-- WARNING: This schema is for context only and is not meant to be run.
-- Table order and constraints may not be valid for execution.

CREATE TABLE public.channel_branding (
  channel_id uuid NOT NULL,
  theme_color text,
  cover_image_url text,
  leader_avatar_url text,
  is_animated boolean DEFAULT false,
  has_border boolean DEFAULT false,
  CONSTRAINT channel_branding_pkey PRIMARY KEY (channel_id),
  CONSTRAINT channel_branding_channel_id_fkey FOREIGN KEY (channel_id) REFERENCES public.channels(id)
);
CREATE TABLE public.channel_content_tags (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  post_id uuid NOT NULL,
  user_id uuid NOT NULL,
  source_channel_id uuid NOT NULL,
  target_channel_id uuid NOT NULL,
  created_at timestamp with time zone DEFAULT timezone('utc'::text, now()),
  link_chain ARRAY DEFAULT '{}'::text[],
  CONSTRAINT channel_content_tags_pkey PRIMARY KEY (id),
  CONSTRAINT channel_content_tags_post_id_fkey FOREIGN KEY (post_id) REFERENCES public.channel_posts(id),
  CONSTRAINT channel_content_tags_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.profiles(id),
  CONSTRAINT channel_content_tags_source_channel_id_fkey FOREIGN KEY (source_channel_id) REFERENCES public.channels(id),
  CONSTRAINT channel_content_tags_target_channel_id_fkey FOREIGN KEY (target_channel_id) REFERENCES public.channels(id)
);
CREATE TABLE public.channel_creator (
  channel_id uuid NOT NULL,
  creator_id uuid NOT NULL,
  name text,
  is_verified boolean DEFAULT false,
  is_following boolean DEFAULT false,
  role_title text,
  CONSTRAINT channel_creator_pkey PRIMARY KEY (channel_id),
  CONSTRAINT channel_creator_channel_id_fkey FOREIGN KEY (channel_id) REFERENCES public.channels(id),
  CONSTRAINT channel_creator_creator_id_fkey FOREIGN KEY (creator_id) REFERENCES public.profiles(id)
);
CREATE TABLE public.channel_gifts (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  channel_id uuid NOT NULL,
  giver_id uuid NOT NULL,
  receiver_id uuid NOT NULL,
  gift_id text NOT NULL,
  coin_value integer DEFAULT 0,
  received_at timestamp with time zone DEFAULT timezone('utc'::text, now()),
  CONSTRAINT channel_gifts_pkey PRIMARY KEY (id),
  CONSTRAINT channel_gifts_channel_id_fkey FOREIGN KEY (channel_id) REFERENCES public.channels(id),
  CONSTRAINT channel_gifts_giver_id_fkey FOREIGN KEY (giver_id) REFERENCES public.profiles(id),
  CONSTRAINT channel_gifts_receiver_id_fkey FOREIGN KEY (receiver_id) REFERENCES public.profiles(id)
);
CREATE TABLE public.channel_invitations (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  sender_id uuid NOT NULL,
  source_channel_id uuid NOT NULL,
  target_channel_id uuid NOT NULL,
  created_at timestamp with time zone DEFAULT timezone('utc'::text, now()),
  CONSTRAINT channel_invitations_pkey PRIMARY KEY (id),
  CONSTRAINT channel_invitations_sender_id_fkey FOREIGN KEY (sender_id) REFERENCES public.profiles(id),
  CONSTRAINT channel_invitations_source_channel_id_fkey FOREIGN KEY (source_channel_id) REFERENCES public.channels(id),
  CONSTRAINT channel_invitations_target_channel_id_fkey FOREIGN KEY (target_channel_id) REFERENCES public.channels(id)
);
CREATE TABLE public.channel_members (
  channel_id uuid NOT NULL,
  user_id uuid NOT NULL,
  role text DEFAULT 'member'::text,
  unread_count integer DEFAULT 0,
  joined_at timestamp with time zone DEFAULT timezone('utc'::text, now()),
  CONSTRAINT channel_members_pkey PRIMARY KEY (channel_id, user_id),
  CONSTRAINT channel_members_channel_id_fkey FOREIGN KEY (channel_id) REFERENCES public.channels(id),
  CONSTRAINT channel_members_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.profiles(id)
);
CREATE TABLE public.channel_messages (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  channel_id uuid NOT NULL,
  sender_id uuid NOT NULL,
  text_content text,
  media_url text,
  media_type text,
  voice_note_url text,
  reply_to_id uuid,
  is_read boolean DEFAULT false,
  is_pending boolean DEFAULT false,
  created_at timestamp with time zone DEFAULT timezone('utc'::text, now()),
  metadata jsonb,
  thumbnail_url text,
  CONSTRAINT channel_messages_pkey PRIMARY KEY (id),
  CONSTRAINT channel_messages_channel_id_fkey FOREIGN KEY (channel_id) REFERENCES public.channels(id),
  CONSTRAINT channel_messages_sender_id_fkey FOREIGN KEY (sender_id) REFERENCES public.profiles(id)
);
CREATE TABLE public.channel_metadata (
  channel_id uuid NOT NULL,
  member_count integer DEFAULT 0,
  unread_count integer DEFAULT 0,
  posts_badge_count integer DEFAULT 0,
  members_badge_count integer DEFAULT 0,
  messages_badge_count integer DEFAULT 0,
  is_charted boolean DEFAULT false,
  is_pending boolean DEFAULT false,
  created_at timestamp with time zone DEFAULT timezone('utc'::text, now()),
  last_message_at timestamp with time zone,
  CONSTRAINT channel_metadata_pkey PRIMARY KEY (channel_id),
  CONSTRAINT channel_metadata_channel_id_fkey FOREIGN KEY (channel_id) REFERENCES public.channels(id)
);
CREATE TABLE public.channel_moments (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  channel_id uuid NOT NULL,
  author_id uuid NOT NULL,
  media_url text NOT NULL,
  caption text,
  created_at timestamp with time zone DEFAULT timezone('utc'::text, now()),
  expires_at timestamp with time zone,
  media_type text NOT NULL DEFAULT 'photo'::text,
  thumbnail_url text,
  CONSTRAINT channel_moments_pkey PRIMARY KEY (id),
  CONSTRAINT channel_moments_channel_id_fkey FOREIGN KEY (channel_id) REFERENCES public.channels(id),
  CONSTRAINT channel_moments_author_id_fkey FOREIGN KEY (author_id) REFERENCES public.profiles(id)
);
CREATE TABLE public.channel_post_comment_counts (
  post_id uuid NOT NULL,
  user_id uuid NOT NULL,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT channel_post_comment_counts_pkey PRIMARY KEY (post_id, user_id),
  CONSTRAINT channel_post_comment_counts_post_id_fkey FOREIGN KEY (post_id) REFERENCES public.channel_posts(id),
  CONSTRAINT channel_post_comment_counts_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id)
);
CREATE TABLE public.channel_post_comments (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  post_id uuid NOT NULL,
  author_id uuid NOT NULL,
  created_at timestamp with time zone DEFAULT timezone('utc'::text, now()),
  channel_id uuid,
  message text,
  image_urls jsonb DEFAULT '[]'::jsonb,
  likes integer DEFAULT 0,
  is_pending boolean DEFAULT false,
  CONSTRAINT channel_post_comments_pkey PRIMARY KEY (id),
  CONSTRAINT channel_post_comments_author_id_fkey FOREIGN KEY (author_id) REFERENCES public.profiles(id),
  CONSTRAINT channel_post_comments_channel_id_fkey FOREIGN KEY (channel_id) REFERENCES public.channels(id)
);
CREATE TABLE public.channel_post_likes (
  user_id uuid NOT NULL,
  post_id uuid NOT NULL,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT channel_post_likes_pkey PRIMARY KEY (user_id, post_id),
  CONSTRAINT channel_post_likes_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id),
  CONSTRAINT channel_post_likes_post_id_fkey FOREIGN KEY (post_id) REFERENCES public.channel_posts(id)
);
CREATE TABLE public.channel_post_tags (
  id integer GENERATED ALWAYS AS IDENTITY NOT NULL,
  post_id uuid NOT NULL,
  tag_name text NOT NULL,
  tag_value text,
  tag_color text,
  CONSTRAINT channel_post_tags_pkey PRIMARY KEY (id),
  CONSTRAINT channel_post_tags_post_id_fkey FOREIGN KEY (post_id) REFERENCES public.channel_posts(id)
);
CREATE TABLE public.channel_posts (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  channel_id uuid NOT NULL,
  author_id uuid NOT NULL,
  caption text,
  image_urls jsonb DEFAULT '[]'::jsonb,
  video_url text,
  is_video boolean DEFAULT false,
  is_sponsored boolean DEFAULT false,
  aspect_ratio double precision,
  likes integer DEFAULT 0,
  comments integer DEFAULT 0,
  shares integer DEFAULT 0,
  created_at timestamp with time zone DEFAULT timezone('utc'::text, now()),
  is_pending boolean DEFAULT false,
  video_urls jsonb DEFAULT '[]'::jsonb,
  thumbnail_urls jsonb DEFAULT '[]'::jsonb,
  author_username text,
  author_profile_image_url text,
  audio_url text,
  is_audio boolean DEFAULT false,
  allow_comments boolean DEFAULT true,
  is_public boolean DEFAULT true,
  post_type text DEFAULT 'post'::text,
  metadata jsonb DEFAULT '{}'::jsonb,
  tags_count integer DEFAULT 0,
  CONSTRAINT channel_posts_pkey PRIMARY KEY (id),
  CONSTRAINT channel_posts_channel_id_fkey FOREIGN KEY (channel_id) REFERENCES public.channels(id),
  CONSTRAINT channel_posts_author_id_fkey FOREIGN KEY (author_id) REFERENCES public.profiles(id)
);
CREATE TABLE public.channel_presence (
  channel_id uuid NOT NULL,
  user_id uuid NOT NULL,
  is_typing boolean DEFAULT false,
  is_online boolean DEFAULT false,
  last_seen_at timestamp with time zone,
  last_known_name text,
  last_known_avatar text,
  CONSTRAINT channel_presence_pkey PRIMARY KEY (channel_id, user_id),
  CONSTRAINT channel_presence_channel_id_fkey FOREIGN KEY (channel_id) REFERENCES public.channels(id),
  CONSTRAINT channel_presence_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.profiles(id)
);
CREATE TABLE public.channel_statuses (
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
  comments_count integer NOT NULL DEFAULT 0,
  thumbnail_url text,
  CONSTRAINT channel_statuses_pkey PRIMARY KEY (id),
  CONSTRAINT channel_statuses_channel_id_fkey FOREIGN KEY (channel_id) REFERENCES public.channels(id),
  CONSTRAINT channel_statuses_author_id_fkey FOREIGN KEY (author_id) REFERENCES public.profiles(id)
);
CREATE TABLE public.channels (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  creator_id uuid NOT NULL,
  name text NOT NULL,
  description text,
  avatar_url text,
  age_restriction text DEFAULT 'All Ages'::text,
  visible_to_other_channel_members boolean DEFAULT false,
  visible_to_followed_users boolean DEFAULT true,
  join_method text DEFAULT 'invite'::text,
  prevent_leaving boolean DEFAULT false,
  country_restrictions jsonb DEFAULT '["Global"]'::jsonb,
  allow_commenting_by text DEFAULT 'all'::text,
  members_count integer DEFAULT 1,
  created_at timestamp with time zone NOT NULL DEFAULT timezone('utc'::text, now()),
  unread_count integer DEFAULT 0,
  allow_status_posting_by text NOT NULL DEFAULT 'all'::text,
  is_discoverable boolean DEFAULT true,
  allow_invitations_by text DEFAULT 'all'::text,
  followers_count integer DEFAULT 0,
  tags_count integer DEFAULT 0,
  likes_count integer DEFAULT 0,
  CONSTRAINT channels_pkey PRIMARY KEY (id),
  CONSTRAINT channels_creator_id_fkey FOREIGN KEY (creator_id) REFERENCES public.profiles(id)
);
CREATE TABLE public.common_channels (
  user_id uuid NOT NULL,
  other_user_id uuid NOT NULL,
  channel_id uuid NOT NULL,
  CONSTRAINT common_channels_pkey PRIMARY KEY (user_id, other_user_id, channel_id),
  CONSTRAINT common_channels_channel_id_fkey FOREIGN KEY (channel_id) REFERENCES public.channels(id),
  CONSTRAINT common_channels_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.profiles(id),
  CONSTRAINT common_channels_other_user_id_fkey FOREIGN KEY (other_user_id) REFERENCES public.profiles(id)
);
CREATE TABLE public.crown_options (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  crown_id uuid NOT NULL,
  description text NOT NULL,
  media_url text,
  media_type text DEFAULT 'none'::text,
  link text,
  crowned_user_id uuid,
  created_at timestamp with time zone DEFAULT timezone('utc'::text, now()),
  CONSTRAINT crown_options_pkey PRIMARY KEY (id),
  CONSTRAINT crown_options_crown_id_fkey FOREIGN KEY (crown_id) REFERENCES public.crowns(id),
  CONSTRAINT crown_options_crowned_user_id_fkey FOREIGN KEY (crowned_user_id) REFERENCES public.profiles(id)
);
CREATE TABLE public.crown_votes (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  crown_id uuid NOT NULL,
  option_id uuid NOT NULL,
  user_id uuid NOT NULL,
  created_at timestamp with time zone DEFAULT timezone('utc'::text, now()),
  CONSTRAINT crown_votes_pkey PRIMARY KEY (id),
  CONSTRAINT crown_votes_crown_id_fkey FOREIGN KEY (crown_id) REFERENCES public.crowns(id),
  CONSTRAINT crown_votes_option_id_fkey FOREIGN KEY (option_id) REFERENCES public.crown_options(id),
  CONSTRAINT crown_votes_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.profiles(id)
);
CREATE TABLE public.crowns (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  title text NOT NULL,
  description text NOT NULL,
  crowner_id uuid NOT NULL,
  channel_id uuid,
  is_active boolean DEFAULT true,
  has_status boolean DEFAULT false,
  created_at timestamp with time zone DEFAULT timezone('utc'::text, now()),
  CONSTRAINT crowns_pkey PRIMARY KEY (id),
  CONSTRAINT crowns_crowner_id_fkey FOREIGN KEY (crowner_id) REFERENCES public.profiles(id),
  CONSTRAINT crowns_channel_id_fkey FOREIGN KEY (channel_id) REFERENCES public.channels(id)
);
CREATE TABLE public.posts (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  author_id uuid NOT NULL,
  channel_id uuid,
  channel_name text,
  caption text,
  video_url text,
  image_urls jsonb DEFAULT '[]'::jsonb,
  is_video boolean DEFAULT false,
  likes integer DEFAULT 0,
  comments integer DEFAULT 0,
  shares integer DEFAULT 0,
  created_at timestamp with time zone NOT NULL DEFAULT timezone('utc'::text, now()),
  linked_post_id uuid,
  folder_name text DEFAULT 'public_posts'::text,
  privacy text DEFAULT 'public'::text,
  role_viewer text,
  thumbnail_urls jsonb DEFAULT '[]'::jsonb,
  sd_video_url text,
  audio_url text,
  is_audio boolean DEFAULT false,
  post_type text DEFAULT 'post'::text,
  parent_post_id text,
  link_chain text DEFAULT '[]'::text,
  link_depth integer DEFAULT 0,
  aspect_ratio double precision,
  allow_comments boolean DEFAULT true,
  video_urls jsonb DEFAULT '[]'::jsonb,
  CONSTRAINT posts_pkey PRIMARY KEY (id),
  CONSTRAINT posts_author_id_fkey FOREIGN KEY (author_id) REFERENCES public.profiles(id),
  CONSTRAINT posts_channel_id_fkey FOREIGN KEY (channel_id) REFERENCES public.channels(id)
);
CREATE TABLE public.profiles (
  id uuid NOT NULL,
  username text NOT NULL UNIQUE,
  display_name text NOT NULL,
  profile_image_url text,
  bio text,
  crown_title text,
  birthday date,
  gender text,
  crown_category text DEFAULT 'default'::text,
  is_verified boolean DEFAULT false,
  followers_count integer DEFAULT 0,
  following_count integer DEFAULT 0,
  posts_count integer DEFAULT 0,
  crowns_count integer DEFAULT 0,
  channels_count integer DEFAULT 0,
  created_at timestamp with time zone NOT NULL DEFAULT timezone('utc'::text, now()),
  is_online boolean DEFAULT false,
  ChartTitle text,
  CONSTRAINT profiles_pkey PRIMARY KEY (id),
  CONSTRAINT profiles_id_fkey FOREIGN KEY (id) REFERENCES auth.users(id)
);
CREATE TABLE public.status_views (
  status_id uuid NOT NULL,
  viewer_id uuid NOT NULL,
  viewed_at timestamp with time zone DEFAULT timezone('utc'::text, now()),
  CONSTRAINT status_views_pkey PRIMARY KEY (status_id, viewer_id),
  CONSTRAINT status_views_status_id_fkey FOREIGN KEY (status_id) REFERENCES public.statuses(id),
  CONSTRAINT status_views_viewer_id_fkey FOREIGN KEY (viewer_id) REFERENCES public.profiles(id)
);
CREATE TABLE public.statuses (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  author_id uuid NOT NULL,
  caption text,
  image_urls jsonb DEFAULT '[]'::jsonb,
  video_url text,
  audio_url text,
  is_video boolean DEFAULT false,
  is_audio boolean DEFAULT false,
  privacy text DEFAULT 'public'::text,
  allow_comments boolean DEFAULT true,
  views_count integer DEFAULT 0,
  likes_count integer DEFAULT 0,
  created_at timestamp with time zone NOT NULL DEFAULT timezone('utc'::text, now()),
  expires_at timestamp with time zone,
  thumbnail_url text,
  CONSTRAINT statuses_pkey PRIMARY KEY (id),
  CONSTRAINT statuses_author_id_fkey FOREIGN KEY (author_id) REFERENCES public.profiles(id)
);