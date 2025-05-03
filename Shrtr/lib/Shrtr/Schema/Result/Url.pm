package Shrtr::Schema::Result::Url;

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

Shrtr::Schema::Result::Url

=cut

__PACKAGE__->table("url");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 code

  data_type: 'varchar'
  is_nullable: 1
  size: 200

=head2 url

  data_type: 'text'
  is_nullable: 1

=head2 ts

  data_type: 'timestamp'
  datetime_undef_if_invalid: 1
  default_value: current_timestamp
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "code",
  { data_type => "varchar", is_nullable => 1, size => 200 },
  "url",
  { data_type => "text", is_nullable => 1 },
  "ts",
  {
    data_type => "timestamp",
    datetime_undef_if_invalid => 1,
    default_value => \"current_timestamp",
    is_nullable => 0,
  },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint("code", ["code"]);

=head1 RELATIONS

=head2 clicks

Type: has_many

Related object: L<Shrtr::Schema::Result::Click>

=cut

__PACKAGE__->has_many(
  "clicks",
  "Shrtr::Schema::Result::Click",
  { "foreign.url" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 user_urls

Type: has_many

Related object: L<Shrtr::Schema::Result::UserUrl>

=cut

__PACKAGE__->has_many(
  "user_urls",
  "Shrtr::Schema::Result::UserUrl",
  { "foreign.url" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-04-08 16:55:07
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:FoXnNJ92XRZorgk006qkXQ

__PACKAGE__->many_to_many(
  users => user_urls => 'user',
);

# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
