require_relative "web-server"
require "test/unit"
require 'webrick'
require 'net/http'

class TestWebServer < Test::Unit::TestCase
  def initialize(test_method_name)
    super(test_method_name)
    mock_web_service = MockWebService.new([200, 'text/html', 'mock example.org'])
    @handlers = Handlers.new(mock_web_service)
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

  def test_unit_web_service
    expected_status = 200
    expected_content_type = 'text/html'
    expected_body = 'mock example.org'
    mock_response = [expected_status, expected_content_type, expected_body]

    mock_web_service = MockWebService.new(mock_response)
    handlers = Handlers.new(mock_web_service)

    status_code, content_type, body = handlers.handle("/web-service")
    assert_equal(expected_status, status_code)
    assert_equal(expected_content_type, content_type)
    assert_equal(expected_body, body)
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

  def test_integration_web_service
    do_integration_test('/web-service', lambda { |response|
      assert_equal(200, response.code.to_i)
      assert_include(response['Content-Type'], 'text/html')
      assert_include(response.body, 'Example Domain')
    })
  end

  def do_integration_test(path, check_response)
    port = 8000
    server = WEBrick::HTTPServer.new :Port => port
    server.mount '/', WebServer

    begin
      # Start the web server in a separate thread so it
      # doesn't block the test
      thread = Thread.new do
        server.start
      end

      # Make an HTTP request to the web server at the
      # specified path
      uri = URI("http://localhost:#{port}#{path}")
      response = Net::HTTP.get_response(uri)

      # Use the specified check_response lambda to validate
      # the response
      check_response.call(response)
    ensure
      # Shut the server and thread down at the end of the
      # test
      server.shutdown
      thread.join
    end
  end
end

class MockWebService
  def initialize(response)
    @response = response
  end

  def proxy
    @response
  end
end
