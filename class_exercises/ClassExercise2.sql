/*
BC2402 Class Exercise 2
Name: Tang Te Jie, Nicholas
Matric No: U2310817H
*/


/* 1 */
SELECT DISTINCT StudentID, LastName, FirstName, Age, Gender
FROM student
WHERE LastName = 'Ben'
ORDER BY Gender, Age;


/* 2 */
SELECT DISTINCT s.StudentID, s.LastName, s.FirstName 
FROM student s
JOIN enrollment e ON  s.StudentID = e.StudentID
WHERE Grade < 50;


/* 3 */
SELECT DISTINCT s.StudentID, s.LastName, s.FirstName 
FROM student s
JOIN enrollment e ON  s.StudentID = e.StudentID
WHERE e.Grade IN ('D', 'F');


 /* 4 */
SELECT DISTINCT s.StudentID, s.LastName, s.FirstName 
FROM student s
JOIN enrollment e ON s.StudentID = e.StudentID
JOIN courseinsemester c ON e.Sem = c.Sem
JOIN instructor i ON c.InstructorID = i.InstructorID
WHERE i.FirstName = 'John' AND i.LastName = 'Chua'
ORDER BY s.LastName ASC, s.FirstName ASC;


/* 5 */
SELECT COUNT(CourseID) AS amt_section_john
FROM instructor i
JOIN courseinsemester c ON i.InstructorID = c.InstructorID
WHERE i.LastName = 'John' 
	AND i.FirstName = 'Chua'
	AND c.Sem = 2
	AND c.Year = "2018";
    

/* 6 */
SELECT COUNT(e.StudentID) AS amt_students
FROM instructor i
	JOIN courseinsemester c ON i.InstructorID = c.InstructorID
	JOIN section s ON c.CourseID = s.CourseID
	JOIN enrollment e ON s.SectionID = e.SectionID
WHERE i.LastName = 'Kris' 
	AND i.FirstName = 'Tan'
	AND s.CourseID = 8881
	AND s.Sem = 1
	AND s.Year = 2018;


/* 7 */
SELECT s.StudentID, s.LastName, s.FirstName, s.Gender, s.Age
FROM student s
	JOIN enrollment e ON s.StudentID = e.StudentID
	JOIN courseinsemester cs ON e.CourseID = cs.CourseID
WHERE cs.Year IN (2017, 2018)
GROUP BY s.StudentID
HAVING COUNT(DISTINCT cs.CourseID) >= 3;


/* 8 */
SELECT i.InstructorID, i.LastName, i.FirstName
FROM instructor i
	JOIN courseinsemester cs ON i.InstructorID = cs.InstructorID
	JOIN section s ON cs.CourseID = s.CourseID
WHERE s.Sem = 2
AND s.Year = 2018
	GROUP BY i.InstructorID
	HAVING COUNT(DISTINCT s.SectionID) >= 3;


/* 9 */
SELECT student.StudentID, LastName, FirstName, Gender, Age, Grade
FROM enrollment, student
WHERE enrollment.StudentID = student.StudentID
  AND Grade = "A"
    AND (Year = "2017" OR Year = "2018")
GROUP BY student.StudentID
HAVING COUNT(Grade) >= 3;


/* 15 */
SELECT * FROM student
WHERE StudentID NOT IN 
  (SELECT DISTINCT StudentID FROM enrollment WHERE Sem = 2 AND Year = "2018");
  
  
/* 16 */
SELECT * FROM instructor
WHERE InstructorID NOT IN
  (SELECT DISTINCT InstructorID FROM section);
  

/* 17 */
(
SELECT instructor.InstructorID, LastName AS lastname, FirstName AS firstname, COUNT(*) AS course_taught
FROM instructor, section
WHERE instructor.InstructorID = section.InstructorID
GROUP BY instructor.InstructorID
)

UNION

(
SELECT InstructorID, LastName AS lastname, FirstName AS firstname, 0
FROM instructor
WHERE InstructorID NOT IN (SELECT DISTINCT InstructorID FROM section)
);