class Employee < ApplicationRecord
  validates :full_name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :job_title, presence: true
  validates :country, presence: true
  validates :salary, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :department, presence: true
  validates :hire_date, presence: true
  validates :employee_id, presence: true, uniqueness: true

  scope :by_country, ->(country) { where(country: country) }
  scope :by_job_title, ->(job_title) { where(job_title: job_title) }

  def self.salary_stats_by_country(country)
    employees = by_country(country)

    if employees.any?
      {
        min_salary: employees.minimum(:salary).to_i,
        max_salary: employees.maximum(:salary).to_i,
        avg_salary: employees.average(:salary).to_i,
        count: employees.count
      }
    else
      {
        min_salary: 0,
        max_salary: 0,
        avg_salary: 0,
        count: 0
      }
    end
  end

  def self.avg_salary_by_job_title_and_country(job_title, country)
    employees = by_job_title(job_title).by_country(country)
    employees.any? ? employees.average(:salary).to_i : 0
  end
end
