SELECT * FROM books;
SELECT * FROM branch;
SELECT * FROM employee;
SELECT * FROM members;
SELECT * FROM issued_status;

DESC books;
DESC branch;
DESC employee;
DESC members;
DESC issued_status;
-- Project Tasks

-- CRUD Operations

-- Task 1. Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 
--         'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"

INSERT INTO books (isbn, book_title, category, rental_price, status, author, publisher) 
VALUES ('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');
SELECT * FROM books;

-- Task 2: Update an Existing Member's Address
UPDATE members 
SET member_address='125 Oak St'
where member_id='C103';

-- Delete a Record from the Issued Status Table 
-- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.
DELETE FROM issued_status 
where issued_id='IS121';

--Task 4: Retrieve All Books Issued by a Specific Employee
-- Objective: Select all books issued by the employee with emp_id = 'E101'.

SELECT * FROM issued_status
WHERE issued_emp_id= 'E101';

--Task 5: List Members Who Have Issued More Than One Book 
-- Objective: Use GROUP BY to find members who have issued more than one book.
SELECT issued_member_id FROM issued_status
GROUP BY issued_member_id
HAVING COUNT(issued_book_name)>1;
--OR
SELECT
    issued_member_id,
    COUNT(*)
FROM issued_status
GROUP BY 1
HAVING COUNT(*) > 1;

--CTAS (Create Table As Select)

-- Task 6: Create Summary Tables: Use CTAS to generate new tables based on query results 
-- each book and total book_issued_cnt**

CREATE TABLE book_issue_cnt AS
SELECT b.isbn, b.book_title, COUNT(i.issued_id) as issued_count
FROM books b
JOIN issued_status i
ON b.isbn=i.issued_book_isbn
GROUP BY 1,2;

SELECT * FROM book_issue_cnt;

-- 4. Data Analysis & Findings
-- The following SQL queries were used to address specific questions:

-- Task 7. Retrieve All Books in a Specific Category:
SELECT * FROM books 
WHERE category='Dystopian';

-- Task 8: Find Total Rental Income by Category:
SELECT b.category, SUM(b.rental_price) AS total_rental_income, COUNT(*) num_books 
FROM issued_status i
JOIN books b 
ON i.issued_book_isbn=b.isbn
GROUP BY category;

-- Task 9: List Members Who Registered in the Last 1000 Days:
SELECT * FROM members
WHERE reg_date >= CURRENT_DATE - INTERVAL '1000 days';
-- INSERT INTO members
INSERT INTO members(member_id, member_name, member_address, reg_date)
VALUES	
	('C120', 'Sam', '145 Main St', '2024-06-01'),
	('C121', 'John', '133 Main St', '2024-05-01');

-- Task 10: List Employees with Their Branch Manager's Name and their branch details:
SELECT e1.emp_id, e1.emp_name, e1.position, e1.salary, b.*, e2.emp_name branch_manager
FROM employee e1
JOIN branch b 
ON e1.branch_id=b.branch_id
JOIN employee e2
ON b.manager_id=e2.emp_id;

-- Task 11: Create a Table of Books with Rental Price Above a Certain Threshold:
CREATE TABLE book_rent_th AS
SELECT * FROM books 
WHERE rental_price>=6.00;

SELECT * FROM book_rent_th;

-- Task 12: Retrieve the List of Books Not Yet Returned
SELECT * FROM issued_status as ist
LEFT JOIN
return_status as rs
ON rs.issued_id = ist.issued_id
WHERE rs.return_id IS NULL;


