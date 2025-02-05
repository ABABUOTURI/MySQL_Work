
C:\Users\Administrator>sqlcmd -S . -E
1> CREATE DATABASE questionnaire;
2> GO
1>
2>
3> SELECT name
4> FROM sys.databases;
5> GO
name

--------------------------------------------------------------------------------------------------------------------------------
master

tempdb

model

msdb

ReportServer

ReportServerTempDB

StudentsDB

SchoolOfMedicineDB

Influenza

questionnaire


(10 rows affected)
1>
2>
3> USE questionnaire;
4> GO
Changed database context to 'questionnaire'.
1>
2>
3> --Table1  with basic information of the questionnaires
4> GO
1>
2>
3> -- Table1: Basic information of the questionnaire
4> CREATE TABLE questionnaire (
5>     ID INT PRIMARY KEY IDENTITY(1,1),       -- Primary Key, Auto-incremented ID
6>     serial_number VARCHAR(50) UNIQUE NOT NULL, -- Unique serial number
7>     date_of_data_collection DATE NOT NULL   -- Date of data collection
8> );
9> GO
1>
2>
3> -- Table2: Socio-economic and demographic information
4> CREATE TABLE socio_economic_demographic (
5>     ID INT PRIMARY KEY IDENTITY(1,1),       -- Primary Key, Auto-incremented ID
6>     questionnaire_id INT NOT NULL,          -- Foreign key to `questionnaire`
7>     age INT CHECK (age BETWEEN 15 AND 19),  -- Age constraint
8>     relationship VARCHAR(100) NOT NULL CHECK (relationship IN ('Father and Mother', 'Mother only', 'Father only', 'Relative')),
9>     guardian_occupation VARCHAR(100) NOT NULL CHECK (guardian_occupation IN ('Farm Worker', 'Self Employed', 'Employed by someone', 'Professional', 'Others')),
10>     guardian_education VARCHAR(100) NOT NULL CHECK (guardian_education IN ('None', 'Primary', 'Secondary', 'Tertiary Education')),
11>     respondent_religion VARCHAR(50) NOT NULL CHECK (respondent_religion IN ('Catholic', 'Protestant', 'Muslim', 'SDA', 'None')),
12>     family_size INT NOT NULL CHECK (family_size >= 0),
13>     has_siblings VARCHAR(3) NOT NULL CHECK (has_siblings IN ('Yes', 'No')),
14>     siblings_have_partners VARCHAR(3) NOT NULL CHECK (siblings_have_partners IN ('Yes', 'No')),
15>     gets_pocket_money VARCHAR(3) NOT NULL CHECK (gets_pocket_money IN ('Yes', 'No')),
16>     pocket_money_adequate VARCHAR(3) NOT NULL CHECK (pocket_money_adequate IN ('Yes', 'No')),
17>     financial_support VARCHAR(100) NOT NULL CHECK (financial_support IN ('Relatives', 'Boyfriends', 'Grandparents', 'Other Friends')),
18>     guardian_visits VARCHAR(3) NOT NULL CHECK (guardian_visits IN ('Yes', 'No')),
19>     alternative_visitor VARCHAR(100) NOT NULL CHECK (alternative_visitor IN ('Boyfriend', 'Relatives', 'Brothers/Sisters', 'Man Friend', 'None')),
20>     FOREIGN KEY (questionnaire_id) REFERENCES questionnaire(ID) ON DELETE CASCADE
21> );
22> GO
1>
2>
3> -- Table3: Sources of information and sexual behavior
4> CREATE TABLE sources_information_sexual_behavior (
5>     ID INT PRIMARY KEY IDENTITY(1,1),       -- Primary Key, Auto-incremented ID
6>     questionnaire_id INT NOT NULL,          -- Foreign key to `questionnaire`
7>     access_to_reproductive_health_info VARCHAR(3) NOT NULL CHECK (access_to_reproductive_health_info IN ('Yes', 'No')),
8>     information_adequate VARCHAR(3) NOT NULL CHECK (information_adequate IN ('Yes', 'No')),
9>     FOREIGN KEY (questionnaire_id) REFERENCES questionnaire(ID) ON DELETE CASCADE
10> );
11> GO
1>
2>
3> -- Table4: Reproductive health education
4> CREATE TABLE reproductive_health_education (
5>     ID INT PRIMARY KEY IDENTITY(1,1),       -- Primary Key, Auto-incremented ID
6>     questionnaire_id INT NOT NULL,          -- Foreign key to `questionnaire`
7>     educator VARCHAR(100) NOT NULL CHECK (educator IN ('Teachers', 'Parents', 'Health Worker', 'Friends', 'Radio Magazines/TV')),
8>     FOREIGN KEY (questionnaire_id) REFERENCES questionnaire(ID) ON DELETE CASCADE
9> );
10> GO
1>
2>
3> -- Table5: Reproductive health topics
4> CREATE TABLE reproductive_health_topics (
5>     ID INT PRIMARY KEY IDENTITY(1,1),       -- Primary Key, Auto-incremented ID
6>     questionnaire_id INT NOT NULL,          -- Foreign key to `questionnaire`
7>     topic VARCHAR(100) NOT NULL CHECK (topic IN ('Sexuality', 'Abstinence', 'Condoms', 'STI/HIV', 'Relationships')),
8>     FOREIGN KEY (questionnaire_id) REFERENCES questionnaire(ID) ON DELETE CASCADE
9> );
10> GO
1>
2>
3> SELECT name FROM sys.tables;
4> GO
name

--------------------------------------------------------------------------------------------------------------------------------
questionnaire

socio_economic_demographic

sources_information_sexual_behavior

reproductive_health_education

reproductive_health_topics


(5 rows affected)
1>
2>
3> SELECT * FROM questionnaire;
4> GO
ID          serial_number                                      date_of_data_collection
----------- -------------------------------------------------- -----------------------

(0 rows affected)
1>
2>
3> SELECT *FROM socio_economic_demographic;
4> GO
ID          questionnaire_id age         relationship
                                                                  guardian_occupation
               guardian_education
                                        respondent_religion
               family_size has_siblings siblings_have_partners gets_pocket_money pocket_money_adequate financial_support
                                                    guardian_visits alternative_visitor

----------- ---------------- ----------- ---------------------------------------------------------------------------------------------------- ---------------------------------------------------------------------------------------------------- ---------------------------------------------------------------------------------------------------- -------------------------------------------------- ----------- ------------ ---------------------- ----------------- --------------------- ---------------------------------------------------------------------------------------------------- --------------- ----------------------------------------------------------------------------------------------------

(0 rows affected)
1> SELECT * FROM sources_information_sexual_behavior;
4> GO
ID          questionnaire_id access_to_reproductive_health_info information_adequate
----------- ---------------- ---------------------------------- --------------------

(0 rows affected)
1>
2>
3> SELECT * FROM reproductive_health_education;
4> GO
ID          questionnaire_id educator
----------- ---------------- ----------------------------------------------------------------------------------------------------

(0 rows affected)
1>
2>
3> SELECT * FROM reproductive_health_topics;
4> GO
ID          questionnaire_id topic
----------- ---------------- ----------------------------------------------------------------------------------------------------

(0 rows affected)
3>
4>


