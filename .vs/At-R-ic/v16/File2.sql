--procedures--
USE Milestone2
GO

--1) As an unregistered user I should be able to:--

--1) a) Register as a student to the website --
CREATE PROC StudentRegister
@first_name VARCHAR(20),
@last_name VARCHAR(20),
@password VARCHAR(20),
@faculty VARCHAR(20),
@Gucian BIT,
@email VARCHAR(50),
@address VARCHAR(50)
AS
IF @first_name IS NULL OR @last_name IS NULL OR @password IS NULL OR @faculty IS NULL OR @Gucian IS NULL OR @email IS NULL OR @address IS NULL
PRINT 'ONE OF THE INPUTS IS NULL'
ELSE
Begin
INSERT INTO PostGradUser (email,password) VALUES(@email,@password)
DECLARE @ID INT
SELECT @ID =PGU.id
FROM PostGradUser PGU
WHERE PGU.email=@email AND PGU.password=@password
IF @Gucian = 1 
INSERT INTO GucianStudent (id,firstName,lastName,faculty,address) VALUES(@ID,@first_name,@last_name,@faculty,@address)
ELSE 
INSERT INTO NonGucianStudent (id,firstName,lastName,faculty,address) VALUES(@ID,@first_name,@last_name,@faculty,@address)
End
--1) b) Register as a supervisor to the website --

GO
CREATE PROC SupervisorRegister
@first_name VARCHAR(20),
@last_name VARCHAR(20),
@password VARCHAR(20),
@faculty VARCHAR(20),
@email VARCHAR(50)
AS
IF @first_name IS NULL OR @last_name IS NULL OR @password IS NULL OR @faculty IS NULL OR @email IS NULL
PRINT 'ONE OF THE INPUTS IS NULL'
ELSE
begin
INSERT INTO PostGradUser (email,password) VALUES(@email,@password)
DECLARE @ID INT
SELECT @ID =PGU.id
FROM PostGradUser PGU
WHERE PGU.email=@email AND PGU.password=@password
INSERT INTO Supervisor (id,Name,faculty) VALUES(@ID,@first_name+@last_name,@faculty)
End
--2) As any registered User I should be able to:--

--2) a) login using my username and password --
GO

CREATE PROC userLogin
@ID INT,
@password VARCHAR(20),
@Success BIT OUTPUT
AS
IF EXISTS (
SELECT * 
FROM PostGradUser PGU
WHERE PGU.password=@password AND PGU.id=@ID
)
set @Success = '1'
else 
set @Success = '0'
print @Success

--2) b) add my mobile number(s) --
GO

create proc addMobile 
@ID int ,
@mobile_number varchar(20)
as 
if exists ( select * from GucianStudent s where @ID = s.id ) and @mobile_number is not null
insert into GUCStudentPhoneNumber (id ,phone) values (@ID , @mobile_number)
else if exists ( select * from NonGucianStudent s where @ID = s.id )
insert into NonGUCStudentPhoneNumber (id ,phone) values (@ID , @mobile_number)
else 
print 'id not correct'


--3) As an admin I should be able to:--

--3) a) List all supervisors in the system --
GO

create proc AdminListSup 
as 
select *
from Supervisor

--3) b) view the profile of any supervisor that contains all his/her information --
GO
CREATE PROC AdminViewSupervisorProfile 
@supId int 
as 
if exists (select * from Supervisor S
where  S.id= @supId)
begin
select * 
from Supervisor S
where  S.id= @supId
end 
else print 'wrong id number'

--3) c) List all Theses in the system --
Go

create proc AdminViewAllTheses
as 
select * 
from Thesis

--3) d) List the number of on going theses --
Go 

create proc AdminViewOnGoingTheses
@thesesCount int output 
as
declare @curr date
SELECT @curr=CAST( GETDATE() AS Date )
select @thesesCount= count (*)
from Thesis 
where endDate>@curr
print @thesesCount 

--3) e) List all supervisors’ names currently supervising students, theses title, student name --
Go

