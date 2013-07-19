require 'sinatra/base'
require 'sinatra/reloader'
require 'sinatra/json'
require 'sqlite3'
require 'sass'
require 'slim'
require 'sinatra/flash'
require 'logger'
require './models/admin'
require './models/student'
require './models/student_attendance'
require './models/attendance_remark'
require './helpers/views_helpers'
require './helpers/controllers_helpers'
#require './models'

class AsAttendance < Sinatra::Base
  ### Helpers defined in /helpers
  helpers ViewsHelpers
  helpers ControllersHelpers
  helpers Sinatra::JSON
  error_logger = Logger.new("log/errors.log")


  configure :development do
    register Sinatra::ActiveRecordExtension
    register Sinatra::Reloader
    register Sinatra::Flash
    set :method_override => true
    enable :logging
    enable :sessions
    ### Password set for admin login
    set :username, "as"
    set :password, "all04round"
  end

  configure :production do
    register Sinatra::ActiveRecordExtension
    register Sinatra::Flash
    ActiveRecord::Base.establish_connection(ENV["DATABASE_URL"])
    set :username, "as"
    set :password, "all04round"
  end

  ### Admin controllers

  ### Front page to receive barcode scanner
  ### Need to search student record, take attendance.
  get '/' do
    slim "admin/barcode_search".to_sym
  end

  ### Frontpage login action to validate admin username & passowrd
  post '/admin/login' do
    if params[:username] == AsAttendance.settings.username &&
      params[:password] == AsAttendance.settings.password
      session[:admin] = true
      redirect to('/students/show')
    else
      flash[:warning] = "Username / Password is incorrect!"
      redirect to('/')
    end

  end


  ### Action to set the admin session in false so logout
  get '/admin/logout' do
    session[:admin] = false
    flash[:warning] = "Logged out"
    redirect to('/')
  end



  ### Student controllers

  ### Listing all students info
  ### View -> student/student_list.slim
  get "/students/show" do
    @title = "Academy of Scholars -- List of all students"
    @students = Student.all         ### Containing all student records from the database -> students_list
    if session[:admin]
      @student_count = Student.all.count      ### Counting the number of students -> for generating student ID
      slim "student/students_list".to_sym
    else
      flash[:warning] = "You are not authorized!"
      redirect ('/')
    end
  end

  ### Listing student's full information
  ### View -> student/full_student.slim
  get '/students/:id/info' do
    @student = Student.find(params[:id])
    @attendances = @student.student_attendances
    @logger = error_logger
    slim "student/full_student".to_sym
  end

  ### Rendering form to create new student
  get '/students/new' do
    @student = Student.new
    if Student.count == 0
      @last_student_id = 0
    else
      @last_student_id = Student.last.id      ### Counting the number of students -> for generating student ID
    end
    slim "student/new_student".to_sym
  end

  ### Forming array of students' names in order to use it in the create/edit form of referer
  get '/students/names_array' do
    @student_names = Student.find(:all).collect {|s| s.english_name + ' ' + s.last_name }
    json @student_names
  end

  post '/students/new' do
    student = Student.create(params[:student])
    redirect to('/students/show')
  end

  ### Updating student record from full_student.slim

  get '/students/show/:id/update' do
    @student = Student.find(params[:id])
    slim "student/edit_student".to_sym
  end

  put '/students/show/:id/update' do
    @student = Student.find(params[:id])
    if @student.update_attributes(params[:student])
      redirect to("/students/#{@student.id}/info")
    end
  end

  ### Deleting student record from full_student.slim
  delete '/students/:id/destroy' do
    @student = Student.find(params[:id])
    @student.delete
    #redirect to('/students/show')
  end

  ### Searching student by Student ID -> Taking attendance
  get '/students/find' do
    @student = Student.find_by student_id: params[:student]["student_id"]
    if @student.student_attendances.empty?
      @student.student_attendances.build
      @student.student_attendances.last.update(arrival: Time.now.localtime)
      if @student.student_attendances.last.save
        flash[:notice] = "#{@student.english_name} has taken attentance at #{Time.now.strftime('%H:%M')}."
      end
    elsif @student.student_attendances.last.leave
      if @student.student_attendances.create(arrival: Time.now.localtime)
         flash[:notice] = "#{@student.english_name} has taken attentance at #{Time.now.strftime('%H:%M')}."
       end
    elsif @student.student_attendances.last.arrival
      period = Time.now - @student.student_attendances.last.arrival
      if period > 300
        @student.student_attendances.last.update(leave: Time.now.localtime)
        if @student.student_attendances.last.save
          flash[:notice] = "#{@student.english_name} has taken (leaving) attentance at #{Time.now.strftime('%H:%M')}."
        end
      else
        flash[:warning] = "#{@student.english_name} has already taken attendance #{sprintf('%d', period / 60)} minute(s) ago."
      end
    end
    redirect to('/')
  end

  ### Attendance controller

  delete '/students/:student_id/attendances/:id/delete' do
    @attendance = StudentAttendance.find(params[:id])
    @attendance.delete
  end
end



### Executing script
if __FILE__ == $0
  AsAttendance.run!
end






