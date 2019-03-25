require 'sinatra'
require "sinatra/reloader" if development?
require './spec/support/index'

also_reload './spec/support/index'

get '/' do
  Index.render
end
