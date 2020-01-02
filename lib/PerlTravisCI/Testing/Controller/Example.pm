package PerlTravisCI::Testing::Controller::Example;
use Mojo::Base 'Mojolicious::Controller';

use Mojo::Util 'dumper';

# This action will render a template
sub welcome {
  my $self = shift;

  my $sql = $self->app->sql;
  my $q   = $sql->select('users', [], {where => 'username = ?'});

  my $data_user = {};
  my ($username, $fullname) = 'Unknown';
  my $qsql = $self->mysql->db->query($q, 'yusrideb');
  if ($qsql->rows) {
    $data_user = $qsql->hashes;
    $username  = $data_user->to_array->[0]->{username};
    $fullname  = $data_user->to_array->[0]->{fullname};
  }

  my $content = "Current user : $username with fullname : $fullname";

  # Render template "example/welcome.html.ep" with message
  $self->render(msg => 'Welcome to the Mojolicious real-time web framework!', content_msg => $content);
}

1;
