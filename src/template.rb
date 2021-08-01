class Template
  attr_accessor :question_format, :answer_format, :name
  def initialize(name, question:, answer: "html/verseAnswer.html")
    self.name = name
    header = open("html/header.html").read
    open(question) {|f| self.question_format = header + f.read}
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