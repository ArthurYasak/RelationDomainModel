DROP TYPE IF EXISTS UserType CASCADE;
CREATE TYPE UserType AS ENUM ('ADMIN', 'USER', 'GUEST');

CREATE OR REPLACE PROCEDURE set_default_price()
language plpgsql
AS $$ 
begin
	update lots
	set current_price = min_price;
end;
$$;

DROP TABLE IF EXISTS  users CASCADE;
CREATE TABLE IF NOT EXISTS users (user_id SERIAL PRIMARY KEY, 
					authorization_id INT UNIQUE,			  
					user_type UserType NOT NULL,
					user_balance NUMERIC DEFAULT 0.0,
					user_data_id INT UNIQUE);
				    
DROP TABLE IF EXISTS authorizations_data CASCADE;
CREATE TABLE IF NOT EXISTS authorizations_data (authorization_id SERIAL PRIMARY KEY,
											 user_id INT NOT NULL,
											 CONSTRAINT authorization_user_fk FOREIGN KEY (user_id)
											 		REFERENCES users(user_id) ON DELETE CASCADE,
											 login VARCHAR(20),
											 password VARCHAR(20));
											 
ALTER TABLE	users ADD CONSTRAINT user_authorization_fk FOREIGN KEY (authorization_id)
		REFERENCES authorizations_data (authorization_id) ON DELETE CASCADE;
					
DROP TABLE IF EXISTS users_data CASCADE;
CREATE TABLE IF NOT EXISTS users_data (user_data_id SERIAL PRIMARY KEY,
									user_id INT NOT NULL,
									CONSTRAINT userdata_user_fk FOREIGN KEY (user_id)
											REFERENCES users(user_id) ON DELETE CASCADE,
									Name VARCHAR(30) NOT NULL,
									surname VARCHAR(30) NOT NULL,
									age INT,
									telephone VARCHAR(20),
									email VARCHAR(30),
									address VARCHAR(50),
									photo BYTEA);
									
ALTER TABLE users ADD CONSTRAINT user_userdata_fk FOREIGN KEY (user_data_id)
		REFERENCES users_data(user_data_id) ON DELETE CASCADE;									
					
DROP TABLE IF EXISTS bets CASCADE;					
CREATE TABLE IF NOT EXISTS bets (bet_id SERIAL PRIMARY KEY,
								user_owner_id INT NOT NULL,
								CONSTRAINT bet_user_fk FOREIGN KEY (user_owner_id)
											REFERENCES users(user_id) ON DELETE CASCADE,
								bet_price NUMERIC NOT NULL);
								
DROP TABLE IF EXISTS lots CASCADE;								
CREATE TABLE IF NOT EXISTS lots (lot_id SERIAL PRIMARY KEY,
							user_owner_id INT NOT NULL,			
							CONSTRAINT lots_users_fk FOREIGN KEY (user_owner_id)
											REFERENCES users(user_id) ON DELETE CASCADE,
							property_id INT UNIQUE,
						    CONSTRAINT lots_properties_fk FOREIGN KEY (property_id)
							 	 			REFERENCES lots_properties(property_id) ON DELETE CASCADE,	 
							
							sold_until DATE,
							min_price NUMERIC DEFAULT 1.0,							
							last_customer_id INT,
							CONSTRAINT lots_last_user_fk FOREIGN KEY (last_customer_id)
											REFERENCES users(user_id) ON DELETE CASCADE,	 
							current_price NUMERIC);
							
							
DROP TABLE IF EXISTS lots_properties CASCADE;								
CREATE TABLE IF NOT EXISTS lots_properties (property_id SERIAL PRIMARY KEY,
									   lot_id INT UNIQUE NOT NULL,
									   CONSTRAINT properties_lots_fk FOREIGN KEY (lot_id)
									  					REFERENCES lots(lot_id) ON DELETE CASCADE,
									   weight INT,
									   size INT,
									   description VARCHAR(150),
									   photo BYTEA);
								   
									   
ALTER TABLE lots ADD CONSTRAINT lots_properties_fk FOREIGN KEY (property_id)
								 			REFERENCES lots_properties(property_id) ON DELETE CASCADE;										   
									   
DROP TABLE IF EXISTS commissions CASCADE;								
CREATE TABLE IF NOT EXISTS commissions (commission_id SERIAL PRIMARY KEY,
									   lot_id INT NOT NULL,
									   CONSTRAINT commision_lots_fk FOREIGN KEY (lot_id)
									  				REFERENCES lots(lot_id) ON DELETE CASCADE,
									   commission_percent NUMERIC DEFAULT 0.0,
									   result NUMERIC DEFAULT 0.0); 