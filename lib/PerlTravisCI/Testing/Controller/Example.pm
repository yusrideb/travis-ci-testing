package PerlTravisCI::Testing::Controller::Example;
use Mojo::Base 'Mojolicious::Controller';

use Mojo::Util 'dumper';

# This action will render a template
sub welcome {
  my $self = shift;

  my $sql = $self->app->sql;
  my $q   = $sql->select('users', [], {where => 'username = ?'});

  my $data_user_mysql = {};
  my $data_user_pg = {};
  my ($username_mysql, $fullname_mysql) = 'Unknown';
  my ($username_pg, $fullname_pg) = 'Unknown';
  my $r_mysql = $self->mysql->db->query($q, 'yusrideb');
  if ($r_mysql->rows) {
    $data_user_mysql = $r_mysql->hashes;
    $username_mysql  = $data_user_mysql->to_array->[0]->{username};
    $fullname_mysql  = $data_user_mysql->to_array->[0]->{fullname};
  }
  my $r_pg = $self->pg->db->query($q, 'yusrideb');
  if ($r_pg->rows) {
    $data_user_pg = $r_pg->hashes;
    $username_pg  = $data_user_pg->to_array->[0]->{username};
    $fullname_pg  = $data_user_pg->to_array->[0]->{fullname};
  }

  my $content_mysql = "Example from MariaDB - user : $username_mysql with fullname : $fullname_mysql";
  my $content_pg = "Example from PostgreSQL - user : $username_pg with fullname : $fullname_pg";

  # Render template "example/welcome.html.ep" with message
  $self->render(msg => 'Welcome to the Mojolicious real-time web framework!', content_mysql => $content_mysql, content_pg => $content_pg);
}

1;
