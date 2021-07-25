class String
  @@people = Pandas.read_excel("Mnemonics.xlsx", sheet_name="People")
  @@actions = Pandas.read_excel("Mnemonics.xlsx", sheet_name="Actions")
  @@objects = Pandas.read_excel("Mnemonics.xlsx", sheet_name="Objects")

  @@mnemonics = {
    people:  Hash.new {|h, k| h[k] = Mnemonic.from_sheet(k, @@people)},
    actions: Hash.new {|h, k| h[k] = Mnemonic.from_sheet(k, @@actions)},
    objects:  Hash.new {|h, k| h[k] = Mnemonic.from_sheet(k, @@objects)}
  }
  def letter?
    self.match?(/[[:alpha:]]/)
  end

  def div(*classes)
    "<div class=\""+ classes.join(" ") + "\">" + self + "</div>"
  end

  def person
    @@mnemonics[:people][self.upcase]
  end

  def action
    @@mnemonics[:actions][self.upcase]
  end

  def object
    @@mnemonics[:objects][self.upcase]
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