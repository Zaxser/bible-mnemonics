class String
  def letter?
    self.match?(/[[:alpha:]]/)
  end

  def div(*classes)
    "<div class=\""+ classes.join(" ") + "\">" + self + "</div>"
  end

  def person
    Person.new(self.upcase)
  end

  def action
    Action.new(self.upcase)
  end

  # Shouldn't name the O in a PAO Object; probably shouldn't even name this
  # function object. 
  def object
    Animal.new(self.upcase)
  end

  def characters
    chars = self.split(" ").map {|char| char[0].letter? ? char[0] : char[1]}
    chars.each_slice(3).map do |slice|
      Character.from_chars(slice)
    end
  end

  def mnemonic
    self.characters.map(&:to_s).join(" ")
  end
end