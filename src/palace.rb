$genanki = PyCall.import_module("genanki")

class Palace
  attr_accessor :floors, :notes, :name, :cards
  @@open_sky = Mnemonic.new(nil, "open sky", "Last chapter, so no floor above")
  @@model = $genanki.Model.new(
    1, # Model id; should be randomized and stored eventually
    "BibleVerseMemorization", # Model Name
    css: File.open("css/mnemonic_cards.css").read(),
    fields: [
      "VerseID", "OddWords", "EvenWords", "FirstLetters", "PrecedingVerseID",
      "PrecedingVerseText", "VerseText", "MnemonicText"].fields,
    # Badly need to make a Template class to clean this stuff up.
    templates: [{ 
    # (maybe) 1 card where you give the basic idea of a verse, given the text of the preceding verse
        "name": "SummaryForPrecedingVerse",
        "qfmt": 
        "<div class=\"front summary preceding verse\">" +
          "<div class=\"verse id\">{{VerseID}}</div>" +
          "<div class=\"verse id\">{{PrecedingVerseID}}</div>" + 
          "<div class=\"preceding verse hint\">{{PrecedingVerseText}}</div>" +
        "</div>",
        "afmt": 
        "<div class=\"back summary\">" +
          "<div class=\"verse text\">{{VerseText}}</div>" +
          "<div class=\"mnemonic text\">{{MnemonicText}}</div>" +
        "</div>"
      },{ 
    # 1 card where you give the basic idea of a verse, given book, chapter and verse numbers
        "name": "SummaryVerseID",
        "qfmt": 
        "<div class=\"front summary\">" +
          "<div class=\"verse id\">{{VerseID}}</div>" + 
        "</div>",
        "afmt": 
        "<div class=\"back summary\">" +
          "<div class=\"verse text\">{{VerseText}}</div>" +
          "<div class=\"mnemonic text\">{{MnemonicText}}</div>" +
        "</div>"
      },{
        "name": "RoteOddWords",
        "qfmt": 
        "<div class=\"front rote\">" +
          "<div class=\"verse id\">{{VerseID}}</div>" + 
          "<div class=\"odd words hint\">{{OddWords}}</div>" +
        "</div>",
        "afmt": 
        "<div class=\"back rote\">" +
          "<div class=\"verse text\">{{VerseText}}</div>" +
          "<div class=\"mnemonic text\">{{MnemonicText}}</div>" +
        "</div>"
      },{
        "name": "RoteEvenWords",
        "qfmt": 
        "<div class=\"front rote\">" +
          "<div class=\"verse id\">{{VerseID}}</div>" + 
          "<div class=\"even words hint\">{{EvenWords}}</div>" +
        "</div>",
        "afmt": 
        "<div class=\"back rote\">" +
          "<div class=\"verse text\">{{VerseText}}</div>" +
          "<div class=\"mnemonic text\">{{MnemonicText}}</div>" +
        "</div>"
      }, {
    # 1 card where, given the first letter of each word in the verse, you recite the verse
        "name": "RoteFirstLetters",
        "qfmt": 
        "<div class=\"front rote\">" +
          "<div class=\"verse id\">{{VerseID}}</div>" + 
          "<div class=\"first letters hint\">{{FirstLetters}}</div>" +
        "</div>",
        "afmt": 
        "<div class=\"back rote\">" +
          "<div class=\"verse text\">{{VerseText}}</div>" +
          "<div class=\"mnemonic text\">{{MnemonicText}}</div>" +
        "</div>"
      }, {
    # 1 card where, given the proceeding verse, you recite the next verse from memory
        "name": "RotePrecedingVerse",
        "qfmt":
          "<div class=\"front rote\">" +
            "<div class=\"verse id\">{{VerseID}}</div>" + 
            "<div class=\"preceding verse hint\">" +
              "<div class=\"preceding verse id hint\">" +
                "{{PrecedingVerseID}}" +
              "</div>" +
              "<div class=\"preceding verse text hint\">" +
                "{{PrecedingVerseText}}" +
              "</div>" +
            "</div>" +
          "</div>",
        "afmt": 
          "<div class=\"back rote\">" +
            "<div class=\"verse text\">{{VerseText}}</div>" +
            "<div class=\"mnemonic text\">{{MnemonicText}}</div>" +
          "</div>"
      }, {
    # 1 card where given book, chapter and verse numbers, you recite the verse from memory
        "name": "RoteNoHint",
        "qfmt":
          "<div class=\"front rote\">" +
            "<div class=\"verse id\">{{VerseID}}</div>" + 
          "</div>",
        "afmt": 
          "<div class=\"back rote\">" +
            "<div class=\"verse text\">{{VerseText}}</div>" +
            "<div class=\"mnemonic text\">{{MnemonicText}}</div>" +
          "</div>"
      }, {
    # (maybe) 1 card, where given the text of the verse, you can recite name, number and location
        "name": "RoteReverse",
        "qfmt":
          "<div class=\"front rote\">" +
            "<div class=\"verse text\">{{VerseText}}</div>" +
          "</div>",
        "afmt": 
          "<div class=\"back rote\">" +
            "<div class=\"verse id\">{{VerseID}}</div>" + 
            "<div class=\"mnemonic text\">{{MnemonicText}}</div>" +
          "</div>"
      }   
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

    self.floors.each_with_index do |floor, index|
      floor.each do |room|
        self.cards << $genanki.Note.new(model: @@model, fields: [
          room.verse.identity, # {"name": "VerseID"},
          room.verse.word_hint(:odd), #{"name": "OddWords"},
          room.verse.word_hint(:even), #{"name": "EvenWords"},
          room.verse.letter_hint, #{"name": "FirstLetters"},
          room.verse.prev.identity, #{"name": "PrecedingVerseID"}
          room.verse.prev.text, # {"name": "PrecedingVerseText"},
          room.verse.text, #{"name": "VerseText"},
          room.description #{"name": "MnemonicText"}
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
    
    $genanki.Package.new(deck)
  end
end