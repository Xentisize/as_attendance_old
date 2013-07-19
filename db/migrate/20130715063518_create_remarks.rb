class CreateRemarks < ActiveRecord::Migration
  def up
    create_table :attendance_remarks do |t|
      t.belongs_to :student_attendance
      t.text :label
      t.text :in_text
      t.integer :student_attendance_id
    end
  end

  def down
  end
end
