ALTER TABLE items ADD COLUMN `id` int(11) UNIQUE AUTO_INCREMENT;
ALTER TABLE items ADD COLUMN `metadata` JSON DEFAULT ('{}');

CREATE TABLE IF NOT EXISTS `items_crafted` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `character_id` int(11) NOT NULL REFERENCES characters(charidentifier),
  `item_id` int(11) NOT NULL REFERENCES items(id),
  `updated_at` TIMESTAMP DEFAULT now(),
  `metadata` JSON,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ID` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `character_inventories` (
  `character_id` int(11) DEFAULT NULL REFERENCES characters(charidentifier),
  `inventory_type` ENUM('default', 'horse', 'cart', 'hideout', 'container', 'clan') NOT NULL DEFAULT 'default',
  `item_crafted_id` int(11) NOT NULL REFERENCES items_crafted(id),
  `amount` int(11) DEFAULT NULL,
  `created_at` TIMESTAMP DEFAULT now()
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4;

-- Convert Json items into separate rows and insert them in items_crafted
INSERT INTO items_crafted (
      character_id,
      item_id,
      metadata)
WITH
  i AS (SELECT id, item FROM items),
  c AS (SELECT charidentifier, inventory FROM characters )
SELECT c.charidentifier, i.id, '{}' as metadata FROM i JOIN c
    WHERE JSON_CONTAINS(JSON_KEYS(c.inventory), JSON_QUOTE(i.item), '$');

-- Assignamount to newly created items and Assign character and inventory type
INSERT INTO character_inventories (
                                   character_id,
                                   inventory_type,
                                   item_crafted_id,
                                   amount
                                   )
WITH
  i AS (SELECT id, item FROM items),
  c AS (SELECT charidentifier, inventory FROM characters),
  ic AS (SELECT id, character_id, item_id FROM items_crafted)
SELECT c.charidentifier, 'default', ic.id, JSON_EXTRACT(c.inventory, CONCAT('$.', i.item)) as amount FROM i JOIN c JOIN ic
    WHERE JSON_CONTAINS(JSON_KEYS(c.inventory), JSON_QUOTE(i.item), '$')
      AND ic.item_id = i.id AND ic.character_id = c.charidentifier
GROUP BY c.charidentifier, ic.id, c.inventory;