# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

require_relative '../lib/seed_generator'

puts "Starting to seed employees..."
puts "This script is optimized for performance and can be run regularly."

start_time = Time.now

generator = SeedGenerator.new
generator.seed_database(10_000, batch_size: 1000)

end_time = Time.now
duration = end_time - start_time

puts "\n✓ Seeding completed in #{duration.round(2)} seconds"
puts "✓ Total employees: #{Employee.count}"
puts "✓ Countries: #{Employee.distinct.count(:country)}"
puts "✓ Job titles: #{Employee.distinct.count(:job_title)}"
puts "✓ Departments: #{Employee.distinct.count(:department)}"
