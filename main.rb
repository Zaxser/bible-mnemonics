require "pycall"
require "pandas"

require "./src/anki.rb"
require "./src/book.rb"
require "./src/card.rb"
require "./src/chapter.rb"
require "./src/character.rb"
require "./src/integer.rb"
require "./src/mnemonic.rb"
require "./src/room.rb"
require "./src/string.rb"
require "./src/verse.rb"


## Little test
# (1..50).each do |i|
#   p i.mnemonic
# end

p genesis = Kj::Bible.new.books[0]
# p verse = genesis.chapters[0].verses[0]
# p verse.text
# print verse.cards

# deck = Anki2.new({
#   css: "css/mnemonic_cards.css",
#   name: "Genesis",
#   output_path: "decks/Genesis.apkg"
# })

genanki = PyCall.import_module("genanki")

model = genanki.Model.new(
  1, # Model id; should harcode this eventually
  "Bible",
  fields: [ # Eventually should be set up with hint, answer and mnemonic fields
    {"name": "Front"},
    {"name": "Back"}
  ],
  templates:[{
    "name": "Verse",
    "qfmt": "{{Front}}",
    "afmt": "{{Back}}"
  }]
)

deck = genanki.Deck.new(
  2, # Deck id; should harcode this eventually
  "Genesis"
)

genesis.chapters.each do |chapter|
  p chapter.number
  chapter.verses.each do |verse|
    verse.cards.each do |card|
      note = genanki.Note.new(model: model, fields: [
        card.front,
        card.back
      ])
      deck.add_note(note)
    end
  end
end

p deck
package = genanki.Package.new(deck)
p package
package.write_to_file("decks/Genesis.apkg")
