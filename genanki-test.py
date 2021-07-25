import genanki

model = genanki.Model(
  1, # Model id; should harcode this eventually
  "Bible",
  fields=[ # Eventually should be set up with hint, answer and mnemonic fields
    {"name": "Front"},
    {"name": "Back"}
  ],
  templates=[{
    "name": "Verse",
    "qfmt": "{{Front}}",
    "afmt": "{{Back}}"
  }]
)

deck = genanki.Deck(
  2, # Deck id; should harcode this eventually
  "Genesis"
)

note = genanki.Note(model=model, fields=["potato", "potato"])
deck.add_note(note)

note = genanki.Note(model=model, fields=["totato", "totato"])
deck.add_note(note)

package = genanki.Package(deck)
package.write_to_file("decks/Genesis7.apkg")