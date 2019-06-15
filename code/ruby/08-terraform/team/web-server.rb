require 'webrick'
require 'net/http'

class WebServer < WEBrick::HTTPServlet::AbstractServlet
  def do_GET(request, response)
    web_service = WebService.new("http://www.example.org")
    handlers = Handlers.new(web_service)

    status_code, content_type, body = handlers.handle(request.path)

    response.status = status_code
    response['Content-Type'] = content_type
    response.body = body
  end
end

class Handlers
  def initialize(web_service)
    @web_service = web_service
  end

  def handle(path)
    case path
    when "/"
      self.hello
    when "/api"
      self.api
    when "/web-service"
      self.web_service
    else
      self.not_found
    end
  end

  def hello
    [200, 'text/plain', 'Hello, World v2']
  end

  def api
    [201, 'application/json', '{"foo":"bar"}']
  end

  def web_service
    @web_service.proxy
  end

  def not_found
    [404, 'text/plain', 'Not Found']
  end
end

class WebService
  def initialize(url)
    @uri = URI(url)
  end

  def proxy
    response = Net::HTTP.get_response(@uri)
    [response.code.to_i, response['Content-Type'], response.body]
  end
end

# This will only run if this script was called directly from the CLI, but
# not if it was required from another file
if __FILE__ == $0
  # Run the server on localhost at port 8000
  server = WEBrick::HTTPServer.new :Port => 8000
  server.mount '/', WebServer

  # Shut down the server on CTRL+C
  trap 'INT' do server.shutdown end

  # Start the server
  server.start
end

