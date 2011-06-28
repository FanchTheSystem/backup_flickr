
use strict;
use Data::Dumper;

use WWW::Mechanize;


my $cpt = 1;    
my $site = "http://www.flickr.com/photos/manannan_alias_fanch/";    
my $img_link = '/photos/manannan_alias_fanch/';
my $img_tag = "img";

my $mech = WWW::Mechanize->new();
$mech->agent_alias( 'Windows IE 6' );


$mech->get($site);
print Dumper($mech->uri());


#print Dumper($mech->find_link( tag => $img_tag));
#print Dumper($mech->find_all_links( url_regex => qr/$img_link/i));
my $id_list;

while ($cpt <= 88) {
    
    foreach my $link ($mech->find_all_links( url_regex => qr/$img_link/i)) {
	my $new_img = $link->url();
	my $img_id = substr($new_img, length($img_link), length($new_img) - length($img_link) - 1);
	if ($id_list->{$img_id} != 1) {
	    $id_list->{$img_id} = 1;
	    
	    if ($img_id =~ m/\D/g) {
		print "$new_img => skipped\n";
	    }
	    else {
		print "$new_img => $new_img/sizes/o/\n";
		$mech->get("$new_img/sizes/o/");
		if ($mech->status() == 200) {
		    my $img_lnk = $mech->find_link( url_regex => qr/jpg/i );
		    print Dumper($img_lnk->url());
		    system ('cd photos; wget -q '.$img_lnk->url());     
		}
	    }
	}
    }

    $cpt++;
    $mech->get($site."/page$cpt/");
    print Dumper($mech->uri());
}






