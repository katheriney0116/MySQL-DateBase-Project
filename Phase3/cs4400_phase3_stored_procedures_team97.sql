-- CS4400: Introduction to Database Systems (Fall 2021)
-- Phase III: Stored Procedures & Views [v0] Tuesday, November 9, 2021 @ 12:00am EDT
-- Team 97
-- Xiao Yang (xyang427)
-- Tiankai Yan (tyan41)
-- Zhouyi Xue (zxue60)
-- Qihang Hu（qhu81)
-- Directions:
-- Please follow all instructions for Phase III as listed on Canvas.
-- Fill in the team number and names and GT usernames for all members above.


-- ID: 1a
-- Name: register_customer
drop procedure if exists register_customer;
delimiter //
create procedure register_customer (
    in i_email varchar(50),
    in i_first_name varchar(100),
    in i_last_name varchar(100),
    in i_password varchar(50),
    in i_phone_number char(12),
    in i_cc_number varchar(19),
    in i_cvv char(3),
    in i_exp_date date,
    in i_location varchar(50)
) 
sp_main: begin
if i_phone_number in (select phone_number from clients) then leave sp_main; end if;
if i_cc_number in (select ccnumber from customer) then leave sp_main; end if;
if  concat(i_email,i_phone_number) in (select concat(email,phone_number) from clients) 
then leave sp_main; end if;
if (i_email in (select email from accounts) and i_email in (select email from clients))
then insert into customer values (); leave sp_main;end if;
insert into Accounts VALUES(i_email, i_first_name, i_last_name, i_password);
insert into Clients VALUES(i_email, i_phone_number);
insert into Customer VALUES(i_email, i_cc_number, i_cvv, i_exp_date, i_location);

end //
delimiter ;

-- ID: 1b
-- Name: register_owner
drop procedure if exists register_owner;
delimiter //
create procedure register_owner (
    in i_email varchar(50),
    in i_first_name varchar(100),
    in i_last_name varchar(100),
    in i_password varchar(50),
    in i_phone_number char(12)
) 
sp_main: begin
if i_phone_number in (select phone_number from clients) then leave sp_main; end if;
if  concat(i_email,i_phone_number) in (select concat(email,phone_number) from clients) 
then leave sp_main; end if;
if (i_email in (select email from accounts) and i_email in (select email from clients))
then insert into Owners VALUES(i_email); leave sp_main;end if;
insert into Accounts VALUES(i_email, i_first_name, i_last_name, i_password);
insert into Clients VALUES(i_email, i_phone_number); 
insert into Owners VALUES(i_email);

end //
delimiter ;


-- ID: 1c
-- Name: remove_owner
drop procedure if exists remove_owner;
delimiter //
create procedure remove_owner ( 
    in i_owner_email varchar(50)
)
sp_main: begin
if (i_owner_email in (select owner_email from property)) then leave sp_main; end if;
delete from review where owner_email = i_owner_email;
delete from owners_rate_customers where owner_email = i_owner_email;
delete from customers_rate_owners where owner_email = i_owner_email;
if (i_owner_email in (select email from customer)) then delete from owners where email = i_owner_email; leave sp_main; end if;
delete from owners where email = i_owner_email;
delete from clients where email = i_owner_email;
delete from accounts where email = i_owner_email;
end //
delimiter ;


-- ID: 2a
-- Name: schedule_flight
drop procedure if exists schedule_flight;
delimiter //
create procedure schedule_flight (
    in i_flight_num char(5),
    in i_airline_name varchar(50),
    in i_from_airport char(3),
    in i_to_airport char(3),
    in i_departure_time time,
    in i_arrival_time time,
    in i_flight_date date,
    in i_cost decimal(6, 2),
    in i_capacity int,
    in i_current_date date
)
sp_main: begin
	if (concat(i_flight_num,i_airline_name) in (select concat(flight_num,airline_name) from flight)) then leave sp_main;end if;
	-- how to make it uniquely identified
	if i_to_airport = i_from_airport then leave sp_main; end if;
    if i_flight_date <= i_current_date then leave sp_main; end if;
    insert into Flight values (i_flight_num,i_airline_name,i_from_airport,i_to_airport,i_departure_time,i_arrival_time,i_flight_date,i_cost,i_capacity);

