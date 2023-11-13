require "json"
require "open-uri"

class GamesController < ApplicationController

  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def score
    @letters = params[:letters]
    word = params[:word]
    if included?(@letters, word)
      if english_word?(word)
        @results = "Congrats #{word}"
      else
        @results = "Sorry but #{word} does not seem to be a valid English word..."
      end
    else
      @results = "Sorry but #{word} can't be built out of #{@letters}"
    end
  end

  def included?(letters, word)
    word.chars.all? { |letter| word.count(letter) <= letters.split.count(letter) }
  end

  def english_word?(word)
    response = URI.parse("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    return json['found']
  end
end
