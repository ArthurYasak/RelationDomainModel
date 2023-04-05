DROP TYPE IF EXISTS user_type CASCADE;
CREATE TYPE user_type AS ENUM ('Admin', 'User', 'Guest');



DROP TABLE IF EXISTS  UserTypes CASCADE;
CREATE TABLE IF NOT EXISTS UserTypes (TypeId SERIAL PRIMARY KEY,
									 Type user_type);

DROP TABLE IF EXISTS  Users CASCADE;
CREATE TABLE IF NOT EXISTS Users (UserId SERIAL PRIMARY KEY, 
					TypeId INT,			  
					CONSTRAINT user_types_fk FOREIGN KEY (TypeId)
								  REFERENCES UserTypes(TypeId),			   
					UserName CHAR(30) NOT NULL,
					UserBalance INT DEFAULT 0);
					
DROP TABLE IF EXISTS Bets CASCADE;					
CREATE TABLE IF NOT EXISTS Bets (BetId SERIAL PRIMARY KEY,
								UserId INT,
								CONSTRAINT bet_user_fk FOREIGN KEY (UserId)
											REFERENCES Users(UserId),
								BetPrice MONEY);
								
DROP TABLE IF EXISTS Lots CASCADE;								
CREATE TABLE IF NOT EXISTS Lots (LotId SERIAL PRIMARY KEY,
							UserId INT,	
							PropertyId INT,
							CONSTRAINT lots_users_fk FOREIGN KEY (UserId)
											REFERENCES Users (UserId),
							SoldUntil DATE,
							MinPrice MONEY,							
							LastUserId INT,
							CONSTRAINT lots_bets_user_fk FOREIGN KEY (LastUserId)
											REFERENCES Users(UserId),	 
							CurrentPrice MONEY);
							
							
DROP TABLE IF EXISTS Properties CASCADE;								
CREATE TABLE IF NOT EXISTS Properties (PropertyId SERIAL PRIMARY KEY,
									   LotId INT,
									   CONSTRAINT properties_lots_fk FOREIGN KEY (LotId)
									  					REFERENCES Lots(LotId),
									   Weight INT,
									   Size INT,
									   Description CHAR(150),
									   Photo BYTEA);
									   
DROP TABLE IF EXISTS Comissions CASCADE;								
CREATE TABLE IF NOT EXISTS Comissions (ComissionId SERIAL PRIMARY KEY,
									   LotId INT,
									   CONSTRAINT commision_lots_fk FOREIGN KEY (LotId)
									  				REFERENCES Lots(LotId),
									   ComissionPersent INT,
									   Total MONEY); 