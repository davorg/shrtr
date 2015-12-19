-- 
-- Created by SQL::Translator::Producer::SQLite
-- Created on Sat Feb  9 20:39:27 2013
-- 

BEGIN TRANSACTION;

--
-- Table: click
--
DROP TABLE click;

CREATE TABLE click (
  id INTEGER PRIMARY KEY NOT NULL,
  url integer NOT NULL,
  ts timestamp NOT NULL DEFAULT current_timestamp,
  referrer varchar(200),
  user_agent varchar(200),
  ip_address varchar(15),
  FOREIGN KEY (url) REFERENCES url(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE INDEX click_idx_url ON click (url);

--
-- Table: url
--
DROP TABLE url;

CREATE TABLE url (
  id INTEGER PRIMARY KEY NOT NULL,
  code varchar(200),
  url text,
  ts timestamp NOT NULL DEFAULT current_timestamp
);

CREATE UNIQUE INDEX code ON url (code);

--
-- Table: user
--
DROP TABLE user;

CREATE TABLE user (
  id INTEGER PRIMARY KEY NOT NULL,
  username varchar(20) NOT NULL,
  email varchar(100) NOT NULL,
  password varchar(32) NOT NULL
);

--
-- Table: user_url
--
DROP TABLE user_url;

CREATE TABLE user_url (
  user integer,
  url integer,
  ts timestamp NOT NULL DEFAULT current_timestamp,
  ip varchar(15),
  FOREIGN KEY (url) REFERENCES url(id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (user) REFERENCES user(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE INDEX user_url_idx_url ON user_url (url);

CREATE INDEX user_url_idx_user ON user_url (user);

COMMIT;