5>
6> --Error handling on database views
7> -- View1: Combined basic questionnaire information with demographic details
8> CREATE VIEW vw_questionnaire_demographics AS
9> SELECT
10>     q.ID AS questionnaire_id,
11>     ISNULL(q.serial_number, 'Unknown') AS serial_number,
12>     ISNULL(q.date_of_data_collection, '2025-02-05') AS date_of_data_collection,
13>     ISNULL(s.age, 'N/A') AS age,
14>     ISNULL(s.relationship, 'Unknown') AS relationship,
15>     ISNULL(s.guardian_occupation, 'Unknown') AS guardian_occupation,
16>     ISNULL(s.guardian_education, 'Unknown') AS guardian_education,
17>     ISNULL(s.respondent_religion, 'Unknown') AS respondent_religion,
18>     ISNULL(s.family_size, 0) AS family_size,
19>     ISNULL(s.has_siblings, 'No') AS has_siblings,
20>     ISNULL(s.siblings_have_partners, 'No') AS siblings_have_partners,
21>     ISNULL(s.gets_pocket_money, 'No') AS gets_pocket_money,
22>     ISNULL(s.pocket_money_adequate, 'No') AS pocket_money_adequate,
23>     ISNULL(s.financial_support, 'Unknown') AS financial_support,
24>     ISNULL(s.guardian_visits, 'No') AS guardian_visits,
25>     ISNULL(s.alternative_visitors, 'None') AS alternative_visitors
26> FROM questionnaire q
27> LEFT JOIN socio_economic_demographic s ON q.ID = s.questionnaire_id;
28> GO
Msg 207, Level 16, State 1, Server ABABU-OTURI, Procedure vw_questionnaire_demographics, Line 25
Invalid column name 'alternative_visitors'.
1>
2> -- View1: Combined basic questionnaire information with demographic details
3> CREATE VIEW vw_questionnaire_demographics AS
4> SELECT
5>     q.ID AS questionnaire_id,
6>     ISNULL(q.serial_number, 'Unknown') AS serial_number,
7>     ISNULL(q.date_of_data_collection, '2025-02-05') AS date_of_data_collection,
8>     ISNULL(s.age, 'N/A') AS age,
9>     ISNULL(s.relationship, 'Unknown') AS relationship,
10>     ISNULL(s.guardian_occupation, 'Unknown') AS guardian_occupation,
11>     ISNULL(s.guardian_education, 'Unknown') AS guardian_education,
12>     ISNULL(s.respondent_religion, 'Unknown') AS respondent_religion,
13>     ISNULL(s.family_size, 0) AS family_size,
14>     ISNULL(s.has_siblings, 'No') AS has_siblings,
15>     ISNULL(s.siblings_have_partners, 'No') AS siblings_have_partners,
16>     ISNULL(s.gets_pocket_money, 'No') AS gets_pocket_money,
17>     ISNULL(s.pocket_money_adequate, 'No') AS pocket_money_adequate,
18>     ISNULL(s.financial_support, 'Unknown') AS financial_support,
19>     ISNULL(s.guardian_visits, 'No') AS guardian_visits,
20>     ISNULL(s.alternative_visitors, 'None') AS alternative_visitors
21> FROM questionnaire q
22> LEFT JOIN socio_economic_demographic s ON q.ID = s.questionnaire_id;
23> GO
Msg 207, Level 16, State 1, Server ABABU-OTURI, Procedure vw_questionnaire_demographics, Line 20
Invalid column name 'alternative_visitors'.
1>
2> -- View2: Questionnaire responses related to sexual behavior and health information
3> CREATE VIEW vw_sexual_health_info AS
4> SELECT
5>     q.ID AS questionnaire_id,
6>     ISNULL(q.serial_number, 'Unknown') AS serial_number,
7>     ISNULL(q.date_of_data_collection, '2025-02-05') AS date_of_data_collection,
8>     ISNULL(s.access_to_reproductive_health_info, 'No') AS access_to_reproductive_health_info,
9>     ISNULL(s.information_adequate, 'No') AS information_adequate
10> FROM questionnaire q
11> LEFT JOIN sources_information_sexual_behavior s ON q.ID = s.questionnaire_id;
12> GO
1>
2> -- View3: Educator information related to reproductive health education
3> CREATE VIEW vw_health_education AS
4> SELECT
5>     q.ID AS questionnaire_id,
6>     ISNULL(q.serial_number, 'Unknown') AS serial_number,
7>     ISNULL(q.date_of_data_collection, '2025-02-05') AS date_of_data_collection,
8>     ISNULL(r.educator, 'Unknown') AS educator
9> FROM questionnaire q
10> LEFT JOIN reproductive_health_education r ON q.ID = r.questionnaire_id;
11> GO
1>
2> -- View4: Topics discussed in reproductive health education
3> CREATE VIEW vw_health_topics AS
4> SELECT
5>     q.ID AS questionnaire_id,
6>     ISNULL(q.serial_number, 'Unknown') AS serial_number,
7>     ISNULL(q.date_of_data_collection, '2025-02-05') AS date_of_data_collection,
8>     ISNULL(t.topic, 'Unknown') AS topic
9> FROM questionnaire q
10> LEFT JOIN reproductive_health_topics t ON q.ID = t.questionnaire_id;
11> GO
1>
2> -- View5: Comprehensive view combining all questionnaire-related data
3> CREATE VIEW vw_full_questionnaire AS
4> SELECT
5>     q.ID AS questionnaire_id,
6>     ISNULL(q.serial_number, 'Unknown') AS serial_number,
7>     ISNULL(q.date_of_data_collection, '2025-02-05') AS date_of_data_collection,
8>     ISNULL(s.age, 'N/A') AS age,
9>     ISNULL(s.relationship, 'Unknown') AS relationship,
10>     ISNULL(s.guardian_occupation, 'Unknown') AS guardian_occupation,
11>     ISNULL(s.guardian_education, 'Unknown') AS guardian_education,
12>     ISNULL(s.respondent_religion, 'Unknown') AS respondent_religion,
13>     ISNULL(s.family_size, 0) AS family_size,
14>     ISNULL(s.has_siblings, 'No') AS has_siblings,
15>     ISNULL(s.siblings_have_partners, 'No') AS siblings_have_partners,
16>     ISNULL(s.gets_pocket_money, 'No') AS gets_pocket_money,
17>     ISNULL(s.pocket_money_adequate, 'No') AS pocket_money_adequate,
18>     ISNULL(s.financial_support, 'Unknown') AS financial_support,
19>     ISNULL(s.guardian_visits, 'No') AS guardian_visits,
20>     ISNULL(s.alternative_visitors, 'None') AS alternative_visitors,
21>     ISNULL(si.access_to_reproductive_health_info, 'No') AS access_to_reproductive_health_info,
22>     ISNULL(si.information_adequate, 'No') AS information_adequate,
23>     ISNULL(re.educator, 'Unknown') AS educator,
24>     ISNULL(rt.topic, 'Unknown') AS topic
25> FROM questionnaire q
26> LEFT JOIN socio_economic_demographic s ON q.ID = s.questionnaire_id
27> LEFT JOIN sources_information_sexual_behavior si ON q.ID = si.questionnaire_id
28> LEFT JOIN reproductive_health_education re ON q.ID = re.questionnaire_id
29> LEFT JOIN reproductive_health_topics rt ON q.ID = rt.questionnaire_id;
30> GO
Msg 207, Level 16, State 1, Server ABABU-OTURI, Procedure vw_full_questionnaire, Line 20
Invalid column name 'alternative_visitors'.
1>
2>
3> SELECT COLUMN_NAME
4> FROM INFORMATION_SCHEMA.COLUMNS
5> WHERE TABLE_NAME = 'socio_economic_demographic';
6> GO
COLUMN_NAME
--------------------------------------------------------------------------------------------------------------------------------
ID
questionnaire_id
age
relationship
guardian_occupation
guardian_education
respondent_religion
family_size
has_siblings
siblings_have_partners
gets_pocket_money
pocket_money_adequate
financial_support
guardian_visits
alternative_visitor