end //
delimiter ;


-- ID: 2b
-- Name: remove_flight
drop procedure if exists remove_flight;
delimiter //
create procedure remove_flight ( 
    in i_flight_num char(5),
    in i_airline_name varchar(50),
    in i_current_date date
) 
sp_main: begin
	if (select flight_date from flight where concat(flight_num, airline_name) in (select concat(i_flight_num,i_airline_name) from flight))<=i_current_date
    then leave sp_main; end if;
    delete from book where flight_num = i_flight_num and airline_name = i_airline_name;
    delete from flight where flight_num = i_flight_num and airline_name = i_airline_name;

end //
delimiter ;



-- ID: 3a
-- Name: book_flight
drop procedure if exists book_flight;
delimiter //
create procedure book_flight (
    in i_customer_email varchar(50),
    in i_flight_num char(5),
    in i_airline_name varchar(50),
    in i_num_seats int,
    in i_current_date date
)
sp_main: begin
	-- a customer can't have more than one non_cancelled flight booked per day?
    select sum(Num_Seats) 
	into @filled_seats
	from Book
	where Flight_Num = i_flight_num and Airline_Name = i_airline_name and Was_Cancelled = 0;
    
    select capacity 
    into @capacity
    from flight where Flight_Num = i_flight_num and Airline_Name = i_airline_name;
    
    select  num_seats
    into @seat
    from book where Flight_Num = i_flight_num and Airline_Name = i_airline_name and customer = i_customer_email and was_cancelled = 0;
    
    
    select flight_date
    into @flight_date
    from flight where Flight_Num = i_flight_num and Airline_Name = i_airline_name;
    
    if (@flight_date in (select flight_date from book natural join flight where customer = i_customer_email and was_cancelled = 0
    )) then leave sp_main; end if;
    
	if(@capacity-@filled_seats<i_num_seats) then leave sp_main;end if;
     
	if @flight_date <= i_current_date then leave sp_main;end if;
    
    if (concat(i_flight_num,i_airline_name) not in (select concat(flight_num,airline_name) from flight)) then leave sp_main;end if;

   if (concat(i_customer_email,i_flight_num,i_airline_name) in (select concat(customer,flight_num,airline_name) from 
    book where was_cancelled = 0)) 
    and ((i_num_seats+@seat) <= (select capacity - sum(num_seats* if (was_cancelled = 0,1,0))from flight natural join book 
	where Flight_Num = i_flight_num and Airline_Name = i_airline_name group by flight_num,airline_name))
    then update book set num_seats = @seat + i_num_seats where customer = i_customer_email;leave sp_main; end if;
    
    
    if (concat(i_customer_email,i_flight_num,i_airline_name) not in (select concat(customer,flight_num,airline_name) from 
    book)) then insert into book value (i_customer_email,i_flight_num,i_airline_name,i_num_seats,0);
    leave sp_main;end if;
    
    if (concat(i_customer_email,i_flight_num,i_airline_name) in (select concat(customer,flight_num,airline_name) from 
    flight natural join book where was_cancelled = 1)) 
    then leave sp_main;end if;
    
    


end //
delimiter ;

