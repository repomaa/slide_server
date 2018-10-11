require "baked_file_system"
require "http/server"

module SlideServer
  class FileStorage
    extend BakedFileSystem
    bake_folder "../public"
  end

  class StaticFileHandler
    include HTTP::Handler

    def call(context)
      path = context.request.path
      file = FileStorage.get?(
        path[-1] == '/' ? "#{path}index.html" : path
      )
      return call_next(context) if file.nil?
      context.response.content_type = file.mime_type
      IO.copy(file, context.response)
    end
  end

  class SlideServerHandler
    include HTTP::Handler

    def initialize(@base_path : String)
    end

    def call(context)
      slide_path_cookie = context.request.cookies["SlidePath"]?
      return call_next(context) unless slide_path_cookie

      path = File.expand_path("./#{slide_path_cookie.value}", @base_path)

      unless File.expand_path(path) > File.expand_path(@base_path)
        return call_next(context)
      end

      unless context.request.path == "/slides.md" && File.exists?(path)
        return call_next(context)
      end

      context.response.content_type = "text/markdown"
      File.open(path) do |file|
        IO.copy(file, context.response)
      end
    end
  end

  class SlidePathHandler
    include HTTP::Handler

    def initialize(@path : String)
    end

    def call(context)
      return call_next(context) unless context.request.path[-3..-1] == ".md"
      path = File.join(@path, context.request.path)
      return call_next(context) unless File.exists?(path)
      context.response.cookies["SlidePath"] = context.request.path
      context.request.path = "/index.html"
      call_next(context)
    end
  end

  def self.slide_path_handler(path)
    SlidePathHandler.new(path)
  end

  def self.static_file_handler
    StaticFileHandler.new
  end

  def self.slides_handler(path)
    SlideServerHandler.new(path)
  end

  def self.serve(path)
    server = HTTP::Server.new([
      slide_path_handler(path),
      static_file_handler,
      slides_handler(path)
    ])

    host = ENV.fetch("SLIDE_SERVER_HOST", "localhost")
    port = ENV.fetch("SLIDES_PORT", "3000").to_i

    puts "Starting slides on #{host}:#{port}"
    server.listen(host, port)
  end
end
