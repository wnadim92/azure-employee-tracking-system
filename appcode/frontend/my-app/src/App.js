import React, { useState, useEffect } from 'react';
import './App.css';

function App() {
  const [theme, setTheme] = useState('dark');
  const [employees, setEmployees] = useState([]);
  const [formData, setFormData] = useState({
    id: null,
    name: '',
    role: '',
    address: '',
    hireDate: '',
    dob: '',
    manager: ''
  });

  // Access the environment variable injected by Docker
  const API_BASE = process.env.REACT_APP_API_BASE_URL || 'http://localhost:7071';

  useEffect(() => {
    fetchEmployees();
  }, []);

  useEffect(() => {
    document.documentElement.setAttribute('data-theme', theme);
  }, [theme]);

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
      const payload = { ...formData };
      // Remove id if it's null/empty so backend generates a new one for creates
      if (!payload.id || payload.id === "") {
        delete payload.id;
      }

      const response = await fetch(`${API_BASE}/employee`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(payload),
      });

      if (response.ok) {
        await fetchEmployees(); // Refresh list
        handleCancel(); // Reset form
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

  const handleEdit = (emp) => {
    setFormData({
      id: emp.id,
      name: emp.name,
      role: emp.role || '',
      address: emp.address || '',
      hireDate: emp.hireDate || '',
      dob: emp.dob || '',
      manager: emp.manager || ''
    });
  };

  const handleCancel = () => {
    setFormData({ id: null, name: '', role: '', address: '', hireDate: '', dob: '', manager: '' });
  };

  const toggleTheme = () => {
    setTheme(prev => prev === 'dark' ? 'light' : 'dark');
  };

  return (
    <div className="App">
      <header className="App-header">
        <h1>Employee Tracking System</h1>
        <button onClick={toggleTheme} className="theme-toggle">
          {theme === 'dark' ? '☀️ Light Mode' : '🌙 Dark Mode'}
        </button>
      </header>
      <main className="container">
        <section className="form-section">
          <h2>{formData.id ? 'Edit Employee' : 'Add New Employee'}</h2>
          <form onSubmit={handleSubmit} className="employee-form">
            <div className="form-group">
              <label>Name</label>
              <input name="name" placeholder="Name" value={formData.name} onChange={handleInputChange} required />
            </div>
            <div className="form-group">
              <label>Role</label>
              <input name="role" placeholder="Role" value={formData.role} onChange={handleInputChange} />
            </div>
            <div className="form-group">
              <label>Address</label>
              <input name="address" placeholder="Address" value={formData.address} onChange={handleInputChange} />
            </div>
            <div className="form-group">
              <label>Hire Date</label>
              <input name="hireDate" type="date" value={formData.hireDate} onChange={handleInputChange} />
            </div>
            <div className="form-group">
              <label>Birthday</label>
              <input name="dob" type="date" value={formData.dob} onChange={handleInputChange} />
            </div>
            <div className="form-group">
              <label>Manager</label>
              <input name="manager" placeholder="Manager Name" value={formData.manager} onChange={handleInputChange} />
            </div>
            <div className="form-actions">
              <button type="submit">{formData.id ? 'Update Employee' : 'Add Employee'}</button>
              {formData.id && <button type="button" onClick={handleCancel} className="cancel-btn">Cancel</button>}
            </div>
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
                    <strong>{emp.name}</strong> <small>(ID: {emp.id})</small> <span>({emp.role})</span>
                    <br/>
                    <small>Manager: {emp.manager || 'N/A'} | Hired: {emp.hireDate} | DOB: {emp.dob} | Address: {emp.address || 'N/A'}</small>
                  </div>
                  <div className="item-actions">
                    <button onClick={() => handleEdit(emp)} className="edit-btn">Edit</button>
                    <button onClick={() => handleDelete(emp.id)} className="delete-btn">Delete</button>
                  </div>
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