#/∗
#∗ CSCI3180 Principles of Programming Languages
#∗
#∗ --- Declaration ---
#∗
#∗ I declare that the assignment here submitted is original except for source
#∗ material explicitly acknowledged. I also acknowledge that I am aware of
#∗ University policy and regulations on honesty in academic work, and of the
#∗ disciplinary guidelines and procedures applicable to breaches of such policy
#∗ and regulations, as contained in the website
#∗ http://www.cuhk.edu.hk/policy/academichonesty/
#∗
#∗ Assignment 3
#∗ Name : Choi Man Kin
#∗ Student ID : 1155077469
#∗ Email Addr : mkchoi6@cse.cuhk.edu.hk
#∗/

use strict;
use warnings;

package Player;

sub new {
    my $class = shift @_;

    my $name = shift @_;
    my @cards = ();
    my $object = bless { "name" => $name, "cards" => \@cards }, $class;

    return $object;
}

sub get_name {
    my $self = $_[0];

    my $name = $self->{"name"};

    return $name;
}

sub getCards {
    my $self = $_[0];
    my @cards = @{$_[1]};

    my @original_cards = @{$self->{"cards"}};

    if ($#cards > 0) {
        my @my_cards = ();

        for my $i (0 .. $#cards) {
            push(@my_cards, $cards[$#cards - $i]);
        }

        for my $i (0 .. $#original_cards) {
            push(@my_cards, $original_cards[$i]);
        }

        $self->{"cards"} = \@my_cards;
    }
}

sub dealCards {
    my $self = shift @_;

    my @cards = @{$self->{"cards"}};
    my $card = pop(@cards);

    $self->{"cards"} = \@cards;

    return $card;
}

sub numCards {
    my $self = shift @_;

    my @cards = @{$self->{"cards"}};
    my $numOfCards = @cards;

    return $numOfCards;
}

1;