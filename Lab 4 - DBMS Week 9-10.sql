DROP  database IF EXISTS e_commerce;
create database e_commerce;
use  e_commerce;

create table  Supplier(SUPP_ID int primary key ,SUPP_NAME varchar(50),SUPP_CITY varchar(50) ,SUPP_PHONE BIGINT);

insert into Supplier values(1,'Rajesh Retails','Delhi',1234567890);
insert into Supplier values(2,'Appario Ltd.','Mumbai',2589631470);
insert into Supplier values(3,'Knome products','Banglore',9785462315);
insert into Supplier values(4,'Bansal Retails',	'Kochi',8975463285);
insert into Supplier values(5,'Mittal Ltd.','Lucknow',7898456532);

create table Customer(CUS_ID int primary key ,CUS_NAME varchar(50),CUS_PHONE BIGINT,CUS_CITY varchar(50) ,CUS_GENDER varchar(30));

insert into Customer values(1,'AAKASH',9999999999,'DELHI','M');
insert into Customer values(2,'AMAN',9785463215,'NOIDA','M');
insert into Customer values(3,'NEHA',9999999999,'MUMBAI','F');
insert into Customer values(4,'MEGHA',9994562399,'KOLKATA','F');
insert into Customer values(5,'PULKIT',7895999999,'LUCKNOW','M');



create table Category(CAT_ID int primary key  ,CAT_NAME varchar(50));

insert into Category values(1,'BOOKS');
insert into Category values(2,'GAMES');
insert into Category values(3,'GROCERIES');
insert into Category values(4,'ELECTRONICS');
insert into Category values(5,'CLOTHES');


create table Product(
PRO_ID int primary key,
PRO_NAME varchar(50),PRO_DESC varchar(50),CAT_ID int,
FOREIGN KEY (CAT_ID) REFERENCES Category(CAT_ID)
);

insert into Product values(1,'GTA V','DFJDJFDJFDJFDJFJF',2);
insert into Product values(2,'TSHIRT','DFDFJDFJDKFD',5);
insert into Product values(3,'ROG LAPTOP','DFNTTNTNTERND',4);
insert into Product values(4,'OATS','REURENTBTOTH',3);
insert into Product values(5,'HARRY POTTER','NBEMCTHTJTH',1);

create table ProductDetails(
PROD_ID int primary key ,
PRO_ID int ,SUPP_ID int,PRICE int,
FOREIGN KEY (SUPP_ID) REFERENCES Supplier(SUPP_ID),
FOREIGN KEY (PRO_ID) REFERENCES Product(PRO_ID)
);
insert into ProductDetails values(1,1,2,1500);
insert into ProductDetails values(2,3,5,30000);
insert into ProductDetails values(3,5,1,3000);
insert into ProductDetails values(4,2,3,2500);
insert into ProductDetails values(5,4,1,1000);


create table Order_table(
ORD_ID int primary key,ORD_AMOUNT int,ORD_DATE date,CUS_ID int,PROD_ID int,
FOREIGN KEY (PROD_ID) REFERENCES ProductDetails(PROD_ID),
FOREIGN KEY (CUS_ID) REFERENCES Customer(CUS_ID)
);

insert into Order_table values(20,1500,'2021-10-12',3,5);
insert into Order_table values(25,30500,'2021-09-16',5,2);
insert into Order_table values(26,2000,'2021-10-05',1,1);
insert into Order_table values(30,3500,'2021-08-16',4,3);
insert into Order_table values(50,2000,'2021-10-06',2,1);

create table Rating(
RAT_ID int primary key ,
CUS_ID int,SUPP_ID int,RAT_RATSTARS int,
FOREIGN KEY (SUPP_ID) REFERENCES Supplier(SUPP_ID),
FOREIGN KEY (CUS_ID) REFERENCES Customer(CUS_ID)
);

insert into Rating values(1,2,2,4);
insert into Rating values(2,3,4,3);
insert into Rating values(3,5,1,5);
insert into Rating values(4,1,3,2);
insert into Rating values(5,4,5,4);

/*---3)	Display the number of the customer group by their genders 
who have placed any order of amount greater than or equal to Rs.3000.*/

SELECT Customer.CUS_GENDER,count(CUS_GENDER) as count 
FROM Customer   
INNER JOIN  Order_table  
ON Customer.CUS_ID = Order_table.CUS_ID
where order_table.ORD_AMOUNT >= 3000
group by Customer.CUS_GENDER ;  


/*4)Display all the orders along with the product name ordered by a customer having Customer_Id=2.*/

SELECT Order_table.* ,Product.PRO_NAME from Order_table ,
productdetails,product where Order_table.cus_id =2 and 
Order_table.prod_id = productdetails.prod_id and
productdetails.prod_id = product.pro_id;


/*5)Display the Supplier details who can supply more than one product.*/
/*ANSWER*/
select supplier.* from supplier,ProductDetails 
where supplier.supp_id in 
(select ProductDetails.supp_id 
from ProductDetails group by ProductDetails.supp_id 
having count(ProductDetails.supp_id)>1)
group by supplier.supp_id;

/*6)Find the category of the product whose order amount is minimum.*/
/*ANSWER*/
Select category.* from order_table 
inner join ProductDetails on order_table.prod_id = ProductDetails.prod_id
inner join product on product.pro_id=ProductDetails.pro_id 
inner join category on category.cat_id=product.cat_id
having min(order_table.ord_amount);

/*7)Display the Id and Name of the Product ordered after “2021-10-05”.*/
/*ANSWER*/
Select product.pro_id,product.pro_name from order_table 
inner join ProductDetails on ProductDetails.prod_id=order_table.prod_id
inner join product on product.pro_id=ProductDetails.pro_id 
where order_table.ord_date>"2021-10-05";

/*8)Display customer name and gender whose names start or end with character 'A'.*/
/*ANSWER*/
Select customer.cus_name,customer.cus_gender from customer
where customer.cus_name like '%A%';

/*9)Create a stored procedure to display the Rating for a Supplier if any along with the Verdict.
 on that rating if any like if rating >4 then “Genuine Supplier” if rating >2 “Average Supplier” 
 else “Supplier should not be considered”.*/
 /*ANSWER*/
 
 
 use  e_commerce;
 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc`()
BEGIN
 Select supplier.supp_id,supplier.supp_name,rating.rat_ratstars,
 case
     when rating.rat_ratstars >4 Then 'Genuine Supplier'
     when rating.rat_ratstars >2 Then 'Average Supplier'
     else 'Supplier should not be considered'
end As verdict from rating inner join supplier on supplier.supp_id=rating.supp_id;
END

call proc;

