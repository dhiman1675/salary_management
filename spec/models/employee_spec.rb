require 'rails_helper'

RSpec.describe Employee, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      employee = Employee.new(
        full_name: 'John Doe',
        email: 'john.doe@example.com',
        job_title: 'Software Engineer',
        country: 'USA',
        salary: 75000,
        department: 'Engineering',
        hire_date: Date.today,
        employee_id: 'EMP001'
      )
      expect(employee).to be_valid
    end

    it 'is invalid without a full_name' do
      employee = Employee.new(full_name: nil)
      expect(employee).not_to be_valid
      expect(employee.errors[:full_name]).to include("can't be blank")
    end

    it 'is invalid without an email' do
      employee = Employee.new(email: nil)
      expect(employee).not_to be_valid
      expect(employee.errors[:email]).to include("can't be blank")
    end

    it 'is invalid with a duplicate email' do
      Employee.create!(
        full_name: 'John Doe',
        email: 'john@example.com',
        job_title: 'Engineer',
        country: 'USA',
        salary: 75000,
        department: 'Engineering',
        hire_date: Date.today,
        employee_id: 'EMP001'
      )
      employee = Employee.new(email: 'john@example.com')
      expect(employee).not_to be_valid
      expect(employee.errors[:email]).to include("has already been taken")
    end

    it 'is invalid without a job_title' do
      employee = Employee.new(job_title: nil)
      expect(employee).not_to be_valid
      expect(employee.errors[:job_title]).to include("can't be blank")
    end

    it 'is invalid without a country' do
      employee = Employee.new(country: nil)
      expect(employee).not_to be_valid
      expect(employee.errors[:country]).to include("can't be blank")
    end

    it 'is invalid without a salary' do
      employee = Employee.new(salary: nil)
      expect(employee).not_to be_valid
      expect(employee.errors[:salary]).to include("can't be blank")
    end

    it 'is invalid with a negative salary' do
      employee = Employee.new(salary: -1000)
      expect(employee).not_to be_valid
      expect(employee.errors[:salary]).to include("must be greater than or equal to 0")
    end

    it 'is invalid without a department' do
      employee = Employee.new(department: nil)
      expect(employee).not_to be_valid
      expect(employee.errors[:department]).to include("can't be blank")
    end

    it 'is invalid without a hire_date' do
      employee = Employee.new(hire_date: nil)
      expect(employee).not_to be_valid
      expect(employee.errors[:hire_date]).to include("can't be blank")
    end

    it 'is invalid without an employee_id' do
      employee = Employee.new(employee_id: nil)
      expect(employee).not_to be_valid
      expect(employee.errors[:employee_id]).to include("can't be blank")
    end

    it 'is invalid with a duplicate employee_id' do
      Employee.create!(
        full_name: 'John Doe',
        email: 'john@example.com',
        job_title: 'Engineer',
        country: 'USA',
        salary: 75000,
        department: 'Engineering',
        hire_date: Date.today,
        employee_id: 'EMP001'
      )
      employee = Employee.new(employee_id: 'EMP001')
      expect(employee).not_to be_valid
      expect(employee.errors[:employee_id]).to include("has already been taken")
    end
  end

  describe 'scopes' do
    before do
      Employee.create!(
        full_name: 'John Doe',
        email: 'john@example.com',
        job_title: 'Software Engineer',
        country: 'USA',
        salary: 80000,
        department: 'Engineering',
        hire_date: Date.today,
        employee_id: 'EMP001'
      )
      Employee.create!(
        full_name: 'Jane Smith',
        email: 'jane@example.com',
        job_title: 'Product Manager',
        country: 'Canada',
        salary: 90000,
        department: 'Product',
        hire_date: Date.today,
        employee_id: 'EMP002'
      )
      Employee.create!(
        full_name: 'Bob Johnson',
        email: 'bob@example.com',
        job_title: 'Software Engineer',
        country: 'USA',
        salary: 85000,
        department: 'Engineering',
        hire_date: Date.today,
        employee_id: 'EMP003'
      )
    end

    it 'filters by country' do
      usa_employees = Employee.by_country('USA')
      expect(usa_employees.count).to eq(2)
      expect(usa_employees.pluck(:country).uniq).to eq(['USA'])
    end

    it 'filters by job_title' do
      engineers = Employee.by_job_title('Software Engineer')
      expect(engineers.count).to eq(2)
      expect(engineers.pluck(:job_title).uniq).to eq(['Software Engineer'])
    end
  end

  describe 'class methods' do
    before do
      Employee.create!(
        full_name: 'John Doe',
        email: 'john@example.com',
        job_title: 'Software Engineer',
        country: 'USA',
        salary: 80000,
        department: 'Engineering',
        hire_date: Date.today,
        employee_id: 'EMP001'
      )
      Employee.create!(
        full_name: 'Jane Smith',
        email: 'jane@example.com',
        job_title: 'Product Manager',
        country: 'USA',
        salary: 90000,
        department: 'Product',
        hire_date: Date.today,
        employee_id: 'EMP002'
      )
      Employee.create!(
        full_name: 'Bob Johnson',
        email: 'bob@example.com',
        job_title: 'Software Engineer',
        country: 'Canada',
        salary: 85000,
        department: 'Engineering',
        hire_date: Date.today,
        employee_id: 'EMP003'
      )
    end

    describe '.salary_stats_by_country' do
      it 'returns correct salary statistics for a country' do
        stats = Employee.salary_stats_by_country('USA')
        expect(stats[:min_salary]).to eq(80000)
        expect(stats[:max_salary]).to eq(90000)
        expect(stats[:avg_salary]).to eq(85000)
        expect(stats[:count]).to eq(2)
      end

      it 'returns zeros for a country with no employees' do
        stats = Employee.salary_stats_by_country('Germany')
        expect(stats[:min_salary]).to eq(0)
        expect(stats[:max_salary]).to eq(0)
        expect(stats[:avg_salary]).to eq(0)
        expect(stats[:count]).to eq(0)
      end
    end

    describe '.avg_salary_by_job_title_and_country' do
      it 'returns correct average salary for job title and country' do
        avg = Employee.avg_salary_by_job_title_and_country('Software Engineer', 'USA')
        expect(avg).to eq(80000)
      end

      it 'returns 0 for non-existent combination' do
        avg = Employee.avg_salary_by_job_title_and_country('CEO', 'Germany')
        expect(avg).to eq(0)
      end
    end
  end
end