create proc AdminViewStudentThesisBySupervisor
as 
select Su.name as supervisor_name , t.title , s.firstName+s.lastName as Student_name 
from GUCianStudentRegisterThesis GPR inner join GucianStudent s on GPR.sid = s.id 
inner join Thesis t on GPR.serial_no = t.serialNumber 
inner join Supervisor Su on GPR.supid = Su.id 
union 
select Su.name , t.title , s.firstName+' '+s.lastName as Student_name 
from NonGUCianStudentRegisterThesis GPR inner join NonGucianStudent s on GPR.sid = s.id 
inner join Thesis t on GPR.serial_no = t.serialNumber 
inner join Supervisor Su on GPR.supid = Su.id 


--3) f) List nonGucians names, course code, and respective grade --
Go

create proc AdminListNonGucianCourse
@courseID int 
as 
if exists (select * from Course c where id =@courseID)
begin
select S.firstName+' '+S.lastName as Student_name , C.code , tc.grade 
from NonGucianStudentTakeCourse tc inner join Course C on tc.cid= C.id 
inner join NonGucianStudent S on tc.sid=S.id 
where @courseID = C.id
end
else print 'wrong course id number'

-- 3) g) Update the number of thesis extension by 1 --
Go

create proc AdminUpdateExtension
@ThesisSerialNo int 
as 
if exists (select * from Thesis where serialNumber=@ThesisSerialNo)
update Thesis set noExtension = noExtension+1 
where serialNumber=@ThesisSerialNo
else
print 'wrong thesis id number'

--3) h) Issue a thesis payment --
go

create proc AdminIssueThesisPayment
@ThesisSerialNo int ,
@amount Decimal(10,2),
@noOfInstallments int ,
@fundPercentage decimal (3,2),
@Sucess Bit output 
as 

if exists(select * from Thesis where serialNumber = @ThesisSerialNo )
BEGIN
insert into Payment (amount ,no_installments,fundPercentage)values (@amount , @noOfInstallments , @fundPercentage)
Declare @temp int 
select @temp= id from Payment where id = @@IDENTITY
update Thesis set payment_id = @temp 
where serialNumber = @ThesisSerialNo
set @Sucess = '1'
print @Sucess
END
else 
BEGIN
set @Sucess='0'
print @Sucess
END

--3) i) view the profile of any student that contains all his/her information --
Go

create proc AdminViewStudentProfile 
@sid int 
as 
if exists ( select * from GucianStudent s where @sid = s.id )
select * from GucianStudent s where @sid = s.id 
else if exists ( select * from NonGucianStudent s where @sid = s.id )
select * from NonGucianStudent s where @sid = s.id 
else
print 'wrong id number'

--3) j) Issue installments as per the number of installments for a certain payment every six months startingfrom the entered date --
Go

create proc AdminIssueInstallPayment
@paymentID int ,
@InstallStartDate date 
as 
if exists (select * from Payment where id=@paymentID ) and @InstallStartDate is not null
begin
declare @amo decimal(10,2)
declare @num int
select @amo =pa.amount, @num=pa.no_installments
from Payment pa where pa.id=@paymentID
Declare @newamo decimal(10,1)
set @newamo = @amo/@num
declare @enddate date 
set @enddate=@InstallStartDate
--declare @curr date--
--SELECT @curr=CAST( GETDATE() AS Date ) ;--

/*select @curr=th.endDate
from Thesis th 
where th.payment_id=@paymentID*/
declare @co int
set @co=0
while (@co<@num )
begin
insert into Installment values(@enddate,@paymentID,@newamo,0)
SET @enddate = DATEADD(MONTH, 6, @enddate)
set @co = @co+1
end 
end
else 
print 'payment id number is wrong or the start date was not enterd'
--3) k) List the title(s) of accepted publication(s) per thesis --
go

create proc AdminListAcceptPublication
as
select p.title as publication_title , t.serialNumber as thesis_serialnumber
from Publication p inner join ThesisHasPublication Thp on p.id=thp.pubid
inner join thesis t on thp.serialNo = t.serialNumber
where p.accepted ='1'

--3) l) Add courses and link courses to students --
go

CREATE PROC AddCourse
@courseCode varchar(10),
@credithrs int ,
@fees decimal

as
insert into Course values(@fees,@creditHrs,@courseCode)


go
CREATE PROC linkCourseStudent
@courseID int,
@studentID int 
as
if exists (select * from NonGucianStudent where id=@studentID) and exists (select * from Course where id=@courseID)
insert into NonGucianStudentTakeCourse (sid , cid) values(@studentID,@courseID)
else
print 'student id number or course id is incorrect'



