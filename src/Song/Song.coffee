#
#
#
class Song

	#__title: ""

	#__sections: []
	constructor: ->
		@__sections = []
	
	getTitle: ->
		return @__title
	
	setTitle: (value) ->
		@__title = value
	
	getSections: ->
		return @__sections
	
	addSection: (section) ->
		@__sections.push section
	