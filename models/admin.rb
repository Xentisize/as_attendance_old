require 'sinatra'
require 'sinatra/activerecord'

set :database, "sqlite3:///db/attendance.db"

class Admin < ActiveRecord::Base
  ### Admin is the class monitoring students' information and attendance.
  ### It should be able to generate graphical presentation of students' attendance in the future.
  ### The basic functions:
  ### 1. Query students' attendance
  ### 2. Edit students' attendance
  ### 3. Delete students' attendance

  ### Every admin will monitor all students. Therefore, Admin has many students.
  has_many :students
end
