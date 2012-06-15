# Set up the script to use bundler: http://gembundler.com/
require "rubygems"
require "bundler"

Bundler.require(:default)

# Include dependencies as per usual
require "rack"
require "rack/contrib"

# Turn off buffering for logging to allow realtime logs on heroku.
# See https://devcenter.heroku.com/articles/ruby
$stdout.sync = true

# Custom middleware to serve a static file if it's found, otherwise pass the request to the next app.
module Rack

  class StaticIfFound

    def initialize(app, options)
      @app = app
      @static = ::Rack::Static.new(lambda { [404, {}, []] }, options)
    end

    def call(env)
      resp = @static.call(env)
      if resp[0] != 404
      	return resp
      else
      	@app.call(env)
      end
    end

  end
end

# Default endpoint, displays the 404 page.
notFound = Rack::NotFound.new("public/404.html")

# Display any page under /public as if that was the root. index.html is the default index. Fall through to notfound if the file can't be serviced.
# app = Rack::Static.new(notfound, :urls => [""], :root => 'public', :index => "index.html")
staticIfFound = Rack::StaticIfFound.new(notFound, :urls => [""], :root => 'public', :index => "index.html")

# Start up the application.
run staticIfFound


