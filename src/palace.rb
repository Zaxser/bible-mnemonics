# Each floor represents a chapter and each verse represents a room
class Floor
  attr_accessor :rooms
  def initialize(rooms)
    self.rooms = rooms

    # The door to the next room has the first character of the next verse on it,
    # as a hint.
    self.rooms.each_with_index do |room, index|
      break if index == self.rooms.length
      room.door = self.rooms[index + 1].characters[0]
    end
  end
end

class Palace
  attr_accessor :floors
  def initialize(floors)
    self.floors = floors 

    # Add a staircase at the end of each floor
    self.floors.each_with_index do |floor, index|
      break if index == self.rooms.length
      # add a staircase to the last room of each floor
      # (except the last one of course)
      floor.rooms[-1].staircase = self.floor[index + 1].rooms[0]characters[0]
    end

    # The ceiling is the floor of the next chapter, except for the last chapter,
    # which is the open sky. This is just to reinforce the number mnemonics for
    # the chapters / floors.
    self.floors.each do |floor, index|
      if index == self.floor.length
        ceiling = "open sky"
      else
        ceiling = self.floors[index + 1]
      end
      
      floor.rooms.each do |room|
        room.ceiling = ceiling
      end
    end
  end
end