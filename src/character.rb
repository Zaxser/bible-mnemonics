class Character
  attr_accessor :person, :action, :object
  def initialize(person=false, action=nil, object=nil)
    self.person = person
    self.action = action
    self.object = object
  end

  def self.from_chars(chars)
    args = []
    args << chars[0].person
    args << (chars[1] ? chars[1].action : "NONE".action)
    args << (chars[2] ? chars[2].object : "NONE".object)
    Character.new(*args)
  end

  def to_s
    if self.action == "NONE"
      return "#{self.person.to_s} takes a bow."
    elsif self.object == "NONE"
      return "#{self.person.to_s} #{self.action.to_s} the door."
    else
      return "#{self.person.to_s} #{self.action.to_s} #{self.object.to_s}."
    end
  end

  def description
    # should make a "punched up" version for each character later
    to_s
  end
end