-- ID: 3b
-- Name: cancel_flight_booking
drop procedure if exists cancel_flight_booking;
delimiter //
create procedure cancel_flight_booking ( 
    in i_customer_email varchar(50),
    in i_flight_num char(5),
    in i_airline_name varchar(50),
    in i_current_date date
)
sp_main: begin

	if i_customer_email not in (select customer from book) then leave sp_main; end if;
	if i_customer_email in (select customer from book where was_cancelled = 1 and flight_num = i_flight_num
    and airline_name = i_airline_name) then leave sp_main; end if;
	if (select flight_date from flight
    where flight_num = i_flight_num and airline_name =i_airline_name) <= i_current_date then leave sp_main;
    end if;
    update book set was_cancelled = 1 where customer = i_customer_email and flight_num = i_flight_num
    and airline_name = i_airline_name;
end //
delimiter ;


-- ID: 3c
-- Name: view_flight
create or replace view view_flight (
    flight_id,
    flight_date,
    airline,
    destination,
    seat_cost,
    num_empty_seats,
    total_spent
) as
select flight_num,flight_date,airline_name,to_airport,cost,capacity - sum(num_seats* if (was_cancelled = 0,1,0)),
cost*sum(num_seats* if (was_cancelled = 0,1,0)) + cost*0.2*sum(num_seats* if (was_cancelled = 1,1,0))
from flight natural join book 
group by flight_num,airline_name
union
select flight_num,flight_date,airline_name,to_airport,cost,capacity,0 from flight 
where concat(flight_num,airline_name) not in (select concat(flight_num,airline_name) from book) group by flight_num,airline_name;




-- ID: 4a
-- Name: add_property
drop procedure if exists add_property;
delimiter //
create procedure add_property (
    in i_property_name varchar(50),
    in i_owner_email varchar(50),
    in i_description varchar(500),
    in i_capacity int,
    in i_cost decimal(6, 2),
    in i_street varchar(50),
    in i_city varchar(50),
    in i_state char(2),
    in i_zip char(5),
    in i_nearest_airport_id char(3),
    in i_dist_to_airport int
) 
sp_main: begin
if (concat(i_street,i_city,i_state,i_zip) in (select concat(street,city,state,zip) from property )) then leave sp_main;end if;
if (concat(i_property_name,i_owner_email) in (select concat(property_name,owner_email) from property)) then leave sp_main;end if;

insert into Property VALUES(i_property_name, i_owner_email, i_description, i_capacity, i_cost,i_street, i_city, i_state, i_zip);
    
    if i_nearest_airport_id in (select airport_id from Airport) and concat(i_property_name, i_owner_email) not in (select concat(Property_Name, Owner_Email) 
    from is_close_to) and i_nearest_airport_id IS NOT NULL and i_dist_to_airport IS NOT NULL then 
 insert into Is_Close_To VALUES(i_property_name,  i_owner_email, i_nearest_airport_id, i_dist_to_airport); end if;
end //
delimiter ;

-- ID: 4b
-- Name: remove_property
drop procedure if exists remove_property;
delimiter //
create procedure remove_property (
    in i_property_name varchar(50),
    in i_owner_email varchar(50),
    in i_current_date date
)
sp_main: begin
-- TODO: Implement your solution here
	if (concat(i_property_name, i_owner_email) in (select concat(Property_name, Owner_email) from reserve 
    where i_current_date >=start_date and was_cancelled = 0)) then leave sp_main;end if;
    
	If (i_property_name, i_owner_email)
	not in (select Property_name, Owner_email from Reserve where Was_cancelled = 0 and (i_current_date < End_date and i_current_date > Start_date))
	and (i_property_name, i_owner_email) in (select Property_name, Owner_email from Property)

	then

	delete from Reserve where i_property_name = Property_Name and i_owner_email = Owner_Email;
	delete from Review where i_property_name = Property_Name and i_owner_email = Owner_Email;
	delete from Amenity where i_property_name = Property_Name and i_owner_email = Property_Owner;
	delete from Property where i_property_name = Property_Name and i_owner_email = Owner_Email;
	
    end if;
end //
delimiter ;




