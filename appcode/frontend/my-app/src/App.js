import React, { useState, useEffect } from 'react';
import './App.css';

function App() {
  const [employees, setEmployees] = useState([]);
  const [formData, setFormData] = useState({
    name: '',
    role: '',
    address: '',
    hireDate: ''
  });

  // Access the environment variable injected by Docker
  const API_BASE = process.env.REACT_APP_API_BASE_URL || 'http://localhost:7071/api';

  useEffect(() => {
    fetchEmployees();
  }, []);

  const fetchEmployees = async () => {
    try {
      const response = await fetch(`${API_BASE}/employees`);
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }
      const data = await response.json();
      setEmployees(data);
    } catch (error) {
      console.error('Error fetching employees:', error);
    }
  };

  const handleInputChange = (e) => {
    const { name, value } = e.target;
    setFormData(prev => ({ ...prev, [name]: value }));
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      const response = await fetch(`${API_BASE}/employee`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(formData),
      });

      if (response.ok) {
        await fetchEmployees(); // Refresh list
        setFormData({ name: '', role: '', address: '', hireDate: '' }); // Reset form
      } else {
        console.error('Failed to save employee');
      }
    } catch (error) {
      console.error('Error saving employee:', error);
    }
  };

  const handleDelete = async (id) => {
    if (!window.confirm('Are you sure you want to delete this employee?')) return;
    
    try {
      const response = await fetch(`${API_BASE}/employees/${id}`, {
        method: 'DELETE',
      });

      if (response.ok) {
        await fetchEmployees();
      } else {
        console.error('Failed to delete employee');
      }
    } catch (error) {
      console.error('Error deleting employee:', error);
    }
  };

  return (
    <div className="App">
      <header className="App-header">
        <h1>Employee Tracking System</h1>
      </header>
      <main className="container">
        <section className="form-section">
          <h2>Add New Employee</h2>
          <form onSubmit={handleSubmit} className="employee-form">
            <input name="name" placeholder="Name" value={formData.name} onChange={handleInputChange} required />
            <input name="role" placeholder="Role" value={formData.role} onChange={handleInputChange} />
            <input name="address" placeholder="Address" value={formData.address} onChange={handleInputChange} />
            <input name="hireDate" type="date" placeholder="Hire Date" value={formData.hireDate} onChange={handleInputChange} />
            <button type="submit">Add Employee</button>
          </form>
        </section>

        <section className="list-section">
          <h2>Employee List</h2>
          {employees.length === 0 ? (
            <p>No employees found.</p>
          ) : (
            <ul className="employee-list">
              {employees.map(emp => (
                <li key={emp.id} className="employee-item">
                  <div className="employee-info">
                    <strong>{emp.name}</strong> <span>({emp.role})</span>
                  </div>
                  <button onClick={() => handleDelete(emp.id)} className="delete-btn">Delete</button>
                </li>
              ))}
            </ul>
          )}
        </section>
      </main>
    </div>
  );
}

export default App;