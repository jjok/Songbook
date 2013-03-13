#
#
#
class CrdFileReader

	#
	#
	#
	constructor: (@__input, @__fileReader) ->

	#
	# 
	# @param callback {function}
	#
	activate: (callback) ->
		@__loaded_callback = callback
		@__fileReader.onprogress = @__onProgress
		@__fileReader.onload = @__onLoad
		@__fileReader.onerror = @__onError
		$(@__input).on "change", @__selectFile

	__onProgress: (e) =>
		console.log "__onProgress"
		console.log e

	__onLoad: (e) =>
		console.log "__onLoad"
		@__loaded_callback e.target.result
		
	__onError: (e) =>
		console.log "__onError"
		console.log e

	__selectFile: =>
		@__fileReader.readAsText @__input.files[0], "UTF-8"
