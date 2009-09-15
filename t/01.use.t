use Test::More tests => 12;

use WebService::SmartFM;
use Data::Dumper;

my $api = WebService::SmartFM->new(
    api_key => 'test',
);
isa_ok($api, 'WebService::SmartFM');
isa_ok($api->_smart_fm, 'WebService::Simple');

my $noblejasper = $api->get('user_profile', 'noblejasper');
check_get_profile( $noblejasper, {
    name     => 'noblejasper',
    id       => 'noblejasper',
    birthday => '1985-06-11',
    gender   => 'male',
    href     => 'http://smart.fm/users/noblejasper',
});
sub check_get_profile {
    my ( $data, $rules ) = @_;
    foreach ( keys %{ $rules } ) {
        is($data->{$_}, $rules->{$_});
    }
}

my $study_lists = $api->get('user_study_lists', 'noblejasper');
is( $study_lists->{link}, 'http://smart.fm/users/noblejasper');

my $study_items = $api->get('user_study_items', 'noblejasper');
ok( $study_items->{item} );

my $followings = $api->get('user_following', 'noblejasper');
ok( $followings );

my $followers = $api->get('user_followers', 'noblejasper');
ok( $followers );

my $recent_sentences = $api->get('recent_sentences');
ok( $recent_sentences );

# why... request to http://api.smart.fm/users/noblejasper/study_results?api_key=xxx failed
#my $study_lists = $api->get_user_study_results('noblejasper');