(15 rows affected)
1>
2>
3> -- View1: Combined basic questionnaire information with demographic details
4> CREATE VIEW vw_questionnaire_demographics AS
5> SELECT
6>     q.ID AS questionnaire_id,
7>     ISNULL(q.serial_number, 'Unknown') AS serial_number,
8>     ISNULL(q.date_of_data_collection, '2025-02-05') AS date_of_data_collection,
9>     ISNULL(s.age, 'N/A') AS age,
10>     ISNULL(s.relationship, 'Unknown') AS relationship,
11>     ISNULL(s.guardian_occupation, 'Unknown') AS guardian_occupation,
12>     ISNULL(s.guardian_education, 'Unknown') AS guardian_education,
13>     ISNULL(s.respondent_religion, 'Unknown') AS respondent_religion,
14>     ISNULL(s.family_size, 0) AS family_size,
15>     ISNULL(s.has_siblings, 'No') AS has_siblings,
16>     ISNULL(s.siblings_have_partners, 'No') AS siblings_have_partners,
17>     ISNULL(s.gets_pocket_money, 'No') AS gets_pocket_money,
18>     ISNULL(s.pocket_money_adequate, 'No') AS pocket_money_adequate,
19>     ISNULL(s.financial_support, 'Unknown') AS financial_support,
20>     ISNULL(s.guardian_visits, 'No') AS guardian_visits,
21>     ISNULL(s.alternative_visitor, 'None') AS alternative_visitor
22> FROM questionnaire q
23> LEFT JOIN socio_economic_demographic s ON q.ID = s.questionnaire_id;
24> GO
1>
2> -- View2: Questionnaire responses related to sexual behavior and health information
3> CREATE VIEW vw_sexual_health_info AS
4> SELECT
5>     q.ID AS questionnaire_id,
6>     ISNULL(q.serial_number, 'Unknown') AS serial_number,
7>     ISNULL(q.date_of_data_collection, '2025-02-05') AS date_of_data_collection,
8>     ISNULL(s.access_to_reproductive_health_info, 'No') AS access_to_reproductive_health_info,
9>     ISNULL(s.information_adequate, 'No') AS information_adequate
10> FROM questionnaire q
11> LEFT JOIN sources_information_sexual_behavior s ON q.ID = s.questionnaire_id;
12> GO
Msg 2714, Level 16, State 3, Server ABABU-OTURI, Procedure vw_sexual_health_info, Line 3
There is already an object named 'vw_sexual_health_info' in the database.
1>
2> -- View3: Educator information related to reproductive health education
3> CREATE VIEW vw_health_education AS
4> SELECT
5>     q.ID AS questionnaire_id,
6>     ISNULL(q.serial_number, 'Unknown') AS serial_number,
7>     ISNULL(q.date_of_data_collection, '2025-02-05') AS date_of_data_collection,
8>     ISNULL(r.educator, 'Unknown') AS educator
9> FROM questionnaire q
10> LEFT JOIN reproductive_health_education r ON q.ID = r.questionnaire_id;
11> GO
Msg 2714, Level 16, State 3, Server ABABU-OTURI, Procedure vw_health_education, Line 3
There is already an object named 'vw_health_education' in the database.
1>
2> -- View4: Topics discussed in reproductive health education
3> CREATE VIEW vw_health_topics AS
4> SELECT
5>     q.ID AS questionnaire_id,
6>     ISNULL(q.serial_number, 'Unknown') AS serial_number,
7>     ISNULL(q.date_of_data_collection, '2025-02-05') AS date_of_data_collection,
8>     ISNULL(t.topic, 'Unknown') AS topic
9> FROM questionnaire q
10> LEFT JOIN reproductive_health_topics t ON q.ID = t.questionnaire_id;
11> GO
Msg 2714, Level 16, State 3, Server ABABU-OTURI, Procedure vw_health_topics, Line 3
There is already an object named 'vw_health_topics' in the database.
1>
2> -- View5: Comprehensive view combining all questionnaire-related data
3> CREATE VIEW vw_full_questionnaire AS
4> SELECT
5>     q.ID AS questionnaire_id,
6>     ISNULL(q.serial_number, 'Unknown') AS serial_number,
7>     ISNULL(q.date_of_data_collection, '2025-02-05') AS date_of_data_collection,
8>     ISNULL(s.age, 'N/A') AS age,
9>     ISNULL(s.relationship, 'Unknown') AS relationship,
10>     ISNULL(s.guardian_occupation, 'Unknown') AS guardian_occupation,
11>     ISNULL(s.guardian_education, 'Unknown') AS guardian_education,
12>     ISNULL(s.respondent_religion, 'Unknown') AS respondent_religion,
13>     ISNULL(s.family_size, 0) AS family_size,
14>     ISNULL(s.has_siblings, 'No') AS has_siblings,
15>     ISNULL(s.siblings_have_partners, 'No') AS siblings_have_partners,
16>     ISNULL(s.gets_pocket_money, 'No') AS gets_pocket_money,
17>     ISNULL(s.pocket_money_adequate, 'No') AS pocket_money_adequate,
18>     ISNULL(s.financial_support, 'Unknown') AS financial_support,
19>     ISNULL(s.guardian_visits, 'No') AS guardian_visits,
20>     ISNULL(s.alternative_visitor, 'None') AS alternative_visitor,
21>     ISNULL(si.access_to_reproductive_health_info, 'No') AS access_to_reproductive_health_info,
22>     ISNULL(si.information_adequate, 'No') AS information_adequate,
23>     ISNULL(re.educator, 'Unknown') AS educator,
24>     ISNULL(rt.topic, 'Unknown') AS topic
25> FROM questionnaire q
26> LEFT JOIN socio_economic_demographic s ON q.ID = s.questionnaire_id
27> LEFT JOIN sources_information_sexual_behavior si ON q.ID = si.questionnaire_id
28> LEFT JOIN reproductive_health_education re ON q.ID = re.questionnaire_id
29> LEFT JOIN reproductive_health_topics rt ON q.ID = rt.questionnaire_id;
30> GO
1>
2>
3>
4>
5> --Stored procedures, this allows to perform operations like inserting,updating,deleting and retrieving data efficiently.
6> /* procedure for inserting data*/
7> CREATE PROCEDURE sp_InsertQuestionnaire
8>     @serial_number VARCHAR(50),
9>     @date_of_data_collection DATE
10> AS
11> BEGIN
12>     INSERT INTO questionnaire (serial_number, date_of_data_collection)
13>     VALUES (@serial_number, @date_of_data_collection)
14> END;
15> GO
1>
2>
3>
4> /*stored procedures for data retrieve*/
5> CREATE PROCEDURE sp_GetQuestionnaireDemographics
6> AS
7> BEGIN
8>     SELECT * FROM vw_questionnaire_demographics;
9> END;
10> GO
1>
2>
3>
4> /*stored procedure for data update*/
5> CREATE PROCEDURE sp_UpdateGuardianOccupation
6>     @questionnaire_id INT,
7>     @guardian_occupation VARCHAR(100)
8> AS
9> BEGIN
10>     UPDATE socio_economic_demographic
11>     SET guardian_occupation = @guardian_occupation
12>     WHERE questionnaire_id = @questionnaire_id;
13> END;
14> GO
1>
2>
3>
4> /*testing the stored procedures*/
5> EXEC sp_InsertQuestionnaire 'SN12345', '2025-02-05';
6> EXEC sp_GetQuestionnaireDemographics;
7> EXEC sp_UpdateGuardianOccupation 1, 'Teacher';
8> GO