go
CREATE PROC addStudentCourseGrade
@courseID int,
@studentID int, 
@grade decimal(3,2)
as
if exists (select * from NonGucianStudent where id=@studentID) and exists (select * from Course where id=@courseID) and @grade is not null
begin
update NonGucianStudentTakeCourse
set grade=  @grade
WHERE @studentID=sid and  @courseID=cid
end
else print 'student id number, course id or grade is incorrect'

--3) m) View examiners and supervisor(s) names attending a thesis defense taking place on a certain date --
go

create proc ViewExamSupDefense
@defenseDate datetime
as
if @defenseDate is not null
begin
select E.name as Examiner_name , T.serialNumber as thesis_id ,T.title as thesis_title ,D.location ,D.date,d.grade
from Defense D inner join ExaminerEvaluateDefense EED on D.date = EED.date
inner join Examiner E on EED.examinerId = E.id
inner join Thesis T on D.serialNumber =T.serialNumber
where D.date = @defenseDate
select S.name as supervisor_name,T.serialNumber as thesis_id ,T.title as thesis_title ,D.location ,D.date,d.grade
from Defense D inner join Thesis T on D.serialNumber = T.serialNumber 
inner join GUCianStudentRegisterThesis GRT on T.serialNumber =GRT.serial_no
inner join Supervisor S on GRT.supid = S.id
where D.date = @defenseDate
union
select S.name as supervisor_name,T.serialNumber as thesis_id ,T.title as thesis_title ,D.location ,D.date,d.grade
from Defense D inner join Thesis T on D.serialNumber = T.serialNumber 
inner join NonGUCianStudentRegisterThesis GRT on T.serialNumber =GRT.serial_no
inner join Supervisor S on GRT.supid = S.id
where D.date = @defenseDate
end
else print 'no date entered'
--4) As a supervisor I am able to :--

--4) a) Evaluate a student’s progress report --
go
create proc EvaluateProgressReport
@supervisorID int,
@thesisSerialNo int,
@progressReportNo int, 
@evaluation int
as
if (@evaluation>=0 and @evaluation <=3)
begin
if exists(
select *
from GUCianProgressReport p 
where p.no=@progressReportNo and @thesisSerialNo=p.thesisSerialNumber and p.supid=@supervisorID
)
begin
update GUCianProgressReport
set eval =@evaluation
where no=@progressReportNo and @thesisSerialNo=thesisSerialNumber and supid=@supervisorID
end
else if exists(
select *
from NonGUCianProgressReport p 
where p.no=@progressReportNo and @thesisSerialNo=p.thesisSerialNumber and p.supid=@supervisorID
)
begin
update NonGUCianProgressReport
set eval =@evaluation
where no=@progressReportNo and @thesisSerialNo=thesisSerialNumber and supid=@supervisorID
end
else print 'invalid data entery, progress report does not exists'
end
else
print 'Evaluation not correct'

--4) b) View all my students’s names and years spent in the thesis --
go

create proc ViewSupStudentsYears
@supervisorID int
as
if exists (select * from Supervisor where id=@supervisorID)
begin
select g.firstName,g.lastName , t.years
from GucianStudent g inner join GUCianProgressReport gp on g.id=gp.sid
inner join Thesis t on t.serialNumber=gp.thesisSerialNumber
where gp.supid = @supervisorID
union
select g.firstName,g.lastName , t.years
from NonGucianStudent g inner join NonGUCianProgressReport gp on g.id=gp.sid
inner join Thesis t on t.serialNumber=gp.thesisSerialNumber
where gp.supid = @supervisorID
end
else print 'invalid id number'

--4) c) View my profile and update my personal information --
go
create proc SupViewProfile
@supervisorID int 
as 
if exists (select * from Supervisor where id=@supervisorID)
begin
select * 
from Supervisor S
where S.id = @supervisorID
end
else print 'invalid id number'

go 
create proc UpdateSupProfile
@supervisorID int, @name varchar(20), @faculty varchar(20)
as 
if exists (select * from Supervisor where id=@supervisorID) and @name is not null and @faculty is not null
begin
update Supervisor 
set name = @name , faculty = @faculty
where id = @supervisorID 
end 
else print 'invalid data credentials'

--4) d) View all publications of a student --
go 

