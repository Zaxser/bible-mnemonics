# bible-mnemonics

If you're thinking about trying my anki decks, the outputted anki decks so far
are in the decks folder. If you want to generate your own deck with custom
mnemonics, then you can edit the README and run ruby main.rb. I haven't made a
gemfile for this yet, 

This project currently makes Anki cards, with mnemonics for each verse in
Genesis, in the hopes that this helps people memorize the Bible, greatly 
influenced by all the Remember the Kanji Anki decks that you can find on
AnkiWeb. The mnemonics for this set are structured like a memory palace. To help
people with "Random Recall," each room has a floor based on the chapter, walls
base on the verse, and a window base on the book. There are different theories
as to how to organize things within a room to memorize the contents. In this
case, we try to remember the first letter of each word, with mnemonics based on
the PAO system. So, for example, the Mnemonic for Genesis 1:1 is:

The floor is made of fur. The walls are made of fur. In the window, you can see 
a Garden. The ceiling is made of an enormous circular, analog clock-face. There 
are 4 people in the room. Iscariot throws butterfly. Goliath cooks t-rex. Herod 
absorbs t-rex. Eve takes a bow. Ahead of you, you see a door, on it, you see 
Apollyon throws elephant.

Fur floor represents chapter 1; fur walls represents verse 1. The Garden
represent Genesis. The clock ceiling represents the next chapter, chapter 2,
and is just to keep track of the structure of the build The characters in the
room represent ITBGCTHATE, i.e. "In the beginning, God created the Heavens and
the Earth."

"Apollyon throws Elephant" represents "And the earth..." from the next verse,
and is there to help connect the verse to the next one.

Obviously, the whole thing needs a lot of punching up. While part of forming a
memory palace is to visualize as it you walk through it, I feel that it's
important that a good mnemonic invite you to form strong visual connections.

The current state of this project is the most minimal of minimum viable
products. I currently have mnemonics for chapters and verses going up to 52,
while the longest chapter of the Bible, Psalm 119, has 176 verses. By the same
token, I also only have mnemonics for a fraction of the books of the bible.
Plus, there is much more I'd like to add.

Some quick TODOs

* add more styling to cards so that they look better
* finish making the mnemonics so that the can encompass the entire bible
* punching up the descriptions of the characters and their actions to make them
  more memorable
* add audio to each card, reading the verses
* add procedurally generated images (or interactive 3-D models?) for each card
* add cards that teach the mnemonic system as you go through the Bible, in the
same spirit as "Remember the Kanji" and Wanikani.
* add automated testing the project
* possibly migrate the cards into some sort of gamified online service, in the
spirit of Khan Academy.
* add typing input, in the same spirit as WaniKani and scripture typer
* move the mnemonics to a real database rather than a spreadsheet
* generate and save genanki objects in some reasonable way
* add an actual GEMFILE so people can get this thing working reasonably; this
may be slightly tricky as this uses PyCall to call genanki, a Python library
* actually, it would also be nice to either take genanki and either wrap it in a 
gem or recreate it in Ruby; every ruby gem for Anki is missing core features 
that Python's genanki has. We can even take the Japanization theme a lot of Ruby 
library's have and call it "Kyoushitsu" or something like that.

I'm really excited to get started on this, other than WaniKani and RTK, there
aren't very many things that are even the ballpark of what I'm trying to do
here. 

Here are the closest I've found so far:

* https://github.com/jm-moreau/anki-pao-bootstrap-style

I also really need to look at this to explore what I can do with Anki to extend
this project.

* https://github.com/topics/anki-theme
* https://github.com/asdfgeoff/anki-templates/tree/master/mental-models
* https://www.juliensobczak.com/write/2016/12/26/anki-scripting.html
* https://github.com/jm-moreau/anki-pao-bootstrap-style
* https://github.com/sobjornstad/AnkiLPCG
* https://github.com/mmjang/ankihelper
