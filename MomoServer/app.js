
/**
 * Module dependencies.
 */

var express = require('express');
var socketIO = require('socket.io');
var timer = require('timers');

var app = module.exports = express.createServer();

// Configuration

app.configure(function(){
  app.set('views', __dirname + '/views');
  app.set('view engine', 'jade');
  app.use(express.bodyParser());
  app.use(express.methodOverride());
  app.use(app.router);
  app.use(express.static(__dirname + '/public'));
});

app.configure('development', function(){
  app.use(express.errorHandler({ dumpExceptions: true, showStack: true })); 
});

app.configure('production', function(){
  app.use(express.errorHandler()); 
});

// Routes

app.get('/', function(req, res){
  res.render('index', {
    title: 'MomoPlayerServer'
  });
});

var playlists = [];

app.listen(3000);
console.log("Express server listening on port %d in %s mode", app.address().port, app.settings.env);

var io = socketIO.listen(app);

io.sockets.on('connection', function(socket){
  console.log('connection');

  socket.emit('playlists', playlists);

  socket.on("makePlayList", function(data){
    console.log("makePlayList");

    // Make Playlist Data
    var playlist = {name : "Test", items : data.playlist, index : 0, join: 1};

    playlists.push(playlist);

    socket.join(playlists.length - 1);
    socket.set("playlist", playlists[playlists.length - 1]);

    io.sockets.emit("playlists", playlists);
  });

  socket.on("join", function(data){
    socket.join(data.playlistid);
    socket.set("playlist", playlists[data.playlistid]);
    playlists[data.playlistid].join++;
    console.log("join:" + playlists[data.playlistid].join);
  });

  socket.on("leave", function(data){
    console.log("leave");
    socket.leave();
    socket.get('playlist', function(err, playlist){
      playlist.join--;
      console.log("join:" + playlist.join);
    });
  });

  socket.on("next", function(data){
    socket.get('playlist', function(err, playlist){
      console.log(data);
    });
  });

  // Disconenct
  socket.on('disconnect', function () {
    console.log('disconnect');

  });
});

