#!/usr/pkg/bin/perl
#

use Test::More tests => 1;

use Kharon::Entitlement::SimpleSQL;

use Krb5Admin::C;
use Krb5Admin::KerberosDB;

use strict;
use warnings;

$ENV{KRB5_CONFIG} = './t/krb5.conf';

unlink('t/test-hdb.db');

my  $ctx   = Krb5Admin::C::krb5_init_context();
our $hndl  = Krb5Admin::C::krb5_get_kadm5_hndl($ctx, 'db:t/test-hdb');
Krb5Admin::C::init_kdb($ctx, $hndl);
undef $hndl;

my $creds = 'admin_user@TEST.REALM';

my $kmdb;

my $sqlacl  = Kharon::Entitlement::SimpleSQL->new(
    table => 'krb5_admin_simple_acls');

$kmdb = Krb5Admin::KerberosDB->new(
    local	=> 1,
    client	=> $creds,
    dbname	=> 'db:t/test-hdb',
    sqlite	=> 't/sqlite.db',
    sacls	=> $sqlacl,
);

$sqlacl->set_dbh($kmdb->get_dbh());

#
# XXXrcd: This is destructive!

$kmdb->drop_db();
$kmdb->init_db();

$kmdb->add_acl($creds, 'krb5');

$kmdb->sacls_add('sacls_add', $creds);
$kmdb->sacls_add('sacls_del', $creds);
$kmdb->sacls_add('add_acl', $creds);
# $kmdb->sacls_add('bind_host', $creds);
$kmdb->sacls_add('change', $creds);
$kmdb->sacls_add('change_passwd', $creds);
$kmdb->sacls_add('create', $creds);
$kmdb->sacls_add('create_appid', $creds);
$kmdb->sacls_add('create_host', $creds);
$kmdb->sacls_add('create_user', $creds);
$kmdb->sacls_add('del_acl', $creds);
$kmdb->sacls_add('disable', $creds);
$kmdb->sacls_add('enable', $creds);
$kmdb->sacls_add('fetch', $creds);
$kmdb->sacls_add('insert_aclgroup', $creds);
$kmdb->sacls_add('insert_hostmap', $creds);
$kmdb->sacls_add('insert_ticket', $creds);
$kmdb->sacls_add('modify', $creds);
$kmdb->sacls_add('remove', $creds);
$kmdb->sacls_add('remove_aclgroup', $creds);

ok(1);

exit(0);
