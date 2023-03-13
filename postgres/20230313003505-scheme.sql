-- +migrate Up
CREATE TYPE transmission as ENUM ('manual', 'cvt', 'one_clutch_robot', 'dual_clutch_robot', 'auto');
CREATE TYPE order_status as ENUM ('created', 'verified', 'started', 'completed');

create table auth
(
    id        serial,
    email     varchar(50) not null,
    pass_hash varchar(50) not null
);

create table customers
(
    id         int primary key,
    name       varchar(50) not null,
    surname    varchar(50) not null,
    experience int         not null,
    age        int         not null,
    dr_license varchar(50) not null,
    passport   varchar(50) not null,
    phone      varchar(50) not null
);

create table rent_conditions
(
    id              serial,
    min_age         int not null,
    min_experience  int not null,
    deposit         int not null,
    max_day_mileage int
);

create table prices
(
    id          serial,
    car_id      int not null,
    period_from int not null,
    period_to   int,
    price       int not null
);

create table orders
(
    id          serial,
    customer_id int          not null,
    car_id      int          not null,
    created_at  timestamp    not null,
    rent_from   timestamp    not null,
    rent_to     timestamp    not null,
    status      order_status not null,
    notes       varchar(1000)
);

create table cars
(
    id                 serial,
    rent_conditions_id int          not null,
    manufacturer       varchar(50)  not null,
    model              varchar(50)  not null,
    manufacture_year   int          not null,
    engine_power       int          not null,
    transmission       transmission not null,
    doors              int          not null,
    passenger_capacity int          not null,
    description        varchar(1000)
);

INSERT INTO auth(email, pass_hash)
values ('john.doe@gmail.com', '6dbd0fe19c9a301c4708287780df41a2');
INSERT INTO auth(email, pass_hash)
values ('dave.doe@gmail.com', '4cc2321ca77b832bd20b66f86f85bef6');
INSERT INTO auth(email, pass_hash)
values ('steve.doe@gmail.com', 'a6fc8c37c5a4ee63f21c8cddedc44e4b');

INSERT INTO customers(id, name, surname, experience, age, dr_license, passport, phone)
VALUES (1, 'John', 'Doe', 0, 19, '333777333', 'AA1234567', '+19913221337');
INSERT INTO customers(id, name, surname, experience, age, dr_license, passport, phone)
VALUES (2, 'Dave', 'Doe', 3, 22, '333888333', 'BB1234567', '+19913221447');
INSERT INTO customers(id, name, surname, experience, age, dr_license, passport, phone)
VALUES (3, 'Steve', 'Doe', 12, 35, '333999333', 'CC1234567', '+19913221557');

INSERT INTO orders(id, customer_id, car_id, created_at, rent_from, rent_to, status, notes)
VALUES (1, 1, 1, '2020-2-1'::timestamp, '2020-2-3'::timestamp, '2020-2-5'::timestamp, 'completed', '');
INSERT INTO orders(id, customer_id, car_id, created_at, rent_from, rent_to, status, notes)
VALUES (2, 1, 2, '2020-3-1'::timestamp, '2020-3-3'::timestamp, '2020-3-5'::timestamp, 'completed', '');
INSERT INTO orders(id, customer_id, car_id, created_at, rent_from, rent_to, status, notes)
VALUES (3, 1, 4, '2020-4-1'::timestamp, '2020-4-3'::timestamp, '2020-4-5'::timestamp, 'completed', '');
INSERT INTO orders(id, customer_id, car_id, created_at, rent_from, rent_to, status, notes)
VALUES (4, 1, 3, '2020-5-1'::timestamp, '2020-5-3'::timestamp, '2020-5-5'::timestamp, 'completed', '');
INSERT INTO orders(id, customer_id, car_id, created_at, rent_from, rent_to, status, notes)
VALUES (5, 1, 1, '2020-6-1'::timestamp, '2020-6-3'::timestamp, '2020-6-5'::timestamp, 'completed', '');

INSERT INTO orders(id, customer_id, car_id, created_at, rent_from, rent_to, status, notes)
VALUES (6, 2, 1, '2020-7-1'::timestamp, '2020-7-3'::timestamp, '2020-7-5'::timestamp, 'completed', '');
INSERT INTO orders(id, customer_id, car_id, created_at, rent_from, rent_to, status, notes)
VALUES (7, 2, 2, '2020-8-1'::timestamp, '2020-8-3'::timestamp, '2020-8-5'::timestamp, 'completed', '');
INSERT INTO orders(id, customer_id, car_id, created_at, rent_from, rent_to, status, notes)
VALUES (8, 2, 4, '2020-9-1'::timestamp, '2020-9-3'::timestamp, '2020-9-5'::timestamp, 'completed', '');
INSERT INTO orders(id, customer_id, car_id, created_at, rent_from, rent_to, status, notes)
VALUES (9, 2, 3, '2020-10-1'::timestamp, '2020-10-3'::timestamp, '2020-10-5'::timestamp, 'completed', '');
INSERT INTO orders(id, customer_id, car_id, created_at, rent_from, rent_to, status, notes)
VALUES (10, 2, 1, '2020-11-1'::timestamp, '2020-11-3'::timestamp, '2020-11-5'::timestamp, 'completed', '');

INSERT INTO orders(id, customer_id, car_id, created_at, rent_from, rent_to, status, notes)
VALUES (11, 3, 1, '2021-2-1'::timestamp, '2021-2-3'::timestamp, '2021-2-5'::timestamp, 'completed', '');
INSERT INTO orders(id, customer_id, car_id, created_at, rent_from, rent_to, status, notes)
VALUES (12, 3, 2, '2021-3-1'::timestamp, '2021-3-3'::timestamp, '2021-3-5'::timestamp, 'completed', '');
INSERT INTO orders(id, customer_id, car_id, created_at, rent_from, rent_to, status, notes)
VALUES (13, 3, 4, '2021-4-1'::timestamp, '2021-4-3'::timestamp, '2021-4-5'::timestamp, 'completed', '');
INSERT INTO orders(id, customer_id, car_id, created_at, rent_from, rent_to, status, notes)
VALUES (14, 3, 3, '2021-5-1'::timestamp, '2021-5-3'::timestamp, '2021-5-5'::timestamp, 'completed', '');
INSERT INTO orders(id, customer_id, car_id, created_at, rent_from, rent_to, status, notes)
VALUES (15, 3, 1, '2021-6-1'::timestamp, '2021-6-3'::timestamp, '2021-6-5'::timestamp, 'completed', '');

COPY prices (
             car_id,
             period_from,
             period_to,
             price
    ) FROM '/prices.csv' DELIMITER ',' CSV HEADER;
COPY
    cars (
          rent_conditions_id,
          manufacturer,
          model,
          manufacture_year,
          engine_power,
          transmission,
          doors,
          passenger_capacity,
          description
        ) FROM '/cars.csv' DELIMITER ',' CSV HEADER;
COPY rent_conditions (
                      min_age,
                      min_experience,
                      deposit,
                      max_day_mileage
    ) FROM '/rent_conditions.csv' DELIMITER ',' CSV HEADER;

-- +migrate Down
drop table cars CASCADE;
drop table prices CASCADE;
drop table rent_conditions CASCADE;
drop table orders CASCADE;
drop table customers CASCADE;
drop table auth CASCADE;
drop type order_status CASCADE;
drop type transmission CASCADE;
