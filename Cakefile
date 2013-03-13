fs     = require 'fs'
{exec} = require 'child_process'

appFiles  = [
  # omit src/ and .coffee to make the below lines a little shorter
  'static/coffee/App.coffee'
  'static/coffee/CrdFile/CrdFile.coffee'
  'static/coffee/CrdFile/CrdFileReader.coffee'
  'static/coffee/CrdFile/CrdFileStorage.coffee'
  'static/coffee/Parser/CrdFileParser.coffee'
  'static/coffee/Song/Line.coffee'
  'static/coffee/Song/Section.coffee'
  'static/coffee/Song/Song.coffee'
  'static/coffee/Settings.coffee'
  'static/coffee/SongWriter.coffee'
  'static/coffee/init.coffee'
]
task 'build', 'Build single application file from source files', ->
  appContents = new Array remaining = appFiles.length
  for file, index in appFiles then do (file, index) ->
    console.log "Compiling #{file}"
    fs.readFile file, 'utf8', (err, fileContents) ->
      throw err if err
      appContents[index] = fileContents
      process() if --remaining is 0
  process = ->
    fs.writeFile 'static/coffee/combined.coffee', appContents.join('\n\n'), 'utf8', (err) ->
      throw err if err
      exec 'coffee -co static/js static/coffee/combined.coffee', (err, stdout, stderr) ->
        throw err if err
        console.log stdout + stderr
        fs.unlink 'static/coffee/combined.coffee', (err) ->
          throw err if err
          console.log 'Done.'