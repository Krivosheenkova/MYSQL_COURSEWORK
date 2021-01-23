-- Выборка недвижимости, доступных для аренды. 
-- Подобным же образом можно посмотреть собственность на продажу и обмен, изменяя индекс transaction_type: [5001, 5002, 5003]

SELECT `id`, (SELECT `property_type`.`type` FROM `property_type` WHERE `id` = `property`.`property_type_id`) 'Тип недвижимости',
		     `administrative_district_id` 'Административный округ',
             (SELECT `district`.`name` FROM `district` WHERE `id` = `property`.`district_id`) 'Район',
             (SELECT `type` FROM `transaction_type` WHERE `id` = `property`.`transaction_id`) 'Тип сделки',
             (SELECT CONCAT_WS(' ', `surname`, `name`, `patronymic`) `t` FROM `client` WHERE `id` = `property`.`owner_client_id`) 'Полное имя собственника',
             `address` 'Адрес', `floor` 'Этаж', `rooms` 'Комнат', `square` 'Площадь', `bedrooms` 'Спален', `bathrooms` 'Санузлов',
             `details` 'Описание', `price` "Цена",
             IF(`is_new_building` = 1, 'Новостройка', '') AS ""             
FROM `property` WHERE `transaction_id` = 5003;
