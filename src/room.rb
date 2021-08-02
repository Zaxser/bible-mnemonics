class Room
  def self.model(*keys)
    templates = {
      # 1 card where you recite the verse from memory given every other word
      roteEvenWords: template("RoteEvenWords", 
        question: "html/roteEvenWords.html",answer: "html/roteAnswer.html"),
      # 1 card where you recite the verse given the first letter of each word
      roteFirstLetters: template("RoteFirstLetters", 
        question: "html/roteFirstLetters.html", answer: "html/roteAnswer.html"),
      # 1 card where you recite the verse from memory given every other word
      roteOddWords: template("RoteOddWords", question: "html/roteOddWords.html",
        answer: "html/roteAnswer.html"),
      # 1 card where, given the proceeding verse, you recite the next verse from memory
      rotePrecedingVerse: template("RotePrecedingVerse",
        question: "html/rotePrecedingVerse.html", 
        answer: "html/roteAnswer.html"),
      # (maybe) 1 card, where given the text of the verse, you can recite name, number and location
      roteReverse: template("RoteReverse", question: "html/roteReverse.html", 
        answer: "html/roteReverseAnswer.html"),
      # 1 card where given book, chapter and verse numbers, you recite the verse from memory
      roteVerseID: template("RoteVerseID", question: "html/roteVerseID.html",
        answer: "html/roteAnswer.html"),
      # (maybe) 1 card where you give the basic idea of a verse, given the text of the preceding verse
      summaryPrecedingVerse: template("SummaryPrecedingVerse", 
        question: "html/summaryPrecedingVerse.html",
        answer: "html/summaryAnswer.html"),
      # 1 card where you give the basic idea of a verse, given book, chapter and verse numbers
      summaryVerseID: template("SummaryVerseID", 
        question: "html/summaryVerseID.html",
        answer: "html/summaryVerseID.html")
    }
  
    templates = keys == [] ? templates.values : keys.map {|key| templates[key]}
    
    fields = ["VerseID", "VerseText", "OddWords", "EvenWords", "FirstLetters", 
      "PrecedingVerseID", "PrecedingVerseText", "MnemonicText", "VerseAudio",
      "PrecedingVerseNumber", "PrecedingChapterNumber", "PrecedingBookName", 
      "VerseNumber", "ChapterNumber", "BookName"
    ]
  
    @@model = $genanki.Model.new(
      rand(1 << 30..1 << 31), # Model id; should be randomized and stored eventually
      "BibleVerseMemorization-Genesis", # Model Name
      css: File.open("css/mnemonic_cards.css").read(),
      fields: fields.fields,
      templates: templates
    )
  end

  @@model = self.model

  attr_accessor :window, :floor, :walls, :characters, :ceiling, :upstaircase,
    :downstaircase, :door_ahead, :door_behind, :verse
  
  def initialize(verse)
    self.verse = verse
    self.window = verse.chapter.book.mnemonic
    self.floor = verse.chapter.mnemonic
    self.walls = verse.mnemonic
    self.characters = verse.text.characters
    self.ceiling = false
    self.upstaircase = false
    self.downstaircase = false
    self.door_ahead = false
    self.door_behind = false
  end

  def description
    description = "The floor is #{self.floor.device}. "
    description += "The walls are #{self.walls.device}. "
    description += "In the window, you can see a #{self.window.device}. "
    description += "The ceiling is #{self.ceiling.device}. " if self.ceiling
    
    description += "\nThere are #{self.characters.length} people in the room. "

    description += characters.map(&:description).join(" ")

    if self.door_behind
      description += "\nBehind you is a door leading back, on it you see  "
      description += "#{self.door_behind}"
    end

    if self.door_ahead
      description += "\nAhead of you, you see a door, on it, you see "
      description += "#{self.door_ahead.description}"
    end

    if self.upstaircase
      description += "\nAhead of you is a staircase leading up, "
      description += "on it, you can see "
      description += self.upstaircase.description
    end

    if self.downstaircase
      description += "\nBehind you is a staircase going down, "
      description += "on it, you can see "
      description += self.downstaircase.description
    end

    description
  end

  def mnemonic
    Mnemonic.new(self.verse.identity + self.verse.text, description)
  end

  def fields
    fields = [  self.verse.identity, # {"name": "VerseID"},
                self.verse.text, # {"name": "PrecedingVerseText"},
                self.verse.word_hint(:odd), #{"name": "OddWords"},
                self.verse.word_hint(:even), #{"name": "EvenWords"},
                self.verse.letter_hint, #{"name": "FirstLetters"},
                self.verse.prev.identity, #{"name": "PrecedingVerseID"}
                self.verse.prev.text, #{"name": "VerseText"},
                self.description, #{"name": "MnemonicText"}
                "[sound:" + self.verse.audio_path.split("/")[-1] + "]",
                self.verse.prev.number, # "PrecedingVerseNumber", 
                self.verse.prev.chapter.number, # "PrecedingChapterNumber", 
                self.verse.prev.chapter.book.name, # "PrecedingBookName", 
                self.verse.number, # "VerseNumber", 
                self.verse.chapter.number, # "ChapterNumber", 
                self.verse.chapter.book.name, # "BookName"
    ]

    fields.map! {|f| Rack::Utils.escape_html(f)}
  end

  def note
    $genanki.Note.new(model: @@model, fields: fields)
  end
end