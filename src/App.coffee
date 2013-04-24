#
#
#
class App

	__selected_song: null
	
	__touch_support: false
	
	#
	# 
	# @param
	# @param
	# @param
	# @param
	# @param
	#
	constructor: (@__song_storage, @__crd_file_reader, @__crd_file_parser, @__song_writer, @__touch_support) ->

	#
	# Initialise the application.
	# @todo Move all this to init.coffee and make the methods public.
	#
	initialise: ->
		console.log "initialising app"
		@__el_songbook = $ "#songbook"
		@__el_songsheet = $ "#songsheet"
		@__el_app = $ "#app"
		@__el_panel = $ "#panel"
		
		@__drawSongbook()
		@__crd_file_reader.activate @__addSong
		
		if !@__touch_support
			@__el_panel.on "mouseenter", @showPanel
			@__el_songsheet.on "mouseenter", @showSongsheet
		
	
	showPanel: =>
	#	console.log "showPanel"
		@__el_app.addClass "showing-panel" if !@__el_app.hasClass "showing-panel"
		
	showSongsheet: =>
	#	console.log "showSongsheet"
		@__el_app.removeClass "showing-panel" if @__selected_song isnt null and @__el_app.hasClass "showing-panel"
	
	#
	# @todo Only display songs if there are some.
	#
	__drawSongbook: ->
		#console.log "__drawSongbook"
		indexes = @__song_storage.retrieve "index"
		if indexes.length is 0
			@__el_songbook.text "You haven't loaded any songs yet."
		
		else
			ul = $ document.createElement "ul"
			ul.append @__getThumbnail @__song_storage.retrieve id for id in indexes
			@__el_songbook.html ul

	#
	# Build a thumbnail of a song.
	# @param song {CrdFile}
	# @return {Element}
	#
	__getThumbnail: (crd_file) ->
		#console.log "__getThumbnail"
		thmb = @__song_writer.toHtml @__crd_file_parser.parse crd_file.content
		thmb.attr "id", "song:" + crd_file.id
		thmb.click @__displaySong

		button = $ document.createElement "a"
		button.attr "id", "delete:" + crd_file.id
		button.attr "title", "Delete this song"
		button.text "X"
		button.click @__deleteSong
		
		li = $ document.createElement "li"
		li.append thmb
		li.append button
		
		return li

	__displaySong: (e) =>
		#console.log "__displaySong"
		@__selected_song = e.currentTarget.id.substr 5
		@__el_songsheet.html @__song_writer.toHtml @__crd_file_parser.parse (@__song_storage.getSong @__selected_song).content
	
	#
	# Store a new song from a string.
	# @param song_content {String} The content of the song file.
	#
	__addSong:(song_content) =>
		@__song_storage.addSong new CrdFile null, song_content
		@__drawSongbook()
	
	#
	# Delete a song and redraw songbook.
	#
	__deleteSong: (e) =>
		#console.log "__deleteSong"
		@__song_storage.removeSong parseInt e.target.id.substr 7
		@__drawSongbook()
