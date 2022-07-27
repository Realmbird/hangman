# frozen_string_literal: false
require 'json'
# Sets up the variables required to play a game of Hangman (overall application)
class Hangman
  # sets up hangman with file, dictionary, and random word
  def initialize
    @contents = File.readlines('dictionary.txt')
    @data = File.read('save.txt')
    @dictionary = []
    fill_dictionary
  end

  # sets random word

  def random_word 
    @answer = @dictionary[rand(@dictionary.length)]
  end

  # Fills dictionary with words from contents if word is between 5 and 12

  def fill_dictionary
    @contents.each do |word|
      if word.length >= 5 && word.length <= 12
        @dictionary.push(word[0..-2])
      end
    end
  end

  # starts a hangman game

  def start_game
    puts 'Load game? yes or no'
    input = gets.chomp.downcase
    rounds = Game.new(@answer)
    rounds.load if input == 'yes'
    rounds.round
  end
end

# The code for a game of Hangman not a round
class Game
  def initialize(answer, current = Array.new(answer.length, '_'), life = 5)
    @answer = answer
    @current = current
    @key = @answer.split('')
    @lives = life
  end

  def round
    guess until @lives.zero? || @key == @current
    if @lives.zero?
      puts 'You lose'
    else
      puts 'You win'
    end
  end

  # Starts guess
  def guess
    puts 'Enter save or yes if you wish to save your game, enter anything else to continue'
    choice = gets.chomp.downcase
    save if choice == 'save' || choice == 'yes'
    puts 'Enter a letter'
    letter = gets.chomp.downcase
    check(letter)
    p @current
    puts "You have #{@lives} lives left"
  end

  # Checks if letter in word and fills in
  def check(letter)
    if @key.include?(letter)
      @key.each_with_index do |l, index|
        @current[index] = letter if l == letter
      end
    else
      @lives -= 1
      puts 'Fail'
    end
  end

  # save function
  def save
    data = JSON.dump({
      :answer => @answer,
      :current => @current,
      :lives => @lives
    })
    File.write('save.json', data)
  end

  # load function might be used
  # loads game
  def load
    string = File.read('save.json')
    data = JSON.parse string
    initialize(data['answer'], data['current'], data['lives'])
  end
end
game = Hangman.new
game.start_game
