DROP TYPE IF EXISTS user_type CASCADE;
CREATE TYPE user_type AS ENUM ('Admin', 'User', 'Guest');

CREATE OR REPLACE PROCEDURE set_default_price()
language plpgsql
AS $$ 
begin
	update Lots
	set CurrentPrice = MinPrice;
end;
$$;

DROP TABLE IF EXISTS  UsersTypes CASCADE;
CREATE TABLE IF NOT EXISTS UsersTypes (TypeId SERIAL PRIMARY KEY,
									 Type user_type NOT NULL);

DROP TABLE IF EXISTS  Users CASCADE;
CREATE TABLE IF NOT EXISTS Users (UserId SERIAL PRIMARY KEY, 
					TypeId INT NOT NULL,			  
					CONSTRAINT users_types_fk FOREIGN KEY (TypeId)
								  REFERENCES UsersTypes(TypeId),			   					
					UserBalance INT DEFAULT 0);
					
DROP TABLE IF EXISTS UsersData CASCADE;
CREATE TABLE IF NOT EXISTS UsersData (UserDataId SERIAL PRIMARY KEY,
									UserId INT NOT NULL,
									CONSTRAINT userdata_user_fk FOREIGN KEY (UserId)
											REFERENCES Users(UserId) ON DELETE CASCADE,
									Name VARCHAR(30) NOT NULL,
									Surname VARCHAR(30) NOT NULL,
									Age INT,
									Telephone VARCHAR(20),
									Email VARCHAR(30),
									Address VARCHAR(50),
									Photo BYTEA);

DROP TABLE IF EXISTS AuthorizationsData CASCADE;
CREATE TABLE IF NOT EXISTS AuthorizationsData (AuthorizationId SERIAL PRIMARY KEY,
											 UserId INT NOT NULL,
											 CONSTRAINT authorization_user FOREIGN KEY (UserId)
											 		REFERENCES Users(UserId) ON DELETE CASCADE,
											 Login VARCHAR(20),
											 Password VARCHAR(20));
					
DROP TABLE IF EXISTS Bets CASCADE;					
CREATE TABLE IF NOT EXISTS Bets (BetId SERIAL PRIMARY KEY,
								UserId INT NOT NULL,
								CONSTRAINT bet_user_fk FOREIGN KEY (UserId)
											REFERENCES Users(UserId) ON DELETE CASCADE,
								BetPrice MONEY NOT NULL);
								
DROP TABLE IF EXISTS Lots CASCADE;								
CREATE TABLE IF NOT EXISTS Lots (LotId SERIAL PRIMARY KEY,
							UserOwnerId INT NOT NULL,	
							PropertyId INT,
							CONSTRAINT lots_users_fk FOREIGN KEY (UserOwnerId)
											REFERENCES Users (UserId) ON DELETE CASCADE,
							SoldUntil DATE,
							MinPrice MONEY,							
							LastUserCustomerId INT,
							CONSTRAINT lots_bets_user_fk FOREIGN KEY (LastUserCustomerId)
											REFERENCES Users(UserId) ON DELETE CASCADE,	 
							CurrentPrice MONEY);
							
							
DROP TABLE IF EXISTS Properties CASCADE;								
CREATE TABLE IF NOT EXISTS Properties (PropertyId SERIAL PRIMARY KEY,
									   LotId INT NOT NULL,
									   CONSTRAINT properties_lots_fk FOREIGN KEY (LotId)
									  					REFERENCES Lots(LotId) ON DELETE CASCADE,
									   Weight INT,
									   Size INT,
									   Description VARCHAR(150),
									   Photo BYTEA);
									   
DROP TABLE IF EXISTS Comissions CASCADE;								
CREATE TABLE IF NOT EXISTS Comissions (ComissionId SERIAL PRIMARY KEY,
									   LotId INT NOT NULL,
									   CONSTRAINT commision_lots_fk FOREIGN KEY (LotId)
									  				REFERENCES Lots(LotId) ON DELETE CASCADE,
									   ComissionPersent INT DEFAULT 0,
									   Total MONEY DEFAULT 0); 