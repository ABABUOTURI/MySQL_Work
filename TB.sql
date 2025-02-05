--Table1
CREATE TABLE questionnaire (
    serial_number INT IDENTITY(1,1) PRIMARY KEY,  -- Auto-generated serial number
    educator VARCHAR(255) NOT NULL CHECK (educator IN ('Teachers', 'Parents', 'Health Worker', 'Friends', 'Radio Magazines/TV')),
    topic VARCHAR(255) NOT NULL CHECK (topic IN ('Sexuality', 'Abstinence', 'Condoms', 'STI/HIV', 'Relationships')),
    age INT NOT NULL CHECK (age BETWEEN 15 AND 19),
    relationship VARCHAR(255) NOT NULL CHECK (relationship IN ('Father and Mother', 'Mother only', 'Father only', 'Relative')),
    guardian_occupation VARCHAR(255) NOT NULL CHECK (guardian_occupation IN ('Farm Worker', 'Self Employed', 'Employed by someone', 'Professional', 'Others')),
    guardian_education VARCHAR(255) NOT NULL CHECK (guardian_education IN ('None', 'Primary', 'Secondary', 'Tertiary Education')),
    respondent_religion VARCHAR(255) NOT NULL CHECK (respondent_religion IN ('Catholic', 'Protestant', 'Muslim', 'SDA', 'None')),
    family_size INT NOT NULL CHECK (family_size >= 0),
    has_siblings VARCHAR(3) NOT NULL CHECK (has_siblings IN ('Yes', 'No')),
    siblings_have_partners VARCHAR(3) NOT NULL CHECK (siblings_have_partners IN ('Yes', 'No')),
    gets_pocket_money VARCHAR(3) NOT NULL CHECK (gets_pocket_money IN ('Yes', 'No')),
    pocket_money_adequate VARCHAR(3) NOT NULL CHECK (pocket_money_adequate IN ('Yes', 'No')),
    financial_support VARCHAR(255) NOT NULL CHECK (financial_support IN ('Relatives', 'Boyfriends', 'Grandparents', 'Other Friends')),
    guardian_visits VARCHAR(3) NOT NULL CHECK (guardian_visits IN ('Yes', 'No')),
    alternative_visitor VARCHAR(255) NOT NULL CHECK (alternative_visitor IN ('Boyfriend', 'Relatives', 'Brothers/Sisters', 'Man Friend', 'None')),
    access_to_reproductive_health_info VARCHAR(3) NOT NULL CHECK (access_to_reproductive_health_info IN ('Yes', 'No')),
    information_adequate VARCHAR(3) NOT NULL CHECK (information_adequate IN ('Yes', 'No')),
    date_of_data_collection DATE NOT NULL
);
GO



--Stored procedure
CREATE PROCEDURE insert_questionnaire_data
    @educator VARCHAR(255),
    @topic VARCHAR(255),
    @age INT,
    @relationship VARCHAR(255),
    @guardian_occupation VARCHAR(255),
    @guardian_education VARCHAR(255),
    @respondent_religion VARCHAR(255),
    @family_size INT,
    @has_siblings VARCHAR(3),
    @siblings_have_partners VARCHAR(3),
    @gets_pocket_money VARCHAR(3),
    @pocket_money_adequate VARCHAR(3),
    @financial_support VARCHAR(255),
    @guardian_visits VARCHAR(3),
    @alternative_visitor VARCHAR(255),
    @access_to_reproductive_health_info VARCHAR(3),
    @information_adequate VARCHAR(3),
    @date_of_data_collection DATE
AS
BEGIN
    INSERT INTO questionnaire
    (educator, topic, age, relationship, guardian_occupation, guardian_education, respondent_religion, 
    family_size, has_siblings, siblings_have_partners, gets_pocket_money, pocket_money_adequate, 
    financial_support, guardian_visits, alternative_visitor, access_to_reproductive_health_info, 
    information_adequate, date_of_data_collection)
    VALUES
    (@educator, @topic, @age, @relationship, @guardian_occupation, @guardian_education, @respondent_religion,
    @family_size, @has_siblings, @siblings_have_partners, @gets_pocket_money, @pocket_money_adequate, 
    @financial_support, @guardian_visits, @alternative_visitor, @access_to_reproductive_health_info, 
    @information_adequate, @date_of_data_collection);
END;
GO



--View
CREATE VIEW vw_questionnaire_summary AS
SELECT 
    serial_number,
    educator,
    topic,
    age,
    relationship,
    guardian_occupation,
    guardian_education,
    respondent_religion,
    family_size,
    has_siblings,
    siblings_have_partners,
    gets_pocket_money,
    pocket_money_adequate,
    financial_support,
    guardian_visits,
    alternative_visitor,
    access_to_reproductive_health_info,
    information_adequate,
    date_of_data_collection
FROM questionnaire;
GO



--indexes
CREATE INDEX idx_age ON questionnaire (age);
CREATE INDEX idx_educator ON questionnaire (educator);
CREATE INDEX idx_topic ON questionnaire (topic);
GO


