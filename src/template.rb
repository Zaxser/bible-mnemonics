# Feels a little ugly to do it this way; but it also felt ugly to keep it a
# class.
def template(name, question:, answer:)
  header = open("html/header.html") {|f| f.read}
  question_format = header + open(question).read
  answer_format   = open(answer).read

  {
    "name": name,
    "qfmt": question_format,
    "afmt": question_format + answer_format
  }
end