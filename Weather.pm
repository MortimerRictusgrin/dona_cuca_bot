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
	    my $req = HTTP::Request->new(GET => "https://wttr.in/$country?format='%l:+%C+%t'");
	    $req->header('Accept' => 'text/html');
	    chomp(my $res = $ua->request($req));
	    if ($res->is_success) {
		$bot->reply($res->decoded_content);
	    }
	    else {
		$bot->reply("Sorry, I'm unable to get the weather report for $country.");
	    }
	},
	{
	    subs  => [],
	    helps => [],
	},
    );
}

1;
