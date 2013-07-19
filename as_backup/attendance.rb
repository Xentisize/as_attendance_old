require './student'
require 'sinatra'
require 'sinatra/activerecord'

class Attendance < ActiveRecord::Base
  ### Attendance Class holds the Time object of students' attendance.

  belongs_to :student
end