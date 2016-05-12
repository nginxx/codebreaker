module Codebreaker
  # Logic game
  class Game
    HINTS = 3
    ATTEMPTS = 10
    CODE_SIZE = 4
    NUM_RANGE = 1..6

    def initialize
      @secret_code = code_generator
    end

    def start
      puts "Enter #{CODE_SIZE} numbers.".green +
               " Each num should be in range #{NUM_RANGE}.".green
      guess_num = gets.chomp
      validate_guess_num(guess_num)
      compare_input(guess_num)
    end

    private

    def code_generator
      code = []
      CODE_SIZE.times { code << rand(NUM_RANGE) }
      code.join
    end

    def validate_guess_num(num)
      if num.length != CODE_SIZE || !num.match(/[1-6]+/)
        raise "Should be #{CODE_SIZE} nums, each num between #{NUM_RANGE}".red
      end
    rescue => e
      puts e.message
      start
    end

    def compare_input(num)
      if num == @secret_code
        puts 'Congratulations!!! You won the game. '.yellow +
                 "The code was #{num}.".yellow
      else
        puts 'Try again. ' + match_position(num)
        start
      end
    end

    def match_position(num)
      code = @secret_code.chars
      num = num.chars
      guess = num.map.with_index do |item, index|
        next if item != code[index]
        code[index] = nil
        '+'
      end
      num.each do |item|
        next unless code.include?(item)
        guess << '-'
        code.delete_at(code.index(item))
      end
      guess.join
    end
  end
end
puts 'Ready for challenge ? (type yes/no)'
start_game = gets.chomp
if start_game == 'yes'
  puts 'Let\'s start!!!'
  Codebreaker::Game.new.start
else
  exec('exit')
end