(1 rows affected)
Msg 245, Level 16, State 1, Server ABABU-OTURI, Procedure sp_GetQuestionnaireDemographics, Line 8
Conversion failed when converting the varchar value 'N/A' to data type int.
1>
2>
3>
4> --Alter table section to change values on a column
5> ALTER VIEW vw_questionnaire_demographics AS
6> SELECT
7>     q.ID AS questionnaire_id,
8>     ISNULL(q.serial_number, 'Unknown') AS serial_number,
9>     ISNULL(q.date_of_data_collection, '2025-02-05') AS date_of_data_collection,
10>     ISNULL(CAST(s.age AS VARCHAR), 'N/A') AS age,  -- ✅ Fix: Ensure `age` is a string
11>     ISNULL(s.relationship, 'Unknown') AS relationship,
12>     ISNULL(s.guardian_occupation, 'Unknown') AS guardian_occupation,
13>     ISNULL(s.guardian_education, 'Unknown') AS guardian_education,
14>     ISNULL(s.respondent_religion, 'Unknown') AS respondent_religion,
15>     ISNULL(CAST(s.family_size AS VARCHAR), '0') AS family_size, -- ✅ Fix: Ensure `family_size` is a string
16>     ISNULL(s.has_siblings, 'No') AS has_siblings,
17>     ISNULL(s.siblings_have_partners, 'No') AS siblings_have_partners,
18>     ISNULL(s.gets_pocket_money, 'No') AS gets_pocket_money,
19>     ISNULL(s.pocket_money_adequate, 'No') AS pocket_money_adequate,
20>     ISNULL(s.financial_support, 'Unknown') AS financial_support,
21>     ISNULL(s.guardian_visits, 'No') AS guardian_visits,
22>     ISNULL(s.alternative_visitor, 'None') AS alternative_visitor -- ✅ Fix: Corrected column name
23> FROM questionnaire q
24> LEFT JOIN socio_economic_demographic s ON q.ID = s.questionnaire_id;
25> GO
1>
2>
3>
4> EXEC sp_GetQuestionnaireDemographics;
5> GO
questionnaire_id serial_number                                      date_of_data_collection age                            relationship
                                                                       guardian_occupation
                   guardian_education                                                                                   respondent_religion
                  family_size                    has_siblings siblings_have_partners gets_pocket_money pocket_money_adequate financial_support
                                                                         guardian_visits alternative_visitor

---------------- -------------------------------------------------- ----------------------- ------------------------------ ---------------------------------------------------------------------------------------------------- ---------------------------------------------------------------------------------------------------- ---------------------------------------------------------------------------------------------------- -------------------------------------------------- ------------------------------ ------------ ---------------------- ----------------- --------------------- ---------------------------------------------------------------------------------------------------- --------------- ----------------------------------------------------------------------------------------------------
               1 SN12345                                                         2025-02-05 N/A                            Unknown
                                                                       Unknown
                   Unknown                                                                                              Unknown
                  0                              No           No                     No                No                    Unknown
                                                                         No              None


(1 rows affected)
1>
2>
3>
4> --Also alter the table to improve functionalities and handle errors
5> ALTER VIEW vw_full_questionnaire AS
6> SELECT
7>     q.ID AS questionnaire_id,
8>     ISNULL(q.serial_number, 'Unknown') AS serial_number,
9>     ISNULL(q.date_of_data_collection, '2025-02-05') AS date_of_data_collection,
10>     ISNULL(CAST(s.age AS VARCHAR), 'N/A') AS age,  -- ✅ Fix: Ensure `age` is a string
11>     ISNULL(s.relationship, 'Unknown') AS relationship,
12>     ISNULL(s.guardian_occupation, 'Unknown') AS guardian_occupation,
13>     ISNULL(s.guardian_education, 'Unknown') AS guardian_education,
14>     ISNULL(s.respondent_religion, 'Unknown') AS respondent_religion,
15>     ISNULL(CAST(s.family_size AS VARCHAR), '0') AS family_size, -- ✅ Fix: Ensure `family_size` is a string
16>     ISNULL(s.has_siblings, 'No') AS has_siblings,
17>     ISNULL(s.siblings_have_partners, 'No') AS siblings_have_partners,
18>     ISNULL(s.gets_pocket_money, 'No') AS gets_pocket_money,
19>     ISNULL(s.pocket_money_adequate, 'No') AS pocket_money_adequate,
20>     ISNULL(s.financial_support, 'Unknown') AS financial_support,
21>     ISNULL(s.guardian_visits, 'No') AS guardian_visits,
22>     ISNULL(s.alternative_visitor, 'None') AS alternative_visitor,
23>     ISNULL(si.access_to_reproductive_health_info, 'No') AS access_to_reproductive_health_info,
24>     ISNULL(si.information_adequate, 'No') AS information_adequate,
25>     ISNULL(re.educator, 'Unknown') AS educator,
26>     ISNULL(rt.topic, 'Unknown') AS topic
27> FROM questionnaire q
28> LEFT JOIN socio_economic_demographic s ON q.ID = s.questionnaire_id
29> LEFT JOIN sources_information_sexual_behavior si ON q.ID = si.questionnaire_id
30> LEFT JOIN reproductive_health_education re ON q.ID = re.questionnaire_id
31> LEFT JOIN reproductive_health_topics rt ON q.ID = rt.questionnaire_id;
32> GO
1>
2>
3>
4> SELECT * FROM vw_full_questionnaire;
5> GO
questionnaire_id serial_number                                      date_of_data_collection age                            relationship
                                                                       guardian_occupation
                   guardian_education                                                                                   respondent_religion
                  family_size                    has_siblings siblings_have_partners gets_pocket_money pocket_money_adequate financial_support
                                                                         guardian_visits alternative_visitor
                                     access_to_reproductive_health_info information_adequate educator
                                         topic
---------------- -------------------------------------------------- ----------------------- ------------------------------ ---------------------------------------------------------------------------------------------------- ---------------------------------------------------------------------------------------------------- ---------------------------------------------------------------------------------------------------- -------------------------------------------------- ------------------------------ ------------ ---------------------- ----------------- --------------------- ---------------------------------------------------------------------------------------------------- --------------- ---------------------------------------------------------------------------------------------------- ---------------------------------- -------------------- ---------------------------------------------------------------------------------------------------- ----------------------------------------------------------------------------------------------------
               1 SN12345                                                         2025-02-05 N/A                            Unknown
                                                                       Unknown
                   Unknown                                                                                              Unknown
                  0                              No           No                     No                No                    Unknown
                                                                         No              None
                                     No                                 No                   Unknown
                                         Unknown

(1 rows affected)
1>
2>
3>
4> EXEC sp_InsertQuestionnaire 'SN12345', '2025-02-05';
5> EXEC sp_GetQuestionnaireDemographics;
6> EXEC sp_UpdateGuardianOccupation 1, 'Teacher';
7> GO
Msg 2627, Level 14, State 1, Server ABABU-OTURI, Procedure sp_InsertQuestionnaire, Line 12
Violation of UNIQUE KEY constraint 'UQ__question__BED14FEED685CAE1'. Cannot insert duplicate key in object 'dbo.questionnaire'. The duplicate key value is (SN12345).
The statement has been terminated.
questionnaire_id serial_number                                      date_of_data_collection age                            relationship
                                                                       guardian_occupation
                   guardian_education                                                                                   respondent_religion
                  family_size                    has_siblings siblings_have_partners gets_pocket_money pocket_money_adequate financial_support
                                                                         guardian_visits alternative_visitor

---------------- -------------------------------------------------- ----------------------- ------------------------------ ---------------------------------------------------------------------------------------------------- ---------------------------------------------------------------------------------------------------- ---------------------------------------------------------------------------------------------------- -------------------------------------------------- ------------------------------ ------------ ---------------------- ----------------- --------------------- ---------------------------------------------------------------------------------------------------- --------------- ----------------------------------------------------------------------------------------------------
               1 SN12345                                                         2025-02-05 N/A                            Unknown
                                                                       Unknown
                   Unknown                                                                                              Unknown
                  0                              No           No                     No                No                    Unknown
                                                                         No              None


