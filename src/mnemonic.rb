class Mnemonic < Struct.new("Mnemonic", :object, :device, :explanation)
  def initialize(object, device, explanation="")
    super
  end

  def self.from_sheet(object, sheet)
    row = sheet[sheet.Object == object].iloc[0]
    device = (row["Mnemonic"].nan? ? "" : row["Mnemonic"])
    explanation = (row["Explanation"].nan? ? "" : row["Explanation"])
    Mnemonic.new(object, device, explanation)
  end
end