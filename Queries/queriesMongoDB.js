-- Query 1 - Cidades com departamentos
db.departments.distinct("location.city");

-- Query 2 - Empregados com mudanças de empregos
db.employees.aggregate([ { '$project': { '_id': 0, 'first_name': 1, 'ocorrencias': { '$size': { '$ifNull': [ '$job_history', [] ] } } } }, { '$match': { 'ocorrencias': {'$gt': 0 } } }, { '$sort': { 'ocorrencias': -1 } }]);

-- Query 3 - Conteudo geral da BD
db.employees.aggregate([{$lookup: { from: 'departments', localField: 'department_id', foreignField: 'department_id', as: 'departments'}}]).pretty();

-- Query 4 - Empregados que iniciam com a letra J
db.employees.find({"first_name": /^J.*/}, {_id: 0, job: 0, job_history: 0, department: 0}).pretty();

-- Query 5 - Listar os presidentes
db.employees.find({"job.job_title": "President"}, {_id: 0, employee_id: 0, last_name: 0, email: 0, phone_number: 0, job_id: 0, commission_pct: 0, manager_id: 0, job: 0, job_history: 0, department: 0}).pretty();

-- Query 6 - Top 5 bem pagos
db.employees.find({}, {_id: 0, job: 0, job_history: 0, department: 0}).sort({salary:-1}).limit(5).pretty();

-- Query 7 - Nome dos departamentos por País e Código Postal
db.departments.find({}, {_id: 0, "location.postal_code": 1, department_name: 1, "location.country.country_name": 1}).pretty();

-- Query 8 - Top salário médio por departamento e cidade
db.departments.aggregate(
    [
    {
        '$lookup': {
            'from': 'employees', 
            'localField': 'department_id', 
            'foreignField': 'department_id', 
            'as': 'employees'
        }
    }, {
        '$unwind': {
            'path': '$employees', 
            'includeArrayIndex': 'index'
        }
    }, {
        '$addFields': {
            'soma_salario': {
                '$sum': [
                    '$employees.job.max_salary', '$employees.job.min_salary'
                ]
            }
        }
    }, {
        '$addFields': {
            'salario_medio': {
                '$divide': [
                    '$soma_salario', 2
                ]
            }
        }
    }, {
        '$project': {
            '_id': 0, 
            'department_name': 1, 
            'location.city': 1, 
            'salario_medio': 1
        }
    }, {
        '$unwind': {
            'path': '$department_name'
        }
    }, {
        '$group': {
            '_id': null, 
            'resultado': {
                '$addToSet': {
                    'department_name': '$department_name', 
                    'city': '$location.city', 
                    'salario_medio': '$salario_medio'
                }
            }
        }
    }, {
        '$project': {
            'resultado': 1, 
            '_id': 0
        }
    }, {
        '$unwind': {
            'path': '$resultado'
        }
    }, {
        '$sort': {
            'resultado.salario_medio': -1
        }
    }
]
)