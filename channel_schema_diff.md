# Database Schema Migration Plan

After cross-referencing your local Drift models with the remote `tables.sql` schema, here is the breakdown of what is missing and what needs to be changed to achieve 1:1 parity between local caching and your backend.

## 1. Missing Tables (Need to be created in Drift)

The following tables exist in your remote SQL schema but have no local Drift equivalent. They should be created to support full offline caching and rich UI experiences:

*   **`ChannelGifts` (`channel_gifts`)**: 
    *   **Purpose**: Tracks gifts/coins sent within a channel.
    *   **Fields Needed**: `id`, `channelId`, `giverId`, `receiverId`, `giftId`, `coinValue`, `receivedAt`.
*   **`Crowns` (`crowns`)**: 
    *   **Purpose**: Manages the core "Crown" (Poll/Voting) feature within channels.
    *   **Fields Needed**: `id`, `title`, `description`, `crownerId`, `channelId`, `isActive`, `hasStatus`, `createdAt`.
*   **`CrownOptions` (`crown_options`)**: 
    *   **Purpose**: The choices available to vote on within a Crown.
    *   **Fields Needed**: `id`, `crownId`, `description`, `mediaUrl`, `mediaType`, `link`, `crownedUserId`, `createdAt`.
*   **`CrownVotes` (`crown_votes`)**: 
    *   **Purpose**: Tracks which user voted for which option.
    *   **Fields Needed**: `id`, `crownId`, `optionId`, `userId`, `createdAt`.
*   **`StatusViews` (`status_views`)**: 
    *   **Purpose**: Tracks exactly who viewed an ephemeral status.
    *   **Fields Needed**: `statusId`, `viewerId`, `viewedAt`.

## 2. Changes Needed in Existing Drift Tables

To match `tables.sql` perfectly, we need to add or adjust a few columns in our current Drift definitions:

### `Channels` (Main Identity Table)
*   *Missing fields to add*: 
    *   `description` (maps to your `subtitle` perhaps, but we should match the SQL naming).
    *   `ageRestriction` (e.g., 'All Ages').
    *   `membersOtherChannels` (boolean).
    *   `membersFollowing` (boolean).
    *   `preventLeaving` (boolean).
    *   `countryRestrictions` (JSON string/list).
    *   `allowCommentingBy` (e.g., 'all').

### `ChannelPostComments`
*   *Missing fields to add*: 
    *   Currently, our `ChannelPostComments` has `message` and `imageUrls`, but SQL has `comment_text` instead of `message`. We should align the naming.

### `ChannelStatuses`
*   *Missing fields to add*: 
    *   SQL `statuses` has `video_url`, `audio_url`, `is_video`, `is_audio`, `privacy`, `allow_comments`, `views_count`, `likes_count`. We need to ensure our local `ChannelStatuses` supports these rich media types and interaction counters.

## Next Steps

If you approve of this plan, I can automatically generate the Drift files for `ChannelGifts`, the `Crown` ecosystem (Crowns, Options, Votes), and `StatusViews`, and then update the existing tables to add the missing columns!
