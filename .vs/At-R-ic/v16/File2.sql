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
SELECT @curr=CAST( GETDATE() AS Date ) ;
declare @co int
select @co=count(i.paymentId)
from Installment i inner join Payment pa on i.paymentId=pa.id
where @paymentID=pa.id
while (@curr >= @enddate and @co<@num)
begin
insert into Installment values(@enddate,@paymentID,@amo,0)
SET @enddate = DATEADD(MONTH, 6, @enddate)
set @co = @co+1
end 

