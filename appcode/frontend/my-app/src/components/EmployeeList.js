import React from 'react';

export default function EmployeeList({ employees, onEdit }) {
  return (
    <div className="card">
      <h3>Employee Directory</h3>
      {employees.length === 0 ? (
        <p>No employees found.</p>
      ) : (
        <table className="table">
          <thead>
            <tr>
              <th>Name</th>
              <th>Address</th>
              <th>DOB</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            {employees.map((emp) => (
              <tr key={emp.id}>
                <td>{emp.name}</td>
                <td>{emp.address}</td>
                <td>{emp.dob}</td>
                <td>
                  <button onClick={() => onEdit(emp)} className="btn-sm">Edit</button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      )}
    </div>
  );
}
