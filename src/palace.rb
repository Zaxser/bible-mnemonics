class Palace
  attr_accessor :floors, :notes, :name, :cards
  @@open_sky = Mnemonic.new(nil, "open sky", "Last chapter, so no floor above")

  # It feels like the model, deck and note stuff should have their own classes,
  # but I'm not sure how to do it yet.
  @@model = $genanki.Model.new(
    1, # Model id; should be randomized and stored eventually
    "BibleVerseMemorization", # Model Name
    css: File.open("css/mnemonic_cards.css").read(),
    fields: [
      "VerseID", "OddWords", "EvenWords", "FirstLetters", "PrecedingVerseID",
      "PrecedingVerseText", "VerseText", "MnemonicText", "VerseAudio",
      "PrecedingVerseNumber", "PrecedingChapterNumber", "PrecedingBookName", 
      "VerseNumber", "ChapterNumber", "BookName"].fields,
    templates: [ 
    # (maybe) 1 card where you give the basic idea of a verse, given the text of the preceding verse
      Template.new("SummaryForPrecedingVerse", 
        question: "html/summaryPrecedingVerse.html").hash,
      # 1 card where you give the basic idea of a verse, given book, chapter and verse numbers
      Template.new("SummaryVerseID", 
      question: "html/summaryVerseID.html").hash,
      # (maybe) 1 card where you give the basic idea of a verse, given the text of the preceding verse
      Template.new("RoteOddWords", question: "html/roteOddWords.html").hash,
      Template.new("RoteEvenWords", question: "html/roteEvenWords.html").hash,
      Template.new("RoteFirstLetters", 
        question: "html/roteFirstLetters.html").hash,
      # 1 card where, given the proceeding verse, you recite the next verse from memory
      Template.new("RotePrecedingVerse", 
        question: "html/rotePrecedingVerse.html").hash,
      # 1 card where given book, chapter and verse numbers, you recite the verse from memory
      Template.new("RoteVerseID", question: "html/roteVerseID.html").hash,
      # (maybe) 1 card, where given the text of the verse, you can recite name, number and location
      Template.new("RoteReverse", question: "html/roteReverse.html", answer: "html/reverseAnswer.html").hash
    ]
  )

  def initialize(book)
    self.name = book.name
    self.cards = []

    # Generate Mnemonic rooms of our Memory Palace for each verse in our book.
    self.floors = book.chapters.map do |chapter|
      chapter.verses.map {|verse| verse.room}  
    end

    # Set values for the rooms that hint at adjacent verses.
    self.floors.each_with_index do |floor, floor_number|
      # The roof should be the floor of the next floor, unless it's the top
      # floor, in which case the roof should be the open sky
      if floor_number == self.floors.length - 1
        ceiling = @@open_sky
      else
        ceiling = self.floors[floor_number + 1][0].floor
      # The staircase comes at the last room of the floor and hints at the
      # start of the first verse of the next chapter (if there is a next chapter)
        floor[-1].upstaircase = self.floors[floor_number + 1][0].characters[0]
      end
      
      # The staircase comes at the beginning room of the floor and hints at the
      # start of the last verse of the last chapter (if there is a last 
      # chapter)
      unless floor_number == 0
        floor[0].downstaircase = self.floors[floor_number - 1][-1].characters[0]
      end

      floor.each_with_index do |room, room_number|
        room.ceiling = ceiling # every room on a floor has the same ceiling
      
      # The door comes at the beginning of the room and hints at the start of 
      # the preceding verse of the chapter (if there was a preceding verse of 
      # the chapter
        unless room_number == 0
          room.door_behind = floor[room_number - 1].characters[0]
        end

      # The door comes at the beginning room and hints at the start of the 
      # preceding verse of the chapter (if there was a preceding verse)
        if room_number < floor.length - 1
          room.door_ahead = floor[room_number + 1].characters[0]
        end
      end
    end
  end

  def notes
    return self.cards unless cards.empty?
    # TODO: HTML Encode each of the fields, Just In Case
    self.floors.each_with_index do |floor, index|
      floor.each do |room|
        # Maybe each of the rooms should make their own notes / fields / model?
        self.cards << $genanki.Note.new(model: @@model, fields: [
          room.verse.identity, # {"name": "VerseID"},
          room.verse.word_hint(:odd), #{"name": "OddWords"},
          room.verse.word_hint(:even), #{"name": "EvenWords"},
          room.verse.letter_hint, #{"name": "FirstLetters"},
          room.verse.prev.identity, #{"name": "PrecedingVerseID"}
          room.verse.prev.text, # {"name": "PrecedingVerseText"},
          room.verse.text, #{"name": "VerseText"},
          room.description, #{"name": "MnemonicText"}
          "[sound:" + room.verse.audio_path.split("/")[-1] + "]",
          room.verse.prev.number, # "PrecedingVerseNumber", 
          room.verse.prev.chapter.number, # "PrecedingChapterNumber", 
          room.verse.prev.chapter.book.name, # "PrecedingBookName", 
          room.verse.number, # "VerseNumber", 
          room.verse.chapter.number, # "ChapterNumber", 
          room.verse.chapter.book.name, # "BookName"
        ])
      end
    end

    self.cards
  end

  def card_pack
    deck = $genanki.Deck.new(
      2, # Deck id; should be randomized and stored eventually
      self.name
    )

    self.notes.each_with_index do |note, index|
      deck.add_note(note)
    end
    
    package = $genanki.Package.new(deck)
    package.media_files = Pathname.glob("audio-verses/*/*/*").map {|v| v.to_s}
    package
  end
end