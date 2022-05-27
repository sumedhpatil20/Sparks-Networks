------------------------------------------- DDL -------------------------------------------------
create database RAW_DB;
create schema RAW_DB.RAW_SCHEMA;

create database PRODUCTION_DB;
create schema PRODUCTION_DB.PROD_SCHEMA;

create table raw_db.raw_schema.USERS
    (createdAt varchar,
     updatedAt varchar,
     city varchar,
     country varchar,
     zipCode varchar,  
     email_domain varchar,
     birthDate varchar,
     id varchar,
     gender varchar,
     smoking_condition varchar,
     profession varchar,
     income varchar);

create table raw_db.raw_schema.subscriptions
    (user_id integer,
     createdAt varchar,
     startDate varchar,
     endDate varchar,
     status  varchar,
     amount varchar,
     updatedat varchar);

create table raw_db.raw_schema.messages  
      (createdAt varchar ,
       receiverId integer,
       message_id integer,
       senderId integer);

create TABLE PRODUCTION_DB.PROD_SCHEMA.USERS ( 
    CREATEDAT TIMESTAMP, 
    UPDATEDAT TIMESTAMP, 
    CITY VARCHAR, 
    COUNTRY VARCHAR, 
    ZIPCODE VARCHAR, 
    EMAIL_DOMAIN VARCHAR, 
    BIRTHDATE TIMESTAMP, 
    ID INTEGER, 
    GENDER VARCHAR, 
    SMOKING_CONDITION VARCHAR, 
    PROFESSION VARCHAR, 
    INCOME FLOAT, 
    AGE FLOAT );

create table PRODUCTION_DB.PROD_SCHEMA.subscriptions
    (user_id integer,
     createdAt timestamp,
     startDate timestamp,
     endDate timestamp,
     status  varchar,
     amount float
     updatedat timestamp);

create table PRODUCTION_DB.PROD_SCHEMA.messages  
      (createdAt timestamp ,
       receiverId integer,
       message_id integer,
       senderId integer);

------------------------------------------- DML -------------------------------------------------


insert into production_db.prod_schema.USERS
    (select 
    createdAt::timestamp as createdat,
    updatedAt::timestamp as UPDATEDAT,
    city,
    country,
    zipCode,
    email_domain,
    birthDate::timestamp as BIRTHDATE,
    id :: integer,
    gender,
    smoking_condition,
    profession,
    income,
    datediff('year', date(BIRTHDATE::timestamp), sysdate())  as age
    from raw_db.raw_schema.users where updatedat > (select max(updatedat) from production_db.prod_schema.USERS)
    );
    
insert into production_db.prod_schema.subscriptions
    (select 
     user_id ::integer,
     createdAt:: timestamp,
     startDate:: timestamp,
     endDate :: timestamp,
     status :: varchar,
     amount :: float,
     updatedat :: timestamp
     from raw_db.raw_schema.subscriptions where updatedat > (select max(updatedat) from production_db.prod_schema.subscriptions )
    );

insert into production_db.prod_schema.messages
    (select 
    CREATEDAT :: timestamp,
    RECEIVERID :: integer,
    MESSAGE_ID :: integer,
    SENDERID :: integer 
    from raw_db.raw_schema.messages where CREATEDAT > (select max(CREATEDAT) from production_db.prod_schema.messages)
    );
    
-----------------------------------------------------------------------------------------------------------------
