
INSERT INTO `role` (`id`, `name`, `description`, `parent`) VALUES
	(1, 'user', 'Пользователь', NULL),
	(2, 'dispatcher', 'Диспетчер', NULL),
	(3, 'admin', 'Администратор системы', NULL),
	(4, 'device', 'Устройство BACNet', NULL),
	(5, 'addGroup', 'Создание группы', 'admin'),
	(6, 'delGroup', 'Удаление группы', 'admin'),
	(7, 'addUser', 'Создание пользователя', 'admin'),
	(8, 'delUser', 'Удаление пользователя', 'admin'),
	(9, 'addTopic', 'Создание заявки', 'dispatcher'),
	(10, 'closeTopic', 'Закрыть заявку', 'dispatcher'),
	(12, 'supportLevel0', 'Уровень поддержки удалить', 'user'),
	(13, 'supportLevel1', 'Уровень поддержки 1', 'user'),
	(14, 'supportLevel2', 'Уровень поддержки 2', 'user'),
	(15, 'supportLevel3', 'Уровень поддержки 3', 'user'),
	(16, 'addCheckList', 'Создать журнал работ', 'admin'),
	(17, 'delChecklist', 'Удалить журнал работ', 'admin'),
	(18, 'getCheckList', 'Просмотр журнала работ', 'dispatcher'),
	(19, 'checkChecklist', 'Проверить в журнале работ', 'dispatcher'),
	(20, 'addTopicGroup', 'Добавление группы в топик', 'user'),
	(21, 'delTopicGroup', 'Удаление группы из топика', 'user');



INSERT INTO `user` (`id`, `login`, `password`, `vdesk_id`, `updated`) VALUES
	(1, 'admin', 'e43789d888e4ff27e407b7a532010e1a', 1, '2021-01-15 00:00:00'),
	(2, 'user', 'ee11cbb19052e40b07aac0ca060c23ee', 2, '2021-01-15 00:00:00'),
	(3, 'gateway', 'c83b12a93bc74590f9bf9308f53a5d82', 3, '2021-01-15 00:00:00'),
	(4, 'vidiodesk', '9fd3dc34b562888683042c4ae345ea06', 4, '2021-01-15 00:00:00');

INSERT INTO auth.role_user (role_id,user_id) SELECT id as role_id, 1 as user_id FROM auth.role;
INSERT INTO auth.role_user (role_id,user_id) SELECT id as role_id, 2 as user_id FROM auth.role;
INSERT INTO auth.role_user (role_id,user_id) SELECT id as role_id, 3 as user_id FROM auth.role;
INSERT INTO auth.role_user (role_id,user_id) SELECT id as role_id, 4 as user_id FROM auth.role;



INSERT INTO `reliability` (`id`, `name`, `description`) VALUES
	(0, 'no-fault-detected', 'No fault detected'),
	(1, 'no-sensor', 'No sensor'),
	(2, 'over-range', 'Over range'),
	(3, 'under-range', 'Under range'),
	(4, 'open-loop', 'Open loop'),
	(5, 'shorted-loop', 'Shorted loop'),
	(6, 'no-output', 'No output'),
	(7, 'unreliable-other', 'Unreliable other'),
	(8, 'process-error', 'Process error'),
	(9, 'multi-state-fault', 'Multi state fault'),
	(10, 'configuration-error', 'Configuration error'),
	(11, 'reserved', 'Reserved'),
	(12, 'communication-failure', 'Communication failure'),
	(13, 'member-fault', 'Member fault'),
	(14, 'monitored-object-fault', 'Monitored object fault'),
	(15, 'tripped', 'Tripped');



INSERT INTO `access_rights` (`id`, `name`, `full_name`) VALUES
	(1, 'CREATE_EVENT', 'Создавать события'),
	(2, 'EDIT_EVENT', 'Редактировать события'),
	(3, 'ADMIN_EVENT', 'Администрировать события'),
	(4, 'ADMIN_PRIORITY', 'Администрировать приоритет'),
	(5, 'ADMIN_USERS_GROUPS', 'Администрировать пользователей и группы');


