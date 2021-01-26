// QUERIES Neo4J

// 1 -> Retorna o numero de departamentos por localização
match (d:Department) -[r:SEDIADO_EM]-> (l:Location)  
return DISTINCT l.city AS City, count(r) as Number

// 2 ->  Retorna o numero de trabalhos antigos de cada funcionário
match (e:Employee) -[r:TRABALHOU_EM]-> (a:Job_History)  
return e.firstName as Name, count(r) as NumberJobs

// 3 -> Consulta geral da BD
macth (n)  
return n

// 4 -> Empregados que iniciam com a letra J
match (e:Employee)  
WHERE e.firstName =~'J.*'  
return e

// 5 -> Retorna o Presidente 
match (n:Employee) -[:TRABALHA_EM]-> (:Job{jobTitle:"President"})  
return n.firstName as Name, n.hireDate as HireDate, n.salary as Salary  

// 6 -> Retorna top 5 dos salários mais altos por funcionarios
match (e:Employee)  
return e.firstName as Name, toInteger(e.salary) as Salary  
order by toInteger(e.salary) desc  
limit 5;

// 7 ->

// 8 ->
