import React, { useState, useEffect } from 'react';

export default function EmployeeForm({ currentEmployee, onSave, onCancel }) {
  const [formData, setFormData] = useState({ name: '', address: '', dob: '' });

  // Populate form if editing an existing employee
  useEffect(() => {
    if (currentEmployee) {
      setFormData(currentEmployee);
    } else {
      setFormData({ name: '', address: '', dob: '' });
    }
  }, [currentEmployee]);

  const handleSubmit = (e) => {
    e.preventDefault();
    onSave(formData);
  };

  return (
    <div className="card">
      <h3>{currentEmployee ? 'Edit Employee' : 'Add New Employee'}</h3>
      <form onSubmit={handleSubmit}>
        <div className="form-group">
          <label>Name</label>
          <input
            type="text"
            value={formData.name}
            onChange={(e) => setFormData({ ...formData, name: e.target.value })}
            required
          />
        </div>
        <div className="form-group">
          <label>Address</label>
          <input
            type="text"
            value={formData.address}
            onChange={(e) => setFormData({ ...formData, address: e.target.value })}
            required
          />
        </div>
        <div className="form-group">
          <label>Date of Birth</label>
          <input
            type="date"
            value={formData.dob}
            onChange={(e) => setFormData({ ...formData, dob: e.target.value })}
            required
          />
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
