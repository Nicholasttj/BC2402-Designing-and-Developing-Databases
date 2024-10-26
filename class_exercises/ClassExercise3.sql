/*
BC2402 Class Exercise 3
Name: Tang Te Jie, Nicholas
Matric No: U2310817H
*/

/* 1 */
SELECT DISTINCT s.staffname, s.staffno
	FROM staff s
	JOIN doctor d ON s.staffno = d.staffno
		WHERE d.position = "Associate Doctor"
		GROUP BY staffname, staffno;


/* 2 */
SELECT p.PatientName
FROM Patient p
	JOIN Doctor d ON p.DoctorNo = d.StaffNo
	JOIN Staff s ON d.StaffNo = s.StaffNo
		WHERE s.StaffName = 'Saanvi Anand'
ORDER BY p.PatientName ASC;


/* 3 */
SELECT wardno, COUNT(*) as amt_patients
FROM Patient p
GROUP BY wardno;


/* 4 */
SELECT w.wardno, count(p.PatientID) as amt_patients, w.maxbeds
FROM Ward w
LEFT JOIN Patient p ON w.WardNo = p.WardNo
GROUP BY w.wardno, w.maxbeds
HAVING COUNT(p.PatientID) > w.maxbeds/3;


/* 5 */
SELECT patientid, patientName
FROM patient
WHERE patientname IN (
	SELECT patientname
    FROM patient
    GROUP BY patientName
    HAVING COUNT(*) > 1
)
ORDER BY patientname;


/* 6 */
SELECT s.staffname
FROM staff s
JOIN nurse n ON s.staffno = n.staffno
WHERE n.supno IS NULL
GROUP BY s.staffname
ORDER BY staffname ASC;


/* 7 */
SELECT staffname
FROM staff s, nurse n
WHERE s.staffno = n.staffno
	AND n.supno = (SELECT staffno FROM staff WHERE staffname ='Cammy Soh');

/* 8 */
SELECT staffname
FROM doctor d, staff s
WHERE d.staffno = s.staffno
	AND s.staffno NOT IN (SELECT DISTINCT doctorno FROM patient);