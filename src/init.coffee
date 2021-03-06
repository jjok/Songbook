#
# Initialise the application.
#

	unless Modernizr.filereader and Modernizr.localstorage
	    alert "Look, I'm all for \"keeping it old skool\", but you're going to have to update your browser to the latest version, to use this app."
		
	#input = $ 'input[type="file"]'
	#console.log input
	input = document.getElementById "file-input"
	crd_file_reader = new CrdFileReader input, new FileReader
	
	app = new App new CrdFileStorage, crd_file_reader, new CrdFileParser, new SongWriter, Modernizr.touch
	app.initialise()

	# debug
	@app = app
	console.log app
	
	if Modernizr.touch
		doc = Hammer document
		doc.on "swiperight", @showPanel
		doc.on "swipeleft", @showSongsheet
	
	# FireFoxFix
	if !!navigator.userAgent.match /firefox/i
	    label = $ "label[for='file-input']"
	    console.log "FireFoxFix"
	    label.on "click", ->
	        $("#file-input")[0].click()
