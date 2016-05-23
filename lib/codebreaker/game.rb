module Codebreaker
  # Logic game
  class Game
    HINTS = 1
    ATTEMPTS = 4
    CODE_SIZE = 4
    NUM_RANGE = 1..6

    attr_accessor :name

    def initialize
      @secret_code = code_generator
      @name = ''
      @attempts = @hints = 0
      @win = false
      @start_time = Time.now
    end

    def compare_input(num)
      return game_over if check_attempts
      if num == @secret_code
        puts 'Congratulations!!! You won the game. '.yellow
        @win = true
        game_over
      else
        puts 'Try again. ' + match_position(num)
        false
      end
    end

    def validate(rule, item)
      case rule
      when 'name' then item =~ /^[a-zA-Z]+$/
      when 'number' then item =~ /^[1-6]+$/ && item.length == CODE_SIZE
      end
    end

    def make_hint
      return puts 'No hints available.' if @hints == HINTS
      @hints += 1
      puts @secret_code.chars.sample
    end

    private

    def code_generator
      code = []
      CODE_SIZE.times { code << rand(NUM_RANGE) }
      code.join
    end

    def save_result
      time = (Time.now - @start_time).to_i
      result = { name: @name, secret_code: @secret_code, attempts: @attempts,
                hints: @hints, win: @win, time: "#{time} sec" }
      File.open('results.json', 'a+') { |f| f.puts(result.to_json) }
    end

    def match_position(num)
      code = @secret_code.chars
      num = num.chars
      guess = num.zip(code).map do |x, y|
        next unless x == y
        code[code.index(y)] = nil; '+'
      end
      guess << '-' * (num & code).size
      guess.join
    end

    def check_attempts
      @attempts += 1
      return unless @attempts > ATTEMPTS
      puts 'Game over! You\'ve exceeded the number of attempts. '.red +
               "The code was #{@secret_code}.".red
      true
    end

    def game_over
      save_result
      puts 'Do you want to proceed? (yes/no)'.green
      answer = gets.chomp
      answer == 'yes' ? true : exec('exit')
    end
  end
end
