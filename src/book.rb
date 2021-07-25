require "kj"

class Kj::Book
  @@book = Pandas.read_excel("Mnemonics.xlsx", sheet_name="Books")
  
  @@mnemonics = Hash.new do |hash, key| 
    hash[key] = Mnemonic.from_sheet(key, @@book)
  end

  def mnemonic
    @@mnemonics[self.name]
  end
end