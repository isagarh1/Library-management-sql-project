-- Project : Library Management :-

-- Creating Tables :

DROP TABLE IF EXISTS branch;

CREATE TABLE branch(
	branch_id			VARCHAR(10) PRIMARY KEY,
	manager_id			VARCHAR(10),
	branch_address		VARCHAR(25),
	contact_no			VARCHAR(25)
);

DROP TABLE IF EXISTS employees;

CREATE TABLE employees(
	emp_id				VARCHAR(10) PRIMARY KEY,
	emp_name			VARCHAR(25),
	position			VARCHAR(25),
	salary				INT,
	branch_id			VARCHAR(10)
);

-- Alter datatype INT to Numeric --
ALTER TABLE employees
ALTER COLUMN salary TYPE NUMERIC(10,2);

DROP TABLE IF EXISTS books;

CREATE TABLE books(
	isbn				VARCHAR(25) PRIMARY KEY,
	book_title			VARCHAR(75),
	category			VARCHAR(25),
	rental_price		FLOAT,
	status				VARCHAR(10),
	author				VARCHAR(50),
	publisher			VARCHAR(50)
);

DROP TABLE IF EXISTS issued_status;

CREATE TABLE issued_status(
	issued_id			VARCHAR(10) PRIMARY KEY,
	issued_member_id	VARCHAR(10), --
	issued_book_name	VARCHAR(75),
	issued_date			DATE,
	issued_book_isbn	VARCHAR(25),--
	issued_emp_id		VARCHAR(10) --
);


DROP TABLE IF EXISTS members;

CREATE TABLE members(
	member_id			VARCHAR(10) PRIMARY KEY,	
	member_name			VARCHAR(25),
	member_address		VARCHAR(50),		
	reg_date			DATE
);

DROP TABLE IF EXISTS return_status;

CREATE TABLE return_status(
	return_id			VARCHAR(10) PRIMARY KEY,
	issued_id			VARCHAR(10),--
	return_book_name	VARCHAR(75),
	return_date			DATE,
	return_book_isbn	VARCHAR(25)
);


