require_relative "web-server-basic"
require "test/unit"
require 'webrick'
require 'net/http'

class TestWebServer < Test::Unit::TestCase
  def test_integration_hello
    do_integration_test('/', lambda { |response|
      assert_equal(200, response.code.to_i)
      assert_equal('text/plain', response['Content-Type'])
      assert_equal('Hello, World', response.body)
    })
  end

  def test_integration_api
    do_integration_test('/api', lambda { |response|
      assert_equal(201, response.code.to_i)
      assert_equal('application/json', response['Content-Type'])
      assert_equal('{"foo":"bar"}', response.body)
    })
  end

  def test_integration_404
    do_integration_test('/invalid-path', lambda { |response|
      assert_equal(404, response.code.to_i)
      assert_equal('text/plain', response['Content-Type'])
      assert_equal('Not Found', response.body)
    })
  end

  def do_integration_test(path, check_response)
    port = 8002
    server = WEBrick::HTTPServer.new :Port => port
    server.mount '/', WebServer

    begin
      thread = Thread.new do
        server.start
      end

      uri = URI("http://localhost:#{port}#{path}")
      response = Net::HTTP.get_response(uri)
      check_response.call(response)
    ensure
      server.shutdown
      thread.join
    end
  end
end
