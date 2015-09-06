require 'sinatra'
require 'yaml/store'


Choices = {
  'HAM' => 'Juicy Cheesy Old-Fashioned Hamburgers',
  'PIZ' => 'Overloaded Meat Pizza With All the Dips You Like',
  'CUR' => 'Savoury Indian Butter Chicken Served with Roti',
  'NOO' => 'Hearty Wonton Hand-Pulled Noodle Soup',
}

get '/' do
  @title = 'Saturday Dinner Poll!'
  erb :index
end

post '/cast' do
  @title = 'Thanks for casting your vote!'
  @vote  = params['vote']
  @store = YAML::Store.new 'votes.yml'
  @store.transaction do
    @store['votes'] ||= {}
    @store['votes'][@vote] ||= 0
    @store['votes'][@vote] += 1
  end
  erb :cast
end

get '/results' do
  @title = 'Results so far:'
  @store = YAML::Store.new 'votes.yml'
  @votes = @store.transaction { @store['votes'] }
  erb :results
end