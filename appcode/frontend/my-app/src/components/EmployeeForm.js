import React, { useState, useEffect } from 'react';

export default function EmployeeForm({ currentEmployee, onSave, onCancel }) {
  const [formData, setFormData] = useState({ 
    name: '', 
    address: '', 
    dob: '', 
    role: '', 
    hireDate: '', 
    manager: '' // Can be nullable in data storage, but input handles string
  });

  // Populate form if editing an existing employee
  useEffect(() => {
    if (currentEmployee) {
      setFormData(currentEmployee);
    } else {
      setFormData({ name: '', address: '', dob: '', role: '', hireDate: '', manager: '' });
    }
  }, [currentEmployee]);

  const updateField = (e) => {
    setFormData({ ...formData, [e.target.name]: e.target.value });
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    onSave(formData);
  };

  return (
    <div className="card">
      <h3>{currentEmployee ? 'Edit Employee' : 'Add New Employee'}</h3>
      <form onSubmit={handleSubmit}>
        {/* Existing Fields */}
        <div className="form-group">
          <label>Name</label>
          <input type="text" name="name" value={formData.name} onChange={updateField} required />
        </div>
        <div className="form-group">
          <label>Address</label>
          <input type="text" name="address" value={formData.address} onChange={updateField} required />
        </div>
        <div className="form-group">
          <label>Date of Birth</label>
          <input type="date" name="dob" value={formData.dob} onChange={updateField} required />
        </div>

        {/* New Fields */}
        <div className="form-group">
          <label>Job Role</label>
          <input type="text" name="role" value={formData.role} onChange={updateField} required />
        </div>
        <div className="form-group">
          <label>Hire Date</label>
          <input type="date" name="hireDate" value={formData.hireDate} onChange={updateField} required />
        </div>
        <div className="form-group">
          <label>Manager Name (Optional)</label>
          <input type="text" name="manager" value={formData.manager || ''} onChange={updateField} />
        </div>

        <div className="btn-group">
          <button type="submit" className="btn primary">Save</button>
          {currentEmployee && (
            <button type="button" onClick={onCancel} className="btn secondary">Cancel</button>
          )}
        </div>
      </form>
    </div>
  );
}
