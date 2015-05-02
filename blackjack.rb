# Ruby Blackjack

require 'pry'

FULL_DECK = {"Ace of Hearts" => 1, "Ace of Spades" => 1, "Ace of Clubs" => 1, "Ace of Diamonds" => 1, 
"Two of Hearts" => 2, "Two of Spades" => 2, "Two of Clubs" => 2, "Two of Diamonds" => 2,
"Three of Hearts" => 3, "Three of Spades" => 3, "Three of Clubs" => 3, "Three of Diamonds" => 3,
"Four of Hearts" => 4, "Four of Spades" => 4, "Four of Clubs" => 4, "Four of Diamonds" => 4,
"Five of Hearts" => 5, "Five of Spades" => 5, "Five of Clubs" => 5, "Five of Diamonds" => 5,
"Six of Hearts" => 6, "Six of Spades" => 6, "Six of Clubs" => 6, "Six of Diamonds" => 6,
"Seven of Hearts" => 7, "Seven of Spades" => 7, "Seven of Clubs" => 7, "Seven of Diamonds" => 7,
"Eight of Hearts" => 8, "Eight of Spades" => 8, "Eight of Clubs" => 8, "Eight of Diamonds" => 8,
"Nine of Hearts" => 9, "Nine of Spades" => 9, "Nine of Clubs" => 9, "Nine of Diamonds" => 9,
"Ten of Hearts" => 10, "Ten of Spades" => 10, "Ten of Clubs" => 10, "Ten of Diamonds" => 10,
"Jack of Hearts" => 10, "Jack of Spades" => 10, "Jack of Clubs" => 10, "Jack of Diamonds" => 10,
"Queen of Hearts" => 10, "Queen of Spades" => 10, "Queen of Clubs" => 10, "Queen of Diamonds" => 10,
"King of Hearts" => 10, "King of Spades" => 10, "King of Clubs" => 10, "King of Diamonds" => 10 }

def say(input)
  puts "=> " + input
end

def new_deck(deck)
  FULL_DECK.keys.shuffle
end

def deal_card(deck, holder)
  holder << deck.shift
end

def card_total(holders_cards)
  total = 0
  holders_cards.each { |card| total += FULL_DECK[card] }
  if holders_cards.any? { |card| card.include?("Ace") }
    total += 10
    total -= 10 if total > 21
  end
  total
end

def hit_or_stay(choice)
  say "What would you like to do?"
  choice = gets.chomp
  until choice == 'stay' || choice == 'hit'
    say "You need to either enter: 'hit' or 'stay'"
    choice = gets.chomp.downcase
  end
  choice
end

def winner(winner, loser, type_of_win)
  if type_of_win == 'bust'
    say "#{loser.capitalize} busts, "
  elsif type_of_win == 'blackjack'
    say "#{winner.capitalize} has Blackjack!! "
  elsif type_of_win == 'better_cards'
    say "#{winner.capitalize}'s cards are better, "
  else
    say "#{player_name}'s and Dealer's cards are the same, "
  end

  if winner == 'Dealer'
    puts "Dealer Wins...Bummer"
  elsif winner == '#{player_name}'
    puts "You Win!!"
  else
    puts "it's a Tie!!"
  end
end

def end_game(in_play)
  say "Would you like to continue? ('y', 'n')"
  in_play = gets.chomp
end

def in_play?(in_play)
  if in_play != 'y'
    true
  else
    false
  end
end

deck = new_deck(deck)

puts "-------Welcome to BlackJack!!--------"

say "What's your name?"
player_name = gets.chomp.capitalize

begin

  in_play = 'y'
  
  if deck.length < 26
    deck = new_deck(deck)
  end

  player_cards = []
  dealer_cards = []
  
  begin
    deal_card(deck, player_cards)
    deal_card(deck, dealer_cards)
  end until player_cards.length == 2 && dealer_cards.length == 2

  say "Dealer's Hand:"
  print "#{puts dealer_cards}" 
  puts "Dealer Total: #{card_total(dealer_cards)}"
  say "#{player_name}'s Hand:" 
  print "#{puts player_cards}"
  puts "#{player_name}'s Total: #{card_total(player_cards)}"

  if card_total(player_cards) == 21
    winner("#{player_name}", 'Dealer', 'blackjack')
    in_play = end_game(in_play)
  end


  while card_total(player_cards) < 21
    choice = hit_or_stay(choice)
    
    if choice == 'stay'
      break
    end
    
    if choice == 'hit'
      deal_card(deck, player_cards)
      say "You were dealt a:" 
      puts "#{puts player_cards.last}" 
      say "Your hand:" 
      print "#{puts player_cards}" 
      say "Your Total: #{card_total(player_cards)}"
      if card_total(player_cards) > 21
        winner('Dealer', "#{player_name}", 'bust')
        in_play = end_game(in_play)
      end
    end
  end
  
  while card_total(dealer_cards) < 17 && in_play == 'y'
    deal_card(deck, dealer_cards)
    say "Dealer hits" 
    say "Dealer's Current Hand:" 
    print "#{puts dealer_cards}"
    puts "Dealers total: #{card_total(dealer_cards)}"
    sleep 2
  end
  if card_total(dealer_cards) > 21 && in_play == 'y'
    winner("#{player_name}", 'Dealer', 'bust')
     in_play = end_game(in_play)
  elsif card_total(dealer_cards) == 21 && in_play == 'y'
     winner('Dealer', "#{player_name}", 'blackjack')
    in_play = end_game(in_play)
  elsif card_total(player_cards) > card_total(dealer_cards) && in_play == 'y'
    winner("#{player_name}", 'Dealer', 'better_cards')
    in_play = end_game(in_play)
  elsif card_total(player_cards) < card_total(dealer_cards) && in_play == 'y'
    winner('Dealer', "#{player_name}", 'better_cards')
    in_play = end_game(in_play)
  elsif card_total(player_cards) == card_total(dealer_cards) && in_play == 'y'
    winner('Tie', 'Tie', 'same_cards') 
    in_play = end_game(in_play)
  end
end until in_play != 'y'
