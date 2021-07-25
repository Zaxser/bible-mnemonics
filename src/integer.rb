class Integer
  @@book = Pandas.read_excel("Mnemonics.xlsx", sheet_name="Numbers")
  def mnemonic
    # Retrieve mnemonic from sheet and create mnemonic object
    Mnemonic.from_sheet(self, @@book)
  end
end