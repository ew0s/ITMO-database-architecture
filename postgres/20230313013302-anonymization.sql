-- +migrate Up
-- Инициализация расширения
CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE EXTENSION IF NOT EXISTS anon;
SELECT anon.start_dynamic_masking();

-- Создание пользователя
CREATE ROLE m_user LOGIN;
SECURITY LABEL FOR anon ON ROLE m_user IS 'MASKED';

ALTER ROLE m_user
    WITH PASSWORD 'qwerty123';

-- Настройка анонимизации данных для пользователя
SECURITY LABEL FOR anon ON COLUMN customers.surname
    IS 'MASKED WITH FUNCTION anon.fake_last_name()';

SECURITY LABEL FOR anon ON COLUMN customers.dr_license
    IS 'MASKED WITH FUNCTION anon.partial(dr_license,0,$$******$$,2)';

SECURITY LABEL FOR anon ON COLUMN customers.passport
    IS 'MASKED WITH FUNCTION anon.partial(passport,0,$$******$$,2)';

SECURITY LABEL FOR anon ON COLUMN customers.phone
    IS 'MASKED WITH FUNCTION anon.partial(phone,0,$$******$$,2)';

-- Создание materialized view c анонимизированными данными
CREATE MATERIALIZED VIEW IF NOT EXISTS active_customers_anon AS
SELECT customers.id, name, anon.fake_last_name() as surname, age, SUM(rent_to - rent_from) as total_rent_days
FROM customers
         INNER JOIN orders
                    ON customers.id = orders.customer_id
WHERE status = 'completed'
GROUP BY customers.id
ORDER BY total_rent_days DESC;

CREATE MATERIALIZED VIEW IF NOT EXISTS customer_ages AS
SELECT id, name, anon.fake_last_name() as surname, anon.generalize_int4range(age,5) AS age
FROM customers;

CREATE MATERIALIZED VIEW IF NOT EXISTS randomized_prices AS
SELECT id, car_id, period_from, period_to, anon.noise(price,0.1) AS price
FROM prices;


-- +migrate Down
DROP MATERIALIZED VIEW IF EXISTS active_customers_anon;
DROP MATERIALIZED VIEW IF EXISTS customer_ages;
DROP MATERIALIZED VIEW IF EXISTS randomized_prices;

REASSIGN OWNED BY m_user TO itmo;
DROP OWNED BY m_user;
DROP ROLE IF EXISTS m_user;
DROP EXTENSION IF EXISTS anon CASCADE;
DROP EXTENSION IF EXISTS pgcrypto CASCADE;
