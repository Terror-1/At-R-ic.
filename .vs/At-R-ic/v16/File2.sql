USE Milestone2
GO
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
INSERT INTO PostGradUser (email,password) VALUES(@email,@password)
DECLARE @ID INT
SELECT @ID =PGU.id
FROM PostGradUser PGU
WHERE PGU.email=@email AND PGU.password=@password
IF @Gucian = 1 
INSERT INTO GucianStudent (id,firstName,lastName,faculty,address) VALUES(@ID,@first_name,@last_name,@faculty,@address)
ELSE 
INSERT INTO NonGucianStudent (id,firstName,lastName,faculty,address) VALUES(@ID,@first_name,@last_name,@faculty,@address)

--drop proc StudentRegister--
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
INSERT INTO PostGradUser (email,password) VALUES(@email,@password)
DECLARE @ID INT
SELECT @ID =PGU.id
FROM PostGradUser PGU
WHERE PGU.email=@email AND PGU.password=@password
INSERT INTO Supervisor (id,Name,faculty) VALUES(@ID,@first_name+@last_name,@faculty)

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
set @Success = 1
else 
set @Success = 0
print @Success

GO

create proc addMobile 
@ID int ,
@mobile_number varchar(20)
as 
if exists ( select * from GucianStudent s where @ID = s.id )
insert into GUCStudentPhoneNumber (id ,phone) values (@ID , @mobile_number)
else if exists ( select * from NonGucianStudent s where @ID = s.id )
insert into NonGUCStudentPhoneNumber (id ,phone) values (@ID , @mobile_number)
else 
print 'id not correct'

GO

create proc AdminListSup 
as 
select *
from Supervisor

GO
CREATE PROC AdminViewSupervisorProfile 
@supId int 
as 
select * 
from Supervisor S
where  S.id= @supId 

Go

create proc AdminViewAllTheses
as 
select * 
from Thesis

Go 

create proc AdminViewOnGoingTheses
@thesesCount int output 
as
select @thesesCount= count (*)
from Thesis 

Go

create proc AdminViewStudentThesisBySupervisor
as 
select Su.name , t.title , s.firstName+s.lastName as Student_name 
from GUCianProgressReport GPR inner join GucianStudent s on GPR.sid = s.id 
inner join Thesis t on GPR.thesisSerialNumber = t.serialNumber 
inner join Supervisor Su on GPR.supid = Su.id 
union 
select Su.name , t.title , s.firstName+' '+s.lastName as Student_name 
from NonGUCianProgressReport GPR inner join NonGucianStudent s on GPR.sid = s.id 
inner join Thesis t on GPR.thesisSerialNumber = t.serialNumber 
inner join Supervisor Su on GPR.supid = Su.id 

Go

create proc AdminListNonGucianCourse
@courseID int 
as 
select S.firstName+' '+S.lastName as Student_name , C.code , tc.grade 
from NonGucianStudentTakeCourse tc inner join Course C on tc.cid= C.id 
inner join NonGucianStudent S on tc.sid=S.id 
where @courseID = C.id

Go

create proc AdminUpdateExtension
@ThesisSerialNo int 
as 
update Thesis set noExtension = noExtension+1 
where serialNumber=@ThesisSerialNo

go

create proc AdminIssueThesisPayment
@ThesisSerialNo int ,
@amount Decimal(10,2),
@noOfInstallments int ,
@fundPercentage decimal (3,2),
@Sucess Bit output 
as 
Declare @id int 
select @id = T.payment_id
from Thesis T
where T.serialNumber = @ThesisSerialNo

if @id =0
begin
set @Sucess = 0
print 'warnning' 
end 

else 
begin
set @Sucess = 1
update Payment set amount = @amount , no_installments = @noOfInstallments , fundPercentage =@fundPercentage 
where id=@id
end 

print @Sucess 

Go

create proc AdminViewStudentProfile 
@sid int 
as 
if exists ( select * from GucianStudent s where @sid = s.id )
select * from GucianStudent s where @sid = s.id 
else if exists ( select * from NonGucianStudent s where @sid = s.id )
select * from NonGucianStudent s where @sid = s.id 
else
print 'id not correct'

Go

create proc AdminIssueInstallPayment
@paymentID int ,
@InstallStartDate date 
as 
declare @amo decimal(10,2)
declare @num int
select @amo =pa.amount, @num=pa.no_installments
from Payment pa where pa.id=@paymentID
set @amo = @amo/@num
declare @enddate date 
set @enddate=@InstallStartDate
SET @enddate = DATEADD(MONTH, 6, @enddate)
declare @curr date
--SELECT @curr=CAST( GETDATE() AS Date ) ;--

