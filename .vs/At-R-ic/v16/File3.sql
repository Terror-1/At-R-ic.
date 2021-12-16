--Executions--
USE Milestone2
GO
-- 1) a --

Exec StudentRegister 'Hosam' , 'ELfar' ,'As5566' , 'MET' , '1' , 'hossamelfar@guc.edu.eg','Elrehab' 
Exec SupervisorRegister 'Mervat' , 'Abuelkheir' , 'SQL123' , 'DataSciense', 'Mervatabduelkheit @guc.eg '
-- 2) a -- 
Declare @temp bit
Exec  userLogin  19 ,'As5566', @temp OUTPUT

--2)b --
Exec addMobile 19, '01007759720'

--3) a --
Exec AdminListSup 

--3)b --
Exec AdminViewSupervisorProfile 20

--3)c--
Exec AdminViewAllTheses
--3)d--
Declare @count int 
Exec AdminViewOnGoingTheses @count OUTPUT
--3)e--
Exec AdminViewStudentThesisBySupervisor
-- 3)f--
Exec AdminListNonGucianCourse 1
-- 3)g AdminUpdateExtension--
EXEC AdminUpdateExtension 16
--3)h--
declare @Success bit
exec AdminIssueThesisPayment 16,15000,3,0.3,@Success output
--3) i --
Exec AdminViewStudentProfile 4
--3) j--
Exec AdminIssueInstallPayment 20,'2021/1/17'
--3)k---
Exec AdminListAcceptPublication
--3)l--
exec AddCourse 'Database1',4, 6000
exec linkCourseStudent 5,6
exec addStudentCourseGrade 5 , 6 ,3.4
--3)m --
exec ViewExamSupDefense '2021/12/23'
--4)a ---
Exec EvaluateProgressReport 11,1,1,0
--4)b--
Exec ViewSupStudentsYears 11
--4)c--
Exec SupViewProfile 11
Exec UpdateSupProfile 11,'mamhoud Elmougy','EMS'
--4)d
Exec ViewAStudentPublications 1
--4)e--
Exec AddDefenseGucian 16,'2024/8/7','6th of octocor'
Exec AddDefenseNonGucian 17,'2024/8/7','6th of octocor'
--4)f--
Exec AddExaminer 1,'2022/7/23','hosam yassin' , '1' , 'CS'
--4)g--
Exec CancelThesis 1 
--4) h--
Exec AddGrade 16 ,80
--5)a--
Exec AddDefenseGrade 16 , '2024/8/7',64
--5)b--
Exec AddCommentsGrade 5 , '2021/12/20',17, 'Very good'

--6)a--

