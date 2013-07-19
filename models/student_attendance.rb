#require './student'
require 'sinatra'
require 'sinatra/activerecord'

class StudentAttendance < ActiveRecord::Base
  ### Attendance Class holds the Time object of students' attendance.

  belongs_to :student
  has_many :attendance_remarks
end