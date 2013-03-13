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
	#
	initialise: ->
		console.log "initialising app"
		@__songs_container = $ "#songbook"
		@__song_container = $ "#songsheet"
		@__displaySongThumbs()
		@__crd_file_reader.activate @__addSong
		
		@__app = $ "#app"
		@__panel = $ "#panel"
		
		if @__touch_support
			doc = Hammer document
			doc.on "swiperight", @__showPanel
			doc.on "swipeleft", @__showSongsheet
		else
			@__panel.on "mouseenter", @__showPanel
			@__song_container.on "mouseenter", @__showSongsheet
		
	__showPanel: =>
	#	console.log "__showPanel"
		@__app.addClass "showing-panel" if !@__app.hasClass "showing-panel"
		
	__showSongsheet: =>
	#	console.log "__showSongsheet"
		@__app.removeClass "showing-panel" if @__selected_song isnt null and @__app.hasClass "showing-panel"
	
	#
	# 
	#
	__displaySongThumbs: ->
		#console.log "__displaySongThumbs"
		ul = $ document.createElement "ul"
		ul.append @__getThumbnail @__song_storage.retrieve id for id in @__song_storage.retrieve "index"
		@__songs_container.html ul

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
		@__song_container.html @__song_writer.toHtml @__crd_file_parser.parse (@__song_storage.getSong @__selected_song).content
	
	__addSong:(song_content) =>
		@__song_storage.addSong new CrdFile null, song_content
		@__displaySongThumbs()
		
	__deleteSong: (e) =>
		#console.log "__deleteSong"
		@__song_storage.removeSong parseInt e.target.id.substr 7
		@__displaySongThumbs()
		
