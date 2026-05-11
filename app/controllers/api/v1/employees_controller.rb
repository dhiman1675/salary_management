module Api
  module V1
    class EmployeesController < ApplicationController
      before_action :set_employee, only: [ :show, :update, :destroy ]

      def index
        @employees = Employee.all
        @employees = @employees.by_country(params[:country]) if params[:country].present?
        @employees = @employees.by_job_title(params[:job_title]) if params[:job_title].present?

        page = params[:page] || 1
        per_page = params[:per_page] || 25

        @pagy_employees = @employees.page(page).per(per_page)
        total_pages = (@employees.count.to_f / per_page.to_i).ceil

        render json: {
          employees: @pagy_employees.as_json,
          pagination: {
            current_page: page.to_i,
            per_page: per_page.to_i,
            total_pages: total_pages,
            total_count: @employees.count
          }
        }
      end

      def show
        render json: { employee: @employee.as_json }
      end

      def create
        @employee = Employee.new(employee_params)

        if @employee.save
          render json: { employee: @employee.as_json }, status: :created
        else
          render json: { errors: @employee.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @employee.update(employee_params)
          render json: { employee: @employee.as_json }
        else
          render json: { errors: @employee.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @employee.destroy
        head :no_content
      end

      private

      def set_employee
        @employee = Employee.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Employee not found" }, status: :not_found
      end

      def employee_params
        params.require(:employee).permit(
          :full_name, :email, :job_title, :country, :salary,
          :department, :hire_date, :employee_id
        )
      end
    end
  end
end
