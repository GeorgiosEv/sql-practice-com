/* EXERCISE 1
Show all of the patients grouped into weight groups.
Show the total amount of patients in each weight group.
Order the list by the weight group decending.
For example, if they weight 100 to 109 they are placed in the 100 weight group, 110-119 = 110 weight group, etc. */
SELECT COUNT(*) AS patients_in_group, FLOOR(weight/10)*10 as weight_group
FROM patients
GROUP BY weight_group
ORDER BY weight_group DESC; 

/* EXERCISE 2
Show patient_id, weight, height, isObese from the patients table.
Display isObese as a boolean 0 or 1.
Obese is defined as weight(kg)/(height(m)2) >= 30.
weight is in units kg.
height is in units cm. */
SELECT 
	patient_id, 
    weight, 
    height,
    (CASE 
     	WHEN (weight/POWER(height*0.01,2))>=30 THEN 1
    	ELSE 0 END) AS isObese
FROM patients;

/* EXERCISE 3
Show patient_id, first_name, last_name, and attending doctor's specialty.
Show only the patients who has a diagnosis as 'Epilepsy' and the doctor's first name is 'Lisa'.
Check patients, admissions, and doctors tables for required information. */
SELECT pat.patient_id, pat.first_name, pat.last_name, doc.specialty
FROM patients AS pat
JOIN admissions AS adm ON pat.patient_id = adm.patient_id
JOIN doctors AS doc ON doc.doctor_id = adm.attending_doctor_id
WHERE diagnosis = 'Epilepsy' AND doc.first_name = 'Lisa'

/* EXERCISE 4
All patients who have gone through admissions, can see their medical documents on our site. Those patients are given a temporary password after their first admission. Show the patient_id and temp_password.
The password must be the following, in order:
1. patient_id
2. the numerical length of patient's last_name
3. year of patient's birth_date */
SELECT DISTINCT pat.patient_id, CONCAT(pat.patient_id, len(pat.last_name), YEAR(pat.birth_date)) AS temp_password
FROM patients AS pat
LEFT JOIN admissions AS adm ON pat.patient_id = adm.patient_id
WHERE adm.patient_id IS NOT NULL;

/* EXERCISE 4 
Each admission costs $50 for patients without insurance, and $10 for patients with insurance. All patients with an even patient_id have insurance.
Give each patient a 'Yes' if they have insurance, and a 'No' if they don't have insurance. Add up the admission_total cost for each has_insurance group. */
SELECT DISTINCT
(CASE
	WHEN MOD(patient_id,2)<>0 THEN 'No'
	ELSE 'Yes' END
) AS has_insurance,
SUM(CASE
	WHEN MOD(patient_id,2)<>0 THEN 50
	ELSE 10 END
) AS cost_after_insurance
FROM admissions
GROUP by has_insurance;

/* EXERCISE 5
Show the provinces that has more patients identified as 'M' than 'F'. Must only show full province_name. */
SELECT DISTINCT pn.province_name
FROM province_names AS pn
JOIN patients AS pat ON pn.province_id = pat.province_id
GROUP BY pn.province_name
HAVING
	SUM(CASE WHEN gender = 'M' THEN 1 ELSE 0 END) >
    SUM(CASE WHEN gender = 'F' THEN 1 ELSE 0 END);

/* EXERCISE 6
We are looking for a specific patient. Pull all columns for the patient who matches the following criteria:
- First_name contains an 'r' after the first two letters.
- Identifies their gender as 'F'
- Born in February, May, or December
- Their weight would be between 60kg and 80kg
- Their patient_id is an odd number
- They are from the city of 'Kingston' */
SELECT *
FROM patients
WHERE
	SUBSTRING(first_name, 3, 1) = 'r' AND
    gender = 'F' AND
    MONTH(birth_date) IN (2, 5, 12) AND
    weight BETWEEN 60 AND 80 AND
    MOD(patient_id, 2) <> 0 AND
    city = 'Kingston';
    
/* EXERCISE 7
Show the percent of patients that have 'M' as their gender. Round the answer to the nearest hundreth number and in percent form. */
SELECT CONCAT(
  ROUND(AVG(CASE
      WHEN gender = 'M'THEN 1
      ELSE 0 END), 4)*100, '%') AS percent_of_male_patients
FROM patients;

/* EXERCISE 8 
For each day display the total amount of admissions on that day. Display the amount changed from the previous date. */
SELECT
	admission_date, 
    COUNT(admission_date) AS admission_day, -- you can use COUNT(*)
    COUNT(admission_date) - LAG(COUNT(admission_date)) OVER (ORDER BY admission_date) AS admission_count_change -- you can use COUNT(*)
FROM admissions
GROUP BY DATE(admission_date)
ORDER BY DATE(admission_date);

/* EXERCISE 9
Sort the province names in ascending order in such a way that the province 'Ontario' is always on top. */
SELECT province_name 
FROM province_names
ORDER BY
	CASE WHEN province_name = 'Ontario' THEN 0
    ELSE 1 END,
    province_name
    
/* EXERCISE 10
We need a breakdown for the total amount of admissions each doctor has started each year. Show the doctor_id, doctor_full_name, specialty, year, total_admissions for that year. */
SELECT
	DISTINCT doc.doctor_id,
    CONCAT(doc.first_name, ' ', doc.last_name) AS doctor_name,
    doc.specialty,
    YEAR(adm.admission_date) AS selected_year,
    COUNT(adm.admission_date) as total_admissions
FROM doctors AS doc
JOIN admissions AS adm ON doc.doctor_id = adm.attending_doctor_id
GROUP BY doc.doctor_id, selected_year
order by doc.doctor_id, doc.doctor_name, selected_year;