INSERT INTO `client` (`id`, `client`, `contract_type`, `contract_name`, `contract_date_start`, `contract_date_end`, `user_count`, `active_user_count`) VALUES
	(1, 'Клиент', NULL, NULL, NULL, NULL, 4, NULL);


INSERT INTO `priority` (`id`, `name`, `title`, `color`, `hour_plan`, `hour_notify_support_2`, `hour_notify_support_3`, `plan_inwork`, `plan_ready`, `plan_verify`) VALUES
	(1, 'low', 'Низкий', NULL, 4, 3, 2, 240, 2400, 240),
	(2, 'norm', 'Нормальный', NULL, 3, 2, 2, 120, 1200, 120),
	(3, 'heed', 'Особый', NULL, 2, 1, 1, 30, 600, 30),
	(4, 'top', 'Высокий', NULL, 1, 1, 0, 0, 0, 0);


INSERT INTO `status` (`id`, `name`, `title`, `cancel_notify_2`, `cancel_notify_3`) VALUES
	(1, 'new', 'Новый', NULL, NULL),
	(2, 'assigned', 'Назначенный', NULL, NULL),
	(3, 'in_progress', 'В работе', NULL, NULL),
	(4, 'on_hold', 'В ожидании', NULL, NULL),
	(5, 'resolved', 'Выполнено', NULL, NULL),
	(6, 'closed', 'Закрыто', NULL, NULL);


INSERT INTO `support_level` (`id`, `name`) VALUES
	(2, 'Второй уровень'),
	(1, 'Первый уровень'),
	(3, 'Третий уровень');


INSERT INTO `topic_type` (`id`, `name`) VALUES
	(1, 'Событие'),
	(2, 'Заявка(на обслуживание)'),
	(3, 'Задача'),
	(4, 'Обсуждение');


INSERT INTO `type` (`id`, `name`, `title`) VALUES
	(1, 'img', 'Изображение'),
	(2, 'file', 'Документ'),
	(3, 'user', 'Пользователь'),
	(4, 'group', 'Группа'),
	(5, 'priority', 'Приоритет'),
	(6, 'status', 'Статус'),
	(7, 'problem', 'Проблема'),
	(8, 'term_date_plan', 'Плановая дата завершения'),
	(9, 'term_date_fact', 'Фактическая дата завершения'),
	(10, 'audio', 'Аудиофайл'),
	(11, 'location', 'Место'),
	(12, 'venue', 'Встреча'),
	(13, 'message', 'Сообщение'),
	(14, 'check', 'Ознакомлен'),
	(15, 'removed_from_group', 'Удален у группы'),
	(16, 'removed_from_user', 'Удален у пользователя'),
	(17, 'description', 'Изменено описание'),
	(18, 'checklist', 'Из чек-листа');

INSERT INTO `user` (`id`, `first_name`, `last_name`, `login`, `pass_hash`, `token`, `client_id`, `position`, `dismissed`, `phone`, `user_name`, `sms_code`, `middle_name`, `user_type_id`, `tmp_hash`, `link_used`, `avatar`) VALUES
	(1, 'admin', 'admin', 'admin', 'e43789d888e4ff27e407b7a532010e1a', NULL, 1, 'admin', NULL, NULL, 'admin', NULL, 'admin', NULL, NULL, NULL, NULL),
	(2, 'user', 'user', 'user', 'ee11cbb19052e40b07aac0ca060c23ee', NULL, 1, 'user', NULL, NULL, 'user', NULL, 'User', NULL, NULL, NULL, NULL),
	(3, 'gateway', 'gateway', 'gateway', 'c83b12a93bc74590f9bf9308f53a5d82', NULL, 1, 'gateway', NULL, NULL, 'gateway', NULL, 'gateway', NULL, NULL, NULL, NULL),
	(4, 'vidiodesk', 'vidiodesk', 'vidiodesk', '9fd3dc34b562888683042c4ae345ea06', NULL, 1, 'vidiodesk', NULL, NULL, 'vidiodesk', NULL, 'vidiodesk', NULL, NULL, NULL, NULL);


INSERT INTO `user_type` (`id`, `name`) VALUES
	(1, 'employee'),
	(2, 'bot-visiobas');



SET foreign_key_checks = 1;
SET GLOBAL event_scheduler = ON;
