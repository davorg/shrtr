package Shrtr::Schema::Result::UserUrl;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 NAME

Shrtr::Schema::Result::UserUrl

=cut

__PACKAGE__->table("user_url");

=head1 ACCESSORS

=head2 user

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 url

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 ts

  data_type: 'timestamp'
  datetime_undef_if_invalid: 1
  default_value: current_timestamp
  is_nullable: 0

=head2 ip

  data_type: 'varchar'
  is_nullable: 1
  size: 15

=cut

__PACKAGE__->add_columns(
  "user",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "url",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "ts",
  {
    data_type => "timestamp",
    datetime_undef_if_invalid => 1,
    default_value => \"current_timestamp",
    is_nullable => 0,
  },
  "ip",
  { data_type => "varchar", is_nullable => 1, size => 15 },
);

=head1 RELATIONS

=head2 url

Type: belongs_to

Related object: L<Shrtr::Schema::Result::Url>

=cut

__PACKAGE__->belongs_to(
  "url",
  "Shrtr::Schema::Result::Url",
  { id => "url" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);

=head2 user

Type: belongs_to

Related object: L<Shrtr::Schema::Result::User>

=cut

__PACKAGE__->belongs_to(
  "user",
  "Shrtr::Schema::Result::User",
  { id => "user" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-04-08 16:55:07
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:bhN4sclzkGQlV0M4aJ4hjw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
