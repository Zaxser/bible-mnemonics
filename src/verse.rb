class Kj::Verse
  def room
    window = self.chapter.book.mnemonic
    walls = self.number.mnemonic
    floor = self.chapter.mnemonic
    characters = self.text.characters
    
    Room.new(self.chapter.book, self.number, self.chapter.number, self.text)
  end

  def mnemonic(type=:room)
    return self.number.mnemonic if type == :number
    return self.text.mnemonic if type == :text
    return self.room.mnemonic if type == :room
    
    # Retrieve mnemonic from sheet and create mnemonic object
  end

  # Displays a a label for the verse in the pattern Book Chapter:Verse
  def identity
    self.book_name + " " + self.chapter_id.to_s + ":" + self.number.to_s
  end

  # Makes a div that displays the preceding verse as a hint.
  def preceding_verse_hint
    preceding_verse = self.prev
    id_div = preceding_verse.identity.div("verse", "preceding", "hint", "id")
    text_div = preceding_verse.text.div("verse", "preceding", "hint", "text")
    hint = id_div + " " + text_div
    hint.div(["verse", "preceding", "hint", "parent"])
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
    first_letters.div(["letters", "hint"])
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

    hint.join(" ").div("words", "hint", type)
  end

  # Makes cards of different types wiht 
  def card(hint=false, type="rote")
    id_div = self.identity.div("verse", "id")
    mnemonic = self.mnemonic
    
    hint_div = preceding_verse_hint if hint == :preceding_verse
    hint_div = letter_hint if hint == :letter
    hint_div = word_hint(:odd) if hint == :odd_words
    hint_div = word_hint(:even) if hint == :even_words
    hint_div = self.text.div("verse", "text", "answer", "hint") if hint == :reverse
    hint_div = "" unless hint
    
    return Card.new(hint_div, id_div, mnemonic, type) if hint == :reverse
    
    text_div = self.text.div("verse", "text", "answer")
    Card.new(id_div + " " + hint_div, text_div, mnemonic, type)
  end

  # Creates a bunch of cards for the verse
  # Maybe add functionality to make this create a variable number / kinds of
  # cards based on parameters?
  def cards
    cards = []

    # # (maybe) 1 card where you give the basic idea of a verse, given the text of the preceding verse
    # unless self.number == 1 and self.chapter.number == 1
    #   cards << self.card(:preceding_verse, "summary")
    # end
    # # 1 card where you give the basic idea of a verse, given book, chapter and verse numbers
    # cards << self.card(false, "summary")
    # 1 card where, given every other word, you fill in the missing words
    cards << self.card(:odd_words, "rote")
    cards << self.card(:even_words, "rote")
    # 1 card where, given the first letter of each word in the verse, you recite the verse
    cards << self.card(:letter, "rote")
    # 1 card where, given the proceeding verse, you recite the next verse from memory
    cards << self.card(:preceding_verse, "rote")
    # 1 card where given book, chapter and verse numbers, you recite the verse from memory
    cards << self.card(false, "rote")
    # (maybe) 1 card, where given the text of the verse, you can recite name, number and location
    cards <<  self.card(:reverse, "rote")

    cards
  end
end