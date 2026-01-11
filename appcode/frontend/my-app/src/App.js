import React, { useState, useEffect } from 'react';
import EmployeeList from './components/EmployeeList';
import EmployeeForm from './components/EmployeeForm';
import { getEmployees, saveEmployee } from './services/api';
import './App.css';

function App() {
  const [employees, setEmployees] = useState([]);
  const [editingEmployee, setEditingEmployee] = useState(null);

  // Load data on startup
  useEffect(() => {
    refreshData();
  }, []);

  const refreshData = async () => {
    const data = await getEmployees();
    setEmployees(data);
  };

  const handleSave = async (employee) => {
    await saveEmployee(employee);
    setEditingEmployee(null); // Clear edit mode
    refreshData(); // Reload list
  };

  return (
    <div className="container">
      <header className="header">
        <h1>HR Tracker</h1>
      </header>
      
      <div className="main-content">
        {/* Left: Form */}
        <div className="section">
          <EmployeeForm 
            currentEmployee={editingEmployee} 
            onSave={handleSave} 
            onCancel={() => setEditingEmployee(null)}
          />
        </div>

        {/* Right: List */}
        <div className="section">
          <EmployeeList 
            employees={employees} 
            onEdit={setEditingEmployee} 
          />
        </div>
      </div>
    </div>
  );
}

export default App;
