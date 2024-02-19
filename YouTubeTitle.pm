package Bot::IRC::X::YouTubeTitle;
# ABSTRACT: Bot::IRC plugin to parse and print URI titles from YouTube videos

use strict;
use warnings;

use v5.36;
use exact;

use Bot::IRC;
use YouTube::Util;

use HTML::Entities;
use LWP::UserAgent;
use JSON;

our $VERSION = '0.1'; # VERSION

my $gapi = $ENV{GAPI};

# Query youtube to get video title
sub youtube_query {
    my $url = shift;

    my $ua = LWP::UserAgent->new(ssl_opts => { verify_hostname => 1 });
    $ua->agent("Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.0; Trident/5.0; Trident/5.0)");

    my $res = $ua->get($url);
    # print "HTTP status: ", $res->code();
    my $content_json = decode_json($res->content);

    my $output = "";

    #If no video found
    if ($content_json->{pageInfo}->{totalResults} == 0) {
        $output = "Video not found.";
	} 
    else { #Video found, set the title as output
        $output = "YouTube Title: " . $content_json->{items}[0]->{snippet}->{title} . " Uploader: " . $content_json->{items}[0]->{snippet}->{channelTitle};
    }
    $output;
}

sub init {
  my ($bot) = @_;
  $bot->hook(
      {
	  to_me => 0,
	  text => qr/^((?:https?:)?\/\/)?((?:www|m)\.)?((?:youtube(-nocookie)?\.com|youtu.be))(\/(?:[\w\-]+\?v=|embed\/|live\/|v\/)?)([\w\-]+)(\S+)?$/,
      },
      sub {
	  my ( $bot, $in, $m ) = @_;
	  my $id = YouTube::Util::extract_youtube_video_id("$in->{text}");
	  my $query = join('',"https://www.googleapis.com/youtube/v3/videos?key=", $gapi,"&part=snippet&id=",$id);
	  $bot->reply("[ " . youtube_query($query) . " ]");
      },
      {
	  subs  => [],
	  helps => [],
      },
  );
}

1;
