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
              <th>Role</th> 
              <th>Manager</th>
              <th>Hire Date</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            {employees.map((emp) => (
              <tr key={emp.id}>
                <td>{emp.name}</td>
                <td>{emp.role}</td>
                <td>{emp.manager || 'N/A'}</td> {/* Display N/A if null */}
                <td>{emp.hireDate}</td>
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
