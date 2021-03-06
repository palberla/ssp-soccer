DROP DATABASE IF EXISTS soccer;
create DATABASE soccer CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE TABLE `soccer`.`t_stadium` (
  `c_id` SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `c_name` VARCHAR(35) NOT NULL,
  `c_capacity` INT UNSIGNED NOT NULL,
  `c_address` VARCHAR(120) NOT NULL,
  `c_city` VARCHAR(35) NOT NULL,
  `c_picture_outside_url` VARCHAR(120) NOT NULL,
  `c_picture_inside_url` VARCHAR(120) NOT NULL,
  `c_longitude` DECIMAL(20,15) NOT NULL,
  `c_latitude` DECIMAL(20,15) NOT NULL,
  
  PRIMARY KEY (c_id)
) ENGINE=InnoDB;

CREATE TABLE `soccer`.`t_team` (
  `c_id` SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `c_name` VARCHAR(35) NOT NULL,
  `c_icon_url` VARCHAR(120) NOT NULL,
  `c_stadium_id` SMALLINT UNSIGNED NOT NULL,
  PRIMARY KEY (c_id),
  CONSTRAINT FK_TEAM_STADIUM FOREIGN KEY FK_STADIUM (c_stadium_id) REFERENCES t_stadium (c_id) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB;

CREATE TABLE `soccer`.`t_player` (
  `c_id` SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `c_name` VARCHAR(35) NOT NULL,
  `c_team_id` SMALLINT UNSIGNED,
  PRIMARY KEY (c_id),
  CONSTRAINT FK_PLAYER_TEAM FOREIGN KEY FK_TEAM (c_team_id) REFERENCES t_team (c_id) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB;

CREATE TABLE `soccer`.`t_result` (
  `c_id` SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `c_points_home` TINYINT UNSIGNED NOT NULL,
  `c_points_guest` TINYINT UNSIGNED NOT NULL,
  PRIMARY KEY (c_id)
) ENGINE=InnoDB;

CREATE TABLE `soccer`.`t_match` (
  `c_id` SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `c_group_id` TINYINT UNSIGNED NOT NULL,
  `c_home_team_id` SMALLINT UNSIGNED NOT NULL,
  `c_guest_team_id` SMALLINT UNSIGNED NOT NULL,
  `c_stadium_id` SMALLINT UNSIGNED NOT NULL,
  `c_half_result_id` SMALLINT UNSIGNED,
  `c_final_result_id` SMALLINT UNSIGNED,
  `c_date` DATETIME NOT NULL,
  `c_viewers` INT UNSIGNED,
  PRIMARY KEY (c_id),
  CONSTRAINT FK_MATCH_HOME_TEAM FOREIGN KEY FK_HOME_TEAM (c_home_team_id) REFERENCES t_team (c_id) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT FK_MATCH_GUEST_TEAM FOREIGN KEY FK_GUEST_TEAM (c_guest_team_id) REFERENCES t_team (c_id) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT FK_MATCH_STADIUM FOREIGN KEY FK_STADIUM (c_stadium_id) REFERENCES t_stadium (c_id) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT FK_MATCH_HALF_RESULT FOREIGN KEY FK_HALF_RESULT (c_half_result_id) REFERENCES t_result (c_id) ON DELETE SET NULL ON UPDATE NO ACTION,
  CONSTRAINT FK_MATCH_FINAL_RESULT FOREIGN KEY FK_FINAL_RESULT (c_final_result_id) REFERENCES t_result (c_id) ON DELETE SET NULL ON UPDATE NO ACTION
) ENGINE=InnoDB;

CREATE TABLE `soccer`.`t_goal` (
  `c_id` SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `c_points_home` TINYINT UNSIGNED NOT NULL,
  `c_points_guest` TINYINT UNSIGNED NOT NULL,
  `c_minute` TINYINT UNSIGNED NOT NULL,
  `c_player_id` SMALLINT UNSIGNED NOT NULL,
  `c_match_id` SMALLINT UNSIGNED NOT NULL,
  `c_comment` VARCHAR(25),
  `c_penalty` BOOLEAN NOT NULL,
  `c_own` BOOLEAN NOT NULL,
  `c_overtime` BOOLEAN NOT NULL,
  PRIMARY KEY (c_id),
  CONSTRAINT FK_GOAL_PLAYER FOREIGN KEY FK_PLAYER (c_player_id) REFERENCES t_player (c_id) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT FK_GOAL_MATCH FOREIGN KEY FK_MATCH (c_match_id) REFERENCES t_match (c_id) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB;

CREATE TABLE `soccer`.`t_user` (
  `id` SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `c_username` VARCHAR(35) NOT NULL,
  `c_password` VARCHAR(35) NOT NULL,
  `c_name` VARCHAR(35) NOT NULL,
  
  PRIMARY KEY (id)
) ENGINE=InnoDB;

CREATE TABLE `soccer`.`t_group` (
  `id` SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `c_groupname` VARCHAR(35) NOT NULL,
  
  PRIMARY KEY (id)
) ENGINE=InnoDB;

CREATE TABLE `soccer`.`t_user_group` (
  `userID` SMALLINT UNSIGNED NOT NULL,
  `groupID` SMALLINT UNSIGNED NOT NULL,

  CONSTRAINT FK_USER FOREIGN KEY FK_USER (userID) REFERENCES t_user (id) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT FK_GROUP FOREIGN KEY FK_GROUP (groupID) REFERENCES t_group (id) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB;

CREATE OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `soccer`.`v_user_group` AS select `soccer`.`t_user`.`c_username` AS `c_username`,`soccer`.`t_user`.`c_password` AS `c_password`,`soccer`.`t_group`.`c_groupname` AS `c_groupname` from (`soccer`.`t_user` join `soccer`.`t_group`), `soccer`.`t_user_group` WHERE `soccer`.`t_user`.`id` = `soccer`.`t_user_group`.`userID` AND `soccer`.`t_group`.`id` = `soccer`.`t_user_group`.`groupID`;