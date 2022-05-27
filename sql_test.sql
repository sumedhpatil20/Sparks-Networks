-- How many total messages are being sent every day ?

select date(msg.createdat) as date ,count(*) as total_number_of_messages_on_particular_day from PRODUCTION_DB.PROD_SCHEMA.MESSAGES msg group by date(msg.createdat);

-- Are there any users that did not receive any message ?

with users_join as(
select usr.id as user_id ,msg.message_id as message_id from USERS usr left join MESSAGES msg on usr.id = msg.receiverid)

select user_id as users_that_did_not_receive_any_message from users_join where message_id is null;

-- How many active subscriptions do we have today ?

select count(*) as total_active_subscriptions_today from PRODUCTION_DB.PROD_SCHEMA.subscriptions where status = 'Active' and date(enddate) >= current_date();

--  Are there users sending messages without an active subscription? 
-- (some extra context for you: in our apps only premium users can send messages).

with inactive_subscriptions as(
select distinct user_id from subscriptions where status = 'Inactive'
-- select distinct user_id from subscriptions where status <> 'Active' and date(enddate) <= current_date()
)

select distinct msg.senderid as user_id from inactive_subscriptions subs left join MESSAGES msg on subs.user_id = msg.senderid;

select * from inactive_subscriptions subs left join MESSAGES msg on subs.user_id = msg.senderid;

--  Did you identified any inaccurate/noisy record that somehow could prejudice 
-- the data analyses? How to monitor it (SQL query)? Please explain how do you 
-- suggest to handle with this noisy data?


-- Explanation :

-- Below querys will return all the rows in which any column values is null
select * from raw_db.raw_schema.users where concat(createdAt,updatedAt,city,country,zipCode,
    email_domain,birthDate,id,gender,smoking_condition,profession,income) is null;
    
select * from raw_db.raw_schema.subscriptions where concat(user_id,createdAt,startDate,endDate,status,amount) is null;

select * from raw_db.raw_schema.messages where concat(createdAt,receiverId,message_id,senderId) is null; 


