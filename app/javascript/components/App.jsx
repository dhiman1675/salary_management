import React, { useState } from 'react';
import { Layout, Menu } from 'antd';
import { TeamOutlined, BarChartOutlined } from '@ant-design/icons';
import EmployeeList from './EmployeeList';
import Insights from './Insights';

const { Header, Content } = Layout;

const App = () => {
  const [currentView, setCurrentView] = useState('employees');

  const menuItems = [
    {
      key: 'employees',
      icon: <TeamOutlined />,
      label: 'Employees',
    },
    {
      key: 'insights',
      icon: <BarChartOutlined />,
      label: 'Insights',
    },
  ];

  return (
    <Layout style={{ minHeight: '100vh' }}>
      <Header style={{ display: 'flex', alignItems: 'center' }}>
        <div style={{ color: 'white', fontSize: '20px', fontWeight: 'bold', marginRight: '50px' }}>
          Salary Management
        </div>
        <Menu
          theme="dark"
          mode="horizontal"
          selectedKeys={[currentView]}
          items={menuItems}
          onClick={({ key }) => setCurrentView(key)}
          style={{ flex: 1, minWidth: 0 }}
        />
      </Header>
      <Content style={{ padding: '24px', background: '#f0f2f5' }}>
        {currentView === 'employees' && <EmployeeList />}
        {currentView === 'insights' && <Insights />}
      </Content>
    </Layout>
  );
};

export default App;
