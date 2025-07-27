CREATE TABLE branch (
    branch_id VARCHAR(10)PRIMARY KEY,
    manager_id VARCHAR(10),
    branch_address TEXT,
    contact_no VARCHAR(15)
);

CREATE TABLE books (
    isbn VARCHAR(20) PRIMARY KEY,
    book_title VARCHAR(80) ,
    category VARCHAR(50),
    rental_price float,
    status VARCHAR(20),
    author VARCHAR(100),
    publisher VARCHAR(100)
);

CREATE TABLE employee (
    emp_id VARCHAR(10) PRIMARY KEY,
    emp_name VARCHAR(100),
    position VARCHAR(50),
    salary DECIMAL(10, 2),
    branch_id VARCHAR(10)
);

CREATE TABLE ISSUED_STATUS (
    issued_id VARCHAR(10) PRIMARY KEY,
    issued_member_id VARCHAR(10),--fk
    issued_book_name VARCHAR(100),
    issued_date DATE,
    issued_book_isbn VARCHAR(20),--fk
    issued_emp_id VARCHAR(10)--fk
);
CREATE TABLE members (
    member_id VARCHAR(10) PRIMARY KEY,
    member_name VARCHAR(100),
    member_address TEXT,
    reg_date DATE
);

CREATE TABLE return_status (
    return_id VARCHAR(10) PRIMARY KEY,
    issued_id VARCHAR(10),
    return_book_name VARCHAR(100),
    return_date DATE,
    return_book_isbn VARCHAR(20)
);

Alter table ISSUED_STATUS
add  constraint fk_members
foreign key(issued_member_id)
references members(member_id)

Alter table ISSUED_STATUS
add  constraint fk_books
foreign key(issued_book_isbn)
references books(isbn)

ALTER TABLE ISSUED_STATUS
ADD CONSTRAINT fk_employee
FOREIGN KEY (issued_emp_id)
REFERENCES employee(emp_id);

ALTER TABLE branch
ADD CONSTRAINT pk_branch PRIMARY KEY (branch_id);


ALTER TABLE employee
ADD CONSTRAINT fk_branch
FOREIGN KEY (branch_id)
REFERENCES branch(branch_id);


ALTER TABLE return_status
ADD CONSTRAINT fk_issued_status
FOREIGN KEY (issued_id)
REFERENCES ISSUED_STATUS(issued_id);


ALTER TABLE return_status
DROP CONSTRAINT return_status_pkey;


ALTER TABLE return_status
ADD CONSTRAINT pk_return_status PRIMARY KEY (issued_id);


ALTER TABLE return_status
ADD CONSTRAINT fk_issued_status
FOREIGN KEY (issued_id)
REFERENCES issued_status(issued_id);
INSERT INTO issued_status (
    issued_id,
    issued_member_id,
    issued_book_name,
    issued_date,
    issued_book_isbn,
    issued_emp_id
)
VALUES (
    'IS103',
    'M101',              -- Must already exist in `members`
    'Python Programming',
    '2025-07-22',
    'ISBN123',           -- Must already exist in `books`
    'E101'               -- Must already exist in `employees`
);

INSERT INTO return_status (
    return_id,
    issued_id,
    return_book_name,
    return_date,
    return_book_isbn
)
VALUES (
    'R103',
    'IS103',
    'Python Programming',
    '2025-07-24',
    'ISBN123'
);


INSERT INTO issued_status (
    issued_id,
    issued_member_id,
    issued_book_name,
    issued_date,
    issued_book_isbn,
    issued_emp_id
)
VALUES (
    'IS105',
    'M101',               -- must exist in `members`
    'Python Programming',
    '2025-07-20',
    'ISBN123',            -- must exist in `books`
    'E101'                -- must exist in `employees`
);
INSERT INTO return_status (
    return_id,
    issued_id,
    return_book_name,
    return_date,
    return_book_isbn
)
VALUES (
    'R105',
    'IS105',
    'Python Programming',
    '2025-07-24',
    'ISBN123'
);

