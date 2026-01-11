// Simulating an async database call
const MOCK_DATA = [
  { id: 1, name: "Alice Smith", address: "123 Maple St, FL", dob: "1990-05-15" },
  { id: 2, name: "Bob Jones", address: "456 Oak Ave, NY", dob: "1985-11-22" },
];

export const getEmployees = async () => {
  return new Promise((resolve) => setTimeout(() => resolve([...MOCK_DATA]), 500));
};

export const saveEmployee = async (employee) => {
  return new Promise((resolve) => {
    setTimeout(() => {
      if (employee.id) {
        // Update existing
        const index = MOCK_DATA.findIndex(e => e.id === employee.id);
        MOCK_DATA[index] = employee;
      } else {
        // Add new
        const newEmp = { ...employee, id: Date.now() };
        MOCK_DATA.push(newEmp);
      }
      resolve();
    }, 500);
  });
};


// const API_URL = "your-azure-app.azurewebsites.net"; 
// // ^ Make sure to add https:// and the /api/employees endpoint

// export const getEmployees = async () => {
//   const response = await fetch(API_URL);
//   if (!response.ok) throw new Error('Failed to fetch employees');
//   return response.json();
// };

// export const saveEmployee = async (employee) => {
//   const method = employee.id ? 'PUT' : 'POST'; // Use PUT for updates, POST for new
//   const url = employee.id ? `${API_URL}/${employee.id}` : API_URL;

//   const response = await fetch(url, {
//     method: method,
//     headers: {
//       'Content-Type': 'application/json',
//     },
//     body: JSON.stringify(employee),
//   });

//   if (!response.ok) throw new Error(`Failed to ${method === 'POST' ? 'add' : 'update'} employee`);
//   // If your Azure API returns the saved object, you can return response.json() here.
// };
