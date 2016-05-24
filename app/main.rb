#!/usr/bin/ruby

require 'sinatra'
require 'erb'
require 'sass'
require './student'

#The following configure is used for session managament
configure do
  enable :sessions
  set :username, 'frank'
  set :password, 'sinatra'
end

#In develop mode we will be using the local student.db file
configure :development do
  DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/student.db")
end

#Tells the app what DB to use in production mode
configure :production do
  DataMapper.setup(:default, ENV['DATABASE_URL'])
end

#route to css
get('/styles.css'){ scss :styles }

#route to login
get '/login' do
  erb :login
end

#route to get the params back from the login page
post '/login' do
  if params[:username] == settings.username &&
    params[:password] == settings.password
    session[:admin] = true
    redirect to ('/students')
  else
    erb :login
  end
end

#route to logout page
get '/logout' do
  session.clear
  redirect to ("/")
end

#route to home page
get '/' do
  erb :home
end

#route to about page
get '/about' do
  @title = "All About This Website"
  erb :about
end

#route to contact page
get '/contact' do
  erb :contact
end

#What to diaplay when page is not found.
not_found do
  erb :not_found
end

