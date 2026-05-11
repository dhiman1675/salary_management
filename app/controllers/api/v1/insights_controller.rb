module Api
  module V1
    class InsightsController < ApplicationController
      def salary_by_country
        unless params[:country].present?
          return render json: { error: "Country parameter is required" }, status: :bad_request
        end

        stats = Employee.salary_stats_by_country(params[:country])

        render json: {
          country: params[:country],
          min_salary: stats[:min_salary],
          max_salary: stats[:max_salary],
          avg_salary: stats[:avg_salary],
          employee_count: stats[:count]
        }
      end

      def salary_by_job_title
        unless params[:job_title].present? && params[:country].present?
          return render json: { error: "Job title and country parameters are required" }, status: :bad_request
        end

        avg_salary = Employee.avg_salary_by_job_title_and_country(params[:job_title], params[:country])
        count = Employee.by_job_title(params[:job_title]).by_country(params[:country]).count

        render json: {
          job_title: params[:job_title],
          country: params[:country],
          avg_salary: avg_salary,
          employee_count: count
        }
      end

      def overview
        total_employees = Employee.count
        countries = Employee.distinct.pluck(:country)
        departments = Employee.distinct.pluck(:department)
        avg_salary = Employee.average(:salary).to_i

        top_countries = Employee.group(:country)
                                .select("country, COUNT(*) as employee_count, AVG(salary) as avg_salary")
                                .order("employee_count DESC")
                                .limit(5)
                                .map { |e| { country: e.country, count: e.employee_count, avg_salary: e.avg_salary.to_i } }

        top_job_titles = Employee.group(:job_title)
                                 .select("job_title, COUNT(*) as employee_count, AVG(salary) as avg_salary")
                                 .order("employee_count DESC")
                                 .limit(5)
                                 .map { |e| { job_title: e.job_title, count: e.employee_count, avg_salary: e.avg_salary.to_i } }

        render json: {
          total_employees: total_employees,
          countries_count: countries.count,
          departments_count: departments.count,
          avg_salary: avg_salary,
          top_countries: top_countries,
          top_job_titles: top_job_titles
        }
      end
    end
  end
end
