require 'sinatra'
require 'sinatra/activerecord'
#require './attendance'

class AttendanceRemark < ActiveRecord::Base
  ### Remark class for holding remarks in students' attendances.

  belongs_to :student_attendance
end