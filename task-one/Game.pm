use strict;
use warnings;

package Game;

use MannerDeckStudent;
use Player;

sub new {
    my $class = shift @_;

    my $object = bless {}, $class;

    return $object;
}

sub set_players {
    my $self = $_[0];
    my @player_names = @{$_[1]};

    my $num_of_players = @player_names;
    $self->{"player_names"} = \@player_names;

    if (52 % $num_of_players > 0) {
        print("Error: cards' number 52 can not be divided by players number $num_of_players!\n");
        return 0;
    }

    print("There $num_of_players players in the game:\n");
    print("@player_names \n\n");

    return 1;
}

sub getReturn {
    my $self = $_[0];
    my $card = $_[1];

    my @cards = @{$self->{"cards"}};
    my $cards_max_index = $#cards;

    # J
    if ($card eq "J" && $cards_max_index >= 1) {
        my @empty_cards = ();
        my @reversed_cards = reverse(@cards);

        $self->{"cards"} = \@empty_cards;

        return \@reversed_cards;
    }

    # other cards
    my $ret_start_index = $cards_max_index;
    for my $i (reverse(0 .. $cards_max_index - 1)) {
        if ($cards[$i] eq $card) {
            $ret_start_index = $i;
            last;
        }
    }

    my @ret = ();
    if ($cards_max_index > $ret_start_index) {
        for my $i ($ret_start_index .. $cards_max_index) {
            push(@ret, pop(@cards));
        }

        $self->{"cards"} = \@cards;
    }

    return \@ret;
}

sub get_num_of_cards {
    my $self = $_[0];

    my @cards = @{$self->{"cards"}};
    my $num_of_cards = $#cards;

    return $num_of_cards;
}

sub showCards {
    my $self = $_[0];

    my @cards = @{$self->{"cards"}};

    print("@cards\n");
}

sub start_game {
    my $self = $_[0];

    my @player_names = @{$self->{"player_names"}};
    my $num_of_players = @player_names;

    # deck
    my $deck = MannerDeckStudent->new();
    $deck->shuffle();
    my @card_groups = @{$deck->AveDealCards($num_of_players)};

    # players
    my @players = ();
    for my $i (0 .. $#player_names) {
        my @card_group = @{$card_groups[$i]};

        my $player = Player->new($player_names[$i]);
        $player->getCards(\@card_group);

        push(@players, $player);
    }

    # cards
    my @cards = ();

    $self->{"deck"} = $deck;
    $self->{"players"} = \@players;
    $self->{"cards"} = \@cards;

    print("Game begin!!!\n");

    # Game loop
    $self->loop();
}

sub loop() {
    my $self = $_[0];

    my @players = @{$self->{"players"}};
    my @player_names = @{$self->{"player_names"}};

    my $number_of_players = @players;

    my $turn = 0;
    my $turn_player_index = 0;
    while (1) {
        $turn = $turn + 1;

        my $turn_player = $players[$turn_player_index];
        my $turn_player_name = $turn_player->get_name();
        my $turn_player_num_of_cards = $turn_player->numCards();

        if ($turn_player_num_of_cards > 0) {
            $self->turn($turn_player_index);

            $turn_player_num_of_cards = $turn_player->numCards();
            if ($turn_player_num_of_cards == 0) {
                print("Player $turn_player_name has no cards, out!\n");
            }

            if (my $win_player = $self->check_win()) {
                my $win_player_name = $win_player->get_name();
                my $game = int($turn / $number_of_players + 0.5);
                print("\nWinner is $win_player_name in game $game\n");

                return;
            }
        }

        $turn_player_index = $turn_player_index + 1;
        if ($turn_player_index > $#player_names) {
            $turn_player_index = 0;
        }
    }
}

sub turn() {
    my $self = $_[0];
    my $turn = $_[1];

    my @players = @{$self->{"players"}};
    my @cards = @{$self->{"cards"}};

    my $turn_player = $players[$turn];
    my $turn_player_name = $turn_player->get_name();
    my $turn_player_num_of_cards = $turn_player->numCards();

    print("\nPlayer $turn_player_name has $turn_player_num_of_cards cards before deal.\n");

    print("=====Before player's deal=======\n");

    $self->showCards();

    print("================================\n");

    my $dealed_card = $turn_player->dealCards();
    print("$turn_player_name ==> card $dealed_card\n");

    print("=====After player's deal=======\n");

    push(@cards, $dealed_card);
    $self->{"cards"} = \@cards;

    my @returned_cards = @{$self->getReturn($dealed_card)};
    $turn_player->getCards(\@returned_cards);

    $self->showCards();

    print("================================\n");

    $turn_player_num_of_cards = $turn_player->numCards();
    print("Player $turn_player_name has $turn_player_num_of_cards cards after deal.\n");
}


sub check_win() {
    my $self = $_[0];

    my @players = @{$self->{"players"}};

    my $num_of_living_players = @players;

    # Count living players
    for my $i (0 .. $#players) {
        my $player = $players[$i];
        my $player_num_of_cards = $player->numCards();

        if ($player_num_of_cards == 0) {
            $num_of_living_players = $num_of_living_players - 1;
        }
    }

    # Get winner
    if ($num_of_living_players == 1) {
        for my $i (0 .. $#players) {
            my $player = $players[$i];
            my $player_num_of_cards = $player->numCards();

            if ($player_num_of_cards > 0) {
                return $player;
            }
        }
    }

    return 0;
}

1;