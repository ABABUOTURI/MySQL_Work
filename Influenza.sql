sqlcmd -S . -E


--Creating databse for influenza program questionnaire
CREATE DATABASE Influenza;
GO

--To display the database in place
SELECT name
FROM sys.databases;
GO


--To use the craeted database
USE Influenza;
GO

/*Below is a database schema*/

--Table1 with basic information of the questionnaires
CREATE TABLE questionnaire (
    ID INT PRIMARY KEY IDENTITY(1,1),       -- Primary Key, Auto-incremented ID
    serial_number VARCHAR(50),               -- Unique serial number
    date_of_data_collection DATE            -- Date of data collection
);



--Table2 information about socio_economic_demographic
CREATE TABLE socio_economic_demographic (
    ID INT PRIMARY KEY IDENTITY(1,1),       -- Primary Key, Auto-incremented ID
    questionnaire_id INT,                    -- Foreign key to `questionnaire`
    age VARCHAR(50),                         -- Age group
    relationship VARCHAR(100),               -- Relationship status
    guardian_occupation VARCHAR(100),        -- Occupation of the guardian
    guardian_education VARCHAR(100),         -- Education level of the guardian
    respondent_religion VARCHAR(50),         -- Religion of the respondent
    family_size INT,                         -- Family size
    has_siblings VARCHAR(10),                -- Whether they have siblings (Yes/No)
    siblings_have_partners VARCHAR(10),      -- Whether siblings have partners (Yes/No)
    gets_pocket_money VARCHAR(10),           -- Whether they get pocket money (Yes/No)
    pocket_money_adequate VARCHAR(10),       -- Whether the pocket money is adequate (Yes/No)
    financial_support VARCHAR(100),          -- Type of financial support
    guardian_visits VARCHAR(10),             -- Whether the guardian visits (Yes/No)
    alternative_visitors VARCHAR(100),       -- Alternative visitors to the respondent
    FOREIGN KEY (questionnaire_id) REFERENCES questionnaire(ID) -- Foreign Key relation
);
GO



--Table3 information about sources_information_sexual_behavior
CREATE TABLE sources_information_sexual_behavior (
    ID INT PRIMARY KEY IDENTITY(1,1),       -- Primary Key, Auto-incremented ID
    questionnaire_id INT,                    -- Foreign key to `questionnaire`
    access_to_reproductive_health_info VARCHAR(10), -- Whether they have access to info (Yes/No)
    information_adequate VARCHAR(10),        -- Whether the info is adequate (Yes/No)
    FOREIGN KEY (questionnaire_id) REFERENCES questionnaire(ID) -- Foreign Key relation
);
GO


--Table4 reproductive_health_education
CREATE TABLE reproductive_health_education (
    ID INT PRIMARY KEY IDENTITY(1,1),       -- Primary Key, Auto-incremented ID
    questionnaire_id INT,                    -- Foreign key to `questionnaire`
    educator VARCHAR(100),                   -- Name of the educator
    FOREIGN KEY (questionnaire_id) REFERENCES questionnaire(ID) -- Foreign Key relation
);
GO


--Table5 information about reproductive_health-topics
CREATE TABLE reproductive_health_topics (
    ID INT PRIMARY KEY IDENTITY(1,1),       -- Primary Key, Auto-incremented ID
    questionnaire_id INT,                    -- Foreign key to `questionnaire`
    topic VARCHAR(100),                      -- Topic related to reproductive health
    FOREIGN KEY (questionnaire_id) REFERENCES questionnaire(ID) -- Foreign Key relation
);
GO




--To display all created tables
SELECT name FROM sys.tables;
GO




--Below is database views
CREATE VIEW vw_full_questionnaire AS
SELECT 
    q.serial_number,
    q.date_of_data_collection,
    sed.age,
    sed.relationship,
    sed.guardian_occupation,
    si.access_to_reproductive_health_info,
    rhe.educator,
    rht.topic
FROM 
    questionnaire q
JOIN 
    socio_economic_demographic sed ON q.ID = sed.questionnaire_id
JOIN 
    sources_information_sexual_behavior si ON q.ID = si.questionnaire_id
JOIN 
    reproductive_health_education rhe ON q.ID = rhe.questionnaire_id
JOIN 
    reproductive_health_topics rht ON q.ID = rht.questionnaire_id;




--Below is stored procedure
CREATE PROCEDURE InsertQuestionnaireData
    @serial_number VARCHAR(50),
    @date_of_data_collection DATE,
    @age VARCHAR(50),
    @relationship VARCHAR(100),
    @guardian_occupation VARCHAR(100),
    @guardian_education VARCHAR(100),
    @respondent_religion VARCHAR(50),
    @family_size INT,
    @has_siblings VARCHAR(10),
    @siblings_have_partners VARCHAR(10),
    @gets_pocket_money VARCHAR(10),
    @pocket_money_adequate VARCHAR(10),
    @financial_support VARCHAR(100),
    @guardian_visits VARCHAR(10),
    @alternative_visitors VARCHAR(100),
    @access_to_reproductive_health_info VARCHAR(10),
    @information_adequate VARCHAR(10),
    @educator VARCHAR(100),
    @topic VARCHAR(100)
AS
BEGIN
    -- Insert into questionnaire table
    INSERT INTO questionnaire (serial_number, date_of_data_collection)
    VALUES (@serial_number, @date_of_data_collection);

    DECLARE @questionnaire_id INT;
    SET @questionnaire_id = SCOPE_IDENTITY();

    -- Insert into socio_economic_demographic table
    INSERT INTO socio_economic_demographic 
    (questionnaire_id, age, relationship, guardian_occupation, guardian_education, respondent_religion, family_size, has_siblings, siblings_have_partners, gets_pocket_money, pocket_money_adequate, financial_support, guardian_visits, alternative_visitors)
    VALUES
    (@questionnaire_id, @age, @relationship, @guardian_occupation, @guardian_education, @respondent_religion, @family_size, @has_siblings, @siblings_have_partners, @gets_pocket_money, @pocket_money_adequate, @financial_support, @guardian_visits, @alternative_visitors);

    -- Insert into sources_information_sexual_behavior
    INSERT INTO sources_information_sexual_behavior (questionnaire_id, access_to_reproductive_health_info, information_adequate)
    VALUES
    (@questionnaire_id, @access_to_reproductive_health_info, @information_adequate);

    -- Insert into reproductive_health_education
    INSERT INTO reproductive_health_education (questionnaire_id, educator)
    VALUES
    (@questionnaire_id, @educator);

    -- Insert into reproductive_health_topics
    INSERT INTO reproductive_health_topics (questionnaire_id, topic)
    VALUES
    (@questionnaire_id, @topic);
END;




