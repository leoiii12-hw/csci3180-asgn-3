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
    print("@player_names\n\n");

    return 1;
}

sub get_return {
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

sub show_cards {
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
    my @card_groups = @{$deck->divide_cards($num_of_players)};

    # players
    my @players = ();
    for my $i (0 .. $#player_names) {
        my @card_group = @{$card_groups[$i]};

        my $player = Player->new($player_names[$i]);
        $player->get_cards(\@card_group);

        push(@players, $player);
    }

    # cards
    my @cards = ();

    $self->{"deck"} = $deck;
    $self->{"players"} = \@players;
    $self->{"cards"} = \@cards;

    print("Game begin!!!\n\n");

    # Game loop
    $self->loop();
}

sub loop() {
    my $self = $_[0];

    my @players = @{$self->{"players"}};
    my @player_names = @{$self->{"player_names"}};

    my $number_of_players = @players;

    my $turn = 0;
    my $turnPlayerIndex = 0;
    while (1) {
        $turn = $turn + 1;

        my $turnPlayer = $players[$turnPlayerIndex];
        my $turnPlayerNumOfCards = $turnPlayer->get_num_of_cards();

        if ($turnPlayerNumOfCards > 0) {
            $self->turn($turnPlayerIndex);
        }

        if (my $win_player = $self->check_win()) {
            my $win_player_name = $win_player->get_name();
            my $game = int($turn / $number_of_players + 0.5);
            print("Winner is $win_player_name in game $game\n");

            return;
        }

        $turnPlayerIndex = $turnPlayerIndex + 1;
        if ($turnPlayerIndex > $#player_names) {
            $turnPlayerIndex = 0;
        }
    }
}

sub turn() {
    my $self = $_[0];
    my $turn = $_[1];

    my @players = @{$self->{"players"}};
    my @cards = @{$self->{"cards"}};

    my $turnPlayer = $players[$turn];
    my $turnPlayerName = $turnPlayer->get_name();
    my $turnPlayerNumOfCards = $turnPlayer->get_num_of_cards();

    print("Player $turnPlayerName has $turnPlayerNumOfCards cards before deal.\n");

    print("=====Before player's deal=======\n");

    $self->show_cards();

    print("================================\n");

    my $dealed_card = $turnPlayer->deal_card();
    print("$turnPlayerName ===> card $dealed_card\n");

    print("=====After player's deal=======\n");

    push(@cards, $dealed_card);
    $self->{"cards"} = \@cards;

    my @returned_cards = @{$self->get_return($dealed_card)};
    $turnPlayer->get_cards(\@returned_cards);

    $self->show_cards();

    print("================================\n");

    $turnPlayerNumOfCards = $turnPlayer->get_num_of_cards();
    print("Player $turnPlayerName has $turnPlayerNumOfCards cards after deal.\n\n");
}


sub check_win() {
    my $self = $_[0];

    my @players = @{$self->{"players"}};

    my $num_of_living_players = @players;

    for my $i (0 .. $#players) {
        my $player = $players[$i];
        my $playerNumOfCards = $player->get_num_of_cards();

        if ($playerNumOfCards == 0) {
            $num_of_living_players = $num_of_living_players - 1;
        }
    }

    if ($num_of_living_players == 1) {
        for my $i (0 .. $#players) {
            my $player = $players[$i];
            my $playerNumOfCards = $player->get_num_of_cards();

            if ($playerNumOfCards > 0) {
                return $player;
            }
        }
    }

    return 0;
}

1;