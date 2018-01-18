CREATE DATABASE mytime;

CREATE TABLE locations (
	id Serial PRIMARY KEY,
	name VARCHAR(300)
);

CREATE TABLE users (
	id SERIAL PRIMARY KEY,
	email VARCHAR(300) NOT NULL,
	password_digest VARCHAR(400)
);

CREATE TABLE bookings (
	id Serial PRIMARY KEY,
	start INTEGER, 
	finish INTEGER, 
	location_id INTEGER,
	user_id INTEGER,
	FOREIGN KEY (location_id) REFERENCES locations (id) ON delete RESTRICT,
	FOREIGN KEY (user_id) REFERENCES users (id) ON delete RESTRICT
);

CREATE TABLE comments (
	id SERIAL PRIMARY KEY,
	body VARCHAR (500) NOT NULL, 
	location_id INTEGER NOT NULL,
	FOREIGN KEY (location_id) REFERENCES locations (id) ON delete
	RESTRICT
);
