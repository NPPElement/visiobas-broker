SET foreign_key_checks = 0;





-- Дамп структуры базы данных auth
DROP DATABASE IF EXISTS `auth`;
CREATE DATABASE IF NOT EXISTS `auth` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `auth`;


-- Дамп структуры для таблица auth.role
DROP TABLE IF EXISTS `role`;
CREATE TABLE IF NOT EXISTS `role` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL,
  `description` varchar(256) DEFAULT NULL,
  `parent` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- Дамп структуры для таблица auth.role_user
DROP TABLE IF EXISTS `role_user`;
CREATE TABLE IF NOT EXISTS `role_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `role_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  KEY `role_id_idx` (`role_id`),
  KEY `user_id_idx` (`user_id`),
  CONSTRAINT `fk_role_idx` FOREIGN KEY (`role_id`) REFERENCES `role` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_user_idx` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.


-- Дамп структуры для таблица auth.token
DROP TABLE IF EXISTS `token`;
CREATE TABLE IF NOT EXISTS `token` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `token` varchar(2048) NOT NULL,
  `user_id` int(11) NOT NULL,
  `updated` datetime DEFAULT NULL,
  `push_key` varchar(250) DEFAULT NULL,
  `base_url` varchar(250) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  KEY `token_user_idx` (`user_id`),
  CONSTRAINT `fk_token_idx` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.


-- Дамп структуры для таблица auth.user
DROP TABLE IF EXISTS `user`;
CREATE TABLE IF NOT EXISTS `user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `login` varchar(128) NOT NULL,
  `password` varchar(512) NOT NULL,
  `vdesk_id` int(11) DEFAULT NULL,
  `updated` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;





















-- Дамп структуры базы данных log
DROP DATABASE IF EXISTS `log`;
CREATE DATABASE IF NOT EXISTS `log` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `log`;


-- Дамп структуры для таблица log.objects_value
DROP TABLE IF EXISTS `objects_value`;
CREATE TABLE IF NOT EXISTS `objects_value` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `device_id` int(11) NOT NULL DEFAULT '0',
  `Object_Identifier` int(11) NOT NULL DEFAULT '0',
  `Object_Type` enum('analog-input','analog-output','analog-value','binary-input','binary-output','binary-value','calendar','command','device','event-enrollment','file','group','loop','multi-state-input','multi-state-output','notification-class','program','schedule','averaging','multi-state-value','trend-log','life-safety-point','life-safety-zone','accumulator','pulse-converter','event-log','global-group','trend-log-multiple','load-control','structured-view','access-door','access-credential','access-point','access-rights','access-user','access-zone','credential-data-input','network-security','bitstring-value','characterstring-value','date-pattern-value','date-value','datetime-pattern-value','datetime-value','integer-value','large-analog-value','octetstring-value','positive-integer-value','time-pattern-value','time-value','notification-forwarder','alert-enrollment','channel','lighting-output','folder','site','trunk','graphic') DEFAULT NULL,
  `value` double DEFAULT NULL,
  `status` tinytext NOT NULL,
  `timestamp` datetime(3) DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.


