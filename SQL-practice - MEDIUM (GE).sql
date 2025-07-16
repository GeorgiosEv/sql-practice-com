/* EXERCISE 1
Show unique birth years from patients and order them by ascending.΄
Remember, by default SQL orders by ascending. */
SELECT DISTINCT YEAR(birth_date) -- use alias 'AS birth_year' here and further down in the ORDER BY
FROM patients
ORDER BY birth_date;

/* EXERCISE 2
Show unique first names from the patients table which only occurs once in the list.
For example, if two or more people are named 'John' in the first_name column then don't include their name in the output list. If only 1 person is named 'Leo' then include them in the output. */
SELECT DISTINCT first_name
FROM patients
GROUP BY first_name
HAVING COUNT(*) = 1;
-- You need to use GROUP BY to use HAVING.

/* EXERCISE 3
Show patient_id and first_name from patients where their first_name start and ends with 's' and is at least 6 characters long. */
SELECT patient_id, first_name 
FROM patients
WHERE first_name LIKE 's%' AND first_name LIKE '%s' AND LEN(first_name) >= 6;

/* EXERCISE 4
Show patient_id, first_name, last_name from patients whos diagnosis is 'Dementia'.
Primary diagnosis is stored in the admissions table. */
SELECT patients.patient_id, patients.first_name, patients.last_name
FROM patients
JOIN admissions ON patients.patient_id = admissions.patient_id
WHERE admissions.diagnosis = 'Dementia';

/* EXERCISE 5
Display every patient's first_name.
Order the list by the length of each name and then by alphabetically.  */
SELECT first_name
FROM patients
ORDER BY Len(first_name), first_name;

/* EXERCISE 6 
Show the total amount of male patients and the total amount of female patients in the patients table.
Display the two results in the same row. */
SELECT
  (SELECT COUNT(*)
  FROM patients
  WHERE gender = 'M') as male_count,
  (SELECT COUNT(*)
  FROM patients
  WHERE gender = 'F') as female_count;
-- The above syntax ensures that the results will be displayed in the same row.

/* EXERCISE 7 
Show first and last name, allergies from patients which have allergies to either 'Penicillin' or 'Morphine'. Show results ordered ascending by allergies then by first_name then by last_name. */
SELECT first_name, last_name, allergies
FROM patients
WHERE allergies = 'Penicillin' OR allergies = 'Morphine'
-- WHERE allergies IN ('Penicillin', 'Morphine') is also acceptable (better in case the filtering parameters are more than 2 or 3).
ORDER BY allergies, first_name, last_name;

/* EXERCISE 8 
Show patient_id, diagnosis from admissions. Find patients admitted multiple times for the same diagnosis. */
SELECT patient_id, diagnosis
FROM admissions
group by patient_id, diagnosis
HAVING COUNT(*) > 1;

/* EXERCISE 9 
Show the city and the total number of patients in the city.
Order from most to least patients and then by city name ascending. */
SELECT city, COUNT(*) AS num_patients
FROM patients
GROUP BY city
ORDER BY num_patients DESC, city;

/* EXERCISE 10
Show first name, last name and role of every person that is either patient or doctor.
The roles are either "Patient" or "Doctor" */
SELECT first_name, last_name, 'patient' AS role
FROM patients
UNION ALL
SELECT first_name, last_name, 'doctor' AS role
FROM doctors;

/* EXERCISE 11
Show all allergies ordered by popularity. Remove NULL values from query. */
SELECT allergies, COUNT(*) as total_diagnosis
FROM patients
WHERE allergies IS NOT NULL
GROUP BY allergies
ORDER BY total_diagnosis DESC;

/* EXERCISE 12 
Show all patient's first_name, last_name, and birth_date who were born in the 1970s decade. Sort the list starting from the earliest birth_date. */
SELECT first_name, last_name, birth_date
FROM patients
WHERE YEAR(birth_date) BETWEEN 1970 AND 1979
ORDER BY YEAR(birth_date), MONTH(birth_date), DAY(birth_date);

/* EXERCISE 13 
We want to display each patient's full name in a single column. Their last_name in all upper letters must appear first, then first_name in all lower case letters. Separate the last_name and first_name with a comma. Order the list by the first_name in decending order
EX: SMITH,jane */
SELECT CONCAT(UPPER(last_name), ',', LOWER(first_name)) as new_name_format
FROM patients
ORDER BY first_name DESC;

/* EXERCISE 14
Show the province_id(s), sum of height; where the total sum of its patient's height is greater than or equal to 7,000. */
SELECT province_id, SUM(height) AS sum_height
FROM patients
group by province_id
HAVING sum_height >= 7000;

/* EXERCISE 15
Show the difference between the largest weight and smallest weight for patients with the last name 'Maroni'. */
SELECT (MAX(weight) - MIN(weight)) AS weight_delta
FROM patients
WHERE last_name = 'Maroni';

/* EXERCISE 16
Show all of the days of the month (1-31) and how many admission_dates occurred on that day. Sort by the day with most admissions to least admissions. */
SELECT DAY(admission_date) AS day_number, COUNT(*) AS number_of_admissions
FROM admissions
GROUP by day_number
ORDER BY number_of_admissions DESC;

/* EXERCISE 17
Show all columns for patient_id 542's most recent admission_date. */
SELECT *
FROM admissions
WHERE patient_id = '542'
ORDER BY YEAR(admission_date) DESC
LIMIT 1;

