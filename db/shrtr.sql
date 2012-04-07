create database if not exists shrtr;
use shrtr;

# create user 'shrtr'@'localhost' identified by '5hr7r';

create table if not exists shrtr_url (
  code char(10) primary key,
  url text,
  clicks int
) ENGINE InnoDB;

grant all on shrtr.* to 'shrtr';