-- Дамп структуры для таблица log.trendlog
DROP TABLE IF EXISTS `trendlog`;
CREATE TABLE IF NOT EXISTS `trendlog` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `device_id` int(11) DEFAULT '0',
  `Object_Identifier` int(11) DEFAULT '0',
  `Object_Type` enum('analog-input','analog-output','analog-value','binary-input','binary-output','binary-value','calendar','command','device','event-enrollment','file','group','loop','multi-state-input','multi-state-output','notification-class','program','schedule','averaging','multi-state-value','trend-log','life-safety-point','life-safety-zone','accumulator','pulse-converter','event-log','global-group','trend-log-multiple','load-control','structured-view','access-door','access-credential','access-point','access-rights','access-user','access-zone','credential-data-input','network-security','bitstring-value','characterstring-value','date-pattern-value','date-value','datetime-pattern-value','datetime-value','integer-value','large-analog-value','octetstring-value','positive-integer-value','time-pattern-value','time-value','notification-forwarder','alert-enrollment','channel','lighting-output','folder','site','trunk','graphic') DEFAULT NULL,
  `value` double DEFAULT NULL,
  `value_prev` double DEFAULT NULL,
  `status` tinyint(4) NOT NULL,
  `timestamp` datetime(3) DEFAULT CURRENT_TIMESTAMP(3),
  `timestamp_prev` datetime(3) DEFAULT NULL,
  KEY `id` (`id`),
  KEY `device_id` (`device_id`),
  KEY `Object_Identifier` (`Object_Identifier`),
  KEY `Object_Type` (`Object_Type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.


-- Дамп структуры для триггер log.trigger_after_insert_log_info
DROP TRIGGER IF EXISTS `trigger_after_insert_log_info`;
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `trigger_after_insert_log_info` AFTER INSERT ON `objects_value` FOR EACH ROW BEGIN
	-- Новый сигнал, вставка пустого
 	INSERT INTO `trendlog` (`device_id`,`Object_Identifier`,`Object_Type`, `status`, `value`, `value_prev`,`timestamp_prev`) VALUES (NEW.device_id, NEW.Object_Identifier, NEW.Object_Type, NEW.status, NEW.value, NULL, NULL);
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;


-- Дамп структуры для триггер log.trigger_after_update_log_info
DROP TRIGGER IF EXISTS `trigger_after_update_log_info`;
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `trigger_after_update_log_info` AFTER UPDATE ON `objects_value` FOR EACH ROW BEGIN
 	INSERT INTO `trendlog` (`device_id`,`Object_Identifier`,`Object_Type`, `status`, `value`, `value_prev`,`timestamp_prev`) VALUES (NEW.device_id, NEW.Object_Identifier, NEW.Object_Type, NEW.status, NEW.value, OLD.value, OLD.timestamp);
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;














-- Дамп структуры базы данных vbas
DROP DATABASE IF EXISTS `vbas`;
CREATE DATABASE IF NOT EXISTS `vbas` /*!40100 DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci */;
USE `vbas`;


-- Дамп структуры для таблица vbas.accredential_accright
DROP TABLE IF EXISTS `accredential_accright`;
CREATE TABLE IF NOT EXISTS `accredential_accright` (
  `id` int(11) NOT NULL COMMENT 'Сквозной уникальный идентификатор объекта',
  `right_id` int(11) NOT NULL,
  `credential_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  KEY `fk_accredentialright_1_idx` (`right_id`),
  KEY `fk_accredentialright_2_idx` (`credential_id`),
  CONSTRAINT `accredential_accright_ibfk_1` FOREIGN KEY (`right_id`) REFERENCES `objects.access-rights` (`id`),
  CONSTRAINT `accredential_accright_ibfk_2` FOREIGN KEY (`credential_id`) REFERENCES `objects.access-credential` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.


-- Дамп структуры для таблица vbas.accright_accpoint
DROP TABLE IF EXISTS `accright_accpoint`;
CREATE TABLE IF NOT EXISTS `accright_accpoint` (
  `id` int(11) NOT NULL COMMENT 'Сквозной уникальный идентификатор объекта',
  `right_id` int(11) NOT NULL,
  `point_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  KEY `fk_acrightpoint_1_idx` (`right_id`),
  KEY `fk_acrightpoint_2_idx` (`point_id`),
  CONSTRAINT `accright_accpoint_ibfk_1` FOREIGN KEY (`right_id`) REFERENCES `objects.access-rights` (`id`),
  CONSTRAINT `accright_accpoint_ibfk_2` FOREIGN KEY (`point_id`) REFERENCES `objects.access-point` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.


-- Дамп структуры для таблица vbas.accright_acczone
DROP TABLE IF EXISTS `accright_acczone`;
CREATE TABLE IF NOT EXISTS `accright_acczone` (
  `id` int(11) NOT NULL COMMENT 'Сквозной уникальный идентификатор объекта',
  `right_id` int(11) NOT NULL,
  `zone_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  KEY `fk_acrightzone_1_idx` (`right_id`),
  KEY `fk_acrightzone_2_idx` (`zone_id`),
  CONSTRAINT `accright_acczone_ibfk_1` FOREIGN KEY (`right_id`) REFERENCES `objects.access-rights` (`id`),
  CONSTRAINT `accright_acczone_ibfk_2` FOREIGN KEY (`zone_id`) REFERENCES `objects.access-zone` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.


-- Дамп структуры для таблица vbas.acczone_accpoint
DROP TABLE IF EXISTS `acczone_accpoint`;
CREATE TABLE IF NOT EXISTS `acczone_accpoint` (
  `id` int(11) NOT NULL COMMENT 'Сквозной уникальный идентификатор объекта',
  `zone_id` int(11) NOT NULL,
  `point_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  KEY `fk_aczonepoint_1_idx` (`zone_id`),
  KEY `fk_aczonepoint_2_idx` (`point_id`),
  CONSTRAINT `acczone_accpoint_ibfk_1` FOREIGN KEY (`zone_id`) REFERENCES `objects.access-zone` (`id`),
  CONSTRAINT `acczone_accpoint_ibfk_2` FOREIGN KEY (`point_id`) REFERENCES `objects.access-point` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.


-- Дамп структуры для таблица vbas.acuser_accredential
DROP TABLE IF EXISTS `acuser_accredential`;
CREATE TABLE IF NOT EXISTS `acuser_accredential` (
  `id` int(11) NOT NULL COMMENT 'Сквозной уникальный идентификатор объекта',
  `user_id` int(11) NOT NULL,
  `credential_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  KEY `fk_accusercredential_1_idx` (`user_id`),
  KEY `fk_accusercredential_2_idx` (`credential_id`),
  CONSTRAINT `acuser_accredential_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `objects.access-user` (`id`),
  CONSTRAINT `acuser_accredential_ibfk_2` FOREIGN KEY (`credential_id`) REFERENCES `objects.access-credential` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.


-- Дамп структуры для таблица vbas.bot_chat
DROP TABLE IF EXISTS `bot_chat`;
CREATE TABLE IF NOT EXISTS `bot_chat` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `chat_id` bigint(20) NOT NULL,
  `chat_name` varchar(128) DEFAULT NULL,
  `type` varchar(64) DEFAULT NULL,
  `last_answered_message_id` int(11) DEFAULT NULL,
  `objects_parent_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `chat_id_UNIQUE` (`chat_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.


-- Дамп структуры для процедура vbas.func_debug
DROP PROCEDURE IF EXISTS `func_debug`;
DELIMITER //
CREATE PROCEDURE `func_debug`(IN `text` TEXT)
    COMMENT 'Вывод отладочной информации в отдельную таблицу'
BEGIN
 	INSERT INTO `_debug` (`text`) VALUES (text);
END//
DELIMITER ;


-- Дамп структуры для процедура vbas.func_init
DROP PROCEDURE IF EXISTS `func_init`;
DELIMITER //
CREATE PROCEDURE `func_init`()
    COMMENT 'Инициализация после запуска базы'
BEGIN
	CALL func_init_event_all_objects();
END//
DELIMITER ;


-- Дамп структуры для процедура vbas.func_init_event_all_objects
DROP PROCEDURE IF EXISTS `func_init_event_all_objects`;
DELIMITER //
CREATE PROCEDURE `func_init_event_all_objects`()
    COMMENT 'Инициализация после запуска базы'
BEGIN

	DECLARE objId INT;
	DECLARE objType VARCHAR(50);

	DECLARE flag INT DEFAULT 0;
	DECLARE curObjects CURSOR FOR SELECT id, Object_Type FROM objects;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET flag = 1;


	TRUNCATE `object_looks`;


	OPEN curObjects;

	REPEAT
		FETCH curObjects INTO objId, objType;

		IF objType='binary-input'
--  			OR objType='binary-output'
 			OR objType='binary-value'
 			OR objType='analog-output'
 			OR objType='analog-value'
 			OR objType='analog-input'
--  			OR objType='multi-state-input'
-- 			OR objType='multi-state-output'
-- 			OR objType='multi-state-value'
 			OR objType='device'
			THEN CALL func_prepare_object_topic_info(objId);
		END IF;

		IF objType='notification-class' THEN
			CALL func_init_notification_class(objId);
		END IF;

	UNTIL flag END REPEAT;

	CLOSE curObjects;
END//
DELIMITER ;


-- Дамп структуры для процедура vbas.func_init_notification_class
DROP PROCEDURE IF EXISTS `func_init_notification_class`;
DELIMITER //
CREATE PROCEDURE `func_init_notification_class`(IN `object_id` INT)
    COMMENT 'Загрузка данных по notification class'
BEGIN
	DECLARE p1 VARCHAR(10);
	DECLARE p2 VARCHAR(10);
	DECLARE p3 VARCHAR(10);

 	SELECT Priority FROM `objects.notification-class` WHERE id=object_id INTO @priority;

	SET p1 = SUBSTRING_INDEX(@priority, '|', 2);
	SET p2 = SUBSTRING_INDEX(p1, '|', -1);
	SET p1 = SUBSTRING_INDEX(p1, '|', 1);
	SET p3 = SUBSTRING_INDEX(@priority, '|', -1);

 	IF (SELECT id from `object_notification` WHERE id=object_id LIMIT 0,1) THEN
 		UPDATE `object_notification` SET
 			priority_to_offnormal 	= p1,
 			priority_to_fault 		= p2,
 			priority_to_normal 		= p3
		WHERE id=object_id;
	ELSE
		INSERT INTO `object_notification` (id, priority_to_offnormal, priority_to_fault, priority_to_normal) VALUES ( object_id, p1, p2, p3 );
 	END IF;

	CALL func_init_notification_groups(object_id);

 	-- CALL func_debug(CONCAT('Priority[', object_id ,'] ', @priority));
END//
DELIMITER ;


-- Дамп структуры для процедура vbas.func_init_notification_groups
DROP PROCEDURE IF EXISTS `func_init_notification_groups`;
DELIMITER //
CREATE PROCEDURE `func_init_notification_groups`(IN `notification_id` INT)
    COMMENT 'Заполняет список групп уже в идентификаторах, а не текстом'
BEGIN
	DECLARE groupName VARCHAR(250);
	DECLARE groupId 	INT;
	DECLARE f4 			INT;
	DECLARE f2 			INT;
	DECLARE f1 			INT;

	DECLARE flag INT DEFAULT 0;
	DECLARE cur CURSOR FOR SELECT recipient, transitions&4>0, transitions&2>0, transitions&1>0 FROM `objects.bacnet-destination` WHERE notification_class_id=notification_id;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET flag = 1;

	DELETE FROM `object_notification_groups` WHERE object_notification_groups.notification_id=notification_id;


	OPEN cur;

	REPEAT
		FETCH cur INTO groupName, f4, f2, f1;
		-- CALL func_debug(CONCAT('GROUP[',  notification_id ,'] "', groupName, '" , ', f4, f2, f1));
		SELECT id from `vdesk`.`group` WHERE name LIKE groupName COLLATE utf8_general_ci INTO groupId;
		IF groupId IS NOT NULL AND groupName IS NOT NULL AND f4 IS NOT NULL THEN
			INSERT INTO `object_notification_groups` (
				notification_id,
				group_id,
				to_offnormal,
				to_fault,
				to_normal
				) VALUES (
					notification_id,
					(SELECT id from `vdesk`.`group` WHERE name LIKE groupName COLLATE utf8_general_ci),
					f4,
					f2,
					f1
				);
		END IF;

	UNTIL flag END REPEAT;

	CLOSE cur;
END//
DELIMITER ;


-- Дамп структуры для процедура vbas.func_link_topic_to_notify_groups_fault
DROP PROCEDURE IF EXISTS `func_link_topic_to_notify_groups_fault`;
DELIMITER //
CREATE PROCEDURE `func_link_topic_to_notify_groups_fault`(IN `topicId` INT, IN `notificationId` INT)
    COMMENT 'Линкует найденные группы к указанному топику'
BEGIN
	DECLARE groupId INT;
	DECLARE flag INT DEFAULT 0;
	DECLARE cur CURSOR FOR SELECT DISTINCT(group_id) FROM object_notification_groups WHERE notification_id=notificationId AND to_fault=1;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET flag = 1;

	OPEN cur;
	REPEAT
		FETCH cur INTO groupId;
		IF groupId>0 THEN
			INSERT INTO `vdesk`.`bind_topic_group` (group_id, topic_id) VALUES (groupId, topicId);
		END IF;
	UNTIL flag END REPEAT;
END//
DELIMITER ;


-- Дамп структуры для процедура vbas.func_link_topic_to_notify_groups_normal
DROP PROCEDURE IF EXISTS `func_link_topic_to_notify_groups_normal`;
DELIMITER //
CREATE PROCEDURE `func_link_topic_to_notify_groups_normal`(IN `topicId` INT, IN `notificationId` INT)
    COMMENT 'Линкует найденные группы к указанному топику'
BEGIN
	DECLARE groupId INT;
	DECLARE flag INT DEFAULT 0;
	DECLARE cur CURSOR FOR SELECT DISTINCT(group_id) FROM object_notification_groups WHERE notification_id=notificationId AND to_normal=1;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET flag = 1;

	OPEN cur;
	REPEAT
		FETCH cur INTO groupId;
		IF groupId>0 THEN
			INSERT INTO `vdesk`.`bind_topic_group` (group_id, topic_id) VALUES (groupId, topicId);
		END IF;
	UNTIL flag END REPEAT;
END//
DELIMITER ;


-- Дамп структуры для процедура vbas.func_link_topic_to_notify_groups_offnormal
DROP PROCEDURE IF EXISTS `func_link_topic_to_notify_groups_offnormal`;
DELIMITER //
CREATE PROCEDURE `func_link_topic_to_notify_groups_offnormal`(IN `topicId` INT, IN `notificationId` INT)
    COMMENT 'Линкует найденные группы к указанному топику'
BEGIN
	DECLARE groupId INT;
	DECLARE flag INT DEFAULT 0;
	DECLARE cur CURSOR FOR SELECT DISTINCT(group_id) FROM object_notification_groups WHERE notification_id=notificationId AND to_offnormal=1;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET flag = 1;

	OPEN cur;
	REPEAT
		FETCH cur INTO groupId;
		IF groupId>0 THEN
			INSERT INTO `vdesk`.`bind_topic_group` (group_id, topic_id) VALUES (groupId, topicId);
		END IF;
	UNTIL flag END REPEAT;
END//
DELIMITER ;


-- Дамп структуры для процедура vbas.func_prepare_object_topic_info
DROP PROCEDURE IF EXISTS `func_prepare_object_topic_info`;
DELIMITER //
CREATE PROCEDURE `func_prepare_object_topic_info`(IN `object_id` INT)
    COMMENT 'Подготовка данных об объекте для наблюдения за ним (записываются в специальную таблицу) object_looks'
BEGIN
	DECLARE objectTypeName 		VARCHAR(64);
	DECLARE objectTypeId 		INT;
	DECLARE parentId				INT;
	DECLARE objectTableName 	VARCHAR(64);
	DECLARE objectMessageText 	VARCHAR(250);
	DECLARE objectParentName 	VARCHAR(100);
	DECLARE objectName 			VARCHAR(100);
	DECLARE eventEnable 			INT;
	DECLARE eventMessageText 	VARCHAR(250);
	DECLARE notificationClass 	INT;
	DECLARE notificationClassId 	INT;


 	DECLARE queryString 		VARCHAR(250);

	DECLARE tableName 		VARCHAR(64);
	DECLARE message1 			VARCHAR(200);
	DECLARE message2 			VARCHAR(200);
	DECLARE message3 			VARCHAR(200);
	DECLARE activeText 		VARCHAR(50);
	DECLARE inactiveText 	VARCHAR(50);
	DECLARE alarmValueText 	VARCHAR(50);
	DECLARE normalValueText	VARCHAR(50);
	DECLARE yesLook			BOOL DEFAULT FALSE;






	SELECT objects.Object_Type, objects.Object_Type, objects.parent_id, objects.Object_Name FROM objects WHERE id=object_id INTO objectTypeName, objectTypeId, parentId, objectName;
	SET objectTableName = CONCAT('objects.', objectTypeName);

	-- CALL func_debug(CONCAT('type: ', objectTypeName, ' : ', objectTypeId, ' : ',parentId));


-- 	IF objectTypeId IN (1,2,3) THEN		-- analog
-- 		SET @queryString = CONCAT('SELECT Event_Enable, Event_Detection_Enable, Event_Message_Texts, Notification_Class, Low_Limit, High_Limit, 	NULL, 		   NULL	FROM `', objectTableName, '` WHERE id=', object_id, ' INTO @eventEnable,@eventDetectionEnable, @eventMessageText, @notificationClass, @lowLimit, @highLimit, @alarmValue, @mulistateAlarmValue');
-- 	ELSEIF objectTypeId IN (4,6) THEN	-- binary
-- 		SET @queryString = CONCAT('SELECT Event_Enable, Event_Detection_Enable, Event_Message_Texts, Notification_Class, NULL, 		 NULL,		 	Alarm_Value-1, NULL FROM `', objectTableName, '` WHERE id=', object_id, ' INTO @eventEnable,@eventDetectionEnable, @eventMessageText, @notificationClass, @lowLimit, @highLimit, @alarmValue, @mulistateAlarmValue');
-- 	ELSE
-- 		SET @queryString = CONCAT('SELECT Event_Enable, Event_Detection_Enable, Event_Message_Texts, Notification_Class, NULL, 		 NULL, 			NULL, 		   NULL FROM `', objectTableName, '` WHERE id=', object_id, ' INTO @eventEnable,@eventDetectionEnable, @eventMessageText, @notificationClass, @lowLimit, @highLimit, @alarmValue, @mulistateAlarmValue');
-- 	END IF;
--
-- 	PREPARE exec from @queryString;
-- 	EXECUTE exec;



	-- 	CALL func_debug( CONCAT('objectTypeId: ALL =', objectTypeName));


	CASE objectTypeId
		WHEN 1 THEN	-- analog input
			SELECT Event_Enable, Event_Detection_Enable, Event_Message_Texts, Notification_Class, Low_Limit, High_Limit 	FROM `objects.analog-input` WHERE id= object_id
			 INTO  @eventEnable, @eventDetectionEnable,  @eventMessageText,   @notificationClass, @lowLimit, @highLimit;

		WHEN 2 THEN	-- analog output
			SELECT Event_Enable, Event_Detection_Enable, Event_Message_Texts, Notification_Class, Low_Limit, High_Limit		FROM `objects.analog-output` WHERE id= object_id
			 INTO  @eventEnable, @eventDetectionEnable,  @eventMessageText,   @notificationClass, @lowLimit, @highLimit;

		WHEN 3 THEN	-- analog value
			SELECT Event_Enable, Event_Detection_Enable, Event_Message_Texts, Notification_Class, Low_Limit, High_Limit		FROM `objects.analog-value` WHERE id= object_id
			 INTO  @eventEnable, @eventDetectionEnable,  @eventMessageText,   @notificationClass, @lowLimit, @highLimit;

		WHEN 4 THEN	-- binary input
			SELECT  Event_Enable, Event_Detection_Enable, Event_Message_Texts, Notification_Class, NULL, 		NULL,		 	Alarm_Value-1, Active_Text, Inactive_Text	FROM `objects.binary-input` WHERE id= object_id
			  INTO  @eventEnable, @eventDetectionEnable,  @eventMessageText,   @notificationClass, @lowLimit,  @highLimit, @alarmValue,   activeText,  inactiveText;

			-- CALL func_debug( CONCAT('binary texts: ', activeText, ' / ', inactiveText));

			IF activeText IS NULL THEN
				SET activeText = 'Active';
			END IF;
			IF inactiveText IS NULL THEN
				SET activeText = 'Inactive';
			END IF;

			IF @alarmValue THEN
				SET alarmValueText = activeText;
				SET normalValueText = inactiveText;
			ELSE
				SET alarmValueText = inactiveText;
				SET normalValueText = activeText;
			END IF;



		WHEN 6 THEN	-- binary input
			SELECT  Event_Enable, Event_Detection_Enable, Event_Message_Texts, Notification_Class, NULL, 		NULL,		 	Alarm_Value-1, Active_Text, Inactive_Text	FROM `objects.binary-value` WHERE id= object_id
			  INTO  @eventEnable, @eventDetectionEnable,  @eventMessageText,   @notificationClass, @lowLimit,  @highLimit, @alarmValue,   activeText,  inactiveText;
			-- CALL func_debug( CONCAT('binary texts: ', activeText, ' / ', inactiveText));

			IF activeText IS NULL THEN
				SET activeText = 'Active';
			END IF;
			IF inactiveText IS NULL THEN
				SET activeText = 'Inactive';
			END IF;

			IF @alarmValue THEN
				SET alarmValueText = activeText;
				SET normalValueText = inactiveText;
			ELSE
				SET alarmValueText = inactiveText;
				SET normalValueText = activeText;
			END IF;



		WHEN 9 THEN	-- device
			SELECT  Event_Enable, Event_Detection_Enable, Event_Message_Texts, Notification_Class, NULL, 		NULL,		 	0, 'Работает', 'Не работает'	FROM `objects.device` WHERE id= object_id
			  INTO  @eventEnable, @eventDetectionEnable,  @eventMessageText,   @notificationClass, @lowLimit,  @highLimit, @alarmValue,   activeText,  inactiveText;
			-- CALL func_debug( CONCAT('binary texts: ', activeText, ' / ', inactiveText));

			IF activeText IS NULL THEN
				SET activeText = 'Active';
			END IF;
			IF inactiveText IS NULL THEN
				SET activeText = 'Inactive';
			END IF;

			IF @alarmValue THEN
				SET alarmValueText = activeText;
				SET normalValueText = inactiveText;
			ELSE
				SET alarmValueText = inactiveText;
				SET normalValueText = activeText;
			END IF;



		WHEN 14 THEN	-- multi-state input
			CALL func_debug( CONCAT('objectTypeId: ', objectTypeName));
		WHEN 15 THEN	-- multi-state output
			CALL func_debug( CONCAT('objectTypeId: ', objectTypeName));
		WHEN 20 THEN	-- multi-state value
			CALL func_debug( CONCAT('objectTypeId: ', objectTypeName));
		ELSE
			CALL func_debug( CONCAT('objectTypeId: ', 'ERROR(!)'));
		END CASE;



-- 	CALL func_debug(@queryString);


  	SELECT id FROM objects WHERE objects.Object_Type=16 AND objects.Object_Identifier=@notificationClass INTO notificationClassId;

	IF notificationClassId>0 THEN
		CALL func_debug(CONCAT('notificationClass[DEVICE] = ', notificationClass, ' notificationClassId = ', notificationClassId));
	END IF;

--  	CALL func_debug(CONCAT('notificationClass = ', notificationClass, ' notificationClassId = ', notificationClassId));


  	IF @eventEnable>0 AND @eventDetectionEnable AND  @eventMessageText IS NOT NULL AND @notificationClass>0 AND notificationClassId>0 THEN
		SET message1 = SUBSTRING_INDEX(@eventMessageText, '|', 2);
		SET message2 = SUBSTRING_INDEX(message1, '|', -1);
		SET message1 = SUBSTRING_INDEX(message1, '|', 1);
		SET message3 = SUBSTRING_INDEX(@eventMessageText, '|', -1);

		IF objectTypeId=4 OR objectTypeId=5 THEN
			SET message1 = REPLACE(message1, '{{.Value}}', alarmValueText);
			SET message3 = REPLACE(message3, '{{.Value}}', normalValueText);
		END IF;


		-- Имя топика формируется как имя вышестоящего FOLDER - Description
		-- Если Description отсутствует берётся последняя часть Object_Name (после точки)
		-- Но если нет и его - то просто имя объекта (на всякий случай)
	 	SELECT Description FROM `objects.folder` WHERE id=parentId INTO objectParentName;

	 	IF objectParentName IS NULL THEN
			SELECT Object_Name FROM objects WHERE id=parentId INTO objectParentName;
		 	IF objectParentName IS NULL THEN
		 		SET objectParentName = objectName;
	 		ELSE
				SET objectParentName = SUBSTRING_INDEX(objectParentName, '.', -1);
			END IF;
		END IF;



	 	IF (SELECT id from `object_looks` WHERE id=object_id LIMIT 0,1) THEN
		 	-- CALL func_debug('Объект уже вставлен, будем "править"');
		 	SET yesLook = TRUE;
		 	UPDATE `object_looks`
				SET
					object_type					= objectTypeName,
					object_type_id				= objectTypeId,
					notification_id			= notificationClassId,
			 		enable_to_offnormal		= @eventEnable&4>0,
					enable_to_fault			= @eventEnable&2>0,
			 		enable_to_normal			= @eventEnable&1>0,
					parent_name					= objectParentName,
			 		message_to_offnormal		= message1,
			 		message_to_fault			= message2,
			 		message_to_normal			= message3,
			 		analog_low					= @lowLimit,
			 		analog_high					= @highLimit,
			 		binary_alarm				= @alarmValue,
			 		multistate_alarm			= @mulistateAlarmValue

		 		WHERE
				 id=object_id;

	 	ELSE
		 	SET yesLook = TRUE;
		 	INSERT INTO `object_looks` (
			 	 id,
			 	 object_type,
			 	 object_type_id,
			 	 notification_id,
				 enable_to_offnormal,
				 enable_to_fault,
				 enable_to_normal,
			 	 parent_name,
				 message_to_offnormal,
				 message_to_fault,
				 message_to_normal,
				 analog_low,
				 analog_high,
				 binary_alarm,
				 multistate_alarm
			 ) VALUES (
				 object_id,
				 objectTypeName,
				 objectTypeId,
				 notificationClassId,
				 @eventEnable&4>0,
				 @eventEnable&2>0,
				 @eventEnable&1>0,
				 objectParentName,
				 message1,
				 message2,
				 message3,
				 @lowLimit,
				 @highLimit,
				 @alarmValue,
				 @mulistateAlarmValue
				 );
		 	END IF;
	ELSE
		-- CALL func_debug(CONCAT('OBJECT #', object_id, ' HAVE NOT ANY EVENTS' ));
		DELETE FROM `object_looks` WHERE id=object_id;
  	END IF;

  	IF NOT yesLook THEN
		DELETE FROM `object_looks` WHERE id=object_id;
  	END IF;

END//
DELIMITER ;


-- Дамп структуры для функция vbas.func_replace_NameValueTime
DROP FUNCTION IF EXISTS `func_replace_NameValueTime`;
DELIMITER //
CREATE FUNCTION `func_replace_NameValueTime`(`message` VARCHAR(250), `name` VARCHAR(150), `value` VARCHAR(100), `time` DATETIME) RETURNS text CHARSET utf8 COLLATE utf8_unicode_ci DETERMINISTIC
BEGIN
	DECLARE result TEXT;
	IF message NOT LIKE '%{{.%' THEN
		RETURN message;
	END IF;

	SET result = REPLACE(message, '{{.Value}}', `value`);
	SET result = REPLACE(result, '{{.Time}}', `time`);
	SET result = REPLACE(result, '{{.Name}}', `name`);

	RETURN result;
END//
DELIMITER ;



-- Дамп структуры для таблица vbas.objects
DROP TABLE IF EXISTS `objects`;
CREATE TABLE IF NOT EXISTS `objects` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Сквозной уникальный идентификатор объекта',
  `parent_id` int(11) NOT NULL COMMENT 'id родительского объекта',
  `device_id` int(11) DEFAULT NULL COMMENT 'id объекта device, к которому привязан объект',
  `reliability_id` int(11) NOT NULL DEFAULT '0',
  `map_id` INT(11) NOT NULL DEFAULT '0' COMMENT 'id объекта Map: на карте',
  `out_of_service` tinyint(1) NOT NULL DEFAULT '0',
  `bacnet_name` varchar(256) DEFAULT NULL COMMENT 'имя объекта получаемое от bacnet устройства',
  `value` double DEFAULT '0',
  `status` tinyint(4) DEFAULT '0',
  `timestamp` datetime DEFAULT NULL COMMENT 'время последнего обновления',
  `Object_Identifier` int(11) DEFAULT NULL COMMENT '75 Идентификатор объекта',
  `Object_Name` varchar(256) DEFAULT NULL COMMENT '77 Имя объекта',
  `Object_Type` enum('analog-input','analog-output','analog-value','binary-input','binary-output','binary-value','calendar','command','device','event-enrollment','file','group','loop','multi-state-input','multi-state-output','notification-class','program','schedule','averaging','multi-state-value','trend-log','life-safety-point','life-safety-zone','accumulator','pulse-converter','event-log','global-group','trend-log-multiple','load-control','structured-view','access-door','access-credential','access-point','access-rights','access-user','access-zone','credential-data-input','network-security','bitstring-value','characterstring-value','date-pattern-value','date-value','datetime-pattern-value','datetime-value','integer-value','large-analog-value','octetstring-value','positive-integer-value','time-pattern-value','time-value','notification-forwarder','alert-enrollment','channel','lighting-output','folder','site','trunk','graphic') NOT NULL COMMENT '79 Тип объекта',
  `Property_List` text COMMENT '371 Список свойств',
  `Log_Enable` tinyint(1) DEFAULT '0' COMMENT '133 Включить логгирование',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  UNIQUE KEY `index_tree` (`device_id`,`Object_Identifier`,`Object_Type`),
  KEY `identifier` (`Object_Identifier`),
  KEY `name` (`Object_Name`(255)),
  KEY `type` (`Object_Type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.


-- Дамп структуры для таблица vbas.objects.access-credential
DROP TABLE IF EXISTS `objects.access-credential`;
CREATE TABLE IF NOT EXISTS `objects.access-credential` (
  `id` int(11) NOT NULL COMMENT 'Сквозной уникальный идентификатор объекта',
  `Description` varchar(256) DEFAULT NULL COMMENT '28 Описание',
  `Global_Identifier` int(10) unsigned DEFAULT NULL COMMENT '323 Глобальный идентификатор',
  `Status_Flags` tinyint(4) DEFAULT NULL COMMENT '111 Флаги состояния',
  `Reliability` varchar(256) DEFAULT NULL COMMENT '103 Освободить по умолчанию',
  `Credential_Status` enum('inactive','active') DEFAULT NULL COMMENT '264 Статус учетных данных',
  `Reason_For_Disable` int(10) unsigned DEFAULT NULL COMMENT '303 Причина отключения',
  `Authentication_Factors` text COMMENT '257 Факторы аутентификации',
  `Activation_Time` datetime(3) DEFAULT NULL COMMENT '254 Время активации',
  `Expiry_Time` datetime(3) DEFAULT NULL COMMENT '270 Время истечения срока действия',
  `Credential_Disable` enum('none','disable','disable-manual','disable-lockout') DEFAULT NULL COMMENT '263 Учетные данные отключены',
  `Days_Remaining` int(11) DEFAULT NULL COMMENT '267 Дней осталось',
  `Uses_Remaining` int(11) DEFAULT NULL COMMENT '319 Пользователей осталось',
  `Absentee_Limit` int(10) unsigned DEFAULT NULL COMMENT '244 Отсутствующий предел',
  `Belongs_To` varchar(256) DEFAULT NULL COMMENT '262 Принадлежит',
  `Assigned_Access_Rights` text COMMENT '256 Присвоенные права доступа',
  `Last_Access_Point` varchar(256) DEFAULT NULL COMMENT '276 Точка последнего доступа',
  `Last_Access_Event` enum('none','granted','muster','passback-detected','duress','trace','lockout-max-attempts','lockout-other','lockout-relinquished','locked-by-higher-priority','out-of-service','out-of-service-relinquished','accompaniment-by','authentication-factor-read','authorization-delayed','verification-required','no-entry-after-grant','denied-deny-all','denied-unknown-credential','denied-authentication-unavailable','denied-authentication-factor-timeout','denied-incorrect-authentication-factor','denied-zone-no-access-rights','denied-point-no-access-rights','denied-no-access-rights','denied-out-of-time-range','denied-threat-level','denied-passback','denied-unexpected-location-usage','denied-max-attempts','denied-lower-occupancy-limit','denied-upper-occupancy-limit','denied-authentication-factor-lost','denied-authentication-factor-stolen','denied-authentication-factor-damaged','denied-authentication-factor-destroyed','denied-authentication-factor-disabled','denied-authentication-factor-error','denied-credential-unassigned','denied-credential-not-provisioned','denied-credential-not-yet-active','denied-credential-expired','denied-credential-manual-disable','denied-credential-lockout','denied-credential-max-days','denied-credential-max-uses','denied-credential-inactivity','denied-credential-disabled','denied-no-accompaniment','denied-incorrect-accompaniment','denied-lockout','denied-verification-failed','denied-verification-timeout','denied-other') DEFAULT NULL COMMENT '275 Событие последнего доступа',
  `Last_Use_Time` datetime(3) DEFAULT NULL COMMENT '281 Время последнего использования',
  `Trace_Flag` tinyint(1) DEFAULT NULL COMMENT '308 Отследить флаг',
  `Threat_Authority` int(10) unsigned DEFAULT NULL COMMENT '306 Угроза - полномочный орган',
  `Extended_Time_Enable` tinyint(1) DEFAULT NULL COMMENT '271 Расширенное время включено',
  `Authorization_Exemptions` int(10) unsigned DEFAULT NULL COMMENT '364 Авторизация изъятия',
  `Reliability_Evaluation_Inhibit` tinyint(1) DEFAULT NULL COMMENT '357 Оценка надежности сдерживания',
  `Profile_Name` varchar(256) DEFAULT NULL COMMENT '168 Имя профиля',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.


-- Дамп структуры для таблица vbas.objects.access-door
DROP TABLE IF EXISTS `objects.access-door`;
CREATE TABLE IF NOT EXISTS `objects.access-door` (
  `id` int(11) NOT NULL COMMENT 'Сквозной уникальный идентификатор объекта',
  `Present_Value` enum('lock','unlock','pulse-unlock','extended-pulse-unlock') DEFAULT NULL COMMENT '85 Текущее значение',
  `Description` varchar(256) DEFAULT NULL COMMENT '28 Описание',
  `Status_Flags` tinyint(4) DEFAULT NULL COMMENT '111 Флаги состояния',
  `Event_State` varchar(256) DEFAULT NULL COMMENT '36 Состояние события',
  `Reliability` varchar(256) DEFAULT NULL COMMENT '103 Освободить по умолчанию',
  `Out_Of_Service` tinyint(1) DEFAULT NULL COMMENT '81 Не работает',
  `Priority_Array` varchar(256) DEFAULT NULL COMMENT '87 Приоритетный массив',
  `Relinquish_Default` enum('lock','unlock','pulse-unlock','extended-pulse-unlock') DEFAULT NULL COMMENT '104 Освободить по умолчанию',
  `Door_Status` enum('closed','opened','unknown','door-fault','unused') DEFAULT NULL COMMENT '231 Дверь статус',
  `Lock_Status` enum('locked','unlocked','lock-fault','unused','unknown') DEFAULT NULL COMMENT '233 Состояние закрытия',
  `Secured_Status` enum('secured','unsecured','unknown') DEFAULT NULL COMMENT '235 Статус охраны',
  `Door_Members` text COMMENT '228 Дверь члены',
  `Door_Pulse_Time` int(10) unsigned DEFAULT NULL COMMENT '230 Дверь импульсное время',
  `Door_Extended_Pulse_Time` int(10) unsigned DEFAULT NULL COMMENT '227 Дверь расширенное импульсное время',
  `Door_Unlock_Delay_Time` int(10) unsigned DEFAULT NULL COMMENT '232 Дверь задержка открытого замка',
  `Door_Open_Too_Long_Time` int(10) unsigned DEFAULT NULL COMMENT '229 Дверь открыта слишком долгое время',
  `Door_Alarm_State` varchar(256) DEFAULT NULL COMMENT '226 Состояние сигнализации двери',
  `Masked_Alarm_Values` int(10) unsigned DEFAULT NULL COMMENT '234 Значения подмененной тревоги',
  `Maintenance_Required` varchar(256) DEFAULT NULL COMMENT '158 Требуется обслуживание',
  `Time_Delay` int(10) unsigned DEFAULT NULL COMMENT '113 Задержка по времени',
  `Notification_Class` int(10) unsigned DEFAULT NULL COMMENT '17 Класс уведомления',
  `Alarm_Values` int(10) unsigned DEFAULT NULL COMMENT '7 Сигнальные значения',
  `Fault_Values` int(10) unsigned DEFAULT NULL COMMENT '39 Значений ошибки',
  `Event_Enable` tinyint(4) DEFAULT NULL COMMENT '35 Событие разрешено',
  `Acked_Transitions` tinyint(4) DEFAULT NULL COMMENT '0 Признаный переход',
  `Notify_Type` enum('alarm','event','ack-notification') DEFAULT NULL COMMENT '72 Тип уведомления',
  `Event_Time_Stamps` text COMMENT '130 Отметки времени событий',
  `Event_Message_Texts` text COMMENT '351 Тексты сообщений о событиях',
  `Event_Message_Texts_Config` text COMMENT '352 Конфигурация текстов сообщений о событиях',
  `Event_Detection_Enable` tinyint(1) DEFAULT NULL COMMENT '353 Включить обнаружение событий',
  `Event_Algorithm_Inhibit_Ref` varchar(256) DEFAULT NULL COMMENT '355 Ссылка события алгоритма сдерживания',
  `Event_Algorithm_Inhibit` tinyint(1) DEFAULT NULL COMMENT '354 События алгоритма сдерживания',
  `Time_Delay_Normal` int(10) unsigned DEFAULT NULL COMMENT '356 Нормальная задержка времени',
  `Reliability_Evaluation_Inhibit` tinyint(1) DEFAULT NULL COMMENT '357 Оценка надежности сдерживания',
  `Profile_Name` varchar(256) DEFAULT NULL COMMENT '168 Имя профиля',
  `event_state_tmp` varchar(256) DEFAULT NULL COMMENT '36 Состояние события, в течение интервалов timeDelay, timeDelayNormal',
  `event_timestamps_tmp` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.


-- Дамп структуры для таблица vbas.objects.access-point
DROP TABLE IF EXISTS `objects.access-point`;
CREATE TABLE IF NOT EXISTS `objects.access-point` (
  `id` int(11) NOT NULL COMMENT 'Сквозной уникальный идентификатор объекта',
  `Description` varchar(256) DEFAULT NULL COMMENT '28 Описание',
  `Status_Flags` tinyint(4) DEFAULT NULL COMMENT '111 Флаги состояния',
  `Event_State` varchar(256) DEFAULT NULL COMMENT '36 Состояние события',
  `Reliability` varchar(256) DEFAULT NULL COMMENT '103 Освободить по умолчанию',
  `Out_Of_Service` tinyint(1) DEFAULT NULL COMMENT '81 Не работает',
  `Authentication_Status` enum('not-ready','ready','disabled','waiting-for-authentication-factor','waiting-for-accompaniment','waiting-for-verification','in-progress') DEFAULT NULL COMMENT '260 Состояние аутентификации',
  `Active_Authentication_Policy` int(10) unsigned DEFAULT NULL COMMENT '255 Активная политика аутентификации',
  `Number_Of_Authentication_Policies` int(10) unsigned DEFAULT NULL COMMENT '289 Число идентификационных политик',
  `Authentication_Policy_List` text COMMENT '258 Список политик аутентификаций',
  `Authentication_Policy_Names` text COMMENT '259 Имена политики аутентификаций',
  `Authorization_Mode` varchar(256) DEFAULT NULL COMMENT '261 Режим авторизации',
  `Verification_Time` int(10) unsigned DEFAULT NULL COMMENT '326 Время проверки',
  `Lockout` tinyint(1) DEFAULT NULL COMMENT '282 Блокировка',
  `Lockout_Relinquish_Time` int(10) unsigned DEFAULT NULL COMMENT '283 Время высвобождения блокировки',
  `Failed_Attempts` int(10) unsigned DEFAULT NULL COMMENT '273 Неудачных попыток',
  `Failed_Attempt_Events` int(10) unsigned DEFAULT NULL COMMENT '272 События неудачных попыток',
  `Max_Failed_Attempts` int(10) unsigned DEFAULT NULL COMMENT '285 Макс. число неудачных попыток',
  `Failed_Attempts_Time` int(10) unsigned DEFAULT NULL COMMENT '274 Время неудачных попыток',
  `Threat_Level` int(10) unsigned DEFAULT NULL COMMENT '307 Уровень угроз',
  `Occupancy_Upper_Limit_Enforced` tinyint(1) DEFAULT NULL COMMENT '298 Верхний порог присутствия применен принудительно',
  `Occupancy_Lower_Limit_Enforced` tinyint(1) DEFAULT NULL COMMENT '295 Нижний порог присутствия применен принудительно',
  `Occupancy_Count_Adjust` tinyint(1) DEFAULT NULL COMMENT '291 Регулировка подсчета присутствия',
  `Accompaniment_Time` int(10) unsigned DEFAULT NULL COMMENT '253 Время сопровождения',
  `Access_Event` varchar(256) DEFAULT NULL COMMENT '247 Событие доступа',
  `Access_Event_Tag` int(10) unsigned DEFAULT NULL COMMENT '322 Описание события доступа',
  `Access_Event_Time` varchar(256) DEFAULT NULL COMMENT '250 Время события доступа',
  `Access_Event_Credential` varchar(256) DEFAULT NULL COMMENT '249 Учетные данные для события доступа',
  `Access_Event_Authentication_Factor` varchar(256) DEFAULT NULL COMMENT '248 Фактор аутентификации события доступа',
  `Access_Doors` text COMMENT '246 Двери доступа',
  `Priority_For_Writing` int(11) DEFAULT NULL COMMENT '88 Приоритет на запись',
  `Muster_Point` tinyint(1) DEFAULT NULL COMMENT '287 Главная точка',
  `Zone_To` varchar(256) DEFAULT NULL COMMENT '321 Зона - куда',
  `Zone_From` varchar(256) DEFAULT NULL COMMENT '320 Зона - откуда',
  `Notification_Class` int(10) unsigned DEFAULT NULL COMMENT '17 Класс уведомления',
  `Transaction_Notification_Class` int(10) unsigned DEFAULT NULL COMMENT '309 Класс уведомлений трансакций',
  `Access_Alarm_Events` int(10) unsigned DEFAULT NULL COMMENT '245 Сигнал событий доступа',
  `Access_Transaction_Events` int(10) unsigned DEFAULT NULL COMMENT '251 Транзакция событий доступа',
  `Event_Enable` tinyint(4) DEFAULT NULL COMMENT '35 Событие разрешено',
  `Acked_Transitions` tinyint(4) DEFAULT NULL COMMENT '0 Признаный переход',
  `Notify_Type` enum('alarm','event','ack-notification') DEFAULT NULL COMMENT '72 Тип уведомления',
  `Event_Time_Stamps` text COMMENT '130 Отметки времени событий',
  `Event_Message_Texts` text COMMENT '351 Тексты сообщений о событиях',
  `Event_Message_Texts_Config` text COMMENT '352 Конфигурация текстов сообщений о событиях',
  `Event_Detection_Enable` tinyint(1) DEFAULT NULL COMMENT '353 Включить обнаружение событий',
  `Event_Algorithm_Inhibit_Ref` varchar(256) DEFAULT NULL COMMENT '355 Ссылка события алгоритма сдерживания',
  `Event_Algorithm_Inhibit` tinyint(1) DEFAULT NULL COMMENT '354 События алгоритма сдерживания',
  `Reliability_Evaluation_Inhibit` tinyint(1) DEFAULT NULL COMMENT '357 Оценка надежности сдерживания',
  `Profile_Name` varchar(256) DEFAULT NULL COMMENT '168 Имя профиля',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.


-- Дамп структуры для таблица vbas.objects.access-rights
DROP TABLE IF EXISTS `objects.access-rights`;
CREATE TABLE IF NOT EXISTS `objects.access-rights` (
  `id` int(11) NOT NULL COMMENT 'Сквозной уникальный идентификатор объекта',
  `Description` varchar(256) DEFAULT NULL COMMENT '28 Описание',
  `Global_Identifier` int(10) unsigned DEFAULT NULL COMMENT '323 Глобальный идентификатор',
  `Status_Flags` tinyint(4) DEFAULT NULL COMMENT '111 Флаги состояния',
  `Reliability` varchar(256) DEFAULT NULL COMMENT '103 Освободить по умолчанию',
  `Enable` tinyint(1) DEFAULT NULL COMMENT '133 Включить',
  `Negative_Access_Rules` text COMMENT '288 Негативные правила доступа',
  `Positive_Access_Rules` text COMMENT '302 Позитивные правила доступа',
  `Accompaniment` varchar(256) DEFAULT NULL COMMENT '252 Сопровождение',
  `Reliability_Evaluation_Inhibit` tinyint(1) DEFAULT NULL COMMENT '357 Оценка надежности сдерживания',
  `Profile_Name` varchar(256) DEFAULT NULL COMMENT '168 Имя профиля',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.


-- Дамп структуры для таблица vbas.objects.access-user
DROP TABLE IF EXISTS `objects.access-user`;
CREATE TABLE IF NOT EXISTS `objects.access-user` (
  `id` int(11) NOT NULL COMMENT 'Сквозной уникальный идентификатор объекта',
  `Description` varchar(256) DEFAULT NULL COMMENT '28 Описание',
  `Global_Identifier` int(10) unsigned DEFAULT NULL COMMENT '323 Глобальный идентификатор',
  `Status_Flags` tinyint(4) DEFAULT NULL COMMENT '111 Флаги состояния',
  `Reliability` varchar(256) DEFAULT NULL COMMENT '103 Освободить по умолчанию',
  `User_Type` enum('asset','group','person') DEFAULT NULL COMMENT '318 Тип пользователя',
  `User_Name` varchar(256) DEFAULT NULL COMMENT '317 Имя пользователя с доступом',
  `User_External_Identifier` varchar(256) DEFAULT NULL COMMENT '310 Внешний идентификатор пользователя',
  `User_Information_Reference` varchar(256) DEFAULT NULL COMMENT '311 Ссылка информации о пользователе',
  `Members` int(10) unsigned DEFAULT NULL COMMENT '286 Члены',
  `Member_Of` int(10) unsigned DEFAULT NULL COMMENT '159 Член',
  `Credentials` int(10) unsigned DEFAULT NULL COMMENT '265 Полномочия',
  `Reliability_Evaluation_Inhibit` tinyint(1) DEFAULT NULL COMMENT '357 Оценка надежности сдерживания',
  `Profile_Name` varchar(256) DEFAULT NULL COMMENT '168 Имя профиля',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.


-- Дамп структуры для таблица vbas.objects.access-zone
DROP TABLE IF EXISTS `objects.access-zone`;
CREATE TABLE IF NOT EXISTS `objects.access-zone` (
  `id` int(11) NOT NULL COMMENT 'Сквозной уникальный идентификатор объекта',
  `Description` varchar(256) DEFAULT NULL COMMENT '28 Описание',
  `Global_Identifier` int(10) unsigned DEFAULT NULL COMMENT '323 Глобальный идентификатор',
  `Occupancy_State` enum('normal','below-lower-limit','at-lower-limit','at-upper-limit','above-upper-limit','disabled','not-supported') DEFAULT NULL COMMENT '296 Состояние присутствия',
  `Status_Flags` tinyint(4) DEFAULT NULL COMMENT '111 Флаги состояния',
  `Event_State` varchar(256) DEFAULT NULL COMMENT '36 Состояние события',
  `Reliability` varchar(256) DEFAULT NULL COMMENT '103 Освободить по умолчанию',
  `Out_Of_Service` tinyint(1) DEFAULT NULL COMMENT '81 Не работает',
  `Occupancy_Count` int(10) unsigned DEFAULT NULL COMMENT '290 Подсчет присутствия',
  `Occupancy_Count_Enable` tinyint(1) DEFAULT NULL COMMENT '292 Подсчет присутствия включен',
  `Adjust_Value` int(11) DEFAULT NULL COMMENT '176 Скорректируемое значение',
  `Occupancy_Upper_Limit` int(10) unsigned DEFAULT NULL COMMENT '297 Повышенный лимит присутствия',
  `Occupancy_Lower_Limit` int(10) unsigned DEFAULT NULL COMMENT '294 Сниженый лимит присутствия',
  `Credentials_In_Zone` int(10) unsigned DEFAULT NULL COMMENT '266 Полномочия в зоне',
  `Last_Credential_Added` varchar(256) DEFAULT NULL COMMENT '277 Последняя добавленная учетная запись',
  `Last_Credential_Added_Time` datetime(3) DEFAULT NULL COMMENT '278 Время последней добавленной записи',
  `Last_Credential_Removed` varchar(256) DEFAULT NULL COMMENT '279 Последняя удаленная учетная запись',
  `Last_Credential_Removed_Time` datetime(3) DEFAULT NULL COMMENT '280 Время последней удаленной записи',
  `Passback_Mode` enum('passback-off','hard-passback','soft-passback') DEFAULT NULL COMMENT '300 Режим PASSBACK',
  `Passback_Timeout` int(10) unsigned DEFAULT NULL COMMENT '301 Задержка PASSBACK',
  `Entry_Points` int(10) unsigned DEFAULT NULL COMMENT '268 Точки входа',
  `Exit_Points` int(10) unsigned DEFAULT NULL COMMENT '269 Точки выхода',
  `Time_Delay` int(10) unsigned DEFAULT NULL COMMENT '113 Задержка по времени',
  `Notification_Class` int(10) unsigned DEFAULT NULL COMMENT '17 Класс уведомления',
  `Alarm_Values` int(10) unsigned DEFAULT NULL COMMENT '7 Сигнальные значения',
  `Event_Enable` tinyint(4) DEFAULT NULL COMMENT '35 Событие разрешено',
  `Acked_Transitions` tinyint(4) DEFAULT NULL COMMENT '0 Признаный переход',
  `Notify_Type` enum('alarm','event','ack-notification') DEFAULT NULL COMMENT '72 Тип уведомления',
  `Event_Time_Stamps` text COMMENT '130 Отметки времени событий',
  `Event_Message_Texts` text COMMENT '351 Тексты сообщений о событиях',
  `Event_Message_Texts_Config` text COMMENT '352 Конфигурация текстов сообщений о событиях',
  `Event_Detection_Enable` tinyint(1) DEFAULT NULL COMMENT '353 Включить обнаружение событий',
  `Event_Algorithm_Inhibit_Ref` varchar(256) DEFAULT NULL COMMENT '355 Ссылка события алгоритма сдерживания',
  `Event_Algorithm_Inhibit` tinyint(1) DEFAULT NULL COMMENT '354 События алгоритма сдерживания',
  `Time_Delay_Normal` int(10) unsigned DEFAULT NULL COMMENT '356 Нормальная задержка времени',
  `Reliability_Evaluation_Inhibit` tinyint(1) DEFAULT NULL COMMENT '357 Оценка надежности сдерживания',
  `Profile_Name` varchar(256) DEFAULT NULL COMMENT '168 Имя профиля',
  `event_state_tmp` varchar(256) DEFAULT NULL COMMENT '36 Состояние события, в течение интервалов timeDelay, timeDelayNormal',
  `event_timestamps_tmp` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.


-- Дамп структуры для таблица vbas.objects.accumulator
DROP TABLE IF EXISTS `objects.accumulator`;
CREATE TABLE IF NOT EXISTS `objects.accumulator` (
  `id` int(11) NOT NULL COMMENT 'Сквозной уникальный идентификатор объекта',
  `Present_Value` int(10) unsigned DEFAULT NULL COMMENT '85 Текущее значение',
  `Description` varchar(256) DEFAULT NULL COMMENT '28 Описание',
  `Device_Type` varchar(256) DEFAULT NULL COMMENT '31 Тип устройства',
  `Status_Flags` tinyint(4) DEFAULT NULL COMMENT '111 Флаги состояния',
  `Event_State` varchar(256) DEFAULT NULL COMMENT '36 Состояние события',
  `Reliability` varchar(256) DEFAULT NULL COMMENT '103 Освободить по умолчанию',
  `Out_Of_Service` tinyint(1) DEFAULT NULL COMMENT '81 Не работает',
  `Scale` varchar(256) DEFAULT NULL COMMENT '187 Масштаб',
  `Units` varchar(256) DEFAULT NULL COMMENT '117 Единицы',
  `Prescale` varchar(256) DEFAULT NULL COMMENT '185 Предделитель',
  `Max_Pres_Value` int(10) unsigned DEFAULT NULL COMMENT '65 Макс. значение',
  `Value_Change_Time` datetime(3) DEFAULT NULL COMMENT '192 Время изменения значения',
  `Value_Before_Change` int(10) unsigned DEFAULT NULL COMMENT '190 Значение перед изменением',
  `Value_Set` int(10) unsigned DEFAULT NULL COMMENT '191 Набор значений',
  `Logging_Record` varchar(256) DEFAULT NULL COMMENT '184 Запись логирования',
  `Logging_Object` int(10) unsigned DEFAULT NULL COMMENT '183 Объект логирования',
  `Pulse_Rate` int(10) unsigned DEFAULT NULL COMMENT '186 Частота импульсов',
  `High_Limit` int(10) unsigned DEFAULT NULL COMMENT '45 Высокий предел',
  `Low_Limit` int(10) unsigned DEFAULT NULL COMMENT '59 Низкий предел',
  `Limit_Monitoring_Interval` int(10) unsigned DEFAULT NULL COMMENT '182 Ограничить интервал мониторинга',
  `Notification_Class` int(10) unsigned DEFAULT NULL COMMENT '17 Класс уведомления',
  `Time_Delay` int(10) unsigned DEFAULT NULL COMMENT '113 Задержка по времени',
  `Limit_Enable` tinyint(4) DEFAULT NULL COMMENT '52 Предел включения',
  `Event_Enable` tinyint(4) DEFAULT NULL COMMENT '35 Событие разрешено',
  `Acked_Transitions` tinyint(4) DEFAULT NULL COMMENT '0 Признаный переход',
  `Notify_Type` enum('alarm','event','ack-notification') DEFAULT NULL COMMENT '72 Тип уведомления',
  `Event_Time_Stamps` text COMMENT '130 Отметки времени событий',
  `Event_Message_Texts` text COMMENT '351 Тексты сообщений о событиях',
  `Event_Message_Texts_Config` text COMMENT '352 Конфигурация текстов сообщений о событиях',
  `Event_Detection_Enable` tinyint(1) DEFAULT NULL COMMENT '353 Включить обнаружение событий',
  `Event_Algorithm_Inhibit_Ref` varchar(256) DEFAULT NULL COMMENT '355 Ссылка события алгоритма сдерживания',
  `Event_Algorithm_Inhibit` tinyint(1) DEFAULT NULL COMMENT '354 События алгоритма сдерживания',
  `Time_Delay_Normal` int(10) unsigned DEFAULT NULL COMMENT '356 Нормальная задержка времени',
  `Reliability_Evaluation_Inhibit` tinyint(1) DEFAULT NULL COMMENT '357 Оценка надежности сдерживания',
  `Profile_Name` varchar(256) DEFAULT NULL COMMENT '168 Имя профиля',
  `event_state_tmp` varchar(256) DEFAULT NULL COMMENT '36 Состояние события, в течение интервалов timeDelay, timeDelayNormal',
  `event_timestamps_tmp` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.


-- Дамп структуры для таблица vbas.objects.alert-enrollment
DROP TABLE IF EXISTS `objects.alert-enrollment`;
CREATE TABLE IF NOT EXISTS `objects.alert-enrollment` (
  `id` int(11) NOT NULL COMMENT 'Сквозной уникальный идентификатор объекта',
  `Description` varchar(256) DEFAULT NULL COMMENT '28 Описание',
  `Present_Value` int(10) unsigned DEFAULT NULL COMMENT '85 Текущее значение',
  `Event_State` varchar(256) DEFAULT NULL COMMENT '36 Состояние события',
  `Event_Detection_Enable` tinyint(1) DEFAULT NULL COMMENT '353 Включить обнаружение событий',
  `Notification_Class` int(10) unsigned DEFAULT NULL COMMENT '17 Класс уведомления',
  `Event_Enable` tinyint(4) DEFAULT NULL COMMENT '35 Событие разрешено',
  `Acked_Transitions` tinyint(4) DEFAULT NULL COMMENT '0 Признаный переход',
  `Notify_Type` enum('alarm','event','ack-notification') DEFAULT NULL COMMENT '72 Тип уведомления',
  `Event_Time_Stamps` text COMMENT '130 Отметки времени событий',
  `Event_Message_Texts` text COMMENT '351 Тексты сообщений о событиях',
  `Event_Message_Texts_Config` text COMMENT '352 Конфигурация текстов сообщений о событиях',
  `Event_Algorithm_Inhibit_Ref` varchar(256) DEFAULT NULL COMMENT '355 Ссылка события алгоритма сдерживания',
  `Event_Algorithm_Inhibit` tinyint(1) DEFAULT NULL COMMENT '354 События алгоритма сдерживания',
  `Profile_Name` varchar(256) DEFAULT NULL COMMENT '168 Имя профиля',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.


-- Дамп структуры для таблица vbas.objects.analog-input
DROP TABLE IF EXISTS `objects.analog-input`;
CREATE TABLE IF NOT EXISTS `objects.analog-input` (
  `id` int(11) NOT NULL COMMENT 'Сквозной уникальный идентификатор объекта',
  `Present_Value` float DEFAULT NULL COMMENT '85 Текущее значение',
  `Description` varchar(256) DEFAULT NULL COMMENT '28 Описание',
  `Device_Type` varchar(256) DEFAULT NULL COMMENT '31 Тип устройства',
  `Status_Flags` tinyint(4) DEFAULT NULL COMMENT '111 Флаги состояния',
  `Event_State` varchar(256) DEFAULT NULL COMMENT '36 Состояние события',
  `Reliability` varchar(256) DEFAULT NULL COMMENT '103 Освободить по умолчанию',
  `Out_Of_Service` tinyint(1) DEFAULT NULL COMMENT '81 Не работает',
  `Update_Interval` int(10) unsigned DEFAULT NULL COMMENT '118 Интервал обновления',
  `Units` varchar(256) DEFAULT NULL COMMENT '117 Единицы',
  `Min_Pres_Value` float DEFAULT NULL COMMENT '69 Мин. значение',
  `Max_Pres_Value` float DEFAULT NULL COMMENT '65 Макс. значение',
  `Resolution` float DEFAULT NULL COMMENT '106 Разрешение',
  `COV_Increment` float DEFAULT NULL COMMENT '22 Приращение COV',
  `Time_Delay` int(10) unsigned DEFAULT NULL COMMENT '113 Задержка по времени',
  `Notification_Class` int(10) unsigned DEFAULT NULL COMMENT '17 Класс уведомления',
  `High_Limit` float DEFAULT NULL COMMENT '45 Высокий предел',
  `Low_Limit` float DEFAULT NULL COMMENT '59 Низкий предел',
  `Deadband` float DEFAULT NULL COMMENT '25 Нечувствительность',
  `Limit_Enable` tinyint(4) DEFAULT NULL COMMENT '52 Предел включения',
  `Event_Enable` tinyint(4) DEFAULT NULL COMMENT '35 Событие разрешено',
  `Acked_Transitions` tinyint(4) DEFAULT NULL COMMENT '0 Признаный переход',
  `Notify_Type` enum('alarm','event','ack-notification') DEFAULT NULL COMMENT '72 Тип уведомления',
  `Event_Time_Stamps` text COMMENT '130 Отметки времени событий',
  `Event_Message_Texts` text COMMENT '351 Тексты сообщений о событиях',
  `Event_Message_Texts_Config` text COMMENT '352 Конфигурация текстов сообщений о событиях',
  `Event_Detection_Enable` tinyint(1) DEFAULT NULL COMMENT '353 Включить обнаружение событий',
  `Event_Algorithm_Inhibit_Ref` varchar(256) DEFAULT NULL COMMENT '355 Ссылка события алгоритма сдерживания',
  `Event_Algorithm_Inhibit` tinyint(1) DEFAULT NULL COMMENT '354 События алгоритма сдерживания',
  `Time_Delay_Normal` int(10) unsigned DEFAULT NULL COMMENT '356 Нормальная задержка времени',
  `Reliability_Evaluation_Inhibit` tinyint(1) DEFAULT NULL COMMENT '357 Оценка надежности сдерживания',
  `Profile_Name` varchar(256) DEFAULT NULL COMMENT '168 Имя профиля',
  `event_state_tmp` varchar(256) DEFAULT NULL COMMENT '36 Состояние события, в течение интервалов timeDelay, timeDelayNormal',
  `event_timestamps_tmp` text,
  `last_log_value` double DEFAULT NULL COMMENT 'Последнее значение, записанное в log.trendlog',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.


-- Дамп структуры для таблица vbas.objects.analog-output
DROP TABLE IF EXISTS `objects.analog-output`;
CREATE TABLE IF NOT EXISTS `objects.analog-output` (
  `id` int(11) NOT NULL COMMENT 'Сквозной уникальный идентификатор объекта',
  `Present_Value` float DEFAULT NULL COMMENT '85 Текущее значение',
  `Description` varchar(256) DEFAULT NULL COMMENT '28 Описание',
  `Device_Type` varchar(256) DEFAULT NULL COMMENT '31 Тип устройства',
  `Status_Flags` tinyint(4) DEFAULT NULL COMMENT '111 Флаги состояния',
  `Event_State` varchar(256) DEFAULT NULL COMMENT '36 Состояние события',
  `Reliability` varchar(256) DEFAULT NULL COMMENT '103 Освободить по умолчанию',
  `Out_Of_Service` tinyint(1) DEFAULT NULL COMMENT '81 Не работает',
  `Units` varchar(256) DEFAULT NULL COMMENT '117 Единицы',
  `Min_Pres_Value` float DEFAULT NULL COMMENT '69 Мин. значение',
  `Max_Pres_Value` float DEFAULT NULL COMMENT '65 Макс. значение',
  `Resolution` float DEFAULT NULL COMMENT '106 Разрешение',
  `Priority_Array` varchar(256) DEFAULT NULL COMMENT '87 Приоритетный массив',
  `Relinquish_Default` float DEFAULT NULL COMMENT '104 Освободить по умолчанию',
  `COV_Increment` float DEFAULT NULL COMMENT '22 Приращение COV',
  `Time_Delay` int(10) unsigned DEFAULT NULL COMMENT '113 Задержка по времени',
  `Notification_Class` int(10) unsigned DEFAULT NULL COMMENT '17 Класс уведомления',
  `High_Limit` float DEFAULT NULL COMMENT '45 Высокий предел',
  `Low_Limit` float DEFAULT NULL COMMENT '59 Низкий предел',
  `Deadband` float DEFAULT NULL COMMENT '25 Нечувствительность',
  `Limit_Enable` tinyint(4) DEFAULT NULL COMMENT '52 Предел включения',
  `Event_Enable` tinyint(4) DEFAULT NULL COMMENT '35 Событие разрешено',
  `Acked_Transitions` tinyint(4) DEFAULT NULL COMMENT '0 Признаный переход',
  `Notify_Type` enum('alarm','event','ack-notification') DEFAULT NULL COMMENT '72 Тип уведомления',
  `Event_Time_Stamps` text COMMENT '130 Отметки времени событий',
  `Event_Message_Texts` text COMMENT '351 Тексты сообщений о событиях',
  `Event_Message_Texts_Config` text COMMENT '352 Конфигурация текстов сообщений о событиях',
  `Event_Detection_Enable` tinyint(1) DEFAULT NULL COMMENT '353 Включить обнаружение событий',
  `Event_Algorithm_Inhibit_Ref` varchar(256) DEFAULT NULL COMMENT '355 Ссылка события алгоритма сдерживания',
  `Event_Algorithm_Inhibit` tinyint(1) DEFAULT NULL COMMENT '354 События алгоритма сдерживания',
  `Time_Delay_Normal` int(10) unsigned DEFAULT NULL COMMENT '356 Нормальная задержка времени',
  `Reliability_Evaluation_Inhibit` tinyint(1) DEFAULT NULL COMMENT '357 Оценка надежности сдерживания',
  `Profile_Name` varchar(256) DEFAULT NULL COMMENT '168 Имя профиля',
  `event_state_tmp` varchar(256) DEFAULT NULL COMMENT '36 Состояние события, в течение интервалов timeDelay, timeDelayNormal',
  `event_timestamps_tmp` text,
  `last_log_value` double DEFAULT NULL COMMENT 'Последнее значение, записанное в log.trendlog',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.


-- Дамп структуры для таблица vbas.objects.analog-value
DROP TABLE IF EXISTS `objects.analog-value`;
CREATE TABLE IF NOT EXISTS `objects.analog-value` (
  `id` int(11) NOT NULL COMMENT 'Сквозной уникальный идентификатор объекта',
  `Present_Value` float DEFAULT NULL COMMENT '85 Текущее значение',
  `Description` varchar(256) DEFAULT NULL COMMENT '28 Описание',
  `Status_Flags` tinyint(4) DEFAULT NULL COMMENT '111 Флаги состояния',
  `Event_State` varchar(256) DEFAULT NULL COMMENT '36 Состояние события',
  `Reliability` varchar(256) DEFAULT NULL COMMENT '103 Освободить по умолчанию',
  `Out_Of_Service` tinyint(1) DEFAULT NULL COMMENT '81 Не работает',
  `Units` varchar(256) DEFAULT NULL COMMENT '117 Единицы',
  `Priority_Array` varchar(256) DEFAULT NULL COMMENT '87 Приоритетный массив',
  `Relinquish_Default` float DEFAULT NULL COMMENT '104 Освободить по умолчанию',
  `COV_Increment` float DEFAULT NULL COMMENT '22 Приращение COV',
  `Time_Delay` int(10) unsigned DEFAULT NULL COMMENT '113 Задержка по времени',
  `Notification_Class` int(10) unsigned DEFAULT NULL COMMENT '17 Класс уведомления',
  `High_Limit` float DEFAULT NULL COMMENT '45 Высокий предел',
  `Low_Limit` float DEFAULT NULL COMMENT '59 Низкий предел',
  `Deadband` float DEFAULT NULL COMMENT '25 Нечувствительность',
  `Limit_Enable` tinyint(4) DEFAULT NULL COMMENT '52 Предел включения',
  `Event_Enable` tinyint(4) DEFAULT NULL COMMENT '35 Событие разрешено',
  `Acked_Transitions` tinyint(4) DEFAULT NULL COMMENT '0 Признаный переход',
  `Notify_Type` enum('alarm','event','ack-notification') DEFAULT NULL COMMENT '72 Тип уведомления',
  `Event_Time_Stamps` text COMMENT '130 Отметки времени событий',
  `Event_Message_Texts` text COMMENT '351 Тексты сообщений о событиях',
  `Event_Message_Texts_Config` text COMMENT '352 Конфигурация текстов сообщений о событиях',
  `Event_Detection_Enable` tinyint(1) DEFAULT NULL COMMENT '353 Включить обнаружение событий',
  `Event_Algorithm_Inhibit_Ref` varchar(256) DEFAULT NULL COMMENT '355 Ссылка события алгоритма сдерживания',
  `Event_Algorithm_Inhibit` tinyint(1) DEFAULT NULL COMMENT '354 События алгоритма сдерживания',
  `Time_Delay_Normal` int(10) unsigned DEFAULT NULL COMMENT '356 Нормальная задержка времени',
  `Reliability_Evaluation_Inhibit` tinyint(1) DEFAULT NULL COMMENT '357 Оценка надежности сдерживания',
  `Min_Pres_Value` float DEFAULT NULL COMMENT '69 Мин. значение',
  `Max_Pres_Value` float DEFAULT NULL COMMENT '65 Макс. значение',
  `Resolution` float DEFAULT NULL COMMENT '106 Разрешение',
  `Profile_Name` varchar(256) DEFAULT NULL COMMENT '168 Имя профиля',
  `event_state_tmp` varchar(256) DEFAULT NULL COMMENT '36 Состояние события, в течение интервалов timeDelay, timeDelayNormal',
  `event_timestamps_tmp` text,
  `last_log_value` double DEFAULT NULL COMMENT 'Последнее значение, записанное в log.trendlog',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.


-- Дамп структуры для таблица vbas.objects.averaging
DROP TABLE IF EXISTS `objects.averaging`;
CREATE TABLE IF NOT EXISTS `objects.averaging` (
  `id` int(11) NOT NULL COMMENT 'Сквозной уникальный идентификатор объекта',
  `Minimum_Value` float DEFAULT NULL COMMENT '136 Минимальное значение',
  `Minimum_Value_Timestamp` datetime(3) DEFAULT NULL COMMENT '150 Минимальное значение временной метки',
  `Average_Value` float DEFAULT NULL COMMENT '125 Среднее значение',
  `Variance_Value` float DEFAULT NULL COMMENT '151 Значение варианта',
  `Maximum_Value` float DEFAULT NULL COMMENT '135 Максимальное значение',
  `Maximum_Value_Timestamp` datetime(3) DEFAULT NULL COMMENT '149 Максимальное значение временной метки',
  `Description` varchar(256) DEFAULT NULL COMMENT '28 Описание',
  `Attempted_Samples` int(10) unsigned DEFAULT NULL COMMENT '124 Испробованые шаблоны',
  `Valid_Samples` int(10) unsigned DEFAULT NULL COMMENT '146 Допустимый образец',
  `Object_Property_Reference` varchar(256) DEFAULT NULL COMMENT '78 Ссылка на свойство объекта',
  `Window_Interval` int(10) unsigned DEFAULT NULL COMMENT '147 Интервал окна',
  `Window_Samples` int(10) unsigned DEFAULT NULL COMMENT '148 Примеры окна',
  `Profile_Name` varchar(256) DEFAULT NULL COMMENT '168 Имя профиля',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.


-- Дамп структуры для таблица vbas.objects.bacnet-destination
DROP TABLE IF EXISTS `objects.bacnet-destination`;
CREATE TABLE IF NOT EXISTS `objects.bacnet-destination` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Сквозной уникальный идентификатор объекта',
  `recipient` varchar(256) DEFAULT NULL COMMENT 'Имя группы',
  `transitions` tinyint(4) DEFAULT NULL COMMENT 'three bits {TO_OFFNORMAL, TO_FAULT, TO_NORMAL}',
  `notification_class_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  KEY `fk_notification_class_idx` (`notification_class_id`),
  CONSTRAINT `objects.bacnet-destination_ibfk_1` FOREIGN KEY (`notification_class_id`) REFERENCES `objects.notification-class` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.


-- Дамп структуры для таблица vbas.objects.binary-input
DROP TABLE IF EXISTS `objects.binary-input`;
CREATE TABLE IF NOT EXISTS `objects.binary-input` (
  `id` int(11) NOT NULL COMMENT 'Сквозной уникальный идентификатор объекта',
  `Present_Value` enum('inactive','active') DEFAULT NULL COMMENT '85 Текущее значение',
  `Description` varchar(256) DEFAULT NULL COMMENT '28 Описание',
  `Device_Type` varchar(256) DEFAULT NULL COMMENT '31 Тип устройства',
  `Status_Flags` tinyint(4) DEFAULT NULL COMMENT '111 Флаги состояния',
  `Event_State` varchar(256) DEFAULT NULL COMMENT '36 Состояние события',
  `event_state_tmp` varchar(256) DEFAULT NULL COMMENT '36 Состояние события, в течение интервалов timeDelay, timeDelayNormal',
  `Reliability` varchar(256) DEFAULT NULL COMMENT '103 Освободить по умолчанию',
  `Out_Of_Service` tinyint(1) DEFAULT NULL COMMENT '81 Не работает',
  `Polarity` enum('normal','reverse') DEFAULT NULL COMMENT '84 Полярность',
  `Inactive_Text` varchar(256) DEFAULT 'OFF' COMMENT '46 Неактивный текст',
  `Active_Text` varchar(256) DEFAULT 'ON' COMMENT '4 Активный текст',
  `Change_Of_State_Time` datetime(3) DEFAULT NULL COMMENT '16 Время COS',
  `Change_Of_State_Count` int(10) unsigned DEFAULT NULL COMMENT '15 Число COS',
  `Time_Of_State_Count_Reset` datetime(3) DEFAULT NULL COMMENT '115 Сброс числа состояний',
  `Elapsed_Active_Time` int(10) unsigned DEFAULT NULL COMMENT '33 Затраченное активное время',
  `Time_Of_Active_Time_Reset` datetime(3) DEFAULT NULL COMMENT '114 Сброс активного времени',
  `Time_Delay` int(10) unsigned DEFAULT NULL COMMENT '113 Задержка по времени',
  `Notification_Class` int(10) unsigned DEFAULT NULL COMMENT '17 Класс уведомления',
  `Alarm_Value` enum('inactive','active') DEFAULT NULL COMMENT '6 Сигнальное значение',
  `Event_Enable` tinyint(4) DEFAULT NULL COMMENT '35 Событие разрешено',
  `Acked_Transitions` tinyint(4) DEFAULT NULL COMMENT '0 Признаный переход',
  `Notify_Type` enum('alarm','event','ack-notification') DEFAULT NULL COMMENT '72 Тип уведомления',
  `Event_Time_Stamps` text COMMENT '130 Отметки времени событий',
  `Event_Message_Texts` text COMMENT '351 Тексты сообщений о событиях',
  `Event_Message_Texts_Config` text COMMENT '352 Конфигурация текстов сообщений о событиях',
  `Event_Detection_Enable` tinyint(1) DEFAULT NULL COMMENT '353 Включить обнаружение событий',
  `Event_Algorithm_Inhibit_Ref` varchar(256) DEFAULT NULL COMMENT '355 Ссылка события алгоритма сдерживания',
  `Event_Algorithm_Inhibit` tinyint(1) DEFAULT NULL COMMENT '354 События алгоритма сдерживания',
  `Time_Delay_Normal` int(10) unsigned DEFAULT NULL COMMENT '356 Нормальная задержка времени',
  `Reliability_Evaluation_Inhibit` tinyint(1) DEFAULT NULL COMMENT '357 Оценка надежности сдерживания',
  `Profile_Name` varchar(256) DEFAULT NULL COMMENT '168 Имя профиля',
  `event_timestamps_tmp` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.


-- Дамп структуры для таблица vbas.objects.binary-output
DROP TABLE IF EXISTS `objects.binary-output`;
CREATE TABLE IF NOT EXISTS `objects.binary-output` (
  `id` int(11) NOT NULL COMMENT 'Сквозной уникальный идентификатор объекта',
  `Present_Value` enum('inactive','active') DEFAULT NULL COMMENT '85 Текущее значение',
  `Description` varchar(256) DEFAULT NULL COMMENT '28 Описание',
  `Device_Type` varchar(256) DEFAULT NULL COMMENT '31 Тип устройства',
  `Status_Flags` tinyint(4) DEFAULT NULL COMMENT '111 Флаги состояния',
  `Event_State` varchar(256) DEFAULT NULL COMMENT '36 Состояние события',
  `Reliability` varchar(256) DEFAULT NULL COMMENT '103 Освободить по умолчанию',
  `Out_Of_Service` tinyint(1) DEFAULT NULL COMMENT '81 Не работает',
  `Polarity` enum('normal','reverse') DEFAULT NULL COMMENT '84 Полярность',
  `Inactive_Text` varchar(256) DEFAULT 'OFF' COMMENT '46 Неактивный текст',
  `Active_Text` varchar(256) DEFAULT 'ON' COMMENT '4 Активный текст',
  `Change_Of_State_Time` datetime(3) DEFAULT NULL COMMENT '16 Время COS',
  `Change_Of_State_Count` int(10) unsigned DEFAULT NULL COMMENT '15 Число COS',
  `Time_Of_State_Count_Reset` datetime(3) DEFAULT NULL COMMENT '115 Сброс числа состояний',
  `Elapsed_Active_Time` int(10) unsigned DEFAULT NULL COMMENT '33 Затраченное активное время',
  `Time_Of_Active_Time_Reset` datetime(3) DEFAULT NULL COMMENT '114 Сброс активного времени',
  `Minimum_Off_Time` int(10) unsigned DEFAULT NULL COMMENT '66 Минимально выключенное время',
  `Minimum_On_Time` int(10) unsigned DEFAULT NULL COMMENT '67 Минимальное включеное время',
  `Priority_Array` varchar(256) DEFAULT NULL COMMENT '87 Приоритетный массив',
  `Relinquish_Default` enum('inactive','active') DEFAULT NULL COMMENT '104 Освободить по умолчанию',
  `Time_Delay` int(10) unsigned DEFAULT NULL COMMENT '113 Задержка по времени',
  `Notification_Class` int(10) unsigned DEFAULT NULL COMMENT '17 Класс уведомления',
  `Feedback_Value` enum('inactive','active') DEFAULT NULL COMMENT '40 Значение обратной связи',
  `Event_Enable` tinyint(4) DEFAULT NULL COMMENT '35 Событие разрешено',
  `Acked_Transitions` tinyint(4) DEFAULT NULL COMMENT '0 Признаный переход',
  `Notify_Type` enum('alarm','event','ack-notification') DEFAULT NULL COMMENT '72 Тип уведомления',
  `Event_Time_Stamps` text COMMENT '130 Отметки времени событий',
  `Event_Message_Texts` text COMMENT '351 Тексты сообщений о событиях',
  `Event_Message_Texts_Config` text COMMENT '352 Конфигурация текстов сообщений о событиях',
  `Event_Detection_Enable` tinyint(1) DEFAULT NULL COMMENT '353 Включить обнаружение событий',
  `Event_Algorithm_Inhibit_Ref` varchar(256) DEFAULT NULL COMMENT '355 Ссылка события алгоритма сдерживания',
  `Event_Algorithm_Inhibit` tinyint(1) DEFAULT NULL COMMENT '354 События алгоритма сдерживания',
  `Time_Delay_Normal` int(10) unsigned DEFAULT NULL COMMENT '356 Нормальная задержка времени',
  `Reliability_Evaluation_Inhibit` tinyint(1) DEFAULT NULL COMMENT '357 Оценка надежности сдерживания',
  `Profile_Name` varchar(256) DEFAULT NULL COMMENT '168 Имя профиля',
  `event_state_tmp` varchar(256) DEFAULT NULL COMMENT '36 Состояние события, в течение интервалов timeDelay, timeDelayNormal',
  `event_timestamps_tmp` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.


-- Дамп структуры для таблица vbas.objects.binary-value
DROP TABLE IF EXISTS `objects.binary-value`;
CREATE TABLE IF NOT EXISTS `objects.binary-value` (
  `id` int(11) NOT NULL COMMENT 'Сквозной уникальный идентификатор объекта',
  `Present_Value` enum('inactive','active') DEFAULT NULL COMMENT '85 Текущее значение',
  `Description` varchar(256) DEFAULT NULL COMMENT '28 Описание',
  `Status_Flags` tinyint(4) DEFAULT NULL COMMENT '111 Флаги состояния',
  `Event_State` varchar(256) DEFAULT NULL COMMENT '36 Состояние события',
  `event_state_tmp` varchar(256) DEFAULT NULL COMMENT '36 Состояние события, в течение интервалов timeDelay, timeDelayNormal',
  `Reliability` varchar(256) DEFAULT NULL COMMENT '103 Освободить по умолчанию',
  `Out_Of_Service` tinyint(1) DEFAULT NULL COMMENT '81 Не работает',
  `Inactive_Text` varchar(256) DEFAULT 'OFF' COMMENT '46 Неактивный текст',
  `Active_Text` varchar(256) DEFAULT 'ON' COMMENT '4 Активный текст',
  `Change_Of_State_Time` datetime(3) DEFAULT NULL COMMENT '16 Время COS',
  `Change_Of_State_Count` int(10) unsigned DEFAULT NULL COMMENT '15 Число COS',
  `Time_Of_State_Count_Reset` datetime(3) DEFAULT NULL COMMENT '115 Сброс числа состояний',
  `Elapsed_Active_Time` int(10) unsigned DEFAULT NULL COMMENT '33 Затраченное активное время',
  `Time_Of_Active_Time_Reset` datetime(3) DEFAULT NULL COMMENT '114 Сброс активного времени',
  `Minimum_Off_Time` int(10) unsigned DEFAULT NULL COMMENT '66 Минимально выключенное время',
  `Minimum_On_Time` int(10) unsigned DEFAULT NULL COMMENT '67 Минимальное включеное время',
  `Priority_Array` varchar(256) DEFAULT NULL COMMENT '87 Приоритетный массив',
  `Relinquish_Default` enum('inactive','active') DEFAULT NULL COMMENT '104 Освободить по умолчанию',
  `Time_Delay` int(10) unsigned DEFAULT NULL COMMENT '113 Задержка по времени',
  `Notification_Class` int(10) unsigned DEFAULT NULL COMMENT '17 Класс уведомления',
  `Alarm_Value` enum('inactive','active') DEFAULT NULL COMMENT '6 Сигнальное значение',
  `Event_Enable` tinyint(4) DEFAULT NULL COMMENT '35 Событие разрешено',
  `Acked_Transitions` tinyint(4) DEFAULT NULL COMMENT '0 Признаный переход',
  `Notify_Type` enum('alarm','event','ack-notification') DEFAULT NULL COMMENT '72 Тип уведомления',
  `Event_Time_Stamps` text COMMENT '130 Отметки времени событий',
  `Event_Message_Texts` text COMMENT '351 Тексты сообщений о событиях',
  `Event_Message_Texts_Config` text COMMENT '352 Конфигурация текстов сообщений о событиях',
  `Event_Detection_Enable` tinyint(1) DEFAULT NULL COMMENT '353 Включить обнаружение событий',
  `Event_Algorithm_Inhibit_Ref` varchar(256) DEFAULT NULL COMMENT '355 Ссылка события алгоритма сдерживания',
  `Event_Algorithm_Inhibit` tinyint(1) DEFAULT NULL COMMENT '354 События алгоритма сдерживания',
  `Time_Delay_Normal` int(10) unsigned DEFAULT NULL COMMENT '356 Нормальная задержка времени',
  `Reliability_Evaluation_Inhibit` tinyint(1) DEFAULT NULL COMMENT '357 Оценка надежности сдерживания',
  `Profile_Name` varchar(256) DEFAULT NULL COMMENT '168 Имя профиля',
  `event_timestamps_tmp` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.


-- Дамп структуры для таблица vbas.objects.bitstring-value
DROP TABLE IF EXISTS `objects.bitstring-value`;
CREATE TABLE IF NOT EXISTS `objects.bitstring-value` (
  `id` int(11) NOT NULL COMMENT 'Сквозной уникальный идентификатор объекта',
  `Description` varchar(256) DEFAULT NULL COMMENT '28 Описание',
  `Present_Value` bit(12) DEFAULT NULL COMMENT '85 Текущее значение',
  `Bit_Text` text COMMENT '343 Битовый текст',
  `Status_Flags` tinyint(4) DEFAULT NULL COMMENT '111 Флаги состояния',
  `Event_State` varchar(256) DEFAULT NULL COMMENT '36 Состояние события',
  `Reliability` varchar(256) DEFAULT NULL COMMENT '103 Освободить по умолчанию',
  `Out_Of_Service` tinyint(1) DEFAULT NULL COMMENT '81 Не работает',
  `Priority_Array` varchar(256) DEFAULT NULL COMMENT '87 Приоритетный массив',
  `Relinquish_Default` mediumint(9) DEFAULT NULL COMMENT '104 Освободить по умолчанию',
  `Time_Delay` int(10) unsigned DEFAULT NULL COMMENT '113 Задержка по времени',
  `Notification_Class` int(10) unsigned DEFAULT NULL COMMENT '17 Класс уведомления',
  `Alarm_Values` text COMMENT '7 Сигнальные значения',
  `Bit_Mask` bit(12) DEFAULT NULL COMMENT '342 Маска бита',
  `Event_Enable` tinyint(4) DEFAULT NULL COMMENT '35 Событие разрешено',
  `Acked_Transitions` tinyint(4) DEFAULT NULL COMMENT '0 Признаный переход',
  `Notify_Type` enum('alarm','event','ack-notification') DEFAULT NULL COMMENT '72 Тип уведомления',
  `Event_Time_Stamps` text COMMENT '130 Отметки времени событий',
  `Event_Message_Texts` text COMMENT '351 Тексты сообщений о событиях',
  `Event_Message_Texts_Config` text COMMENT '352 Конфигурация текстов сообщений о событиях',
  `Event_Detection_Enable` tinyint(1) DEFAULT NULL COMMENT '353 Включить обнаружение событий',
  `Event_Algorithm_Inhibit_Ref` varchar(256) DEFAULT NULL COMMENT '355 Ссылка события алгоритма сдерживания',
  `Event_Algorithm_Inhibit` tinyint(1) DEFAULT NULL COMMENT '354 События алгоритма сдерживания',
  `Time_Delay_Normal` int(10) unsigned DEFAULT NULL COMMENT '356 Нормальная задержка времени',
  `Reliability_Evaluation_Inhibit` tinyint(1) DEFAULT NULL COMMENT '357 Оценка надежности сдерживания',
  `Profile_Name` varchar(256) DEFAULT NULL COMMENT '168 Имя профиля',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.


-- Дамп структуры для таблица vbas.objects.calendar
DROP TABLE IF EXISTS `objects.calendar`;
CREATE TABLE IF NOT EXISTS `objects.calendar` (
  `id` int(11) NOT NULL COMMENT 'Сквозной уникальный идентификатор объекта',
  `Description` varchar(256) DEFAULT NULL COMMENT '28 Описание',
  `Present_Value` tinyint(1) DEFAULT NULL COMMENT '85 Текущее значение',
  `Date_List` int(10) unsigned DEFAULT NULL COMMENT '23 Список дат',
  `Profile_Name` varchar(256) DEFAULT NULL COMMENT '168 Имя профиля',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.


-- Дамп структуры для таблица vbas.objects.channel
DROP TABLE IF EXISTS `objects.channel`;
CREATE TABLE IF NOT EXISTS `objects.channel` (
  `id` int(11) NOT NULL COMMENT 'Сквозной уникальный идентификатор объекта',
  `Description` varchar(256) DEFAULT NULL COMMENT '28 Описание',
  `Present_Value` varchar(256) DEFAULT NULL COMMENT '85 Текущее значение',
  `Last_Priority` int(10) unsigned DEFAULT NULL COMMENT '369 Последний приоритет',
  `Write_Status` enum('idle','in-progress','successful','failed') DEFAULT NULL COMMENT '370 Статус записи',
  `Status_Flags` tinyint(4) DEFAULT NULL COMMENT '111 Флаги состояния',
  `Reliability` varchar(256) DEFAULT NULL COMMENT '103 Освободить по умолчанию',
  `Out_Of_Service` tinyint(1) DEFAULT NULL COMMENT '81 Не работает',
  `List_Of_Object_Property_References` text COMMENT '54 Список ссылок свойств объекта',
  `Execution_Delay` text COMMENT '368 Задержка запуска',
  `Allow_Group_Delay_Inhibit` tinyint(1) DEFAULT NULL COMMENT '365 Допуск групп задержки сдерживания',
  `Channel_Number` int(11) DEFAULT NULL COMMENT '366 Номер канала',
  `Control_Groups` text COMMENT '367 Управляемые группы',
  `Event_Detection_Enable` tinyint(1) DEFAULT NULL COMMENT '353 Включить обнаружение событий',
  `Notification_Class` int(10) unsigned DEFAULT NULL COMMENT '17 Класс уведомления',
  `Event_Enable` tinyint(4) DEFAULT NULL COMMENT '35 Событие разрешено',
  `Event_State` varchar(256) DEFAULT NULL COMMENT '36 Состояние события',
  `Acked_Transitions` tinyint(4) DEFAULT NULL COMMENT '0 Признаный переход',
  `Notify_Type` enum('alarm','event','ack-notification') DEFAULT NULL COMMENT '72 Тип уведомления',
  `Event_Time_Stamps` text COMMENT '130 Отметки времени событий',
  `Event_Message_Texts` text COMMENT '351 Тексты сообщений о событиях',
  `Event_Message_Texts_Config` text COMMENT '352 Конфигурация текстов сообщений о событиях',
  `Reliability_Evaluation_Inhibit` tinyint(1) DEFAULT NULL COMMENT '357 Оценка надежности сдерживания',
  `Profile_Name` varchar(256) DEFAULT NULL COMMENT '168 Имя профиля',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.


-- Дамп структуры для таблица vbas.objects.characterstring-value
DROP TABLE IF EXISTS `objects.characterstring-value`;
CREATE TABLE IF NOT EXISTS `objects.characterstring-value` (
  `id` int(11) NOT NULL COMMENT 'Сквозной уникальный идентификатор объекта',
  `Description` varchar(256) DEFAULT NULL COMMENT '28 Описание',
  `Present_Value` varchar(256) DEFAULT NULL COMMENT '85 Текущее значение',
  `Status_Flags` tinyint(4) DEFAULT NULL COMMENT '111 Флаги состояния',
  `Event_State` varchar(256) DEFAULT NULL COMMENT '36 Состояние события',
  `Reliability` varchar(256) DEFAULT NULL COMMENT '103 Освободить по умолчанию',
  `Out_Of_Service` tinyint(1) DEFAULT NULL COMMENT '81 Не работает',
  `Priority_Array` varchar(256) DEFAULT NULL COMMENT '87 Приоритетный массив',
  `Relinquish_Default` varchar(256) DEFAULT NULL COMMENT '104 Освободить по умолчанию',
  `Time_Delay` int(10) unsigned DEFAULT NULL COMMENT '113 Задержка по времени',
  `Notification_Class` int(10) unsigned DEFAULT NULL COMMENT '17 Класс уведомления',
  `Alarm_Values` text COMMENT '7 Сигнальные значения',
  `Fault_Values` text COMMENT '39 Значений ошибки',
  `Event_Enable` tinyint(4) DEFAULT NULL COMMENT '35 Событие разрешено',
  `Acked_Transitions` tinyint(4) DEFAULT NULL COMMENT '0 Признаный переход',
  `Notify_Type` enum('alarm','event','ack-notification') DEFAULT NULL COMMENT '72 Тип уведомления',
  `Event_Time_Stamps` text COMMENT '130 Отметки времени событий',
  `Event_Message_Texts` text COMMENT '351 Тексты сообщений о событиях',
  `Event_Message_Texts_Config` text COMMENT '352 Конфигурация текстов сообщений о событиях',
  `Event_Detection_Enable` tinyint(1) DEFAULT NULL COMMENT '353 Включить обнаружение событий',
  `Event_Algorithm_Inhibit_Ref` varchar(256) DEFAULT NULL COMMENT '355 Ссылка события алгоритма сдерживания',
  `Event_Algorithm_Inhibit` tinyint(1) DEFAULT NULL COMMENT '354 События алгоритма сдерживания',
  `Time_Delay_Normal` int(10) unsigned DEFAULT NULL COMMENT '356 Нормальная задержка времени',
  `Reliability_Evaluation_Inhibit` tinyint(1) DEFAULT NULL COMMENT '357 Оценка надежности сдерживания',
  `Profile_Name` varchar(256) DEFAULT NULL COMMENT '168 Имя профиля',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.


-- Дамп структуры для таблица vbas.objects.command
DROP TABLE IF EXISTS `objects.command`;
CREATE TABLE IF NOT EXISTS `objects.command` (
  `id` int(11) NOT NULL COMMENT 'Сквозной уникальный идентификатор объекта',
  `Description` varchar(256) DEFAULT NULL COMMENT '28 Описание',
  `Present_Value` int(10) unsigned DEFAULT NULL COMMENT '85 Текущее значение',
  `In_Process` tinyint(1) DEFAULT NULL COMMENT '47 Выполняется',
  `All_Writes_Successful` tinyint(1) DEFAULT NULL COMMENT '9 Успешные операции записи',
  `Action` text COMMENT '2 Действие',
  `Action_Text` text COMMENT '2 Действие_TEXT',
  `Profile_Name` varchar(256) DEFAULT NULL COMMENT '168 Имя профиля',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.


-- Дамп структуры для таблица vbas.objects.credential-data-input
DROP TABLE IF EXISTS `objects.credential-data-input`;
CREATE TABLE IF NOT EXISTS `objects.credential-data-input` (
  `id` int(11) NOT NULL COMMENT 'Сквозной уникальный идентификатор объекта',
  `Present_Value` varchar(256) DEFAULT NULL COMMENT '85 Текущее значение',
  `Description` varchar(256) DEFAULT NULL COMMENT '28 Описание',
  `Status_Flags` tinyint(4) DEFAULT NULL COMMENT '111 Флаги состояния',
  `Reliability` varchar(256) DEFAULT NULL COMMENT '103 Освободить по умолчанию',
  `Out_Of_Service` tinyint(1) DEFAULT NULL COMMENT '81 Не работает',
  `Supported_Formats` text COMMENT '304 Поддерживаемые форматы',
  `Supported_Format_Classes` text COMMENT '305 Классы поддерживаемых форматов',
  `Update_Time` varchar(256) DEFAULT NULL COMMENT '189 Время обновления',
  `Event_Detection_Enable` tinyint(1) DEFAULT NULL COMMENT '353 Включить обнаружение событий',
  `Notification_Class` int(10) unsigned DEFAULT NULL COMMENT '17 Класс уведомления',
  `Event_Enable` tinyint(4) DEFAULT NULL COMMENT '35 Событие разрешено',
  `Event_State` varchar(256) DEFAULT NULL COMMENT '36 Состояние события',
  `Acked_Transitions` tinyint(4) DEFAULT NULL COMMENT '0 Признаный переход',
  `Notify_Type` enum('alarm','event','ack-notification') DEFAULT NULL COMMENT '72 Тип уведомления',
  `Event_Time_Stamps` text COMMENT '130 Отметки времени событий',
  `Event_Message_Texts` text COMMENT '351 Тексты сообщений о событиях',
  `Event_Message_Texts_Config` text COMMENT '352 Конфигурация текстов сообщений о событиях',
  `Reliability_Evaluation_Inhibit` tinyint(1) DEFAULT NULL COMMENT '357 Оценка надежности сдерживания',
  `Profile_Name` varchar(256) DEFAULT NULL COMMENT '168 Имя профиля',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.


-- Дамп структуры для таблица vbas.objects.date-pattern-value
DROP TABLE IF EXISTS `objects.date-pattern-value`;
CREATE TABLE IF NOT EXISTS `objects.date-pattern-value` (
  `id` int(11) NOT NULL COMMENT 'Сквозной уникальный идентификатор объекта',
  `Description` varchar(256) DEFAULT NULL COMMENT '28 Описание',
  `Present_Value` date DEFAULT NULL COMMENT '85 Текущее значение',
  `Status_Flags` tinyint(4) DEFAULT NULL COMMENT '111 Флаги состояния',
  `Event_State` varchar(256) DEFAULT NULL COMMENT '36 Состояние события',
  `Reliability` varchar(256) DEFAULT NULL COMMENT '103 Освободить по умолчанию',
  `Out_Of_Service` tinyint(1) DEFAULT NULL COMMENT '81 Не работает',
  `Priority_Array` varchar(256) DEFAULT NULL COMMENT '87 Приоритетный массив',
  `Relinquish_Default` date DEFAULT NULL COMMENT '104 Освободить по умолчанию',
  `Reliability_Evaluation_Inhibit` tinyint(1) DEFAULT NULL COMMENT '357 Оценка надежности сдерживания',
  `Profile_Name` varchar(256) DEFAULT NULL COMMENT '168 Имя профиля',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.


-- Дамп структуры для таблица vbas.objects.date-value
DROP TABLE IF EXISTS `objects.date-value`;
CREATE TABLE IF NOT EXISTS `objects.date-value` (
  `id` int(11) NOT NULL COMMENT 'Сквозной уникальный идентификатор объекта',
  `Description` varchar(256) DEFAULT NULL COMMENT '28 Описание',
  `Present_Value` date DEFAULT NULL COMMENT '85 Текущее значение',
  `Status_Flags` tinyint(4) DEFAULT NULL COMMENT '111 Флаги состояния',
  `Event_State` varchar(256) DEFAULT NULL COMMENT '36 Состояние события',
  `Reliability` varchar(256) DEFAULT NULL COMMENT '103 Освободить по умолчанию',
  `Out_Of_Service` tinyint(1) DEFAULT NULL COMMENT '81 Не работает',
  `Priority_Array` varchar(256) DEFAULT NULL COMMENT '87 Приоритетный массив',
  `Relinquish_Default` date DEFAULT NULL COMMENT '104 Освободить по умолчанию',
  `Reliability_Evaluation_Inhibit` tinyint(1) DEFAULT NULL COMMENT '357 Оценка надежности сдерживания',
  `Profile_Name` varchar(256) DEFAULT NULL COMMENT '168 Имя профиля',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.


-- Дамп структуры для таблица vbas.objects.datetime-pattern-value
DROP TABLE IF EXISTS `objects.datetime-pattern-value`;
CREATE TABLE IF NOT EXISTS `objects.datetime-pattern-value` (
  `id` int(11) NOT NULL COMMENT 'Сквозной уникальный идентификатор объекта',
  `Description` varchar(256) DEFAULT NULL COMMENT '28 Описание',
  `Present_Value` datetime(3) DEFAULT NULL COMMENT '85 Текущее значение',
  `Status_Flags` tinyint(4) DEFAULT NULL COMMENT '111 Флаги состояния',
  `Event_State` varchar(256) DEFAULT NULL COMMENT '36 Состояние события',
  `Reliability` varchar(256) DEFAULT NULL COMMENT '103 Освободить по умолчанию',
  `Out_Of_Service` tinyint(1) DEFAULT NULL COMMENT '81 Не работает',
  `Is_UTC` tinyint(1) DEFAULT NULL COMMENT '344 Время UTC',
  `Priority_Array` varchar(256) DEFAULT NULL COMMENT '87 Приоритетный массив',
  `Relinquish_Default` datetime(3) DEFAULT NULL COMMENT '104 Освободить по умолчанию',
  `Reliability_Evaluation_Inhibit` tinyint(1) DEFAULT NULL COMMENT '357 Оценка надежности сдерживания',
  `Profile_Name` varchar(256) DEFAULT NULL COMMENT '168 Имя профиля',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.


-- Дамп структуры для таблица vbas.objects.datetime-value
DROP TABLE IF EXISTS `objects.datetime-value`;
CREATE TABLE IF NOT EXISTS `objects.datetime-value` (
  `id` int(11) NOT NULL COMMENT 'Сквозной уникальный идентификатор объекта',
  `Description` varchar(256) DEFAULT NULL COMMENT '28 Описание',
  `Present_Value` datetime(3) DEFAULT NULL COMMENT '85 Текущее значение',
  `Status_Flags` tinyint(4) DEFAULT NULL COMMENT '111 Флаги состояния',
  `Event_State` varchar(256) DEFAULT NULL COMMENT '36 Состояние события',
  `Reliability` varchar(256) DEFAULT NULL COMMENT '103 Освободить по умолчанию',
  `Out_Of_Service` tinyint(1) DEFAULT NULL COMMENT '81 Не работает',
  `Priority_Array` varchar(256) DEFAULT NULL COMMENT '87 Приоритетный массив',
  `Relinquish_Default` datetime(3) DEFAULT NULL COMMENT '104 Освободить по умолчанию',
  `Is_UTC` tinyint(1) DEFAULT NULL COMMENT '344 Время UTC',
  `Reliability_Evaluation_Inhibit` tinyint(1) DEFAULT NULL COMMENT '357 Оценка надежности сдерживания',
  `Profile_Name` varchar(256) DEFAULT NULL COMMENT '168 Имя профиля',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.


-- Дамп структуры для таблица vbas.objects.device
DROP TABLE IF EXISTS `objects.device`;
CREATE TABLE IF NOT EXISTS `objects.device` (
  `id` int(11) NOT NULL COMMENT 'Сквозной уникальный идентификатор объекта',
  `System_Status` varchar(256) DEFAULT NULL COMMENT '112 Состояние системы',
  `Vendor_Name` varchar(256) DEFAULT NULL COMMENT '121 Название поставщика',
  `Vendor_Identifier` int(10) unsigned DEFAULT NULL COMMENT '120 Идентификатор поставщика',
  `Model_Name` varchar(256) DEFAULT NULL COMMENT '70 Имя модели',
  `Firmware_Revision` varchar(256) DEFAULT NULL COMMENT '44 Вариант микропрограммы',
  `Application_Software_Version` varchar(256) DEFAULT NULL COMMENT '12 Версия приложения',
  `Location` varchar(256) DEFAULT NULL COMMENT '58 Местоположение',
  `Description` varchar(256) DEFAULT NULL COMMENT '28 Описание',
  `Protocol_Version` int(10) unsigned DEFAULT NULL COMMENT '98 Протокол версий',
  `Protocol_Revision` int(10) unsigned DEFAULT NULL COMMENT '139 Изменения протокола',
  `Protocol_Services_Supported` text COMMENT '97 Протокол предоставляемых сервисов',
  `Protocol_Object_Types_Supported` text COMMENT '96 Протокол поддерживаемый типов объекта',
  `Object_List` text COMMENT '76 Список объектов',
  `Structured_Object_List` text COMMENT '209 Структурированый список объекта',
  `Max_APDU_Length_Accepted` int(10) unsigned DEFAULT NULL COMMENT '62 Максимально допускаемая длина APDU',
  `Segmentation_Supported` enum('segmented-both','segmented-transmit','segmented-receive','no-segmentation') DEFAULT NULL COMMENT '107 Поддерживается сегментация',
  `Max_Segments_Accepted` int(10) unsigned DEFAULT NULL COMMENT '167 Максимальное количество принятых сегментов',
  `VT_Classes_Supported` int(10) unsigned DEFAULT NULL COMMENT '122 Класс поддерживаемого VT',
  `Active_VT_Sessions` int(10) unsigned DEFAULT NULL COMMENT '5 Активные VT сесии',
  `Local_Time` time DEFAULT NULL COMMENT '57 Местное время',
  `Local_Date` date DEFAULT NULL COMMENT '56 Местная дата',
  `UTC_Offset` int(11) DEFAULT NULL COMMENT '119 Смещение UTC',
  `Daylight_Savings_Status` tinyint(1) DEFAULT NULL COMMENT '24 Статус летнего времени',
  `APDU_Segment_Timeout` int(10) unsigned DEFAULT NULL COMMENT '10 Тайм-аут сегмента APDU',
  `APDU_Timeout` int(10) unsigned DEFAULT NULL COMMENT '11 Тайм-аут APDU',
  `Number_Of_APDU_Retries` int(10) unsigned DEFAULT NULL COMMENT '73 Число повторов APDU',
  `Time_Synchronization_Recipients` int(10) unsigned DEFAULT NULL COMMENT '116 Время синхронизации получателей',
  `Max_Master` int(11) DEFAULT NULL COMMENT '64 Макс. для главного',
  `Max_Info_Frames` int(10) unsigned DEFAULT NULL COMMENT '63 Макс. инф. кадров',
  `Device_Address_Binding` int(10) unsigned DEFAULT NULL COMMENT '30 Адрес связанного устройства',
  `Database_Revision` int(10) unsigned DEFAULT NULL COMMENT '155 Версия базы данных',
  `Configuration_Files` text COMMENT '154 Файлы конфигурации',
  `Last_Restore_Time` datetime(3) DEFAULT NULL COMMENT '157 Последнее Время Восстановления',
  `Backup_Failure_Timeout` int(11) DEFAULT NULL COMMENT '153 Резервный тайм-аут отказа',
  `Backup_Preparation_Time` int(11) DEFAULT NULL COMMENT '339 Время подготовки для сохранения',
  `Restore_Preparation_Time` int(11) DEFAULT NULL COMMENT '341 Время подготовки для востановления',
  `Restore_Completion_Time` int(11) DEFAULT NULL COMMENT '340 Время комплексного востановления',
  `Backup_And_Restore_State` enum('idle','preparing-for-backup','preparing-for-restore','performing-a-backup','performing-a-restore','backup-failure','restore-failure') DEFAULT NULL COMMENT '338 Состояние сохранения и востановления',
  `Active_COV_Subscriptions` int(10) unsigned DEFAULT NULL COMMENT '152 Активных COV подписок',
  `Slave_Proxy_Enable` text COMMENT '172 Работающий ведомый прокси',
  `Manual_Slave_Address_Binding` int(10) unsigned DEFAULT NULL COMMENT '170 Ручная ведомая привязка по адресу',
  `Auto_Slave_Discovery` text COMMENT '169 Автоматическое ведомое открытие',
  `Slave_Address_Binding` int(10) unsigned DEFAULT NULL COMMENT '171 Ведомая привязка по адресу',
  `uniq_val` varchar(32) DEFAULT NULL,
  `Notification_Class` int(10) unsigned DEFAULT NULL COMMENT '17 Класс уведомления',
  `Notify_Type` enum('alarm','event','ack-notification') DEFAULT NULL COMMENT '72 Тип уведомления',
  `Event_Message_Texts` text COMMENT '351 Тексты сообщений о событиях',
  `Event_Detection_Enable` tinyint(1) DEFAULT NULL COMMENT '353 Включить обнаружение событий',
  `Event_Enable` tinyint(4) DEFAULT NULL COMMENT '35 Событие разрешено',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.


-- Дамп структуры для таблица vbas.objects.event-enrollment
DROP TABLE IF EXISTS `objects.event-enrollment`;
CREATE TABLE IF NOT EXISTS `objects.event-enrollment` (
  `id` int(11) NOT NULL COMMENT 'Сквозной уникальный идентификатор объекта',
  `Description` varchar(256) DEFAULT NULL COMMENT '28 Описание',
  `Event_Type` varchar(256) DEFAULT NULL COMMENT '37 Тип события',
  `Notify_Type` enum('alarm','event','ack-notification') DEFAULT NULL COMMENT '72 Тип уведомления',
  `Event_Parameters` text COMMENT '83 Параметры события',
  `Object_Property_Reference` varchar(256) DEFAULT NULL COMMENT '78 Ссылка на свойство объекта',
  `Event_State` varchar(256) DEFAULT NULL COMMENT '36 Состояние события',
  `Event_Enable` tinyint(4) DEFAULT NULL COMMENT '35 Событие разрешено',
  `Acked_Transitions` tinyint(4) DEFAULT NULL COMMENT '0 Признаный переход',
  `Notification_Class` int(10) unsigned DEFAULT NULL COMMENT '17 Класс уведомления',
  `Event_Time_Stamps` text COMMENT '130 Отметки времени событий',
  `Event_Message_Texts` text COMMENT '351 Тексты сообщений о событиях',
  `Event_Message_Texts_Config` text COMMENT '352 Конфигурация текстов сообщений о событиях',
  `Event_Detection_Enable` tinyint(1) DEFAULT NULL COMMENT '353 Включить обнаружение событий',
  `Event_Algorithm_Inhibit_Ref` varchar(256) DEFAULT NULL COMMENT '355 Ссылка события алгоритма сдерживания',
  `Event_Algorithm_Inhibit` tinyint(1) DEFAULT NULL COMMENT '354 События алгоритма сдерживания',
  `Time_Delay_Normal` int(10) unsigned DEFAULT NULL COMMENT '356 Нормальная задержка времени',
  `Status_Flags` tinyint(4) DEFAULT NULL COMMENT '111 Флаги состояния',
  `Reliability` varchar(256) DEFAULT NULL COMMENT '103 Освободить по умолчанию',
  `Fault_Type` enum('none','fault-characterstring','fault-extended','fault-life-safety','fault-state','fault-status-flags') DEFAULT NULL COMMENT '359 Типы сбоя',
  `Fault_Parameters` varchar(256) DEFAULT NULL COMMENT '358 Параметры сбоя',
  `Reliability_Evaluation_Inhibit` tinyint(1) DEFAULT NULL COMMENT '357 Оценка надежности сдерживания',
  `Profile_Name` varchar(256) DEFAULT NULL COMMENT '168 Имя профиля',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.


-- Дамп структуры для таблица vbas.objects.event-log
DROP TABLE IF EXISTS `objects.event-log`;
CREATE TABLE IF NOT EXISTS `objects.event-log` (
  `id` int(11) NOT NULL COMMENT 'Сквозной уникальный идентификатор объекта',
  `Description` varchar(256) DEFAULT NULL COMMENT '28 Описание',
  `Status_Flags` tinyint(4) DEFAULT NULL COMMENT '111 Флаги состояния',
  `Event_State` varchar(256) DEFAULT NULL COMMENT '36 Состояние события',
  `Reliability` varchar(256) DEFAULT NULL COMMENT '103 Освободить по умолчанию',
  `Enable` tinyint(1) DEFAULT NULL COMMENT '133 Включить',
  `Start_Time` datetime(3) DEFAULT NULL COMMENT '142 Время начала',
  `Stop_Time` datetime(3) DEFAULT NULL COMMENT '143 Время остановки',
  `Stop_When_Full` tinyint(1) DEFAULT NULL COMMENT '144 Остановить при заполнении',
  `Buffer_Size` int(10) unsigned DEFAULT NULL COMMENT '126 Размер буфера',
  `Log_Buffer` int(10) unsigned DEFAULT NULL COMMENT '131 Буфер журнала',
  `Record_Count` int(10) unsigned DEFAULT NULL COMMENT '141 Номер записи',
  `Total_Record_Count` int(10) unsigned DEFAULT NULL COMMENT '145 Общее значение записи',
  `Notification_Threshold` int(10) unsigned DEFAULT NULL COMMENT '137 Порог уведомления',
  `Records_Since_Notification` int(10) unsigned DEFAULT NULL COMMENT '140 Записи с уведомлением',
  `Last_Notify_Record` int(10) unsigned DEFAULT NULL COMMENT '173 Последняя уведомляющая запись',
  `Notification_Class` int(10) unsigned DEFAULT NULL COMMENT '17 Класс уведомления',
  `Event_Enable` tinyint(4) DEFAULT NULL COMMENT '35 Событие разрешено',
  `Acked_Transitions` tinyint(4) DEFAULT NULL COMMENT '0 Признаный переход',
  `Notify_Type` enum('alarm','event','ack-notification') DEFAULT NULL COMMENT '72 Тип уведомления',
  `Event_Time_Stamps` text COMMENT '130 Отметки времени событий',
  `Event_Message_Texts` text COMMENT '351 Тексты сообщений о событиях',
  `Event_Message_Texts_Config` text COMMENT '352 Конфигурация текстов сообщений о событиях',
  `Event_Detection_Enable` tinyint(1) DEFAULT NULL COMMENT '353 Включить обнаружение событий',
  `Event_Algorithm_Inhibit_Ref` varchar(256) DEFAULT NULL COMMENT '355 Ссылка события алгоритма сдерживания',
  `Event_Algorithm_Inhibit` tinyint(1) DEFAULT NULL COMMENT '354 События алгоритма сдерживания',
  `Reliability_Evaluation_Inhibit` tinyint(1) DEFAULT NULL COMMENT '357 Оценка надежности сдерживания',
  `Profile_Name` varchar(256) DEFAULT NULL COMMENT '168 Имя профиля',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.


-- Дамп структуры для таблица vbas.objects.event-log.buffer
DROP TABLE IF EXISTS `objects.event-log.buffer`;
CREATE TABLE IF NOT EXISTS `objects.event-log.buffer` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'primary key',
  `message_text` varchar(256) DEFAULT NULL,
  `notify_type` enum('alarm','event','ack-notification') DEFAULT NULL COMMENT 'Тип уведомления',
  `from_state` enum('normal','fault','offnormal','high-limit','low-limit','life-safety-alarm') DEFAULT NULL,
  `to_state` enum('normal','fault','offnormal','high-limit','low-limit','life-safety-alarm') DEFAULT NULL,
  `status_flags` tinyint(4) DEFAULT NULL,
  `reliability` varchar(256) DEFAULT NULL,
  `Timestamp` datetime(3) NOT NULL COMMENT 'Метка создания записи',
  `serial` int(11) NOT NULL COMMENT 'поле для контроля количества записей в таблице',
  `object_identifier` int(11) NOT NULL,
  `device_id` int(11) NOT NULL,
  `object_name` varchar(256) DEFAULT NULL,
  `description` varchar(256) DEFAULT NULL,
  `present_value` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  UNIQUE KEY `serial` (`serial`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.


-- Дамп структуры для таблица vbas.objects.file
DROP TABLE IF EXISTS `objects.file`;
CREATE TABLE IF NOT EXISTS `objects.file` (
  `id` int(11) NOT NULL COMMENT 'Сквозной уникальный идентификатор объекта',
  `Description` varchar(256) DEFAULT NULL COMMENT '28 Описание',
  `File_Type` varchar(256) DEFAULT NULL COMMENT '43 Тип файла',
  `File_Size` int(10) unsigned DEFAULT NULL COMMENT '42 Размер файла',
  `Modification_Date` datetime(3) DEFAULT NULL COMMENT '71 Дата модификации',
  `Archive` tinyint(1) DEFAULT NULL COMMENT '13 Архив',
  `Read_Only` tinyint(1) DEFAULT NULL COMMENT '99 Только чтение',
  `File_Access_Method` enum('record-access','stream-access') DEFAULT NULL COMMENT '41 Метод доступа к файлу',
  `Record_Count` int(10) unsigned DEFAULT NULL COMMENT '141 Номер записи',
  `Profile_Name` varchar(256) DEFAULT NULL COMMENT '168 Имя профиля',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.


-- Дамп структуры для таблица vbas.objects.folder
DROP TABLE IF EXISTS `objects.folder`;
CREATE TABLE IF NOT EXISTS `objects.folder` (
  `id` int(11) NOT NULL COMMENT 'Сквозной уникальный идентификатор объекта',
  `Description` varchar(256) DEFAULT NULL COMMENT '28 Описание',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.


-- Дамп структуры для таблица vbas.objects.global-group
DROP TABLE IF EXISTS `objects.global-group`;
CREATE TABLE IF NOT EXISTS `objects.global-group` (
  `id` int(11) NOT NULL COMMENT 'Сквозной уникальный идентификатор объекта',
  `Description` varchar(256) DEFAULT NULL COMMENT '28 Описание',
  `Group_Members` text COMMENT '345 Члены группы',
  `Group_Member_Names` text COMMENT '346 Имена членов группы',
  `Present_Value` text COMMENT '85 Текущее значение',
  `Status_Flags` tinyint(4) DEFAULT NULL COMMENT '111 Флаги состояния',
  `Event_State` varchar(256) DEFAULT NULL COMMENT '36 Состояние события',
  `Member_Status_Flags` tinyint(4) DEFAULT NULL COMMENT '347 Флаги состояние членов',
  `Reliability` varchar(256) DEFAULT NULL COMMENT '103 Освободить по умолчанию',
  `Out_of_Service` tinyint(1) DEFAULT NULL COMMENT '81 Не работает',
  `Update_Interval` int(10) unsigned DEFAULT NULL COMMENT '118 Интервал обновления',
  `Requested_Update_Interval` int(10) unsigned DEFAULT NULL COMMENT '348 Запрощенный интервал обновления',
  `COV_Resubscription_Interval` int(10) unsigned DEFAULT NULL COMMENT '128 Интервал переподписки COV',
  `Client_COV_Increment` varchar(256) DEFAULT NULL COMMENT '127 Инкремент COV клиента',
  `Time_Delay` int(10) unsigned DEFAULT NULL COMMENT '113 Задержка по времени',
  `Notification_Class` int(10) unsigned DEFAULT NULL COMMENT '17 Класс уведомления',
  `Event_Enable` tinyint(4) DEFAULT NULL COMMENT '35 Событие разрешено',
  `Acked_Transitions` tinyint(4) DEFAULT NULL COMMENT '0 Признаный переход',
  `Notify_Type` enum('alarm','event','ack-notification') DEFAULT NULL COMMENT '72 Тип уведомления',
  `Event_Time_Stamps` text COMMENT '130 Отметки времени событий',
  `Event_Message_Texts` text COMMENT '351 Тексты сообщений о событиях',
  `Event_Message_Texts_Config` text COMMENT '352 Конфигурация текстов сообщений о событиях',
  `Event_Detection_Enable` tinyint(1) DEFAULT NULL COMMENT '353 Включить обнаружение событий',
  `Event_Algorithm_Inhibit_Ref` varchar(256) DEFAULT NULL COMMENT '355 Ссылка события алгоритма сдерживания',
  `Event_Algorithm_Inhibit` tinyint(1) DEFAULT NULL COMMENT '354 События алгоритма сдерживания',
  `Time_Delay_Normal` int(10) unsigned DEFAULT NULL COMMENT '356 Нормальная задержка времени',
  `COVU_Period` int(10) unsigned DEFAULT NULL COMMENT '349 Период COVU',
  `COVU_Recipients` int(10) unsigned DEFAULT NULL COMMENT '350 Получатели COVU',
  `Reliability_Evaluation_Inhibit` tinyint(1) DEFAULT NULL COMMENT '357 Оценка надежности сдерживания',
  `Profile_Name` varchar(256) DEFAULT NULL COMMENT '168 Имя профиля',
  `event_state_tmp` varchar(256) DEFAULT NULL COMMENT '36 Состояние события, в течение интервалов timeDelay, timeDelayNormal',
  `event_timestamps_tmp` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.


-- Дамп структуры для таблица vbas.objects.group
DROP TABLE IF EXISTS `objects.group`;
CREATE TABLE IF NOT EXISTS `objects.group` (
  `id` int(11) NOT NULL COMMENT 'Сквозной уникальный идентификатор объекта',
  `Description` varchar(256) DEFAULT NULL COMMENT '28 Описание',
  `List_Of_Group_Members` int(10) unsigned DEFAULT NULL COMMENT '53 Список участников группы',
  `Present_Value` int(10) unsigned DEFAULT NULL COMMENT '85 Текущее значение',
  `Profile_Name` varchar(256) DEFAULT NULL COMMENT '168 Имя профиля',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.


-- Дамп структуры для таблица vbas.objects.integer-value
DROP TABLE IF EXISTS `objects.integer-value`;
CREATE TABLE IF NOT EXISTS `objects.integer-value` (
  `id` int(11) NOT NULL COMMENT 'Сквозной уникальный идентификатор объекта',
  `Description` varchar(256) DEFAULT NULL COMMENT '28 Описание',
  `Present_Value` int(11) DEFAULT NULL COMMENT '85 Текущее значение',
  `Status_Flags` tinyint(4) DEFAULT NULL COMMENT '111 Флаги состояния',
  `Event_State` varchar(256) DEFAULT NULL COMMENT '36 Состояние события',
  `Reliability` varchar(256) DEFAULT NULL COMMENT '103 Освободить по умолчанию',
  `Out_Of_Service` tinyint(1) DEFAULT NULL COMMENT '81 Не работает',
  `Units` varchar(256) DEFAULT NULL COMMENT '117 Единицы',
  `Priority_Array` varchar(256) DEFAULT NULL COMMENT '87 Приоритетный массив',
  `Relinquish_Default` int(11) DEFAULT NULL COMMENT '104 Освободить по умолчанию',
  `COV_Increment` int(10) unsigned DEFAULT NULL COMMENT '22 Приращение COV',
  `Time_Delay` int(10) unsigned DEFAULT NULL COMMENT '113 Задержка по времени',
  `Notification_Class` int(10) unsigned DEFAULT NULL COMMENT '17 Класс уведомления',
  `High_Limit` int(11) DEFAULT NULL COMMENT '45 Высокий предел',
  `Low_Limit` int(11) DEFAULT NULL COMMENT '59 Низкий предел',
  `Deadband` int(10) unsigned DEFAULT NULL COMMENT '25 Нечувствительность',
  `Limit_Enable` tinyint(4) DEFAULT NULL COMMENT '52 Предел включения',
  `Event_Enable` tinyint(4) DEFAULT NULL COMMENT '35 Событие разрешено',
  `Acked_Transitions` tinyint(4) DEFAULT NULL COMMENT '0 Признаный переход',
  `Notify_Type` enum('alarm','event','ack-notification') DEFAULT NULL COMMENT '72 Тип уведомления',
  `Event_Time_Stamps` text COMMENT '130 Отметки времени событий',
  `Event_Message_Texts` text COMMENT '351 Тексты сообщений о событиях',
  `Event_Message_Texts_Config` text COMMENT '352 Конфигурация текстов сообщений о событиях',
  `Event_Detection_Enable` tinyint(1) DEFAULT NULL COMMENT '353 Включить обнаружение событий',
  `Event_Algorithm_Inhibit_Ref` varchar(256) DEFAULT NULL COMMENT '355 Ссылка события алгоритма сдерживания',
  `Event_Algorithm_Inhibit` tinyint(1) DEFAULT NULL COMMENT '354 События алгоритма сдерживания',
  `Time_Delay_Normal` int(10) unsigned DEFAULT NULL COMMENT '356 Нормальная задержка времени',
  `Reliability_Evaluation_Inhibit` tinyint(1) DEFAULT NULL COMMENT '357 Оценка надежности сдерживания',
  `Min_Pres_Value` int(11) DEFAULT NULL COMMENT '69 Мин. значение',
  `Max_Pres_Value` int(11) DEFAULT NULL COMMENT '65 Макс. значение',
  `Resolution` int(11) DEFAULT NULL COMMENT '106 Разрешение',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.


-- Дамп структуры для таблица vbas.objects.large-analog-value
DROP TABLE IF EXISTS `objects.large-analog-value`;
CREATE TABLE IF NOT EXISTS `objects.large-analog-value` (
  `id` int(11) NOT NULL COMMENT 'Сквозной уникальный идентификатор объекта',
  `Description` varchar(256) DEFAULT NULL COMMENT '28 Описание',
  `Present_Value` double DEFAULT NULL COMMENT '85 Текущее значение',
  `Status_Flags` tinyint(4) DEFAULT NULL COMMENT '111 Флаги состояния',
  `Event_State` varchar(256) DEFAULT NULL COMMENT '36 Состояние события',
  `Reliability` varchar(256) DEFAULT NULL COMMENT '103 Освободить по умолчанию',
  `Out_Of_Service` tinyint(1) DEFAULT NULL COMMENT '81 Не работает',
  `Units` varchar(256) DEFAULT NULL COMMENT '117 Единицы',
  `Priority_Array` varchar(256) DEFAULT NULL COMMENT '87 Приоритетный массив',
  `Relinquish_Default` double DEFAULT NULL COMMENT '104 Освободить по умолчанию',
  `COV_Increment` double DEFAULT NULL COMMENT '22 Приращение COV',
  `Time_Delay` int(10) unsigned DEFAULT NULL COMMENT '113 Задержка по времени',
  `Notification_Class` int(10) unsigned DEFAULT NULL COMMENT '17 Класс уведомления',
  `High_Limit` double DEFAULT NULL COMMENT '45 Высокий предел',
  `Low_Limit` double DEFAULT NULL COMMENT '59 Низкий предел',
  `Deadband` double DEFAULT NULL COMMENT '25 Нечувствительность',
  `Limit_Enable` tinyint(4) DEFAULT NULL COMMENT '52 Предел включения',
  `Event_Enable` tinyint(4) DEFAULT NULL COMMENT '35 Событие разрешено',
  `Acked_Transitions` tinyint(4) DEFAULT NULL COMMENT '0 Признаный переход',
  `Notify_Type` enum('alarm','event','ack-notification') DEFAULT NULL COMMENT '72 Тип уведомления',
  `Event_Time_Stamps` text COMMENT '130 Отметки времени событий',
  `Event_Message_Texts` text COMMENT '351 Тексты сообщений о событиях',
  `Event_Message_Texts_Config` text COMMENT '352 Конфигурация текстов сообщений о событиях',
  `Event_Detection_Enable` tinyint(1) DEFAULT NULL COMMENT '353 Включить обнаружение событий',
  `Event_Algorithm_Inhibit_Ref` varchar(256) DEFAULT NULL COMMENT '355 Ссылка события алгоритма сдерживания',
  `Event_Algorithm_Inhibit` tinyint(1) DEFAULT NULL COMMENT '354 События алгоритма сдерживания',
  `Time_Delay_Normal` int(10) unsigned DEFAULT NULL COMMENT '356 Нормальная задержка времени',
  `Reliability_Evaluation_Inhibit` tinyint(1) DEFAULT NULL COMMENT '357 Оценка надежности сдерживания',
  `Min_Pres_Value` double DEFAULT NULL COMMENT '69 Мин. значение',
  `Max_Pres_Value` double DEFAULT NULL COMMENT '65 Макс. значение',
  `Resolution` double DEFAULT NULL COMMENT '106 Разрешение',
  `Profile_Name` varchar(256) DEFAULT NULL COMMENT '168 Имя профиля',
  `event_state_tmp` varchar(256) DEFAULT NULL COMMENT '36 Состояние события, в течение интервалов timeDelay, timeDelayNormal',
  `event_timestamps_tmp` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.


-- Дамп структуры для таблица vbas.objects.life-safety-point
DROP TABLE IF EXISTS `objects.life-safety-point`;
CREATE TABLE IF NOT EXISTS `objects.life-safety-point` (
  `id` int(11) NOT NULL COMMENT 'Сквозной уникальный идентификатор объекта',
  `Present_Value` varchar(256) DEFAULT NULL COMMENT '85 Текущее значение',
  `Tracking_Value` varchar(256) DEFAULT NULL COMMENT '164 Отслеживаемое значение',
  `Description` varchar(256) DEFAULT NULL COMMENT '28 Описание',
  `Device_Type` varchar(256) DEFAULT NULL COMMENT '31 Тип устройства',
  `Status_Flags` tinyint(4) DEFAULT NULL COMMENT '111 Флаги состояния',
  `Event_State` varchar(256) DEFAULT NULL COMMENT '36 Состояние события',
  `Reliability` varchar(256) DEFAULT NULL COMMENT '103 Освободить по умолчанию',
  `Out_Of_Service` tinyint(1) DEFAULT NULL COMMENT '81 Не работает',
  `Mode` varchar(256) DEFAULT NULL COMMENT '160 Режим',
  `Accepted_Modes` int(10) unsigned DEFAULT NULL COMMENT '175 Принятые режимы',
  `Time_Delay` int(10) unsigned DEFAULT NULL COMMENT '113 Задержка по времени',
  `Notification_Class` int(10) unsigned DEFAULT NULL COMMENT '17 Класс уведомления',
  `Life_Safety_Alarm_Values` int(10) unsigned DEFAULT NULL COMMENT '166 Значения аварийного сигнала безопасности жизни ',
  `Alarm_Values` int(10) unsigned DEFAULT NULL COMMENT '7 Сигнальные значения',
  `Fault_Values` int(10) unsigned DEFAULT NULL COMMENT '39 Значений ошибки',
  `Event_Enable` tinyint(4) DEFAULT NULL COMMENT '35 Событие разрешено',
  `Acked_Transitions` tinyint(4) DEFAULT NULL COMMENT '0 Признаный переход',
  `Notify_Type` enum('alarm','event','ack-notification') DEFAULT NULL COMMENT '72 Тип уведомления',
  `Event_Time_Stamps` text COMMENT '130 Отметки времени событий',
  `Event_Message_Texts` text COMMENT '351 Тексты сообщений о событиях',
  `Event_Message_Texts_Config` text COMMENT '352 Конфигурация текстов сообщений о событиях',
  `Event_Detection_Enable` tinyint(1) DEFAULT NULL COMMENT '353 Включить обнаружение событий',
  `Event_Algorithm_Inhibit_Ref` varchar(256) DEFAULT NULL COMMENT '355 Ссылка события алгоритма сдерживания',
  `Event_Algorithm_Inhibit` tinyint(1) DEFAULT NULL COMMENT '354 События алгоритма сдерживания',
  `Time_Delay_Normal` int(10) unsigned DEFAULT NULL COMMENT '356 Нормальная задержка времени',
  `Reliability_Evaluation_Inhibit` tinyint(1) DEFAULT NULL COMMENT '357 Оценка надежности сдерживания',
  `Silenced` varchar(256) DEFAULT NULL COMMENT '163 Молчаливо',
  `Operation_Expected` varchar(256) DEFAULT NULL COMMENT '161 Ожидается операция',
  `Maintenance_Required` varchar(256) DEFAULT NULL COMMENT '158 Требуется обслуживание',
  `Setting` tinyint(3) unsigned DEFAULT NULL COMMENT '162 Установка',
  `Direct_Reading` float DEFAULT NULL COMMENT '156 Прямое чтение',
  `Units` varchar(256) DEFAULT NULL COMMENT '117 Единицы',
  `Member_Of` int(10) unsigned DEFAULT NULL COMMENT '159 Член',
  `Profile_Name` varchar(256) DEFAULT NULL COMMENT '168 Имя профиля',
  `event_state_tmp` varchar(256) DEFAULT NULL COMMENT '36 Состояние события, в течение интервалов timeDelay, timeDelayNormal',
  `event_timestamps_tmp` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.


-- Дамп структуры для таблица vbas.objects.life-safety-zone
DROP TABLE IF EXISTS `objects.life-safety-zone`;
CREATE TABLE IF NOT EXISTS `objects.life-safety-zone` (
  `id` int(11) NOT NULL COMMENT 'Сквозной уникальный идентификатор объекта',
  `Present_Value` varchar(256) DEFAULT NULL COMMENT '85 Текущее значение',
  `Tracking_Value` varchar(256) DEFAULT NULL COMMENT '164 Отслеживаемое значение',
  `Description` varchar(256) DEFAULT NULL COMMENT '28 Описание',
  `Device_Type` varchar(256) DEFAULT NULL COMMENT '31 Тип устройства',
  `Status_Flags` tinyint(4) DEFAULT NULL COMMENT '111 Флаги состояния',
  `Event_State` varchar(256) DEFAULT NULL COMMENT '36 Состояние события',
  `Reliability` varchar(256) DEFAULT NULL COMMENT '103 Освободить по умолчанию',
  `Out_Of_Service` tinyint(1) DEFAULT NULL COMMENT '81 Не работает',
  `Mode` varchar(256) DEFAULT NULL COMMENT '160 Режим',
  `Accepted_Modes` int(10) unsigned DEFAULT NULL COMMENT '175 Принятые режимы',
  `Time_Delay` int(10) unsigned DEFAULT NULL COMMENT '113 Задержка по времени',
  `Notification_Class` int(10) unsigned DEFAULT NULL COMMENT '17 Класс уведомления',
  `Life_Safety_Alarm_Values` int(10) unsigned DEFAULT NULL COMMENT '166 Значения аварийного сигнала безопасности жизни ',
  `Alarm_Values` int(10) unsigned DEFAULT NULL COMMENT '7 Сигнальные значения',
  `Fault_Values` int(10) unsigned DEFAULT NULL COMMENT '39 Значений ошибки',
  `Event_Enable` tinyint(4) DEFAULT NULL COMMENT '35 Событие разрешено',
  `Acked_Transitions` tinyint(4) DEFAULT NULL COMMENT '0 Признаный переход',
  `Notify_Type` enum('alarm','event','ack-notification') DEFAULT NULL COMMENT '72 Тип уведомления',
  `Event_Time_Stamps` text COMMENT '130 Отметки времени событий',
  `Event_Message_Texts` text COMMENT '351 Тексты сообщений о событиях',
  `Event_Message_Texts_Config` text COMMENT '352 Конфигурация текстов сообщений о событиях',
  `Event_Detection_Enable` tinyint(1) DEFAULT NULL COMMENT '353 Включить обнаружение событий',
  `Event_Algorithm_Inhibit_Ref` varchar(256) DEFAULT NULL COMMENT '355 Ссылка события алгоритма сдерживания',
  `Event_Algorithm_Inhibit` tinyint(1) DEFAULT NULL COMMENT '354 События алгоритма сдерживания',
  `Time_Delay_Normal` int(10) unsigned DEFAULT NULL COMMENT '356 Нормальная задержка времени',
  `Reliability_Evaluation_Inhibit` tinyint(1) DEFAULT NULL COMMENT '357 Оценка надежности сдерживания',
  `Silenced` varchar(256) DEFAULT NULL COMMENT '163 Молчаливо',
  `Operation_Expected` varchar(256) DEFAULT NULL COMMENT '161 Ожидается операция',
  `Maintenance_Required` tinyint(1) DEFAULT NULL COMMENT '158 Требуется обслуживание',
  `Zone_Members` int(10) unsigned DEFAULT NULL COMMENT '165 Зона членов',
  `Member_Of` int(10) unsigned DEFAULT NULL COMMENT '159 Член',
  `Profile_Name` varchar(256) DEFAULT NULL COMMENT '168 Имя профиля',
  `event_state_tmp` varchar(256) DEFAULT NULL COMMENT '36 Состояние события, в течение интервалов timeDelay, timeDelayNormal',
  `event_timestamps_tmp` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.


-- Дамп структуры для таблица vbas.objects.lighting-output
DROP TABLE IF EXISTS `objects.lighting-output`;
CREATE TABLE IF NOT EXISTS `objects.lighting-output` (
  `id` int(11) NOT NULL COMMENT 'Сквозной уникальный идентификатор объекта',
  `Present_Value` float DEFAULT NULL COMMENT '85 Текущее значение',
  `Tracking_Value` float DEFAULT NULL COMMENT '164 Отслеживаемое значение',
  `Lighting_Command` text COMMENT '380 Команда освещения',
  `In_Progress` enum('idle','fade-active','ramp-active','not-controlled','other') DEFAULT NULL COMMENT '378 В  процессе выполнения',
  `Description` varchar(256) DEFAULT NULL COMMENT '28 Описание',
  `Status_Flags` tinyint(4) DEFAULT NULL COMMENT '111 Флаги состояния',
  `Reliability` varchar(256) DEFAULT NULL COMMENT '103 Освободить по умолчанию',
  `Out_Of_Service` tinyint(1) DEFAULT NULL COMMENT '81 Не работает',
  `Blink_Warn_Enable` tinyint(1) DEFAULT NULL COMMENT '373 Включение мигающего уведомления',
  `Egress_Time` int(10) unsigned DEFAULT NULL COMMENT '377 Выходное время',
  `Egress_Active` tinyint(1) DEFAULT NULL COMMENT '386 Активный выход',
  `Default_Fade_Time` int(10) unsigned DEFAULT NULL COMMENT '374 Время затемнения по умолчанию',
  `Default_Ramp_Rate` float DEFAULT NULL COMMENT '375 Уровень пандуса по умолчанию',
  `Default_Step_Increment` float DEFAULT NULL COMMENT '376 Шаговый инкремент по умолчанию',
  `Transition` enum('none','fade','ramp') DEFAULT NULL COMMENT '385 Переход',
  `Feedback_Value` float DEFAULT NULL COMMENT '40 Значение обратной связи',
  `Priority_Array` varchar(256) DEFAULT NULL COMMENT '87 Приоритетный массив',
  `Relinquish_Default` float DEFAULT NULL COMMENT '104 Освободить по умолчанию',
  `Power` float DEFAULT NULL COMMENT '384 Мощность',
  `Instantaneous_Power` float DEFAULT NULL COMMENT '379 Мгновенная мощность',
  `Min_Actual_Value` float DEFAULT NULL COMMENT '383 Минимальное фактическое значение',
  `Max_Actual_Value` float DEFAULT NULL COMMENT '382 Максимальное фактическое значение',
  `Lighting_Command_Default_Priority` int(10) unsigned DEFAULT NULL COMMENT '381 Приоритет команды освещения по умолчанию',
  `COV_Increment` float DEFAULT NULL COMMENT '22 Приращение COV',
  `Reliability_Evaluation_Inhibit` tinyint(1) DEFAULT NULL COMMENT '357 Оценка надежности сдерживания',
  `Profile_Name` varchar(256) DEFAULT NULL COMMENT '168 Имя профиля',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.


-- Дамп структуры для таблица vbas.objects.load-control
DROP TABLE IF EXISTS `objects.load-control`;
CREATE TABLE IF NOT EXISTS `objects.load-control` (
  `id` int(11) NOT NULL COMMENT 'Сквозной уникальный идентификатор объекта',
  `Description` varchar(256) DEFAULT NULL COMMENT '28 Описание',
  `Present_Value` enum('shed-inactive','shed-request-pending','shed-compliant','shed-non-compliant') DEFAULT NULL COMMENT '85 Текущее значение',
  `State_Description` varchar(256) DEFAULT NULL COMMENT '222 Описание состояния',
  `Status_Flags` tinyint(4) DEFAULT NULL COMMENT '111 Флаги состояния',
  `Event_State` varchar(256) DEFAULT NULL COMMENT '36 Состояние события',
  `Reliability` varchar(256) DEFAULT NULL COMMENT '103 Освободить по умолчанию',
  `Requested_Shed_Level` varchar(256) DEFAULT NULL COMMENT '218 Запрашиваемый уровень снятия',
  `Start_Time` datetime(3) DEFAULT NULL COMMENT '142 Время начала',
  `Shed_Duration` int(10) unsigned DEFAULT NULL COMMENT '219 Длительность снятия',
  `Duty_Window` int(10) unsigned DEFAULT NULL COMMENT '213 Служебное окно',
  `Enable` tinyint(1) DEFAULT NULL COMMENT '133 Включить',
  `Full_Duty_Baseline` float DEFAULT NULL COMMENT '215 Полная базовая линия режима работы',
  `Expected_Shed_Level` varchar(256) DEFAULT NULL COMMENT '214 Ожидаемый уровень снятия',
  `Actual_Shed_Level` varchar(256) DEFAULT NULL COMMENT '212 Актуальный уровень снятия',
  `Shed_Levels` text COMMENT '221 Уровень снятия',
  `Shed_Level_Descriptions` text COMMENT '220 Описание снятия',
  `Notification_Class` int(10) unsigned DEFAULT NULL COMMENT '17 Класс уведомления',
  `Time_Delay` int(10) unsigned DEFAULT NULL COMMENT '113 Задержка по времени',
  `Event_Enable` tinyint(4) DEFAULT NULL COMMENT '35 Событие разрешено',
  `Acked_Transitions` tinyint(4) DEFAULT NULL COMMENT '0 Признаный переход',
  `Notify_Type` enum('alarm','event','ack-notification') DEFAULT NULL COMMENT '72 Тип уведомления',
  `Event_Time_Stamps` text COMMENT '130 Отметки времени событий',
  `Event_Message_Texts` text COMMENT '351 Тексты сообщений о событиях',
  `Event_Message_Texts_Config` text COMMENT '352 Конфигурация текстов сообщений о событиях',
  `Event_Detection_Enable` tinyint(1) DEFAULT NULL COMMENT '353 Включить обнаружение событий',
  `Event_Algorithm_Inhibit_Ref` varchar(256) DEFAULT NULL COMMENT '355 Ссылка события алгоритма сдерживания',
  `Event_Algorithm_Inhibit` tinyint(1) DEFAULT NULL COMMENT '354 События алгоритма сдерживания',
  `Time_Delay_Normal` int(10) unsigned DEFAULT NULL COMMENT '356 Нормальная задержка времени',
  `Reliability_Evaluation_Inhibit` tinyint(1) DEFAULT NULL COMMENT '357 Оценка надежности сдерживания',
  `Profile_Name` varchar(256) DEFAULT NULL COMMENT '168 Имя профиля',
  `event_state_tmp` varchar(256) DEFAULT NULL COMMENT '36 Состояние события, в течение интервалов timeDelay, timeDelayNormal',
  `event_timestamps_tmp` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.


-- Дамп структуры для таблица vbas.objects.loop
DROP TABLE IF EXISTS `objects.loop`;
CREATE TABLE IF NOT EXISTS `objects.loop` (
  `id` int(11) NOT NULL COMMENT 'Сквозной уникальный идентификатор объекта',
  `Present_Value` float DEFAULT NULL COMMENT '85 Текущее значение',
  `Description` varchar(256) DEFAULT NULL COMMENT '28 Описание',
  `Status_Flags` tinyint(4) DEFAULT NULL COMMENT '111 Флаги состояния',
  `Event_State` varchar(256) DEFAULT NULL COMMENT '36 Состояние события',
  `Reliability` varchar(256) DEFAULT NULL COMMENT '103 Освободить по умолчанию',
  `Out_Of_Service` tinyint(1) DEFAULT NULL COMMENT '81 Не работает',
  `Update_Interval` int(10) unsigned DEFAULT NULL COMMENT '118 Интервал обновления',
  `Output_Units` varchar(256) DEFAULT NULL COMMENT '82 Устройство вывода',
  `Manipulated_Variable_Reference` varchar(256) DEFAULT NULL COMMENT '60 Управляемая переменная ссылка',
  `Controlled_Variable_Reference` varchar(256) DEFAULT NULL COMMENT '19 Ссылка на контроллируемую переменную',
  `Controlled_Variable_Value` float DEFAULT NULL COMMENT '21 Контролируемое переменное значение',
  `Controlled_Variable_Units` varchar(256) DEFAULT NULL COMMENT '20 Контролируемые переменные блоки',
  `Setpoint_Reference` varchar(256) DEFAULT NULL COMMENT '109 Ссылка на заданную точку',
  `Setpoint` float DEFAULT NULL COMMENT '108 Заданная точка',
  `Action` enum('direct','reverse') DEFAULT NULL COMMENT '2 Действие',
  `Proportional_Constant` float DEFAULT NULL COMMENT '93 Пропорциональная постоянная',
  `Proportional_Constant_Units` varchar(256) DEFAULT NULL COMMENT '94 Блоки пропорциональной постоянной',
  `Integral_Constant` float DEFAULT NULL COMMENT '49 Интегральная постоянная',
  `Integral_Constant_Units` varchar(256) DEFAULT NULL COMMENT '50 Блок интегральной постоянной',
  `Derivative_Constant` float DEFAULT NULL COMMENT '26 Производная постоянной',
  `Derivative_Constant_Units` varchar(256) DEFAULT NULL COMMENT '27 Блоки производной постоянной',
  `Bias` float DEFAULT NULL COMMENT '14 Предвзятость',
  `Maximum_Output` float DEFAULT NULL COMMENT '61 Максимальный выходной уровень',
  `Minimum_Output` float DEFAULT NULL COMMENT '68 Минимальный выходной уровень',
  `Priority_For_Writing` int(10) unsigned DEFAULT NULL COMMENT '88 Приоритет на запись',
  `COV_Increment` float DEFAULT NULL COMMENT '22 Приращение COV',
  `Time_Delay` int(10) unsigned DEFAULT NULL COMMENT '113 Задержка по времени',
  `Notification_Class` int(10) unsigned DEFAULT NULL COMMENT '17 Класс уведомления',
  `Error_Limit` float DEFAULT NULL COMMENT '34 Предел ошибки',
  `Deadband` float DEFAULT NULL COMMENT '25 Нечувствительность',
  `Event_Enable` tinyint(4) DEFAULT NULL COMMENT '35 Событие разрешено',
  `Acked_Transitions` tinyint(4) DEFAULT NULL COMMENT '0 Признаный переход',
  `Notify_Type` enum('alarm','event','ack-notification') DEFAULT NULL COMMENT '72 Тип уведомления',
  `Event_Time_Stamps` text COMMENT '130 Отметки времени событий',
  `Event_Message_Texts` text COMMENT '351 Тексты сообщений о событиях',
  `Event_Message_Texts_Config` text COMMENT '352 Конфигурация текстов сообщений о событиях',
  `Event_Detection_Enable` tinyint(1) DEFAULT NULL COMMENT '353 Включить обнаружение событий',
  `Event_Algorithm_Inhibit_Ref` varchar(256) DEFAULT NULL COMMENT '355 Ссылка события алгоритма сдерживания',
  `Event_Algorithm_Inhibit` tinyint(1) DEFAULT NULL COMMENT '354 События алгоритма сдерживания',
  `Time_Delay_Normal` int(10) unsigned DEFAULT NULL COMMENT '356 Нормальная задержка времени',
  `Reliability_Evaluation_Inhibit` tinyint(1) DEFAULT NULL COMMENT '357 Оценка надежности сдерживания',
  `Profile_Name` varchar(256) DEFAULT NULL COMMENT '168 Имя профиля',
  `event_state_tmp` varchar(256) DEFAULT NULL COMMENT '36 Состояние события, в течение интервалов timeDelay, timeDelayNormal',
  `event_timestamps_tmp` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.


-- Дамп структуры для таблица vbas.objects.multi-state-input
DROP TABLE IF EXISTS `objects.multi-state-input`;
CREATE TABLE IF NOT EXISTS `objects.multi-state-input` (
  `id` int(11) NOT NULL COMMENT 'Сквозной уникальный идентификатор объекта',
  `Present_Value` int(10) unsigned DEFAULT NULL COMMENT '85 Текущее значение',
  `Description` varchar(256) DEFAULT NULL COMMENT '28 Описание',
  `Device_Type` varchar(256) DEFAULT NULL COMMENT '31 Тип устройства',
  `Status_Flags` tinyint(4) DEFAULT NULL COMMENT '111 Флаги состояния',
  `Event_State` varchar(256) DEFAULT NULL COMMENT '36 Состояние события, после окончания интервалов timeDelay, timeDelayNormal',
  `event_state_tmp` varchar(256) DEFAULT NULL COMMENT '36 Состояние события, в течение интервалов timeDelay, timeDelayNormal',
  `Reliability` varchar(256) DEFAULT NULL COMMENT '103 Освободить по умолчанию',
  `Out_Of_Service` tinyint(1) DEFAULT NULL COMMENT '81 Не работает',
  `Number_Of_States` int(10) unsigned DEFAULT NULL COMMENT '74 Число состояний',
  `State_Text` int(11) DEFAULT NULL COMMENT '110 Состояние текста',
  `Time_Delay` int(10) unsigned DEFAULT NULL COMMENT '113 Задержка по времени',
  `Notification_Class` int(10) unsigned DEFAULT NULL COMMENT '17 Класс уведомления',
  `Alarm_Values` text COMMENT '7 Сигнальные значения',
  `Fault_Values` text COMMENT '39 Значений ошибки',
  `Event_Enable` tinyint(4) DEFAULT NULL COMMENT '35 Событие разрешено',
  `Acked_Transitions` tinyint(4) DEFAULT NULL COMMENT '0 Признаный переход',
  `Notify_Type` enum('alarm','event','ack-notification') DEFAULT NULL COMMENT '72 Тип уведомления',
  `Event_Time_Stamps` text COMMENT '130 Отметки времени событий',
  `Event_Message_Texts` text COMMENT '351 Тексты сообщений о событиях',
  `Event_Message_Texts_Config` text COMMENT '352 Конфигурация текстов сообщений о событиях',
  `Event_Detection_Enable` tinyint(1) DEFAULT NULL COMMENT '353 Включить обнаружение событий',
  `Event_Algorithm_Inhibit_Ref` varchar(256) DEFAULT NULL COMMENT '355 Ссылка события алгоритма сдерживания',
  `Event_Algorithm_Inhibit` tinyint(1) DEFAULT NULL COMMENT '354 События алгоритма сдерживания',
  `Time_Delay_Normal` int(10) unsigned DEFAULT NULL COMMENT '356 Нормальная задержка времени',
  `Reliability_Evaluation_Inhibit` tinyint(1) DEFAULT NULL COMMENT '357 Оценка надежности сдерживания',
  `Profile_Name` varchar(256) DEFAULT NULL COMMENT '168 Имя профиля',
  `event_timestamps_tmp` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.


-- Дамп структуры для таблица vbas.objects.multi-state-output
DROP TABLE IF EXISTS `objects.multi-state-output`;
CREATE TABLE IF NOT EXISTS `objects.multi-state-output` (
  `id` int(11) NOT NULL COMMENT 'Сквозной уникальный идентификатор объекта',
  `Present_Value` int(10) unsigned DEFAULT NULL COMMENT '85 Текущее значение',
  `Description` varchar(256) DEFAULT NULL COMMENT '28 Описание',
  `Device_Type` varchar(256) DEFAULT NULL COMMENT '31 Тип устройства',
  `Status_Flags` tinyint(4) DEFAULT NULL COMMENT '111 Флаги состояния',
  `Event_State` varchar(256) DEFAULT NULL COMMENT '36 Состояние события',
  `Reliability` varchar(256) DEFAULT NULL COMMENT '103 Освободить по умолчанию',
  `Out_Of_Service` tinyint(1) DEFAULT NULL COMMENT '81 Не работает',
  `Number_Of_States` int(10) unsigned DEFAULT NULL COMMENT '74 Число состояний',
  `State_Text` int(11) DEFAULT NULL COMMENT '110 Состояние текста',
  `Priority_Array` varchar(256) DEFAULT NULL COMMENT '87 Приоритетный массив',
  `Relinquish_Default` int(10) unsigned DEFAULT NULL COMMENT '104 Освободить по умолчанию',
  `Time_Delay` int(10) unsigned DEFAULT NULL COMMENT '113 Задержка по времени',
  `Notification_Class` int(10) unsigned DEFAULT NULL COMMENT '17 Класс уведомления',
  `Feedback_Value` int(10) unsigned DEFAULT NULL COMMENT '40 Значение обратной связи',
  `Event_Enable` tinyint(4) DEFAULT NULL COMMENT '35 Событие разрешено',
  `Acked_Transitions` tinyint(4) DEFAULT NULL COMMENT '0 Признаный переход',
  `Notify_Type` enum('alarm','event','ack-notification') DEFAULT NULL COMMENT '72 Тип уведомления',
  `Event_Time_Stamps` text COMMENT '130 Отметки времени событий',
  `Event_Message_Texts` text COMMENT '351 Тексты сообщений о событиях',
  `Event_Message_Texts_Config` text COMMENT '352 Конфигурация текстов сообщений о событиях',
  `Event_Detection_Enable` tinyint(1) DEFAULT NULL COMMENT '353 Включить обнаружение событий',
  `Event_Algorithm_Inhibit_Ref` varchar(256) DEFAULT NULL COMMENT '355 Ссылка события алгоритма сдерживания',
  `Event_Algorithm_Inhibit` tinyint(1) DEFAULT NULL COMMENT '354 События алгоритма сдерживания',
  `Time_Delay_Normal` int(10) unsigned DEFAULT NULL COMMENT '356 Нормальная задержка времени',
  `Reliability_Evaluation_Inhibit` tinyint(1) DEFAULT NULL COMMENT '357 Оценка надежности сдерживания',
  `Profile_Name` varchar(256) DEFAULT NULL COMMENT '168 Имя профиля',
  `event_state_tmp` varchar(256) DEFAULT NULL COMMENT '36 Состояние события, в течение интервалов timeDelay, timeDelayNormal',
  `event_timestamps_tmp` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.


-- Дамп структуры для таблица vbas.objects.multi-state-value
DROP TABLE IF EXISTS `objects.multi-state-value`;
CREATE TABLE IF NOT EXISTS `objects.multi-state-value` (
  `id` int(11) NOT NULL COMMENT 'Сквозной уникальный идентификатор объекта',
  `Present_Value` int(10) unsigned DEFAULT NULL COMMENT '85 Текущее значение',
  `Description` varchar(256) DEFAULT NULL COMMENT '28 Описание',
  `Status_Flags` tinyint(4) DEFAULT NULL COMMENT '111 Флаги состояния',
  `Event_State` varchar(256) DEFAULT NULL COMMENT '36 Состояние события',
  `event_state_tmp` varchar(256) DEFAULT NULL COMMENT '36 Состояние события, в течение интервалов timeDelay, timeDelayNormal',
  `event_timestamps_tmp` text,
  `Reliability` varchar(256) DEFAULT NULL COMMENT '103 Освободить по умолчанию',
  `Out_Of_Service` tinyint(1) DEFAULT NULL COMMENT '81 Не работает',
  `Number_Of_States` int(10) unsigned DEFAULT NULL COMMENT '74 Число состояний',
  `State_Text` int(11) DEFAULT NULL COMMENT '110 Состояние текста',
  `Priority_Array` varchar(256) DEFAULT NULL COMMENT '87 Приоритетный массив',
  `Relinquish_Default` int(10) unsigned DEFAULT NULL COMMENT '104 Освободить по умолчанию',
  `Time_Delay` int(10) unsigned DEFAULT NULL COMMENT '113 Задержка по времени',
  `Notification_Class` int(10) unsigned DEFAULT NULL COMMENT '17 Класс уведомления',
  `Alarm_Values` text COMMENT '7 Сигнальные значения',
  `Fault_Values` text COMMENT '39 Значения ошибки',
  `Event_Enable` tinyint(4) DEFAULT NULL COMMENT '35 Событие разрешено',
  `Acked_Transitions` tinyint(4) DEFAULT NULL COMMENT '0 Признаный переход',
  `Notify_Type` enum('alarm','event','ack-notification') DEFAULT NULL COMMENT '72 Тип уведомления',
  `Event_Time_Stamps` text COMMENT '130 Отметки времени событий',
  `Event_Message_Texts` text COMMENT '351 Тексты сообщений о событиях',
  `Event_Message_Texts_Config` text COMMENT '352 Конфигурация текстов сообщений о событиях',
  `Event_Detection_Enable` tinyint(1) DEFAULT NULL COMMENT '353 Включить обнаружение событий',
  `Event_Algorithm_Inhibit_Ref` varchar(256) DEFAULT NULL COMMENT '355 Ссылка события алгоритма сдерживания',
  `Event_Algorithm_Inhibit` tinyint(1) DEFAULT NULL COMMENT '354 События алгоритма сдерживания',
  `Time_Delay_Normal` int(10) unsigned DEFAULT NULL COMMENT '356 Нормальная задержка времени',
  `Reliability_Evaluation_Inhibit` tinyint(1) DEFAULT NULL COMMENT '357 Оценка надежности сдерживания',
  `Profile_Name` varchar(256) DEFAULT NULL COMMENT '168 Имя профиля',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.


-- Дамп структуры для таблица vbas.objects.network-security
DROP TABLE IF EXISTS `objects.network-security`;
CREATE TABLE IF NOT EXISTS `objects.network-security` (
  `id` int(11) NOT NULL COMMENT 'Сквозной уникальный идентификатор объекта',
  `Description` varchar(256) DEFAULT NULL COMMENT '28 Описание',
  `Base_Device_Security_Policy` enum('incapable','plain','signed','encrypted','signed-end-to-end','encrypted-end-to-end') DEFAULT NULL COMMENT '327 Базовое устройство политики безопасности',
  `Network_Access_Security_Policies` text COMMENT '332 Политика безопасности сетевого доступа',
  `Security_Time_Window` int(10) unsigned DEFAULT NULL COMMENT '335 Безопасное окно времени',
  `Packet_Reorder_Time` int(10) unsigned DEFAULT NULL COMMENT '333 Пакетное время повторного заказа',
  `Distribution_Key_Revision` tinyint(3) unsigned DEFAULT NULL COMMENT '328 Ключевая версия распределения',
  `Key_Sets` text COMMENT '330 Ключ настроек',
  `Last_Key_Server` varchar(256) DEFAULT NULL COMMENT '331 Последний ключ сервера',
  `Security_PDU_Timeout` int(11) DEFAULT NULL COMMENT '334 Задержка PDU безопасности',
  `Update_Key_Set_Timeout` int(11) DEFAULT NULL COMMENT '337 Установка задержки ключа обновления',
  `Supported_Security_Algorithms` int(10) unsigned DEFAULT NULL COMMENT '336 Поддерживаемые алгоритмы безопасности',
  `Do_Not_Hide` tinyint(1) DEFAULT NULL COMMENT '329 Не заслонять',
  `Profile_Name` varchar(256) DEFAULT NULL COMMENT '168 Имя профиля',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.


-- Дамп структуры для таблица vbas.objects.notification-class
DROP TABLE IF EXISTS `objects.notification-class`;
CREATE TABLE IF NOT EXISTS `objects.notification-class` (
  `id` int(11) NOT NULL COMMENT 'Сквозной уникальный идентификатор объекта',
  `Description` varchar(256) DEFAULT NULL COMMENT '28 Описание',
  `Notification_Class` int(10) unsigned DEFAULT NULL COMMENT '17 Класс уведомления',
  `Priority` text COMMENT '86 Приоритет',
  `Ack_Required` tinyint(4) DEFAULT NULL COMMENT '1 Требуется ACK',
  `Recipient_List` int(10) unsigned DEFAULT NULL COMMENT '102 Надежность',
  `Profile_Name` varchar(256) DEFAULT NULL COMMENT '168 Имя профиля',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.


-- Дамп структуры для таблица vbas.objects.notification-forwarder
DROP TABLE IF EXISTS `objects.notification-forwarder`;
CREATE TABLE IF NOT EXISTS `objects.notification-forwarder` (
  `id` int(11) NOT NULL COMMENT 'Сквозной уникальный идентификатор объекта',
  `Description` varchar(256) DEFAULT NULL COMMENT '28 Описание',
  `Status_Flags` tinyint(4) DEFAULT NULL COMMENT '111 Флаги состояния',
  `Reliability` varchar(256) DEFAULT NULL COMMENT '103 Освободить по умолчанию',
  `Out_Of_Service` tinyint(1) DEFAULT NULL COMMENT '81 Не работает',
  `Recipient_List` int(10) unsigned DEFAULT NULL COMMENT '102 Надежность',
  `Subscribed_Recipients` int(10) unsigned DEFAULT NULL COMMENT '362 Подписанные получатели',
  `Process_Identifier_Filter` varchar(256) DEFAULT NULL COMMENT '361 Фильтр идентификационных процессов',
  `Port_Filter` text COMMENT '363 Фильтр порта',
  `Local_Forwarding_Only` tinyint(1) DEFAULT NULL COMMENT '360 Только локальная переадрессация',
  `Reliability_Evaluation_Inhibit` tinyint(1) DEFAULT NULL COMMENT '357 Оценка надежности сдерживания',
  `Profile_Name` varchar(256) DEFAULT NULL COMMENT '168 Имя профиля',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.


-- Дамп структуры для таблица vbas.objects.octetstring-value
DROP TABLE IF EXISTS `objects.octetstring-value`;
CREATE TABLE IF NOT EXISTS `objects.octetstring-value` (
  `id` int(11) NOT NULL COMMENT 'Сквозной уникальный идентификатор объекта',
  `Description` varchar(256) DEFAULT NULL COMMENT '28 Описание',
  `Present_Value` int(11) DEFAULT NULL COMMENT '85 Текущее значение',
  `Status_Flags` tinyint(4) DEFAULT NULL COMMENT '111 Флаги состояния',
  `Event_State` varchar(256) DEFAULT NULL COMMENT '36 Состояние события',
  `Reliability` varchar(256) DEFAULT NULL COMMENT '103 Освободить по умолчанию',
  `Out_Of_Service` tinyint(1) DEFAULT NULL COMMENT '81 Не работает',
  `Priority_Array` varchar(256) DEFAULT NULL COMMENT '87 Приоритетный массив',
  `Relinquish_Default` int(11) DEFAULT NULL COMMENT '104 Освободить по умолчанию',
  `Reliability_Evaluation_Inhibit` tinyint(1) DEFAULT NULL COMMENT '357 Оценка надежности сдерживания',
  `Profile_Name` varchar(256) DEFAULT NULL COMMENT '168 Имя профиля',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.


-- Дамп структуры для таблица vbas.objects.positive-integer-value
DROP TABLE IF EXISTS `objects.positive-integer-value`;
CREATE TABLE IF NOT EXISTS `objects.positive-integer-value` (
  `id` int(11) NOT NULL COMMENT 'Сквозной уникальный идентификатор объекта',
  `Description` varchar(256) DEFAULT NULL COMMENT '28 Описание',
  `Present_Value` int(10) unsigned DEFAULT NULL COMMENT '85 Текущее значение',
  `Status_Flags` tinyint(4) DEFAULT NULL COMMENT '111 Флаги состояния',
  `Event_State` varchar(256) DEFAULT NULL COMMENT '36 Состояние события',
  `Reliability` varchar(256) DEFAULT NULL COMMENT '103 Освободить по умолчанию',
  `Out_Of_Service` tinyint(1) DEFAULT NULL COMMENT '81 Не работает',
  `Units` varchar(256) DEFAULT NULL COMMENT '117 Единицы',
  `Priority_Array` varchar(256) DEFAULT NULL COMMENT '87 Приоритетный массив',
  `Relinquish_Default` int(10) unsigned DEFAULT NULL COMMENT '104 Освободить по умолчанию',
  `COV_Increment` int(10) unsigned DEFAULT NULL COMMENT '22 Приращение COV',
  `Time_Delay` int(10) unsigned DEFAULT NULL COMMENT '113 Задержка по времени',
  `Notification_Class` int(10) unsigned DEFAULT NULL COMMENT '17 Класс уведомления',
  `High_Limit` int(10) unsigned DEFAULT NULL COMMENT '45 Высокий предел',
  `Low_Limit` int(10) unsigned DEFAULT NULL COMMENT '59 Низкий предел',
  `Deadband` int(10) unsigned DEFAULT NULL COMMENT '25 Нечувствительность',
  `Limit_Enable` tinyint(4) DEFAULT NULL COMMENT '52 Предел включения',
  `Event_Enable` tinyint(4) DEFAULT NULL COMMENT '35 Событие разрешено',
  `Acked_Transitions` bit(3) DEFAULT NULL COMMENT '0 Признаный переход',
  `Notify_Type` enum('alarm','event','ack-notification') DEFAULT NULL COMMENT '72 Тип уведомления',
  `Event_Time_Stamps` text COMMENT '130 Отметки времени событий',
  `Event_Message_Texts` text COMMENT '351 Тексты сообщений о событиях',
  `Event_Message_Texts_Config` text COMMENT '352 Конфигурация текстов сообщений о событиях',
  `Event_Detection_Enable` tinyint(1) DEFAULT NULL COMMENT '353 Включить обнаружение событий',
  `Event_Algorithm_Inhibit_Ref` varchar(256) DEFAULT NULL COMMENT '355 Ссылка события алгоритма сдерживания',
  `Event_Algorithm_Inhibit` tinyint(1) DEFAULT NULL COMMENT '354 События алгоритма сдерживания',
  `Time_Delay_Normal` int(10) unsigned DEFAULT NULL COMMENT '356 Нормальная задержка времени',
  `Reliability_Evaluation_Inhibit` tinyint(1) DEFAULT NULL COMMENT '357 Оценка надежности сдерживания',
  `Min_Pres_Value` int(10) unsigned DEFAULT NULL COMMENT '69 Мин. значение',
  `Max_Pres_Value` int(10) unsigned DEFAULT NULL COMMENT '65 Макс. значение',
  `Resolution` int(10) unsigned DEFAULT NULL COMMENT '106 Разрешение',
  `Profile_Name` varchar(256) DEFAULT NULL COMMENT '168 Имя профиля',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.


-- Дамп структуры для таблица vbas.objects.program
DROP TABLE IF EXISTS `objects.program`;
CREATE TABLE IF NOT EXISTS `objects.program` (
  `id` int(11) NOT NULL COMMENT 'Сквозной уникальный идентификатор объекта',
  `Program_State` enum('idle','loading','running','waiting','halted','unloading') DEFAULT NULL COMMENT '92 Состояние программы',
  `Program_Change` enum('ready','load','run','halt','restart','unload') DEFAULT NULL COMMENT '90 Изменение программы',
  `Reason_For_Halt` varchar(256) DEFAULT NULL COMMENT '100 Причина останова',
  `Description_Of_Halt` varchar(256) DEFAULT NULL COMMENT '29 Описание остановки',
  `Program_Location` varchar(256) DEFAULT NULL COMMENT '91 Нахождение программы',
  `Description` varchar(256) DEFAULT NULL COMMENT '28 Описание',
  `Instance_Of` varchar(256) DEFAULT NULL COMMENT '48 Экземпляр',
  `Status_Flags` tinyint(4) DEFAULT NULL COMMENT '111 Флаги состояния',
  `Reliability` varchar(256) DEFAULT NULL COMMENT '103 Освободить по умолчанию',
  `Out_Of_Service` tinyint(1) DEFAULT NULL COMMENT '81 Не работает',
  `Event_Detection_Enable` tinyint(1) DEFAULT NULL COMMENT '353 Включить обнаружение событий',
  `Notification_Class` int(10) unsigned DEFAULT NULL COMMENT '17 Класс уведомления',
  `Event_Enable` tinyint(4) DEFAULT NULL COMMENT '35 Событие разрешено',
  `Event_State` varchar(256) DEFAULT NULL COMMENT '36 Состояние события',
  `Acked_Transitions` tinyint(4) DEFAULT NULL COMMENT '0 Признаный переход',
  `Notify_Type` enum('alarm','event','ack-notification') DEFAULT NULL COMMENT '72 Тип уведомления',
  `Event_Time_Stamps` text COMMENT '130 Отметки времени событий',
  `Event_Message_Texts` text COMMENT '351 Тексты сообщений о событиях',
  `Event_Message_Texts_Config` text COMMENT '352 Конфигурация текстов сообщений о событиях',
  `Reliability_Evaluation_Inhibit` tinyint(1) DEFAULT NULL COMMENT '357 Оценка надежности сдерживания',
  `Profile_Name` varchar(256) DEFAULT NULL COMMENT '168 Имя профиля',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.


-- Дамп структуры для таблица vbas.objects.property.bacnet-list
DROP TABLE IF EXISTS `objects.property.bacnet-list`;
CREATE TABLE IF NOT EXISTS `objects.property.bacnet-list` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор листа',
  `object_id` int(11) NOT NULL COMMENT 'Сквозной уникальный идентификатор объекта',
  `property_id` int(11) NOT NULL COMMENT 'Связанный идентификатор с свойством объекта',
  `Number` int(11) NOT NULL COMMENT 'Номер свойства в листе',
  `Property_JSON` text COMMENT 'Данные свойства в формате JSON',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  KEY `prop_id` (`property_id`),
  KEY `object_id` (`object_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.


-- Дамп структуры для таблица vbas.objects.pulse-converter
DROP TABLE IF EXISTS `objects.pulse-converter`;
CREATE TABLE IF NOT EXISTS `objects.pulse-converter` (
  `id` int(11) NOT NULL COMMENT 'Сквозной уникальный идентификатор объекта',
  `Description` varchar(256) DEFAULT NULL COMMENT '28 Описание',
  `Present_Value` float DEFAULT NULL COMMENT '85 Текущее значение',
  `Input_Reference` varchar(256) DEFAULT NULL COMMENT '181 Ввод значения',
  `Status_Flags` tinyint(4) DEFAULT NULL COMMENT '111 Флаги состояния',
  `Event_State` varchar(256) DEFAULT NULL COMMENT '36 Состояние события',
  `Reliability` varchar(256) DEFAULT NULL COMMENT '103 Освободить по умолчанию',
  `Out_Of_Service` tinyint(1) DEFAULT NULL COMMENT '81 Не работает',
  `Units` varchar(256) DEFAULT NULL COMMENT '117 Единицы',
  `Scale_Factor` float DEFAULT NULL COMMENT '188 Фактор умножения',
  `Adjust_Value` float DEFAULT NULL COMMENT '176 Скорректируемое значение',
  `Count` int(10) unsigned DEFAULT NULL COMMENT '177 Счетчик',
  `Update_Time` datetime(3) DEFAULT NULL COMMENT '189 Время обновления',
  `Count_Change_Time` datetime(3) DEFAULT NULL COMMENT '179 Время изменения счетчика',
  `Count_Before_Change` int(10) unsigned DEFAULT NULL COMMENT '178 Счетчик перед изменением',
  `COV_Increment` float DEFAULT NULL COMMENT '22 Приращение COV',
  `COV_Period` int(10) unsigned DEFAULT NULL COMMENT '180 COV период',
  `Notification_Class` int(10) unsigned DEFAULT NULL COMMENT '17 Класс уведомления',
  `Time_Delay` int(10) unsigned DEFAULT NULL COMMENT '113 Задержка по времени',
  `High_Limit` float DEFAULT NULL COMMENT '45 Высокий предел',
  `Low_Limit` float DEFAULT NULL COMMENT '59 Низкий предел',
  `Deadband` float DEFAULT NULL COMMENT '25 Нечувствительность',
  `Limit_Enable` tinyint(4) DEFAULT NULL COMMENT '52 Предел включения',
  `Event_Enable` tinyint(4) DEFAULT NULL COMMENT '35 Событие разрешено',
  `Acked_Transitions` tinyint(4) DEFAULT NULL COMMENT '0 Признаный переход',
  `Notify_Type` enum('alarm','event','ack-notification') DEFAULT NULL COMMENT '72 Тип уведомления',
  `Event_Time_Stamps` text COMMENT '130 Отметки времени событий',
  `Event_Message_Texts` text COMMENT '351 Тексты сообщений о событиях',
  `Event_Message_Texts_Config` text COMMENT '352 Конфигурация текстов сообщений о событиях',
  `Event_Detection_Enable` tinyint(1) DEFAULT NULL COMMENT '353 Включить обнаружение событий',
  `Event_Algorithm_Inhibit_Ref` varchar(256) DEFAULT NULL COMMENT '355 Ссылка события алгоритма сдерживания',
  `Event_Algorithm_Inhibit` tinyint(1) DEFAULT NULL COMMENT '354 События алгоритма сдерживания',
  `Time_Delay_Normal` int(10) unsigned DEFAULT NULL COMMENT '356 Нормальная задержка времени',
  `Reliability_Evaluation_Inhibit` tinyint(1) DEFAULT NULL COMMENT '357 Оценка надежности сдерживания',
  `Profile_Name` varchar(256) DEFAULT NULL COMMENT '168 Имя профиля',
  `event_state_tmp` varchar(256) DEFAULT NULL COMMENT '36 Состояние события, в течение интервалов timeDelay, timeDelayNormal',
  `event_timestamps_tmp` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.


-- Дамп структуры для таблица vbas.objects.schedule
DROP TABLE IF EXISTS `objects.schedule`;
CREATE TABLE IF NOT EXISTS `objects.schedule` (
  `id` int(11) NOT NULL COMMENT 'Сквозной уникальный идентификатор объекта',
  `Present_Value` varchar(256) DEFAULT NULL COMMENT '85 Текущее значение',
  `Description` varchar(256) DEFAULT NULL COMMENT '28 Описание',
  `Effective_Period` varchar(256) DEFAULT NULL COMMENT '32 Период действия',
  `Weekly_Schedule` text COMMENT '123 Недельное рассписание',
  `Exception_Schedule` text COMMENT '38 Расписание исключений',
  `Schedule_Default` varchar(256) DEFAULT NULL COMMENT '174 Команда для расписания по умолчанию',
  `List_Of_Object_Property_References` int(10) unsigned DEFAULT NULL COMMENT '54 Список ссылок свойств объекта',
  `Priority_For_Writing` int(11) DEFAULT NULL COMMENT '88 Приоритет на запись',
  `Status_Flags` tinyint(4) DEFAULT NULL COMMENT '111 Флаги состояния',
  `Reliability` varchar(256) DEFAULT NULL COMMENT '103 Освободить по умолчанию',
  `Out_Of_Service` tinyint(1) DEFAULT NULL COMMENT '81 Не работает',
  `Event_Detection_Enable` tinyint(1) DEFAULT NULL COMMENT '353 Включить обнаружение событий',
  `Notification_Class` int(10) unsigned DEFAULT NULL COMMENT '17 Класс уведомления',
  `Event_Enable` tinyint(4) DEFAULT NULL COMMENT '35 Событие разрешено',
  `Event_State` varchar(256) DEFAULT NULL COMMENT '36 Состояние события',
  `Acked_Transitions` tinyint(4) DEFAULT NULL COMMENT '0 Признаный переход',
  `Notify_Type` enum('alarm','event','ack-notification') DEFAULT NULL COMMENT '72 Тип уведомления',
  `Event_Time_Stamps` text COMMENT '130 Отметки времени событий',
  `Event_Message_Texts` text COMMENT '351 Тексты сообщений о событиях',
  `Event_Message_Texts_Config` text COMMENT '352 Конфигурация текстов сообщений о событиях',
  `Reliability_Evaluation_Inhibit` tinyint(1) DEFAULT NULL COMMENT '357 Оценка надежности сдерживания',
  `Profile_Name` varchar(256) DEFAULT NULL COMMENT '168 Имя профиля',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.


-- Дамп структуры для таблица vbas.objects.structured-view
DROP TABLE IF EXISTS `objects.structured-view`;
CREATE TABLE IF NOT EXISTS `objects.structured-view` (
  `id` int(11) NOT NULL COMMENT 'Сквозной уникальный идентификатор объекта',
  `Description` varchar(256) DEFAULT NULL COMMENT '28 Описание',
  `Node_Type` enum('unknown','system','network','device','organizational','area','equipment','point','collection','property','functional','other') DEFAULT NULL COMMENT '208 Тип узла',
  `Node_Subtype` varchar(256) DEFAULT NULL COMMENT '207 Подтип узла',
  `Subordinate_List` text COMMENT '211 Подчиненные списки',
  `Subordinate_Annotations` text COMMENT '210 Подчиненные аннотации',
  `Profile_Name` varchar(256) DEFAULT NULL COMMENT '168 Имя профиля',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.


-- Дамп структуры для таблица vbas.objects.time-pattern-value
DROP TABLE IF EXISTS `objects.time-pattern-value`;
CREATE TABLE IF NOT EXISTS `objects.time-pattern-value` (
  `id` int(11) NOT NULL COMMENT 'Сквозной уникальный идентификатор объекта',
  `Description` varchar(256) DEFAULT NULL COMMENT '28 Описание',
  `Present_Value` time DEFAULT NULL COMMENT '85 Текущее значение',
  `Status_Flags` tinyint(4) DEFAULT NULL COMMENT '111 Флаги состояния',
  `Event_State` varchar(256) DEFAULT NULL COMMENT '36 Состояние события',
  `Reliability` varchar(256) DEFAULT NULL COMMENT '103 Освободить по умолчанию',
  `Out_Of_Service` tinyint(1) DEFAULT NULL COMMENT '81 Не работает',
  `Priority_Array` varchar(256) DEFAULT NULL COMMENT '87 Приоритетный массив',
  `Relinquish_Default` time DEFAULT NULL COMMENT '104 Освободить по умолчанию',
  `Reliability_Evaluation_Inhibit` tinyint(1) DEFAULT NULL COMMENT '357 Оценка надежности сдерживания',
  `Profile_Name` varchar(256) DEFAULT NULL COMMENT '168 Имя профиля',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.


-- Дамп структуры для таблица vbas.objects.time-value
DROP TABLE IF EXISTS `objects.time-value`;
CREATE TABLE IF NOT EXISTS `objects.time-value` (
  `id` int(11) NOT NULL COMMENT 'Сквозной уникальный идентификатор объекта',
  `Description` varchar(256) DEFAULT NULL COMMENT '28 Описание',
  `Present_Value` time DEFAULT NULL COMMENT '85 Текущее значение',
  `Status_Flags` tinyint(4) DEFAULT NULL COMMENT '111 Флаги состояния',
  `Event_State` varchar(256) DEFAULT NULL COMMENT '36 Состояние события',
  `Reliability` varchar(256) DEFAULT NULL COMMENT '103 Освободить по умолчанию',
  `Out_Of_Service` tinyint(1) DEFAULT NULL COMMENT '81 Не работает',
  `Priority_Array` varchar(256) DEFAULT NULL COMMENT '87 Приоритетный массив',
  `Relinquish_Default` time DEFAULT NULL COMMENT '104 Освободить по умолчанию',
  `Reliability_Evaluation_Inhibit` tinyint(1) DEFAULT NULL COMMENT '357 Оценка надежности сдерживания',
  `Profile_Name` varchar(256) DEFAULT NULL COMMENT '168 Имя профиля',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.


-- Дамп структуры для таблица vbas.objects.trend-log
DROP TABLE IF EXISTS `objects.trend-log`;
CREATE TABLE IF NOT EXISTS `objects.trend-log` (
  `id` int(11) NOT NULL COMMENT 'Сквозной уникальный идентификатор объекта',
  `log_device` int(11) NOT NULL COMMENT 'identifier of the logged object parent device, 75 field of device',
  `log_object` int(11) NOT NULL COMMENT 'identifier of the logged object, 75 field of the object',
  `log_property` int(11) NOT NULL COMMENT 'identifier of the logged object property',
  `Description` varchar(256) DEFAULT NULL COMMENT '28 Описание',
  `Enable` tinyint(1) DEFAULT NULL COMMENT '133 Включить',
  `Start_Time` datetime(3) DEFAULT NULL COMMENT '142 Время начала',
  `Stop_Time` datetime(3) DEFAULT NULL COMMENT '143 Время остановки',
  `Log_DeviceObjectProperty` text COMMENT '132 Свойство объекта журнала событий, must be as [dev75, obj75, propcode]',
  `Log_Interval` int(10) unsigned DEFAULT NULL COMMENT '134 Интервал обновления журнала',
  `COV_Resubscription_Interval` int(10) unsigned DEFAULT NULL COMMENT '128 Интервал переподписки COV',
  `Client_COV_Increment` varchar(256) DEFAULT NULL COMMENT '127 Инкремент COV клиента',
  `Stop_When_Full` tinyint(1) DEFAULT NULL COMMENT '144 Остановить при заполнении',
  `Buffer_Size` int(10) unsigned DEFAULT NULL COMMENT '126 Размер буфера',
  `Record_Count` int(10) unsigned DEFAULT NULL COMMENT '141 Номер записи',
  `Total_Record_Count` int(10) unsigned DEFAULT NULL COMMENT '145 Общее значение записи',
  `Logging_Type` varchar(256) DEFAULT NULL COMMENT '197 Тип ведения журнала',
  `Align_Intervals` tinyint(1) DEFAULT NULL COMMENT '193 Связаный интервал',
  `Interval_Offset` int(10) unsigned DEFAULT NULL COMMENT '195 Смещение интервала',
  `Trigger` tinyint(1) DEFAULT NULL COMMENT '205 Переключатель',
  `Status_Flags` tinyint(4) DEFAULT NULL COMMENT '111 Флаги состояния',
  `Reliability` varchar(256) DEFAULT NULL COMMENT '103 Освободить по умолчанию',
  `Notification_Threshold` int(10) unsigned DEFAULT NULL COMMENT '137 Порог уведомления',
  `Records_Since_Notification` int(10) unsigned DEFAULT NULL COMMENT '140 Записи с уведомлением',
  `Last_Notify_Record` int(10) unsigned DEFAULT NULL COMMENT '173 Последняя уведомляющая запись',
  `Event_State` varchar(256) DEFAULT NULL COMMENT '36 Состояние события',
  `Notification_Class` int(10) unsigned DEFAULT NULL COMMENT '17 Класс уведомления',
  `Event_Enable` tinyint(4) DEFAULT NULL COMMENT '35 Событие разрешено',
  `Acked_Transitions` tinyint(4) DEFAULT NULL COMMENT '0 Признаный переход',
  `Notify_Type` enum('alarm','event','ack-notification') DEFAULT NULL COMMENT '72 Тип уведомления',
  `Event_Time_Stamps` text COMMENT '130 Отметки времени событий',
  `Event_Message_Texts` text COMMENT '351 Тексты сообщений о событиях',
  `Event_Message_Texts_Config` text COMMENT '352 Конфигурация текстов сообщений о событиях',
  `Event_Detection_Enable` tinyint(1) DEFAULT NULL COMMENT '353 Включить обнаружение событий',
  `Event_Algorithm_Inhibit_Ref` varchar(256) DEFAULT NULL COMMENT '355 Ссылка события алгоритма сдерживания',
  `Event_Algorithm_Inhibit` tinyint(1) DEFAULT NULL COMMENT '354 События алгоритма сдерживания',
  `Reliability_Evaluation_Inhibit` tinyint(1) DEFAULT NULL COMMENT '357 Оценка надежности сдерживания',
  `Profile_Name` varchar(256) DEFAULT NULL COMMENT '168 Имя профиля',
  PRIMARY KEY (`id`,`log_device`,`log_object`,`log_property`),
  UNIQUE KEY `id` (`id`),
  KEY `pk_log_device_idx` (`log_device`),
  KEY `pk_log_object_idx` (`log_object`),
  KEY `pk_log_property_idx` (`log_property`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.


-- Дамп структуры для таблица vbas.objects.trend-log-multiple
DROP TABLE IF EXISTS `objects.trend-log-multiple`;
CREATE TABLE IF NOT EXISTS `objects.trend-log-multiple` (
  `id` int(11) NOT NULL COMMENT 'Сквозной уникальный идентификатор объекта',
  `Description` varchar(256) DEFAULT NULL COMMENT '28 Описание',
  `Status_Flags` tinyint(4) DEFAULT NULL COMMENT '111 Флаги состояния',
  `Event_State` varchar(256) DEFAULT NULL COMMENT '36 Состояние события',
  `Reliability` varchar(256) DEFAULT NULL COMMENT '103 Освободить по умолчанию',
  `Enable` tinyint(1) DEFAULT NULL COMMENT '133 Включить',
  `Start_Time` datetime(3) DEFAULT NULL COMMENT '142 Время начала',
  `Stop_Time` datetime(3) DEFAULT NULL COMMENT '143 Время остановки',
  `Logging_Type` enum('polled','cov','triggered') DEFAULT NULL COMMENT '197 Тип ведения журнала',
  `Log_Interval` int(10) unsigned DEFAULT NULL COMMENT '134 Интервал обновления журнала',
  `Align_Intervals` tinyint(1) DEFAULT NULL COMMENT '193 Связаный интервал',
  `Interval_Offset` int(10) unsigned DEFAULT NULL COMMENT '195 Смещение интервала',
  `Trigger` tinyint(1) DEFAULT NULL COMMENT '205 Переключатель',
  `Stop_When_Full` tinyint(1) DEFAULT NULL COMMENT '144 Остановить при заполнении',
  `Buffer_Size` int(10) unsigned DEFAULT NULL COMMENT '126 Размер буфера',
  `Log_Buffer` int(10) unsigned DEFAULT NULL COMMENT '131 Буфер журнала',
  `Record_Count` int(10) unsigned DEFAULT NULL COMMENT '141 Номер записи',
  `Total_Record_Count` int(10) unsigned DEFAULT NULL COMMENT '145 Общее значение записи',
  `Notification_Threshold` int(10) unsigned DEFAULT NULL COMMENT '137 Порог уведомления',
  `Records_Since_Notification` int(10) unsigned DEFAULT NULL COMMENT '140 Записи с уведомлением',
  `Last_Notify_Record` int(10) unsigned DEFAULT NULL COMMENT '173 Последняя уведомляющая запись',
  `Notification_Class` int(10) unsigned DEFAULT NULL COMMENT '17 Класс уведомления',
  `Event_Enable` tinyint(4) DEFAULT NULL COMMENT '35 Событие разрешено',
  `Acked_Transitions` tinyint(4) DEFAULT NULL COMMENT '0 Признаный переход',
  `Notify_Type` enum('alarm','event','ack-notification') DEFAULT NULL COMMENT '72 Тип уведомления',
  `Event_Time_Stamps` text COMMENT '130 Отметки времени событий',
  `Event_Message_Texts` text COMMENT '351 Тексты сообщений о событиях',
  `Event_Message_Texts_Config` text COMMENT '352 Конфигурация текстов сообщений о событиях',
  `Event_Detection_Enable` tinyint(1) DEFAULT NULL COMMENT '353 Включить обнаружение событий',
  `Event_Algorithm_Inhibit_Ref` varchar(256) DEFAULT NULL COMMENT '355 Ссылка события алгоритма сдерживания',
  `Event_Algorithm_Inhibit` tinyint(1) DEFAULT NULL COMMENT '354 События алгоритма сдерживания',
  `Reliability_Evaluation_Inhibit` tinyint(1) DEFAULT NULL COMMENT '357 Оценка надежности сдерживания',
  `Profile_Name` varchar(256) DEFAULT NULL COMMENT '168 Имя профиля',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.


-- Дамп структуры для таблица vbas.objects.trend-log-multiple.buffer
DROP TABLE IF EXISTS `objects.trend-log-multiple.buffer`;
CREATE TABLE IF NOT EXISTS `objects.trend-log-multiple.buffer` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'primary key',
  `device_id` int(11) NOT NULL COMMENT 'девайс',
  `Object_Name` varchar(256) NOT NULL COMMENT 'Имя объекта',
  `Object_Identifier` int(11) NOT NULL COMMENT 'айди объекта',
  `Log_Datum` text NOT NULL COMMENT 'Данные объекта, или статус лога, см enum LogStatus',
  `Timestamp` datetime(3) NOT NULL COMMENT 'Метка создания записи',
  `Status_Flags` tinyint(4) DEFAULT NULL COMMENT 'Флаги состояния логируемого объекта',
  `serial` int(11) NOT NULL COMMENT 'поле для контроля количества записей в таблице',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  UNIQUE KEY `serial` (`serial`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.


-- Дамп структуры для таблица vbas.objects.trend-log-multiple.ext
DROP TABLE IF EXISTS `objects.trend-log-multiple.ext`;
CREATE TABLE IF NOT EXISTS `objects.trend-log-multiple.ext` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'primary key',
  `trend_id` int(11) NOT NULL COMMENT 'trend log id',
  `log_device` int(11) NOT NULL COMMENT 'identifier of the logged object parent device, 75 field of device',
  `log_object` int(11) NOT NULL COMMENT 'identifier of the logged object, 75 field of the object',
  `log_property` int(11) NOT NULL COMMENT 'identifier of the logged object property',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  KEY `fk_trend_log_ext` (`trend_id`),
  CONSTRAINT `fk_trend_log_ext` FOREIGN KEY (`trend_id`) REFERENCES `objects.trend-log-multiple` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.


-- Дамп структуры для таблица vbas.objects.trend-log.buffer
DROP TABLE IF EXISTS `objects.trend-log.buffer`;
CREATE TABLE IF NOT EXISTS `objects.trend-log.buffer` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'primary key',
  `trend_id` int(11) NOT NULL COMMENT 'trend log id',
  `log_device` int(11) NOT NULL COMMENT 'identifier of the logged object parent device, 75 field of device',
  `log_object` int(11) NOT NULL COMMENT 'identifier of the logged object, 75 field of the object',
  `log_property` int(11) NOT NULL COMMENT 'identifier of the logged object property',
  `Log_Datum` text NOT NULL COMMENT 'Данные объекта, или статус лога, см enum LogStatus',
  `Timestamp` datetime(3) NOT NULL COMMENT 'Метка создания записи',
  `Status_Flags` tinyint(4) DEFAULT NULL COMMENT 'Флаги состояния логируемого объекта',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  KEY `fk_trend_log` (`trend_id`,`log_device`,`log_object`,`log_property`),
  CONSTRAINT `fk_trend_log` FOREIGN KEY (`trend_id`, `log_device`, `log_object`, `log_property`) REFERENCES `objects.trend-log` (`id`, `log_device`, `log_object`, `log_property`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.


-- Дамп структуры для таблица vbas.objects_wmap
DROP TABLE IF EXISTS `objects_wmap`;
CREATE TABLE IF NOT EXISTS `objects_wmap` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Сквозной уникальный идентификатор объекта',
  `parent_id` int(11) NOT NULL COMMENT 'id родительского объекта',
  `device_id` int(11) DEFAULT NULL COMMENT 'id объекта device, к которому привязан объект',
  `reliability_id` int(11) NOT NULL DEFAULT '0',
  `out_of_service` tinyint(1) NOT NULL DEFAULT '0',
  `bacnet_name` varchar(256) DEFAULT NULL COMMENT 'имя объекта получаемое от bacnet устройства',
  `value` double DEFAULT '0',
  `status` tinyint(4) DEFAULT '0',
  `timestamp` datetime DEFAULT NULL COMMENT 'время последнего обновления',
  `Object_Identifier` int(11) DEFAULT NULL COMMENT '75 Идентификатор объекта',
  `Object_Name` varchar(256) DEFAULT NULL COMMENT '77 Имя объекта',
  `Object_Type` enum('analog-input','analog-output','analog-value','binary-input','binary-output','binary-value','calendar','command','device','event-enrollment','file','group','loop','multi-state-input','multi-state-output','notification-class','program','schedule','averaging','multi-state-value','trend-log','life-safety-point','life-safety-zone','accumulator','pulse-converter','event-log','global-group','trend-log-multiple','load-control','structured-view','access-door','access-credential','access-point','access-rights','access-user','access-zone','credential-data-input','network-security','bitstring-value','characterstring-value','date-pattern-value','date-value','datetime-pattern-value','datetime-value','integer-value','large-analog-value','octetstring-value','positive-integer-value','time-pattern-value','time-value','notification-forwarder','alert-enrollment','channel','lighting-output','folder','site','trunk','graphic') NOT NULL COMMENT '79 Тип объекта',
  `Property_List` text COMMENT '371 Список свойств',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  KEY `identifier` (`Object_Identifier`),
  KEY `name` (`Object_Name`(255)),
  KEY `type` (`Object_Type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.


-- Дамп структуры для таблица vbas.object_looks
DROP TABLE IF EXISTS `object_looks`;
CREATE TABLE IF NOT EXISTS `object_looks` (
  `id` int(11) NOT NULL,
  `object_type` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `object_type_id` int(11) NOT NULL DEFAULT '0',
  `notification_id` int(11) NOT NULL DEFAULT '0',
  `enable_to_offnormal` tinyint(1) NOT NULL DEFAULT '0',
  `enable_to_fault` tinyint(1) NOT NULL DEFAULT '0',
  `enable_to_normal` tinyint(1) NOT NULL DEFAULT '0',
  `parent_name` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `message_to_offnormal` varchar(150) COLLATE utf8_unicode_ci DEFAULT NULL,
  `message_to_fault` varchar(150) COLLATE utf8_unicode_ci DEFAULT NULL,
  `message_to_normal` varchar(150) COLLATE utf8_unicode_ci DEFAULT NULL,
  `binary_alarm` tinyint(1) DEFAULT NULL,
  `multistate_alarm` int(11) DEFAULT NULL,
  `analog_low` float DEFAULT NULL,
  `analog_high` float DEFAULT NULL,
  `topic_id` int(11) DEFAULT '0',
  `fault_topic_id` int(11) DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- Экспортируемые данные не выделены.


-- Дамп структуры для таблица vbas.object_notification
DROP TABLE IF EXISTS `object_notification`;
CREATE TABLE IF NOT EXISTS `object_notification` (
  `id` int(11) NOT NULL,
  `priority_to_offnormal` int(11) NOT NULL DEFAULT '0',
  `priority_to_fault` int(11) NOT NULL DEFAULT '0',
  `priority_to_normal` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- Экспортируемые данные не выделены.


-- Дамп структуры для таблица vbas.object_notification_groups
DROP TABLE IF EXISTS `object_notification_groups`;
CREATE TABLE IF NOT EXISTS `object_notification_groups` (
  `notification_id` int(11) DEFAULT NULL,
  `group_id` int(11) DEFAULT NULL,
  `to_offnormal` tinyint(1) DEFAULT NULL,
  `to_fault` tinyint(1) DEFAULT NULL,
  `to_normal` tinyint(1) DEFAULT NULL,
  KEY `notification_id` (`notification_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- Экспортируемые данные не выделены.


-- Дамп структуры для таблица vbas.reliability
DROP TABLE IF EXISTS `reliability`;
CREATE TABLE IF NOT EXISTS `reliability` (
  `id` int(11) NOT NULL,
  `name` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `description` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------
-- Хост:                         127.0.0.1
-- Версия сервера:               5.6.48-log - MySQL Community Server (GPL)
-- ОС Сервера:                   Win64
-- HeidiSQL Версия:              9.3.0.4984
-- --------------------------------------------------------



-- Дамп структуры для событие vbas.update_2s
DROP EVENT IF EXISTS `update_2s`;
DELIMITER //
CREATE EVENT `update_2s` ON SCHEDULE EVERY 2 SECOND STARTS '2020-11-03 13:47:53' ON COMPLETION PRESERVE ENABLE DO BEGIN

update `objects`
	set status=status|2
   where  device_id IN (
	SELECT a.oid FROM (select Object_Identifier as oid from `objects` where id in
								(select id from `objects.device` WHERE TIMESTAMPADD(SECOND, APDU_Timeout * Number_Of_APDU_Retries /1000  ,Last_Restore_Time)<NOW())
							) as `a`
								)
	and Object_Type in (
	'binary-output',
	'binary-input',
	'binary-value',
	'analog-value',
	'analog-output',
	'analog-input',
	'multi-state-value',
	'multi-state-input',
	'accumulator');

	update `objects` SET status = status|2 where  id in (select id from `objects.device` WHERE TIMESTAMPADD(SECOND, APDU_Timeout * Number_Of_APDU_Retries /1000  ,Last_Restore_Time)<=NOW());
	update `objects` SET status = status&5 where  id in (select id from `objects.device` WHERE TIMESTAMPADD(SECOND, APDU_Timeout * Number_Of_APDU_Retries /1000  ,Last_Restore_Time)>NOW());
END//
DELIMITER ;


-- Дамп структуры для процедура vbas.update_watcher
DROP PROCEDURE IF EXISTS `update_watcher`;
DELIMITER //
CREATE PROCEDURE `update_watcher`()
BEGIN
	INSERT INTO watcer_objects (id) 
		select id from `objects.accumulator` where Event_Detection_Enable=1 and id NOT IN (SELECT  id from watcer_objects) union select id from `objects.analog-input` where Event_Detection_Enable=1 and id NOT IN (SELECT  id from watcer_objects) union select id from `objects.analog-output` where Event_Detection_Enable=1 and id NOT IN (SELECT  id from watcer_objects) union select id from `objects.analog-value` where Event_Detection_Enable=1 and id NOT IN (SELECT  id from watcer_objects) union select id from `objects.binary-input` where Event_Detection_Enable=1 and id NOT IN (SELECT  id from watcer_objects) union select id from `objects.binary-output` where Event_Detection_Enable=1 and id NOT IN (SELECT  id from watcer_objects) union select id from `objects.binary-value` where Event_Detection_Enable=1 and id NOT IN (SELECT  id from watcer_objects) union select id from `objects.multi-state-input` where Event_Detection_Enable=1 and id NOT IN (SELECT  id from watcer_objects) union select id from `objects.multi-state-value` where Event_Detection_Enable=1 and id NOT IN (SELECT  id from watcer_objects) union select id from `objects.device` where Event_Detection_Enable=1 and id NOT IN (SELECT  id from watcer_objects);
	DELETE FROM watcer_objects 
		WHERE id not in (select id from `objects.accumulator` where Event_Detection_Enable=1 union select id from `objects.analog-input` where Event_Detection_Enable=1 union select id from `objects.analog-output` where Event_Detection_Enable=1 union select id from `objects.analog-value` where Event_Detection_Enable=1 union select id from `objects.binary-input` where Event_Detection_Enable=1 union select id from `objects.binary-output` where Event_Detection_Enable=1 union select id from `objects.binary-value` where Event_Detection_Enable=1 union select id from `objects.multi-state-input` where Event_Detection_Enable=1 union select id from `objects.multi-state-value` where Event_Detection_Enable=1 union select id from `objects.device` where Event_Detection_Enable=1);
END//
DELIMITER ;


-- Дамп структуры для таблица vbas.users
DROP TABLE IF EXISTS `users`;
CREATE TABLE IF NOT EXISTS `users` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `root` varchar(2048) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.


-- Дамп структуры для таблица vbas._debug
DROP TABLE IF EXISTS `_debug`;
CREATE TABLE IF NOT EXISTS `_debug` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `text` text COLLATE utf8_unicode_ci,
  KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- Экспортируемые данные не выделены.


-- Дамп структуры для триггер vbas.trigger_object_analog_input_change
DROP TRIGGER IF EXISTS `trigger_object_analog_input_change`;
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `trigger_object_analog_input_change` AFTER UPDATE ON `objects.analog-input` FOR EACH ROW BEGIN
	IF OLD.Event_Enable!=NEW.Event_Enable
	OR OLD.Event_Detection_Enable!=NEW.Event_Detection_Enable
	OR OLD.Event_Message_Texts!=NEW.Event_Message_Texts
	OR OLD.Notification_Class!=NEW.Notification_Class
	OR OLD.Low_Limit!=NEW.Low_Limit
	OR OLD.High_Limit!=NEW.High_Limit THEN
		CALL func_prepare_object_topic_info(NEW.id);
	END IF;
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;


-- Дамп структуры для триггер vbas.trigger_object_analog_output_change
DROP TRIGGER IF EXISTS `trigger_object_analog_output_change`;
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `trigger_object_analog_output_change` AFTER UPDATE ON `objects.analog-output` FOR EACH ROW BEGIN
	IF OLD.Event_Enable!=NEW.Event_Enable
	OR OLD.Event_Detection_Enable!=NEW.Event_Detection_Enable
	OR OLD.Event_Message_Texts!=NEW.Event_Message_Texts
	OR OLD.Notification_Class!=NEW.Notification_Class
	OR OLD.Low_Limit!=NEW.Low_Limit
	OR OLD.High_Limit!=NEW.High_Limit THEN
		CALL func_prepare_object_topic_info(NEW.id);
	END IF;
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;


-- Дамп структуры для триггер vbas.trigger_object_analog_value_change
DROP TRIGGER IF EXISTS `trigger_object_analog_value_change`;
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `trigger_object_analog_value_change` AFTER UPDATE ON `objects.analog-value` FOR EACH ROW BEGIN
	IF OLD.Event_Enable!=NEW.Event_Enable
	OR OLD.Event_Detection_Enable!=NEW.Event_Detection_Enable
	OR OLD.Event_Message_Texts!=NEW.Event_Message_Texts
	OR OLD.Notification_Class!=NEW.Notification_Class
	OR OLD.Low_Limit!=NEW.Low_Limit
	OR OLD.High_Limit!=NEW.High_Limit THEN
		CALL func_prepare_object_topic_info(NEW.id);
	END IF;
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;


-- Дамп структуры для триггер vbas.trigger_object_binary_input_change
DROP TRIGGER IF EXISTS `trigger_object_binary_input_change`;
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `trigger_object_binary_input_change` AFTER UPDATE ON `objects.binary-input` FOR EACH ROW BEGIN
	IF OLD.Event_Enable!=NEW.Event_Enable
	OR OLD.Event_Detection_Enable!=NEW.Event_Detection_Enable
	OR OLD.Event_Message_Texts!=NEW.Event_Message_Texts
	OR OLD.Notification_Class!=NEW.Notification_Class
	OR OLD.Alarm_Value!=NEW.Alarm_Value
	OR OLD.Active_Text!=NEW.Active_Text
	OR OLD.Inactive_Text!=NEW.Inactive_Text
	 THEN
		CALL func_prepare_object_topic_info(NEW.id);
	END IF;
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;


-- Дамп структуры для триггер vbas.trigger_object_binary_value_change
DROP TRIGGER IF EXISTS `trigger_object_binary_value_change`;
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `trigger_object_binary_value_change` AFTER UPDATE ON `objects.binary-value` FOR EACH ROW BEGIN
	IF OLD.Event_Enable!=NEW.Event_Enable
	OR OLD.Event_Detection_Enable!=NEW.Event_Detection_Enable
	OR OLD.Event_Message_Texts!=NEW.Event_Message_Texts
	OR OLD.Notification_Class!=NEW.Notification_Class
	OR OLD.Alarm_Value!=NEW.Alarm_Value
	OR OLD.Active_Text!=NEW.Active_Text
	OR OLD.Inactive_Text!=NEW.Inactive_Text
	 THEN
		CALL func_prepare_object_topic_info(NEW.id);
	END IF;
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;


-- Дамп структуры для триггер vbas.trigger_object_change
DROP TRIGGER IF EXISTS `trigger_object_change`;
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `trigger_object_change` AFTER UPDATE ON `objects` FOR EACH ROW BEGIN


	DECLARE notificationId INT;
	DECLARE topicId INT;
	DECLARE topicFaultId INT;
	DECLARE newTopicId INT;
	DECLARE newTopicFaultId INT;
	DECLARE priorityId INT;
	DECLARE faultPriorityId INT;
	DECLARE binaryAlarmValue INT;
	DECLARE analogLowValue FLOAT;
	DECLARE analogHighValue FLOAT;
	DECLARE messageOffnormal 	VARCHAR(250);
	DECLARE messageFault 		VARCHAR(250);
	DECLARE messageNormal 		VARCHAR(250);
	DECLARE parentName 		   VARCHAR(250);
	DECLARE newAnalogBondary BOOL;
	DECLARE oldAnalogBondary BOOL;
	DECLARE yesLoggin        BOOL DEFAULT FALSE;

	DECLARE enableToOffnormal 	INT;
	DECLARE enableToFault 		INT;
	DECLARE enableToNormal 		INT;

	DECLARE userId INT;
	DECLARE logValueId INT;

	IF (NEW.Object_Type=4 -- BI
	OR NEW.Object_Type=6 -- BV
	OR NEW.Object_Type=1 -- AI
	OR NEW.Object_Type=2 -- AO
	OR NEW.Object_Type=3 -- AV
-- 	OR NEW.Object_Type=14 -- MI
-- 	OR NEW.Object_Type=15 -- MO
-- 	OR NEW.Object_Type=20 -- MV
 	OR NEW.Object_Type=9 -- DEVICE
 	) AND (OLD.value != NEW.value OR OLD.status != NEW.status)
	THEN
		SELECT notification_id, topic_id, fault_topic_id, binary_alarm, 	  analog_low,		 analog_high,		parent_name, message_to_offnormal, message_to_fault, message_to_normal, enable_to_offnormal, enable_to_fault,  enable_to_normal FROM object_looks WHERE id=NEW.id
		  INTO notificationId,  topicId,  topicFaultId,   binaryAlarmValue, analogLowValue,  analogHighValue, parentName,  messageOffnormal, 	  messageFault, 	  messageNormal, 		enableToOffnormal, 	enableToFault, 	enableToNormal;
		IF notificationId IS NOT NULL THEN

			SELECT priority_to_offnormal, priority_to_fault FROM object_notification WHERE id=notificationId INTO priorityId, faultPriorityId;
			SELECT id from `vdesk`.`user` WHERE `login`='visiodesk' INTO userId;

			IF priorityId IS NOT NULL AND userId>0 THEN

				-- Если в таблице групп (object_notification_groups) нет ни одной разрешенной группы по каждому из событий - событие не активно (x 3 раза)
				IF enableToOffnormal AND NOT (SELECT to_offnormal FROM object_notification_groups WHERE notification_id=notificationId AND to_offnormal=1 LIMIT 0,1) THEN
					SET enableToOffnormal = 0;
				END IF;

				IF enableToFault AND NOT (SELECT to_fault FROM object_notification_groups WHERE notification_id=notificationId AND to_fault=1 LIMIT 0,1) THEN
					SET enableToFault = 0;
				END IF;

				IF enableToNormal AND NOT (SELECT to_normal FROM object_notification_groups WHERE notification_id=notificationId AND to_normal=1 LIMIT 0,1) THEN
					SET enableToNormal = 0;
				END IF;



			-- FAULT-ы все обрабатываются одинаково, выносим отдельно, возможно перенести вниз
				IF	enableToFault THEN
					IF topicFaultId=0 AND NEW.status&2!=0 AND OLD.status&2=0 THEN
						SET newTopicFaultId = `vdesk`.func_create_topic(parentName, func_replace_NameValueTime(messageFault, new.Object_Name,NEW.value, NEW.timestamp), faultPriorityId, userId);
						UPDATE object_looks SET fault_topic_id=newTopicFaultId WHERE id=NEW.id;
					END IF;

					IF topicFaultId>0 AND NEW.status&2!=0 AND OLD.status&2=0 THEN
						CALL `vdesk`.func_add_topic_item('Сообщение', CONCAT('[p]',func_replace_NameValueTime(messageFault, new.Object_Name,NEW.value, NEW.timestamp),'[/p]'), topicFaultId, 13, userId, NULL, NULL);
					END IF;

					IF topicFaultId>0 AND NEW.status&2=0 AND OLD.status&2!=0 THEN
						CALL `vdesk`.func_add_topic_item('Сообщение', CONCAT('[p]',func_replace_NameValueTime(messageNormal, new.Object_Name,NEW.value, NEW.timestamp),'[/p]'), topicFaultId, 13, userId, NULL, NULL);
					END IF;
				END IF;



			-- BINARY
				IF NEW.Object_Type=4 OR NEW.Object_Type=6 THEN
					-- Выход за границы, топик не создан
					IF enableToOffnormal AND topicId=0 AND NEW.value=binaryAlarmValue AND NEW.value!=OLD.value THEN
						SET newTopicId = `vdesk`.func_create_topic(parentName, func_replace_NameValueTime(messageOffnormal, new.Object_Name,NEW.value, NEW.timestamp), priorityId, userId);
						UPDATE object_looks SET topic_id=newTopicId WHERE id=NEW.id;
					END IF;

					-- Восстановление, топик создан
					IF enableToNormal AND topicId>0 AND NEW.value!=binaryAlarmValue AND NEW.value!=OLD.value THEN
							CALL `vdesk`.func_add_topic_item('Сообщение', CONCAT('[p]',func_replace_NameValueTime(messageNormal, new.Object_Name,NEW.value, NEW.timestamp),'[/p]'), topicId, 13, userId, NULL, NULL);
					END IF;

					-- Выход за границы, топик создан
					IF enableToOffnormal AND topicId>0 AND NEW.value=binaryAlarmValue AND NEW.value!=OLD.value THEN
							CALL `vdesk`.func_add_topic_item('Сообщение', CONCAT('[p]',func_replace_NameValueTime(messageOffnormal, new.Object_Name,NEW.value, NEW.timestamp),'[/p]'), topicId, 13, userId, NULL, NULL);
					END IF;

				END IF; -- Binary



			-- ANALOG
				IF NEW.Object_Type=1 OR NEW.Object_Type=2 OR NEW.Object_Type=3 THEN

					SET oldAnalogBondary = OLD.value>=analogLowValue AND OLD.value<=analogHighValue;
					SET newAnalogBondary = NEW.value>=analogLowValue AND NEW.value<=analogHighValue;

					-- Выход за границы, топик не создан, раньше в границах
					IF enableToOffnormal AND topicId=0 AND NEW.value<analogLowValue AND oldAnalogBondary THEN
							SET newTopicId = `vdesk`.func_create_topic(parentName, func_replace_NameValueTime(messageOffnormal, new.Object_Name,NEW.value, NEW.timestamp), priorityId, userId);
							UPDATE object_looks SET topic_id=newTopicId WHERE id=NEW.id;
					END IF;

					-- Выход за границы, топик не создан, раньше в границах
					IF enableToOffnormal AND topicId=0 AND NEW.value>analogHighValue AND oldAnalogBondary THEN
							SET newTopicId = `vdesk`.func_create_topic(parentName, func_replace_NameValueTime(messageOffnormal, new.Object_Name,NEW.value, NEW.timestamp), priorityId, userId);
							UPDATE object_looks SET topic_id=newTopicId WHERE id=NEW.id;
					END IF;

					-- Восстановление, топик создан
					IF enableToNormal AND topicId>0 AND newAnalogBondary AND NOT oldAnalogBondary THEN
							CALL `vdesk`.func_add_topic_item('Сообщение', CONCAT('[p]',func_replace_NameValueTime(messageNormal, new.Object_Name,NEW.value, NEW.timestamp),'[/p]'), topicId, 13, userId, NULL, NULL);
					END IF;

					-- Выход за границы, топик создан
					IF enableToOffnormal AND topicId>0 AND NOT newAnalogBondary AND oldAnalogBondary THEN
							CALL `vdesk`.func_add_topic_item('Сообщение', CONCAT('[p]',func_replace_NameValueTime(messageOffnormal, new.Object_Name,NEW.value, NEW.timestamp),'[/p]'), topicId, 13, userId, NULL, NULL);
					END IF;
				END IF;



				IF newTopicId>0 THEN
					CALL func_link_topic_to_notify_groups_offnormal(newTopicId, notificationId);
				END IF;

				IF newTopicFaultId>0 THEN
					CALL func_link_topic_to_notify_groups_fault(newTopicFaultId, notificationId);
				END IF;

			END IF; -- priorityId
		END IF; -- notificationId
	END IF; -- type 1,2,3,4,6,...


--  Логгирование 1,2,3,4,5,6,14,15,20



	IF  NEW.Log_Enable=1 THEN


	    CASE NEW.Object_Type
	    WHEN 'analog-input' THEN
            IF (SELECT id from `objects.analog-input` WHERE id=NEW.id AND (last_log_value IS NULL OR ABS(NEW.value-last_log_value)>=IFNULL(COV_Increment, 1))) THEN
			    SET yesLoggin = TRUE;
--                INSERT INTO `log`.`trendlog` (`value`,`status`, `device_id`, `Object_Identifier`,`Object_Type`) VALUES (NEW.value, NEW.status, NEW.device_id, NEW.Object_Identifier, NEW.Object_Type);
                UPDATE `objects.analog-input` SET `objects.analog-input`.last_log_value=NEW.value WHERE id=NEW.id;
            END IF;

	    WHEN 'analog-output' THEN
            IF (SELECT id from `objects.analog-output` WHERE id=NEW.id AND (last_log_value IS NULL OR ABS(NEW.value-last_log_value)>=IFNULL(COV_Increment, 1))) THEN
			    SET yesLoggin = TRUE;
--                INSERT INTO `log`.`trendlog` (`value`,`status`, `device_id`, `Object_Identifier`,`Object_Type`) VALUES (NEW.value, NEW.status, NEW.device_id, NEW.Object_Identifier, NEW.Object_Type);
                UPDATE `objects.analog-output` SET `objects.analog-output`.last_log_value=NEW.value WHERE id=NEW.id;
            END IF;

	    WHEN 'analog-value' THEN
            IF (SELECT id from `objects.analog-value` WHERE id=NEW.id AND (last_log_value IS NULL OR ABS(NEW.value-last_log_value)>=IFNULL(COV_Increment, 1))) THEN
			    SET yesLoggin = TRUE;
--                INSERT INTO `log`.`trendlog` (`value`,`status`, `device_id`, `Object_Identifier`,`Object_Type`) VALUES (NEW.value, NEW.status, NEW.device_id, NEW.Object_Identifier, NEW.Object_Type);
                UPDATE `objects.analog-value` SET `objects.analog-value`.last_log_value=NEW.value WHERE id=NEW.id;
            END IF;
        ELSE
            IF NEW.value!=OLD.value OR NEW.status!=OLD.status THEN
			    SET yesLoggin = TRUE;
--                 INSERT INTO `log`.`trendlog` (`value`,`status`, `device_id`, `Object_Identifier`,`Object_Type`) VALUES (NEW.value, NEW.status, NEW.device_id, NEW.Object_Identifier, NEW.Object_Type);
            END IF;
        END CASE;
-- logValueId
        IF yesLoggin THEN
            SELECT id FROM `log`.`objects_value` WHERE device_id=NEW.device_id AND Object_Identifier=NEW.Object_Identifier AND Object_Type=NEW.Object_Type INTO logValueId;
            IF logValueId>0 THEN
                UPDATE `log`.`objects_value` SET `value`=NEW.value, `status`=NEW.status WHERE id=logValueId;
            ELSE
                INSERT INTO `log`.`objects_value` (`value`,`status`, `device_id`, `Object_Identifier`,`Object_Type`) VALUES (NEW.value, NEW.status, NEW.device_id, NEW.Object_Identifier, NEW.Object_Type);
            END IF;
        END IF;
	END IF;


END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;


-- Дамп структуры для триггер vbas.trigger_object_device_change
DROP TRIGGER IF EXISTS `trigger_object_device_change`;
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `trigger_object_device_change` AFTER UPDATE ON `objects.device` FOR EACH ROW BEGIN
	IF OLD.Event_Enable!=NEW.Event_Enable
	OR OLD.Event_Detection_Enable!=NEW.Event_Detection_Enable
	OR OLD.Event_Message_Texts!=NEW.Event_Message_Texts
	OR OLD.Notification_Class!=NEW.Notification_Class
	 THEN
		CALL func_prepare_object_topic_info(NEW.id);
	END IF;
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;


-- Дамп структуры базы данных vdesk
DROP DATABASE IF EXISTS `vdesk`;
CREATE DATABASE IF NOT EXISTS `vdesk` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `vdesk`;





-- Дамп структуры для таблица vdesk.access_rights
DROP TABLE IF EXISTS `access_rights`;
CREATE TABLE IF NOT EXISTS `access_rights` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` enum('CREATE_EVENT','EDIT_EVENT','ADMIN_EVENT','ADMIN_PRIORITY','ADMIN_USERS_GROUPS') DEFAULT NULL,
  `full_name` varchar(256) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.


-- Дамп структуры для таблица vdesk.action
DROP TABLE IF EXISTS `action`;
CREATE TABLE IF NOT EXISTS `action` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `title` varchar(45) DEFAULT NULL,
  `status_id` int(11) DEFAULT NULL,
  `priority_id` int(11) DEFAULT NULL,
  `type_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `group_id` int(11) DEFAULT NULL,
  `location_id` int(11) DEFAULT NULL,
  `report_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  KEY `fk_action_status_idx` (`status_id`),
  KEY `fk_action_priority_idx` (`priority_id`),
  KEY `fk_action_type_idx` (`type_id`),
  KEY `fk_action_user_idx` (`user_id`),
  KEY `fk_action_location_idx` (`location_id`),
  KEY `fk_action_group_idx` (`group_id`),
  CONSTRAINT `fk_action_group` FOREIGN KEY (`group_id`) REFERENCES `group` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_action_location` FOREIGN KEY (`location_id`) REFERENCES `location` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_action_priority` FOREIGN KEY (`priority_id`) REFERENCES `priority` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_action_status` FOREIGN KEY (`status_id`) REFERENCES `status` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_action_type` FOREIGN KEY (`type_id`) REFERENCES `type` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_action_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.


-- Дамп структуры для таблица vdesk.bind_access_rights
DROP TABLE IF EXISTS `bind_access_rights`;
CREATE TABLE IF NOT EXISTS `bind_access_rights` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `group_id` int(11) DEFAULT NULL,
  `right_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  KEY `fk_bind_access_rights_user_idx` (`user_id`),
  KEY `fk_bind_access_rights_group_idx` (`group_id`),
  KEY `fk_bind_access_rights_right_idx` (`right_id`),
  CONSTRAINT `fk_bind_access_rights_group` FOREIGN KEY (`group_id`) REFERENCES `group` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_bind_access_rights_right` FOREIGN KEY (`right_id`) REFERENCES `access_rights` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_bind_access_rights_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.


-- Дамп структуры для таблица vdesk.bind_topic_all
DROP TABLE IF EXISTS `bind_topic_all`;
CREATE TABLE IF NOT EXISTS `bind_topic_all` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `topic_id` int(11) NOT NULL,
  `object_id` int(11) DEFAULT NULL,
  `type` varchar(128) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  KEY `topic_id_idx` (`topic_id`),
  KEY `object_id_idx` (`object_id`),
  KEY `type_idx` (`type`),
  CONSTRAINT `fk_topic_all_idx` FOREIGN KEY (`topic_id`) REFERENCES `topic` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.


-- Дамп структуры для таблица vdesk.bind_topic_group
DROP TABLE IF EXISTS `bind_topic_group`;
CREATE TABLE IF NOT EXISTS `bind_topic_group` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) NOT NULL,
  `topic_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  KEY `fk_bind_topic_group_1_idx` (`topic_id`),
  KEY `fk_bind_topic_group_2_idx` (`group_id`),
  CONSTRAINT `fk_bind_topic_group_1` FOREIGN KEY (`topic_id`) REFERENCES `topic` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_bind_topic_group_2` FOREIGN KEY (`group_id`) REFERENCES `group` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.


-- Дамп структуры для таблица vdesk.bind_topic_user
DROP TABLE IF EXISTS `bind_topic_user`;
CREATE TABLE IF NOT EXISTS `bind_topic_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `topic_id` int(11) NOT NULL,
  `binded_at` datetime DEFAULT NULL,
  `unbinded_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  KEY `fk_bind_topic_user_1_idx` (`topic_id`),
  KEY `fk_bind_topic_user_2_idx` (`user_id`),
  CONSTRAINT `fk_bind_topic_user_1` FOREIGN KEY (`topic_id`) REFERENCES `topic` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_bind_topic_user_2` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.


-- Дамп структуры для таблица vdesk.bind_user_group
DROP TABLE IF EXISTS `bind_user_group`;
CREATE TABLE IF NOT EXISTS `bind_user_group` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL,
  `support_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_user_group_user_idx` (`user_id`),
  KEY `fk_user_group_group_idx` (`group_id`),
  KEY `fk_user_group_support_idx` (`support_id`),
  CONSTRAINT `fk_user_group_group` FOREIGN KEY (`group_id`) REFERENCES `group` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_user_group_support` FOREIGN KEY (`support_id`) REFERENCES `support_level` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_user_group_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.


-- Дамп структуры для таблица vdesk.check
DROP TABLE IF EXISTS `check`;
CREATE TABLE IF NOT EXISTS `check` (
  `id` int(11) NOT NULL,
  `created_at` datetime NOT NULL,
  `dontfollow_at` datetime DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  `topic_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  KEY `fk_check_user_idx` (`user_id`),
  KEY `fk_check_topic_idx` (`topic_id`),
  CONSTRAINT `fk_check_topic` FOREIGN KEY (`topic_id`) REFERENCES `topic` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_check_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.


-- Дамп структуры для таблица vdesk.check_list
DROP TABLE IF EXISTS `check_list`;
CREATE TABLE IF NOT EXISTS `check_list` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`root_id` INT(11) NULL DEFAULT NULL,
	`parent_id` INT(11) NULL DEFAULT NULL,
	`unique_number` INT(11) NULL DEFAULT NULL,
	`name` VARCHAR(128) NULL DEFAULT NULL,
	`description` VARCHAR(1024) NULL DEFAULT NULL,
	`object` VARCHAR(1024) NULL DEFAULT NULL,
	`check_date` DATETIME NULL DEFAULT NULL,
	`check_period` INT(11) NULL DEFAULT NULL,
	`check_status` INT(11) NULL DEFAULT NULL,
	`check_percent` INT(11) NULL DEFAULT NULL,
	`group_id` INT(11) NULL DEFAULT NULL,
	`client_id` INT(11) NULL DEFAULT NULL,
	`type` VARCHAR(128) NULL DEFAULT NULL,
	`user_id` INT(11) NULL DEFAULT NULL,
	`count_closed` INT(11) NOT NULL DEFAULT '0',
	`count_resolved` INT(11) NOT NULL DEFAULT '0',
	`count_on_hold` INT(11) NOT NULL DEFAULT '0',
	`count_in_progress` INT(11) NOT NULL DEFAULT '0',
	`count_created` INT(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  KEY `fk_clist_client_idx` (`client_id`),
  CONSTRAINT `fk_clist_client` FOREIGN KEY (`client_id`) REFERENCES `client` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.


-- Дамп структуры для таблица vdesk.check_list_item
DROP TABLE IF EXISTS `check_list_item`;
CREATE TABLE IF NOT EXISTS `check_list_item` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `check_date` datetime DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  `clist_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  KEY `fk_clist_item_user_idx` (`user_id`),
  KEY `fk_clist_item_clist_idx` (`clist_id`),
  CONSTRAINT `fk_clist_item_clist` FOREIGN KEY (`clist_id`) REFERENCES `check_list` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_clist_item_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.


-- Дамп структуры для таблица vdesk.client
DROP TABLE IF EXISTS `client`;
CREATE TABLE IF NOT EXISTS `client` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `client` varchar(128) DEFAULT NULL,
  `contract_type` varchar(128) DEFAULT NULL,
  `contract_name` varchar(256) DEFAULT NULL,
  `contract_date_start` datetime DEFAULT NULL,
  `contract_date_end` datetime DEFAULT NULL,
  `user_count` int(11) NOT NULL,
  `active_user_count` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.


-- Дамп структуры для функция vdesk.func_add_topic
DROP FUNCTION IF EXISTS `func_add_topic`;
DELIMITER //
CREATE FUNCTION `func_add_topic`(`topicName` VARCHAR(250), `description` VARCHAR(250), `user_id` INT, `priority_id` INT) RETURNS int(11) DETERMINISTIC
    COMMENT 'Добавление записи в таблицу topic'
BEGIN
	DECLARE topicId INT;
	INSERT INTO `vdesk`.`topic` (
		`name`,
		`description`,
		`author_id`,
		`created_at`,
		`terminated_to`,
		`client_id`,
		`status_id`,
		`priority_id`,
		`closed`,
		`topic_type_id`
		) VALUES (
			topicName,
			CONCAT('[p]', description, '[/p]'),
			user_id,
			NOW(),
			DATE_ADD(NOW(), INTERVAL 1 DAY),
			1,
			1,
			priority_id,
			0,
			2
			);
	SET topicId = LAST_INSERT_ID();
-- 	INSERT INTO `vdesk`.`bind_topic_group` (group_id, topic_id) VALUES (1, topicId);
	RETURN topicId;
END//
DELIMITER ;


-- Дамп структуры для процедура vdesk.func_add_topic_item
DROP PROCEDURE IF EXISTS `func_add_topic_item`;
DELIMITER //
CREATE PROCEDURE `func_add_topic_item`(
		IN `itemName` VARCHAR(250),
		IN `itemText` VARCHAR(250),
		IN `topic_id` INT,
		IN `type_id` INT,
		IN `user_id` INT,
		IN `status_id` INT,
		IN `priority_id` INT)
    COMMENT 'Добавление записи в таблицу topic_item'
BEGIN
	INSERT INTO `topic_item` (
		`created_at`,
		`type_id`,
		`topic_id`,
		`author_id`,
		`status_id`,
		`priority_id`,
		`name`,
		`text`
	) VALUES (
		NOW(),
		type_id,
		topic_id,
		user_id,
		status_id,
		priority_id,
		itemName,
		itemText
	);
END//
DELIMITER ;



-- Дамп структуры для функция vdesk.func_create_topic
DROP FUNCTION IF EXISTS `func_create_topic`;
DELIMITER //
CREATE FUNCTION `func_create_topic`(
	`name` VARCHAR(50),
	`description` VARCHAR(250),
	`priorityId` INT,
	`userId` INT
	) RETURNS int(11) DETERMINISTIC
    COMMENT 'Создание типового топика с необходимыми  topic_item'
BEGIN
	DECLARE topicId INT;
	DECLARE priotityName VARCHAR(64);
	DECLARE priotityTitle VARCHAR(64);


	SET topicId = func_add_topic(name, description, userId, priorityId);

  	SELECT `priority`.name, `priority`.title FROM `priority` WHERE id=priorityId INTO  priotityName, priotityTitle;

	CALL func_add_topic_item('Новая',		'new', topicId,  6, userId, 1);
 	CALL func_add_topic_item(priotityTitle, priotityName , topicId,  5, userId, NULL);
 	CALL func_add_topic_item('Сообщение', CONCAT('[p]', description, '[/p]'), topicId, 13, userId, NULL);

	RETURN topicId;
END//
DELIMITER ;



use `vdesk`;


DROP EVENT IF EXISTS `event_chech_topic_hold_to`;
DELIMITER //
CREATE  EVENT `event_chech_topic_hold_to`
	ON SCHEDULE
		EVERY 15 SECOND STARTS '2021-02-01 11:39:54'
	ON COMPLETION NOT PRESERVE
	ENABLE
	COMMENT 'Проверяет не нужно ли сменить статус (не закончился ли срок выпо'
	DO BEGIN
	DECLARE topicId INT;
	DECLARE prevId INT;
	DECLARE statusId INT;
	DECLARE authorId INT;

	DECLARE userId INT DEFAULT NULL;

	DECLARE flag INT DEFAULT 0;
	DECLARE cur CURSOR FOR SELECT DISTINCT id, status_id, author_id FROM `topic` WHERE hold_to<NOW() AND status_id IN(1, 3, 4, 5);
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET flag = 1;

	OPEN cur;

	WHILE flag = 0 DO
		FETCH cur INTO topicId, statusId, authorId;
			IF flag=0 THEN

		    CASE statusId
		    	WHEN 1 THEN
		    		CALL vbas.func_debug( CONCAT("Должен быть взят в работу топик #", topicId));
					CALL func_change_topic_status_by_system(topicId, 1,  1000*UNIX_TIMESTAMP( func_get_topic_hold_to_settings(topicId, 1)) );

		    	WHEN 3 THEN
--  		    		CALL vbas.func_debug( CONCAT("Должен быть сделан топик #", topicId ) );
 		    		CALL vbas.func_debug( CONCAT("Должен быть взят в работу топик #", topicId ) );
					CALL func_change_topic_status_by_system(topicId, 1,  1000*UNIX_TIMESTAMP( func_get_topic_hold_to_settings(topicId, 1)) ) ;

		    	WHEN 4 THEN
		    		CALL vbas.func_debug( CONCAT("Стал новым #", topicId));
					CALL func_change_topic_status_by_system(topicId, 1, 1000*UNIX_TIMESTAMP( func_get_topic_hold_to_settings(topicId, 1))  );

		    	WHEN 5 THEN
		    		CALL vbas.func_debug( CONCAT("Должен быть проверен топик #", topicId));
					CALL func_change_topic_status_by_system(topicId, 5, 1000*UNIX_TIMESTAMP( func_get_topic_hold_to_settings(topicId, 5))  );
			END CASE;

		END IF;
	END WHILE;

	CLOSE cur;
END//
DELIMITER ;






DROP PROCEDURE IF EXISTS `func_change_topic_status_by_system`;
DELIMITER //
CREATE PROCEDURE `func_change_topic_status_by_system`(IN `topicId` INT, IN `statusId` INT, IN `holdMills` BIGINT)
	LANGUAGE SQL
	DETERMINISTIC
	CONTAINS SQL
	SQL SECURITY DEFINER
	COMMENT ''
BEGIN
	DECLARE userId INT;
	DECLARE insId INT;
	DECLARE statusName VARCHAR(50);

	CALL vbas.func_debug( CONCAT("func_change_topic_status_by_system #", topicId, " hm:", holdMills));

	SELECT name FROM `status` WHERE id=statusId INTO statusName;

	SELECT id FROM `user` WHERE login='visiodesk' INTO userId;

	CALL vbas.func_debug( CONCAT("visiodesk user #", userId));

	IF userId IS NULL THEN
		SELECT author_id FROM `topic` WHERE id=topicId INTO userId;
		CALL vbas.func_debug( CONCAT("topic(!vd) user #", userId));
	ELSE
		CALL vbas.func_debug( CONCAT("Польззователь найден: ", userId));
	END IF;

	INSERT INTO `topic_item` (`created_at`,`type_id`, `liked`, `topic_id`,`author_id`,`status_id`,`name`,`text`, hold_millis) VALUES (NOW(), 6, 0, topicId, userId, statusId, "Изменение статуса системой", statusName, holdMills);

	SELECT LAST_INSERT_ID() INTO insId;

	CALL vbas.func_debug( CONCAT("LAST_INSERT_ID #", insId));

	-- UPDATE topic SET hold_to=NULL WHERE id=topicId;
END//
DELIMITER ;


DROP FUNCTION IF EXISTS `func_get_topic_hold_to_settings`;
DELIMITER //
CREATE FUNCTION `func_get_topic_hold_to_settings`(`topicId` INT, `statusId` INT)
	RETURNS datetime
	LANGUAGE SQL
	DETERMINISTIC
	CONTAINS SQL
	SQL SECURITY DEFINER
	COMMENT ''
BEGIN
	DECLARE priorityId INT;
	DECLARE time_minutes INT;
	SELECT priority_id FROM topic WHERE id=topicId INTO priorityId;

	CASE statusId
		WHEN 1 THEN
		 	SELECT plan_inwork FROM priority_group WHERE group_id IN (SELECT group_id FROM bind_topic_group WHERE topic_id=topicId) AND priority_id=priorityId ORDER BY plan_inwork LIMIT 0, 1 INTO time_minutes;
		 	IF time_minutes IS NULL THEN
		 		SELECT plan_inwork FROM priority WHERE id=priorityId INTO time_minutes;
			END IF;

		WHEN 3 THEN
		 	SELECT plan_ready FROM priority_group WHERE group_id IN (SELECT group_id FROM bind_topic_group WHERE topic_id=topicId) AND priority_id=priorityId ORDER BY plan_ready LIMIT 0, 1 INTO time_minutes;
		 	IF time_minutes IS NULL THEN
		 		SELECT plan_ready FROM priority WHERE id=priorityId INTO time_minutes;
			END IF;

		WHEN 4 THEN
		 	SELECT plan_inwork FROM priority_group WHERE group_id IN (SELECT group_id FROM bind_topic_group WHERE topic_id=topicId) AND priority_id=priorityId ORDER BY plan_inwork LIMIT 0, 1 INTO time_minutes;
		 	IF time_minutes IS NULL THEN
		 		SELECT plan_inwork FROM priority WHERE id=priorityId INTO time_minutes;
			END IF;

		WHEN 5 THEN
		 	SELECT plan_verify FROM priority_group WHERE group_id IN (SELECT group_id FROM bind_topic_group WHERE topic_id=topicId) AND priority_id=priorityId ORDER BY plan_verify LIMIT 0, 1 INTO time_minutes;
		 	IF time_minutes IS NULL THEN
		 		SELECT plan_verify FROM priority WHERE id=priorityId INTO time_minutes;
			END IF;
	END CASE;



	RETURN DATE_ADD(NOW(), INTERVAL time_minutes MINUTE);
END//
DELIMITER ;












-- Дамп структуры для таблица vdesk.group
DROP TABLE IF EXISTS `group`;
CREATE TABLE IF NOT EXISTS `group` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL,
  `description` varchar(256) DEFAULT NULL,
  `parent_id` int(11) NOT NULL,
  `client_id` int(11) NOT NULL,
  `dismissed` datetime DEFAULT NULL,
  `master_group` tinyint(1) NOT NULL,
  `percent_support2` int(11) DEFAULT NULL,
  `percent_support3` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.


-- Дамп структуры для таблица vdesk.holdover
DROP TABLE IF EXISTS `holdover`;
CREATE TABLE IF NOT EXISTS `holdover` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `func_id` int(11) NOT NULL DEFAULT '0',
  `param1` int(11) NOT NULL DEFAULT '0',
  `param2` int(11) NOT NULL DEFAULT '0',
  `param3` int(11) NOT NULL DEFAULT '0',
  `param4` int(11) NOT NULL DEFAULT '0',
  `param5` int(11) NOT NULL DEFAULT '0',
  `date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Отложенные вызовы';

-- Экспортируемые данные не выделены.


-- Дамп структуры для таблица vdesk.location
DROP TABLE IF EXISTS `location`;
CREATE TABLE IF NOT EXISTS `location` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL,
  `template` varchar(128) DEFAULT NULL,
  `x` double DEFAULT NULL,
  `y` double DEFAULT NULL,
  `z` varchar(128) DEFAULT NULL,
  `topic_item_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  KEY `fk_location_topic_item_idx` (`topic_item_id`),
  CONSTRAINT `fk_location_topic_item` FOREIGN KEY (`topic_item_id`) REFERENCES `topic_item` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.


-- Дамп структуры для таблица vdesk.priority
DROP TABLE IF EXISTS `priority`;
CREATE TABLE IF NOT EXISTS `priority` (
  `id` int(11) NOT NULL,
  `name` varchar(64) NOT NULL,
  `title` varchar(64) NOT NULL,
  `color` varchar(9) DEFAULT NULL,
  `hour_plan` int(11) NOT NULL,
  `hour_notify_support_2` int(11) NOT NULL,
  `hour_notify_support_3` int(11) NOT NULL,
  `plan_inwork` int(11) NOT NULL,
  `plan_ready` int(11) NOT NULL,
  `plan_verify` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  UNIQUE KEY `name_UNIQUE` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.


-- Дамп структуры для таблица vdesk.priority_group
DROP TABLE IF EXISTS `priority_group`;
CREATE TABLE IF NOT EXISTS `priority_group` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) DEFAULT NULL,
  `priority_id` int(11) NOT NULL,
  `plan_inwork` int(11) NOT NULL,
  `plan_ready` int(11) NOT NULL,
  `plan_verify` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  KEY `fk_pg_group_idx` (`group_id`),
  KEY `fk_pg_priority_idx` (`priority_id`),
  CONSTRAINT `fk_pg_group` FOREIGN KEY (`group_id`) REFERENCES `group` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_pg_priority` FOREIGN KEY (`priority_id`) REFERENCES `priority` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.


-- Дамп структуры для таблица vdesk.problem
DROP TABLE IF EXISTS `problem`;
CREATE TABLE IF NOT EXISTS `problem` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parent_id` int(11) NOT NULL,
  `name` varchar(128) NOT NULL,
  `description` varchar(1024) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `priority_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  KEY `fk_problem_prior_idx` (`priority_id`),
  CONSTRAINT `fk_problem_prior` FOREIGN KEY (`priority_id`) REFERENCES `priority` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.


-- Дамп структуры для таблица vdesk.report
DROP TABLE IF EXISTS `report`;
CREATE TABLE IF NOT EXISTS `report` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `object_name` varchar(512) NOT NULL,
  `name` varchar(128) NOT NULL,
  `description` varchar(512) DEFAULT NULL,
  `check_period_1` int(11) NOT NULL,
  `check_period_2` int(11) DEFAULT NULL,
  `check_period_3` int(11) DEFAULT NULL,
  `check_period_max` int(11) DEFAULT NULL,
  `location_id` int(11) DEFAULT NULL,
  `group_id` int(11) DEFAULT NULL,
  `default_timeout_group_id` int(11) NOT NULL,
  `default_timeout_priority_id` int(11) NOT NULL,
  `default_timeout_topic_name` varchar(128) NOT NULL,
  `default_timeout_topic_description` varchar(256) DEFAULT NULL,
  `prefix` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  KEY `fk_report_group_idx` (`group_id`),
  KEY `fk_report_location_idx` (`location_id`),
  CONSTRAINT `fk_report_group` FOREIGN KEY (`group_id`) REFERENCES `group` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_report_location` FOREIGN KEY (`location_id`) REFERENCES `location` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.


-- Дамп структуры для таблица vdesk.report_item
DROP TABLE IF EXISTS `report_item`;
CREATE TABLE IF NOT EXISTS `report_item` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `check_date` datetime NOT NULL,
  `topic_id` int(11) DEFAULT NULL,
  `type_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  KEY `fk_report_item_type_idx` (`type_id`),
  KEY `index_topic` (`topic_id`),
  KEY `fk_report_item_user_idx` (`user_id`),
  CONSTRAINT `fk_report_item_type` FOREIGN KEY (`type_id`) REFERENCES `type` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_report_item_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.


-- Дамп структуры для таблица vdesk.status
DROP TABLE IF EXISTS `status`;
CREATE TABLE IF NOT EXISTS `status` (
  `id` int(11) NOT NULL,
  `name` varchar(64) NOT NULL,
  `title` varchar(64) NOT NULL,
  `cancel_notify_2` tinyint(1) DEFAULT NULL,
  `cancel_notify_3` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.


-- Дамп структуры для таблица vdesk.support_level
DROP TABLE IF EXISTS `support_level`;
CREATE TABLE IF NOT EXISTS `support_level` (
  `id` int(11) NOT NULL,
  `name` varchar(96) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  UNIQUE KEY `name_UNIQUE` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.


-- Дамп структуры для таблица vdesk.topic
DROP TABLE IF EXISTS `topic`;
CREATE TABLE IF NOT EXISTS `topic` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL,
  `description` text,
  `external` varchar(100) DEFAULT NULL,
  `level` varchar(10) DEFAULT NULL,
  `timeout` int(11) NOT NULL DEFAULT '0',
  `time_ok` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `removed_at` datetime DEFAULT NULL,
  `terminated_to` datetime NOT NULL,
  `closed` tinyint(1) DEFAULT NULL,
  `problem_id` int(11) DEFAULT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `client_id` int(11) NOT NULL,
  `author_id` int(11) NOT NULL,
  `topic_type_id` int(11) DEFAULT NULL,
  `hold_to` datetime DEFAULT NULL,
  `status_id` int(11) NOT NULL DEFAULT '0',
  `priority_id` int(11) NOT NULL DEFAULT '0',
  `to_trigger` tinyint(1) DEFAULT '0',
  `last_item_id` int(11) DEFAULT '0',
  `proceed_item_id` int(11) DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  KEY `fk_incident_problem_idx` (`problem_id`),
  KEY `fk_topic_client_idx` (`client_id`),
  KEY `index_author` (`author_id`),
  KEY `fk_topic_type_idx` (`topic_type_id`),
  KEY `status` (`status_id`),
  KEY `external` (`external`),
  CONSTRAINT `fk_topic_client` FOREIGN KEY (`client_id`) REFERENCES `client` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_topic_problem` FOREIGN KEY (`problem_id`) REFERENCES `problem` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_topic_type` FOREIGN KEY (`topic_type_id`) REFERENCES `topic_type` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.


-- Дамп структуры для таблица vdesk.topic_item
DROP TABLE IF EXISTS `topic_item`;
CREATE TABLE IF NOT EXISTS `topic_item` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `text` text,
  `name` varchar(128) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `removed_at` datetime DEFAULT NULL,
  `topic_id` int(11) NOT NULL,
  `type_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `group_id` int(11) DEFAULT NULL,
  `author_id` int(11) NOT NULL,
  `parent_item_id` int(11) DEFAULT NULL,
  `liked` int(11) DEFAULT NULL,
  `status_id` int(11) DEFAULT NULL,
  `priority_id` int(11) DEFAULT NULL,
  `file_client_size` bigint(20) DEFAULT NULL,
  `hold_millis` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  KEY `fk_topic_item_topic_idx` (`topic_id`),
  KEY `fk_topic_item_type_idx` (`type_id`),
  KEY `fk_topic_item_author_idx` (`author_id`),
  KEY `fk_topic_item_status_idx` (`status_id`),
  KEY `fk_topic_item_priority` (`priority_id`),
  CONSTRAINT `fk_topic_item_author` FOREIGN KEY (`author_id`) REFERENCES `user` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_topic_item_priority` FOREIGN KEY (`priority_id`) REFERENCES `priority` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_topic_item_status` FOREIGN KEY (`status_id`) REFERENCES `status` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_topic_item_topic` FOREIGN KEY (`topic_id`) REFERENCES `topic` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_topic_item_type` FOREIGN KEY (`type_id`) REFERENCES `type` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.


-- Дамп структуры для таблица vdesk.topic_type
DROP TABLE IF EXISTS `topic_type`;
CREATE TABLE IF NOT EXISTS `topic_type` (
  `id` int(11) NOT NULL,
  `name` varchar(64) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.


-- Дамп структуры для таблица vdesk.type
DROP TABLE IF EXISTS `type`;
CREATE TABLE IF NOT EXISTS `type` (
  `id` int(11) NOT NULL,
  `name` varchar(45) DEFAULT NULL,
  `title` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.


-- Дамп структуры для таблица vdesk.user
DROP TABLE IF EXISTS `user`;
CREATE TABLE IF NOT EXISTS `user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `first_name` varchar(128) NOT NULL,
  `last_name` varchar(128) DEFAULT NULL,
  `login` varchar(45) NOT NULL,
  `pass_hash` varchar(64) NOT NULL,
  `token` varchar(128) DEFAULT NULL,
  `client_id` int(11) NOT NULL,
  `position` varchar(512) DEFAULT NULL,
  `dismissed` datetime DEFAULT NULL,
  `phone` varchar(45) DEFAULT NULL,
  `user_name` varchar(45) DEFAULT NULL,
  `sms_code` varchar(6) DEFAULT NULL,
  `middle_name` varchar(45) DEFAULT NULL,
  `user_type_id` int(11) DEFAULT NULL,
  `tmp_hash` varchar(64) DEFAULT NULL,
  `link_used` tinyint(1) DEFAULT NULL,
  `avatar` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  KEY `fk_user_client_idx` (`client_id`),
  KEY `fk_user_type_idx` (`user_type_id`),
  CONSTRAINT `fk_user_client` FOREIGN KEY (`client_id`) REFERENCES `client` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_user_type` FOREIGN KEY (`user_type_id`) REFERENCES `user_type` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.


-- Дамп структуры для таблица vdesk.user_topic_subscribe
DROP TABLE IF EXISTS `user_topic_subscribe`;
CREATE TABLE IF NOT EXISTS `user_topic_subscribe` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT '0',
  `topic_id` int(11) DEFAULT '0',
  `create_date` datetime DEFAULT NULL,
  `closed` tinyint(1) DEFAULT '0',
  `on_hold` tinyint(1) DEFAULT '0',
  `changed` tinyint(1) DEFAULT '0',
  `is_author` tinyint(1) DEFAULT '0',
  `is_inwork` tinyint(1) DEFAULT '0',
  `is_binded` tinyint(1) DEFAULT '0',
  `is_group` tinyint(1) DEFAULT '0',
  `group_id` int(11) DEFAULT '0',
  `support_level` int(11) DEFAULT '0',
  `support_date` datetime DEFAULT NULL,
  `checked_id` int(11) DEFAULT '0',
  `last_id` int(11) DEFAULT '0',
  `last_status_item_id` int(11) DEFAULT '0',
  `push_last_status_item_id` int(11) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.


-- Дамп структуры для таблица vdesk.user_type
DROP TABLE IF EXISTS `user_type`;
CREATE TABLE IF NOT EXISTS `user_type` (
  `id` int(11) NOT NULL,
  `name` varchar(64) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.


-- Дамп структуры для триггер vdesk.topic_before_update
DROP TRIGGER IF EXISTS `topic_before_update`;
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `topic_before_update` BEFORE UPDATE ON `topic` FOR EACH ROW BEGIN
	IF NEW.last_item_id<OLD.last_item_id THEN
		SET  NEW.last_item_id =  OLD.last_item_id;
	END IF;
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;


-- Дамп структуры для триггер vdesk.trigger_after_update_topic_item
DROP TRIGGER IF EXISTS `trigger_after_update_topic_item`;
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `trigger_after_update_topic_item` AFTER UPDATE ON `topic_item` FOR EACH ROW BEGIN
-- 	UPDATE `vdesk`.`topic` SET `topic`.last_item_id=NEW.id WHERE `topic`.id=NEW.topic_id AND `topic`.last_item_id < NEW.id;
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;


-- Дамп структуры для триггер vdesk.trigger_topic_after_insert
DROP TRIGGER IF EXISTS `trigger_topic_after_insert`;
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `trigger_topic_after_insert` AFTER INSERT ON `topic` FOR EACH ROW BEGIN
	INSERT INTO `vdesk`.`holdover` (func_id, param1) VALUES (110, NEW.id);
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;


-- Дамп структуры для триггер vdesk.trigger_topic_item_after_insert
DROP TRIGGER IF EXISTS `trigger_topic_item_after_insert`;
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `trigger_topic_item_after_insert` AFTER INSERT ON `topic_item` FOR EACH ROW BEGIN

	DECLARE currentRemovedAt 	DATETIME;

-- Устанавливаем последний итем
 	UPDATE user_topic_subscribe SET last_id = NEW.id WHERE topic_id=NEW.topic_id;

-- Устанавливаем последний итем статуса
 	IF NEW.type_id=6 THEN

		CALL vbas.func_debug(CONCAT("trigger_topic_item_after_insert(", NEW.id,", topic: ", NEW.topic_id, ", status: ", NEW.status_id, ", time: ", NEW.hold_millis ,")"));
 		CASE NEW.status_id
 		-- HOLD ON + other
-- , terminated_to = FROM_UNIXTIME( NEW.hold_millis/1000 )
 			WHEN 1 THEN

 				CALL vbas.func_debug(CONCAT("SET 1: ", FROM_UNIXTIME( NEW.hold_millis/1000 )));
	 			UPDATE topic SET status_id = NEW.status_id, closed=0, removed_at=NULL, hold_to= FROM_UNIXTIME( NEW.hold_millis/1000 ) WHERE id=NEW.topic_id;

 			WHEN 3 THEN
	 			UPDATE topic SET status_id = NEW.status_id, closed=0, removed_at=NULL, hold_to= FROM_UNIXTIME( NEW.hold_millis/1000 ) WHERE id=NEW.topic_id;

 			WHEN 4 THEN
	 			UPDATE topic SET status_id = NEW.status_id, closed=0, removed_at=NULL, hold_to= FROM_UNIXTIME( NEW.hold_millis/1000 ) WHERE id=NEW.topic_id;

 			WHEN 5 THEN
	 			UPDATE topic SET status_id = NEW.status_id, closed=0, removed_at=NULL, hold_to= FROM_UNIXTIME( NEW.hold_millis/1000 ) WHERE id=NEW.topic_id;

	 	-- CLOSE
 			WHEN 6 THEN
				UPDATE topic SET status_id = NEW.status_id, topic.removed_at=NOW() , topic.closed=1  WHERE id=NEW.topic_id;

 			ELSE
				SELECT removed_at FROM topic WHERE id=NEW.topic_id INTO currentRemovedAt;
-- 				CALL vbas.func_debug(CONCAT("removed_at(",NEW.topic_id,") = ", currentRemovedAt));
 				IF currentRemovedAt IS NOT NULL  THEN
-- 					CALL vbas.func_debug(CONCAT("SET NULL  removed_at (",NEW.topic_id,")"));

					UPDATE topic SET status_id = NEW.status_id, removed_at=NULL, closed=0 WHERE id=NEW.topic_id;
				ELSE
					UPDATE topic SET status_id = NEW.status_id WHERE id=NEW.topic_id;
 				END IF;
		END CASE;


 	 	UPDATE user_topic_subscribe SET last_status_item_id = NEW.id WHERE topic_id=NEW.topic_id;

 	-- Если закрывается заявка, обнулить нужно активные откртые топики в таблице слежения за объектами
 	 	IF NEW.status_id = 6 THEN
 	 		UPDATE `vbas`.object_looks SET topic_id=0 WHERE topic_id = NEW.topic_id;
 	 		UPDATE `vbas`.object_looks SET fault_topic_id=0 WHERE fault_topic_id = NEW.topic_id;
 	 	END IF;

 	END IF;



 	IF NEW.type_id=5 THEN
		UPDATE topic SET priority_id = NEW.priority_id WHERE id=NEW.topic_id;
 	END IF;

-- term_date_plan
 	IF NEW.type_id=8 THEN
		UPDATE topic SET topic.terminated_to = FROM_UNIXTIME(NEW.text/1000) WHERE id=NEW.topic_id;
 	END IF;


-- Устанавливаем последний прочитанный пользтвателем итем
 	IF NEW.type_id=14 THEN
 	 	UPDATE user_topic_subscribe SET checked_id = NEW.id WHERE topic_id=NEW.topic_id AND user_id=NEW.author_id;
 	END IF;

 	IF NEW.type_id=17 THEN
		UPDATE topic SET topic.description = NEW.text WHERE id=NEW.topic_id;
	END IF;


--  Установка changed
 	UPDATE user_topic_subscribe SET
	 	changed=if((closed=0 AND on_hold=0 AND checked_id<last_id AND (is_author=1 OR is_inwork=1 OR is_binded=1 OR (is_group=1 AND (support_date IS NOT NULL) AND support_date<NOW()))),1,0)
		 WHERE topic_id=NEW.topic_id;

 	IF NEW.type_id<>14 THEN
 	 	UPDATE `vdesk`.`topic` SET last_item_id=NEW.id WHERE id=NEW.topic_id AND last_item_id < NEW.id;
 	END IF;

--	UPDATE `vdesk`.`topic` SET last_item_id=NEW.id WHERE id=NEW.topic_id AND last_item_id < NEW.id;
 	UPDATE user_topic_subscribe SET changed=0, checked_id=NEW.id where topic_id=NEW.topic_id AND user_id=NEW.author_id;


END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;




DROP TRIGGER IF EXISTS `trigger_topic_item_after_insert`;
DELIMITER //
CREATE TRIGGER `trigger_topic_item_after_insert` AFTER INSERT ON `topic_item` FOR EACH ROW
BEGIN
	DECLARE currentRemovedAt 	DATETIME;

-- Устанавливаем последний итем
 	UPDATE user_topic_subscribe SET last_id = NEW.id WHERE topic_id=NEW.topic_id;

-- Устанавливаем последний итем статуса
 	IF NEW.type_id=6 THEN

		CALL vbas.func_debug(CONCAT("trigger_topic_item_after_insert(", NEW.id,", topic: ", NEW.topic_id, ", status: ", NEW.status_id, ", time: ", NEW.hold_millis ,")"));
 		CASE NEW.status_id
 		-- HOLD ON + other
-- , terminated_to = FROM_UNIXTIME( NEW.hold_millis/1000 )
 			WHEN 1 THEN

 				CALL vbas.func_debug(CONCAT("SET 1: ", FROM_UNIXTIME( NEW.hold_millis/1000 )));
	 			UPDATE topic SET status_id = NEW.status_id, hold_to= FROM_UNIXTIME( NEW.hold_millis/1000 ) WHERE id=NEW.topic_id;

 			WHEN 3 THEN
	 			UPDATE topic SET status_id = NEW.status_id, hold_to= FROM_UNIXTIME( NEW.hold_millis/1000 ) WHERE id=NEW.topic_id;

 			WHEN 4 THEN
	 			UPDATE topic SET status_id = NEW.status_id, hold_to= FROM_UNIXTIME( NEW.hold_millis/1000 ) WHERE id=NEW.topic_id;

 			WHEN 5 THEN
	 			UPDATE topic SET status_id = NEW.status_id, hold_to= FROM_UNIXTIME( NEW.hold_millis/1000 ) WHERE id=NEW.topic_id;

	 	-- CLOSE
 			WHEN 6 THEN
				UPDATE topic SET status_id = NEW.status_id, topic.removed_at=NOW() , topic.closed=1  WHERE id=NEW.topic_id;

 			ELSE
				SELECT removed_at FROM topic WHERE id=NEW.topic_id INTO currentRemovedAt;
-- 				CALL vbas.func_debug(CONCAT("removed_at(",NEW.topic_id,") = ", currentRemovedAt));
 				IF currentRemovedAt IS NOT NULL  THEN
-- 					CALL vbas.func_debug(CONCAT("SET NULL  removed_at (",NEW.topic_id,")"));

					UPDATE topic SET status_id = NEW.status_id, removed_at=NULL, closed=0 WHERE id=NEW.topic_id;
				ELSE
					UPDATE topic SET status_id = NEW.status_id WHERE id=NEW.topic_id;
 				END IF;
		END CASE;


 	 	UPDATE user_topic_subscribe SET last_status_item_id = NEW.id WHERE topic_id=NEW.topic_id;

 	-- Если закрывается заявка, обнулить нужно активные откртые топики в таблице слежения за объектами
 	 	IF NEW.status_id = 6 THEN
 	 		UPDATE `vbas`.object_looks SET topic_id=0 WHERE topic_id = NEW.topic_id;
 	 		UPDATE `vbas`.object_looks SET fault_topic_id=0 WHERE fault_topic_id = NEW.topic_id;
 	 	END IF;

 	END IF;



 	IF NEW.type_id=5 THEN
		UPDATE topic SET priority_id = NEW.priority_id WHERE id=NEW.topic_id;
 	END IF;

-- term_date_plan
 	IF NEW.type_id=8 THEN
		UPDATE topic SET topic.terminated_to = FROM_UNIXTIME(NEW.text/1000) WHERE id=NEW.topic_id;
 	END IF;


-- Устанавливаем последний прочитанный пользтвателем итем
 	IF NEW.type_id=14 THEN
 	 	UPDATE user_topic_subscribe SET checked_id = NEW.id WHERE topic_id=NEW.topic_id AND user_id=NEW.author_id;
 	END IF;

 	IF NEW.type_id=17 THEN
		UPDATE topic SET topic.description = NEW.text WHERE id=NEW.topic_id;
	END IF;


--  Установка checked
 	UPDATE user_topic_subscribe SET
	 	changed=if((closed=0 AND on_hold=0 AND checked_id<last_id AND (is_author=1 OR is_inwork=1 OR is_binded=1 OR (is_group=1 AND (support_date IS NOT NULL) AND support_date<NOW()))),1,0)
		 WHERE topic_id=NEW.topic_id;

    UPDATE `vdesk`.`topic` SET last_item_id=NEW.id WHERE id=NEW.topic_id AND last_item_id < NEW.id;

END//
DELIMITER ;













-- Дамп структуры базы данных vdesk_auth
DROP DATABASE IF EXISTS `vdesk_auth`;
CREATE DATABASE IF NOT EXISTS `vdesk_auth` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `vdesk_auth`;


-- Дамп структуры для таблица vdesk_auth.fcm_group
DROP TABLE IF EXISTS `fcm_group`;
CREATE TABLE IF NOT EXISTS `fcm_group` (
  `id` int(11) NOT NULL,
  `nkey` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.


-- Дамп структуры для таблица vdesk_auth.fcm_token
DROP TABLE IF EXISTS `fcm_token`;
CREATE TABLE IF NOT EXISTS `fcm_token` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `token` varchar(256) NOT NULL,
  `group_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_group_idx` (`group_id`),
  CONSTRAINT `fk_group` FOREIGN KEY (`group_id`) REFERENCES `fcm_group` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.


-- Дамп структуры для таблица vdesk_auth.role
DROP TABLE IF EXISTS `role`;
CREATE TABLE IF NOT EXISTS `role` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL,
  `description` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.


-- Дамп структуры для таблица vdesk_auth.user
DROP TABLE IF EXISTS `user`;
CREATE TABLE IF NOT EXISTS `user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `login` varchar(128) NOT NULL,
  `password` varchar(512) NOT NULL,
  `identity` varchar(32) DEFAULT NULL,
  `role_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  UNIQUE KEY `role_UNIQUE` (`role_id`),
  KEY `fk_role_idx` (`role_id`),
  CONSTRAINT `user_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `role` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;





SET foreign_key_checks = 1;
SET GLOBAL event_scheduler = ON;
