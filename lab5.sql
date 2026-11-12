DROP DATABASE IF EXISTS car_rental_db;
CREATE DATABASE car_rental_db DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE car_rental_db;

CREATE TABLE CarClasses (
    class_id INT AUTO_INCREMENT PRIMARY KEY,
    class_name VARCHAR(50) NOT NULL,
    base_rate DECIMAL(10,2) NOT NULL
);

CREATE TABLE InsuranceTypes (
    insurance_id INT AUTO_INCREMENT PRIMARY KEY,
    insurance_name VARCHAR(50) NOT NULL,
    cost DECIMAL(10,2) NOT NULL
);

CREATE TABLE Employees (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    position VARCHAR(50) NOT NULL
);

CREATE TABLE Clients (
    client_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20) NOT NULL
);

CREATE TABLE Cars (
    car_id INT AUTO_INCREMENT PRIMARY KEY,
    brand VARCHAR(50) NOT NULL,
    license_plate VARCHAR(15) NOT NULL UNIQUE,
    class_id INT NOT NULL,
    CONSTRAINT fk_car_class FOREIGN KEY (class_id) REFERENCES CarClasses(class_id)
);

CREATE TABLE Contracts (
    contract_id INT AUTO_INCREMENT PRIMARY KEY,
    client_id INT NOT NULL,
    car_id INT NOT NULL,
    employee_id INT NOT NULL,
    insurance_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    CONSTRAINT fk_contract_client FOREIGN KEY (client_id) REFERENCES Clients(client_id),
    CONSTRAINT fk_contract_car FOREIGN KEY (car_id) REFERENCES Cars(car_id),
    CONSTRAINT fk_contract_employee FOREIGN KEY (employee_id) REFERENCES Employees(employee_id),
    CONSTRAINT fk_contract_insurance FOREIGN KEY (insurance_id) REFERENCES InsuranceTypes(insurance_id)
);

CREATE TABLE Payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    contract_id INT NOT NULL,
    payment_date DATE NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_payment_contract FOREIGN KEY (contract_id) REFERENCES Contracts(contract_id)
);

ALTER TABLE Clients ADD COLUMN driver_license VARCHAR(30);

INSERT INTO CarClasses (class_name, base_rate) VALUES
('Эконом', 2000.00), ('Комфорт', 3000.00), ('Бизнес', 5000.00), 
('Премиум', 8000.00), ('Внедорожник', 4500.00), ('Спорткар', 10000.00), ('Электромобиль', 3500.00);

INSERT INTO InsuranceTypes (insurance_name, cost) VALUES
('ОСАГО', 500.00), ('КАСКО', 1500.00), ('Полное покрытие', 2500.00), 
('Мини-страховка', 200.00), ('Расширенная', 1000.00), ('Без франшизы', 2000.00);

INSERT INTO Employees (full_name, position) VALUES
('Смирнов Алексей Викторович', 'Менеджер'), ('Кузнецов Дмитрий Сергеевич', 'Менеджер'),
('Иванова Елена Андреевна', 'Старший менеджер'), ('Орлов Максим Игоревич', 'Механик'),
('Зайцев Павел Олегович', 'Механик'), ('Морозов Андрей Николаевич', 'Директор');

INSERT INTO Clients (full_name, phone, driver_license) VALUES
('Иванов Иван Иванович', '+7 (900) 111-22-33', '77 11 123456'), ('Петров Петр Петрович', '+7 (911) 222-33-44', '77 22 654321'),
('Сидорова Анна Сергеевна', '+7 (922) 333-44-55', '77 33 112233'), ('Смирнов Олег Дмитриевич', '+7 (933) 444-55-66', '77 44 445566'),
('Кузнецова Мария Игоревна', '+7 (944) 555-66-77', '77 55 778899'), ('Попов Денис Алексеевич', '+7 (955) 666-77-88', '77 66 990011'),
('Васильев Артем Максимович', '+7 (966) 777-88-99', '77 77 223344'), ('Соколова Виктория Павловна', '+7 (977) 888-99-00', '77 88 556677');

INSERT INTO Cars (brand, license_plate, class_id) VALUES
('Kia Rio', 'А111АА77', 1), ('Hyundai Solaris', 'В222ВВ77', 1), ('Toyota Camry', 'С333СС77', 3),
('BMW 5 Series', 'М444ММ77', 4), ('Lada Niva', 'Е555ЕЕ77', 5), ('Porsche 911', 'О666ОО77', 6),
('Tesla Model 3', 'Т777ТТ77', 7), ('Mercedes E-Class', 'У888УУ77', 3);

INSERT INTO Contracts (client_id, car_id, employee_id, insurance_id, start_date, end_date) VALUES
(1, 1, 1, 1, '2024-10-01', '2024-10-05'), (2, 3, 1, 2, '2024-10-05', '2024-10-10'),
(3, 2, 2, 1, '2024-10-07', '2024-10-09'), (4, 4, 3, 3, '2024-10-12', '2024-10-15'),
(5, 5, 1, 4, '2024-10-15', '2024-10-20'), (1, 7, 2, 3, '2024-11-01', '2024-11-03'),
(6, 6, 3, 6, '2024-11-05', '2024-11-06'), (7, 8, 1, 2, '2024-11-10', '2024-11-15'),
(8, 1, 2, 1, '2024-11-12', '2024-11-14');

