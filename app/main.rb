#!/usr/bin/ruby

require 'sinatra'
require 'erb'
require 'sass'
require './student'

configure do
  enable :sessions
  set :username, 'frank'
  set :password, 'sinatra'
end

configure :development do
  DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/student.db")
end

configure :production do
  DataMapper.setup(:default, ENV['DATABASE_URL'])
end

get('/styles.css'){ scss :styles }

get '/login' do
  erb :login
end

post '/login' do
  if params[:username] == settings.username &&
    params[:password] == settings.password
    session[:admin] = true
    redirect to ('/students')
  else
    erb :login
  end
end

get '/logout' do
  session.clear
  redirect to ("/")
end

get '/' do
  erb :home
end

get '/about' do
  @title = "All About This Website"
  erb :about
end

get '/contact' do
  erb :contact
end

not_found do
  erb :not_found
end