(1 rows affected)

2> rows affected)
3>
4>
5> --Performance optimization by adding indexes to improve query speed
6> CREATE INDEX idx_questionnaire_id ON questionnaire(ID);
7> CREATE INDEX idx_socio_questionnaire_id ON socio_economic_demographic(questionnaire_id);
8> CREATE INDEX idx_sources_info_questionnaire_id ON sources_information_sexual_behavior(questionnaire_id);
9> CREATE INDEX idx_reproductive_health_questionnaire_id ON reproductive_health_education(questionnaire_id);
10> CREATE INDEX idx_reproductive_topics_questionnaire_id ON reproductive_health_topics(questionnaire_id);
11> GO
1>
2>
3>
4>
5> --Use of indexed views
6> CREATE VIEW vw_full_questionnaire WITH SCHEMABINDING AS
7> SELECT
8>     q.ID AS questionnaire_id,
9>     q.serial_number,
10>     q.date_of_data_collection,
11>     CAST(s.age AS VARCHAR) AS age,  -- Ensure correct data type
12>     s.relationship,
13>     s.guardian_occupation,
14>     s.guardian_education,
15>     s.respondent_religion,
16>     s.family_size,
17>     s.has_siblings,
18>     s.siblings_have_partners,
19>     s.gets_pocket_money,
20>     s.pocket_money_adequate,
21>     s.financial_support,
22>     s.guardian_visits,
23>     s.alternative_visitor,
24>     si.access_to_reproductive_health_info,
25>     si.information_adequate,
26>     re.educator,
27>     rt.topic
28> FROM dbo.questionnaire q
29> LEFT JOIN dbo.socio_economic_demographic s ON q.ID = s.questionnaire_id
30> LEFT JOIN dbo.sources_information_sexual_behavior si ON q.ID = si.questionnaire_id
31> LEFT JOIN dbo.reproductive_health_education re ON q.ID = re.questionnaire_id
32> LEFT JOIN dbo.reproductive_health_topics rt ON q.ID = rt.questionnaire_id;
33> GO
Msg 2714, Level 16, State 3, Server ABABU-OTURI, Procedure vw_full_questionnaire, Line 6
There is already an object named 'vw_full_questionnaire' in the database.
1>
2>
3> ALTER VIEW vw_full_questionnaire AS
4> SELECT
5>     q.ID AS questionnaire_id,
6>     ISNULL(q.serial_number, 'Unknown') AS serial_number,
7>     ISNULL(q.date_of_data_collection, '2025-02-05') AS date_of_data_collection,
8>     CAST(ISNULL(s.age, 'N/A') AS VARCHAR) AS age,  -- Ensure correct data type
9>     ISNULL(s.relationship, 'Unknown') AS relationship,
10>     ISNULL(s.guardian_occupation, 'Unknown') AS guardian_occupation,
11>     ISNULL(s.guardian_education, 'Unknown') AS guardian_education,
12>     ISNULL(s.respondent_religion, 'Unknown') AS respondent_religion,
13>     ISNULL(s.family_size, 0) AS family_size,
14>     ISNULL(s.has_siblings, 'No') AS has_siblings,
15>     ISNULL(s.siblings_have_partners, 'No') AS siblings_have_partners,
16>     ISNULL(s.gets_pocket_money, 'No') AS gets_pocket_money,
17>     ISNULL(s.pocket_money_adequate, 'No') AS pocket_money_adequate,
18>     ISNULL(s.financial_support, 'Unknown') AS financial_support,
19>     ISNULL(s.guardian_visits, 'No') AS guardian_visits,
20>     ISNULL(s.alternative_visitor, 'None') AS alternative_visitor,
21>     ISNULL(si.access_to_reproductive_health_info, 'No') AS access_to_reproductive_health_info,
22>     ISNULL(si.information_adequate, 'No') AS information_adequate,
23>     ISNULL(re.educator, 'Unknown') AS educator,
24>     ISNULL(rt.topic, 'Unknown') AS topic
25> FROM questionnaire q
26> LEFT JOIN socio_economic_demographic s ON q.ID = s.questionnaire_id
27> LEFT JOIN sources_information_sexual_behavior si ON q.ID = si.questionnaire_id
28> LEFT JOIN reproductive_health_education re ON q.ID = re.questionnaire_id
29> LEFT JOIN reproductive_health_topics rt ON q.ID = rt.questionnaire_id;
30> GO
1>
2>
3>
4> CREATE UNIQUE CLUSTERED INDEX idx_vw_full_questionnaire ON vw_full_questionnaire(questionnaire_id);
5> GO
Msg 1939, Level 16, State 1, Server ABABU-OTURI, Line 4
Cannot create index on view 'vw_full_questionnaire' because the view is not schema bound.
1>
2>
3>
4> ALTER VIEW dbo.vw_full_questionnaire
5> WITH SCHEMABINDING
6> AS
7> SELECT
8>     q.ID AS questionnaire_id,
9>     ISNULL(q.serial_number, 'Unknown') AS serial_number,
10>     ISNULL(q.date_of_data_collection, '2025-02-05') AS date_of_data_collection,
11>     CAST(ISNULL(s.age, 0) AS INT) AS age,  -- Ensure correct data type
12>     ISNULL(s.relationship, 'Unknown') AS relationship,
13>     ISNULL(s.guardian_occupation, 'Unknown') AS guardian_occupation,
14>     ISNULL(s.guardian_education, 'Unknown') AS guardian_education,
15>     ISNULL(s.respondent_religion, 'Unknown') AS respondent_religion,
16>     ISNULL(s.family_size, 0) AS family_size,
17>     ISNULL(s.has_siblings, 'No') AS has_siblings,
18>     ISNULL(s.siblings_have_partners, 'No') AS siblings_have_partners,
19>     ISNULL(s.gets_pocket_money, 'No') AS gets_pocket_money,
20>     ISNULL(s.pocket_money_adequate, 'No') AS pocket_money_adequate,
21>     ISNULL(s.financial_support, 'Unknown') AS financial_support,
22>     ISNULL(s.guardian_visits, 'No') AS guardian_visits,
23>     ISNULL(s.alternative_visitor, 'None') AS alternative_visitor,
24>     ISNULL(si.access_to_reproductive_health_info, 'No') AS access_to_reproductive_health_info,
25>     ISNULL(si.information_adequate, 'No') AS information_adequate,
26>     ISNULL(re.educator, 'Unknown') AS educator,
27>     ISNULL(rt.topic, 'Unknown') AS topic
28> FROM dbo.questionnaire q
29> LEFT JOIN dbo.socio_economic_demographic s ON q.ID = s.questionnaire_id
30> LEFT JOIN dbo.sources_information_sexual_behavior si ON q.ID = si.questionnaire_id
31> LEFT JOIN dbo.reproductive_health_education re ON q.ID = re.questionnaire_id
32> LEFT JOIN dbo.reproductive_health_topics rt ON q.ID = rt.questionnaire_id;
33> GO
1>
2>
3>
4> CREATE UNIQUE CLUSTERED INDEX IX_vw_full_questionnaire
5> ON dbo.vw_full_questionnaire (questionnaire_id);
6> GO
Msg 1935, Level 16, State 1, Server ABABU-OTURI, Line 4
Cannot create index. Object 'vw_full_questionnaire' was created with the following SET options off: 'QUOTED_IDENTIFIER'.
1>
2>
3>
4> SET NOCOUNT ON;
5> SELECT DATABASEPROPERTYEX(DB_NAME(), 'IsQuotedIdentifierOn') AS 'QUOTED_IDENTIFIER';
6> GO
QUOTED_IDENTIFIER




















































