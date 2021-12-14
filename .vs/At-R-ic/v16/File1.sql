--table creations--
CREATE Database Milestone2
GO
USE Milestone2
CREATE Table PostGradUser
(
id INT PRIMARY KEY IDENTITY,
email varchar(50),
password  VARCHAR(20)
);

CREATE Table Admin
(
id INT PRIMARY KEY,
FOREIGN KEY(id) REFERENCES PostGradUser ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE Table GucianStudent(
    id INT PRIMARY KEY,
    firstName VARCHAR(20),
    lastName VARCHAR(20),
    type varchar(10),
    faculty VARCHAR(20),
    address VARCHAR(50),
    GPA DECIMAL(3,2), 
    undergradID INT ,
    FOREIGN KEY(id) REFERENCES PostGradUser ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE Table NonGucianStudent(
    id INT PRIMARY KEY,
    firstName VARCHAR(20),
    lastName VARCHAR(20),
    type varchar(10),
    faculty VARCHAR(20),
    address VARCHAR(50),
    GPA DECIMAL(3,2),
    FOREIGN KEY(id) REFERENCES PostGradUser ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE Table GUCStudentPhoneNumber(
    id INT  ,
    phone VARCHAR(20) ,
    PRIMARY KEY(id, phone), 
    FOREIGN KEY (id) REFERENCES GucianStudent ON DELETE CASCADE ON UPDATE CASCADE 
);

CREATE Table NonGUCStudentPhoneNumber(
    id INT,
    phone VARCHAR(20),
    PRIMARY KEY(id, phone), 
    FOREIGN KEY (id) REFERENCES NonGucianStudent ON DELETE CASCADE ON UPDATE CASCADE
);    


CREATE TABLE Course(
    id INT PRIMARY KEY IDENTITY ,
    fees INT,
    creditHours INT,
    code VARCHAR(10)
);

CREATE TABLE Payment(
    id INT PRIMARY KEY Identity ,
    amount DECIMAL(10,2),
    no_installments INT,
    fundPercentage DECIMAL(3,2)
); 

CREATE TABLE Supervisor(
    id INT PRIMARY KEY,
    name VARCHAR(40),
    faculty VARCHAR(20),
    FOREIGN KEY(id) REFERENCES PostGradUser ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Thesis(
    serialNumber INT PRIMARY KEY identity ,
    field VARCHAR(20), 
    type VARCHAR(20), 
    title VARCHAR(20), 
    startDate DATETIME, 
    endDate DATETIME, 
    defenseDate DATETIME, 
    years AS (YEAR(endDATE)-YEAR(startDATE)), 
    grade DECIMAL(3,2), 
    payment_id INT unique,
    noExtension INT,
    FOREIGN KEY (payment_id)  REFERENCES Payment ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Publication(
    id INT PRIMARY KEY IDENTITY,
    title VARCHAR(50),
    date DATETIME,
    place VARCHAR(50),
    accepted BIT,
    host VARCHAR(50)
);


CREATE TABLE Examiner(
    id INT PRIMARY KEY ,
    name VARCHAR(20),
    fieldofwork VARCHAR(20),
    isNational BIT,
    FOREIGN KEY(id) REFERENCES PostGradUser ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Defense (
    serialNumber INT ,
    date DATETIME ,
    location VARCHAR(20),
    grade DECIMAL(3,2),
    PRIMARY KEY(serialNumber,date),
    FOREIGN KEY (serialNumber) REFERENCES Thesis ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE GUCianProgressReport(
    sid INT ,
    no INT Default 0,
    date DATETIME,
    eval INT,
    state INT,
    thesisSerialNumber INT,
    supid INT,
    description varchar(500),
    PRIMARY KEY(sid,no),
    FOREIGN KEY (sid) REFERENCES GucianStudent ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (thesisSerialNumber) REFERENCES Thesis ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (supid) REFERENCES Supervisor ON DELETE no action ON UPDATE no action
);

CREATE TABLE NonGUCianProgressReport(
    sid INT ,
    no INT Default 0,
    date DATETIME,
    eval INT,
    state INT,
    thesisSerialNumber INT,
    supid INT,
    description varchar(500),
    PRIMARY KEY(sid,no),
    FOREIGN KEY (sid) REFERENCES NonGucianStudent ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (thesisSerialNumber) REFERENCES Thesis ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (supid) REFERENCES Supervisor ON DELETE no action ON UPDATE no action
);

CREATE TABLE Installment(
    date DATE ,
    paymentId INT ,
    amount Decimal (10,2),
    done Bit,
    PRIMARY KEY(date,paymentId),
    FOREIGN KEY (paymentId) REFERENCES Payment ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE NonGucianStudentPayForCourse(
    sid INT ,
    paymentNo INT ,
    cid INT ,
    PRIMARY KEY(sid,paymentNo,cid),
    FOREIGN KEY (sid) REFERENCES NonGucianStudent ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (paymentNo) REFERENCES Payment ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (cid) REFERENCES Course ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE NonGucianStudentTakeCourse(
    sid INT ,
    cid INT ,
    grade DECIMAL(3,2),
    PRIMARY KEY(sid,cid),
    FOREIGN KEY (sid) REFERENCES NonGucianStudent ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (cid) REFERENCES Course ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE GUCianStudentRegisterThesis( 
    sid INT ,
    supid INT,
    serial_no INT,
    PRIMARY KEY(sid,supid,serial_no),
    FOREIGN KEY (sid) REFERENCES GucianStudent ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (supid) REFERENCES Supervisor ON DELETE no action ON UPDATE no action,
    FOREIGN KEY (serial_no) REFERENCES Thesis ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE NonGUCianStudentRegisterThesis(
    sid INT ,
    supid INT ,
    serial_no INT,
    PRIMARY KEY(sid,supid,serial_no),
    FOREIGN KEY (sid) REFERENCES NonGucianStudent ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (supid) REFERENCES Supervisor ON DELETE no action ON UPDATE no action,
    FOREIGN KEY (serial_no) REFERENCES Thesis ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE ExaminerEvaluateDefense(
    date DATETIME ,
    serialNo INT ,
    examinerId INT ,
    comment VARCHAR(50), 
    PRIMARY KEY(date,serialNo,examinerId),
    FOREIGN KEY (serialNo , date) REFERENCES Defense ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (examinerId) REFERENCES Examiner ON DELETE CASCADE ON UPDATE CASCADE 
);

CREATE TABLE ThesisHasPublication(
    serialNo INT ,
    pubid INT  ,
    PRIMARY KEY(serialNo,pubid),
    FOREIGN KEY (serialNo) REFERENCES Thesis ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (pubid) REFERENCES Publication ON DELETE CASCADE ON UPDATE CASCADE
);
--USE master; ALTER DATABASE [Milestone2] SET SINGLE_USER WITH ROLLBACK IMMEDIATE; DROP DATABASE [Milestone2] ;--




