class HangpersonGame

  attr_accessor :word, :guesses, :wrong_guesses

  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
  end

  def guess(letter)
    if letter.nil? || letter.empty? || letter !~ /[a-z]/i
      raise ArgumentError
    end
    
    letter_downcase = letter.downcase
    return false if @guesses.include?(letter_downcase) || @wrong_guesses.include?(letter_downcase)

    return @word.include?(letter_downcase) ? @guesses << letter_downcase : @wrong_guesses << letter_downcase
  end


  def word_with_guesses
    word_status = '-' * @word.size
    @guesses.each_char do |guess_letter|
      @word.each_char.with_index do |letter, index|
        if guess_letter == letter
          word_status[index] = guess_letter
        end
      end
    end
    return word_status
  end

  def check_win_or_lose
    if @wrong_guesses.size >= 7
      return :lose
    elsif word_with_guesses.include?('-')
      return :play
    else
      return :win
    end
  end
  
  # You can test it by running $ bundle exec irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> HangpersonGame.get_random_word
  #  => "cooking"   <-- some random word
  #
  # curl --data '' http://watchout4snakes.com/wo4snakes/Random/RandomWord
  # --data is necessary to force curl to do a POST rather than a GET.
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.new('watchout4snakes.com').start { |http|
      return http.post(uri, "").body
    }
  end

end
