#
#
#
class Line
	
	__chords: ""
	
	__lyrics: ""
	
	#
	# The current write mode.
	# @var {String}
	#
	__current: "lyrics"
	
	#
	# Set the current line write mode
	# @param {String} mode The mode to be set. "chords"|"lyrics"
	#
	setCurrent: (mode) ->
		@__current = mode
	
	switchToLyrics: ->
		@__current = "lyrics"
	
	# 
	switchToChords: ->
		@setCurrent "chords"
		@__chords = @__chords.slice 0, -1
	
	add: (char) ->
		if @__current is "chords"
			@__chords += char
			
		else
			@__chords += " "
			@__lyrics += char
		
	getChords: ->
		return @__chords
	
	getLyrics: ->
		return @__lyrics
	