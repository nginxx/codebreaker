module Codebreaker
  # Logic game
  class Game
    HINTS = 3
    ATTEMPTS = 10
    CODE_SIZE = 4
    NUM_RANGE = 1..6

    def initialize
      @secret_code = code_generator
      @name = ''
      @attempts = []
      @hints = []
      @start_time = Time.now
    end

    def start
      if @attempts.size > ATTEMPTS
        puts 'You\'ve exceeded the number of attempts.'.red
        game_over
      end
      define_name if @name.empty?
      puts "Enter #{CODE_SIZE} numbers.".green +
               " Each num should be in range #{NUM_RANGE}.".green
      guess_num = gets.chomp
      validate(guess_num)
      compare_input(guess_num)
    end

    private

    def define_name
      puts 'Enter your name:'.green
      name = gets
      validate(nil, name)
      @name = name
    end

    def code_generator
      code = []
      CODE_SIZE.times { code << rand(NUM_RANGE) }
      code.join
    end

    def validate(num = nil, name = nil)
      unless num.nil? && (num.length == CODE_SIZE || num.match(/[1-6]+/))
        raise "Should be #{CODE_SIZE} nums, each num between #{NUM_RANGE}".red
      end
      unless name.nil? && name.match(/[a-zA-Z]+/)
        raise 'Enter correct name. Only letters'
      end
    rescue => e
      puts e.message
      start
    end

    def compare_input(num)
      if num == @secret_code
        puts 'Congratulations!!! You won the game. '.yellow +
                 "The code was #{num}.".yellow
       game_over
      else
        @attempts << 1
        puts 'Try again. ' + match_position(num)
        make_hint if @attempts.size < HINTS
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

    def make_hint
      puts 'Need a hint ?(yes/no)'
      answer = gets
      puts @secret_code.sample if answer == 'yes'
    end

    def game_over
      save_result
      'Do you want to proceed? (yes/no)'.green
      answer = gets
      if answer == 'yes'
        @attempts = []
        @hints = []
        start
      else
        exec('exit')
      end
    end

    def save_result
      result = {name: @name, attempts: @attempts, time: @start_time - Time.now}
      file = File.open("results.json", 'a+')
      file.puts(result.to_json)
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
