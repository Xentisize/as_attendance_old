class CreateAttendances < ActiveRecord::Migration
  def up
    create_table :student_attendances do |t|
      t.belongs_to :student
      t.datetime :arrival
      t.datetime :leave
      #t.text :remark  ### Move to Remark Class.
      t.integer :student_id
    end
  end

  def down
  end
end
