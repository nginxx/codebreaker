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
      @attempts = []
      @hints = []
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
        make_hint if @hints.size < HINTS
        false
      end
    end

    def validate(rule, item)
      case rule
        when 'name'
          item.match(/[a-zA-Z]+/)
        when 'number'
          item.match(/[1-6]+/) && item.length == CODE_SIZE
      end
    end

    private

    def code_generator
      code = []
      CODE_SIZE.times { code << rand(NUM_RANGE) }
      code.join
    end

    def save_result
      time = (Time.now - @start_time).to_i
      result = {name: @name, attempts: @attempts.size,
                hints: @hints.size, win: @win, time: "#{time} sec"}
      file = File.open('lib/codebreaker/results.json', 'a+')
      file.puts(result.to_json)
      file.close
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
      answer = gets.chomp
      return unless answer == 'yes'
      @hints << 1
      puts @secret_code.chars.sample
    end

    def check_attempts
      @attempts << 1
      return unless @attempts.size > ATTEMPTS
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
