# Ruby Blackjack

require 'pry'

def word_to_int(word)
  return 2 if word.include?("Two")
  return 3 if word.include?("Three")
  return 4 if word.include?("Four")
  return 5 if word.include?("Five")
  return 6 if word.include?("Six")
  return 7 if word.include?("Seven")
  return 8 if word.include?("Eight")
  return 9 if word.include?("Nine")
  return 10 if word.include?("Ten")
end

suits = %w[Hearts Spades Clubs Diamonds]
cards = %w[Ace Two Three Four Five Six Seven Eight Nine Ten Jack Queen King]
card_names = cards.product(suits)
card_names.map! { |card| card.join(" of ") }
deck = {}
card_names.each do |card|
  deck.store(card, nil )
end
deck.each do |card, value|
  if card.include?("Ace") 
    deck[card] = 1
  elsif card.include?("Jack") || card.include?("Queen") || card.include?("King")
    deck[card] = 10
  else
    deck[card] = word_to_int(card)
  end
end

FULL_DECK = deck
BLACKJACK = 21
DEALER_MUST_HIT = 17

def say(input)
  puts "=> #{input}"
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
    total -= 10 if total > BLACKJACK
  end
  total
end

def hit_or_stay(choice)
  say "What would you like to do: 'hit' or 'stay'? "
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
    say "Yours and Dealer's cards are the same, "
  end
end


def declare_winner(winner)
  if winner == 'Dealer'
    puts "Dealer Wins...Bummer"
  elsif winner == "Tie"
    puts "it's a Tie!!"
  else
    puts "You Win!!"
  end
end

def end_game(in_play)
  say "Would you like to continue? ('y', 'n')"
  in_play = gets.chomp
end

deck = new_deck(deck)

say "What's your name?"
player_name = gets.chomp.capitalize

begin
  system 'clear'
  puts "-------Welcome to BlackJack #{player_name}!!--------"
  
  in_play = nil
  
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
  print "#{puts dealer_cards[0]}" 
  puts "Dealer Showing: #{card_total(dealer_cards) - FULL_DECK[dealer_cards[1]]}"
  say "#{player_name}'s Hand:" 
  print "#{puts player_cards}"
  puts "#{player_name}'s Total: #{card_total(player_cards)}"

  choice = hit_or_stay(choice)

  while choice == 'hit'
    deal_card(deck, player_cards)
    say "You were dealt a:" 
    puts "#{puts player_cards.last}" 
    say "Your hand:" 
    print "#{puts player_cards}" 
    say "Your Total: #{card_total(player_cards)}"
    if card_total(player_cards) > BLACKJACK
      winner('Dealer', "#{player_name}", 'bust')
      declare_winner('Dealer')
      in_play = end_game(in_play)
      break
    elsif card_total(player_cards) == BLACKJACK
      winner("#{player_name}", 'Dealer', blackjack)
      declare_winner("#{player_name}")
      in_play = end_game(in_play)
      break
    end
    choice = hit_or_stay(choice)
  end 



  say "Dealer flipped a #{dealer_cards[1]}"
  puts "Dealer's Total: #{card_total(dealer_cards)}"
   
  while card_total(dealer_cards) < DEALER_MUST_HIT && in_play != 'y'
    deal_card(deck, dealer_cards)
    say "Dealer hits" 
    say "Dealer's Current Hand:" 
    print "#{puts dealer_cards}"
    puts "Dealers total: #{card_total(dealer_cards)}"
    sleep 2
  end
  if card_total(dealer_cards) > BLACKJACK && in_play != 'y'
    winner("#{player_name}", 'Dealer', 'bust')
    declare_winner("#{player_name}")
     in_play = end_game(in_play)
  elsif card_total(dealer_cards) == BLACKJACK && in_play != 'y'
     winner('Dealer', "#{player_name}", 'blackjack')
     declare_winner('Dealer')
    in_play = end_game(in_play)
  elsif card_total(player_cards) > card_total(dealer_cards) && in_play != 'y'
    winner("#{player_name}", 'Dealer', 'better_cards')
    declare_winner("#{player_name}")
    in_play = end_game(in_play)
  elsif card_total(player_cards) < card_total(dealer_cards) && in_play != 'y'
    winner('Dealer', "#{player_name}", 'better_cards')
    declare_winner('Dealer')
    in_play = end_game(in_play)
  elsif card_total(player_cards) == card_total(dealer_cards) && in_play != 'y'
    winner('Tie', 'Tie', 'same_cards')
    declare_winner('Tie') 
    in_play = end_game(in_play)
  end
end while in_play == 'y'