--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
NULL




















































1>
2>
3>
4> SET QUOTED_IDENTIFIER ON;
5> GO
1> SET QUOTED_IDENTIFIER ON;
2> CREATE VIEW vw_full_questionnaire AS
3> -- Your view definition here
4> GO
Msg 111, Level 15, State 1, Server ABABU-OTURI, Line 2
'CREATE VIEW' must be the first statement in a query batch.
1>
2>
3> SET QUOTED_IDENTIFIER ON;
4> GO
1>
2>
3>
4>
5> CREATE VIEW vw_full_questionnaire AS
6> -- Your view definition here
7> GO
Msg 102, Level 15, State 1, Server ABABU-OTURI, Procedure vw_full_questionnaire, Line 5
Incorrect syntax near 'AS'.
1> CREATE VIEW vw_full_questionnaire AS
2> -- Your view definition here
3>
4>
5> go
Msg 102, Level 15, State 1, Server ABABU-OTURI, Procedure vw_full_questionnaire, Line 1
Incorrect syntax near 'AS'.
1>
2>
3>
4>
5>
6>
7>
8> --inserting data to the tables
9> /*For questionnaire*/
10> INSERT INTO questionnaire (serial_number, date_of_data_collection)
11> VALUES
12> ('SN001', '2025-02-01'),
13> ('SN002', '2025-02-02'),
14> ('SN003', '2025-02-03'),
15> ('SN004', '2025-02-04'),
16> ('SN005', '2025-02-05');
17> GO
1>
2>
3>
4> --inser into table socio_economic_demographic
5> INSERT INTO socio_economic_demographic (
6>     questionnaire_id, age, relationship, guardian_occupation, guardian_education,
7>     respondent_religion, family_size, has_siblings, siblings_have_partners,
8>     gets_pocket_money, pocket_money_adequate, financial_support, guardian_visits,
9>     alternative_visitors
10> )
11> VALUES
12> (1, 16, 'Father and Mother', 'Self Employed', 'Secondary', 'Catholic', 5, 'Yes', 'No', 'Yes', 'Yes', 'Relatives', 'Yes', 'Relatives'),
13> (2, 18, 'Mother only', 'Employed by someone', 'Primary', 'Protestant', 3, 'No', 'No', 'Yes', 'No', 'Boyfriends', 'No', 'None'),
14> (3, 17, 'Father only', 'Farm Worker', 'None', 'Muslim', 6, 'Yes', 'Yes', 'No', 'No', 'Grandparents', 'Yes', 'Brothers/Sisters'),
15> (4, 15, 'Relative', 'Professional', 'Tertiary Education', 'SDA', 2, 'No', 'No', 'Yes', 'Yes', 'Other Friends', 'No', 'Man Friend'),
16> (5, 19, 'Father and Mother', 'Others', 'Secondary', 'None', 4, 'Yes', 'Yes', 'No', 'Yes', 'Relatives', 'Yes', 'Boyfriend');
17> GO
Msg 207, Level 16, State 1, Server ABABU-OTURI, Line 5
Invalid column name 'alternative_visitors'.
Msg 207, Level 16, State 1, Server ABABU-OTURI, Line 5
Invalid column name 'alternative_visitors'.
1>
2>
3>
4>  --inser into table socio_economic_demographic
5> INSERT INTO socio_economic_demographic (
6>     questionnaire_id, age, relationship, guardian_occupation, guardian_education,
7>     respondent_religion, family_size, has_siblings, siblings_have_partners,
8>     gets_pocket_money, pocket_money_adequate, financial_support, guardian_visits,
9>     alternative_vistor  -- Corrected column name
10> )
11> VALUES
12> (1, 16, 'Father and Mother', 'Self Employed', 'Secondary', 'Catholic', 5, 'Yes', 'No', 'Yes', 'Yes', 'Relatives', 'Yes', 'Relatives'),
13> (2, 18, 'Mother only', 'Employed by someone', 'Primary', 'Protestant', 3, 'No', 'No', 'Yes', 'No', 'Boyfriends', 'No', 'None'),
14> (3, 17, 'Father only', 'Farm Worker', 'None', 'Muslim', 6, 'Yes', 'Yes', 'No', 'No', 'Grandparents', 'Yes', 'Brothers/Sisters'),
15> (4, 15, 'Relative', 'Professional', 'Tertiary Education', 'SDA', 2, 'No', 'No', 'Yes', 'Yes', 'Other Friends', 'No', 'Man Friend'),
16> (5, 19, 'Father and Mother', 'Others', 'Secondary', 'None', 4, 'Yes', 'Yes', 'No', 'Yes', 'Relatives', 'Yes', 'Boyfriend');
17> GO
Msg 207, Level 16, State 1, Server ABABU-OTURI, Line 5
Invalid column name 'alternative_vistor'.
Msg 207, Level 16, State 1, Server ABABU-OTURI, Line 5
Invalid column name 'alternative_vistor'.
1>
2>
3>
4>
5> --insert into sources_information_sexual_behavior
6> INSERT INTO sources_information_sexual_behavior (questionnaire_id, access_to_reproductive_health_info, information_adequate)
7> VALUES
8> (1, 'Yes', 'No'),
9> (2, 'No', 'No'),
10> (3, 'Yes', 'Yes'),
11> (4, 'No', 'Yes'),
12> (5, 'Yes', 'Yes');
13> GO
Msg 547, Level 16, State 1, Server ABABU-OTURI, Line 6
The INSERT statement conflicted with the FOREIGN KEY constraint "FK__sources_i__quest__24927208". The conflict occurred in database "questionnaire", table "dbo.questionnaire", column 'ID'.
The statement has been terminated.
1>
2>
3> INSERT INTO reproductive_health_education (questionnaire_id, educator)
4> VALUES
5> (1, 'Teachers'),
6> (2, 'Parents'),
7> (3, 'Health Worker'),
8> (4, 'Friends'),
9> (5, 'Radio Magazines/TV');
10> GO
Msg 547, Level 16, State 1, Server ABABU-OTURI, Line 3
The INSERT statement conflicted with the FOREIGN KEY constraint "FK__reproduct__quest__286302EC". The conflict occurred in database "questionnaire", table "dbo.questionnaire", column 'ID'.
The statement has been terminated.
1>
2>
3>
4> INSERT INTO reproductive_health_topics (questionnaire_id, topic)
5> VALUES
6> (1, 'Sexuality'),
7> (2, 'Abstinence'),
8> (3, 'Condoms'),
9> (4, 'STI/HIV'),
10> (5, 'Relationships');
11> GO
Msg 547, Level 16, State 1, Server ABABU-OTURI, Line 4
The INSERT statement conflicted with the FOREIGN KEY constraint "FK__reproduct__quest__2C3393D0". The conflict occurred in database "questionnaire", table "dbo.questionnaire", column 'ID'.
The statement has been terminated.
1>
2>
3>
4>
5> SELECT ID FROM dbo.questionnaire WHERE ID IN (1, 2, 3, 4, 5);
6> GO
ID
-----------
          1
          3
          4
          5
