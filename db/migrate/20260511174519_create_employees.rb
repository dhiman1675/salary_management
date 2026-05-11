class CreateEmployees < ActiveRecord::Migration[8.0]
  def change
    create_table :employees do |t|
      t.string :full_name, null: false
      t.string :email, null: false
      t.string :job_title, null: false
      t.string :country, null: false
      t.decimal :salary, precision: 10, scale: 2, null: false
      t.string :department, null: false
      t.date :hire_date, null: false
      t.string :employee_id, null: false

      t.timestamps
    end

    add_index :employees, :email, unique: true
    add_index :employees, :employee_id, unique: true
    add_index :employees, :country
    add_index :employees, :job_title
  end
end
