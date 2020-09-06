SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


CREATE DATABASE IF NOT EXIST discord_invite_manager;


-- Table Structure for GUILDS
CREATE TABLE guilds IF NOT EXIST (
  id varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  name varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  icon varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  memberCount int(11) DEFAULT NULL,
  createdAt datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updatedAt datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deletedAt datetime DEFAULT NULL
);


-- Table Structure for GUILD SETTING
CREATE TABLE guildSettings IF NOT EXIST(
  guildId varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  value json DEFAULT NULL,
  createdAt datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updatedAt datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);


-- Table structure for InviteCode
CREATE TABLE inviteCodes IF NOT EXIST(
  code varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  maxAge int(11) DEFAULT NULL,
  maxUses int(11) DEFAULT NULL,
  uses int(11) DEFAULT NULL,
  clearedAmount int(11) NOT NULL DEFAULT '0',
  createdAt datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updatedAt datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  guildId varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  channelId varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  inviterId varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL
);


-- Table structure for invitecode setting
CREATE TABLE inviteCodeSettings IF NOT EXIST(
  guildId varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  inviteCode varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  value json DEFAULT NULL,
  createdAt datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updatedAt datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);  


-- Table structure for Member leaving the server
CREATE TABLE leaves IF NOT EXIST(
  id int(11) NOT NULL,
  createdAt datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  guildId varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  memberId varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  joinId int(11) DEFAULT NULL
);


-- Table structure for member joining
CREATE TABLE joins IF NOT EXIST(
  id int(11) NOT NULL,
  cleared tinyint(4) NOT NULL DEFAULT '0',
  createdAt datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updatedAt datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  guildId varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  memberId varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  exactMatchCode varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL
);



--  -- -- -- Altering The Table

-- guilds tables
ALTER TABLE guilds
  ADD PRIMARY KEY (id),
  ADD KEY deletedAt (deletedAt);
ALTER TABLE guilds ADD FULLTEXT KEY name (name);


-- guilds setting
ALTER TABLE guildSettings
  ADD PRIMARY KEY (guildId);


-- invite code
ALTER TABLE inviteCodes
  ADD PRIMARY KEY (code),
  ADD KEY channelId (channelId),
  ADD KEY inviterId (inviterId),
  ADD KEY guildId_inviterId (guildId,inviterId);


-- invite code setting
ALTER TABLE inviteCodeSettings
  ADD PRIMARY KEY (inviteCode),
  ADD UNIQUE KEY invite_code_settings_guild_id_invite_code (guildId,inviteCode);


-- member joining
ALTER TABLE joins
  ADD PRIMARY KEY (id),
  ADD UNIQUE KEY joins_guild_id_member_id_created_at (guildId,memberId,createdAt),
  ADD KEY memberId (memberId),
  ADD KEY exactMatchCode_guildId (exactMatchCode,guildId);


-- member leaving
ALTER TABLE leaves
  ADD PRIMARY KEY (id),
  ADD KEY memberId (memberId),
  ADD KEY joinId (joinId),
  ADD KEY leaves_guild_id_member_id_join_id (guildId,memberId,joinId) USING BTREE;


--  -- -- -- Auto Incrementing the table

ALTER TABLE joins
  MODIFY id int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE leaves
  MODIFY id int(11) NOT NULL AUTO_INCREMENT;


