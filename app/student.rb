#!/usr/bin/ruby

require 'dm-core'
require 'dm-migrations'

DataMapper::Logger.new($stdout, :debug)
DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/student.db")

#This is the student class to create an object from the information read from student.db
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

#Allows us to modify the table without completely deleting it.
DataMapper.auto_upgrade!

#Session handling
configure do
  enable :sessions
  set :username, 'frank'
  set :password, 'sinatra'
end

#Check for validity of DB
DataMapper.finalize

#route to students page and chreates an object of all the students
get '/students' do
  @students = Student.all
  erb :students
end

#route to add a new student and checks if you are logged in
get '/students/new' do
  halt(401, "Not Authorized") unless session[:admin]
  @student = Student.new
  erb :new_student
end

#route to display the page for individual student
get '/students/:id' do
  @student = Student.get(params[:id])
  erb :show_student
end

#route to page to edit a student and checks if you are logged in
get '/students/:id/edit' do
  halt(401, "Not Authorized") unless session[:admin]
  @student = Student.get(params[:id])
  erb :edit_student
end

#Information passed back from creating a new student comes here
post '/students' do  
  student = Student.create(params[:student])
  redirect to("/students/#{student.id}")
end

#route to update student information
put '/students/:id' do
  student = Student.get(params[:id])
  student.update(params[:student])
  redirect to("/students/#{student.id}")
end

#route to delete a student and check to see if you are logged in
delete '/students/:id' do
  halt(401, "Not Authorized") unless session[:admin]
  Student.get(params[:id]).destroy
  redirect to('/students')
end
