package PerlTravisCI::Testing;
use Mojo::Base 'Mojolicious';

use Mojo::mysql;
use Mojo::Pg;
use CellBIS::SQL::Abstract;

# This method will run once at server start
sub startup {
  my $self = shift;

  # Load configuration from hash returned by config file
  my $config = $self->plugin('Config');
  my $mysql_cfg
    = $ENV{TEST_ONLINE_mysql} ? $ENV{TEST_ONLINE_mysql} : $config->{mysql};
  my $pg_cfg
    = $ENV{TEST_ONLINE_pg} ? $ENV{TEST_ONLINE_pg} : $config->{pg};

  # Set Default TimeZone
  $ENV{TZ} = $config->{timezone};

  # Helper for SQL Abstract
  $self->helper(
    sql => sub { state $sql_abstract = CellBIS::SQL::Abstract->new() });

  # Helper for database
  $self->helper(
    mysql => sub {
      state $mysql = Mojo::mysql->new($mysql_cfg);
    }
  );
  $self->helper(
    pg => sub {
      state $pg = Mojo::Pg->new($pg_cfg);
    }
  );

  # Migrate to latest version if necessary
  my $tbl_basic = $self->home->rel_file('migrations/main.sql');
  my $tbl_basic_pg = $self->home->rel_file('migrations/main-postgre.sql');
  $self->mysql->migrations->name('main-db')->from_file($tbl_basic)->migrate;
  $self->pg->migrations->name('main-postgre-db')->from_file($tbl_basic_pg)->migrate;

  # Configure the application
  $self->secrets($config->{secrets});

  # Router
  my $r = $self->routes;

  # Normal route to controller
  $r->get('/')->to('example#welcome');
}

1;
