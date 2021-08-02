# These are the actions in my PAO system; I suspect "action" is still not a
# great object name, but naming things is the hardest problem in programming

class Action
  @@objects = Pandas.read_excel("Mnemonics.xlsx", sheet_name="Actions")

  @@mnemonics = Hash.new {|h, k| h[k] = Mnemonic.from_sheet(k, @@objects)}  

  attr_accessor :character, :name, :explanation
  def self.model
    templates = [
      template("actionCard", question: "html/actionQuestion.html",
        answer: "html/actionAnswer.html")
    ]
   
    fields = ["Letter", "Action", "ActionExplanation", "LetterImage"]
  
    @@model = $genanki.Model.new(
      rand(1 << 30..1 << 31), # Model id; should be randomized and stored eventually
      "ActionMemorization", # Model Name
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
    fields += ["<img src=\"#{self.character}.jpg\">"]
  end

  def note
    $genanki.Note.new(model: @@model, fields: fields)
  end
  
  def to_s
    self.name
  end
end