1>
2>
3> INSERT INTO dbo.questionnaire (ID)
4> VALUES (1), (2), (3), (4), (5);
5> GO
Msg 544, Level 16, State 1, Server ABABU-OTURI, Line 3
Cannot insert explicit value for identity column in table 'questionnaire' when IDENTITY_INSERT is set to OFF.
1>
2>
3>
4> SET IDENTITY_INSERT dbo.questionnaire ON;
5> GO
1> GO
1> INSERT INTO dbo.questionnaire (ID)
2> VALUES (1), (2), (3), (4), (5);
3> GO
Msg 515, Level 16, State 2, Server ABABU-OTURI, Line 1
Cannot insert the value NULL into column 'serial_number', table 'questionnaire.dbo.questionnaire'; column does not allow nulls. INSERT fails.
The statement has been terminated.
1>
2>
3>
4> SET IDENTITY_INSERT dbo.questionnaire ON;
5> GO
1>
2> INSERT INTO dbo.questionnaire (ID, serial_number)
3> VALUES (1, 'SN001'), (2, 'SN002'), (3, 'SN003'), (4, 'SN004'), (5, 'SN005');
4> GO
Msg 515, Level 16, State 2, Server ABABU-OTURI, Line 2
Cannot insert the value NULL into column 'date_of_data_collection', table 'questionnaire.dbo.questionnaire'; column does not allow nulls. INSERT fails.
The statement has been terminated.
1> ALTER TABLE dbo.questionnaire
2> ALTER COLUMN serial_number VARCHAR(255) NULL;
3> GO
Msg 5074, Level 16, State 1, Server ABABU-OTURI, Line 1
The object 'vw_full_questionnaire' is dependent on column 'serial_number'.
Msg 4922, Level 16, State 9, Server ABABU-OTURI, Line 1
ALTER TABLE ALTER COLUMN serial_number failed because one or more objects access this column.
1> GO
1>
2>
3> SET IDENTITY_INSERT dbo.questionnaire ON;
4> GO
1>
2> INSERT INTO dbo.questionnaire (ID, serial_number)
3> VALUES (1, 'SN001'), (2, 'SN002'), (3, 'SN003'), (4, 'SN004'), (5, 'SN005');
4> GO
Msg 515, Level 16, State 2, Server ABABU-OTURI, Line 2
Cannot insert the value NULL into column 'date_of_data_collection', table 'questionnaire.dbo.questionnaire'; column does not allow nulls. INSERT fails.
The statement has been terminated.
1>
2> SET IDENTITY_INSERT dbo.questionnaire OFF;
3> GO
1>
2>
3>
4>
5> INSERT INTO questionnaire (serial_number, date_of_data_collection)
6> VALUES
7> ('SN001', '2025-02-01'),
8> ('SN002', '2025-02-02'),
9> ('SN003', '2025-02-03'),
10> ('SN004', '2025-02-04'),
11> ('SN005', '2025-02-05');
12> GO
Msg 2627, Level 14, State 1, Server ABABU-OTURI, Line 5
Violation of UNIQUE KEY constraint 'UQ__question__BED14FEED685CAE1'. Cannot insert duplicate key in object 'dbo.questionnaire'. The duplicate key value is (SN001).
The statement has been terminated.
1>
2>
3> DELETE FROM dbo.questionnaire;
4> GO
1>
2>
3> INSERT INTO dbo.questionnaire (serial_number, date_of_data_collection)
4> VALUES
5> ('SN001', '2025-02-01'),
6> ('SN002', '2025-02-02'),
7> ('SN003', '2025-02-03'),
8> ('SN004', '2025-02-04'),
9> ('SN005', '2025-02-05');
10> GO
1>
2>
3>
4>
5> SELECT * FROM dbo.questionnaire;
6> GO
ID          serial_number                                      date_of_data_collection
----------- -------------------------------------------------- -----------------------
          9 SN001                                                           2025-02-01
         10 SN002                                                           2025-02-02
         11 SN003                                                           2025-02-03
         12 SN004                                                           2025-02-04
         13 SN005                                                           2025-02-05
1>
2>
3>
4>
5>
6>
7> INSERT INTO socio_economic_demographic (
8>     questionnaire_id, age, relationship, guardian_occupation, guardian_education,
9>     respondent_religion, family_size, has_siblings, siblings_have_partners,
10>     gets_pocket_money, pocket_money_adequate, financial_support, guardian_visits,
11>     alternative_visitors
12> )
13> VALUES
14> (9, 16, 'Father and Mother', 'Self Employed', 'Secondary', 'Catholic', 5, 'Yes', 'No', 'Yes', 'Yes', 'Relatives', 'Yes', 'Relatives'),
15> (10, 18, 'Mother only', 'Employed by someone', 'Primary', 'Protestant', 3, 'No', 'No', 'Yes', 'No', 'Boyfriends', 'No', 'None'),
16> (11, 17, 'Father only', 'Farm Worker', 'None', 'Muslim', 6, 'Yes', 'Yes', 'No', 'No', 'Grandparents', 'Yes', 'Brothers/Sisters'),
17> (12, 15, 'Relative', 'Professional', 'Tertiary Education', 'SDA', 2, 'No', 'No', 'Yes', 'Yes', 'Other Friends', 'No', 'Man Friend'),
18> (13, 19, 'Father and Mother', 'Others', 'Secondary', 'None', 4, 'Yes', 'Yes', 'No', 'Yes', 'Relatives', 'Yes', 'Boyfriend');
19> GO
Msg 207, Level 16, State 1, Server ABABU-OTURI, Line 7
Invalid column name 'alternative_visitors'.
Msg 207, Level 16, State 1, Server ABABU-OTURI, Line 7
Invalid column name 'alternative_visitors'.
1>
2>
3> EXEC sp_columns 'socio_economic_demographic';
4> GO
TABLE_QUALIFIER                                                                                                                  TABLE_OWNER
                                                                                                         TABLE_NAME
                                                                                 COLUMN_NAME
                                                         DATA_TYPE TYPE_NAME
                                           PRECISION   LENGTH      SCALE  RADIX  NULLABLE REMARKS

                                       COLUMN_DEF

























                                                              SQL_DATA_TYPE SQL_DATETIME_SUB CHAR_OCTET_LENGTH ORDINAL_POSITION IS_NULLABLE

                                                                             SS_DATA_TYPE
-------------------------------------------------------------------------------------------------------------------------------- -------------------------------------------------------------------------------------------------------------------------------- -------------------------------------------------------------------------------------------------------------------------------- -------------------------------------------------------------------------------------------------------------------------------- --------- -------------------------------------------------------------------------------------------------------------------------------- ----------- ----------- ------ ------ -------- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ------------- ---------------- ----------------- ---------------- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ------------
questionnaire                                                                                                                    dbo
                                                                                                         socio_economic_demographic
                                                                                 ID
                                                                 4 int identity
                                                    10           4      0     10        0 NULL

                                       NULL

























                                                                          4             NULL              NULL                1 NO

                                                                                       56
questionnaire                                                                                                                    dbo
                                                                                                         socio_economic_demographic
                                                                                 questionnaire_id
                                                                 4 int
                                                    10           4      0     10        0 NULL

                                       NULL

























                                                                          4             NULL              NULL                2 NO

                                                                                       56
questionnaire                                                                                                                    dbo
                                                                                                         socio_economic_demographic
                                                                                 age
                                                                 4 int
                                                    10           4      0     10        1 NULL

                                       NULL

























                                                                          4             NULL              NULL                3 YES

                                                                                       38
questionnaire                                                                                                                    dbo
                                                                                                         socio_economic_demographic
                                                                                 relationship
                                                                12 varchar
                                                   100         100   NULL   NULL        0 NULL

                                       NULL

























                                                                         12             NULL               100                4 NO

                                                                                       39
questionnaire                                                                                                                    dbo
                                                                                                         socio_economic_demographic
                                                                                 guardian_occupation
                                                                12 varchar
                                                   100         100   NULL   NULL        0 NULL

                                       NULL

























                                                                         12             NULL               100                5 NO

                                                                                       39
questionnaire                                                                                                                    dbo
                                                                                                         socio_economic_demographic
                                                                                 guardian_education
                                                                12 varchar
                                                   100         100   NULL   NULL        0 NULL

                                       NULL

























                                                                         12             NULL               100                6 NO

                                                                                       39
