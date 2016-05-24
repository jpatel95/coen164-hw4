#!/usr/bin/ruby

require 'dm-core'
require 'dm-migrations'

DataMapper::Logger.new($stdout, :debug)
DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/student.db")

class Student
  include DataMapper::Resource
  property :id, Serial
  property :name, Text
  property :quote, Text
  property :age, Integer
  property :birthday, Date
  
  def released_on=date
    super Date.strptime(date, '%m/%d/%Y')
  end
end
DataMapper.auto_upgrade!

configure do
  enable :sessions
  set :username, 'frank'
  set :password, 'sinatra'
end

DataMapper.finalize

get '/students' do
  @students = Student.all
  erb :students
end

get '/students/new' do
  halt(401, "Not Authorized") unless session[:admin]
  @student = Student.new
  erb :new_student
end

get '/students/:id' do
  @student = Student.get(params[:id])
  erb :show_student
end

get '/students/:id/edit' do
  halt(401, "Not Authorized") unless session[:admin]
  @student = Student.get(params[:id])
  erb :edit_student
end

post '/students' do  
  student = Student.create(params[:student])
  redirect to("/students/#{student.id}")
end

put '/students/:id' do
  student = Student.get(params[:id])
  student.update(params[:student])
  redirect to("/students/#{student.id}")
end

delete '/students/:id' do
  halt(401, "Not Authorized") unless session[:admin]
  Student.get(params[:id]).destroy
  redirect to('/students')
end
