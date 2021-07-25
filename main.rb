require "pycall"
require "pandas"
genanki = PyCall.import_module("genanki")

require "./src/anki.rb"
require "./src/book.rb"
require "./src/card.rb"
require "./src/chapter.rb"
require "./src/character.rb"
require "./src/integer.rb"
require "./src/mnemonic.rb"
require "./src/palace.rb"
require "./src/room.rb"
require "./src/string.rb"
require "./src/verse.rb"

genesis = Kj::Bible.new.books[0]
Palace.new(genesis).card_pack.write_to_file("decks/Genesis.apkg")