create proc ViewAStudentPublications
@StudentID int 
as 
if exists ( select * from GucianStudent s where @StudentID = s.id )
select p.title as publication_title , p.id as publbication_id 
from GucianStudent S inner join GUCianStudentRegisterThesis t on S.id = t.sid 
inner join ThesisHasPublication  tp on t.serial_no = tp.serialNo 
inner join Publication p on tp.pubid = p.id
where @StudentID = S.id
else if exists ( select * from NonGucianStudent s where @StudentID = s.id )
select p.title as publication_title , p.id as publbication_id 
from NonGucianStudent S inner join NonGUCianStudentRegisterThesis t on S.id = t.sid 
inner join ThesisHasPublication  tp on t.serial_no = tp.serialNo 
inner join Publication p on tp.pubid = p.id
where @StudentID = S.id
else
print 'invalid student id'

--4) e) Add defense for a thesis --
Go
create proc AddDefenseGucian
@ThesisSerialNo int , @DefenseDate Datetime , @DefenseLocation varchar(15)
as
if exists (select * from Thesis where serialNumber=@ThesisSerialNo) and @DefenseDate is not null and @DefenseLocation is not null
begin
insert into Defense (serialNumber ,date ,location ) values (@ThesisSerialNo , @DefenseDate , @DefenseLocation)
update thesis set defenseDate = @DefenseDate where serialNumber = @ThesisSerialNo
end
else print 'thesis id number is invalid or defense date and location not specified'
go 

create proc AddDefenseNonGucian
@ThesisSerialNo int , @DefenseDate Datetime , @DefenseLocation varchar(15)
as 
Declare @minimum decimal (5,2)
Select @minimum =Min(C.grade)
from Thesis T inner join NonGUCianStudentRegisterThesis ngrt on T.serialNumber =ngrt.serial_no
inner join NonGucianStudentTakeCourse C on ngrt.sid = C.sid
where T.serialNumber = @ThesisSerialNo 
if @minimum > 50 
begin
insert into Defense (serialNumber ,date ,location ) values (@ThesisSerialNo , @DefenseDate , @DefenseLocation)
update thesis set defenseDate = @DefenseDate where serialNumber = @ThesisSerialNo
end
else 
print 'grade < 50% '
--4) f) Add examiner(s) for a defense --
go
-- how to insert info about examiner into postgraduser--
create proc AddExaminer 
@ThesisSerialNo int , @DefenseDate Datetime , @ExaminerName varchar(20), @National bit, @fieldOfWork varchar(20)
as
insert into PostGradUser (email  ,password )values (null,null)
Declare @temp int 
select @temp= id from PostGradUser where id = @@IDENTITY
insert into Examiner(id , name ,fieldofwork , isNational ) values (@temp , @ExaminerName , @fieldOfWork , @National)
insert into ExaminerEvaluateDefense (date , serialNo , examinerId , comment ) values ( @DefenseDate , @ThesisSerialNo , @temp , null)
--4) g) Cancel a Thesis if the evaluation of the last progress report is zero --
go 

create proc CancelThesis 
@ThesisSerialNo int 
as 
if exists (select * from Thesis where serialNumber=@ThesisSerialNo)
begin
declare @blabizo int
select @blabizo = N.eval 
from NonGUCianProgressReport N where N.thesisSerialNumber = @ThesisSerialNo AND
N.date = (select max(N2.date)
from NonGUCianProgressReport N2 where n2.thesisSerialNumber=@ThesisSerialNo )

declare @blabizo2 int
select @blabizo2 = N.eval 
from GUCianProgressReport N where
N.thesisSerialNumber = @ThesisSerialNo AND
N.date =(select max(N2.date)
from GUCianProgressReport N2 where n2.thesisSerialNumber=@ThesisSerialNo)
if exists (select * from Thesis t inner join GUCianStudentRegisterThesis g on t.serialNumber=g.serial_no 
where t.serialNumber=@ThesisSerialNo)
delete from Thesis where serialNumber = @ThesisSerialNo and @blabizo2= 0 ;
else if exists (select * from Thesis t inner join NonGUCianStudentRegisterThesis ng on t.serialNumber=ng.serial_no 
where t.serialNumber=@ThesisSerialNo)
delete from Thesis where serialNumber = @ThesisSerialNo and @blabizo= 0 ;
end 
else print 'invalid thesis serial number'
--4) h) Add a grade for a thesis --
go
--//whether it is defence grade--
Create proc AddGrade
@ThesisSerialNo int 
as 
if exists (select * from Thesis where serialNumber=@ThesisSerialNo)
begin
/*declare @ggrade decimal  
select @ggrade= c.grade 
from Defense c 
where c.serialNumber = @ThesisSerialNo */
update Thesis 
set grade =78.5
where serialNumber = @ThesisSerialNo
end 
else print 'invalid thesis serial number' 