questionnaire                                                                                                                    dbo
                                                                                                         socio_economic_demographic
                                                                                 respondent_religion
                                                                12 varchar
                                                    50          50   NULL   NULL        0 NULL

                                       NULL

























                                                                         12             NULL                50                7 NO

                                                                                       39
questionnaire                                                                                                                    dbo
                                                                                                         socio_economic_demographic
                                                                                 family_size
                                                                 4 int
                                                    10           4      0     10        0 NULL

                                       NULL

























                                                                          4             NULL              NULL                8 NO

                                                                                       56
questionnaire                                                                                                                    dbo
                                                                                                         socio_economic_demographic
                                                                                 has_siblings
                                                                12 varchar
                                                     3           3   NULL   NULL        0 NULL

                                       NULL

























                                                                         12             NULL                 3                9 NO

                                                                                       39
questionnaire                                                                                                                    dbo
                                                                                                         socio_economic_demographic
                                                                                 siblings_have_partners
                                                                12 varchar
                                                     3           3   NULL   NULL        0 NULL

                                       NULL

























                                                                         12             NULL                 3               10 NO

                                                                                       39
questionnaire                                                                                                                    dbo
                                                                                                         socio_economic_demographic
                                                                                 gets_pocket_money
                                                                12 varchar
                                                     3           3   NULL   NULL        0 NULL

                                       NULL

























                                                                         12             NULL                 3               11 NO

                                                                                       39
questionnaire                                                                                                                    dbo
                                                                                                         socio_economic_demographic
                                                                                 pocket_money_adequate
                                                                12 varchar
                                                     3           3   NULL   NULL        0 NULL

                                       NULL

























                                                                         12             NULL                 3               12 NO

                                                                                       39
questionnaire                                                                                                                    dbo
                                                                                                         socio_economic_demographic
                                                                                 financial_support
                                                                12 varchar
                                                   100         100   NULL   NULL        0 NULL

                                       NULL

























                                                                         12             NULL               100               13 NO

                                                                                       39
questionnaire                                                                                                                    dbo
                                                                                                         socio_economic_demographic
                                                                                 guardian_visits
                                                                12 varchar
                                                     3           3   NULL   NULL        0 NULL

                                       NULL

























                                                                         12             NULL                 3               14 NO

                                                                                       39
questionnaire                                                                                                                    dbo
                                                                                                         socio_economic_demographic
                                                                                 alternative_visitor
                                                                12 varchar
                                                   100         100   NULL   NULL        0 NULL

                                       NULL

























                                                                         12             NULL               100               15 NO

                                                                                       39
1>
2>
3> INSERT INTO socio_economic_demographic (
4>     questionnaire_id, age, relationship, guardian_occupation, guardian_education,
5>     respondent_religion, family_size, has_siblings, siblings_have_partners,
6>     gets_pocket_money, pocket_money_adequate, financial_support, guardian_visits,
7>     alternative_visitor
8> )
9> VALUES
10> (9, 16, 'Father and Mother', 'Self Employed', 'Secondary', 'Catholic', 5, 'Yes', 'No', 'Yes', 'Yes', 'Relatives', 'Yes', 'Relatives'),
11> (10, 18, 'Mother only', 'Employed by someone', 'Primary', 'Protestant', 3, 'No', 'No', 'Yes', 'No', 'Boyfriends', 'No', 'None'),
12> (11, 17, 'Father only', 'Farm Worker', 'None', 'Muslim', 6, 'Yes', 'Yes', 'No', 'No', 'Grandparents', 'Yes', 'Brothers/Sisters'),
13> (12, 15, 'Relative', 'Professional', 'Tertiary Education', 'SDA', 2, 'No', 'No', 'Yes', 'Yes', 'Other Friends', 'No', 'Man Friend'),
14> (13, 19, 'Father and Mother', 'Others', 'Secondary', 'None', 4, 'Yes', 'Yes', 'No', 'Yes', 'Relatives', 'Yes', 'Boyfriend');
15> GO
1>
2>
3> SELECT * FROM socio_economic_demographic;
4> GO
ID          questionnaire_id age         relationship                                                                                         guardian_occupation                                                                                  guardian_education
                                      respondent_religion                                family_size has_siblings siblings_have_partners gets_pocket_money pocket_money_adequate financial_support                                                                                    guardian_visits alternative_visitor
----------- ---------------- ----------- ---------------------------------------------------------------------------------------------------- ---------------------------------------------------------------------------------------------------- ---------------------------------------------------------------------------------------------------- -------------------------------------------------- ----------- ------------ ---------------------- ----------------- --------------------- ---------------------------------------------------------------------------------------------------- --------------- ----------------------------------------------------------------------------------------------------
          1                9          16 Father and Mother                                                                                    Self Employed                                                                                        Secondary
                                      Catholic                                                     5 Yes          No                     Yes
  Yes                   Relatives                                                                                            Yes             Relatives

          2               10          18 Mother only                                                                                          Employed by someone                                                                                  Primary
                                      Protestant                                                   3 No           No                     Yes
  No                    Boyfriends                                                                                           No              None

          3               11          17 Father only                                                                                          Farm Worker                                                                                          None
                                      Muslim                                                       6 Yes          Yes                    No
  No                    Grandparents                                                                                         Yes             Brothers/Sisters
          4               12          15 Relative                                                                                             Professional                                                                                         Tertiary Education
                                      SDA                                                          2 No           No                     Yes
  Yes                   Other Friends                                                                                        No              Man Friend

          5               13          19 Father and Mother                                                                                    Others                                                                                               Secondary
                                      None                                                         4 Yes          Yes                    No
  Yes                   Relatives                                                                                            Yes             Boyfriend

1>
2>
3>
4>
5> INSERT INTO sources_information_sexual_behavior (questionnaire_id, access_to_reproductive_health_info, information_adequate)
6> VALUES
7> (9, 'Yes', 'No'),
8> (10, 'No', 'No'),
9> (11, 'Yes', 'Yes'),
10> (12, 'No', 'Yes'),
11> (13, 'Yes', 'Yes');
12> GO
1>
2>
3>
4> SELECT * FROM sources_information_sexual_behavior;
5> GO
ID          questionnaire_id access_to_reproductive_health_info information_adequate
----------- ---------------- ---------------------------------- --------------------
          3                9 Yes                                No
          4               10 No                                 No
          5               11 Yes                                Yes
          6               12 No                                 Yes
          7               13 Yes                                Yes
1>
2>
3>
4>
5> INSERT INTO reproductive_health_education (questionnaire_id, educator)
6> VALUES
7> (9, 'Teachers'),
8> (10, 'Parents'),
9> (11, 'Health Worker'),
10> (12, 'Friends'),
11> (13, 'Radio Magazines/TV');
12> GO
1>
2>
3> SELECT * FROM  reproductive_health_education;
4> GO
ID          questionnaire_id educator
----------- ---------------- ----------------------------------------------------------------------------------------------------
          3                9 Teachers
          4               10 Parents
          5               11 Health Worker
          6               12 Friends
          7               13 Radio Magazines/TV
1>
2>
3>
4>
5> INSERT INTO reproductive_health_topics (questionnaire_id, topic)
6> VALUES
7> (9, 'Sexuality'),
8> (10, 'Abstinence'),
9> (11, 'Condoms'),
10> (12, 'STI/HIV'),
11> (13, 'Relationships');
12> GO
1>
2>
3>
4> SELECT * FROM  reproductive_health_topics;
5> GO
ID          questionnaire_id topic
----------- ---------------- ----------------------------------------------------------------------------------------------------
          3                9 Sexuality
          4               10 Abstinence
          5               11 Condoms
          6               12 STI/HIV
          7               13 Relationships
1>