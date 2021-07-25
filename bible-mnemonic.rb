require "kj"
require "anki2"
# require "pandas"

p genesis = Kj::Bible.new.books[1]
p genesis.chapters[0].verses[0].text

# books = Kj::Bible.new.books

# books.each do |book|
#   p [book.name, book.chapters.length]
# end