-- ID: 5a
-- Name: reserve_property
drop procedure if exists reserve_property;
delimiter //
create procedure reserve_property (
    in i_property_name varchar(50),
    in i_owner_email varchar(50),
    in i_customer_email varchar(50),
    in i_start_date date,
    in i_end_date date,
    in i_num_guests int,
    in i_current_date date
)
sp_main: begin
	If i_end_date > i_start_date and i_customer_email in (select Email from Customer)
	and (i_property_name, i_owner_email) in (select Property_name, Owner_email from Property)
	and (i_property_name, i_owner_email, i_customer_email) not in (select Property_name, Owner_email, Customer from Reserve)
	and i_start_date > i_current_date and i_customer_email not in (select Customer from Reserve where Start_date < i_end_date and End_date > i_start_date)
	and ((select Capacity from Property where Property_name = i_property_name and Owner_email = i_owner_email) - (select coalesce(SUM(Num_Guests),0)
	from Reserve where Start_Date < i_end_date and End_date > i_start_date and Was_cancelled = 0
	and Property_name = i_property_name and Owner_email = i_owner_email) >= i_num_guests)

	then
	insert into Reserve VALUES (i_property_name, i_owner_email, i_customer_email, i_start_date, i_end_date, i_num_guests, 0);
	end if;
end //
delimiter ;


-- ID: 5b
-- Name: cancel_property_reservation
drop procedure if exists cancel_property_reservation;
delimiter //
create procedure cancel_property_reservation (
    in i_property_name varchar(50),
    in i_owner_email varchar(50),
    in i_customer_email varchar(50),
    in i_current_date date
)
sp_main: begin
	if i_customer_email in (select email from customer)
	and (i_property_name, i_owner_email) in (select property_name, owner_email from property)
	and (i_property_name, i_owner_email, i_customer_email) in (select property_name, owner_email, customer from reserve)
	and (select was_cancelled from reserve where i_property_name = property_name and i_owner_email = owner_email and i_customer_email = customer) = 0
	and i_current_date < (select Start_date from Reserve where
	i_property_name = Property_Name and i_owner_email = Owner_Email and i_customer_email = Customer)
	then

	update Reserve SET Was_Cancelled = 1 where i_property_name = property_name and i_owner_email = owner_email and i_customer_email = customer;
	end if;

end //
delimiter ;





-- ID: 5c
-- Name: customer_review_property
drop procedure if exists customer_review_property;
delimiter //
create procedure customer_review_property (
    in i_property_name varchar(50),
    in i_owner_email varchar(50),
    in i_customer_email varchar(50),
    in i_content varchar(500),
    in i_score int,
    in i_current_date date
)
sp_main: begin
	if i_current_date >= (select Start_date from Reserve where i_property_name = Property_Name and i_owner_email =
	Owner_Email and i_customer_email = Customer) 
    and (select Was_Cancelled from Reserve where i_property_name = Property_Name 
    and i_owner_email = Owner_Email and i_customer_email = Customer) = 0 
    and (concat(i_property_name, i_owner_email, i_customer_email)) not in (select concat(property_name, owner_email, customer) from review)
	then
	insert into Review VALUES(i_property_name, i_owner_email, i_customer_email, i_content, i_score);
	end if;
    
end //
delimiter ;


-- ID: 5d
-- Name: view_properties
create or replace view view_properties (
    property_name, 
    average_rating_score, 
    description, 
    address, 
    capacity, 
    cost_per_night
) as
    select  Property.Property_Name, avg(Score), Descr, concat(Street, ', ', City, ', ', State, ', ', Zip), Capacity, Cost
    from (Property left join Review on Review.Property_Name = Property.Property_Name and Review.Owner_Email = Property.Owner_Email)
    group by Property.Owner_Email, Property.Property_Name;




