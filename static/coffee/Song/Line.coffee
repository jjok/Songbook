#
#
#
class Line
	
	__chords: ""
	
	__lyrics: ""
	
	__current: "lyrics"
		
	setCurrent: (mode) ->
		@__current = mode
	
	add: (char) ->
	
		#FIXME Not sure where to do this...
		#if char is "["
		#	@__chords = @__chords.slice 0, -1
		if @__current is "chords"
			@__chords += char
			
		else
			@__chords += " "
			@__lyrics += char
		
	getChords: ->
		return @__chords
	
	getLyrics: ->
		return @__lyrics
	