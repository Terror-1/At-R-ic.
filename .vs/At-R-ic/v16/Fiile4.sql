--insertions--
USE Milestone2
GO
--19 PAYMENT--
INSERT INTO Payment VALUES(30000,2,0.5)
INSERT INTO Payment VALUES(28000,1,0.25)
INSERT INTO Payment VALUES(22000,2,0.5)
INSERT INTO Payment VALUES(19000,1,0.5)
INSERT INTO Payment VALUES(45000,2,0.1)
INSERT INTO Payment VALUES(30000,1,0.3)
INSERT INTO Payment VALUES(28000,2,0.34)
INSERT INTO Payment VALUES(22000,1,0.5)
INSERT INTO Payment VALUES(19000,2,0.8)
INSERT INTO Payment VALUES(45000,3,0.2)
INSERT INTO Payment VALUES(55520,2,0.1)
INSERT INTO Payment VALUES(45670,1,0.1)
INSERT INTO Payment VALUES(33000,2,0.2)
INSERT INTO Payment VALUES(10000,1,0.5)
INSERT INTO Payment VALUES(12000,2,0.11)
INSERT INTO Payment VALUES(6670,1,0.1)
INSERT INTO Payment VALUES(3000,2,0.2)
INSERT INTO Payment VALUES(10000,1,0.5)
INSERT INTO Payment VALUES(12000,2,0.11)
----------------------------------------------------------------------------
--26 installment --

INSERT INTO Installment VALUES('2018/5/23',1,15000,'1')
INSERT INTO Installment VALUES('2018/11/23',1,15000,'1')
INSERT INTO Installment VALUES('2019/3/1',2,28000,'1')
INSERT INTO Installment VALUES('2019/4/1',3,11000,'1')
INSERT INTO Installment VALUES('2019/10/1',3,11000,'0')
INSERT INTO Installment VALUES('2020/3/1',4,19000,'1')
INSERT INTO Installment VALUES('2019/5/10',5,22500,'1')
INSERT INTO Installment VALUES('2019/11/10',5,22500,'0')
INSERT INTO Installment VALUES('2019/4/6',6,30000,'0')
INSERT INTO Installment VALUES('2018/10/10',7,14000,'1')
INSERT INTO Installment VALUES('2019/4/10',7,14000,'0')
INSERT INTO Installment VALUES('2019/4/5',8,11000,'1')
INSERT INTO Installment VALUES('2019/10/5',8,11000,'0')
INSERT INTO Installment VALUES('2021/4/9',9,8000,'0')
INSERT INTO Installment VALUES('2021/10/9',9,8000,'1')
INSERT INTO Installment VALUES('2020/5/23',10,15000,'1')
INSERT INTO Installment VALUES('2020/11/23',10,15000,'0')
INSERT INTO Installment VALUES('2021/5/23',10,15000,'1')
INSERT INTO Installment VALUES('2021/8/1',11,27760,'1')
INSERT INTO Installment VALUES('2022/2/1',11,27760,'0')
INSERT INTO Installment VALUES('2018/7/5',12,45670,'1')
INSERT INTO Installment VALUES('2019/1/9',13,16500,'1')
INSERT INTO Installment VALUES('2019/7/9',13,16500,'0')
INSERT INTO Installment VALUES('2019/5/5',14,10000,'0')
INSERT INTO Installment VALUES('2021/7/1',15,6000,'1')
INSERT INTO Installment VALUES('2022/1/1',15,6000,'0')
INSERT INTO Installment VALUES('2022/7/1',16,66700,'0')
INSERT INTO Installment VALUES('2021/1/9',17,3000,'1')
INSERT INTO Installment VALUES('2021/7/9',17,3000,'0')
INSERT INTO Installment VALUES('2021/11/23',18,10000,'0')
INSERT INTO Installment VALUES('2022/8/1',19,6000,'0')
INSERT INTO Installment VALUES('2023/2/1',19,6000,'0')


