# Dude. This is stupid. There's no reason to custom generate HTML just to save
# a few lines of code. What I should do is just make the formats for the front
# and back their own HTML files.

class Template
  attr_accessor :question_format, :answer_format, :name
  def initialize(name, question:, answer: "html/verseAnswer.html")
    self.name = name
    open(question) {|f| self.question_format = f.read}
    open(answer)   {|f| self.answer_format   = f.read}
  end

  def hash
    {
      "name": self.name,
      "qfmt": self.question_format,
      "afmt": self.question_format + self.answer_format
    }
  end
end