select @curr=th.endDate
from Thesis th 
where th.payment_id=@paymentID

declare @co int
select @co=0 --count(i.paymentId)--
from Installment i inner join Payment pa on i.paymentId=pa.id
where @paymentID=pa.id
while (@curr >= @enddate and @co<@num)
begin
insert into Installment values(@enddate,@paymentID,@amo,0)
SET @enddate = DATEADD(MONTH, 6, @enddate)
set @co = @co+1
end 

go
create proc AdminListAcceptPublication
as
select p.title
from Thesis t inner join ThesisHasPublication tp on t.serialNumber=tp.serialNo
inner join Publication p on p.id=tp.pubid
where p.accepted =1

go
CREATE PROC AddCourse
@fees decimal,
@creditHrs int,
@courseCode varchar(10)
as
insert into Course values(@fees,@creditHrs,@courseCode)
--link courses to students meaning ???????---

go
CREATE PROC linkCourseStudent
@studentID int,
@courseID int
as
insert into NonGucianStudentTakeCourse (sid,cid) values(@studentID,@courseID)

go
CREATE PROC addStudentCourseGrade
@courseID int,
@studentID int, 
@grade decimal(3,2)
as
update NonGucianStudentTakeCourse
set grade=  @grade
WHERE @studentID=sid and  @courseID=cid

go

create proc ViewExamSupDefense
@defenseDate datetime
as
select e.name
from Examiner e inner join ExaminerEvaluateDefense ed on e.id=ed.examinerId
where @defenseDate=ed.date
union
select s.name
from Supervisor s inner join GUCianStudentRegisterThesis gt on s.id=gt.supid
inner join Thesis t on t.serialNumber=gt.serial_no
where @defenseDate=t.defenseDate
union
select s.name
from Supervisor s inner join NonGucianStudentTakeCourse gt on s.id=gt.supid
inner join Thesis t on t.serialNumber=gt.serial_no
where @defenseDate=t.defenseDate

go
create proc EvaluateProgressReport
@supervisorID int,
@thesisSerialNo int,
@progressReportNo int, 
@evaluation int
as
if(@evaluation>=0 and @evaluation <=3)
begin
if exists(
select *
from GUCianProgressReport p 
where p.no=@progressReportNo and @thesisSerialNo=p.thesisSerialNumber
)
begin
update GUCianProgressReport
set eval =@evaluation
where no=@progressReportNo and @thesisSerialNo=thesisSerialNumber and supid=@supervisorID
end
else if exists(
select *
from NonGUCianProgressReport p 
where p.no=@progressReportNo and @thesisSerialNo=p.thesisSerialNumber
)
begin
update NonGUCianProgressReport
set eval =@evaluation
where no=@progressReportNo and @thesisSerialNo=thesisSerialNumber and supid=@supervisorID
end
else print 'incorrect entry'
end
else
print 'Evaluation not correct'

go

create proc ViewSupStudentsYears
@supervisorID int
as
select g.firstName,g.lastName , t.years
from GucianStudent g inner join GUCianProgressReport gp on g.id=gp.sid
inner join Thesis t on t.serialNumber=gp.thesisSerialNumber
where gp.supid = @supervisorID
union
select g.firstName,g.lastName , t.years
from NonGucianStudent g inner join NonGUCianProgressReport gp on g.id=gp.sid
inner join Thesis t on t.serialNumber=gp.thesisSerialNumber
where gp.supid = @supervisorID

go
create proc SupViewProfile
@supervisorID int 
as 
select * 
from Supervisor S
where S.id = @supervisorID

go 
create proc UpdateSupProfile
@supervisorID int, @name varchar(20), @faculty varchar(20)
as 
update Supervisor 
set name = @name , faculty = @faculty
where id = @supervisorID 

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
print 'id not correct'

Go


create proc AddDefenseGucian
@ThesisSerialNo int , @DefenseDate Datetime , @DefenseLocation varchar(15)
as
insert into Defense (serialNumber ,date ,location ) values (@ThesisSerialNo , @DefenseDate , @DefenseLocation)

go 

