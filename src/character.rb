class Character
  attr_accessor :person, :action, :object
  def initialize(person, action=false, object=false)
    self.person = person
    self.action = action
    self.object = object
  end

  def self.from_chars(chars)
    args = []
    args << chars[0].person if chars[0]
    args << chars[1].action if chars[1]
    args << chars[2].object if chars[2]
    Character.new(*args)
  end

  def to_s
    if self.object
      return "#{self.person.device} #{self.action.device} #{self.object.device}."
    elsif self.action
      return "#{self.person.device} #{self.action.device} #{self.person.device}."
    elsif self.person
      return "#{self.person.device} takes a bow."
    else
      return ""
    end
  end

  def description
    # should make a "punched up" version for each character later
    to_s
  end
end