-----------------------------------------------------------------------------------
--15 thesis insertions--
INSERT INTO Thesis (field,type ,title ,startDate,endDate,defenseDate,grade,noExtension,payment_id) VALUES ('CS', 'Master', 'Python Bites', '2018/5/23', '2022/5/23', '2022/7/23',  40,1,1);
INSERT INTO Thesis (field,type ,title ,startDate,endDate,defenseDate,grade,noExtension,payment_id) VALUES ('Pharmacy', 'Master', 'BioTrends', '2019/3/1', '2022/3/1', '2022/5/1',  50,2,2);
INSERT INTO Thesis (field,type ,title ,startDate,endDate,defenseDate,grade,noExtension,payment_id) VALUES ('IET', 'Master', 'Arduino', '2019/4/1', '2021/12/1', '2021/12/23',  70,2,3);
INSERT INTO Thesis (field,type ,title ,startDate,endDate,defenseDate,grade,noExtension,payment_id) VALUES ('CS', 'Master', 'Javaphobics', '2020/3/1', '2022/3/1', '2022/4/1', 80,3,4);
INSERT INTO Thesis (field,type ,title ,startDate,endDate,defenseDate,grade,noExtension,payment_id) VALUES ('appliedArts', 'phD', 'AutoCad', '2019/5/10', '2021/5/1 ','2021/12/20', 90,1,5);
INSERT INTO Thesis (field,type ,title ,startDate,endDate,defenseDate,grade,noExtension,payment_id) VALUES ('MET', 'Master', 'MachineLearning', '2019/4/6', '2024/4/6', '2024/5/1',  10,2,6);
INSERT INTO Thesis (field,type ,title ,startDate,endDate,defenseDate,grade,noExtension,payment_id) VALUES ('Pharmacy', 'Master', 'plantsDrugs ', '2018/10/10', '2022/10/10', '2022/11/1',  20,1,7);
INSERT INTO Thesis (field,type ,title ,startDate,endDate,defenseDate,grade,noExtension,payment_id) VALUES ('AppliedArts', 'Phd', 'Design', '2019/4/5', '2021/5/5', '2023/5/1', 80,1,8);
INSERT INTO Thesis (field,type ,title ,startDate,endDate,defenseDate,grade,noExtension,payment_id) VALUES ('MNGMT', 'Master', 'Logestics', '2021/4/9', '2023/5/1', '2023/5/10',  100,2,9);
INSERT INTO Thesis (field,type ,title ,startDate,endDate,defenseDate,grade,noExtension,payment_id) VALUES ('CS', 'Phd', 'JavaHardware', '2020/5/23', '2022/12/1', '2022/1/1',  70,1,10);
INSERT INTO Thesis (field,type ,title ,startDate,endDate,defenseDate,grade,noExtension,payment_id) VALUES ('BI', 'Phd', 'Business in KG Ext', '2021/8/1', '2023/1/5', '2022/2/5',  40,2,11);
INSERT INTO Thesis (field,type ,title ,startDate,endDate,defenseDate,grade,noExtension,payment_id) VALUES ('CS', 'Phd', 'AWS', '2018/7/5', '2021/12/12', '2022/2/2',  30,3,12);
INSERT INTO Thesis (field,type ,title ,startDate,endDate,defenseDate,grade,noExtension,payment_id) VALUES ('CS', 'Phd', 'JavaHardware', '2019/1/9', '2022/3/1', '2022/5/1', 48,1,13);
INSERT INTO Thesis (field,type ,title ,startDate,endDate,defenseDate,grade,noExtension,payment_id) VALUES ('CS', 'Phd', 'AI', '2019/5/5', '2024/6/1', '2024/7/1',  65,2,14);
INSERT INTO Thesis (field,type ,title ,startDate,endDate,defenseDate,grade,noExtension,payment_id) VALUES ('MNGMT', 'Master', 'Ethics_inManagement', '2021/7/1', '2024/7/7', '2024/9/1', 78,2,15);
INSERT INTO Thesis (field,type ,title ,startDate,endDate,noExtension) VALUES ('IET', 'Master', 'EthicalHacking', '2021/7/1', '2024/7/7',0);
insert into Thesis (field) values ('hacking');
-----------------------------------------------------------------------
--13 user--
--4-Gucians--
insert into PostGradUser values ('alimahmoud@student.guc.edu.eg','As555')
insert into PostGradUser values ('salma.ahmed@student.guc.edu.eg','hljhu555')
insert into PostGradUser values ('Alia.hamad@student.guc.edu.eg','gege')
insert into PostGradUser values ('Abdullah.farag@student.guc.edu.eg','Auilsvvv555')
INSERT INTO GucianStudent(id,firstName,lastName,type,faculty,address,GPA,undergradID) VALUES(1,'Ali','Mahmoud','Master','IET','Maadi',2.51,55)
INSERT INTO GucianStudent (id,firstName,lastName,type,faculty,address,GPA,undergradID) VALUES(2,'Salma','Ahmed','PhD','Applied Arts','Nasr City',1.2,56)
INSERT INTO GucianStudent (id,firstName,lastName,type,faculty,address,GPA,undergradID) VALUES(3,'Alia','Hamad','Master','MET','Rehab',0.92,57)
INSERT INTO GucianStudent(id,firstName,lastName,type,faculty,address,GPA,undergradID)  VALUES(4,'Abdullah','Farag','Master','Pharmacy','Maadi',1.1,58)
--4nongucians--
insert into PostGradUser values ('hossamMahmoud@gmail.com','As555')
insert into PostGradUser values ('abdo_ahmed11@gmail.com','hfaljhu555')
insert into PostGradUser values ('tamerHamed@gmail.com','ge5dg4')
insert into PostGradUser values ('minafarag@gmail.com','ASFv555')
INSERT INTO NonGucianStudent(id,firstName,lastName,type,faculty,address,GPA) VALUES(5,'Hosam','Mahmoud','Master','MNGMNT','NewCairo',1.55)
INSERT INTO NonGucianStudent (id,firstName,lastName,type,faculty,address,GPA) VALUES(6,'abdo','Ahmed','PhD','CS','6 octobor City',3.2)
INSERT INTO NonGucianStudent (id,firstName,lastName,type,faculty,address,GPA) VALUES(7,'tamer','Hamad','PhD','CS','Rehab',2.92)
INSERT INTO NonGucianStudent(id,firstName,lastName,type,faculty,address,GPA)  VALUES(8,'Mina','Farag','PhD','BI','Madinaty',2.1)
--5 SUPERVISORS--
insert into PostGradUser values ('NADAaki@gmail.com','As22555')
insert into PostGradUser values ('Amrahmed@gmail.com','hfau2555')
insert into PostGradUser values ('Amr_haythem@gmail.com','ge5jdg4')
insert into PostGradUser values ('abdoHusiien@gmail.com','ge5jdg4')
insert into PostGradUser values ('abdoali@gmail.com','ge5jdg4')
INSERT INTO Supervisor VALUES(9, 'Nada Ali', 'MET')
INSERT INTO Supervisor VALUES(10, 'Amr Ahmed', 'Pharmacy')
INSERT INTO Supervisor VALUES(11, 'Amr Haytham', 'IET')
INSERT INTO Supervisor VALUES(12, 'abdo hussien', 'appliedArts')
INSERT INTO Supervisor VALUES(13, 'abdo ali', 'Mangmnet')

