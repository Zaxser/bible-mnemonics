class Integer
  @@book = Pandas.read_excel("Mnemonics.xlsx", sheet_name="Numbers")

  @@mnemonics = Hash.new do |hash, key| 
    hash[key] = Mnemonic.from_sheet(key, @@book)
  end

  def mnemonic
    @@mnemonics[self]
  end
end