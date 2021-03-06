class Kj::Verse
  @@people = Pandas.read_excel("Mnemonics.xlsx", sheet_name="People")
  @@actions = Pandas.read_excel("Mnemonics.xlsx", sheet_name="Actions")
  @@objects = Pandas.read_excel("Mnemonics.xlsx", sheet_name="Objects")

  @@mnemonics = {
    people:  Hash.new {|h, k| h[k] = Mnemonic.from_sheet(k, @@people)},
    actions: Hash.new {|h, k| h[k] = Mnemonic.from_sheet(k, @@actions)},
    objects:  Hash.new {|h, k| h[k] = Mnemonic.from_sheet(k, @@objects)}
  }

  def self.model(*keys)
    templates = {
      # 1 card where you recite the verse from memory given every other word
      card: template("verseCard", question: "html/verseQuestion.html",
        answer: "html/verseAnswer.html"),
      book: template("verseReverse", question: "html/verseReverseQuestion.html",
        answer: "html/verseReverseAnswer.html")
    }
  
    templates = keys == [] ? templates.values : keys.map {|key| templates[key]}
    
    fields = ["VerseNumber", "VerseMnemonic", "MnemonicExplanation"]
  
    @@model = $genanki.Model.new(
      rand(1 << 30..1 << 31), # Model id; should be randomized and stored eventually
      "VerseMemorization", # Model Name
      css: File.open("css/mnemonic_cards.css").read(),
      fields: fields.fields,
      templates: templates
    )
  end

  @@model = self.model

  def fields
    fields = [self.number, self.mnemonic.device, self.mnemonic.explanation]
    fields.map! {|f| Rack::Utils.escape_html(f)}
  end
  
  def note
    $genanki.Note.new(model: @@model, fields: self.fields)
  end

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
    "#{self.book_name} #{self.chapter.number}:#{self.number}"
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

  def audio_path
    book = self.chapter.book
    chapter_id = self.chapter.number.to_s.rjust(3, "0")
    verse_id = self.number.to_s.rjust(3, "0")
    book_id = book.id.to_s.rjust(2, "0")
    "audio-verses/#{book_id} #{book.name}/#{book.name} #{chapter_id}/#{book.name} #{chapter_id} #{verse_id}.mp3"
  end
end