--5 examiners--
insert into PostGradUser values ('hady_adel@gmail.com','bs22555')
insert into PostGradUser values ('omar_Fahmi@gmail.com','dfau2555')
insert into PostGradUser values ('omar_ahmed@gmail.com','dfau2555')
insert into PostGradUser values ('amr_elmougy@gmail.com','dfau2555')
insert into PostGradUser values ('passant_ahmed@gmail.com','dfau2555')
INSERT INTO Examiner VALUES(14, 'Hady Adel', 'Engineering', '1')
INSERT INTO Examiner VALUES(15, 'slimkhaled', 'pharmacy', '0')
INSERT INTO Examiner VALUES(16, 'omar ahmed', 'Mangment', '1')
INSERT INTO Examiner VALUES(17, 'amr elmougy', 'BI', '1')
INSERT INTO Examiner VALUES(18, 'passant_ahmed', 'Computer Sciense', '1')

---------------------------------------------------------------------------
--progres reports--
---add descriptions--
INSERT INTO GUCianProgressReport VALUES(1,1,'2019/1/1',2,3,1,11,'descrip')
INSERT INTO GUCianProgressReport VALUES(2,1,'2019/4/5',2,1,8,12,'descrip')
INSERT INTO GUCianProgressReport VALUES(3,1,'2020/3/1',1,2,4,9,'descrip')
INSERT INTO GUCianProgressReport VALUES(4,1,'2019/3/1',3,1,2,10,'descrip')
insert into GUCianStudentRegisterThesis values (1,11,1)
insert into GUCianStudentRegisterThesis values (2,12,8)
insert into GUCianStudentRegisterThesis values (3,9,4)
insert into GUCianStudentRegisterThesis values (4,10,2)
----
insert into GUCianStudentRegisterThesis values (1,9,3)
insert into GUCianStudentRegisterThesis values (2,12,5)
insert into GUCianStudentRegisterThesis values (3,9,6)
insert into GUCianStudentRegisterThesis values (4,10,7)
--

INSERT INTO NonGUCianProgressReport VALUES(5,1,'2021/7/1',2,1,15,13,'descrip')
INSERT INTO NonGUCianProgressReport VALUES(6,1,'2019/1/9',1,3,13,9,'descrip')
INSERT INTO NonGUCianProgressReport VALUES(7,1,'2020/5/23',2,2,10,9,'descrip')
INSERT INTO NonGUCianProgressReport VALUES(8,1,'2021/8/1',0,1,11,11,'descrip')
insert into NonGUCianStudentRegisterThesis values (5,13,15)
insert into NonGUCianStudentRegisterThesis values (6,9,13)
insert into NonGUCianStudentRegisterThesis values (7,9,10)
insert into NonGUCianStudentRegisterThesis values (8,11,11)
insert into NonGUCianStudentRegisterThesis values (5,13,9)
insert into NonGUCianStudentRegisterThesis values (6,9,12)
insert into NonGUCianStudentRegisterThesis values (7,9,14)
insert into NonGUCianStudentRegisterThesis values (5,13,17)
------------------------------------------------------------
--Courses--
INSERT INTO Course VALUES(6000,6,'CSEN502')
INSERT INTO Course VALUES(7000,6,'MNGMNT2')
INSERT INTO Course VALUES(8000,4,'CSEN301')
INSERT INTO Course VALUES(4000,4,'CSEN501')

