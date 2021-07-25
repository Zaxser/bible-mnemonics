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

p genesis = Kj::Bible.new.books[1]
p verse = genesis.chapters[0].verses[0]
p verse.text
p verse.mnemonic
