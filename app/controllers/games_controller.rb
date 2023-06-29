require "open-uri"

class GamesController < ApplicationController

  def new
    # Array of all uppercase letters from A to Z
    alphabet = ('A'..'Z').to_a

    # randomly select 10 letters from the array
    @letters = alphabet.sample(10)
  end

  def score
    # scoring logic here
    @user_input = params[:word].upcase
    @letters = params[:letters].split('')
    @url = "https://wagon-dictionary.herokuapp.com/#{@user_input}"

    @dictionary_info = URI.open(@url).read
    @user_data = JSON.parse(@dictionary_info)

    # Check if the word can be built out of the original grid
    if can_be_built?(@user_input, @letters)
      # Check if the word is found
      if @user_data["found"]
        @message = "Congratulations! #{@user_data["word"]} is a valid English word!"
      else
        @message = "Sorry #{@user_data["word"]} does not seem to be a valid English word..."
      end
    else
      @message = "Sorry, but #{@user_data["word"]} can't be built out of #{@letters}"
    end
  end

  # other ways to check
  # minus two arrays
  # if

  private

  # Helper method to check if the word can be built from the given letters
  def can_be_built?(word, letters)
    # Count the occurrences of each character in letters
    letter_counts = Hash.new(0)
    letters.each { |letter| letter_counts[letter] += 1 }

    # Check if word can be built using the letters
    word.chars.each do |char|
      letter_counts[char] -= 1
      return false if letter_counts[char] < 0
    end

    true
  end
end
