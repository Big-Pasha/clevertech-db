--1
SELECT ar.model, se.fare_conditions, COUNT(seat_no) as seats_count
FROM aircrafts ar
         JOIN seats se
              ON ar.aircraft_code = se.aircraft_code
GROUP BY ar.model, se.fare_conditions
ORDER BY ar.model

-- 2
SELECT model ,COUNT(seat_no) seats_count
FROM aircrafts_data ar
         JOIN seats se
              ON ar.aircraft_code = se.aircraft_code
GROUP BY model
ORDER BY seats_count DESC
    LIMIT 3

--3
SELECT flight_no
FROM flights
WHERE AGE(actual_departure, scheduled_departure) > interval '2 hours'

--4
SELECT tic.ticket_no, tic.passenger_name, tic.contact_data
FROM tickets tic
         JOIN ticket_flights tf
              ON tic.ticket_no = tf.ticket_no
         JOIN bookings bo
              ON bo.book_ref = tic.book_ref
WHERE tf.fare_conditions = 'Business'
ORDER BY bo.book_date DESC
    LIMIT 10

--5
SELECT f.flight_no
FROM flights f
         JOIN ticket_flights tic
              ON f.flight_id = tic.flight_id
GROUP BY f.flight_no
HAVING bool_or(tic.fare_conditions = 'Business') = false
ORDER BY f.flight_no

--6
SELECT airport_name, city
FROM airports
WHERE airport_code IN (
    SELECT departure_airport
    FROM flights
    WHERE scheduled_departure < actual_departure
)

--7
SELECT ar.airport_name, COUNT(fl.flight_no) as count_flights
FROM airports ar
         JOIN flights fl
              ON fl.departure_airport = ar.airport_code
GROUP BY ar.airport_name
ORDER BY count_flights

--8
SELECT flight_no
FROM flights
WHERE scheduled_arrival != actual_arrival

--9
SELECT a.aircraft_code, a.model, s.seat_no
FROM aircrafts a
         JOIN seats s
              ON a.aircraft_code = s.aircraft_code
WHERE a.model = 'Аэробус A321-200' AND s.fare_conditions != 'Economy'
ORDER BY s.seat_no

--10
SELECT airport_code, airport_name, city
FROM airports
WHERE city IN (
    SELECT city
    FROM airports
    GROUP BY city
    HAVING COUNT(airport_code) > 1
)

--11
SELECT passenger_id, passenger_name
FROM tickets
WHERE book_ref IN (
    SELECT book_ref
    FROM bookings
    WHERE total_amount > (SELECT AVG(total_amount) FROM bookings)
)
ORDER BY passenger_name

--12
SELECT flight_no
FROM flights
WHERE departure_airport IN (SELECT airport_code FROM airports WHERE city = 'Екатеринбург') AND
    arrival_airport IN (SELECT airport_code FROM airports WHERE city = 'Москва') AND
    status IN ('On Time', 'Delayed')


--13
    (SELECT ticket_no, amount
     FROM ticket_flights
     WHERE amount >= (SELECT max(amount) FROM ticket_flights)
         LIMIT 1
) UNION (
     SELECT ticket_no, amount
     FROM ticket_flights
     WHERE amount <= (SELECT min(amount) FROM ticket_flights)
         LIMIT 1)

--14
CREATE TABLE Customers
(
    id SERIAL PRIMARY KEY,
    firstName varchar(255) NOT NULL CHECK (length(firstName) >= 2),
    lastName varchar(255) NOT NULL CHECK (length(lastName) >= 2),
    email varchar(255) NOT NULL UNIQUE CHECK (length(email) > 0),
    phone varchar(15) NOT NULL
);

--15
CREATE TABLE Orders
(
    id SERIAL PRIMARY KEY,
    customerId integer NOT NULL,
    quantity integer NOT NULL CHECK (quantity > 0),
    FOREIGN KEY (customerId)
        REFERENCES bookings.customers (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
);

--16
insert into Customers (firstName, lastName, email, phone) values
('Tolik','Alkogolik', 'alk@golik.com','9379992'),
('Golovach', 'Elena', 'lena@runetki.ru', '1231231'),
('Nikolay', 'Nalivay', 'navilav@gmail.com', '1231233'),
('Oleg', 'Greh', 'greh@tyt.by', '1231231'),
('Simon', 'Myzon', 'dam@vmyz.io', '1231234')

insert into Orders (customerId, quantity) values
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5)

--17
DROP TABLE Orders
DROP TABLE Customers