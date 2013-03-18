#
# Build HMTL from a Song.
# @author Jonathan Jefferies (jjok)
#
class SongWriter

	#
	# Create an article element for the song.
	# @param {Song}
	# @return {Element}
	#
	toHtml: (song) ->
		html_song = $ document.createElement "article"
		title = $ document.createElement "h1"
		
		html_song.append title.text song.getTitle()
		html_song.append @__buildSection section for section in song.getSections()
		
		return html_song
	
	#
	# Convert a song section to a section element.
	# @param {Section}
	# @return {Element} The section element.
	#
	__buildSection: (section) ->
		html_section = $ document.createElement "section"
		html_section.append el[0] for el in @__buildLine line for line in section.getLines()
		
		return html_section
	
	#
	# Convert a Line to two divs.
	# @param {Line} The song line.
	# @return {Array}
	#
	__buildLine: (line) ->
		chords = $ document.createElement "div"
		chords.text line.getChords()
		chords.addClass "chords"
		
		lyrics = $ document.createElement "div"
		lyrics.text line.getLyrics()
		lyrics.addClass "lyrics"
		
		[chords, lyrics]
