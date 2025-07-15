/* EXERCISE 1
Show first name, last name, and gender of patients whose gender is 'M'. */
SELECT first_name,last_name,gender 
FROM patients
WHERE gender = "M";

/* EXERCISE 2
Show first name and last name of patients who does not have allergies. (null) */
SELECT first_name,last_name 
FROM patients
WHERE allergies IS null;

/* EXERCISE 3
Show first name of patients that start with the letter 'C' */
SELECT first_name 
FROM patients
WHERE SUBSTRING(first_name, 1, 1) = "C";

/* EXERCISE 4
Show first name and last name of patients that weight within the range of 100 to 120 (inclusive).  */
SELECT first_name, last_name 
FROM patients
WHERE weight>=100 AND weight<=120;
-- NOTE: You can always use the BETWEEN operator as an alternative.

/* EXERCISE 5
Update the patients table for the allergies column. If the patient's allergies is null then replace it with 'NKA'. */
UPDATE patients
SET   allergies = 'NKA'
WHERE allergies IS NULL;

/* EXERCISE 6
Show first name and last name concatinated into one column to show their full name. */
SELECT CONCAT(first_name," ",last_name)
FROM patients

/* EXERCISE 7
Show first name, last name, and the full province name of each patient. Example: 'Ontario' instead of 'ON'. */
SELECT patients.first_name, patients.last_name, province_names.province_name
FROM patients
INNER JOIN province_names ON patients.province_id = province_names.province_id;
-- NOTE: Added INNER JOIN for readability. Using plain JOIN will not change the end result.

/* EXERCISE 8
Show how many patients have a birth_date with 2010 as the birth year. */
SELECT COUNT(*) -- You can use 'AS total_patients' alias here, based on system's solution
FROM patients
WHERE YEAR(birth_date) = 2010;

/* EXERCISE 9
Show the first_name, last_name, and height of the patient with the greatest height. */
SELECT first_name,last_name, MAX(height)
FROM patients
-- This is a very simple approach. However, you could also use MAX within another query, which will be nested in a WHERE condition (instead of the first/main SELECT statement). This means that you will be querying first_name,last_name, height (instead of what I did). See the condition below:
-- WHERE height = (SELECT max(height) FROM patients)

/* EXERCISE 10
Show all columns for patients who have one of the following patient_ids: 1,45,534,879,1000. */
SELECT *
FROM patients
WHERE patient_id In ('1','45','534','879','1000');

/* EXERCISE 11
Show the total number of admissions. */
SELECT COUNT(*) AS total_admissions
FROM admissions

/* EXERCISE 12
Show all the columns from admissions where the patient was admitted and discharged on the same day. */
SELECT *
FROM admissions
WHERE admission_date = discharge_date;

/* EXERCISE 13
Show the patient id and the total number of admissions for patient_id 579. */
SELECT patient_id, COUNT(*) as total_admissions
FROM admissions
WHERE patient_id = '579';

/* EXERCISE 14
Based on the cities that our patients live in, show unique cities that are in province_id 'NS'. */
SELECT DISTINCT patients.city AS unique_cities
FROM patients
JOIN province_names ON patients.province_id = province_names.province_id
WHERE province_names.province_id = 'NS';

/* EXERCISE 15
Write a query to find the first_name, last name and birth date of patients who has height greater than 160 and weight greater than 70. */
SELECT first_name, last_name, birth_date
FROM patients
WHERE height > '160' AND weight > '70';

/* EXERCISE 16
Write a query to find list of patients first_name, last_name, and allergies where allergies are not null and are from the city of 'Hamilton'. */
SELECT first_name, last_name, allergies
FROM patients
WHERE allergies IS NOT NULL AND city = 'Hamilton';