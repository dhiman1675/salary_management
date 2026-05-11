class SeedGenerator
  attr_reader :first_names, :last_names

  COUNTRIES = ['USA', 'Canada', 'UK', 'Germany', 'France', 'India', 'Australia', 'Japan', 'Brazil', 'Mexico'].freeze
  JOB_TITLES = [
    'Software Engineer', 'Senior Software Engineer', 'Staff Engineer', 'Principal Engineer',
    'Product Manager', 'Senior Product Manager', 'Director of Product',
    'Data Scientist', 'Senior Data Scientist', 'ML Engineer',
    'DevOps Engineer', 'Site Reliability Engineer',
    'Engineering Manager', 'Director of Engineering', 'VP of Engineering',
    'Designer', 'Senior Designer', 'Design Lead',
    'QA Engineer', 'Test Automation Engineer',
    'Technical Writer', 'Developer Advocate',
    'Sales Engineer', 'Account Executive', 'Sales Manager',
    'HR Manager', 'Recruiter', 'People Operations',
    'Finance Manager', 'Accountant', 'Financial Analyst',
    'Marketing Manager', 'Content Strategist', 'Growth Manager'
  ].freeze
  DEPARTMENTS = [
    'Engineering', 'Product', 'Data Science', 'DevOps',
    'Design', 'QA', 'Sales', 'Marketing', 'HR', 'Finance', 'Operations'
  ].freeze

  def initialize
    load_names
  end

  def generate_employees(count)
    employees = []
    count.times do |i|
      employees << {
        full_name: generate_full_name,
        email: generate_email(i),
        job_title: JOB_TITLES.sample,
        country: COUNTRIES.sample,
        salary: generate_salary,
        department: DEPARTMENTS.sample,
        hire_date: generate_hire_date,
        employee_id: generate_employee_id(i)
      }
    end
    employees
  end

  def seed_database(count, batch_size: 1000)
    Employee.delete_all
    
    total_batches = (count.to_f / batch_size).ceil
    
    total_batches.times do |batch_num|
      current_batch_size = [batch_size, count - (batch_num * batch_size)].min
      start_index = batch_num * batch_size
      
      employees = generate_employees_batch(current_batch_size, start_index)
      
      Employee.insert_all(employees)
      
      print "." if batch_num % 10 == 0
    end
    
    puts "\nSeeded #{count} employees successfully!"
  end

  private

  def load_names
    first_names_path = Rails.root.join('db', 'first_names.txt')
    last_names_path = Rails.root.join('db', 'last_names.txt')
    
    @first_names = File.readlines(first_names_path).map(&:strip)
    @last_names = File.readlines(last_names_path).map(&:strip)
  end

  def generate_full_name
    "#{@first_names.sample} #{@last_names.sample}"
  end

  def generate_email(index)
    timestamp = Time.now.to_i
    "employee#{index}_#{timestamp}@company.com"
  end

  def generate_salary
    rand(40000..200000)
  end

  def generate_hire_date
    start_date = 5.years.ago.to_date
    end_date = Date.today
    rand(start_date..end_date)
  end

  def generate_employee_id(index)
    "EMP#{(index + 1).to_s.rjust(6, '0')}"
  end

  def generate_employees_batch(count, start_index)
    employees = []
    now = Time.current
    
    count.times do |i|
      actual_index = start_index + i
      employees << {
        full_name: generate_full_name,
        email: generate_email(actual_index),
        job_title: JOB_TITLES.sample,
        country: COUNTRIES.sample,
        salary: generate_salary,
        department: DEPARTMENTS.sample,
        hire_date: generate_hire_date,
        employee_id: generate_employee_id(actual_index),
        created_at: now,
        updated_at: now
      }
    end
    employees
  end
end
