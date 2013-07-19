require 'sinatra/base'

module ControllersHelpers

  def generate_student_id(last_student_id)
    if last_student_id
      2000 + last_student_id
    else
      2000 + 1
    end
  end

end