-- ID: 5e
-- Name: view_individual_property_reservations
drop procedure if exists view_individual_property_reservations;
delimiter //
create procedure view_individual_property_reservations (
    in i_property_name varchar(50),
    in i_owner_email varchar(50)
)
sp_main: begin
    drop table if exists view_individual_property_reservations;
    create table view_individual_property_reservations (
        property_name varchar(50),
        start_date date,
        end_date date,
        customer_email varchar(50),
        customer_phone_num char(12),
        total_booking_cost decimal(6,2),
        rating_score int,
        review varchar(500)
    );
    -- TODO: replace this select query with your solution
    if (select count(*) from property where (i_property_name, i_owner_email) = (Property.Property_Name, Property.Owner_Email)) = 0 then leave sp_main; end if;
    
    insert into view_individual_property_reservations
    select Reserve.Property_Name, Start_Date, End_Date, Reserve.Customer, Phone_Number, ((End_Date - Start_Date+1) * Cost) as ToCost, Score, Content from reserve, customer, property, Review, Clients
    where (Review.Property_Name, Review.Owner_Email) = (Property.Property_Name, Property.Owner_Email)
    and Review.Customer = Customer.Email 
    and (reserve.Property_Name, reserve.Owner_Email) = (Property.Property_Name, Property.Owner_Email)
    and Reserve.Customer = Customer.Email
    and Customer.Email = Clients.Email
    and (i_property_name, i_owner_email) = (Property.Property_Name, Property.Owner_Email);

end //
delimiter ;


-- ID: 6a
-- Name: customer_rates_owner
drop procedure if exists customer_rates_owner;
delimiter //
create procedure customer_rates_owner (
    in i_customer_email varchar(50),
    in i_owner_email varchar(50),
    in i_score int,
    in i_current_date date
)
sp_main: begin

if (i_customer_email not in (select customer from reserve where owner_email = i_owner_email)) then leave sp_main;end if;

if (i_customer_email and i_owner_email not in (select email from accounts)) then leave sp_main;end if;

if (i_current_date < (select start_date from reserve 
where i_customer_email = customer and i_owner_email = owner_email and was_cancelled = 0))then leave sp_main;end if;

if (concat(i_customer_email,i_owner_email) in (select (concat(customer,owner_email)) from customers_rate_owners)) then leave sp_main;end if;
INSERT INTO Customers_Rate_Owners (customer, owner_email, score)
VALUES (i_customer_email, i_owner_email, i_score);

end //
delimiter ;

-- ID: 6b
-- Name: owner_rates_customer
drop procedure if exists owner_rates_customer;
delimiter //
create procedure owner_rates_customer (
    in i_owner_email varchar(50),
    in i_customer_email varchar(50),
    in i_score int,
    in i_current_date date
)
sp_main: begin
if (i_customer_email not in (select customer from reserve where owner_email = i_owner_email)) then leave sp_main;end if;
if (i_current_date < (select start_date from reserve 
where i_customer_email = customer and i_owner_email = owner_email and was_cancelled = 0))then leave sp_main;end if;
if (i_customer_email and i_owner_email not in (select email from accounts)) then leave sp_main;end if;
if (concat(i_customer_email,i_owner_email) in (select (concat(customer,owner_email)) from owners_rate_customers)) then leave sp_main;end if;

INSERT INTO Owners_Rate_customers (owner_email,customer, score)
VALUES (i_owner_email,i_customer_email, i_score);
end //
delimiter ;

-- helper method for 7a
create or replace view helpermethod_1 (
    airport_id,
    airport_name,
    time_zone,
    total_arriving
) as
	select airport_id,airport_name,time_zone,count(concat(flight_num,airline_name)) 
	from airport left outer join flight dependent on airport_id = to_airport group by airport_id ;
    
create or replace view helpermethod_2 (
    airport_id,
    airport_name,
    time_zone,
    total_departing,
    average_cost
) as
	select airport_id,airport_name,time_zone,count(concat(flight_num,airline_name)),sum(cost)/count(concat(flight_num,airline_name))
	from airport left outer join flight dependent on airport_id = from_airport group by airport_id ;