--5) As an examiner I should be able to: --

--5) a) Add grade for a defense --
go
create proc AddDefenseGrade 
@ThesisSerialNo int , @DefenseDate Datetime , @grade decimal(5,2)
as 
if exists (select * from Thesis where serialNumber=@ThesisSerialNo) and @DefenseDate is not null and @grade is not null
begin
update Defense set grade = @grade 
where serialNumber=@ThesisSerialNo and date = @DefenseDate 
end 
else print 'thesis serial number, defense date or grade is invalid'

--5) b) Add comments for a defense --
go 
create proc AddCommentsGrade 
@ThesisSerialNo int , @DefenseDate Datetime ,@Examiner_id int  , @comments varchar(300) 
as 
update ExaminerEvaluateDefense set comment = @comments
where serialNo=@ThesisSerialNo and date = @DefenseDate and examinerId = @Examiner_id 

--6) As a registered student I should be able to:--

--6) a) View my profile that contains all my information --
go
create proc viewMyProfile
@studentId int
as 
if exists ( select * from GucianStudent s where @studentId = s.id )
select * from GucianStudent s where @studentId = s.id 
else if exists ( select * from NonGucianStudent s where @studentId = s.id )
select * from NonGucianStudent s where @studentId = s.id 
else
print 'id is incorrect'

--6) b) Edit my profile --
go
create proc editMyProfile
@studentID int, @firstName varchar(10), @lastName varchar(10), @password varchar(10), @email
varchar(10), @address varchar(10), @type varchar(10)
as
if exists (select * from PostGradUser where id=@studentID) and @firstName is not null and @lastName is not null and @password is not null and @email is not null and @address is not null and @type is not null
begin
if exists ( select * from GucianStudent s where @studentId = s.id )
begin
update GucianStudent set firstName =@firstName , lastName = @lastName , address = @address , type = @type where id = @studentID
update PostGradUser set password = @password, email = @email 
where id = @studentID
end
else if exists ( select * from NonGucianStudent s where @studentId = s.id )
begin
update NonGucianStudent set firstName =@firstName , lastName = @lastName , address = @address , type = @type where id = @studentID
update PostGradUser set password = @password, email = @email 
where id = @studentID
end
else 
print 'id is not crrocet '
end
else print 'incorrect data entery'

--6) c) As a Gucian graduate, add my undergarduate ID --
go 
create proc addUndergradID
@studentID int, @undergradID varchar(10)
as 
if exists (select * from GucianStudent where id=@studentID) and @undergradID is not null
update GucianStudent set undergradID= @undergradID where id=@studentID
else print 'invalid id number '

