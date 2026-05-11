# Quick Start Guide

## 🚀 Running the Application

### Option 1: Using bin/dev (Recommended)
```bash
cd /home/rd/projects/ruby/mastering_ruby/Rails/salary_management
bin/dev
```

This starts both:
- Rails server on http://localhost:3000
- Asset compilation in watch mode

### Option 2: Manual Start
```bash
# Terminal 1: Start Rails server
rails server

# Terminal 2: Build assets (one-time)
npm run build
```

## 🧪 Running Tests

```bash
# Run all tests
bundle exec rspec

# Run specific test files
bundle exec rspec spec/models/employee_spec.rb
bundle exec rspec spec/requests/api/v1/employees_spec.rb
bundle exec rspec spec/requests/api/v1/insights_spec.rb
bundle exec rspec spec/lib/seed_generator_spec.rb
```

## 📊 Seeding Data

```bash
# Seed 10,000 employees (takes ~1 second)
rails db:seed

# Reset and reseed
rails db:reset
```

## 🌐 Using the Application

### Employee Management
1. Navigate to http://localhost:3000
2. Click "Employees" tab
3. **Add Employee**: Click "Add Employee" button
4. **Edit Employee**: Click edit icon in Actions column
5. **Delete Employee**: Click delete icon (with confirmation)
6. **Filter**: Use table column filters
7. **Pagination**: Navigate through pages at bottom

### Salary Insights
1. Click "Insights" tab
2. **Overview**: See total employees, countries, departments, avg salary
3. **Country Stats**: Select country from dropdown to see min/max/avg salary
4. **Job Title Stats**: Select job title and country to see average salary
5. **Top Rankings**: View tables for top countries and job titles

## 🔌 API Endpoints

### Test API with curl

**Get all employees (paginated):**
```bash
curl http://localhost:3000/api/v1/employees?page=1&per_page=10
```

**Get employee by ID:**
```bash
curl http://localhost:3000/api/v1/employees/1
```

**Create employee:**
```bash
curl -X POST http://localhost:3000/api/v1/employees \
  -H "Content-Type: application/json" \
  -d '{
    "employee": {
      "full_name": "John Doe",
      "email": "john.doe@example.com",
      "job_title": "Software Engineer",
      "country": "USA",
      "salary": 85000,
      "department": "Engineering",
      "hire_date": "2024-01-15",
      "employee_id": "EMP999999"
    }
  }'
```

**Get salary insights by country:**
```bash
curl "http://localhost:3000/api/v1/insights/salary_by_country?country=USA"
```

**Get salary by job title and country:**
```bash
curl "http://localhost:3000/api/v1/insights/salary_by_job_title?job_title=Software%20Engineer&country=USA"
```

**Get overview:**
```bash
curl http://localhost:3000/api/v1/insights/overview
```

## 📁 Project Structure

```
salary_management/
├── app/
│   ├── controllers/api/v1/     # API controllers
│   ├── javascript/components/  # React components
│   ├── models/                 # Employee model
│   └── views/home/             # Main view
├── db/
│   ├── migrate/                # Database migrations
│   ├── seeds.rb                # Seed script
│   ├── first_names.txt         # First names for seeding
│   └── last_names.txt          # Last names for seeding
├── lib/
│   └── seed_generator.rb       # Performance-optimized seed generator
├── spec/                       # RSpec tests
│   ├── models/
│   ├── requests/
│   └── lib/
└── config/
    └── routes.rb               # API routes
```

## 🐛 Troubleshooting

### Port already in use
```bash
# Kill process on port 3000
lsof -ti:3000 | xargs kill -9
```

### Assets not loading
```bash
# Rebuild assets
npm run build
```

### Database issues
```bash
# Reset database
rails db:drop db:create db:migrate db:seed
```

### Test failures
```bash
# Ensure test database is migrated
RAILS_ENV=test rails db:migrate
```

## 📊 Expected Performance

- **Seed Script**: 10,000 employees in < 1 second
- **Test Suite**: 47 examples in < 2 seconds
- **API Response**: < 100ms for most endpoints
- **Frontend Load**: < 2 seconds initial load

## ✅ Verification Checklist

- [ ] Rails server running on port 3000
- [ ] Can access http://localhost:3000
- [ ] Employee list shows 10,000 records
- [ ] Can add/edit/delete employees
- [ ] Insights dashboard shows statistics
- [ ] All tests passing: `bundle exec rspec`
- [ ] API endpoints responding correctly

## 🎥 Demo Preparation

For video demo, showcase:
1. **Employee CRUD**: Add, edit, delete an employee
2. **Filtering**: Filter by country (e.g., USA)
3. **Pagination**: Navigate through pages
4. **Insights**: Show country statistics and job title analysis
5. **Performance**: Run seed script to show speed
6. **Tests**: Run test suite to show coverage

## 📞 Support

For issues or questions, refer to:
- `README.md` - Comprehensive documentation
- `DEVELOPMENT_NOTES.md` - TDD approach and architecture decisions
- Test files in `spec/` - Examples of expected behavior