INSERT INTO issued_status (
    issued_id,
    issued_member_id,
    issued_book_name,
    issued_date,
    issued_book_isbn,
    issued_emp_id
)
VALUES (
    'IS101',
    'M101',  -- this must exist in members table
    'Python Programming',
    '2025-07-20',
    'ISBN123',  -- must exist in books table (if FK enforced)
    'E101'      -- must exist in employees table
);
INSERT INTO books (
    isbn,
    book_title,
    category,
    rental_price,
    status,
    author,
    publisher
)
VALUES (
    'ISBN123',
    'Python Programming',
    'Computer Science',
    50.00,
    'Available',
    'John Doe',
    'TechPress'
);
INSERT INTO members (
    member_id,
    member_name,
    member_address,
    reg_date
)
VALUES (
    'M101',
    'Alice Joseph',
    '123 Library Street',
    '2025-07-01'
);


INSERT INTO return_status (
    return_id,
    issued_id,
    return_book_name,
    return_date,
    return_book_isbn
)
VALUES (
    'R101',
    'IS101',
    'Python Programming',
    '2025-07-24',
    'ISBN123'
);


-- Project Task

-- Task 1. Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"


INSERT INTO books(isbn, book_title, category, rental_price, status, author, publisher)
VALUES
('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');


-- Task 2: Update an Existing Member's Address
select * from members;

UPDATE members
SET member_address = '125 Main St'
WHERE member_id = 'C101';


Task 3: Delete a Record from the Issued Status Table 
-- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.
select * from ISSUED_STATUS

DELETE FROM ISSUED_STATUS
WHERE issued_id = 'IS121'

-- Task 4: Retrieve All Books Issued by a Specific Employee -- Objective: Select all books issued by the employee with emp_id = 'E101'.

SELECT * FROM ISSUED_STATUS where issued_emp_id = 'E101'


-- Task 5: List Members Who Have Issued More Than One Book -- Objective: Use GROUP BY to find members who have issued more than one book.

select issued_emp_id,count(*) issued_book from issued_status where 


SELECT issued_member_id, COUNT(*) AS books_issued
FROM ISSUED_STATUS
GROUP BY issued_member_id
HAVING COUNT(*) > 1;




-- CTAS
-- Task 6: Create Summary Tables: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**


select * from books as b
join 
issued_status as ist
on ist.issued_book_isbn=b.isbn

create table bookcounts 
as
select b.isbn,count(ist.issued_id),b.book_title  from books as b
join 
issued_status as ist
on ist.issued_book_isbn=b.isbn
group by b.isbn,b.book_title



-- Task 7. Retrieve All Books in a Specific Category:

SELECT * FROM books
WHERE category = 'Classic'


-- Task 8: Find Total Rental Income by Category:

select category,sum(rental_price) as Total_Rental
from books
group by category

select b.category,sum(b.rental_price) as Total_Rental,count(*)
from books as b
join 
issued_status as ist
on ist.issued_book_isbn=b.isbn
group by b.category


-- List Members Who Registered in the Last 180 Days:
SELECT *
FROM members
WHERE reg_date = CURRENT_DATE - INTERVAL '180 days';

-- task 10 List Employees with Their Branch Manager's Name and their branch details:


SELECT 
    e1.*,
    b.manager_id,
    e2.emp_name as manager
FROM employee as e1
JOIN  
branch as b
ON b.branch_id = e1.branch_id
JOIN
employee as e2
ON b.manager_id = e2.emp_id

-- Task 12: Retrieve the List of Books Not Yet Returned

SELECT 
    DISTINCT ist.issued_book_name
FROM issued_status as ist
LEFT JOIN
return_status as rs
ON ist.issued_id = rs.issued_id
WHERE rs.return_id IS NULL

    
SELECT * FROM return_status
