
use strict;
use Data::Dumper;

use WWW::Mechanize;


my $site = "http://www.flickr.com/photos/prismoperfect/";#"http://www.flickr.com/photos/manannan_alias_fanch/";    
my $img_link =  'photostream';
my $size = 'z'; # s m z l o 

my $mech = WWW::Mechanize->new();
# Mouah ah ah !
$mech->agent_alias( 'Windows IE 6' );

$mech->get($site);
#print Dumper($mech->uri());
get_image_on_current_page();

$mech->get($site);
#print Dumper($mech->uri());
#print Dumper($mech->find_all_links( class=>"Next"));
while(my$lnk = $mech->find_link( class=>"Next")) {
    print "Page => ".$lnk->url."\n";
   $mech->get($lnk); 
#   print Dumper($mech->uri);
   get_image_on_current_page();
   $mech->get($lnk); 
}



sub get_image_on_current_page {
    #print Dumper($mech->find_all_links( url_regex => qr/$img_link/));
    foreach my $link ($mech->find_all_links( url_regex => qr/$img_link/)) {
	my $img_url = $link->url();
	
	# Recupération de l'id de l'image
	my @backtab = split ('/', $img_url);
	my $img_id = $backtab[3]; 
	$backtab[4] = 'sizes';
	$backtab[5] = $size;
	
	print "\tImage : $img_url $img_id\n";

	my $new_img_url = join('/',@backtab[0..5]).'/';
	print "\tGo to : $new_img_url\n";
	
	$mech->get("$new_img_url");
	
	#    print Dumper($mech->find_all_images(url_regex => qr/jpg/i));
	my $img_lnk = $mech->find_image(url_regex => qr/jpg/i );
	print "\tFind : ".$img_lnk->url."\n";
	# Mouah ! 
	system ('wget -q '.$img_lnk->url());     
	
	#    print Dumper($mech->uri());
    }
}
