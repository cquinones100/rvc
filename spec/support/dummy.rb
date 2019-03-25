require 'sinatra'
require './spec/support/index'

get '/' do
  Index.render
end
