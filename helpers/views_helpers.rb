### TODO: create_modal -> Need to modify the remarks display

require 'sinatra/base'

module ViewsHelpers
  #helpers do

  ### Forming English name from English Name + Last Name (Used in a table of students_list.slim)
  def forming_english_name(student)
    if student.english_name && student.last_name
      student.english_name + " " + student.last_name
    else
      "Not provided - admin please check"
    end
  end

  def attend_date(attendance)
    attendance.localtime.strftime("%Y-%m-%d")
  end

  def attend_time(attendance)
    if !attendance
     "No record"
    else
      attendance.localtime.strftime("%H:%M")
    end
  end

  def attend_duration(attendance)
    if attendance.leave
      duration_seconds = attendance.leave.localtime - attendance.arrival.localtime
      duration = duration_seconds / 60
      sprintf("%d hour(s) %d minute(s)", (duration / 60), (duration % 60))
    else
      "No record"
    end
  end

  def show_notice
    "<div class='alert flash notice'>
      <button type='button' class='close' data-dimiss='alert'>&times;</button>
      <strong>#{flash[:notice]}</strong>
    </div>"
  end

  def show_warning
    "<div class='alert alert-error flash notice'>
      <button type='button' class='close' data-dimiss='alert'>&times;</button>
      <strong>#{flash[:warning]}</strong>
    </div>"
  end

  def calculate_daterange
    today = Date.today.strftime("%B %d, %Y")
    past_month = (Date.today << 1).strftime("%B %d, %Y")
    "  #{past_month} - #{today}"
  end

  def create_modal(attendance)
    @logger.info attendance

    '<div class="modal hide fade" tabindex="-1" role="dialog" aria-labelledyby="recordLabel" aria-hidden="true">
      <div class="modal-header">
        <button type="button" class="close" data-dimiss="modal" aria-hidden="true"> x </button>
        <h3 class="recordLabel">Remark</h3>
      </div>
      <div class="modal-body">' +
        list_remarks(attendance) +
      '</div>
      <div class="modal-footer">
        <button class="btn" data-dismiss="modal" aria-hidden="true">Close</button>
      </div>
    </div>'
  end

  def list_remarks(attendance)
    @logger.info("Remarks count: #{attendance.attendance_remarks.count}")
    if attendance.attendance_remarks.count > 0
      attendance.attendance_remarks.each do |remark|
        #@logger.info("Is there any remark? #{remark}.")
        '<div><span class="label label-info">' + remark.label + '</span><p>' + remark.in_text + '</p></i> <i class="icon-trash"> </i>'
      end
    end
    add_remark(attendance)
  end

  #TODO: Adding a mark for identifying diferent remark icon for processing
  def add_remark(attendance)
    '<div><form class="form-inline">' + add_selections_for_remark +
    '<input type="text" style="margin-left: 10px; margin-right: 10px;" placeholder="Remarks">' +
    '</form><i id="add_remark_' + attendance.id.to_s + '_' + attendance.attendance_remarks.count.to_s + '" class="icon-plus-sign"></i></div>'
  end


  def add_selections_for_remark
    selections = ["extra", "in-class"]
    selection_options = selections.collect {|option| "<option id='#{option}' class='input-small'>#{option}</option>" }.join
    "<select class='input-small'> #{selection_options} </select>"
  end
end