--6) d) As a nonGucian student, view my courses’ grades --
go
create proc ViewCoursesGrades
@studentID int 
as 
if exists (select * from NonGucianStudent where id=@studentID)
begin
select C.cid as cousrse_id,S.code, C.grade as course_grade 
from NonGucianStudentTakeCourse C inner join Course S on C.cid = S.id
where C.sid = @studentID
end
else print 'invalid id number'
--6) e) View all my payments and installments --
go
create proc ViewCoursePaymentsInstall 
@studentID int
as
if exists (select * from NonGucianStudent where id=@studentID)
begin
select p.* 
from NonGucianStudentPayForCourse N inner join Payment p on N.paymentNo = p.id 
inner join Installment I on p.id = I.paymentId
where N.sid = @studentID
select I.* 
from NonGucianStudentPayForCourse N inner join Payment p on N.paymentNo = p.id 
inner join Installment I on p.id = I.paymentId
where N.sid = @studentID
end
else print 'invalid id number'
go
create proc ViewThesisPaymentsInstall 
@studentID int
as 
if exists ( select * from GucianStudent s where @studentId = s.id )
begin
select p.*
from GUCianStudentRegisterThesis gs inner join Thesis T on gs.serial_no=t.serialNumber inner join Payment p on T.payment_id = p.id 
where gs.sid=@studentID
select I.* 
from GUCianStudentRegisterThesis gs inner join Thesis T on gs.serial_no=t.serialNumber inner join Payment p on T.payment_id = p.id 
inner join Installment I on p.id = I.paymentId
where gs.sid=@studentID
end 
else if exists ( select * from NonGucianStudent s where @studentId = s.id )
begin
select p.* 
from NonGUCianStudentRegisterThesis gs inner join Thesis T on gs.serial_no=t.serialNumber inner join Payment p on T.payment_id = p.id 
where gs.sid=@studentID
select I.* 
from NonGUCianStudentRegisterThesis gs inner join Thesis T on gs.serial_no=t.serialNumber inner join Payment p on T.payment_id = p.id 
inner join Installment I on p.id = I.paymentId
where gs.sid=@studentID
end
else 
print 'invalid id number'
go
create proc ViewUpcomingInstallments 
@studentID int
as
Declare @curr date 
SELECT @curr=CAST( GETDATE() AS Date )
if exists ( select * from GucianStudent s where @studentId = s.id )
begin
select I.*
from GUCianStudentRegisterThesis gs inner join Thesis T on gs.serial_no=t.serialNumber inner join Payment p on T.payment_id = p.id 
inner join Installment I on p.id = I.paymentId
where gs.sid=@studentID and I.date > @curr and I.done = '0'
end 
else if exists ( select * from NonGucianStudent s where @studentId = s.id )
begin
select I.*
from NonGUCianStudentRegisterThesis gs inner join Thesis T on gs.serial_no=t.serialNumber inner join Payment p on T.payment_id = p.id 
inner join Installment I on p.id = I.paymentId
where gs.sid=@studentID and I.date > @curr and  I.done = '0'
union 
select I.*
from NonGucianStudentPayForCourse C inner join Payment p on C.paymentNo = p.id 
inner join Installment I on p.id = I.paymentId
where C.sid=@studentID and I.date > @curr and  I.done = '0'
end
else 
print 'invalid id number'

go

create proc ViewMissedInstallments
@studentID int
as
Declare @curr date 
SELECT @curr=CAST( GETDATE() AS Date )
if exists ( select * from GucianStudent s where @studentId = s.id )
begin
select I.*
from GUCianStudentRegisterThesis gs inner join Thesis T on gs.serial_no=t.serialNumber inner join Payment p on T.payment_id = p.id 
inner join Installment I on p.id = I.paymentId
where gs.sid=@studentID and I.date < @curr and I.done='0'
end 
else if exists ( select * from NonGucianStudent s where @studentId = s.id )
begin
select I.*
from NonGUCianStudentRegisterThesis gs inner join Thesis T on gs.serial_no=t.serialNumber inner join Payment p on T.payment_id = p.id 
inner join Installment I on p.id = I.paymentId
where gs.sid=@studentID and I.date < @curr and I.done='0' 
union
select I.*
from NonGucianStudentPayForCourse C inner join Payment p on C.paymentNo = p.id 
inner join Installment I on p.id = I.paymentId
where C.sid=@studentID and I.date < @curr and I.done='0' 
end
else 
print 'invalid id number'

--6) f) Add and fill my progress report(s) --
go
create proc AddProgressReport
@thesisSerialNo int,
@progressReportDate date
as
if exists (select * from Thesis where serialNumber=@thesisSerialNo) and @progressReportDate is not null
begin
declare @sup_id INT 
declare @student_id int
declare @no int
declare @sup_id1 INT 
declare @student_id1 int
declare @no1 int


select @sup_id = N.supid , @student_id =N.sid
from Thesis T inner join GUCianStudentRegisterThesis N on T.serialNumber=N.serial_no 
where N.serial_no = @thesisSerialNo 

select @sup_id1 = N.supid , @student_id1 =N.sid
from Thesis T inner join NonGUCianStudentRegisterThesis N on T.serialNumber=N.serial_no
where N.serial_no = @thesisSerialNo 

select @no =COUNT(*)+1
from GUCianProgressReport
where sid=@student_id

