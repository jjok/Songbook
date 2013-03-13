#
# Build HMTL from a Song.
# @author Jonathan Jefferies (jjok)
#
class SongWriter


	toHtml: (song) ->
		html_song = $ document.createElement "article"
		title = $ document.createElement "h1"
		
		html_song.append title.text song.getTitle()
		html_song.append @__buildSection section for section in song.getSections()
		
		return html_song
		
	__buildSection: (section) ->
		#console.log section
		html_section = $ document.createElement "section"
		html_section.append el[0] for el in @__buildLine line for line in section.getLines()
		
		return html_section
	
	__buildLine: (line) ->
		chords = $ document.createElement "div"
		chords.text line.getChords()
		chords.addClass "chords"
		
		lyrics = $ document.createElement "div"
		lyrics.text line.getLyrics()
		lyrics.addClass "lyrics"
		
		#TODO get rid of this
		#container = $ document.createElement "div"
		#container.append chords
		#container.append lyrics
		
		#return container
		[chords, lyrics]
