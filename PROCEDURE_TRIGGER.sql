-- Данная процедура позволяет внести в таблицу показов недвижимости новую запись

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
| 0001 |        0015 |      0005 |       0012 | NULL    | 2021-01-24 04:20:49 |      1 |
+------+-------------+-----------+------------+---------+---------------------+--------+
1 row in set (0.00 sec)
						
-- Процедура записи нового заключенного контракта
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
| 4001 | 0018, 0002    |        0011 |       0005 |           5003 |             1003 |  100000.00 | 16604472.40 |              5 | 2021-01-24 04:20:46 |
+------+---------------+-------------+------------+----------------+------------------+------------+-------------+----------------+---------------------+
1 row in set (0.00 sec)
			
												    
-- триггер на проверку данных при вставке в таблицу client
												    
DROP TRIGGER IF EXISTS client_data_validate//
CREATE TRIGGER client_data_validate BEFORE INSERT ON `client` FOR EACH ROW
BEGIN
	CASE
		WHEN passport IS NOT NULL AND LENGTH(passport) <> 11
        		THEN SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'Invalide passport';
       		WHEN email NOT LIKE '%@%.%' THEN
        		SIGNAL SQLSTATE '45000'
        		SET MESSAGE_TEXT = 'Invalide email';
        	WHEN phone NOT BETWEEN 79000000000 AND 79999999999 THEN
        		SIGNAL SQLSTATE '45000'
        		SET MESSAGE_TEXT = 'Invalide phone number';
        	WHEN LENGTH(requisites) <> 18 THEN
        		SIGNAL SQLSTATE '45000'
        		SET MESSAGE_TEXT = 'Invalide requisites';
        	WHEN LENGTH(`ITN/TIN`) <> 10 THEN
        		SIGNAL SQLSTATE '45000'
        		SET MESSAGE_TEXT = 'Invalide ITN/TIN';
        	WHEN LENGTH(`IEC`) <> 9 THEN
       			SIGNAL SQLSTATE '45000'
        		SET MESSAGE_TEXT = 'Invalide IEC';
    END CASE;
END//												    
												 
