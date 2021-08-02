class Kj::Book
  @@book = Pandas.read_excel("Mnemonics.xlsx", sheet_name="Books")
  
  @@mnemonics = Hash.new do |hash, key| 
    hash[key] = Mnemonic.from_sheet(key, @@book)
  end

  def self.model(*keys)
    templates = {
      # 1 card where you recite the verse from memory given every other word
      card: template("bookCard", question: "html/bookQuestion.html",
        answer: "html/bookAnswer.html"),
      book: template("bookReverse", question: "html/bookReverseQuestion.html",
        answer: "html/bookReverseAnswer.html")
    }
  
    templates = keys == [] ? templates.values : keys.map {|key| templates[key]}
    
    fields = ["BookName", "BookMnemonic", "MnemonicExplanation"]
  
    @@model = $genanki.Model.new(
      3, # Model id; should be randomized and stored eventually
      "BibleBookMemorization", # Model Name
      css: File.open("css/mnemonic_cards.css").read(),
      fields: fields.fields,
      templates: templates
    )
  end

  @@model = self.model

  def mnemonic
    @@mnemonics[self.name]
  end

  def palace
    Palace.new(self)
  end

  def fields
    fields = [self.name, self.mnemonic.device, self.mnemonic.explanation]
    fields.map! {|f| Rack::Utils.escape_html(f)}
  end

  def note
    $genanki.Note.new(model: @@model, fields: self.fields)
  end
end