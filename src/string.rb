class String
  @@people = Pandas.read_excel("Mnemonics.xlsx", sheet_name="People")
  @@actions = Pandas.read_excel("Mnemonics.xlsx", sheet_name="Actions")
  @@objects = Pandas.read_excel("Mnemonics.xlsx", sheet_name="Objects")
  def letter?
    self.match?(/[[:alpha:]]/)
  end

  def div(*classes)
    "<div class=\""+ classes.join(" ") + "\">" + self + "</div>"
  end

  def person
    Mnemonic.from_sheet(self.upcase, @@people, )
  end

  def action
    Mnemonic.from_sheet(self.upcase, @@actions)
  end

  def object
    Mnemonic.from_sheet(self.upcase, @@objects)
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