require "kj"
require "pandas"
require "pycall"
$genanki = PyCall.import_module("genanki")
require "rack/utils"

require "./src/object.rb"
require "./src/template.rb"
require "./src/array.rb"
require "./src/action.rb"
require "./src/animal.rb"
require "./src/book.rb"
require "./src/chapter.rb"
require "./src/character.rb"
require "./src/integer.rb"
require "./src/mnemonic.rb"
require "./src/palace.rb"
require "./src/person.rb"
require "./src/room.rb"
require "./src/string.rb"
require "./src/verse.rb"

genesis = Kj::Bible.new.books[0]
palace = Palace.new(genesis)
palace.card_pack.write_to_file("decks/Genesis.apkg")
palace.mnemonic_lesson_pack.write_to_file("decks/mnemonic-lesson-Genesis.apkg")