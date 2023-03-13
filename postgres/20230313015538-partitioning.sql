-- +migrate Up
create table if not exists prices_1 ( like prices including all );
alter table prices_1 inherit prices;
alter table prices_1 add constraint partition_check check (id % 3 = 0);

create table if not exists prices_2 ( like prices including all );
alter table prices_2 inherit prices;
alter table prices_2 add constraint partition_check check (id % 3 = 1);

create table if not exists prices_3 ( like prices including all );
alter table prices_3 inherit prices;
alter table prices_3 add constraint partition_check check (id % 3 = 2);

-- функция определения партиции
-- +migrate StatementBegin
create function partition_for_prices() returns trigger as $$
declare
    v_parition_name text;
begin
    v_parition_name := format( 'prices_%s', 1 + new.id % 3 );
    execute 'insert into ' || v_parition_name || ' values ( ($1).* )' using new;
    return null;
end;
$$ language plpgsql;
-- +migrate StatementEnd


-- привязка функции к родительской таблице
create trigger partition_prices before insert on prices for each row execute procedure partition_for_prices();

-- перенос данных из родительской таблицы в партиции
with x as (delete from only prices where id % 3 = 0 returning *) insert into prices_1 select * from x;
with x as (delete from only prices where id % 3 = 1 returning *) insert into prices_2 select * from x;
with x as (delete from only prices where id % 3 = 2 returning *) insert into prices_3 select * from x;

-- +migrate down