INSERT INTO Payments (contract_id, payment_date, amount) VALUES
(1, '2024-10-01', 10500.00), (2, '2024-10-05', 26500.00), (3, '2024-10-07', 4500.00),
(4, '2024-10-12', 25000.00), (5, '2024-10-15', 22700.00), (6, '2024-11-01', 18000.00),
(6, '2024-11-03', 10000.00), (7, '2024-11-05', 12500.00), (8, '2024-11-10', 20000.00);

UPDATE Clients SET phone = '+7 (999) 000-11-22' WHERE client_id = 1;

INSERT INTO Payments (contract_id, payment_date, amount) VALUES (1, '2024-10-01', 100.00);
DELETE FROM Payments WHERE amount = 100.00;

CREATE USER 'manager_user'@'localhost' IDENTIFIED BY 'manager_pass_123';
GRANT SELECT, INSERT, UPDATE, DELETE ON car_rental_db.* TO 'manager_user'@'localhost';

CREATE USER 'director_user'@'localhost' IDENTIFIED BY 'director_pass_123';
GRANT SELECT ON car_rental_db.* TO 'director_user'@'localhost';

FLUSH PRIVILEGES;

DESCRIBE CarClasses;
DESCRIBE InsuranceTypes;
DESCRIBE Employees;
DESCRIBE Clients;
DESCRIBE Cars;
DESCRIBE Contracts;
DESCRIBE Payments;

SELECT c.contract_id, cl.full_name AS client_name, c.start_date
FROM Contracts c, Clients cl
WHERE c.client_id = cl.client_id AND c.start_date > '2024-10-05'
ORDER BY c.start_date DESC;

SELECT 
    c.contract_id, 
    cl.full_name AS client, 
    ca.brand AS car, 
    e.full_name AS employee,
    it.insurance_name,
    c.start_date
FROM Contracts c
JOIN Clients cl ON c.client_id = cl.client_id
JOIN Cars ca ON c.car_id = ca.car_id
JOIN Employees e ON c.employee_id = e.employee_id
JOIN InsuranceTypes it ON c.insurance_id = it.insurance_id;

SELECT 
    COUNT(*) AS total_payments,
    SUM(amount) AS total_revenue,
    AVG(amount) AS average_payment,
    MAX(amount) AS max_payment,
    MIN(amount) AS min_payment
FROM Payments;

SELECT 
    cc.class_name, 
    COUNT(c.contract_id) AS contracts_count,
    SUM(p.amount) AS total_revenue
FROM CarClasses cc
JOIN Cars ca ON cc.class_id = ca.class_id
JOIN Contracts c ON ca.car_id = c.car_id
JOIN Payments p ON c.contract_id = p.contract_id
GROUP BY cc.class_name
HAVING SUM(p.amount) > 15000;

SELECT full_name FROM Clients 
WHERE client_id IN (SELECT client_id FROM Contracts);

SELECT contract_id, amount FROM Payments 
WHERE amount > ALL (SELECT amount FROM Payments WHERE contract_id = 1);

SELECT 
    brand, 
    ca.class_id,
    CASE 
        WHEN cc.base_rate < 3000 THEN 'Бюджетный'
        WHEN cc.base_rate BETWEEN 3000 AND 6000 THEN 'Средний класс'
        ELSE 'Премиум'
    END AS car_category
FROM Cars ca
JOIN CarClasses cc ON ca.class_id = cc.class_id;

SELECT 
    contract_id,
    SUM(amount) AS total_paid,
    IF(SUM(amount) > 20000, 'Полная оплата', 'Частичная оплата') AS payment_status
FROM Payments
GROUP BY contract_id;

CREATE VIEW View_ContractDetails AS
SELECT 
    c.contract_id, 
    cl.full_name AS client_name, 
    ca.brand AS car_brand, 
    it.insurance_name,
    p.amount AS paid_amount
FROM Contracts c
JOIN Clients cl ON c.client_id = cl.client_id
JOIN Cars ca ON c.car_id = ca.car_id
JOIN InsuranceTypes it ON c.insurance_id = it.insurance_id
JOIN Payments p ON c.contract_id = p.contract_id;

SELECT * FROM View_ContractDetails;

WITH ClientTotalPayments AS (
    SELECT c.client_id, SUM(p.amount) AS total_spent
    FROM Contracts c
    JOIN Payments p ON c.contract_id = p.contract_id
    GROUP BY c.client_id
)
SELECT cl.full_name, ctp.total_spent
FROM Clients cl
JOIN ClientTotalPayments ctp ON cl.client_id = ctp.client_id
ORDER BY ctp.total_spent DESC;

EXPLAIN SELECT * FROM Contracts WHERE start_date = '2024-10-01';

CREATE INDEX idx_start_date ON Contracts(start_date);

EXPLAIN SELECT * FROM Contracts WHERE start_date = '2024-10-01';

START TRANSACTION;
    INSERT INTO Contracts (client_id, car_id, employee_id, insurance_id, start_date, end_date) 
    VALUES (1, 2, 1, 1, '2024-12-01', '2024-12-05');
    
    SET @new_contract_id = LAST_INSERT_ID();
    
    INSERT INTO Payments (contract_id, payment_date, amount) 
    VALUES (@new_contract_id, '2024-12-01', 9000.00);
COMMIT;

PREPARE search_client FROM 'SELECT * FROM Clients WHERE phone LIKE ?';

SET @phone_prefix = '+7 (900)%';

EXECUTE search_client USING @phone_prefix;

DEALLOCATE PREPARE search_client;
