require "kj"

class Kj::Book
  @@book = Pandas.read_excel("Mnemonics.xlsx", sheet_name="Books")
  def mnemonic
    # Retrieve mnemonic from sheet and create mnemonic object
    row = @@book[@@book.Object == self.name].iloc[0]
    Mnemonic.new(self.name, row["Mnemonic"])
  end
  def mnemonic
    return
  end
end