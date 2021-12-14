--Executions--
USE Milestone2
GO
-- 1) a --

Exec StudentRegister 'Hosam' , 'ELfar' ,'As5566' , 'GUC' , '1' , 'hossamelfar@guc.edu.eg','Elrehab' 
Exec SupervisorRegister 'Mervat' , 'Abuelkheir' , 'SQL123' , 'GUC', 'Mervatabduelkheit @guc.eg '
-- 2) a -- 
Declare @temp bit
Exec  userLogin  2 ,'As5566', @temp OUTPUT

--2)b --
Exec addMobile 2 , '01007759720'

--3) a --
Exec AdminListSup 

--3)b --
Exec AdminViewSupervisorProfile 3

--3)c--
Exec AdminViewAllTheses
--3)d--
Declare @count int 
Exec AdminViewOnGoingTheses @count OUTPUT
--3)e--
Exec AdminViewStudentThesisBySupervisor
-- 3)f--
Exec AdminListNonGucianCourse 5

