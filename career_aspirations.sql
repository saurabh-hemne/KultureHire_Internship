CREATE SCHEMA kulturehire;

USE kulturehire;

CREATE TABLE career_aspirations (
`date` DATE,
`time` TIME,
country ENUM('AFG','CAN','DEU','IND','IRL','LKA','MYS','NGA','OTH','PAK','UAE','USA'),
zip_code VARCHAR(7),
gender ENUM('M','F','O','T'),
influencing_factors VARCHAR(28),
higher_education_abroad ENUM('Self Funded','Dependent on Sponsorship','Not Interested'),
work_for_3_plus_years ENUM('Committed','Depends on Company','No'),
work_without_clear_mission ENUM('Yes','No'),
work_with_misaligned_mission ENUM('Yes','No'),
work_without_social_impact TINYINT UNSIGNED,
preferred_employers ENUM('Appreciative and Enabling','Appreciative but Non Enabling',
'Challenging and Non Supportive','Challenging and Rewarding','Learning Focused and Rewarding'),
preferred_learning_environment VARCHAR(35),
aspirational_career_choice VARCHAR(40),
preferred_manager ENUM('Goal Oriented Manager','Supportive Goal Setting Manager','Clear-Expectations Manager',
'Target Driven Manager','Unrealistic Target Manager     '),
preferred_team VARCHAR(21),
preferred_team_size ENUM('1-10+','5-6','2-6','2-3','10+','1-6','1','5-10+','1-3','2-10+','7-10','2-10'),
work_after_layoffs VARCHAR(9),
work_for_7_plus_years VARCHAR(18),
email_address VARCHAR(70),
min_salary_first_3_years_in_k ENUM('31-40','21-25','51+','26-30','16-20','41-50','11-15','5-10'),
min_salary_after_5_years_in_k ENUM('91-110','50-70','151+','71-90','111-130','131-150','30-50'),
work_without_remote_option TINYINT UNSIGNED,
salary_for_first_job_in_k ENUM('31-40','26-30','21-25','16-20','10-15'),
work_under_abusive_manager ENUM('Yes','No'),
preferred_daily_work_hours TINYINT UNSIGNED,
preferred_break_to_stay_healthy ENUM('Once in 2 months','Once in 3 months','Once in 6 months','Once in 12 months'),
workplace_frustration_factors ENUM('Unclear work without any goals','Political Environment','Unsupportive Managers',
'Lack of Transparency','Unclear work with a goal','Often a need to learn New Skills','High stressful job'),
has_email ENUM('Yes','No'),
preferred_work_mode ENUM('Remote', 'Hybrid', 'Office'),
company_type ENUM('Established Startup','Mid Size Company','Corporation','Micro Startup','Large Company'),
team_size ENUM('51–250','251–1000','>3000','<50','1001–3000'),
less_working_hours ENUM('Yes','No'),
meaningful_impact_of_work ENUM('Yes','No'),
supportive_manager ENUM('Yes','No'),
work_involves_passion ENUM('Yes','No'),
great_compensation ENUM('Yes','No'),
non_political_environment ENUM('Yes','No'));

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/clean_data.csv'
INTO TABLE career_aspirations
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

DESCRIBE career_aspirations;

SELECT * FROM career_aspirations;

-- Q1. What industries are Gen-Z most interested in pursuing careers in?

SELECT aspirational_career_choice, COUNT(*) AS interest_count
FROM career_aspirations
GROUP BY aspirational_career_choice
ORDER BY interest_count DESC
LIMIT 5;

-- Q2. What are the top factors influencing Gen-Z's career choices?

SELECT influencing_factors, COUNT(*) AS factor_count
FROM career_aspirations
GROUP BY influencing_factors
ORDER BY factor_count DESC;

-- Q3. What is the desired work environment for Gen-Z?

SELECT preferred_work_mode, COUNT(*) AS preference_count
FROM career_aspirations
GROUP BY preferred_work_mode
ORDER BY preference_count DESC;

-- Q4. How do financial goals such as salary and benefits impact career aspirations among Gen-Z?

SELECT salary_for_first_job_in_k, preferred_break_to_stay_healthy, COUNT(*) AS preference_count
FROM career_aspirations
GROUP BY salary_for_first_job_in_k, preferred_break_to_stay_healthy
ORDER BY preference_count DESC, preferred_break_to_stay_healthy DESC;

-- Q5. What role do personal values and social impact play in career choices for Gen-Z?

SELECT meaningful_impact_of_work, work_involves_passion, COUNT(*) AS respondents,
CASE 
WHEN meaningful_impact_of_work = 'Yes' AND work_involves_passion = 'Yes' THEN 'High Passion & High Impact'
WHEN meaningful_impact_of_work = 'Yes' AND work_involves_passion = 'No' THEN 'Low Passion & High Impact'
WHEN meaningful_impact_of_work = 'No' AND work_involves_passion = 'Yes' THEN 'High Passion & Low Impact'
ELSE 'Low Passion & Low Impact'
END AS category, 
ROUND(AVG(
CASE min_salary_after_5_years_in_k
WHEN '30-50' THEN 40
WHEN '50-70' THEN 60
WHEN '71-90' THEN 80.5
WHEN '91-110' THEN 100.5
WHEN '111-130' THEN 120.5
WHEN '131-150' THEN 140.5
WHEN '151+' THEN 160
END),1) * 1000 AS avg_expected_salary
FROM career_aspirations
GROUP BY category, meaningful_impact_of_work, work_involves_passion
ORDER BY respondents DESC;
