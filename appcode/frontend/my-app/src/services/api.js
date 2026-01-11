// Simulating an async database call
const MOCK_DATA = [
  { id: 1, name: "Alice Smith", address: "123 Maple St, FL", dob: "1990-05-15", 
    role: "Software Engineer", hireDate: "2020-01-15", manager: "Bob Jones" },
  { id: 2, name: "Bob Jones", address: "456 Oak Ave, NY", dob: "1985-11-22", 
    role: "Engineering Manager", hireDate: "2015-03-10", manager: null }, // Manager is nullable
];

export const getEmployees = async () => {
  return new Promise((resolve) => setTimeout(() => resolve([...MOCK_DATA]), 500));
};

export const saveEmployee = async (employee) => {
  return new Promise((resolve) => {
    setTimeout(() => {
      if (employee.id) {
        const index = MOCK_DATA.findIndex(e => e.id === employee.id);
        MOCK_DATA[index] = employee;
      } else {
        const newEmp = { ...employee, id: Date.now() };
        MOCK_DATA.push(newEmp);
      }
      resolve();
    }, 500);
  });
};
