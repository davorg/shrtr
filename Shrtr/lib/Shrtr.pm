package Shrtr;
use Dancer ':syntax';
use Dancer::Plugin::DBIC;

our $VERSION = '0.1';

my $url_rs = schema->resultset('Url');

get '/' => sub {
    template 'index';
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
        $url->add_to_clicks({});
        template 'frame', {
            url => $url,
        }, {
            layout => undef,
        }
    };
};

true;
