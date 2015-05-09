#!/home/as/.rvm/rubies/ruby-2.0.0-p247/bin/ruby

require 'sinatra/base'
require 'sinatra/reloader'
require 'sinatra/json'
require 'sinatra/partial'
require 'sqlite3'
require 'sass'
require 'slim'
require 'sinatra/flash'
require 'uri'
#require 'pg' if production?
require 'logger'
require_relative './models/admin'
require_relative './models/student'
require_relative './models/student_attendance'
require_relative './models/attendance_remark'
require_relative './helpers/views_helpers'
require_relative './helpers/controllers_helpers'
#require './models'

class AsAttendance < Sinatra::Base
  ### Helpers defined in /helpers
  helpers ViewsHelpers
  helpers ControllersHelpers
  helpers Sinatra::JSON
  #require 'sinatra/reloader'
  register Sinatra::ActiveRecordExtension
  register Sinatra::Reloader
  register Sinatra::Flash
  #require 'sqlite3'
  set :database, "sqlite3:///db/attendance.db"
  set :method_override => true
  # set :port, 80
  enable :logging
  enable :sessions
  ### Password set for admin login
  set :username, "as"
  set :password, "all04round"
  # error_logger = Logger.new("log/errors.log")
  # att_logger = Logger.new("log/attend.log")

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
    @today_attendance = StudentAttendance.where("arrival > ?", Time.now.yesterday)
    @students = Student.all         ### Containing all student records from the database -> students_list
    if session[:admin]
      @student_count = Student.all.count      ### Counting the number of students -> for generating student ID
      slim "student/students_list".to_sym
    else
      flash[:warning] = "You are not authorized!"
      redirect ('/')
    end
  end

  ### Listing today's attended students

  get "/students/today" do 
    @title = "Today attendance"
    @time = Time.now
    @time_year = @time.year
    @time_month = @time.month
    @time_day = @time.day
    @today_attendance = StudentAttendance.where("arrival > ?", Time.new(@time_year, @time_month, @time_day))
    # att_logger.info @today_attendance
    slim "student/today".to_sym
  end

  ### Listing student's full information
  ### View -> student/full_student.slim
  get '/students/:id/info' do
    @student = Student.find(params[:id])
    @attendances = @student.student_attendances.reverse
    # @logger = error_logger
    slim "student/full_student".to_sym
  end

  ### Manual update student attendance
  get '/attendances/manual/:id' do 
    @student = Student.find(params[:id])
    @attendance = @student.student_attendances.new
    slim "attendance/manual".to_sym
  end

  ### Manual checkin
  get '/students/checkin/:id' do 
    @student = Student.find(params[:id])
    @student.student_attendances.create(arrival: Time.now, leave: nil)
  end

  ### Show previous month attendance
  get '/students/previous' do 
    @students = Student.order("english_name ASC")
    @start_criteria = Time.now.prev_month.beginning_of_month
    @end_criteria = Time.now.prev_month.end_of_month
    slim "attendance/previous".to_sym
  end

  ### Return Attendance in JSON

  get '/students/at_json/:id' do 
    @student = Student.find(params[:id])
    this_year = Time.now.year
    month_begin = Time.now.beginning_of_year.beginning_of_month
    last_month = Time.now.prev_month.end_of_month
    number_of_month = last_month.month - month_begin.month + 1
    @student_attendances = []

    1.upto(number_of_month) do |month|
      begin_that_month = Time.new(this_year, month)
      end_that_month = begin_that_month.end_of_month
      # att_logger.info("Month: #{end_that_month}")
      monthly_attendances = @student.student_attendances.where("arrival >= ? and leave < ?", begin_that_month, end_that_month)
      @student_attendances << [month, monthly_attendances.size]
    end

    # att_logger.info @student_attendances
    json @student_attendances
  end

  get '/students/chart/:id' do 

    slim "attendance/chart".to_sym

  end

  post '/attendances/manual/:id' do 
    @student = Student.find(params[:id])
    # att_logger.info params[:attendance]
    @form_attr = params[:attendance]
    # att_logger.info "@form_attr: #{@form_attr}\n"
    # att_logger.info "Leave time: #{@form_attr['leave_time']}\n"


    @student_attendances = @student.student_attendances.new
    @arrival_date_arr = @form_attr["arrival_date"].split("-")

    @arrival_time_arr = @form_attr["arrival_time"].split(":")
    @leave_datetime = nil

    if @form_attr["leave_time"] != ""
      @leave_time_arr = @form_attr["leave_time"].split(":")
      # att_logger.info @leave_time_arr
      @leave_datetime = Time.new(@arrival_date_arr[0], @arrival_date_arr[1], @arrival_date_arr[2], @leave_time_arr[0], @leave_time_arr[1])
    end

    # att_logger.info @leave_date_time

    @arrival_datetime = Time.new(@arrival_date_arr[0], @arrival_date_arr[1], @arrival_date_arr[2], @arrival_time_arr[0], @arrival_time_arr[1])

    if @leave_datetime
      @student_attendances.update(arrival: @arrival_datetime, leave: @leave_datetime)
    else
      @student_attendances.update(arrival: @arrival_datetime, leave: nil)
    end

    if @student_attendances.save
      flash[:notice] = "Attendance Taken."
      redirect('/students/show')
    end
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
    if params[:student]["student_id"] =~ /^AS/i
      @student = Student.find_by student_id: params[:student]["student_id"][5..8]
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
    else
      flash[:warning] = "#{params[:student]['student_id']} is not a valid student ID."
    end
    redirect to('/')
  end

  get '/students/checkout/:attendance_id' do 
    @attendance = StudentAttendance.find(params[:attendance_id])
    @attendance.update(leave: Time.now.localtime)
    flash[:notice] = "Leaving record has been updated!"
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






