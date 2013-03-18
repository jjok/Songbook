
class CrdFileParser

	#
	# @param 
	# @return Song
	#
	parse: (file) ->
	
		sections = file.split "\r\n\r\n"
		#console.log sections
		song = new Song
		song.setTitle sections.shift().slice 1, -1
		song.addSection @__parseSection section for section in sections
		#console.log song
		
		return song
	
	#
	# @return Section
	#
	__parseSection: (raw_section) ->
		
		section = new Section
		section.addLine @__parseLine line for line in raw_section.split "\r\n"
		
		#console.log section
		return section
	
	#
	# @return Line
	#
	__parseLine: (raw_line) ->		
		line = new Line
		@__parseChar char, line for char in raw_line.split ""
		#console.log line
		
		return line
	
	#
	#
	#
	__parseChar: (char, line) ->
		switch char
			#when "[" then line.setCurrent "chords"
			when "[" then line.switchToChords()
			#when "]" then line.setCurrent "lyrics"
			when "]" then line.switchToLyrics()
			else line.add char
	