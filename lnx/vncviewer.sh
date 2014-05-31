#!/bin/bash

server() {
echo "Starting VNCviewer! "
echo "listening for incoming connections ... "
exec vncviewer -listen -compresslevel 6 -quality 2 -depth 8 -bgr233 -owncmap
}

client() {
x11vnc -scale 3/4 -connect IP:5500
}

export -f server
exec xterm -e server