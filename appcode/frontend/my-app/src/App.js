import React, { useState, useEffect } from 'react';
import EmployeeList from './components/EmployeeList';
import EmployeeForm from './components/EmployeeForm';
import { getEmployees, saveEmployee } from './services/api';
// The import './App.css' is not needed here as we moved it to index.js

function App() {
  const [employees, setEmployees] = useState([]);
  const [editingEmployee, setEditingEmployee] = useState(null);

  useEffect(() => {
    refreshData();
  }, []);

  const refreshData = async () => {
    const data = await getEmployees();
    setEmployees(data);
  };

  const handleSave = async (employee) => {
    await saveEmployee(employee);
    setEditingEmployee(null); 
    refreshData(); 
  };

  return (
    <div className="container">
      <header className="header">
        <h1>HR Tracker</h1>
      </header>
      
      <div className="main-content">
        <div className="section">
          <EmployeeForm 
            currentEmployee={editingEmployee} 
            onSave={handleSave} 
            onCancel={() => setEditingEmployee(null)}
          />
        </div>

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
