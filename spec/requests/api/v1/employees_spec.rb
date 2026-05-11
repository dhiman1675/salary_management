require 'rails_helper'

RSpec.describe "Api::V1::Employees", type: :request do
  let(:valid_attributes) do
    {
      full_name: 'John Doe',
      email: 'john.doe@example.com',
      job_title: 'Software Engineer',
      country: 'USA',
      salary: 75000,
      department: 'Engineering',
      hire_date: Date.today.to_s,
      employee_id: 'EMP001'
    }
  end

  let(:invalid_attributes) do
    {
      full_name: nil,
      email: nil
    }
  end

  describe "GET /api/v1/employees" do
    before do
      Employee.create!(valid_attributes)
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
    end

    it "returns all employees" do
      get "/api/v1/employees"
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['employees'].length).to eq(2)
    end

    it "filters employees by country" do
      get "/api/v1/employees", params: { country: 'USA' }
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['employees'].length).to eq(1)
      expect(json['employees'][0]['country']).to eq('USA')
    end

    it "filters employees by job_title" do
      get "/api/v1/employees", params: { job_title: 'Software Engineer' }
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['employees'].length).to eq(1)
      expect(json['employees'][0]['job_title']).to eq('Software Engineer')
    end

    it "supports pagination" do
      get "/api/v1/employees", params: { page: 1, per_page: 1 }
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['employees'].length).to eq(1)
      expect(json['pagination']['current_page']).to eq(1)
      expect(json['pagination']['total_pages']).to eq(2)
      expect(json['pagination']['total_count']).to eq(2)
    end
  end

  describe "GET /api/v1/employees/:id" do
    let!(:employee) { Employee.create!(valid_attributes) }

    it "returns the employee" do
      get "/api/v1/employees/#{employee.id}"
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['employee']['id']).to eq(employee.id)
      expect(json['employee']['full_name']).to eq('John Doe')
    end

    it "returns 404 for non-existent employee" do
      get "/api/v1/employees/99999"
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST /api/v1/employees" do
    context "with valid parameters" do
      it "creates a new employee" do
        expect {
          post "/api/v1/employees", params: { employee: valid_attributes }
        }.to change(Employee, :count).by(1)

        expect(response).to have_http_status(:created)
        json = JSON.parse(response.body)
        expect(json['employee']['full_name']).to eq('John Doe')
      end
    end

    context "with invalid parameters" do
      it "does not create a new employee" do
        expect {
          post "/api/v1/employees", params: { employee: invalid_attributes }
        }.to change(Employee, :count).by(0)

        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)
        expect(json['errors']).to be_present
      end
    end
  end

  describe "PATCH /api/v1/employees/:id" do
    let!(:employee) { Employee.create!(valid_attributes) }

    context "with valid parameters" do
      let(:new_attributes) do
        { full_name: 'John Updated', salary: 85000 }
      end

      it "updates the employee" do
        patch "/api/v1/employees/#{employee.id}", params: { employee: new_attributes }
        expect(response).to have_http_status(:ok)
        employee.reload
        expect(employee.full_name).to eq('John Updated')
        expect(employee.salary).to eq(85000)
      end
    end

    context "with invalid parameters" do
      it "returns unprocessable entity" do
        patch "/api/v1/employees/#{employee.id}", params: { employee: { email: nil } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /api/v1/employees/:id" do
    let!(:employee) { Employee.create!(valid_attributes) }

    it "destroys the employee" do
      expect {
        delete "/api/v1/employees/#{employee.id}"
      }.to change(Employee, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end

    it "returns 404 for non-existent employee" do
      delete "/api/v1/employees/99999"
      expect(response).to have_http_status(:not_found)
    end
  end
end
