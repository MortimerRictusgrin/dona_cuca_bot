package Bot::IRC::X::Weather;
# ABSTRACT: Bot::IRC plugin to get the weather for a specific location

use strict;
use warnings;

use v5.36;
use exact;

use LWP::UserAgent;

use Bot::IRC;

use Data::Dumper;

our $VERSION = "0.1";

my $ua = LWP::UserAgent->new(ssl_opts => { verify_hostname => 1 });
$ua->agent("Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.0; Trident/5.0; Trident/5.0)");

sub init {
    my ($bot) = @_;
    $bot->hook(
	{
	    to_me => 1,
	    text  => qr/\b(?<word>weather|[l1][e3]{2}[t7])\b/i,
	},
	sub {
	    my ( $bot, $in, $m ) = @_;
            my ($country) = $in->{full_text} =~ /(\S+$)/;
	    # it will match the exact last word including symbol
	    # so you can pass something like Guatemala+City to get a more accurate result
	    my $req = HTTP::Request->new(GET => "https://wttr.in/$country?format=%l:+%t+%C+%c");
	    $req->header('Accept' => 'text/html');
	    chomp(my $res = $ua->request($req));
	    if ($res->is_success) {
		$bot->reply($res->decoded_content);
	    }
	    else {
		$bot->reply("Sorry, I'm unable to get the weather report for $country.");
	    }
	},
    );

    $bot->helps( weather => 'Tells the weather for a location in the format: El+Salvador, Guatemala_City, Lisbon... etc, get the weather for a geographical location other than a town or city with: ~Eiffel+Tower' );
}

1;
