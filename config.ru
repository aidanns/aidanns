require "rubygems"
require "bundler"

Bundler.require(:default)

# Turn off buffering for logging to allow realtime logs on heroku.
# See https://devcenter.heroku.com/articles/ruby
$stdout.sync = true

map "/" do
	use Rack::Static, 
		:urls => ["/css", "/js", "/img"], 
		:root => Dir.pwd

	run lambda { |env|

		headers = {
			"Content-Type" => "text/html",
			"Cache-Control" => "public, max-age=86400"
		}

		body = File.open("#{Dir.pwd}/index.html", File::RDONLY).read

		[200, headers, [body]]
	}
end