create proc AddDefenseNonGucian
@ThesisSerialNo int , @DefenseDate Datetime , @DefenseLocation varchar(15)
as 
if not exists (select Ne.cid 
from Thesis T inner join NonGUCianStudentRegisterThesis N on T.serialNumber = N.serial_no 
inner join NonGucianStudentTakeCourse Ne on Ne.sid = N.sid 
where Ne.grade> 0.5 And @ThesisSerialNo = T.serialNumber except (select Ne1.cid 
from Thesis T1 inner join NonGUCianStudentRegisterThesis N1 on T1.serialNumber = N1.serial_no 
inner join NonGucianStudentTakeCourse Ne1 on Ne1.sid = N1.sid
where  @ThesisSerialNo = T1.serialNumber))
insert into Defense (serialNumber ,date ,location ) values (@ThesisSerialNo , @DefenseDate , @DefenseLocation)
else 
print 'grade < 50 precent '

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

go 

create proc CancelThesis 
@ThesisSerialNo int 
as 

declare @blabizo int
select @blabizo = N.eval 
from NonGUCianProgressReport N where N.thesisSerialNumber = @ThesisSerialNo AND
N.date > all (select N2.date
from NonGUCianProgressReport N2 where N.sid+N.no<>N2.sid+N2.no )

declare @blabizo2 int
select @blabizo2 = N.eval 
from GUCianProgressReport N where
N.thesisSerialNumber = @ThesisSerialNo AND
N.date > all (select N2.date
from GUCianProgressReport N2 where N.sid+N.no<>N2.sid+N2.no )

delete from Thesis where serialNumber = @ThesisSerialNo and @blabizo= 0 ;
delete from Thesis where serialNumber = @ThesisSerialNo and @blabizo2= 0 ;

go
--//whether it is defence grade--
Create proc AddGrade
@ThesisSerialNo int 
as 
declare @ggrade decimal  
select @ggrade= c.grade 
from Defense c 
where c.serialNumber = @ThesisSerialNo 

update Thesis 
set grade =@ggrade
where serialNumber = @ThesisSerialNo

go

create proc AddDefenseGrade 
@ThesisSerialNo int , @DefenseDate Datetime , @grade decimal(3,2)
as 
update Defense set grade = @grade 
where serialNumber=@ThesisSerialNo and date = @DefenseDate 

go 

create proc AddCommentsGrade 
@ThesisSerialNo int , @DefenseDate Datetime ,@Examiner_id int  , @comments varchar(300) 
as 
update ExaminerEvaluateDefense set comment = @comments
where serialNo=@ThesisSerialNo and date = @DefenseDate and examinerId = @Examiner_id 

go

create proc viewMyProfile
@studentId int
as 
if exists ( select * from GucianStudent s where @studentId = s.id )
select * from GucianStudent s where @studentId = s.id 
else if exists ( select * from NonGucianStudent s where @studentId = s.id )
select * from NonGucianStudent s where @studentId = s.id 
else
print 'id is not correct'


go
create proc editMyProfile
@studentID int, @firstName varchar(10), @lastName varchar(10), @password varchar(10), @email
varchar(10), @address varchar(10), @type varchar(10)
as 
update PostGradUser set password = @password, email = @email 
where id = @studentID 

if exists ( select * from GucianStudent s where @studentId = s.id )
update GucianStudent set firstName =@firstName , lastName = @lastName , address = @address , type = @type where id = @studentID
else if exists ( select * from NonGucianStudent s where @studentId = s.id )
update NonGucianStudent set firstName =@firstName , lastName = @lastName , address = @address , type = @type where id = @studentID
else 
print 'id is not crrocet '

go 

create proc addUndergradID
@studentID int, @undergradID varchar(10)
as 
update GucianStudent set undergradID= @undergradID where id=@studentID
go

create proc ViewCoursesGrades
@studentID int 
as 
select C.grade 
from NonGucianStudentTakeCourse C 
where C.sid = @studentID

go

create proc ViewCoursePaymentsInstall 
@studentID int
as 
select p.* , I.*
from NonGucianStudentPayForCourse N inner join Payment p on N.paymentNo = p.id 
inner join Installment I on p.id = I.paymentId
where N.sid = @studentID
go

