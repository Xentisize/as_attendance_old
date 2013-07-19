class CreateStudents < ActiveRecord::Migration
  def up
    create_table :students do |t|
      ### Personal Information
      t.integer :student_id     ### Student ID is assigned from AS for barcode usage.
      t.string :last_name
      t.string :first_name
      t.string :english_name
      t.string :chinese_name
      t.string :gender
      t.datetime :date_of_birth

      ### School Information
      t.string :school_eng_name
      t.string :school_chi_name

      ### Contact Information
      t.integer :self_tel
      t.integer :parents_tel
      t.integer :contact_tel
      t.string :email
      t.string :address

      ### Application Details
      t.datetime :admission_date
      t.string :refer_from

      ### Official Use Only
      t.timestamp
    end

  end

  def down
  end
end
