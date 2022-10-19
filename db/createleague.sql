CREATE TABLE user_table
  ( 
     uid      DECIMAL(3, 0) NOT NULL PRIMARY KEY, 
     fname    VARCHAR(30), 
     lname    VARCHAR(30), 
     email    VARCHAR(50)
  ); 

CREATE TABLE stocks_table 
  ( 
     uid    DECIMAL(3, 0) NOT NULL , 
     ticker_sym  VARCHAR(30) not null, 
     num_stocks DECIMAL(9, 0),
     price DECIMAL(9,0),
     lid DECIMAL(3,0) not null,
     PRIMARY KEY(uid, ticker_sym)
  ); 

CREATE TABLE user_league_table 
  ( 
     uid     DECIMAL(3, 0) NOT NULL , 
     lid DECIMAL(3, 0) not null, 
     balance      DECIMAL(9, 0), 
     PRIMARY KEY(uid, lid)
  ); 

CREATE TABLE stock_data 
  ( 
     ticker_sym  VARCHAR(30) NOT NULL, 
     price DECIMAL(9,0) NOT NULL, 
     stock_time VARCHAR(30) NOT NULL,
     PRIMARY KEY(ticker_sym, stock_time)
  ); 