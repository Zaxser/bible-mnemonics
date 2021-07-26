class Template
  @@fields_classes = {
    "VerseID" => ["verse", "id"], 
    "OddWords" => ["verse", "text", "odd"], 
    "EvenWords" => ["verse", "text", "even"], 
    "FirstLetters" => ["verse", "text", "first-letters"], 
    "PrecedingVerseID" => ["preceding", "verse", "id"], 
    "PrecedingVerseText" => ["preceding", "verse", "id"], 
    "VerseText" => ["verse", "text"], 
    "MnemonicText" => ["mnemonic", "text"]
  }

  attr_accessor :question_format, :answer_format, :name
  def initialize(name, *types, front_fields: ["VerseID"], back_fields: ["VerseText", "MnemonicText"])
    self.name = name
    types = types.empty? ? "rote" : types.join(" ")
    self.question_format = "<div class=\"front #{types}\">" +
      front_fields.map {|field| field_div(field)}.join("\n") +
    "</div>"

    self.answer_format = self.question_format +
    "<div class=\"back #{types}\">" +
      back_fields.map {|field| field_div(field)}.join("\n") + 
    "</div>"
  end

  def field_div(field)
    "<div class=\"#{@@fields_classes[field].join(" ")}\">" +
      "{{#{field}}}" +
    "</div>"
  end

  def hash
    {
      "name": self.name,
      "qfmt": self.question_format,
      "afmt": self.answer_format
    }
  end
end