INSERT INTO NonGucianStudentTakeCourse VALUES(5,2,80)
INSERT INTO NonGucianStudentTakeCourse VALUES(6,1,70)
INSERT INTO NonGucianStudentTakeCourse VALUES(7,3,40)
INSERT INTO NonGucianStudentTakeCourse VALUES(8,4,10)


insert into NonGucianStudentPayForCourse values (5,16,2)
insert into NonGucianStudentPayForCourse values (6,17,1)
insert into NonGucianStudentPayForCourse values (7,18,3)
insert into NonGucianStudentPayForCourse values (8,19,4)
-------------------------------------

--Defences and Examiners attending ---

INSERT INTO Defense VALUES(1, '2022/7/23', 'C3.108', 60)
INSERT INTO Defense VALUES(2, '2022/2/1', 'H5', 40)
INSERT INTO Defense VALUES(3, '2021/12/23', 'H14', 30)
INSERT INTO Defense VALUES(4, '2022/4/1', 'H3', 67)
INSERT INTO Defense VALUES(5, '2021/12/20', 'C7.305', 11)
INSERT INTO Defense VALUES(6, '2024/5/1', 'H12', 100)
INSERT INTO Defense VALUES(7, '2022/11/1', 'H11', 99)
INSERT INTO Defense VALUES(8, '2023/5/1', 'D4.302', 85)
INSERT INTO Defense VALUES(9, '2023/5/10', 'H5', 66)
INSERT INTO Defense VALUES(10, '2022/1/1', 'H9', 30)
INSERT INTO Defense VALUES(11, '2022/2/5', 'H12', 45)
INSERT INTO Defense VALUES(12, '2022/2/2', 'C7.305', 25)
INSERT INTO Defense VALUES(13, '2022/5/1', 'H9', 20)
INSERT INTO Defense VALUES(14, '2024/7/1', 'H7', 44)
INSERT INTO Defense VALUES(15, '2024/9/1', 'H17', 97)


Insert INTO ExaminerEvaluateDefense VALUES('2022/7/23',1,18,'Good')
Insert INTO ExaminerEvaluateDefense VALUES('2022/2/1',2,15,'Good')
Insert INTO ExaminerEvaluateDefense VALUES('2021/12/23',3,14,'Okay')
Insert INTO ExaminerEvaluateDefense VALUES('2022/4/1',4,18,'Perfect')
Insert INTO ExaminerEvaluateDefense VALUES('2021/12/20',5,17,'Perfect')
Insert INTO ExaminerEvaluateDefense VALUES('2024/5/1',6,18,'Good')
Insert INTO ExaminerEvaluateDefense VALUES('2022/11/1',7,15,'Good')
Insert INTO ExaminerEvaluateDefense VALUES('2023/5/1',8,14,'Okay')
Insert INTO ExaminerEvaluateDefense VALUES('2023/5/10',9,18,'Perfect')
Insert INTO ExaminerEvaluateDefense VALUES('2022/1/1',10,17,'Perfect')
Insert INTO ExaminerEvaluateDefense VALUES('2022/2/5',11,18,'Good')
Insert INTO ExaminerEvaluateDefense VALUES('2022/2/2',12,15,'Good')
Insert INTO ExaminerEvaluateDefense VALUES('2022/5/1',13,14,'Okay')
Insert INTO ExaminerEvaluateDefense VALUES('2024/7/1',14,18,'Perfect')
Insert INTO ExaminerEvaluateDefense VALUES('2024/9/1',15,17,'Perfect')
---------------
--publications--
insert into Publication values ('phythonBites' ,'2021/9/23','H14','1','German university in Cairo')
insert into publication values ('Biotrends' , '2021/7/1' ,'ALTS' ,'0', 'The american literary association')
insert into publication values ('ethicalhacking', ' 2022/1/1', 'AUC','1','flibbingBook')
insert into Publication values ('AI USING python' , '2021/11/23','AIN shamns University','1','AISC')
insert into ThesisHasPublication values (1,4)
insert into ThesisHasPublication values (1,1)
insert into ThesisHasPublication values (2,2)
insert into ThesisHasPublication values (16,3)



