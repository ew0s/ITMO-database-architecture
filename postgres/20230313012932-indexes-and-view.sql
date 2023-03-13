-- +migrate Up
CREATE INDEX car_id_period_from_ix on prices(car_id) INCLUDE (period_from);
CREATE INDEX car_search_ix on cars(rent_conditions_id) INCLUDE (manufacture_year, engine_power, transmission, doors, passenger_capacity);

CREATE VIEW active_customers AS
SELECT customers.id, name, surname, SUM(rent_to - rent_from) as total_rent_days
FROM customers
         INNER JOIN orders
                    ON customers.id = orders.customer_id
WHERE status = 'completed'
GROUP BY customers.id
ORDER BY total_rent_days DESC;

-- +migrate Down
drop index car_id_period_from_ix;
drop index car_search_ix;
drop view active_customers;
