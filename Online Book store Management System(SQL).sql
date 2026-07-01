
-- create database 
CREATE TABLE onlinebookstore;

-- switch to the database 
\c onlinebookstore;

-- create tables
DROP  TABLE IF EXISTS Books;
CREATE TABLE Books(
		Book_ID SERIAL PRIMARY KEY,
		Title VARCHAR (100),
		Author VARCHAR (100),
		Genre VARCHAR (50),
		Published_year INT,
		Price NUMERIC(10,2),
		Stock INT
		);
DROP TABLE IF EXISTS Customers;
CREATE TABLE Customers(
		Customer_I SERIAL PRIMARY KEY,
		Name VARCHAR(100),
		Email VARCHAR(100),
		Phone VARCHAR(15),
		City VARCHAR(50),
		Country VARCHAR(150)
);
DROP TABLE IF EXISTS Orders;
CREATE TABLE Orders(
		Order_ID INT PRIMARY KEY,
		Customer_ID INT REFERENCES Customers(Customer_ID),
		Book_ID SERIAL REFERENCES Books(book_ID) ,
		Order_date DATE,
		Quantity INT,
		Total_amount NUMERIC(10,2)
);
SELECT*FROM BOOKS;
SELECT*FROM Customers;
SELECT*FROM Orders;

-- Retrive all books in the "fiction" genre:
SELECT *FROM Books
where Genre='Fiction';

--2) Find books published after the year 1950:
SELECT*FROM Books
WHERE Published_year>1950;

--3) list all customers from the canda:
SELECT*FROM customers
WHERE country='Canada';

--4) Show orders placed in november 2023:
SELECT*FROM Orders
WHERE Order_date BETWEEN '2023-11-01'AND '2023-11-30';

--5) Retrive the total stock of books available ;
SELECT SUM (stock) AS Total_stock
FROM Books;

--6) find the details of the most expensive book:
SELECT*FROM Books ORDER BY Price DESC;

--7) Show all customers who ordered more than 1 quantity of a book:
SELECT *FROM Orders
WHERE Quantity>1;

--8) Retrive all orders where the total amount exceeds $20:
SELECT*FROM Orders
WHERE total_amount>20; 

--9) list all grnres available in the lowest  stock :
SELECT DISTINCT genre FROM Books;

-- 10) Find  the book with the lowest stock :
SELECT* FROM Books ORDER BY stock ASC;

-- 11) Calculate the total revenue generated from all orders:
SELECT SUM (total_amount) AS Revenue
FROM Orders;

 --advance

 -- 1) Retrive the total number of books sold for each genre:
 SELECT B.Genre,SUM(o.quantity)
 FROM Orders o
 JOIN Books b ON b.book_id=o.book_id
 GROUP BY b.Genre;

 --2) find the average price of books in the "fantasy" genre:
 SELECT AVG(price) AS AVERAGE_PRICE
 FROM Books
 WHERE Genre="fantasy";

 --3) List customers who have placed at least  2 orders :
SELECT o.customer_id,c.name,COUNT(O.order_id) AS ORDER_COUNT
FROM orders o
join customers c ON o.customer_id=c.customer_id
GROUP BY o.customer_id,c.name
HAVING COUNT (Order_id)>=2;

--4) find the most frequently ordered book:
SELECT O.Book_id, b.title,COUNT(o.order_id) AS ORDER_COUNT
FROM orders o
JOIN books b ON o.book_id=b.book_id
GROUP BY O.book_id,b.title
ORDER BY ORDER_COUNT DESC LIMIT 1;

--5) SHOW the top 3 most expensive books of "fantasy" Genre:
SELECT*FROM books
WHERE genre ='Fantasy'
ORDER BY price DESC LIMIT 3;

--6) Retrive the total quantity of books sold by each author
SELECT b.author,SUM(o.quantity) AS Total_books_sold
FROM orders o
JOIN books b ON o.book_id=b.book_id
GROUP BY b.author;

-- 7) list the cities where customers who spent over $30 are located:
SELECT DISTINCT c.city
FROM orders o
JOIN customers c ON o.customer_id=c.customer_id
WHERE o.total_amount>30;

SELECT DISTINCT c.city,total_amount
FROM orders o
JOIN customers c ON o.customer_id=c.customer_id
WHERE o.total_amount>300;

--8)find the customer who spent the most on orders:
SELECT c.customer_id,c.name, SUM(o.total_amount) AS total_spent
FROM orders o
JOIN customers c ON o.customer_id=c.customer_id
GROUP BY c.customer_id,c.name
ORDER BY Total_spent Desc ;

-- 9) calculte the stock remaining after fulfilling all orders:
SELECT b.book_id,b.title,b.stock,COALESCE(SUM(o.quantity),0) AS order_quantity,
b.stock-COALESCE(SUM(o.quantity),0) AS Remaining_quantity
FROM books b
LEFT JOIN orders o ON b.book_id=o.book_id
GROUP BY b.book_id;
