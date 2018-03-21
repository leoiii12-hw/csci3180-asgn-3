use strict;
use warnings;

package Deck;

sub new {
    my $class = shift @_;

    my @cards = ("3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A", "2");
    @cards = (@cards, @cards, @cards, @cards);
    my $object = bless { "cards" => \@cards }, $class;

    return $object;
}

sub shuffle {
    my $self = shift @_;

    my $cards = $self->{"cards"};
    for my $i (1 .. $#$cards) {
        my $j = int rand($i + 1);
        @$cards[$j, $i] = @$cards[$i, $j];
    }
}

sub divide_cards {
    my $self = shift @_;
    my $num = shift @_;

    my @cards = @{$self->{"cards"}};

    my $cards_num = @cards;
    $cards_num /= $num;

    my @ret = ();
    for my $n (1 .. $num) {
        my @cur = @cards[($n - 1) * $cards_num .. $n * $cards_num - 1];
        push @ret, \@cur;
    }

    return \@ret;
}


1;