require_relative "web-server-full"
require "test/unit"
require 'webrick'
require 'net/http'

class TestWebServer < Test::Unit::TestCase

  def initialize(test_method_name)
    super(test_method_name)
    @handlers = Handlers.new
  end

  def test_unit_hello
    status_code, content_type, body = @handlers.handle("/")
    assert_equal(200, status_code)
    assert_equal('text/plain', content_type)
    assert_equal('Hello, World', body)
  end

  def test_unit_api
    status_code, content_type, body = @handlers.handle("/api")
    assert_equal(201, status_code)
    assert_equal('application/json', content_type)
    assert_equal('{"foo":"bar"}', body)
  end

  def test_unit_404
    status_code, content_type, body = @handlers.handle("/invalid-path")
    assert_equal(404, status_code)
    assert_equal('text/plain', content_type)
    assert_equal('Not Found', body)
  end

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
    port = 8001
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
