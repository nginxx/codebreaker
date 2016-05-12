module Codebreaker
  class Game
    HINTS = 3
    ATTEMPTS = 10
    CODE_SIZE = 4
    NUM_RANGE = 1..6

    def initialize
      @secret_code = ''
    end

    def start
      @secret_code = code_generator
      puts "Enter #{CODE_SIZE} numbers. Each num should be in range #{NUM_RANGE.to_s}.".green
      guess_num = gets.chomp
      puts guess_num
      validate_guess_num(guess_num)
    end

    private

    def code_generator
      code = []
      CODE_SIZE.times{ code << rand(NUM_RANGE)}
      code.join.to_i
    end

    def validate_guess_num(num)
      begin
        if num.length != CODE_SIZE || !num.match(/[1-6]+/)
          raise "Should be #{CODE_SIZE} nums, each num between #{NUM_RANGE}".red
        end
      rescue Exception => e
        puts e.message
        start
      end
    end
  end
end
puts 'Ready for challenge ? (type yes/no)'
start_game = gets.chomp
if start_game == 'yes'
  puts 'Let\'s start!!!'
  game = Codebreaker::Game.new
  game.start
else
  exec('exit')
end
