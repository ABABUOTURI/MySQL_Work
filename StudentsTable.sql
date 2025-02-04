 CREATE DATABASE SchoolOfMedicineDB;
2> GO
1> USE SchoolOfMedicineDB;
2> GO
Changed database context to 'SchoolOfMedicineDB'.
1> CREATE SCHEMA MedicineSchema;
2> GO
1> CREATE TABLE MedicineSchema.Students(
2> StudentID INT IDENTIFY(1,1) PRIMARY KEY,
3> Name NVARCHAR(100),
4> YearOfStudy INT
5> );
6> GO
Msg 102, Level 15, State 1, Server ABABU-OTURI, Line 2
Incorrect syntax near 'IDENTIFY'.
1> CREATE TABLE MedicineSchema.Students (
2>     StudentID INT IDENTITY(1,1) PRIMARY KEY,
3>     Name NVARCHAR(100),
4>     YearOfStudy INT
5> );
6> GO
1>
2> INSERT INTO MedicineSchema.Students (Name, YearOfStudy)
3> VALUES ('Emmanuel Ababu', 1),
4>
5> GO
Msg 102, Level 15, State 1, Server ABABU-OTURI, Line 3
Incorrect syntax near ','.
1> INSERT INTO MedicineSchema.Students(Name, YearOfStudy)
2> VALUES('Emmanuel Ababu', 1)
3> GO

(1 rows affected)
1> INSERT INTO MedicineSchema.Students(Name, YearOfStudy)
2> VALUES('Emmanuel Ababu', 1),
3>      ('Oturi Junior', 2),
4>      ('Sussy Okaya', 3),
5>      ('Miracle Munganga', 4),
6>      ('David Uturi', 2);
7> GO

(5 rows affected)
1>
2>
3>
4>
5> CREATE VIEW MedicineSchema.StudentView AS
6> SELECT StudentID, Name, YearOfStudy
7> FROM MedicineSchema.Students;
8> GO