-- ID: 7a
-- Name: view_airports
create or replace view view_airports (
    airport_id, 
    airport_name, 
    time_zone, 
    total_arriving_flights, 
    total_departing_flights, 
    avg_departing_flight_cost
) as
-- TODO: replace this select query with your solution    
select * from helpermethod_1 natural join helpermethod_2;

-- ID: 7b
-- Name: view_airlines
create or replace view view_airlines (
    airline_name, 
    rating, 
    total_flights, 
    min_flight_cost
) as
-- TODO: replace this select query with your solution
select airline_name,rating,count(flight_num),min(cost) from airline natural join flight group by airline_name
union
select airline_name,rating,0, null from airline where airline_name not in
(select airline_name from flight);

create or replace view helper_customer1(
	email,
    name_customer,
    owners_customer
) as
select email,concat(first_name,last_name),0
from accounts where email in (select email from customer) and email not in (select email from owners)
union  
select email,concat(first_name,last_name),1
from accounts where email in (select email from customer) and email in (select email from owners);


create or replace view helper_customer2(
	email,
    average_rating
) as 
	select email,sum(score)/count(score) from customer left join owners_rate_customers on email = customer
    group by email;

create or replace view helper_customer(
	email,
    location,
    total_seats_purchased
) as
select email,location,sum(num_seats) from customer join book on email = customer
where email in (select customer from book) group by email
union
select email,location,0 from customer left outer join book on email = customer
where email not in (select customer from book) group by email;



create or replace view helper_customer3(
	email,
    name_customer,
    owners_customer,
    location,
    total_seats_purchased
) as
select email,name_customer,owners_customer,location,total_seats_purchased from helper_customer natural join helper_customer1;

-- ID: 8a
-- Name: view_customers
create or replace view view_customers (
    customer_name, 
    avg_rating, 
    location, 
    is_owner, 
    total_seats_purchased
) as
-- TODO: replace this select query with your solution
-- view customers
select name_customer,average_rating,location,owners_customer,total_seats_purchased from helper_customer2 natural join helper_customer3;



create or replace view helper_owners1(
	property_name,
    owner_email,
    score_property
) as 
	select property_name,owner_email,score
	from property natural join review 
	union
	select property_name,owner_email,null from property where property_name not in (select property_name from review);
    



create or replace view helper_owners (
	email,
    first_last_name,
    property_name,
    property_score
) as
	select email,concat(first_name,last_name),property_name,score_property 
    from accounts join helper_owners1 dependent on email = owner_email
    union 
    select email,concat(first_name,last_name),null,0
    from accounts join helper_owners1 dependent on email = owner_email 
    where email in (select email from owners) and email not in (select owner_email from helper_owners1);
    
 
-- ID: 8b
-- Name: view_owners
create or replace view view_owners (
    owner_name, 
    avg_rating, 
    num_properties_owned, 
    avg_property_rating
) as
select first_last_name,sum(score)/count(score),count(distinct(property_name)),sum(property_score)/count(property_score)
 from helper_owners left outer join customers_rate_owners on owner_email = email
group by first_last_name
union 
select concat(first_name,last_name),null,0,null from owners natural join accounts
where email not in (select owner_email from property);





-- helper method for 9q
create or replace view dataup_helper (
    cust_email,
    state,
    fl_date
) as
select book.customer, airport.State, flight.Flight_Date
from book, flight, airport
where book.Flight_Num = flight.Flight_Num and book.airline_name = flight.airline_name and To_Airport = Airport_Id and book.was_cancelled = 0 ;

-- ID: 9a
-- Name: process_date
drop procedure if exists process_date;
delimiter //
create procedure process_date ( 
    in i_current_date date
)
sp_main: begin


update customer 
join dataup_helper on dataup_helper.cust_email = customer.email 
set customer.location = dataup_helper.state
where fl_date = i_current_date;
    
end //
delimiter ;







