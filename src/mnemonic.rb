Mnemonic = Struct.new("Mnemonic", :object, :device, :explanation) do
  def initialize(object, device, explanation="")
    super
  end

  def self.from_sheet(object, sheet)
    row = sheet[sheet.Object == object].iloc[0]
    Mnemonic.new(object, row["Mnemonic"], row["Explanation"])
  end

  def card
    Card.new(object, device, explanation)
  end

  def div
    # Eventually, I'd like to figure out a way to add an explanation as a sort
    # of "alt text" for the div.
    device.div("mnemonic")
  end
end