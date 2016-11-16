require 'net/http'

if ARGV.length != 3
  raise 'Invalid args. Usage: terraform-test.rb REGION DB_BUCKET DB_KEY'
end

vars = {
    # A unique (ish) 6-char string: http://stackoverflow.com/a/88341/483528
    :cluster_name => (0...6).map { (65 + rand(26)).chr }.join,
    :aws_region => ARGV[0],
    :db_remote_state_bucket => ARGV[1],
    :db_remote_state_key => ARGV[2],
}
vars_string = vars.map{|key, value| "-var '#{key} = \"#{value}\"'"}.join(', ')

def test_url(url, expected_text, retries)
  retries.times do
    begin
      output = Net::HTTP.get(URI.parse(url))
      puts "Output from #{url}: #{output}"
      return 'Success!' if output.include? expected_text
    rescue => e
      puts "Error from #{url}: #{e}"
    end

    puts 'Sleeping for 30 seconds and trying again'
    sleep 30
  end

  raise "Response didn't contain '#{expected_text}' after #{retries} retries"
end

begin
  puts "Deploying code in #{Dir.pwd}"
  puts `terraform get 2>&1`
  puts `terraform apply #{vars_string} 2>&1`

  elb_dns_name = `terraform output -no-color elb_dns_name`
  puts test_url("http://#{elb_dns_name.strip}/", 'Hello, World', 10)
ensure
  puts "Undeploying code in #{Dir.pwd}"
  puts `terraform destroy -force #{vars_string} 2>&1`
end
