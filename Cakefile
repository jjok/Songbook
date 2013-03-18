fs     = require 'fs'
{exec} = require 'child_process'

appFiles = [
  'src/App.coffee'
  'src/CrdFile/CrdFile.coffee'
  'src/CrdFile/CrdFileReader.coffee'
  'src/CrdFile/CrdFileStorage.coffee'
  'src/Parser/CrdFileParser.coffee'
  'src/Song/Line.coffee'
  'src/Song/Section.coffee'
  'src/Song/Song.coffee'
  'src/Settings.coffee'
  'src/SongWriter.coffee'
  'src/init.coffee'
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
    fs.writeFile 'src/combined.coffee', appContents.join('\n\n'), 'utf8', (err) ->
      throw err if err
      exec 'coffee -co app/static/js src/combined.coffee', (err, stdout, stderr) ->
        throw err if err
        console.log stdout + stderr
        fs.unlink 'src/combined.coffee', (err) ->
          throw err if err
          console.log 'Done.'
