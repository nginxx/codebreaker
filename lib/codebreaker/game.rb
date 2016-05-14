module Codebreaker
  # Logic game
  class Game
    HINTS = 1
    ATTEMPTS = 4
    CODE_SIZE = 4
    NUM_RANGE = 1..6

    def initialize
      @secret_code = code_generator
      @name = ''
      @attempts = []
      @hints = []
      @start_time = Time.now
      puts @secret_code
    end

    # def define_name
    #   puts 'Enter your name:'.green
    #   name = gets.chomp
    #   validate(nil, name)
    #   @name = name
    # end

    def code_generator
      code = []
      CODE_SIZE.times { code << rand(NUM_RANGE) }
      code.join
    end

    # def validate(num = nil, name = nil)
    #   if !num.nil? && (num.length != CODE_SIZE || !num.match(/[1-6]+/))
    #     raise "Should be #{CODE_SIZE} nums, each num between #{NUM_RANGE}".red
    #   elsif !name.nil? && !name.match(/[a-zA-Z]+/)
    #     raise 'Enter correct name. Only letters.'
    #   end
    # rescue => e
    #   puts e.message
    #   start
    # end

    def compare_input(num)
      check_attempts
      if num == @secret_code
        puts 'Congratulations!!! You won the game. '.yellow +
                 "The code was #{@secret_code}.".yellow
        game_over
      else
        puts 'Try again. ' + match_position(num)
        make_hint if @hints.size < HINTS
        false
      end
    end

    private

    def save_result
      time = (Time.now - @start_time).to_i
      result = {name: @name, attempts: @attempts.size, time: "#{time} sec"}
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
      puts 'Game over! You\'ve exceeded the number of attempts.'.red
      game_over
    end

    def game_over
      save_result
      puts 'Do you want to proceed? (yes/no)'.green
      answer = gets.chomp
      answer == 'yes' ? true : exec('exit')
    end
  end
end