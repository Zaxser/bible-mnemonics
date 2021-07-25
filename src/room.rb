class Room
  attr_accessor :window, :floor, :walls, :characters, :ceiling, :upstaircase,
    :downstaircase, :door_ahead, :door_behind, :verse
    # window = self.chapter.book.mnemonic
    # walls = self.number.mnemonic
    # floor = self.chapter.mnemonic
    # characters = self.text.characters
    
    # Room.new(self.chapter.book, self.number, self.chapter.number, self.text)
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
end