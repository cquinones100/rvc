require './spec/support/div_like_class'
require 'sinatra'

get '/' do
  DivLikeClass.render id: 'welcome' do
    'Hello!'
  end
end
