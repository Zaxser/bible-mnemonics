class Room
  attr_accessor :window, :floor, :walls, :characters, :ceiling, :upstaircase,
    :downstaircase, :door_ahead, :door_behind, :verse_id
    # window = self.chapter.book.mnemonic
    # walls = self.number.mnemonic
    # floor = self.chapter.mnemonic
    # characters = self.text.characters
    
    # Room.new(self.chapter.book, self.number, self.chapter.number, self.text)
  def initialize(book, chapter, verse, text)
    self.verse_id = "#{book.name} #{chapter}:#{verse}"
    self.window = book.mnemonic
    self.floor = chapter.mnemonic
    self.walls = verse.mnemonic
    self.characters = text.characters
    self.ceiling = false
    self.upstaircase = false
    self.downstaircase = false
    self.door_ahead = false
    self.door_behind = false
  end

  def description
    description = "The floor is #{self.floor.device}. "
    description += "The walls are #{self.walls.device}. "
    description += "The ceiling is #{self.ceiling.device} ." if self.ceiling
    
    description += "\nThere are #{self.characters.length} people in the room. "
    
    characters.each do |character|
      description += character.description
    end

    if self.door_behind
      description += "\nBehind you is a door leading back, it has "
      description += "#{self.door_behind}. "
    end

    if self.door_ahead
      decription += "\nAhead of you, you see a door, it has "
      description += "#{self.door_ahead.description}."
    end

    if self.upstaircase
      description += "\nAhead of you is a staircase leading up, "
      description += "on it, you can see "
      description += self.upstaircase.description
    end

    if self.upstaircase
      description += "\nBehind you is a staircase going down, "
      description += "on it, you can see "
      description += self.downstaircase.description
    end

    description
  end

  def mnemonic
    Mnemonic.new(verse_id, description)
  end
end