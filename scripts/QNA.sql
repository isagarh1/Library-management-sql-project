-- Explore the data :

SELECT * FROM books;
SELECT * FROM branch;
SELECT * FROM employees;
SELECT * FROM issued_status;
SELECT * FROM members;
SELECT * FROM return_status;

-- Project Task :
-- * CRUD Operations :

-- Q1. Create a New Book Record :
-- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"

INSERT INTO books (isbn,book_title,category,rental_price,status,author,publisher)
VALUES('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')

--Q2. Update an Existing Member's Address : '125 Oak St' 'C103': 
SELECT * FROM members;

UPDATE members
SET member_address = '125 Oak St'
WHERE member_id = 'C103'

--Q3. Delete a Record from the Issued Status Table -- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.
SELECT * FROM issued_status;

DELETE FROM issued_status
WHERE issued_id ='IS121';

--Q4. Retrieve All Books Issued by a Specific Employee -- Objective: Select all books issued by the employee with emp_id = 'E101'. 
SELECT * FROM issued_status;

SELECT * 
FROM issued_status WHERE issued_emp_id = 'E101';

--Q5. List Members Who Have Issued More Than One Book -- Objective: Use GROUP BY to find members who have issued more than one book. 

SELECT 
	m.member_id,
	COUNT(*) total_count
FROM members m
LEFT JOIN issued_status iss
ON m.member_id = iss.issued_member_id
GROUP BY m.member_id
HAVING COUNT(*) > 1

--  Data Analysis & Findings :

--Q1. Retrieve All Books in a Specific Category:
SELECT
*
FROM books
WHERE category ='Science Fiction'

--Q2.  Find Total Rental Income by Category:
SELECT 
	category,
	SUM(rental_price) total_rent
	--COUNT(*) total_count_category
FROM books b
JOIN issued_status iss
ON b.isbn = iss.issued_book_isbn
GROUP BY category
ORDER BY total_rent DESC

--Q3. List Members Who Registered in the Last 180 Days:
SELECT 
	member_id,
	member_name,
	reg_date
FROM members
WHERE reg_date > = CURRENT_DATE - INTERVAL '180 days'
ORDER BY reg_date DESC;

--Q4. List Employees with Their Branch Manager's Name and their branch details

SELECT 
	e.emp_id,
	e.emp_name,
	e.position,
	b.branch_id,
em.emp_name AS manager_name
FROM employees e
JOIN branch b
on e.branch_id = b.branch_id
JOIN employees em
ON b.manager_id = em.emp_id

--Q5.  Retrieve the List of Books Not Yet Returned
SELECT 
	iss.issued_book_name
FROM issued_status iss
LEFT JOIN return_status rs
ON iss.issued_id = rs.issued_id
WHERE rs.return_id IS NULL

-- Advanced Operations :

--Q: Identify Members with Overdue Books :
/* Write a query to identify members who have overdue books (assume a 30-day return period). 
   Display the member's_id, member's name, book title, issue date, and days overdue.*/

SELECT 
	m.member_id,
	m.member_name,
	b.book_title,
	ist.issued_date,
	--rs.return_date,
	CURRENT_DATE - ist.issued_Date AS over_due
	--rs.return_id
FROM issued_status AS ist
LEFT JOIN members AS m
ON 
ist.issued_member_id = m.member_id 
LEFT JOIN books AS b
ON 
b.isbn = ist.issued_book_isbn
LEFT JOIN return_status AS rs
ON
rs.issued_id = ist.issued_id
WHERE rs.return_date IS NULL 
AND 
CURRENT_DATE - ist.issued_Date > 365
ORDER BY m.member_id;

--Q: Branch Performance Report :
/* Create a query that generates a performance report for each branch, 
   showing the number of books issued, 
   the number of books returned, and the total revenue generated from book rentals.
*/

SELECT 
	b.branch_id,
	COUNT(DISTINCT ist.issued_id) head_countbk_issued,
	COUNT(DISTINCT rs.return_id) returned_book,
	SUM(bk.rental_price) total_rental_books
FROM branch b
LEFT JOIN employees e
ON
b.branch_id = e.branch_id
LEFT JOIN issued_status ist
ON 
e.emp_id = ist.issued_emp_id
LEFT JOIN books bk
ON
bk.isbn = ist.issued_book_isbn
LEFT JOIN return_status rs
ON 
ist.issued_id = rs.issued_id
GROUP BY b.branch_id

--Q. : Find Employees with the Most Book Issues Processed
/* Write a query to find the top 3 employees who have processed the most book issues. 
   Display the employee name, number of books processed, and their branch.
*/

SELECT 
	e.emp_name,
	b.branch_id,
	COUNT(ist.issued_id) AS num_of_issued
FROM employees e
LEFT JOIN issued_status ist
ON e.emp_id = ist.issued_emp_id
LEFT JOIN books bk
ON ist.issued_book_isbn = bk.isbn
LEFT JOIN branch b
ON b.branch_id = e.branch_id
GROUP BY e.emp_name, b.branch_id
ORDER BY num_of_issued DESC
LIMIT 3;