create proc ViewThesisPaymentsInstall 
@studentID int
as 
if exists ( select * from GucianStudent s where @studentId = s.id )
begin
select p.* , I.*
from GUCianStudentRegisterThesis gs inner join Thesis T on gs.serial_no=t.serialNumber inner join Payment p on T.payment_id = p.id 
inner join Installment I on p.id = I.paymentId
where gs.sid=@studentID
end 
else if exists ( select * from NonGucianStudent s where @studentId = s.id )
begin
select p.* , I.*
from NonGUCianStudentRegisterThesis gs inner join Thesis T on gs.serial_no=t.serialNumber inner join Payment p on T.payment_id = p.id 
inner join Installment I on p.id = I.paymentId
where gs.sid=@studentID
end
else 
print 'incorrect entry'

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
where gs.sid=@studentID and I.date > @curr
end 
else if exists ( select * from NonGucianStudent s where @studentId = s.id )
begin
select I.*
from NonGUCianStudentRegisterThesis gs inner join Thesis T on gs.serial_no=t.serialNumber inner join Payment p on T.payment_id = p.id 
inner join Installment I on p.id = I.paymentId
where gs.sid=@studentID and I.date > @curr
end
else 
print 'incorrect entry'

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
end
else 
print 'incorrect entry'

go
create proc AddProgressReport
@thesisSerialNo int,
@progressReportDate date
as
declare @sup_id INT 
declare @student_id int 

select @sup_id = N.supid , @student_id =N.sid
from Thesis T inner join GUCianStudentRegisterThesis N on T.serialNumber=N.serial_no 
where N.serial_no = @thesisSerialNo 


select @sup_id = N.supid , @student_id =N.sid
from Thesis T inner join NonGUCianStudentRegisterThesis N on T.serialNumber=N.serial_no 
where N.serial_no = @thesisSerialNo 
if exists ( select * from NonGucianStudent s where @student_id = s.id )
insert into NonGUCianProgressReport (sid ,no ,date , thesisSerialNumber ,supid ) values 
(@student_id , DEFAULT , @progressReportDate ,@thesisSerialNo ,@sup_id)

else if exists ( select * from GucianStudent s where @student_id = s.id )
insert into GUCianProgressReport (sid ,no ,date , thesisSerialNumber ,supid ) values 
(@student_id , DEFAULT , @progressReportDate ,@thesisSerialNo ,@sup_id)
else 
print 'id not correct'

go 

create proc FillProgressReport
@thesisSerialNo int, @progressReportNo int, @state int, @description varchar(200)
as 
declare @student_id int 

select  @student_id =N.sid
from Thesis T inner join GUCianStudentRegisterThesis N on T.serialNumber=N.serial_no 
where N.serial_no = @thesisSerialNo 

select  @student_id =N.sid
from Thesis T inner join NonGUCianStudentRegisterThesis N on T.serialNumber=N.serial_no 
where N.serial_no = @thesisSerialNo 

if exists ( select * from NonGucianStudent s where @student_id = s.id )
update NonGUCianProgressReport set no = @progressReportNo , state = @state , description= @description
where sid = @student_id and thesisSerialNumber = @thesisSerialNo

else if exists ( select * from GucianStudent s where @student_id = s.id )
update GUCianProgressReport set no = @progressReportNo , state = @state , description= @description
where sid = @student_id and thesisSerialNumber = @thesisSerialNo

else 
print 'id not correct'
go


create proc ViewEvalProgressReport
 @thesisSerialNo int, @progressReportNo int
 as
declare @student_id int 

select  @student_id =N.sid
from Thesis T inner join GUCianStudentRegisterThesis N on T.serialNumber=N.serial_no 
where N.serial_no = @thesisSerialNo 

select  @student_id =N.sid
from Thesis T inner join NonGUCianStudentRegisterThesis N on T.serialNumber=N.serial_no 
where N.serial_no = @thesisSerialNo 
if exists ( select * from GucianStudent s where @student_id = s.id )
Begin
select PR.no,PR.eval
from GUCianProgressReport PR
where PR.sid = @student_id and PR.no = @progressReportNo and PR.thesisSerialNumber = @thesisSerialNo
end
else if exists ( select * from NonGucianStudent s where @student_id = s.id )
BEGIN
select PR.no,PR.eval
from NonGUCianProgressReport PR
where PR.sid = @student_id and PR.no = @progressReportNo and PR.thesisSerialNumber = @thesisSerialNo
end
else 
print 'id not correct'
go

Create proc addPublication 
@title varchar(50), @pubDate datetime, @host varchar(50), @place varchar(50),@accepted bit
as 
insert into Publication values (@title , @pubDate , @place , @accepted , @host)
go

create proc linkPubThesis
@PubID int, @thesisSerialNo int
as 
insert into ThesisHasPublication values (@thesisSerialNo , @PubID)
go 
















