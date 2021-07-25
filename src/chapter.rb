require "kj"

class Kj::Chapter
  def mnemonic
    self.number.mnemonic
  end
end