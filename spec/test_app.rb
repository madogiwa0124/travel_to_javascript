# frozen_string_literal: true

require 'sinatra/base'

class TestApp < Sinatra::Base
  get '/' do
    <<~HTML
      <!DOCTYPE html>
      <html lang="en">
        <head>
          <meta charset="utf-8">
          <link rel="icon" href="">
        <head>
        <body>
          Hello world!
        </body>
      </html>
    HTML
  end
end
