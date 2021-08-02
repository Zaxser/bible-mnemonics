require "kj"

class Kj::Chapter
  def self.model(*keys)
    templates = {
      # 1 card where you recite the verse from memory given every other word
      card: template("chapterCard", question: "html/chapterQuestion.html",
        answer: "html/chapterAnswer.html"),
      book: template("chapterReverse", 
        question: "html/chapterReverseQuestion.html",
        answer: "html/chapterReverseAnswer.html")
    }
  
    templates = keys == [] ? templates.values : keys.map {|key| templates[key]}
    
    fields = ["ChapterNumber", "ChapterMnemonic", "MnemonicExplanation"]
  
    @@model = $genanki.Model.new(
      4, # Model id; should be randomized and stored eventually
      "BibleChapterMemorization", # Model Name
      css: File.open("css/mnemonic_cards.css").read(),
      fields: fields.fields,
      templates: templates
    )
  end

  @@model = self.model

  def fields
    fields = [self.number, self.mnemonic.device, self.mnemonic.explanation]
    fields.map! {|f| Rack::Utils.escape_html(f)}
  end

  def note
    $genanki.Note.new(model: @@model, fields: self.fields)
  end

  def mnemonic
    self.number.mnemonic
  end
end