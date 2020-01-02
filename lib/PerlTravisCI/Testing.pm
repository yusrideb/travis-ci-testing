package PerlTravisCI::Testing;
use Mojo::Base 'Mojolicious';

use Mojo::mysql;
use CellBIS::SQL::Abstract;

# This method will run once at server start
sub startup {
  my $self = shift;

  # Load configuration from hash returned by config file
  my $config = $self->plugin('Config');
  my $mysql_cfg
    = $ENV{TEST_ONLINE} ? $ENV{TEST_ONLINE} : $config->{mysql};

  # Set Default TimeZone
  $ENV{TZ} = $config->{timezone};

  # Helper for SQL Abstract
  $self->helper(
    sql => sub { state $sql_abstract = CellBIS::SQL::Abstract->new() });

  # Helper for MySQL
  $self->helper(
    mysql => sub {
      state $mysql = Mojo::mysql->new($mysql_cfg);
    }
  );

  # Migrate to latest version if necessary
  my $tbl_basic = $self->home->rel_file('migrations/main.sql');
  $self->mysql->migrations->name('main-db')->from_file($tbl_basic)->migrate;

  # Configure the application
  $self->secrets($config->{secrets});

  # Router
  my $r = $self->routes;

  # Normal route to controller
  $r->get('/')->to('example#welcome');
}

1;
