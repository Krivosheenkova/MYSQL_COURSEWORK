DELIMITER //
DROP PROCEDURE IF EXISTS shedule_show;
CREATE PROCEDURE shedule_show(request_id INT(4), property_id INT(4))
BEGIN
	  INSERT INTO show_property_meet (property_id, client_id, realtor_id)
    SELECT IF(request.property_id IS NOT NULL, request.property_id, property_id), request.client_id, request.realtor_id
    FROM request WHERE request.id = request_id;
END
//
-- example
>> call real_estate_database.shedule_show(0004, 0016);
SELECT * FROM real_estate_database.show_property_meet;
+------+-------------+-----------+------------+---------+---------------------+--------+
| id   | property_id | client_id | realtor_id | comment | date                | status |
+------+-------------+-----------+------------+---------+---------------------+--------+
| 0001 |        0015 |      0005 |       0012 | NULL    | 2021-01-24 04:08:49 |      1 |
+------+-------------+-----------+------------+---------+---------------------+--------+
1 row in set (0.00 sec)
						

DROP PROCEDURE IF EXISTS `add_contract`//
CREATE PROCEDURE `add_contract`(`request_id` INT(4) ZEROFILL, `property_id` INT(4) ZEROFILL, 
`client_id` INT(4) ZEROFILL, `fee_percent` INT(2), `contract_type` INT(4), `prepayment_sum` DECIMAL(10, 2))
BEGIN
	INSERT INTO `contract` (`counteragents`, `property_id`, `realtor_id`, `transaction_id`, `contract_type_id`, 
												`prepayment`, `payment_sum`, `fee_percentage`)
	SELECT IF(`request`.`property_id` IS NULL, CONCAT_WS(', ', `property`.`owner_client_id`, `client_id`), 
						   CONCAT_WS(', ', `request`.`client_id`, `client_id`)),
	       IF(`request`.`property_id` IS NULL, `property_id`, `request`.`property_id`),
           `request`.`realtor_id`, `request`.`transaction_type_id`, `contract_type`, `prepayment_sum`,
           `property`.`price` * ((100 - fee_percent) / 100),
           `fee_percent`
	FROM request LEFT JOIN property ON request.property_id = property.id WHERE request.id = request_id;
END//
DELIMITER ;
												    
-- example
>> call real_estate_database.add_contract(0006, 0008, 0002, 5, 1003, 100000.00);
SELECT * FROM contract;
+------+---------------+-------------+------------+----------------+------------------+------------+-------------+----------------+---------------------+
| id   | counteragents | property_id | realtor_id | transaction_id | contract_type_id | prepayment | payment_sum | fee_percentage | date                |
+------+---------------+-------------+------------+----------------+------------------+------------+-------------+----------------+---------------------+
| 4001 | 0018, 0002    |        0011 |       0005 |           5003 |             1003 |  100000.00 | 16604472.40 |              5 | 2021-01-24 04:05:46 |
+------+---------------+-------------+------------+----------------+------------------+------------+-------------+----------------+---------------------+
1 row in set (0.00 sec)
												    
												    
												 
