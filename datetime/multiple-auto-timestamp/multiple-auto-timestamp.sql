# File to soulve "bug" with MySQL that does not allow to have more than one
# automatic timestamp in one table


# @see http://fititnt.org/mysql/multiples-current-timestamp-workaround.html

#Table example

CREATE  TABLE IF NOT EXISTS `jos_current_timestamp_workaround` (
  `id` INT(11) NOT NULL AUTO_INCREMENT ,
  `title` VARCHAR(255) NULL DEFAULT NULL COMMENT 'your fields here...' ,
  `hits` INT(11) NULL DEFAULT NULL COMMENT 'See J!API JTable' ,
  `ordering` INT(11) NULL DEFAULT NULL COMMENT 'See J!API JTable' ,
  `checked_out` INT(11) NULL COMMENT 'See J!API JTable' ,
  `checked_out_time` DATETIME NULL COMMENT 'See J!API JTable' ,
  `publish_up` DATETIME NULL COMMENT 'See J!API' ,
  `publish_down` DATETIME NULL COMMENT 'See J!API' ,
  `published` TINYINT NULL DEFAULT 1 COMMENT 'See J!API ' ,
  `params` TEXT NULL COMMENT 'See J!API JParameter...' ,
  `created` DATETIME NULL COMMENT 'See tigger' ,
  `updated` DATETIME NULL COMMENT 'See tigger' ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB;

#Procedure to make more than one automatic timestamp

DELIMITER $$

DROP TRIGGER IF EXISTS `jos_ctw_created` $$
CREATE TRIGGER jos_ctw_created BEFORE INSERT ON `jos_current_timestamp_workaround` FOR EACH ROW SET
NEW.created = IFNULL(NEW.created, NOW()),
NEW.updated = IFNULL(NEW.updated, '0000-00-00 00:00:00')$$


DROP TRIGGER IF EXISTS `jos_ctw_updated` $$
CREATE TRIGGER jos_ctw_updated BEFORE UPDATE ON `jos_current_timestamp_workaround` FOR EACH ROW SET
NEW.updated = CASE
                  WHEN NEW.updated IS NULL THEN OLD.updated
                  WHEN NEW.updated = OLD.updated THEN NOW()
                  ELSE NEW.updated
              END,
    NEW.updated= IFNULL(NEW.updated, OLD.updated)$$