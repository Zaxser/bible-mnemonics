class Palace
  attr_accessor :floors, :notes, :name, :cards, :audio_path
  @@open_sky = Mnemonic.new(nil, "open sky", "Last chapter, so no floor above")

  def initialize(book)
    self.name = book.name
    self.audio_path = "audio-verses/#{book.id} #{book.name}/*/*"
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
      # start of the first verse of the next chapter (if there is a next 
      # chapter)
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
      # the chapter)
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
        self.cards << room.note
      end
    end
  
    self.cards
  end
  
  def card_pack
    deck = $genanki.Deck.new(
      2, # Deck id; should be randomized and stored eventually
      self.name
    )
  
    self.notes.each_with_index do |note|
      deck.add_note(note)
    end
    
    package = $genanki.Package.new(deck)
    package.media_files = Pathname.glob(self.audio_path).map {|v| v.to_s}
    package
  end

  def mnemonic_lesson_notes
    verses = []
    chapters = []
    people = []
    actions = []
    objects = []

    notes = []

    self.floors.each do |floor|
      floor.each do |room|
        unless verses.include? room.verse.number
          notes << room.verse.note
          verses << room.verse.number
        end
        
        unless chapters.include? room.verse.chapter.number
          notes << room.verse.chapter.note
          chapters << room.verse.chapter.number
        end

        room.characters.each do |character|
          unless people.include? character.person.to_s
            notes << character.person.note
            people << character.person.to_s
          end

          unless actions.include? character.action.to_s
            notes << character.action.note
            actions << character.action.to_s
          end

          unless objects.include? character.object.to_s
            notes << character.object.note
            objects << character.object.to_s
          end
        end
        
        notes << room.note
      end
    end
    notes
  end

  def mnemonic_lesson_pack
    deck = $genanki.Deck.new(
      10, # Deck id; should be randomized and stored eventually
      self.name
    )
  
    self.mnemonic_lesson_notes.each_with_index do |note|
      deck.add_note(note)
    end
    
    package = $genanki.Package.new(deck)
    package.media_files = Pathname.glob(self.audio_path).map {|v| v.to_s}
    package
  end
end