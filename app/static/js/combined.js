// Generated by CoffeeScript 1.6.2
(function() {
  var App, CrdFile, CrdFileParser, CrdFileReader, CrdFileStorage, Line, Section, Settings, Song, SongWriter,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  App = (function() {
    App.prototype.__selected_song = null;

    App.prototype.__touch_support = false;

    function App(__song_storage, __crd_file_reader, __crd_file_parser, __song_writer, __touch_support) {
      this.__song_storage = __song_storage;
      this.__crd_file_reader = __crd_file_reader;
      this.__crd_file_parser = __crd_file_parser;
      this.__song_writer = __song_writer;
      this.__touch_support = __touch_support;
      this.__deleteSong = __bind(this.__deleteSong, this);
      this.__addSong = __bind(this.__addSong, this);
      this.__displaySong = __bind(this.__displaySong, this);
      this.__showSongsheet = __bind(this.__showSongsheet, this);
      this.__showPanel = __bind(this.__showPanel, this);
    }

    App.prototype.initialise = function() {
      var doc;

      console.log("initialising app");
      this.__el_songbook = $("#songbook");
      this.__el_songsheet = $("#songsheet");
      this.__drawSongbook();
      this.__crd_file_reader.activate(this.__addSong);
      this.__el_app = $("#app");
      this.__el_panel = $("#panel");
      if (this.__touch_support) {
        doc = Hammer(document);
        doc.on("swiperight", this.__showPanel);
        return doc.on("swipeleft", this.__showSongsheet);
      } else {
        this.__el_panel.on("mouseenter", this.__showPanel);
        return this.__el_songsheet.on("mouseenter", this.__showSongsheet);
      }
    };

    App.prototype.__showPanel = function() {
      if (!this.__el_app.hasClass("showing-panel")) {
        return this.__el_app.addClass("showing-panel");
      }
    };

    App.prototype.__showSongsheet = function() {
      if (this.__selected_song !== null && this.__el_app.hasClass("showing-panel")) {
        return this.__el_app.removeClass("showing-panel");
      }
    };

    App.prototype.__drawSongbook = function() {
      var id, indexes, ul, _i, _len;

      indexes = this.__song_storage.retrieve("index");
      if (indexes.length === 0) {
        return this.__el_songbook.text("You haven't loaded any songs yet.");
      } else {
        ul = $(document.createElement("ul"));
        for (_i = 0, _len = indexes.length; _i < _len; _i++) {
          id = indexes[_i];
          ul.append(this.__getThumbnail(this.__song_storage.retrieve(id)));
        }
        return this.__el_songbook.html(ul);
      }
    };

    App.prototype.__getThumbnail = function(crd_file) {
      var button, li, thmb;

      thmb = this.__song_writer.toHtml(this.__crd_file_parser.parse(crd_file.content));
      thmb.attr("id", "song:" + crd_file.id);
      thmb.click(this.__displaySong);
      button = $(document.createElement("a"));
      button.attr("id", "delete:" + crd_file.id);
      button.attr("title", "Delete this song");
      button.text("X");
      button.click(this.__deleteSong);
      li = $(document.createElement("li"));
      li.append(thmb);
      li.append(button);
      return li;
    };

    App.prototype.__displaySong = function(e) {
      this.__selected_song = e.currentTarget.id.substr(5);
      return this.__el_songsheet.html(this.__song_writer.toHtml(this.__crd_file_parser.parse((this.__song_storage.getSong(this.__selected_song)).content)));
    };

    App.prototype.__addSong = function(song_content) {
      this.__song_storage.addSong(new CrdFile(null, song_content));
      return this.__drawSongbook();
    };

    App.prototype.__deleteSong = function(e) {
      this.__song_storage.removeSong(parseInt(e.target.id.substr(7)));
      return this.__drawSongbook();
    };

    return App;

  })();

  CrdFile = (function() {
    function CrdFile(id, content) {
      this.id = id;
      this.content = content;
    }

    return CrdFile;

  })();

  CrdFileReader = (function() {
    function CrdFileReader(__input, __fileReader) {
      this.__input = __input;
      this.__fileReader = __fileReader;
      this.__selectFile = __bind(this.__selectFile, this);
      this.__onError = __bind(this.__onError, this);
      this.__onLoad = __bind(this.__onLoad, this);
      this.__onProgress = __bind(this.__onProgress, this);
    }

    CrdFileReader.prototype.activate = function(callback) {
      this.__loaded_callback = callback;
      this.__fileReader.onprogress = this.__onProgress;
      this.__fileReader.onload = this.__onLoad;
      this.__fileReader.onerror = this.__onError;
      return $(this.__input).on("change", this.__selectFile);
    };

    CrdFileReader.prototype.__onProgress = function(e) {
      console.log("__onProgress");
      return console.log(e);
    };

    CrdFileReader.prototype.__onLoad = function(e) {
      console.log("__onLoad");
      return this.__loaded_callback(e.target.result);
    };

    CrdFileReader.prototype.__onError = function(e) {
      console.log("__onError");
      return console.log(e);
    };

    CrdFileReader.prototype.__selectFile = function() {
      return this.__fileReader.readAsText(this.__input.files[0], "UTF-8");
    };

    return CrdFileReader;

  })();

  CrdFileStorage = (function() {
    function CrdFileStorage() {
      var stored_index;

      this.index = [];
      stored_index = this.retrieve("index");
      if (stored_index === null) {
        this.store("index", this.index);
      } else {
        this.index = stored_index;
      }
    }

    CrdFileStorage.prototype.addSong = function(song) {
      song.id = this.__getNextId();
      this.store(song.id, song);
      this.index.push(song.id);
      return this.store("index", this.index);
    };

    CrdFileStorage.prototype.removeSong = function(id) {
      var i;

      localStorage.removeItem(id);
      i = this.index.indexOf(id);
      this.index.splice(i, 1);
      return this.store("index", this.index);
    };

    CrdFileStorage.prototype.getSong = function(id) {
      var obj;

      obj = this.retrieve(id);
      return new CrdFile(obj.id, obj.content);
    };

    CrdFileStorage.prototype.store = function(id, item) {
      return localStorage.setItem(id, JSON.stringify(item));
    };

    CrdFileStorage.prototype.retrieve = function(id) {
      return JSON.parse(localStorage.getItem(id));
    };

    CrdFileStorage.prototype.__getNextId = function() {
      var i, next, _i, _len, _ref;

      next = 0;
      _ref = this.index;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        i = _ref[_i];
        if (i > next) {
          next = i;
        }
      }
      return ++next;
    };

    return CrdFileStorage;

  })();

  CrdFileParser = (function() {
    function CrdFileParser() {}

    CrdFileParser.prototype.parse = function(file) {
      var section, sections, song, _i, _len;

      sections = file.split("\r\n\r\n");
      song = new Song;
      song.setTitle(sections.shift().slice(1, -1));
      for (_i = 0, _len = sections.length; _i < _len; _i++) {
        section = sections[_i];
        song.addSection(this.__parseSection(section));
      }
      return song;
    };

    CrdFileParser.prototype.__parseSection = function(raw_section) {
      var line, section, _i, _len, _ref;

      section = new Section;
      _ref = raw_section.split("\r\n");
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        line = _ref[_i];
        section.addLine(this.__parseLine(line));
      }
      return section;
    };

    CrdFileParser.prototype.__parseLine = function(raw_line) {
      var char, line, _i, _len, _ref;

      line = new Line;
      _ref = raw_line.split("");
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        char = _ref[_i];
        this.__parseChar(char, line);
      }
      return line;
    };

    CrdFileParser.prototype.__parseChar = function(char, line) {
      switch (char) {
        case "[":
          return line.switchToChords();
        case "]":
          return line.switchToLyrics();
        default:
          return line.add(char);
      }
    };

    return CrdFileParser;

  })();

  Line = (function() {
    function Line() {}

    Line.prototype.__chords = "";

    Line.prototype.__lyrics = "";

    Line.prototype.__current = "lyrics";

    Line.prototype.setCurrent = function(mode) {
      return this.__current = mode;
    };

    Line.prototype.switchToLyrics = function() {
      return this.__current = "lyrics";
    };

    Line.prototype.switchToChords = function() {
      this.setCurrent("chords");
      return this.__chords = this.__chords.slice(0, -1);
    };

    Line.prototype.add = function(char) {
      if (this.__current === "chords") {
        return this.__chords += char;
      } else {
        this.__chords += " ";
        return this.__lyrics += char;
      }
    };

    Line.prototype.getChords = function() {
      return this.__chords;
    };

    Line.prototype.getLyrics = function() {
      return this.__lyrics;
    };

    return Line;

  })();

  Section = (function() {
    function Section() {
      this.__title = "";
      this.__lines = [];
    }

    Section.prototype.getTitle = function() {
      return this.__title;
    };

    Section.prototype.setTitle = function(value) {
      return this.__title = value;
    };

    Section.prototype.getLines = function() {
      return this.__lines;
    };

    Section.prototype.addLine = function(line) {
      return this.__lines.push(line);
    };

    return Section;

  })();

  Song = (function() {
    function Song() {
      this.__sections = [];
    }

    Song.prototype.getTitle = function() {
      return this.__title;
    };

    Song.prototype.setTitle = function(value) {
      return this.__title = value;
    };

    Song.prototype.getSections = function() {
      return this.__sections;
    };

    Song.prototype.addSection = function(section) {
      return this.__sections.push(section);
    };

    return Song;

  })();

  Settings = (function() {
    function Settings() {}

    return Settings;

  })();

  SongWriter = (function() {
    var app, crd_file_reader, input, label;

    function SongWriter() {}

    SongWriter.prototype.toHtml = function(song) {
      var html_song, section, title, _i, _len, _ref;

      html_song = $(document.createElement("article"));
      title = $(document.createElement("h1"));
      html_song.append(title.text(song.getTitle()));
      _ref = song.getSections();
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        section = _ref[_i];
        html_song.append(this.__buildSection(section));
      }
      return html_song;
    };

    SongWriter.prototype.__buildSection = function(section) {
      var el, html_section, line, _i, _j, _len, _len1, _ref, _ref1;

      html_section = $(document.createElement("section"));
      _ref = section.getLines();
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        line = _ref[_i];
        _ref1 = this.__buildLine(line);
        for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
          el = _ref1[_j];
          html_section.append(el[0]);
        }
      }
      return html_section;
    };

    SongWriter.prototype.__buildLine = function(line) {
      var chords, lyrics;

      chords = $(document.createElement("div"));
      chords.text(line.getChords());
      chords.addClass("chords");
      lyrics = $(document.createElement("div"));
      lyrics.text(line.getLyrics());
      lyrics.addClass("lyrics");
      return [chords, lyrics];
    };

    if (!(Modernizr.filereader && Modernizr.localstorage)) {
      alert("Look, I'm all for \"keeping it old skool\", but you're going to have to update your browser to the latest version, to use this app.");
    }

    input = document.getElementById("file-input");

    crd_file_reader = new CrdFileReader(input, new FileReader);

    app = new App(new CrdFileStorage, crd_file_reader, new CrdFileParser, new SongWriter, Modernizr.touch);

    app.initialise();

    SongWriter.app = app;

    console.log(app);

    if (!!navigator.userAgent.match(/firefox/i)) {
      label = $("label[for='file-input']");
      console.log("FireFoxFix");
      label.on("click", function() {
        return $("#file-input")[0].click();
      });
    }

    return SongWriter;

  })();

}).call(this);
