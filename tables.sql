-- WARNING: This schema is for context only and is not meant to be run.
-- Table order and constraints may not be valid for execution.

CREATE TABLE public.channel_comments (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  author_id uuid NOT NULL,
  channel_id uuid NOT NULL,
  manifesto_id uuid,
  message text,
  image_urls jsonb DEFAULT '[]'::jsonb,
  likes integer DEFAULT 0,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT channel_comments_pkey PRIMARY KEY (id)
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
CREATE TABLE public.channel_post_comments (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  post_id uuid NOT NULL,
  author_id uuid NOT NULL,
  comment_text text NOT NULL,
  created_at timestamp with time zone DEFAULT timezone('utc'::text, now()),
  CONSTRAINT channel_post_comments_pkey PRIMARY KEY (id),
  CONSTRAINT channel_post_comments_author_id_fkey FOREIGN KEY (author_id) REFERENCES public.profiles(id)
);
CREATE TABLE public.channels (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  creator_id uuid NOT NULL,
  name text NOT NULL,
  description text,
  avatar_url text,
  age_restriction text DEFAULT 'All Ages'::text,
  members_other_channels boolean DEFAULT false,
  members_following boolean DEFAULT true,
  join_method text DEFAULT 'invite'::text,
  prevent_leaving boolean DEFAULT false,
  country_restrictions jsonb DEFAULT '["Global"]'::jsonb,
  allow_commenting_by text DEFAULT 'all'::text,
  members_count integer DEFAULT 1,
  created_at timestamp with time zone NOT NULL DEFAULT timezone('utc'::text, now()),
  unread_count integer DEFAULT 0,
  CONSTRAINT channels_pkey PRIMARY KEY (id),
  CONSTRAINT channels_creator_id_fkey FOREIGN KEY (creator_id) REFERENCES public.profiles(id)
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
CREATE TABLE public.manifesto_comments (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  manifesto_id uuid NOT NULL,
  author_id uuid NOT NULL,
  channel_id uuid NOT NULL,
  message text,
  image_urls jsonb DEFAULT '[]'::jsonb,
  audio_url text,
  likes integer DEFAULT 0,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT manifesto_comments_pkey PRIMARY KEY (id),
  CONSTRAINT manifesto_comments_author_fkey FOREIGN KEY (author_id) REFERENCES auth.users(id),
  CONSTRAINT manifesto_comments_manifesto_fkey FOREIGN KEY (manifesto_id) REFERENCES public.manifestos(id)
);
CREATE TABLE public.manifestos (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  author_id uuid NOT NULL,
  channel_id uuid NOT NULL,
  caption text,
  video_url text,
  video_urls jsonb DEFAULT '[]'::jsonb,
  image_urls jsonb DEFAULT '[]'::jsonb,
  thumbnail_urls jsonb DEFAULT '[]'::jsonb,
  is_video boolean DEFAULT false,
  is_audio boolean DEFAULT false,
  audio_url text,
  likes integer DEFAULT 0,
  comments integer DEFAULT 0,
  created_at timestamp with time zone DEFAULT now(),
  is_public boolean DEFAULT true,
  allow_comments boolean DEFAULT true,
  CONSTRAINT manifestos_pkey PRIMARY KEY (id)
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
  CONSTRAINT statuses_pkey PRIMARY KEY (id),
  CONSTRAINT statuses_author_id_fkey FOREIGN KEY (author_id) REFERENCES public.profiles(id)
);