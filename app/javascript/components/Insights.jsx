import React, { useState, useEffect } from 'react';
import { Card, Row, Col, Statistic, Select, Form, Table, message } from 'antd';
import { DollarOutlined, TeamOutlined, GlobalOutlined, BankOutlined } from '@ant-design/icons';
import axios from 'axios';

const { Option } = Select;

const Insights = () => {
  const [overview, setOverview] = useState(null);
  const [countryStats, setCountryStats] = useState(null);
  const [jobTitleStats, setJobTitleStats] = useState(null);
  const [selectedCountry, setSelectedCountry] = useState('USA');
  const [selectedJobTitle, setSelectedJobTitle] = useState('Software Engineer');
  const [selectedJobCountry, setSelectedJobCountry] = useState('USA');
  const [loading, setLoading] = useState(false);

  const countries = ['USA', 'Canada', 'UK', 'Germany', 'France', 'India', 'Australia', 'Japan', 'Brazil', 'Mexico'];
  const jobTitles = [
    'Software Engineer', 'Senior Software Engineer', 'Staff Engineer', 'Principal Engineer',
    'Product Manager', 'Senior Product Manager', 'Director of Product',
    'Data Scientist', 'Senior Data Scientist', 'ML Engineer',
    'DevOps Engineer', 'Site Reliability Engineer',
    'Engineering Manager', 'Director of Engineering', 'VP of Engineering',
    'Designer', 'Senior Designer', 'Design Lead',
    'QA Engineer', 'Test Automation Engineer'
  ];

  useEffect(() => {
    fetchOverview();
  }, []);

  useEffect(() => {
    if (selectedCountry) {
      fetchCountryStats(selectedCountry);
    }
  }, [selectedCountry]);

  useEffect(() => {
    if (selectedJobTitle && selectedJobCountry) {
      fetchJobTitleStats(selectedJobTitle, selectedJobCountry);
    }
  }, [selectedJobTitle, selectedJobCountry]);

  const fetchOverview = async () => {
    setLoading(true);
    try {
      const response = await axios.get('/api/v1/insights/overview');
      setOverview(response.data);
    } catch (error) {
      message.error('Failed to fetch overview');
    } finally {
      setLoading(false);
    }
  };

  const fetchCountryStats = async (country) => {
    try {
      const response = await axios.get('/api/v1/insights/salary_by_country', {
        params: { country }
      });
      setCountryStats(response.data);
    } catch (error) {
      message.error('Failed to fetch country statistics');
    }
  };

  const fetchJobTitleStats = async (jobTitle, country) => {
    try {
      const response = await axios.get('/api/v1/insights/salary_by_job_title', {
        params: { job_title: jobTitle, country }
      });
      setJobTitleStats(response.data);
    } catch (error) {
      message.error('Failed to fetch job title statistics');
    }
  };

  const countryColumns = [
    {
      title: 'Country',
      dataIndex: 'country',
      key: 'country',
    },
    {
      title: 'Employees',
      dataIndex: 'count',
      key: 'count',
      sorter: (a, b) => a.count - b.count,
    },
    {
      title: 'Avg Salary',
      dataIndex: 'avg_salary',
      key: 'avg_salary',
      render: (salary) => `$${salary.toLocaleString()}`,
      sorter: (a, b) => a.avg_salary - b.avg_salary,
    },
  ];

  const jobTitleColumns = [
    {
      title: 'Job Title',
      dataIndex: 'job_title',
      key: 'job_title',
    },
    {
      title: 'Employees',
      dataIndex: 'count',
      key: 'count',
      sorter: (a, b) => a.count - b.count,
    },
    {
      title: 'Avg Salary',
      dataIndex: 'avg_salary',
      key: 'avg_salary',
      render: (salary) => `$${salary.toLocaleString()}`,
      sorter: (a, b) => a.avg_salary - b.avg_salary,
    },
  ];

  return (
    <div>
      <h2 style={{ marginBottom: 24 }}>Salary Insights Dashboard</h2>

      {/* Overview Statistics */}
      {overview && (
        <Row gutter={16} style={{ marginBottom: 24 }}>
          <Col xs={24} sm={12} lg={6}>
            <Card>
              <Statistic
                title="Total Employees"
                value={overview.total_employees}
                prefix={<TeamOutlined />}
                valueStyle={{ color: '#3f8600' }}
              />
            </Card>
          </Col>
          <Col xs={24} sm={12} lg={6}>
            <Card>
              <Statistic
                title="Countries"
                value={overview.countries_count}
                prefix={<GlobalOutlined />}
                valueStyle={{ color: '#1890ff' }}
              />
            </Card>
          </Col>
          <Col xs={24} sm={12} lg={6}>
            <Card>
              <Statistic
                title="Departments"
                value={overview.departments_count}
                prefix={<BankOutlined />}
                valueStyle={{ color: '#722ed1' }}
              />
            </Card>
          </Col>
          <Col xs={24} sm={12} lg={6}>
            <Card>
              <Statistic
                title="Avg Salary"
                value={overview.avg_salary}
                prefix={<DollarOutlined />}
                precision={0}
                valueStyle={{ color: '#cf1322' }}
              />
            </Card>
          </Col>
        </Row>
      )}

      {/* Country Statistics */}
      <Card title="Salary Statistics by Country" style={{ marginBottom: 24 }}>
        <Form layout="inline" style={{ marginBottom: 16 }}>
          <Form.Item label="Select Country">
            <Select
              value={selectedCountry}
              onChange={setSelectedCountry}
              style={{ width: 200 }}
            >
              {countries.map(country => (
                <Option key={country} value={country}>{country}</Option>
              ))}
            </Select>
          </Form.Item>
        </Form>

        {countryStats && (
          <Row gutter={16}>
            <Col xs={24} sm={8}>
              <Statistic
                title="Minimum Salary"
                value={countryStats.min_salary}
                prefix="$"
                precision={0}
              />
            </Col>
            <Col xs={24} sm={8}>
              <Statistic
                title="Average Salary"
                value={countryStats.avg_salary}
                prefix="$"
                precision={0}
              />
            </Col>
            <Col xs={24} sm={8}>
              <Statistic
                title="Maximum Salary"
                value={countryStats.max_salary}
                prefix="$"
                precision={0}
              />
            </Col>
          </Row>
        )}
      </Card>

      {/* Job Title Statistics */}
      <Card title="Salary Statistics by Job Title" style={{ marginBottom: 24 }}>
        <Form layout="inline" style={{ marginBottom: 16 }}>
          <Form.Item label="Job Title">
            <Select
              value={selectedJobTitle}
              onChange={setSelectedJobTitle}
              style={{ width: 250 }}
            >
              {jobTitles.map(title => (
                <Option key={title} value={title}>{title}</Option>
              ))}
            </Select>
          </Form.Item>
          <Form.Item label="Country">
            <Select
              value={selectedJobCountry}
              onChange={setSelectedJobCountry}
              style={{ width: 200 }}
            >
              {countries.map(country => (
                <Option key={country} value={country}>{country}</Option>
              ))}
            </Select>
          </Form.Item>
        </Form>

        {jobTitleStats && (
          <Row gutter={16}>
            <Col xs={24} sm={12}>
              <Statistic
                title="Average Salary"
                value={jobTitleStats.avg_salary}
                prefix="$"
                precision={0}
              />
            </Col>
            <Col xs={24} sm={12}>
              <Statistic
                title="Number of Employees"
                value={jobTitleStats.employee_count}
              />
            </Col>
          </Row>
        )}
      </Card>

      {/* Top Countries Table */}
      {overview && overview.top_countries && (
        <Card title="Top Countries by Employee Count" style={{ marginBottom: 24 }}>
          <Table
            columns={countryColumns}
            dataSource={overview.top_countries}
            rowKey="country"
            pagination={false}
          />
        </Card>
      )}

      {/* Top Job Titles Table */}
      {overview && overview.top_job_titles && (
        <Card title="Top Job Titles by Employee Count">
          <Table
            columns={jobTitleColumns}
            dataSource={overview.top_job_titles}
            rowKey="job_title"
            pagination={false}
          />
        </Card>
      )}
    </div>
  );
};

export default Insights;
