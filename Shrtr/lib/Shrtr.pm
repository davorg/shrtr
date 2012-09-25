package Shrtr;
use Dancer ':syntax';
use Dancer::Plugin::DBIC;

our $VERSION = '0.1';

my $url_rs = schema->resultset('Url');

get '/' => sub {
    template 'index';
};

get '/register' => sub {
    template 'register';
};

get '/submit' => sub {
    template 'submit';
};

post '/submit' => sub {
    if (my $url = param('url') and my $code = param('code')) {
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
