require 'rails_helper'

RSpec.describe "Api::V1::Insights", type: :request do
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
    Employee.create!(
      full_name: 'Alice Williams',
      email: 'alice@example.com',
      job_title: 'Software Engineer',
      country: 'USA',
      salary: 95000,
      department: 'Engineering',
      hire_date: Date.today,
      employee_id: 'EMP004'
    )
  end

  describe "GET /api/v1/insights/salary_by_country" do
    it "returns salary statistics for a specific country" do
      get "/api/v1/insights/salary_by_country", params: { country: 'USA' }
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      
      expect(json['country']).to eq('USA')
      expect(json['min_salary']).to eq(80000)
      expect(json['max_salary']).to eq(95000)
      expect(json['avg_salary']).to eq(88333)
      expect(json['employee_count']).to eq(3)
    end

    it "returns zeros for country with no employees" do
      get "/api/v1/insights/salary_by_country", params: { country: 'Germany' }
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      
      expect(json['country']).to eq('Germany')
      expect(json['min_salary']).to eq(0)
      expect(json['max_salary']).to eq(0)
      expect(json['avg_salary']).to eq(0)
      expect(json['employee_count']).to eq(0)
    end

    it "returns bad request without country parameter" do
      get "/api/v1/insights/salary_by_country"
      expect(response).to have_http_status(:bad_request)
    end
  end

  describe "GET /api/v1/insights/salary_by_job_title" do
    it "returns average salary for job title in a country" do
      get "/api/v1/insights/salary_by_job_title", params: { job_title: 'Software Engineer', country: 'USA' }
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      
      expect(json['job_title']).to eq('Software Engineer')
      expect(json['country']).to eq('USA')
      expect(json['avg_salary']).to eq(87500)
      expect(json['employee_count']).to eq(2)
    end

    it "returns zero for non-existent combination" do
      get "/api/v1/insights/salary_by_job_title", params: { job_title: 'CEO', country: 'Germany' }
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      
      expect(json['avg_salary']).to eq(0)
      expect(json['employee_count']).to eq(0)
    end

    it "returns bad request without required parameters" do
      get "/api/v1/insights/salary_by_job_title", params: { job_title: 'Engineer' }
      expect(response).to have_http_status(:bad_request)
    end
  end

  describe "GET /api/v1/insights/overview" do
    it "returns overall salary insights" do
      get "/api/v1/insights/overview"
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      
      expect(json['total_employees']).to eq(4)
      expect(json['countries_count']).to eq(2)
      expect(json['departments_count']).to eq(2)
      expect(json['avg_salary']).to be_present
      expect(json['top_countries']).to be_an(Array)
      expect(json['top_job_titles']).to be_an(Array)
    end
  end
end
