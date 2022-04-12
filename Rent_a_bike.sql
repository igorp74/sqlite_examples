BEGIN TRANSACTION;

/* DATA DEFINITION LANGUAGE (DDL) */
CREATE TABLE "Bikes" (
	"ID"	INTEGER,
	"Model_ID"	INTEGER,
	"Nick_name"	TEXT,
	"Start_date"	DATE,
	PRIMARY KEY("ID" AUTOINCREMENT)
);
CREATE TABLE "Customer" (
	"ID"	INTEGER,
	"First_name"	TEXT,
	"Last_name"	TEXT,
	"GSM"	TEXT,
	"E_mail"	TEXT,
	PRIMARY KEY("ID" AUTOINCREMENT)
);
CREATE TABLE "Models" (
	"ID"	INTEGER,
	"Name"	TEXT,
	"Price"	REAL,
	"Gears"	TEXT,
	"Brakes"	TEXT,
	"Electric"	TEXT,
	PRIMARY KEY("ID" AUTOINCREMENT)
);
CREATE TABLE "Renting" (
	"ID"	INTEGER,
	"Bike_ID"	INTEGER,
	"Customer_ID"	INTEGER,
	"Start"	DATE,
	"Return"	DATE,
	PRIMARY KEY("ID" AUTOINCREMENT)
);

/* INSERTING DATA INTO TABLES */
INSERT INTO BIKES (MODEL_ID,NICK_NAME,START_DATE) VALUES
	 (1,'Mickey','1998-02-14'),
	 (2,'Ngawe','2017-03-25'),
	 (3,'Idris','2022-01-10');
INSERT INTO MODELS (NAME,PRICE,GEARS,BRAKES,ELECTRIC) VALUES
	 ('Greyp',50.0,'18','Disc','Yes'),
	 ('MTB',10.0,'21','Disc','No'),
	 ('City',15.0,'21','V-Brakes','Yes');
INSERT INTO CUSTOMER (FIRST_NAME,LAST_NAME,GSM,E_MAIL) VALUES
	 ('John','Doe','+38599222555','john@doe.com'),
	 ('Ann','Miller','+44777888999','ann.miller@real_killer.com');
INSERT INTO RENTING (BIKE_ID,CUSTOMER_ID,"Start","Return") VALUES
	 (1,2,'2022-04-05 12:00:15','2022-04-05 14:30:15'),
	 (2,1,'2022-04-11 17:30:00','2022-04-11 19:30:00'),
	 (3,1,'2022-04-05 12:00:15',NULL),
	 (2,2,'2022-04-07 12:00:15',NULL);


CREATE VIEW v_Overview AS
SELECT
	m.Name as Bike_model,
	b.Nick_name as Bike_nickname,
	c.First_name,
	c.Last_name,
	c.GSM,
	r.[Start],
	r.[Return],
	round(CAST ((JulianDay(r.Return) - JulianDay(r.Start)) * 24 AS REAL),2) AS [Duration hrs],
	m.Price,
	round(CAST ((JulianDay(r.Return) - JulianDay(r.Start)) * 24 AS REAL),2) * m.Price as [Cost EUR]
FROM
	Renting r
	JOIN Bikes b         ON r.Bike_ID     = b.ID
	JOIN Models m        ON b.Model_ID    = m.ID
	LEFT JOIN Customer c ON r.Customer_ID = c.ID;
CREATE VIEW v_Outside AS
SELECT
	o.Bike_model,
	o.Bike_nickname,
	o.First_name,
	o.Last_name,
	o.GSM,
	o.Start,
	o.Return,
	DATETIME('now','localtime') as Actual_time,
	round(CAST ((JulianDay('now', 'localtime') - JulianDay(o.Start)) * 24 AS REAL),2) AS [Duration hrs],
	o.Price,
	round(CAST ((JulianDay('now', 'localtime') - JulianDay(o.Start)) * 24 AS REAL),2) * o.Price AS [Debt EUR]
FROM v_Overview o
WHERE 1=1
	AND Start IS NOT NULL
	AND [Return] IS NULL;

COMMIT;
