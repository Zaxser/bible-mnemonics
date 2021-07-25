class Card
  attr_accessor :front, :back
  def initialize(hint, answer, mnemonic, media=[], type="")
    self.front = hint.div("hint")
    self.back = answer.div("answer") + " " + mnemonic.div
  end
end