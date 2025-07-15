package Shrtr;
use Dancer2;
use Dancer2::Plugin::DBIC;
use Dancer2::Plugin::Passphrase;

our $VERSION = '0.1';

my %private = map { $_ => 1 } qw[/submit];

hook before => sub {
    var url_rs  => schema->resultset('Url');
    var user_rs => schema->resultset('User');

    if ($private{request->path_info} and !session('user')) {
        forward '/login', {
            goto => request->path_info,
        };
    }
};

hook before_template_render => sub {
    my $tokens = shift;
    $tokens->{user} = session('user');
    $tokens->{version} = $VERSION;
    $tokens->{appname} = config->{appname};
};

get '/' => sub {
    my $user = session('user');
    if (defined $user) {
        debug("Logged in as $user\n");
        my $url_rs = var 'url_rs';
        my @urls = $url_rs->all;
        template 'urls', { urls => \@urls };
    } else {
        debug("Not logged in\n");
        template 'index';
    }
};

get '/register' => sub {
    my $error = session('error');
    session 'error' => undef;
    template 'register', {
        error => $error,
    };
};

post '/register' => sub {
    session 'username' => param('username');
    session 'email' => param('email');
    unless (param('username') and param('email')
        and param('password') and param('password2')) {

        session 'error' => 'You must fill in all values';
        return redirect '/register';
    }
    
    unless (param('password') eq param('password2')) {
        session 'error' => 'Password values are not the same';
        return redirect '/register';
    }
    
    my $user_rs = var 'user_rs';

    if (my $user = $user_rs->find({ username => param('username') })) {
        session 'error' => 'Username ' . $user->username .
            ' is already in use.';
        return redirect '/register';
    }
    
    my $user = $user_rs->create({
        username => param('username'),
        email => param('email'),
        password => passphrase(param('password'))->generate->rfc2307,
    });
    
    template 'registered', { user => $user };
};

get '/login' => sub {
    my $error = session('error');
    session 'error' => undef;
    template 'login', { goto => params->{goto}, error => $error };
};

post '/login' => sub {
    session 'user' => undef;
    session 'username' => params->{username};
    unless (params->{username} and params->{pass}) {
        session 'error' => 'Must give both username and password';
        return redirect '/login';
    }
    
    my $user_rs = var 'user_rs';
    my $user = $user_rs->find({ username => params->{username} });
    unless ($user) {
        session 'error' => 'Invalid username or password';
        return redirect '/login';
    }
    
    unless (passphrase(params->{pass})->matches($user->password)) {
        session 'error' => 'Invalid username or password';
        return redirect '/login';
    }
    
    session 'user' => $user->username;
    
    if (my $goto = params->{goto}) {
        redirect $goto;
    } else {
        redirect '/';
    }
};

get '/logout' => sub {
    session 'user' => undef;
    redirect '/';    
};

get '/submit' => sub {
    template 'submit';
};

post '/submit' => sub {
    if (my $url = param('url') and my $code = param('code')) {
        unless ($url =~ m[^https?://]) {
            $url = "https://$url";
        }

        my $url_rs = var 'url_rs';

        my $new_url = $url_rs->create({
            url => $url,
            code => $code,
        });
        
        my $user = session('user');
        if ($user) {
            my $user_rs = var 'user_rs';
            my $user_obj = $user_rs->find({ username => $user });
            $new_url->add_to_users($user_obj);
        }

        template 'saved', { url => $new_url };
    }
};

get qr{ /(\w+)\+ }x => sub {
    my ($code) = splat;
    
    my $url_rs = var 'url_rs';

    if (my $url = $url_rs->find({code => $code})) {
        template 'url', { url => $url };
    }
};

get qr{ /(\w+) }x => sub {
    my ($code) = splat;

    my $url_rs = var 'url_rs';

    if (my $url = $url_rs->find({code => $code})) {
        my $req = request;
        $url->add_to_clicks({
            user_agent => $req->user_agent,
            referrer   => $req->referer,
            ip_address => $req->remote_address,
        });
        template 'frame', {
            url => $url,
        }, {
            layout => undef,
        };
    }
};

sub debug {
  return unless $ENV{SHRTR_DEBUG};
  goto &CORE::warn;
}

true;
