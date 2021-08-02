class Person
  @@people = Pandas.read_excel("Mnemonics.xlsx", sheet_name="People")

  @@mnemonics = Hash.new {|h, k| h[k] = Mnemonic.from_sheet(k, @@people)}

  attr_accessor :character, :name, :explanation
  def self.model
    templates = [
      template("personeCard", question: "html/personQuestion.html",
        answer: "html/personAnswer.html")
    ]
   
    fields = ["Letter", "Person", "PersonExplanation", "LetterImage"]
  
    @@model = $genanki.Model.new(
      rand(1 << 30..1 << 31), # Model id; should be randomized and stored eventually
      "ObjectMemorization", # Model Name
      css: File.open("css/mnemonic_cards.css").read(),
      fields: fields.fields,
      templates: templates
    )
  end

  @@model = self.model

  def initialize(character)
    self.character = character
    self.name = @@mnemonics[character].device
    self.explanation = @@mnemonics[character].explanation
  end

  def fields
    fields = [self.character, self.name, self.explanation]
    fields.map! {|f| Rack::Utils.escape_html(f)}
    fields += ["<img class=\"letter-image\" src=\"#{self.character}.jpg\">"]
  end

  def note
    $genanki.Note.new(model: @@model, fields: self.fields)
  end

  def to_s
    self.name
  end
end