select @no1 =COUNT(*)+1
from NonGUCianProgressReport
where sid=@student_id1


if exists ( select * from NonGucianStudent s where @student_id1 = s.id )
insert into NonGUCianProgressReport (sid ,no ,date , thesisSerialNumber ,supid ) values 
(@student_id1 , @no1 , @progressReportDate ,@thesisSerialNo ,@sup_id1)

else if exists ( select * from GucianStudent s where @student_id = s.id )
insert into GUCianProgressReport (sid ,no ,date , thesisSerialNumber ,supid ) values 
(@student_id , @no , @progressReportDate ,@thesisSerialNo ,@sup_id)
end
else print 'invalid thesis serial number and date'
go 

create proc FillProgressReport
@thesisSerialNo int, @progressReportNo int, @state int, @description varchar(200)
as 
if exists (select * from Thesis where serialNumber=@thesisSerialNo) and @progressReportNo is not null and @state is not null and @description is not null 
begin
declare @student_id int 

select  @student_id =N.sid
from Thesis T inner join GUCianStudentRegisterThesis N on T.serialNumber=N.serial_no 
where N.serial_no = @thesisSerialNo 

select  @student_id =N.sid
from Thesis T inner join NonGUCianStudentRegisterThesis N on T.serialNumber=N.serial_no 
where N.serial_no = @thesisSerialNo 

if exists ( select * from NonGucianStudent s where @student_id = s.id ) and exists (select * from NonGUCianProgressReport where no=@progressReportNo and sid=@student_id)
update NonGUCianProgressReport set  state = @state , description= @description
where sid = @student_id and thesisSerialNumber = @thesisSerialNo and no = @progressReportNo

else if exists ( select * from GucianStudent s where @student_id = s.id ) and exists (select * from GUCianProgressReport where no=@progressReportNo and sid=@student_id)
update GUCianProgressReport set  state = @state , description= @description
where sid = @student_id and thesisSerialNumber = @thesisSerialNo and no = @progressReportNo 
else print 'invalid progress number'
end
else print 'invalid entery'

--6) g) View my progress report(s) evaluations --
go
create proc ViewEvalProgressReport
@thesisSerialNo int, @progressReportNo int
as
if exists (select * from Thesis where serialNumber=@thesisSerialNo) and @progressReportNo is not null
begin
declare @student_id int 

select  @student_id =N.sid
from Thesis T inner join GUCianStudentRegisterThesis N on T.serialNumber=N.serial_no 
where N.serial_no = @thesisSerialNo 

select  @student_id =N.sid
from Thesis T inner join NonGUCianStudentRegisterThesis N on T.serialNumber=N.serial_no 
where N.serial_no = @thesisSerialNo 
if exists ( select * from GucianStudent s where @student_id = s.id ) and exists (select * from GUCianProgressReport where no=@progressReportNo and sid=@student_id)
Begin
select PR.no as progress_report_number ,PR.eval as progress_report_eval
from GUCianProgressReport PR
where PR.sid = @student_id and PR.no = @progressReportNo and PR.thesisSerialNumber = @thesisSerialNo
end
else if exists ( select * from NonGucianStudent s where @student_id = s.id ) and exists (select * from NonGUCianProgressReport where no=@progressReportNo and sid=@student_id)
BEGIN
select PR.no as progress_report_number ,PR.eval as progress_report_eval
from NonGUCianProgressReport PR
where PR.sid = @student_id and PR.no = @progressReportNo and PR.thesisSerialNumber = @thesisSerialNo
end
else 
print 'progress report number incorrect'
end
else print 'invalid thesis serial number or progress report number'

--6) h) Add publication --
go
Create proc addPublication 
@title varchar(50), @pubDate datetime, @host varchar(50), @place varchar(50),@accepted bit
as 
if @title is not null and @pubDate is not null and @place is not null and @accepted is not null and @host is not null
insert into Publication values (@title , @pubDate , @place , @accepted , @host)
else print 'required input data missing'

--6) i) Link publication to my thesis
go
create proc linkPubThesis
@PubID int, @thesisSerialNo int
as 
if exists (select * from Thesis where serialNumber=@thesisSerialNo) and exists (select * from Publication where id=@PubID)
insert into ThesisHasPublication values (@thesisSerialNo , @PubID)
else print 'thesis serial number or publication id is invalid'
go 

