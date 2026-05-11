require 'rails_helper'
require_relative '../../lib/seed_generator'

RSpec.describe SeedGenerator do
  let(:generator) { SeedGenerator.new }

  describe '#generate_employees' do
    it 'generates the specified number of employees' do
      count = 100
      employees = generator.generate_employees(count)
      expect(employees.length).to eq(count)
    end

    it 'generates employees with all required attributes' do
      employees = generator.generate_employees(10)
      employee = employees.first

      expect(employee[:full_name]).to be_present
      expect(employee[:email]).to be_present
      expect(employee[:job_title]).to be_present
      expect(employee[:country]).to be_present
      expect(employee[:salary]).to be_present
      expect(employee[:department]).to be_present
      expect(employee[:hire_date]).to be_present
      expect(employee[:employee_id]).to be_present
    end

    it 'generates unique emails' do
      employees = generator.generate_employees(100)
      emails = employees.map { |e| e[:email] }
      expect(emails.uniq.length).to eq(100)
    end

    it 'generates unique employee_ids' do
      employees = generator.generate_employees(100)
      employee_ids = employees.map { |e| e[:employee_id] }
      expect(employee_ids.uniq.length).to eq(100)
    end

    it 'uses names from first_names.txt and last_names.txt' do
      employees = generator.generate_employees(10)
      employee = employees.first
      
      first_name, last_name = employee[:full_name].split(' ')
      expect(generator.first_names).to include(first_name)
      expect(generator.last_names).to include(last_name)
    end
  end

  describe '#seed_database' do
    it 'inserts employees into the database efficiently' do
      Employee.delete_all
      
      start_time = Time.now
      generator.seed_database(1000)
      end_time = Time.now
      
      expect(Employee.count).to eq(1000)
      expect(end_time - start_time).to be < 5
    end

    it 'handles large datasets efficiently' do
      Employee.delete_all
      
      start_time = Time.now
      generator.seed_database(10000)
      end_time = Time.now
      
      expect(Employee.count).to eq(10000)
      expect(end_time - start_time).to be < 30
    end
  end
end
