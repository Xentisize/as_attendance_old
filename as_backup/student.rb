require 'sinatra'
require 'sinatra/activerecord'
#require './admin'

class Student < ActiveRecord::Base
  ### Student class represents the structure of a student.
  ### It should include the basic personal information of students.
  ### Also, it should be the object to hold individual's attendance.

  #belongs_to :admin
  has_many :student_attendances
end