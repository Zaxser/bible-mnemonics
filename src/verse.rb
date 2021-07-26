class Kj::Verse
  def room
    Room.new(self)
  end

  def mnemonic(type=:number)
    return self.number.mnemonic if type == :number
    return self.text.mnemonic if type == :text
    return self.room.mnemonic if type == :room
    
    # Retrieve mnemonic from sheet and create mnemonic object
  end

  # Displays a a label for the verse in the pattern Book Chapter:Verse
  def identity
    "#{self.book_name} #{self.number}:#{self.number}"
  end

  # Makes a div that displays the first letter of each word of the verse as a
  # hint.
  def letter_hint
    first_letters = self.text.split(" ").map do |word|
      next word[0] + word[1] + word[-1] unless word[0].letter? or word[-1].letter?
      next word[0] + word[1] unless word[0].letter?
      next word[0] + word[-1] unless word[-1].letter?
      word[0]
    end
    first_letters = first_letters.join(" ")
  end

  # Makes a div that displays every other word as a hint.
  def word_hint(selection=:even)
    # equivalence is the result of a modulo operation; zero indexing is weird
    equivalence, type = 1, "even" if selection == :even
    equivalence, type = 0, "odd" if selection == :odd

    hint = self.text.split(" ").each_with_index.map do |word, index|
      if index % 2 == equivalence
        word
      else
        word.each_char.map {|_| "_"}.join("")
      end
    end

    hint.join(" ")
  end
end