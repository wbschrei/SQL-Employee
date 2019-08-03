drop table if exists departments;
drop table if exists dept_emp;
drop table if exists dept_manager;
drop table if exists employees;
drop table if exists salaries;
drop table if exists title;

Create table departments (
	dept_no char(4) not null primary key,
	dept_name varchar(50));
	
select * from departments;

Create table dept_emp (
	emp_no int not null references employees(emp_no),
	dept_no char(4) not null references departments(dept_no),
	from_date date,
	to_date	date);
	
select * from dept_emp;	
	
Create table dept_manager (
	dept_no char(4) not null references departments(dept_no),
	emp_no int not null references employees(emp_no),
	from_date	date,
	to_date	date);	
	
select * from dept_manager;		
	
Create table employees (
	emp_no int not null primary key,
	birth_date	date,
	first_name varchar(20),
	last_name varchar(30),
	gender	char(1),	
	hire_date date);
		
select * from employees;		

Create table salaries (
	emp_no int not null references employees(emp_no),
	salary int,
	from_date date,
	to_date	date);	
	
select * from salaries;		
	
Create table title (
	emp_no int not null references employees(emp_no),
	title varchar(30),
	from_date date,
	to_date	date);	
	
select * from title;		
	
SELECT 'postgresql' AS dbms,t.table_catalog,t.table_schema,t.table_name,c.column_name,c.ordinal_position,c.data_type,c.character_maximum_length,n.constraint_type,k2.table_schema,k2.table_name,k2.column_name FROM information_schema.tables t NATURAL LEFT JOIN information_schema.columns c LEFT JOIN(information_schema.key_column_usage k NATURAL JOIN information_schema.table_constraints n NATURAL LEFT JOIN information_schema.referential_constraints r)ON c.table_catalog=k.table_catalog AND c.table_schema=k.table_schema AND c.table_name=k.table_name AND c.column_name=k.column_name LEFT JOIN information_schema.key_column_usage k2 ON k.position_in_unique_constraint=k2.ordinal_position AND r.unique_constraint_catalog=k2.constraint_catalog AND r.unique_constraint_schema=k2.constraint_schema AND r.unique_constraint_name=k2.constraint_name WHERE t.TABLE_TYPE='BASE TABLE' AND t.table_schema NOT IN('information_schema','pg_catalog');


-- analysis below

-- employee: employee number, last name, first name, gender, and salary

/*
from "order" o inner join shippingmethod sm
		on o.shippingmethodid = sm.shippingmethodid
	inner join orderdetails od 
		on o.orderid = od.orderid
	inner join product p
		on od.productid = p.productid	
where "order".orderid = o.orderid																
group by o.orderid
*/
	
		
select ee.emp_no, ee.last_name, ee.first_name, ee.gender, sal.salary
from employees as ee
   left join salaries as sal
   on (ee.emp_no = sal.emp_no)
order by ee.emp_no;
		
select ee.emp_no, ee.last_name, ee.first_name, ee.hire_date
from employees as ee
WHERE
      ee.hire_date >= '1986-01-01'
  AND ee.hire_date <= '1986-12-31'
order by ee.emp_no;

-- manager of each department: department number, department name, 
-- manager's employee number, last name, first name, and start and end employment dates 

select d.dept_no, d.dept_name, dm.emp_no, dm.from_date, dm.to_date, ee.first_name, ee.last_name
from departments as d
   left join dept_manager as dm
   on (d.dept_no = dm.dept_no)
   left join employees as ee
   on (dm.emp_no = ee.emp_no)
order by d.dept_no;

-- department of each employee: employee number, last name, first name, and department name

select ee.emp_no, ee.last_name, ee.first_name, d.dept_name
from employees as ee
   left join dept_emp as de
   on (ee.emp_no = de.emp_no)
   left join departments as d
   on (ee.emp_no = de.emp_no)
order by ee.emp_no;

-- employees whose first name is "Hercules" and last names begin with "B."

select ee.first_name, ee.last_name
from employees as ee
where ee.first_name = 'Hercules'
and ee.last_name like 'B%';

-- employees in the Sales department, including their employee number, last name, 
-- first name, and department name

select d.dept_name
from departments as d
order by d.dept_name;

select ee.emp_no, ee.last_name, ee.first_name, d.dept_name
from employees as ee
   left join dept_emp as de
   on (ee.emp_no = de.emp_no)
   left join departments as d
   on (ee.emp_no = de.emp_no)
where d.dept_name = 'Sales'
order by ee.last_name;

-- employees in the Sales and Development departments, including their employee number, 
-- last name, first name, and department name

select ee.emp_no, ee.last_name, ee.first_name, d.dept_name
from employees as ee
   left join dept_emp as de
   on (ee.emp_no = de.emp_no)
   left join departments as d
   on (ee.emp_no = de.emp_no)
where d.dept_name = 'Sales'
or d.dept_name = 'Development'
order by ee.last_name;

-- In descending order, list the frequency count of employee last names, 
-- i.e., how many employees share each last name.

/*
select c.customerid, customername, count(o.orderid) as numberoforders
from customer c left join "order" o
	on c.customerid = o.customerid
where c.customerid > 1
group by c.customerid, c.customername
having count(o.orderid) > 3
order by count(o.orderid) desc;
*/

select ee.last_name, count(ee.last_name)
from employees as ee
group by ee.last_name
order by count(ee.last_name) desc;

select ee.emp_no, ee.last_name
from employees as ee
where ee.emp_no = 499942;

