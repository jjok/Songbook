#
#
#
class Section

	constructor: ->
		@__title = ""
		@__lines = []

	getTitle: ->
		return @__title

	setTitle: (value) ->
		@__title = value
	
	getLines: ->
		return @__lines
	
	addLine: (line) ->
		@__lines.push line
