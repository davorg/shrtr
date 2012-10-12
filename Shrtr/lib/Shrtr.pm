package Shrtr;
use Dancer ':syntax';
use Dancer::Plugin::DBIC;
use Dancer::Plugin::Passphrase;

our $VERSION = '0.1';

my $url_rs = schema->resultset('Url');
my $user_rs = schema->resultset('User');

my %private = map { $_ => 1 } qw[/submit];

hook before => sub {
    if ($private{request->path_info} and ! session('user')) {
        session 'goto' => request->path_info;
        request->path_info('/login');
    }
};

hook before_template => sub {
    my $params = shift;
    $params->{user} = session('user');  
};

get '/' => sub {
    template 'index';
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
    
    if (my $user = $user_rs->single({
        username => param('username'),
    })) {
        session 'error' => 'Username ' . $user->username .
            ' is already in use.';
        return redirect '/register';
    }
    
    my $user = $user_rs->create({
        username => param('username'),
        email => param('email'),
        password => passphrase(param('password'))->generate_hash,
    });
    
    template 'registered', { user => $user };
};

get '/login' => sub {
    my $error = session('error');
    session 'error' => undef;
    template 'login', { error => $error };
};

post '/login' => sub {
    session 'user' => undef;
    session 'username' => params->{username};
    unless (params->{username} and params->{pass}) {
        session 'error' => 'Must give both username and password';
        return redirect '/login';
    }
    
    my $user = $user_rs->single({
        username => params->{username},
    });
    unless ($user) {
        session 'error' => 'Invalid username or password';
        return redirect '/login';
    }
    
    unless (passphrase(params->{pass})->matches($user->password)) {
        session 'error' => 'Invalid username or password';
        return redirect '/login';
    }
    
    session 'user' => $user->username;
    
    if (my $goto = session('goto')) {
        session 'goto' => undef;
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
            $url = "http://$url";
        }
        
        my $new_url = $url_rs->create({
            url => $url,
            code => $code,
        });
        
        template 'saved', { url => $new_url };
    }
};

get qr{ /(\w+)\+ }x => sub {
    my ($code) = splat;
    
    if (my $url = $url_rs->find({code => $code})) {
    
        template 'url', {
            url  => $url,
        };
    }
};

get qr{ /(\w+) }x => sub {
    my ($code) = splat;
    
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
        }
    };
};

true;
