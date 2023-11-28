#!/usr/bin/perl

use strict;
use warnings;

use Bot::IRC;
use YouTube::Util;

use HTML::Entities;
use LWP::UserAgent;
use JSON;

my $gapi = "API_KEY";

my $bot = Bot::IRC->new(
    spawn   => 2,
    daemon  => {},
    connect => {
        server => 'irc.libera.chat',
        port   => '6667',
        nick   => 'dona_cuca',
        name   => 'Dona Cuca Bot',
        join   => [ "#unitedbymetal", "##metal" ],
        ssl    => 0,
        ipv6   => 0,
    },
    plugins => [
        ':core',
	'UriTitle',
	'Store'
    ],
    vars => {
        store => 'bot.yaml',
    },
);

# Query youtube to get video title
sub youtube_query {
    my $url = shift;

    my $ua = LWP::UserAgent->new(ssl_opts => { verify_hostname => 1 });
    $ua->agent("Emacs/29.1");

    my $res = $ua->get($url);
    # print "HTTP status: ", $res->code();
    my $content_json = decode_json($res->content);

    my $output = "";

    #If no video found
    if ($content_json->{pageInfo}->{totalResults} == 0) {
        $output = "Video not found.";
	} 
    else { #Video found, set the title as output
        $output = $content_json->{items}[0]->{snippet}->{title};
    }
    $output;
}

$bot->hook(
    {
        to_me => 0,
	text => qr/^((?:https?:)?\/\/)?((?:www|m)\.)?((?:youtube(-nocookie)?\.com|youtu.be))(\/(?:[\w\-]+\?v=|embed\/|live\/|v\/)?)([\w\-]+)(\S+)?$/,
    },
    sub {
        my ( $bot, $in, $m ) = @_;
	my $id = YouTube::Util::extract_youtube_video_id("$in->{text}");
	print $id . "\n";
	my $query = join('',"https://www.googleapis.com/youtube/v3/videos?key=", $gapi,"&part=snippet&id=",$id);
	$bot->reply("[ YT Title: " . youtube_query($query) . " ]");
    },
    {
        subs  => [],
        helps => [],
    },
);

$bot->run();
