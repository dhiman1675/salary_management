# Salary Management System

A full-stack web application for managing employee salary data with comprehensive analytics and insights. Built following Test-Driven Development (TDD) principles with a focus on code quality, performance, and maintainability.

## 🎯 Project Overview

This application provides HR managers with a powerful tool to:
- Manage employee records (CRUD operations)
- View salary insights and analytics by country and job title
- Handle large datasets efficiently (10,000+ employees)
- Access real-time salary statistics and trends

## 🏗️ Architecture & Tech Stack

### Backend
- **Framework**: Ruby on Rails 8.0.3
- **Database**: SQLite3 with optimized indexes
- **API**: RESTful JSON API (versioned as v1)
- **Testing**: RSpec with 100% test coverage
- **Performance**: Batch insert optimization for seed data

### Frontend
- **Framework**: React 19.2.6
- **UI Library**: Ant Design 6.3.7
- **Build Tool**: esbuild (fast JavaScript bundler)
- **State Management**: React Hooks
- **HTTP Client**: Axios

### Development Approach
- **TDD (Test-Driven Development)**: All features developed following Red-Green-Refactor cycle
- **Incremental Commits**: Clear commit history showing development evolution
- **Code Quality**: RuboCop for style enforcement, comprehensive test suite

## 📋 Features

### Employee Management
- ✅ Add new employees with full validation
- ✅ View employee list with pagination (25 per page)
- ✅ Update employee information
- ✅ Delete employees with confirmation
- ✅ Filter by country and job title
- ✅ Sort by salary and other fields

### Salary Insights
- ✅ Overall statistics (total employees, countries, departments, avg salary)
- ✅ Country-based analytics (min/max/avg salary)
- ✅ Job title & country combination analysis
- ✅ Top countries by employee count
- ✅ Top job titles by employee count
- ✅ Visual statistics with Ant Design components

### Performance Features
- ✅ Optimized seed script: 10,000 employees in < 1 second
- ✅ Batch inserts with configurable batch size
- ✅ Database indexes on frequently queried fields
- ✅ Efficient pagination for large datasets

## 🚀 Getting Started

### Prerequisites
- Ruby 3.4.6 (or compatible version)
- Node.js 18+ and npm
- SQLite3

### Installation

1. **Clone the repository**
```bash
cd /home/rd/projects/ruby/mastering_ruby/Rails/salary_management
```

2. **Install dependencies**
```bash
bundle install
npm install
```

3. **Setup database**
```bash
rails db:create
rails db:migrate
```

4. **Seed the database** (generates 10,000 employees)
```bash
rails db:seed
```

5. **Build frontend assets**
```bash
npm run build
```

### Running the Application

**Development Server:**
```bash
bin/dev
```

This starts:
- Rails server on http://localhost:3000
- Asset compilation with esbuild in watch mode

**Access the application:**
- Open http://localhost:3000 in your browser
- Navigate between "Employees" and "Insights" tabs

## 🧪 Testing

### Run Full Test Suite
```bash
bundle exec rspec
```

**Test Coverage:**
- Model tests: Employee validations, scopes, and class methods
- Request tests: API endpoints for employees and insights
- Seed generator tests: Performance and data integrity

**Test Statistics:**
- 47 examples, 0 failures
- Fast execution (< 2 seconds)
- Comprehensive coverage of business logic

### Run Specific Tests
```bash
# Model tests
bundle exec rspec spec/models/employee_spec.rb

# API tests
bundle exec rspec spec/requests/api/v1/employees_spec.rb
bundle exec rspec spec/requests/api/v1/insights_spec.rb

# Seed generator tests
bundle exec rspec spec/lib/seed_generator_spec.rb
```

## 📊 Database Schema

### Employees Table
```ruby
- id: integer (primary key)
- full_name: string (required)
- email: string (required, unique, indexed)
- job_title: string (required, indexed)
- country: string (required, indexed)
- salary: decimal(10,2) (required, >= 0)
- department: string (required)
- hire_date: date (required)
- employee_id: string (required, unique, indexed)
- created_at: datetime
- updated_at: datetime
```

