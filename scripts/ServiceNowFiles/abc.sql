CREATE TABLE pro.products_23 (
	id int4 NULL,
	name varchar(50) NULL,
	sku varchar(10) NULL
);

CREATE OR REPLACE VIEW pro.products_23_vw ("name", "sku") AS 
  SELECT name, sku
   FROM pro.products_23;


INSERT INTO pro.products_23 (id, name, sku) VALUES(0, 'Kite', '38379384');
INSERT INTO pro.products_23 (id, name, sku) VALUES(1, 'Sled', '94822938');