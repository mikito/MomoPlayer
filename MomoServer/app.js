
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
    var playlist = {name : "Test", items : data.playlist, index : 0, join: 0};

    playlists.push(playlist);

    join(socket, playlists.length - 1);
    io.sockets.emit("playlists", playlists);
  });

  socket.on("join", function(data){
    console.log("join:" + playlists[data.playlistid].join);

    join(socket, data.playlistid);
    
    // Update Playlist Data
    io.sockets.emit("playlists", playlists);
  });

  socket.on("leave", function(data){
    console.log("leave");
    leave(socket);
  });

  socket.on("play", function(data){
    console.log("play");

    socket.get('playlist', function(err, playlist){
      console.log(data);
    });
  });

  // Disconenct
  socket.on('disconnect', function () {
    console.log('disconnect');
    leave(socket);
  });
});

function join(socket, playlistId){
  socket.join(playlistId);
  socket.set("playlist", playlists[playlistId]);
  playlists[playlistId].join++;
}

function leave(socket){
  socket.leave();
  socket.get('playlist', function(err, playlist){
    playlist.join--;
    console.log("join:" + playlist.join);

    if(playlist.join == 0){
      // Delete Playlist
    }

    // Update Playlist Data
    io.sockets.emit("playlists", playlists);
  });
}

