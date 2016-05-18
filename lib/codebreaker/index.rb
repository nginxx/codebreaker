module Codebreaker
# Starts game
  class Index
    def initialize
      @game = Game.new
    end

    def start
      ask_name
      start unless @game.compare_input(ask_number)
      @game = Game.new
      start
    end

    private

    def ask_name
      if @game.name.empty?
        puts 'Enter your name:'.green
        name = gets.chomp
        unless @game.validate('name', name)
          puts 'Enter valid name !'.red
          start
        end
        @game.name = name
      end
    end

    def ask_number
      puts "Enter #{Game::CODE_SIZE} numbers.".green +
               " Each num should be in range #{Game::NUM_RANGE}.".green +
               '(type hint to get one random number from code.)'
      guess_num = gets.chomp
      if guess_num == 'hint'
        @game.make_hint
        start
      end
      unless @game.validate('number', guess_num)
        puts 'Enter valid number !'.red
        start
      end
      guess_num
    end
  end
end
