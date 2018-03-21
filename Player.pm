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

sub get_cards {
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

sub deal_card {
    my $self = shift @_;

    my @cards = @{$self->{"cards"}};
    my $card = pop(@cards);

    $self->{"cards"} = \@cards;

    return $card;
}

sub get_num_of_cards {
    my $self = shift @_;

    my @cards = @{$self->{"cards"}};
    my $numOfCards = @cards;

    return $numOfCards;
}

1;