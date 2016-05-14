module Codebreaker
# Handles game API
  class Index
    def initialize
      @game = Game.new
    end

    def start
      if @game.name.empty?
        puts 'Enter your name:'.green
        @game.name = gets.chomp
      end
      puts "Enter #{Game::CODE_SIZE} numbers.".green +
               " Each num should be in range #{Game::NUM_RANGE}.".green
      guess_num = gets.chomp
      start unless @game.compare_input(guess_num)
      @game = Game.new
      start
    end
  end
end
Codebreaker::Index.new.start
