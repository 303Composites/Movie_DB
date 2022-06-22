CREATE TABLE USERS(

USERID INT PRIMARY KEY NOT NULL,

NAME TEXT NOT NULL

);

CREATE TABLE MOVIES(

MOVIEID INT PRIMARY KEY NOT NULL,

TITLE TEXT NOT NULL

);

CREATE TABLE TAGINFO(

TAGID INT PRIMARY KEY NOT NULL,
CONTENT TEXT NOT NULL
);

CREATE TABLE GENRES(
GENREID INT PRIMARY KEY NOT NULL,
NAME TEXT NOT NULL
);

CREATE TABLE RATINGS(
USERID INT REFERENCES USERS(USERID),
MOVIEID INT REFERENCES MOVIES(MOVIEID),
RATING NUMERIC NOT NULL CHECK(RATING>=0 AND RATING<=5),
TIMESTAMP BIGINT NOT NULL,
PRIMARY KEY (USERID, MOVIEID)
);

CREATE TABLE TAGS(
USERID INT REFERENCES USERS(USERID),
MOVIEID INT REFERENCES MOVIES(MOVIEID),
TAGID INT REFERENCES TAGINFO(TAGID),
TIMESTAMP BIGINT NOT NULL,
PRIMARY KEY (USERID, MOVIEID, TAGID)
);

CREATE TABLE HASAGENRE(
MOVIEID INT REFERENCES MOVIES(MOVIEID),
GENREID INT REFERENCES GENRES(GENREID),
PRIMARY KEY (MOVIEID, GENREID)
);

CREATE TABLE query1 AS
SELECT genres.name AS name, COUNT(hasagenre.movieid) AS count
FROM hasagenre
JOIN genres ON genres.genreid = hasagenre.genreid
GROUP BY hasagenre.genreid, genres.name;

CREATE TABLE query4 AS
SELECT 
  movies.movieid AS m, 
  movies.title AS t, 
  genres.name, 
  hasagenre.movieid, 
  genres.genreid, 
  hasagenre.genreid
FROM movies, genres,hasagenre
WHERE 
  movies.movieid = hasagenre.movieid AND
  hasagenre.genreid = genres.genreid AND name = 'Comedy'


CREATE TABLE query6 AS
SELECT avg(R.rating)
FROM ratings R
WHERE movieid IN ( SELECT movieid
                   FROM hasagenre H  
                   JOIN genres G 
                     ON H.genreid = G.genreid
		   WHERE G.name = 'Comedy'
                   GROUP BY movieid);

CREATE TABLE query7 AS
SELECT avg(R.rating)
FROM ratings R
WHERE movieid IN (SELECT movieid
                   FROM hasagenre H  
                   JOIN genres G 
                     ON H.genreid = G.genreid
                   GROUP BY movieid
                   HAVING COUNT( CASE WHEN G.name = 'Comedy' THEN 1 END) = 1
                      AND COUNT( CASE WHEN G.name = 'Romance' THEN 1 END) = 1); 

CREATE TABLE query8 AS
SELECT avg(R.rating)
FROM ratings R
WHERE movieid IN (SELECT movieid
                   FROM hasagenre H  
                   JOIN genres G 
                     ON H.genreid = G.genreid
                   GROUP BY movieid
                   HAVING COUNT(CASE WHEN G.name = 'Comedy' THEN 1 END) = 1
                      AND COUNT(CASE WHEN G.name = 'Romance' THEN 1 END) = 0); 