CREATE DEFINER=`root`@`localhost` PROCEDURE `proc`()
BEGIN
 Select supplier.supp_id,supplier.supp_name,rating.rat_ratstars,
 case
     when rating.rat_ratstars >4 Then 'Genuine Supplier'
     when rating.rat_ratstars >2 Then 'Average Supplier'
     else 'Supplier should not be considered'
end As verdict from rating inner join supplier on supplier.supp_id=rating.supp_id;

END