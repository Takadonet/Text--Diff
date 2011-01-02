use v6;
use Test;
plan 275;
BEGIN
{
    @*INC.push('lib');
    @*INC.push('blib');
}



eval_lives_ok 'use Text::Diff', 'Can use Text::Diff';
use Text::Diff;

my @A = map {"$_\n"}, < 1 2 3 4 >;
my @B = map {"$_\n"}, < 1 2 3 5 >;

my $A = join "", @A;
my $B = join "", @B;


my $Af = "io_A";
my $Bf = "io_B";

my $fha = open("$Af", :w);
my $fhb = open("$Bf", :w);
$fha.print(@A);
$fhb.print(@B);

$fha.close();
$fhb.close();


my @tests = (
sub {
    ok !(text_diff @A, @A),'no diff';
},
sub {
     my $d = text_diff @A, @B;
     #really need to fix this ugly....
     if $d ~~ /\-4.*\+5/ {
         pass('a valid diff');
     }
     else {
         flunk('Did not find a diff');
     }
     
},
sub {
    ok !(text_diff $A, $A),'no Diff';
},
sub {
    my $d = text_diff $A, $B;
    if $d ~~ /\-4.*\+5/ {
        pass('a valid diff');
    }
    else {
        flunk('Did not find a diff');
    }
},
sub { ok !(text_diff_file $Af, $Af), 'no Diff' },
 sub {
     my $d = text_diff_file($Af, $Bf);
     if $d ~~ /\-4.*\+5/ {
         pass('a valid diff');
     }
     else {
         flunk('Did not find a diff');
     }     
 },
# sub { 
#     open A1, "<$Af" or die $!;
#     open A2, "<$Af" or die $!;
#     ok !text_diff \*A1, \*A2;
#     close A1;
#     close A2;
# },
# sub { 
#     open A, "<$Af" or die $!;
#     open B, "<$Bf" or die $!;
#     my $d = text_diff \*A, \*B;
#     $d =~ /-4.*\+5/s ? ok 1 : ok $d, "a valid diff";
#     close A;
#     close B;
# },
# sub {
#     ok !text_diff sub { \@A}, sub { \@A };
# },
# sub {
#     my $d = text_diff sub { \@A }, sub { \@B };
#     $d =~ /-4.*\+5/s ? ok 1 : ok $d, "a valid diff";
# },
);

# plan tests => scalar @tests;

$_.() for @tests;

# unlink "io_A" or warn $!;
# unlink "io_B" or warn $!;