/* EXERCISE 18
Show patient_id, attending_doctor_id, and diagnosis for admissions that match one of the two criteria:
1. patient_id is an odd number and attending_doctor_id is either 1, 5, or 19.
2. attending_doctor_id contains a 2 and the length of patient_id is 3 characters. */
SELECT patient_id, attending_doctor_id, diagnosis
FROM admissions
WHERE (MOD(patient_id, 2) <> 0 AND attending_doctor_id IN ('1', '5', '19')) 
	OR (attending_doctor_id LIKE '%2%' AND len(patient_id)=3);

/* EXERCISE 19
Show first_name, last_name, and the total number of admissions attended for each doctor.
Every admission has been attended by a doctor. */
SELECT doc.first_name, doc.last_name, COUNT(*) AS admission_total
FROM admissions AS adm
JOIN doctors AS doc ON doc.doctor_id = adm.attending_doctor_id
WHERE attending_doctor_id IS NOT NULL
group by doc.doctor_id;

/* EXERCISE 20
For each doctor, display their id, full name, and the first and last admission date they attended. */
SELECT doc.doctor_id, CONCAT(doc.first_name, ' ', doc.last_name) AS full_name,
	MIN(admission_date) AS first_admission_date, MAX(admission_date) AS last_admission_date
FROM doctors AS doc
JOIN admissions AS adm ON doc.doctor_id = adm.attending_doctor_id
GROUP BY doc.doctor_id;

/* EXERCISE 21
Display the total amount of patients for each province. Order by descending. */
SELECT pn.province_name, COUNT(*) AS patient_count
FROM province_names AS pn
JOIN patients AS pat ON pn.province_id = pat.province_id
group by pn.province_name
ORDER By patient_count DESC;

/* EXERCISE 22
For every admission, display the patient's full name, their admission diagnosis, and their doctor's full name who diagnosed their problem. */
SELECT CONCAT(pat.first_name, ' ', pat.last_name) AS patient_name, adm.diagnosis, CONCAT(doc.first_name, ' ', doc.last_name) AS doctor_name
FROM patients AS pat
JOIN admissions AS adm ON adm.patient_id = pat.patient_id
JOIN doctors AS doc ON doc.doctor_id = adm.attending_doctor_id;

/* EXERCISE 23
Display the first name, last name and number of duplicate patients based on their first name and last name.
- Ex: A patient with an identical name can be considered a duplicate. */
SELECT first_name, last_name, COUNT(*) AS num_of_duplicates
FROM patients
GROUP By first_name, last_name
HAVING COUNT(*) > 1;

/* EXERCISE 24
Display patient's full name,
height in the units feet rounded to 1 decimal,
weight in the unit pounds rounded to 0 decimals,
birth_date, gender non abbreviated.
- Convert CM to feet by dividing by 30.48.
- Convert KG to pounds by multiplying by 2.205. */
SELECT 
	CONCAT(first_name,' ', last_name) AS patient_name,
    ROUND(height/30.48, 1) AS 'height "Feet"', -- BE CAREFUL: 1 decimal place
    ROUND(weight*2.205, 0) AS 'weight "Pounds"', -- BE CAREFUL: 0 decimal places
    birth_date, 
    (CASE 
    	WHEN gender = 'M' THEN 'MALE' 
        ELSE 'FEMALE' END) AS gender_type
FROM patients;
-- Note: Although in earlier occurrences, I did not have to use single quotations ('') marks when creating aliases, in this case, it required their use, so that I could use double quotation marks ("") for Feet and Pounds respectively.

/* EXERCISE 25
Show patient_id, first_name, last_name from patients whose does not have any records in the admissions table. (Their patient_id does not exist in any admissions.patient_id rows). */
SELECT DISTINCT pat.patient_id, pat.first_name, pat.last_name
FROM patients AS pat
LEFT JOIN admissions AS adm ON pat.patient_id = adm.patient_id
WHERE adm.patient_id IS NULL;

/* EXERCISE 26
Display a single row with max_visits, min_visits, average_visits where the maximum, minimum and average number of admissions per day is calculated. Average is rounded to 2 decimal places. */
SELECT
  (SELECT COUNT(*) as admission_count
  FROM admissions
  GROUP BY admission_date
  ORDER BY admission_count DESC
  LIMIT 1) AS 'max_visits',
  (SELECT COUNT(*) as admission_count
  FROM admissions
  GROUP BY admission_date
  ORDER BY admission_count -- in this case, SQL follows the default method of ordering, i.e. ascending order, which I utilised.
  LIMIT 1) AS 'min_visits',
  (SELECT ROUND(AVG(admission_count),2) AS avg_count -- BE CAREFUL: 2 decimal places
  FROM
    (SELECT COUNT(*) as admission_count
    FROM admissions
    GROUP BY admission_date)
  ORDER BY avg_count DESC
  LIMIT 1) AS 'average_visits';
-- In this one, I faced a bit of a challenge and I followed a similar way of thinking as in Exercise 6 (Medium Difficulty) to solve it. However, it required a bit of workaround, especially in the average_visits bit.
-- Once again, I used single quotation marks ('') to ensure the quantities that I wanted to calculated stood out as aliases.
-- Of course, the solution above is by all means NOT the simplest one; it can be further simplified by a different use of aliases as seen below (i.e. the solution provided by the system):
/* select 
	max(number_of_visits) as max_visits, 
	min(number_of_visits) as min_visits, 
  round(avg(number_of_visits),2) as average_visits 
from (
  select admission_date, count(*) as number_of_visits
  from admissions 
  group by admission_date
) */