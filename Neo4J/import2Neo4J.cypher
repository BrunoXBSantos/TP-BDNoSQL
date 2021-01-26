////////// 1. INSERIR INFORMACOES GERAIS. //////////////

// Informações dos paises
LOAD CSV WITH HEADERS FROM 'file:///countries.csv' AS row
CREATE (country:Country {idCountry: row.COUNTRY_ID}) 
SET country.nameCountry= row.COUNTRY_NAME, 
	country.idRegion = row.REGION_ID
RETURN country;

// Informações das regioes
LOAD CSV WITH HEADERS FROM 'file:///regions.csv' AS row
CREATE (region:Region {nameRegion: row.REGION_NAME}) 
SET region.idRegion= row.REGION_ID 
RETURN region;

// Informações dos departamentos
LOAD CSV WITH HEADERS FROM 'file:///departments.csv' AS row
CREATE (department:Department {idDepartment: row.DEPARTMENT_ID}) 
SET department.nameDepartmant= row.DEPARTMENT_NAME, 
	department.idManager = row.MANAGER_ID,
    department.idLocation = row.LOCATION_ID
RETURN department;

// Informações dos funcionarios
LOAD CSV WITH HEADERS FROM 'file:///employees.csv' AS row
CREATE (employee:Employee {firstName: row.FIRST_NAME}) 
SET employee.lastName= row.LAST_NAME, 
	employee.email = row.EMAIL,
    employee.phoneNumber = row.PHONE_NUMBER,
    employee.hireDate = row.HIRE_DATE,
    employee.idJob = row.JOB_ID,
    employee.salary = row.SALARY,
    employee.comission_pct = row.COMISSION_PCT,
    employee.idManager = row.MANAGER_ID,
    employee.idDepartment = row.DEPARTMENT_ID,
    employee.idEmployee = row.EMPLOYEE_ID
RETURN employee;

// Informações do historial dos trabalhos
LOAD CSV WITH HEADERS FROM 'file:///job_history_departments_jobs.csv' AS row
CREATE (job_history:Job_History {idEmployee: row.EMPLOYEE_ID}) 
SET job_history.startDate= row.START_DATE, 
	job_history.endDate = row.END_DATE,
    job_history.department_name = row.DEPARTMENT_NAME,
    job_history.manager_id = row.MANAGER_ID,
    job_history.job_title= row.JOB_TITLE, 
	job_history.min_salary = row.min_salary,
    job_history.max_salary = row.max_salary
RETURN job_history;

// Informações dos jobs
LOAD CSV WITH HEADERS FROM 'file:///jobs.csv' AS row
CREATE (job:Job {idJob: row.JOB_ID}) 
SET job.jobTitle= row.JOB_TITLE, 
	job.minSalary = row.MIN_SALARY,
    job.maxSalary = row.MAX_SALARY
RETURN job;

// Informações das localizacoes
LOAD CSV WITH HEADERS FROM 'file:///locations.csv' AS row
CREATE (location:Location {idLocation: row.LOCATION_ID}) 
SET location.streerAddress= row.STREET_ADDRESS, 
	location.postalCode = row.POSTAL_CODE,
    location.city = row.CITY,
    location.stateProvince = row.STATE_PROVINCE,
    location.idCountry = row.COUNTRY_ID
RETURN location;



////////// 2. INSERIR RELACOES ENTRE NODOSS. //////////////

// Relação Employee -> Job
// Relação Employee -> Department
LOAD CSV WITH HEADERS FROM 'file:///employees.csv' AS row
MATCH (employee:Employee {idEmployee: row.EMPLOYEE_ID})
MATCH (job:Job {idJob: row.JOB_ID})
MATCH (department:Department {idDepartment: row.DEPARTMENT_ID})

CREATE (employee)-[:TRABALHA_EM]->(job)
CREATE (employee)-[:PERTENCE]->(department)
RETURN employee, job, department;

// Relação Employee -> job_history_departments_jobs
LOAD CSV WITH HEADERS FROM 'file:///employees.csv' AS row
MATCH (job_history:Job_History {idEmployee: row.EMPLOYEE_ID})
MATCH (employee:Employee {idEmployee: row.EMPLOYEE_ID})

CREATE (job_history)-[:ANTIGO_JOB]->(employee)
RETURN employee,job_history;

// Relação Department -> Locations
LOAD CSV WITH HEADERS FROM 'file:///departments.csv' AS row
MATCH (department:Department {idLocation: row.LOCATION_ID})
MATCH (location:Location {idLocation: row.LOCATION_ID})

CREATE (department)-[:ESTA_PRESENTE]->(location)
RETURN department,location;

// Relação Staff-Morada
// Relação Staff-Loja
LOAD CSV WITH HEADERS FROM 'file:///staff.csv' AS row
MATCH (staff:Staff {idStaff: row.idStaff})
MATCH (store:Store {idStore: row.idStore})
MATCH (address:Address {idAddress: row.idAddress})

CREATE (staff)-[:VIVE_EM]->(address)
CREATE (staff)-[:TRABALHA_EM]->(store)
RETURN staff,address,store;


match (n) return n
match (n) detach delete n

match (e:Employee{firstName:"Neena"}) -- (p)
return e, p