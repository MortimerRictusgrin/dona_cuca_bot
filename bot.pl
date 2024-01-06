#!/usr/local/bin/perl

use strict;
use warnings;

use Bot::IRC;

my $channels = [ "#unitedbymetal" ];

my $bot = Bot::IRC->new(
    spawn   => 2,
    daemon  => {},
    connect => {
        server => 'irc.libera.chat',
        port   => '6667',
        nick   => 'dona_cuca_bot',
        name   => 'Dona Cuca Bot',
        join   => $channels,
        ssl    => 0,
        ipv6   => 0,
    },
    plugins => [
	# 'UriTitle',
	# 'YouTubeTitle',
	'Weather',
	'Infobot',
	'Functions',
	'Convert',
	'Karma',
	'Math',
	'History',
	'Seen',
	'Store'
     ],
    vars    => { store => 'bot.yaml' },
);

$bot->hook(
    {
        to_me => 1,
        text  => qr/\b(?<word>police|[l1][e3]{2}[t7])\b/i,
    },
    sub {
        my ( $bot, $in, $m ) = @_;
        $bot->reply("Fuck the $m->{word}?...");
    },
);

$bot->hook(
    {
        to_me => 1,
        text  => qr/\b(?<word>semarus|[l1][e3]{2}[t7])\b/i,
    },
    sub {
        my ( $bot, $in, $m ) = @_;
        $bot->reply("Quick, hide the drugs...");
    },
);

$bot->hook(
    {
        to_me => 1,
        text  => qr/\b(?<word>source code|[l1][e3]{2}[t7])\b/i,
    },
    sub {
        my ( $bot, $in, $m ) = @_;
        $bot->reply("https://github.com/MortimerRictusgrin/dona_cuca_bot");
    },
    {
        helps => [ source => 'Provides a link to the source code of the bot.'],
    },
);

$bot->hook(
    {
        to_me => 1,
        text  => qr/\b(?<word>sing|[l1][e3]{2}[t7])\b/i,
    },
    sub {
        my ( $bot, $in, $m ) = @_;
        $bot->reply("I'm gonna put on an iron shirt, and chase the facist out of Earth");
    },
);

$bot->run();
