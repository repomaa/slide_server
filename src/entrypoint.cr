require "./slide_server"
path = ARGV.first? || "."

SlideServer.serve(path)
