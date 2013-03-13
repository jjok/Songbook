
class CrdFileStorage

	constructor: ->
		@index = []
		stored_index = @retrieve "index"
		if stored_index is null
			@store "index", @index
		else
			@index = stored_index

	addSong: (song) ->
		song.id = @__getNextId()
		@store song.id, song
		@index.push song.id
		@store "index", @index

	#
	# Delete the song and remove it's ID from the index
	#
	removeSong: (id) ->
		#console.log "removeSong"
		localStorage.removeItem id
		i = @index.indexOf id
		@index.splice i, 1
		@store "index", @index

	getSong: (id) ->
		obj = @retrieve id
		new CrdFile obj.id, obj.content

	store: (id, item) ->
		localStorage.setItem id, JSON.stringify item
		
	retrieve: (id) ->
		JSON.parse localStorage.getItem id
	
	# @todo Do this better, probably.
	__getNextId: ->
		next = 0
		#console.log @index
		for i in @index
			#console.log i
			next = i if i > next
		#console.log "new ID: #{next}"
		++next