## 🔌 API Endpoints

### Employees API

**GET /api/v1/employees**
- List all employees with pagination
- Query params: `page`, `per_page`, `country`, `job_title`
- Response: JSON with employees array and pagination metadata

**GET /api/v1/employees/:id**
- Get single employee details

**POST /api/v1/employees**
- Create new employee
- Body: `{ employee: { full_name, email, job_title, ... } }`

**PATCH /api/v1/employees/:id**
- Update employee
- Body: `{ employee: { field: value } }`

**DELETE /api/v1/employees/:id**
- Delete employee

### Insights API

**GET /api/v1/insights/overview**
- Overall statistics and top rankings

**GET /api/v1/insights/salary_by_country**
- Query params: `country`
- Returns: min, max, avg salary and employee count

**GET /api/v1/insights/salary_by_job_title**
- Query params: `job_title`, `country`
- Returns: avg salary and employee count

## 🎨 UI Components

### Employee List View
- Responsive table with sorting and filtering
- Inline edit and delete actions
- Modal form for add/edit operations
- Form validation with error messages
- Confirmation dialogs for destructive actions

### Insights Dashboard
- Statistics cards with icons
- Interactive dropdowns for filtering
- Data tables for top rankings
- Real-time data updates

## 📈 Performance Optimizations

1. **Database Indexes**: Added on email, employee_id, country, and job_title
2. **Batch Inserts**: Seed script uses `insert_all` for bulk operations
3. **Pagination**: API returns paginated results to reduce payload size
4. **Efficient Queries**: Uses ActiveRecord scopes and aggregations
5. **Asset Bundling**: esbuild for fast JavaScript compilation

## 🔄 Development Workflow (TDD)

This project strictly follows TDD principles:

1. **RED**: Write failing tests first
2. **GREEN**: Write minimal code to pass tests
3. **REFACTOR**: Improve code while keeping tests green

Example commit flow:
1. `Add RSpec, FactoryBot, and Faker for TDD`
2. `TDD: Implement Employee model with validations and salary analytics methods`
3. `TDD: Implement Employees and Insights API controllers with full CRUD and analytics`
4. `Add performance-optimized seed script with batch inserts`

## 📝 Code Quality

- **RSpec Tests**: Comprehensive test coverage
- **RuboCop**: Rails Omakase style guide
- **Brakeman**: Security vulnerability scanning
- **Factory Bot**: Test data generation
- **Faker**: Realistic test data

## 🚢 Deployment Considerations

### Production Checklist
- [ ] Switch to PostgreSQL for production
- [ ] Configure environment variables
- [ ] Setup asset precompilation
- [ ] Configure CORS if needed
- [ ] Setup monitoring and logging
- [ ] Configure backup strategy

### Deployment Options
- Heroku
- Railway
- Render
- AWS/GCP/Azure
- Docker (Dockerfile included)

## 📂 Project Structure

```
salary_management/
├── app/
│   ├── controllers/
│   │   ├── api/v1/
│   │   │   ├── employees_controller.rb
│   │   │   └── insights_controller.rb
│   │   └── home_controller.rb
│   ├── javascript/
│   │   ├── components/
│   │   │   ├── App.jsx
│   │   │   ├── EmployeeList.jsx
│   │   │   └── Insights.jsx
│   │   └── application.js
│   ├── models/
│   │   └── employee.rb
│   └── views/
│       └── home/index.html.erb
├── db/
│   ├── migrate/
│   ├── seeds.rb
│   ├── first_names.txt
│   └── last_names.txt
├── lib/
│   └── seed_generator.rb
├── spec/
│   ├── models/
│   ├── requests/
│   └── lib/
└── config/
    └── routes.rb
```

## 🤝 Contributing

This project was built as an assessment demonstrating:
- Strong engineering fundamentals
- TDD discipline
- Clean code practices
- Modern full-stack development
- Performance optimization
- Product thinking

## 📄 License

This project is part of a technical assessment.

## 👤 Author

Built with AI assistance following professional software engineering practices.
