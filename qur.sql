CREATE TABLE college(
    college_id varchar(4) primary key,
    college_name text unique not null
);

create table department(
    dep_id varchar(4) primary key,
    dep_name text not null,
    college_id varchar(4) not null,
    foreign key (college_id) references college(college_id) on delete cascade
);


create table program(
    program_id varchar(4) primary key,
    program_name text unique not null,
    dep_id varchar(4) not null,
    foreign key (dep_id) references department(dep_id) on delete cascade
);

create table instructor(
    inst_id int primary key,
    fname varchar(20)  not null,
    sname varchar(20),
    tname varchar(20),
    lname varchar(20)not null,
    gender varchar(6) not null,
    nationality varchar(50) not null,
    cpr bigint unique not null
);


create table instructor_info(

    id serial primary key,
    inst_id INT UNIQUE NOT NULL ,
    email TEXT UNIQUE NOT NULL,
    phone1 BIGINT UNIQUE NOT NULL,
    phone2 BIGINT,
    flat int,
    building int not null,
    road int not null,
    block int not null,
    area varchar(20) not null,
    isactive bool not null default true,
    role varchar(10) not null,
    dep_id varchar(4) not null,
    FOREIGN KEY (inst_id) REFERENCES instructor(inst_id) on delete cascade,
    FOREIGN KEY (dep_id) REFERENCES department(dep_id) on delete restrict
);



CREATE TABLE student(
    student_id INT PRIMARY KEY,
	username varchar(10),
    fname varchar(20)  not null,
    sname varchar(20) not null,
    tname varchar(20) not null,
    lname varchar(20) not null,
    gender varchar(6) not null,
    nationality varchar(50) not null,
    cpr bigint unique not null
);



CREATE TABLE student_info(
    id serial primary key,
    student_id INT UNIQUE NOT NULL,
    program_id varchar(4) not null,
    email TEXT UNIQUE NOT NULL,
    phone1 BIGINT UNIQUE NOT NULL,
    phone2 BIGINT,
    flat int,
    building int not null,
    road int not null,
    block int not null,
    area varchar(20) not null,
    isactive bool not null default true,
    password text not null,
    role varchar(10) not null,
    FOREIGN KEY (student_id) REFERENCES student(student_id) on delete cascade ,
    foreign key (program_id) references program(program_id) on delete restrict
);





CREATE TABLE dean(
    id serial primary key,
    college_id varchar(4) not null,
    dean_id int not null,
    start_date text not null,
    end_date text default null,

    foreign key (college_id)  references college(college_id) on delete cascade,
    foreign key (dean_id) references instructor(inst_id) on delete cascade
);


create table chair(
    id serial primary key,
    dep_id varchar(4) not null,
    chair_id int not null,
    start_date text not null,
    end_date text default null,
    foreign key (dep_id) references department(dep_id) on delete cascade,
    foreign key (chair_id) references instructor(inst_id) on delete cascade
);



create table course(
    course_id varchar(8) primary key,
    credit int default 3,
    minimum_credit_req int default null,
    name text unique not null,
    dep_id varchar(4) not null,
    type varchar(20) not null,
    isactive bool default true,
    hasexam bool default true,
    level int not null,
    foreign key (dep_id) references department(dep_id) on delete cascade
);

create table pre_req(
    id serial primary key,
    course_id varchar(8) not null,
    pre_req_id varchar(8) default null,

    foreign key (course_id) references course(course_id) on delete cascade,
    foreign key (pre_req_id) references course(course_id) on delete restrict
);



create table curriculum(
    id serial primary key,
    course_id varchar(8) not null,
    year int not null,
    semester int not null,
    program_id varchar(4) not null,

    foreign key (course_id) references course(course_id) on delete cascade,
    foreign key (program_id) references program(program_id) on delete cascade
);


create table semester(
    semester_id serial primary key,
    semester_name text unique not null ,
    start_date text unique not null ,
    end_date text unique not null,
    isActive bool default false,
	registration_open bool default false
);



create table room(
    room_id serial primary key,
    room_capacity int not null,
    type varchar(40) not null
);





create table offered_course(
    offer_id serial primary key,
    semester_id int not null,
    course_id varchar(8) not null,
    inst_id int not null,
    room_id int not null,
    section_no int not null,
    foreign key  (semester_id) references semester(semester_id) on delete cascade,
    foreign key (course_id) references course(course_id) on delete cascade,
    foreign key (inst_id) references instructor(inst_id) on delete restrict,
    foreign key (room_id) references room(room_id) on delete restrict
);


create table offer_times(
    id serial primary key,
    day char not null,
    offer_id int not null,
    start_time Text not null,
    end_time Text not null,

    foreign key (offer_id) references offered_course(offer_id) on delete cascade

);

create table registration(
    id serial primary key,
    student_id int not null,
    semester_id int not null,
    offer_id int not null,

    foreign key  (student_id) references student(student_id) on delete cascade,
    foreign key  (semester_id) references semester(semester_id) on delete restrict,
    foreign key  (offer_id) references offered_course(offer_id) on delete cascade
);

create table grades(
    id serial primary key,
    registration_id int not null,
    grade int not null,


    foreign key (registration_id) references registration(id)
);



CREATE TABLE examted(
    id serial primary key,
    student_id int not null,
    course_id varchar(8) not null,
    actual_grade varchar(2) not null,
	FOREIGN KEY (course_id) references course(course_id),
	FOREIGN KEY (student_id) references student(student_id)
);
insert into college values ('ART', 'COLLEGE OF ARTS & SCIENCE');

insert into college values ('ENG', 'COLLEGE OF ENGINEERING');


insert into college values ('IT', 'COLLEGE OF INFORMATION AND TECHNOLOGY');


insert into department (dep_id, dep_name, college_id)
values ('ITMS', 'Multimedia Science Department', 'IT');


insert into department (dep_id, dep_name, college_id)
values ('ITCS', 'Information Technology Department', 'IT');



insert into department (dep_id, dep_name, college_id)
values ('SCI', 'Mathematical Sciences, Languages and General Studies Dept', 'ART');

insert into department values ('ETE', 'Telecommunications Engineering Department', 'ENG');


insert into course (course_id, credit, minimum_credit_req, name, dep_id, type, isactive, hasexam, level)
values
('ITCS 101', 3, 0, 'Introduction to Computers & IT', 'ITCS', 'Core', true, true, 1);


insert into course (course_id, credit, minimum_credit_req, name, dep_id, type, isactive, hasexam, level) values ('ITCS 122', 3, 0, 'Introduction to Programming Techniques', 'ITCS', 'core', true, true, 1);

insert into course values ('ITCS 201', 3, 0, 'Object-Oriented Programming I', 'ITCS', 'core', true, true, 2);
insert into course values ('ITCS 209', 3, 0, 'Discrete Structures', 'ITCS', 'core', true, true, 2);
insert into course values ('ITMS 205', 3, 0, 'Internet Applications and Services', 'ITMS', 'core', true, true, 2);
insert into course values ('ITCS 221', 3, 0, 'Object-Oriented Programming II', 'ITCS', 'core', true, true, 1);
insert into course values ('ITCS 214', 3, 0, 'Computer Systems', 'ITCS', 'core', true, true, 2);

insert into course values ('ITCS 222', 3, 0, 'Visual Programming', 'ITCS', 'core', true, true, 2);
insert into course values ('ITCS 224', 3, 0, 'Data Structures', 'ITCS', 'core', true, true, 2);
insert into course values ('ITCS 341', 3, 0, 'System Administration I', 'ITCS', 'major elective', true, true, 3);
insert into course values ('ITCS 313', 3, 0, 'Software Engineering I', 'ITCS', 'core', true, true, 3);
insert into course values ('ITCS 323', 3, 0, 'Database Systems: Design and Application', 'ITCS', 'core', true, true, 3);
insert into course values ('ITMS 302', 3, 0, 'Human Computer Interaction', 'ITMS', 'core', true, true, 3);
insert into course values ('ITCS 327', 3, 0, 'Software Engineering II', 'ITCS', 'core', true, true, 3);
insert into course values ('ITCS 336', 3, 0, 'Database Administration I', 'ITCS', 'core', true, true, 3);
insert into course values ('ITCS 335', 3, 0, 'IT Infrastructure', 'ITCS', 'major elective', true, true, 3);
insert into course values ('INTR 463', 3, 90, 'BSIT Internship', 'ITCS', 'core', true, true, 4);
insert into course values ('ITCS 404', 3, 0, 'Information Security Engineering', 'ITCS', 'core', true, true, 4);
insert into course values ('ITCS 409', 3, 0, 'Operating Systems', 'ITCS', 'core', true, true, 4);
insert into course values ('ITCS 441', 3, 0, 'System Administration II', 'ITCS', 'Major elective', true, true, 4);
insert into course values ('ITCS 425', 3, 0, 'Web Engineering', 'ITCS', 'core', true, true, 4);
insert into course values ('ITCS 422', 3, 0, 'Distributed Systems', 'ITCS', 'core', true, true, 4);
insert into course values ('ITCS 427', 3, 0, 'Mobile Computing', 'ITCS', 'core', true, true, 4);




insert into course values ('ARAB 101', 3, 0, 'Composition for Native Speakers of Arabic I', 'SCI', 'free', true, true, 1);
insert into course values ('ENGL 101', 3, 0, 'Academic English I', 'SCI', 'free', true, true, 1);
insert into course values ('ENGL 102', 3, 0, 'Academic English II', 'SCI', 'free', true, true, 1);
insert into course values ('ENGL 201', 3, 0, 'Academic English III', 'SCI', 'free', true, true, 2);
insert into course values ('ENGL 202', 3, 0, 'Academic English IV', 'SCI', 'free', true, true, 2);
insert into course values ('MATH 101', 3, 0, 'Calculus I', 'SCI', 'free', true, true, 1);
insert into course values ('MATH 102', 3, 0, 'Calculus II', 'SCI', 'free', true, true, 1);
insert into course values ('MATH 202', 3, 0, 'Calculus III', 'SCI', 'free', true, true, 2);
insert into course values ('HUMR 101', 3, 0, 'Principles of Human Rights', 'SCI', 'free', true, true, 1);
insert into course values ('PHYS 101', 3, 0, 'General Physics I', 'SCI', 'core', true, true, 1);
insert into course values ('HIST 121', 3, 0, 'Modern History of Bahrain', 'SCI', 'free', true, true, 1);
insert into course values ('STAT 101', 3, 0, 'Introduction to Statistics', 'SCI', 'core', true, true, 1);
insert into course values ('CULT 102', 3, 0, 'Humanities/ Social Sciences', 'SCI', 'free', true, true, 1);
insert into course values ('ETHC 392', 3, 60, 'Ethics and Professional Practice in IT and Engineering', 'SCI', 'core', true, true, 3);
insert into course values ('ECTE 329', 3, 0, 'Computer Networks', 'SCI', 'core', true, true, 3);
insert into course values ('IERM 498', 3, 0, 'Research Methods in Information Technology & Engineering', 'ITCS', 'core', true, true, 4);
insert into course values ('ITMA 401', 3, 0, 'E-Commerce', 'ITCS', 'core', true, true, 4);
insert into course values ('ECTE 421', 3, 0, 'NETWORK DESIGN & SECURITY', 'ETE', 'core', true, true, 4);
insert into course values ('ITCS 442', 3, 0, 'VIRTUALIZATION', 'ITCS', 'major', true, true, 4);


INSERT INTO course (course_id, credit, minimum_credit_req, name, dep_id, type, isactive, hasexam, level) VALUES('MATH 201', 3, 0, 'Discrete Mathematics', 'SCI', 'core', true, true, 2);

INSERT INTO course (course_id, credit, minimum_credit_req, name, dep_id, type, isactive, hasexam, level) VALUES
('ITCS 401', 3, 0, 'Software Project Management', 'ITCS', 'core', true, true, 4);


INSERT INTO course (course_id, credit, minimum_credit_req, name, dep_id, type, isactive, hasexam, level) VALUES
('FREN 101', 3, 0, 'French Language', 'SCI', 'free', true, true, 1);

INSERT INTO course (course_id, credit, minimum_credit_req, name, dep_id, type, isactive, hasexam, level) VALUES
('GERM 101', 3, 0, 'German Language', 'SCI', 'free', true, true, 1);
INSERT INTO program (program_id, program_name, dep_id) VALUES
('BSIT', 'BACHELOR DEGREE IN INFORMATION TECHNOLOGY', 'ITCS');
INSERT INTO curriculum (course_id, year, semester, program_id) VALUES ('STAT 101', 1, 2, 'BSIT');
INSERT INTO curriculum (course_id, year, semester, program_id) VALUES ('PHYS 101', 1, 1, 'BSIT');
INSERT INTO curriculum (course_id, year, semester, program_id) VALUES ('MATH 202', 2, 1, 'BSIT');
INSERT INTO curriculum (course_id, year, semester, program_id) VALUES ('MATH 102', 1, 2, 'BSIT');
INSERT INTO curriculum (course_id, year, semester, program_id) VALUES ('MATH 101', 1, 1, 'BSIT');
INSERT INTO curriculum (course_id, year, semester, program_id) VALUES ('ITMS 302', 3, 1, 'BSIT');
INSERT INTO curriculum (course_id, year, semester, program_id) VALUES ('ITMS 205', 2, 1, 'BSIT');
INSERT INTO curriculum (course_id, year, semester, program_id) VALUES ('ITMA 401', 4, 1, 'BSIT');
INSERT INTO curriculum (course_id, year, semester, program_id) VALUES ('ITCS 442',4 ,2 , 'BSIT');
INSERT INTO curriculum (course_id, year, semester, program_id) VALUES ('ITCS 441',4 ,1 , 'BSIT');
INSERT INTO curriculum (course_id, year, semester, program_id) VALUES ('ITCS 427', 4, 2, 'BSIT');
INSERT INTO curriculum (course_id, year, semester, program_id) VALUES ('ITCS 425', 4, 2, 'BSIT');
INSERT INTO curriculum (course_id, year, semester, program_id) VALUES ('ITCS 422', 4, 2, 'BSIT');
INSERT INTO curriculum (course_id, year, semester, program_id) VALUES ('ITCS 409', 4, 1, 'BSIT');
INSERT INTO curriculum (course_id, year, semester, program_id) VALUES ('ITCS 404', 4, 1, 'BSIT');
INSERT INTO curriculum (course_id, year, semester, program_id) VALUES ('ITCS 341',3 ,1 , 'BSIT');
INSERT INTO curriculum (course_id, year, semester, program_id) VALUES ('ITCS 336', 3, 2, 'BSIT');
INSERT INTO curriculum (course_id, year, semester, program_id) VALUES ('ITCS 335', 3, 2, 'BSIT');
INSERT INTO curriculum (course_id, year, semester, program_id) VALUES ('ITCS 327', 3, 2, 'BSIT');
INSERT INTO curriculum (course_id, year, semester, program_id) VALUES ('ITCS 323', 3, 1, 'BSIT');
INSERT INTO curriculum (course_id, year, semester, program_id) VALUES ('ITCS 313', 3, 1, 'BSIT');
INSERT INTO curriculum (course_id, year, semester, program_id) VALUES ('ITCS 224', 2, 2, 'BSIT');
INSERT INTO curriculum (course_id, year, semester, program_id) VALUES ('ITCS 222', 2, 2, 'BSIT');
INSERT INTO curriculum (course_id, year, semester, program_id) VALUES ('ITCS 221', 2, 2, 'BSIT');
INSERT INTO curriculum (course_id, year, semester, program_id) VALUES ('ITCS 214', 2, 2, 'BSIT');
INSERT INTO curriculum (course_id, year, semester, program_id) VALUES ('ITCS 209', 2, 1, 'BSIT');
INSERT INTO curriculum (course_id, year, semester, program_id) VALUES ('ITCS 201', 2, 1, 'BSIT');
INSERT INTO curriculum (course_id, year, semester, program_id) VALUES ('ITCS 122', 1, 2, 'BSIT');
INSERT INTO curriculum (course_id, year, semester, program_id) VALUES ('ITCS 101', 1, 1, 'BSIT');
INSERT INTO curriculum (course_id, year, semester, program_id) VALUES ('INTR 463', 3, 3, 'BSIT');
INSERT INTO curriculum (course_id, year, semester, program_id) VALUES ('IERM 498', 4, 1, 'BSIT');
INSERT INTO curriculum (course_id, year, semester, program_id) VALUES ('HUMR 101', 1, 1, 'BSIT');
INSERT INTO curriculum (course_id, year, semester, program_id) VALUES ('HIST 121', 1, 2, 'BSIT');
INSERT INTO curriculum (course_id, year, semester, program_id) VALUES ('ETHC 392', 3, 2, 'BSIT');
INSERT INTO curriculum (course_id, year, semester, program_id) VALUES ('ENGL 202', 2, 2, 'BSIT');
INSERT INTO curriculum (course_id, year, semester, program_id) VALUES ('ENGL 201', 2, 1, 'BSIT');
INSERT INTO curriculum (course_id, year, semester, program_id) VALUES ('ENGL 102', 1, 2, 'BSIT');
INSERT INTO curriculum (course_id, year, semester, program_id) VALUES ('ENGL 101', 1, 1, 'BSIT');
INSERT INTO curriculum (course_id, year, semester, program_id) VALUES ('ECTE 421', 4, 2, 'BSIT');
INSERT INTO curriculum (course_id, year, semester, program_id) VALUES ('ECTE 329', 3, 2, 'BSIT');
INSERT INTO curriculum (course_id, year, semester, program_id) VALUES ('CULT 102', 3, 1, 'BSIT');
INSERT INTO curriculum (course_id, year, semester, program_id) VALUES ('ARAB 101', 1, 1, 'BSIT');
INSERT INTO curriculum (course_id, year, semester, program_id) VALUES ('ITCS 401', 4, 1, 'BSIT');
insert into pre_req (course_id, pre_req_id) values ('STAT 101' , null);
insert into pre_req (course_id, pre_req_id) values ('PHYS 101' , null);
insert into pre_req (course_id, pre_req_id) values ('MATH 202' , 'MATH 102');
insert into pre_req (course_id, pre_req_id) values ('MATH 102' , 'MATH 101');
insert into pre_req (course_id, pre_req_id) values ('MATH 101' , null);
insert into pre_req (course_id, pre_req_id) values ('ITMS 302' , 'ITCS 122');
insert into pre_req (course_id, pre_req_id) values ('ITMS 205' , 'ITCS 101');
insert into pre_req (course_id, pre_req_id) values ('ITMA 401' , 'ITCS 101');
insert into pre_req (course_id, pre_req_id) values ('ITCS 442' , 'ITCS 335');
insert into pre_req (course_id, pre_req_id) values ('ITCS 441' , 'ITCS 341');
insert into pre_req (course_id, pre_req_id) values ('ITCS 427' , 'ITCS 221');
insert into pre_req (course_id, pre_req_id) values ('ITCS 425' , 'ITMS 205');
insert into pre_req (course_id, pre_req_id) values ('ITCS 425' , 'ITCS 327');
insert into pre_req (course_id, pre_req_id) values ('ITCS 422' , 'ITCS 409');
insert into pre_req (course_id, pre_req_id) values ('ITCS 409' , 'ITCS 214');
insert into pre_req (course_id, pre_req_id) values ('ITCS 404' , 'ITCS 327');
insert into pre_req (course_id, pre_req_id) values ('ITCS 341' , 'ITCS 214');
insert into pre_req (course_id, pre_req_id) values ('ITCS 336' , 'ITCS 323');
insert into pre_req (course_id, pre_req_id) values ('ITCS 335' , 'ITCS 214');
insert into pre_req (course_id, pre_req_id) values ('ITCS 327' , 'ITCS 313');
insert into pre_req (course_id, pre_req_id) values ('ITCS 323' , 'ITCS 222');
insert into pre_req (course_id, pre_req_id) values ('ITCS 313' , 'ITCS 201');
insert into pre_req (course_id, pre_req_id) values ('ITCS 224' , 'ITCS 201');
insert into pre_req (course_id, pre_req_id) values ('ITCS 222' , 'ITCS 122');
insert into pre_req (course_id, pre_req_id) values ('ITCS 221' , 'ITCS 201');
insert into pre_req (course_id, pre_req_id) values ('ITCS 214' , 'ITCS 101');
insert into pre_req (course_id, pre_req_id) values ('ITCS 209' , 'MATH 102');
insert into pre_req (course_id, pre_req_id) values ('ITCS 201' , 'ITCS 122');
insert into pre_req (course_id, pre_req_id) values ('ITCS 122' , 'ITCS 101');
insert into pre_req (course_id, pre_req_id) values ('ITCS 101' , null);
insert into pre_req (course_id, pre_req_id) values ('INTR 463' , null);
insert into pre_req (course_id, pre_req_id) values ('IERM 498' , null);
insert into pre_req (course_id, pre_req_id) values ('HUMR 101' , null);
insert into pre_req (course_id, pre_req_id) values ('HIST 121' , null);
insert into pre_req (course_id, pre_req_id) values ('ETHC 392' , null);
insert into pre_req (course_id, pre_req_id) values ('ENGL 202' , 'ENGL 201');
insert into pre_req (course_id, pre_req_id) values ('ENGL 201' , 'ENGL 102');
insert into pre_req (course_id, pre_req_id) values ('ENGL 102' , 'ENGL 101');
insert into pre_req (course_id, pre_req_id) values ('ENGL 101' , null);
insert into pre_req (course_id, pre_req_id) values ('ECTE 421' , 'ECTE 329');
insert into pre_req (course_id, pre_req_id) values ('ECTE 329' , 'ITCS 214');
insert into pre_req (course_id, pre_req_id) values ('CULT 102' , null);
insert into pre_req (course_id, pre_req_id) values ('ARAB 101' , null);
INSERT INTO pre_req (course_id, pre_req_id) VALUES ('MATH 201', 'MATH 101');
insert into pre_req (course_id, pre_req_id) values ('ITCS 401', 'ITCS 327');
insert into instructor values (1, 'Wasan', 'Shakir', 'Awad', 'Humood', 'Female', 'Iraq', 123456789);
insert into instructor values (2, 'Sohail', null, null, 'Safdar', 'Male', 'Pakistan', 987654321);
insert into instructor values (3, 'Suresh', null, null, 'Subramanian', 'Male', 'India', 333333333);
insert into instructor values (4, 'Baraa', 'Tariq', 'Sharef', 'Al-Alawsh', 'Male', 'Iraq', 123456781);
insert into instructor values (5, 'Hasan', 'Ali', null, 'Razzaqi', 'Male', 'Bahrain', 123456782);
insert into instructor values (6, 'Subhashini', null, null, 'Bhaskaran', 'Female', 'India', 987654323);
insert into instructor values (7, 'Jenan', 'Moosa', 'Abdulnabi', 'Hasan', 'Female', 'Bahrain', 654321124);
insert into instructor values (8, 'Khadija', 'Atyea', 'Jafar', 'Almohsen', 'Female', 'Bahrain', 741852965);
insert into instructor values (9, 'Sara', 'Ebrahim', 'Ali', 'Alaswad', 'Female', 'Bahrain', 321456326);
insert into instructor values (10, 'Mohamed', 'Hasan', 'Mohamed', 'Hasan', 'Male', 'Bahrain', 999666337);
insert into instructor values (11, 'Rafeeqa', 'Abdulla', 'Bin', 'Rajab', 'Female', 'Bahrain', 123456788);
insert into instructor values (12, 'Majeed', 'Abdulnabi', 'Ali', 'Amini', 'Male', 'Bahrain', 9876543299);
insert into instructor values (13, 'Mohamed', 'Yousef', 'A.R.', 'Al-Shoqran', 'Male', 'Jordan', 987654345);
insert into instructor values (14, 'Ayman', 'Ahmed', null, 'Alaiwi', 'Male', 'Bahrain', 987541474);







insert into instructor_info (inst_id, email, phone1, building, road, block, area, role, dep_id) values(1,'wasan@ahlia.com',36612323,1,2,3,'4','dean','ITCS');
insert into instructor_info (inst_id, email, phone1, building, road, block, area, role, dep_id) values(2,'sohail@ahlia.com',33221144,1,2,3,'4','chair','ITCS');
insert into instructor_info (inst_id, email, phone1, building, road, block, area, role, dep_id) values(3,'suresh@ahlia.com',66443322,9,8,452,'Hoora','chair','ITMS');
insert into instructor_info (inst_id, email, phone1, building, road, block, area, role, dep_id) values(4,'baraa@ahlia.com',123456789,98,78,666,'Juffair','instructor','ITCS');
insert into instructor_info (inst_id, email, phone1, building, road, block, area, role, dep_id) values(5,'razzaqi@ahlia.com',66225544,123,456,789,'Tubli','instructor','ITMS');
insert into instructor_info (inst_id, email, phone1, building, road, block, area, role, dep_id) values(6,'subha@ahlia.com',39852123,14,12,333,'Muharraq','instructor','ITCS');
insert into instructor_info (inst_id, email, phone1, building, road, block, area, role, dep_id) values(7,'jenan@ahlia.com',36612541,1,2,3,'Isa Town','instructor','ITCS');
insert into instructor_info (inst_id, email, phone1, building, road, block, area, role, dep_id) values(8,'k@ahlia.com',39237179,7,41,335,'Muharraq','instructor','ITCS');
insert into instructor_info (inst_id, email, phone1, building, road, block, area, role, dep_id) values(9,'sara@ahlia.com',36612415,991,1227,512,'Budaiya','instructor','ITMS');
insert into instructor_info (inst_id, email, phone1, building, road, block, area, role, dep_id) values(10,'mhasan@ahlia.com',51234587,4,2,224,'Muharraq','instructor','SCI');
insert into instructor_info (inst_id, email, phone1, building, road, block, area, role, dep_id) values(11,'rafeeqa@ahlia.com',85412365,784,123,654,'Manama','instructor','SCI');
insert into instructor_info (inst_id, email, phone1, building, road, block, area, role, dep_id) values(12,'majeed@ahlia.com',33224288,4,5,6,'Bilad Qadeem','instructor','SCI');
insert into instructor_info (inst_id, email, phone1, building, road, block, area, role, dep_id) values(13,'shoqran@ahlia.com',32141233,44,55,123,'Hidd','instructor','SCI');
insert into instructor_info (inst_id, email, phone1, building, road, block, area, role, dep_id) values(14,'ayman@ahlia.edu.bh',41234544,3,22,124,'Hoora','instructor','ETE');
insert into room (room_capacity, type) values (20, 'Lab');
insert into room (room_capacity, type) values (15, 'Lab');
insert into room (room_capacity, type) values (15, 'Lab');
insert into room (room_capacity, type) values (20, 'Lab');
insert into room (room_capacity, type) values (20, 'Lab');
insert into room (room_capacity, type) values (20, 'Lab');
insert into room (room_capacity, type) values (30, 'Hall');
insert into room (room_capacity, type) values (35, 'Hall');
insert into room (room_capacity, type) values (35, 'Hall');
insert into room (room_capacity, type) values (20, 'Hall');
insert into room (room_capacity, type) values (20, 'Hall');
insert into room (room_capacity, type) values (35, 'Hall');
insert into room (room_capacity, type) values (25, 'Hall');
insert into dean (college_id, dean_id, start_date, end_date) VALUES
('IT',1,'2015-07-23', Null);

insert into chair (dep_id, chair_id, start_date, end_date) VALUES
('ITCS', 2, '2017-01-05', Null);


insert into chair (dep_id, chair_id, start_date, end_date) VALUES
('ITMS', 3, '2017-01-05', Null);



insert into semester (semester_name, start_date, end_date, isactive) values ('2019/2020 First', '9/1/2019', '1/11/2020', false);
insert into semester (semester_name, start_date, end_date, isactive) values ('2019/2020 Second', '1/19/2020', '5/23/2020', false);
insert into semester (semester_name, start_date, end_date, isactive) values ('2019/2020 Summer', '5/24/2020', '7/25/2020', false);
insert into semester (semester_name, start_date, end_date, isactive) values ('2020/2021 First', '8/30/2020', '1/9/2021', false);
insert into semester (semester_name, start_date, end_date, isactive) values ('2020/2021 Second', '1/14/2021', '5/12/2021', false);
insert into semester (semester_name, start_date, end_date, isactive) values ('2020/2021 Summer', '5/23/2021', '7/24/2021', true);
insert into semester (semester_name, start_date, end_date, isactive, registration_open) values ('2021/2022 First', '8/29/2021', '1/11/2022', false, true);
insert into semester (semester_name, start_date, end_date, isactive) values ('2021/2022 Second', '1/16/2022', '5/26/2022', true);


ALTER SEQUENCE offered_course_offer_id_seq RESTART WITH 2;

insert into offered_course (semester_id, course_id, inst_id, room_id, section_no) VALUES (1, 'ENGL 201', 10, 13, 1);
insert into offered_course (semester_id, course_id, inst_id, room_id, section_no) VALUES (1, 'ITCS 122', 7, 4, 1);
insert into offered_course (semester_id, course_id, inst_id, room_id, section_no) VALUES (1, 'MATH 202', 12, 8, 1);
insert into offered_course (semester_id, course_id, inst_id, room_id, section_no) VALUES (1, 'PHYS 101', 12, 13, 1);
insert into offered_course (semester_id, course_id, inst_id, room_id, section_no) VALUES (1, 'STAT 101', 13, 6, 1);
insert into offered_course (semester_id, course_id, inst_id, room_id, section_no) VALUES (2, 'ENGL 202', 10, 9, 1);
insert into offered_course (semester_id, course_id, inst_id, room_id, section_no) VALUES (2, 'ITCS 201', 7, 4, 1);
insert into offered_course (semester_id, course_id, inst_id, room_id, section_no) VALUES (2, 'ITCS 214', 1, 7, 1);
insert into offered_course (semester_id, course_id, inst_id, room_id, section_no) VALUES (2, 'ITCS 222', 8, 1, 1);
insert into offered_course (semester_id, course_id, inst_id, room_id, section_no) VALUES (2, 'ITMS 205', 9, 2, 1);
insert into offered_course (semester_id, course_id, inst_id, room_id, section_no) VALUES (3, 'ITCS 221', 3, 3, 1);
insert into offered_course (semester_id, course_id, inst_id, room_id, section_no) VALUES (3, 'ITMA 401', 6, 6, 1);
insert into offered_course (semester_id, course_id, inst_id, room_id, section_no) VALUES (3, 'MATH 201', 12, 9, 1);
insert into offered_course (semester_id, course_id, inst_id, room_id, section_no) VALUES (4, 'ETHC 392', 1, 8, 1);
insert into offered_course (semester_id, course_id, inst_id, room_id, section_no) VALUES (4, 'ITCS 224', 9, 2, 1);
insert into offered_course (semester_id, course_id, inst_id, room_id, section_no) VALUES (4, 'ITCS 313', 2, 5, 1);
insert into offered_course (semester_id, course_id, inst_id, room_id, section_no) VALUES (4, 'ITCS 323', 3, 3, 1);
insert into offered_course (semester_id, course_id, inst_id, room_id, section_no) VALUES (4, 'ITCS 409', 4, 4, 1);
insert into offered_course (semester_id, course_id, inst_id, room_id, section_no) VALUES (4, 'ITMS 302', 4, 4, 1);
insert into offered_course (semester_id, course_id, inst_id, room_id, section_no) VALUES (5, 'ECTE 329', 14, 5, 1);
insert into offered_course (semester_id, course_id, inst_id, room_id, section_no) VALUES (5, 'ITCS 327', 2, 2, 1);
insert into offered_course (semester_id, course_id, inst_id, room_id, section_no) VALUES (5, 'ITCS 336', 3, 3, 1);
insert into offered_course (semester_id, course_id, inst_id, room_id, section_no) VALUES (5, 'ITCS 341', 4, 3, 1);
insert into offered_course (semester_id, course_id, inst_id, room_id, section_no) VALUES (5, 'ITCS 422', 6, 4, 1);
insert into offered_course (semester_id, course_id, inst_id, room_id, section_no) VALUES (6, 'ECTE 421', 14, 5, 1);
insert into offered_course (semester_id, course_id, inst_id, room_id, section_no) VALUES (6, 'IERM 498', 5, 9, 1);
insert into offered_course (semester_id, course_id, inst_id, room_id, section_no) VALUES (6, 'INTR 463', 3, 1, 1);



insert into offered_course (semester_id, course_id, inst_id, room_id, section_no) values(7, 'ITCS 101',8, 2, 1);
insert into offered_course (semester_id, course_id, inst_id, room_id, section_no) values(7, 'ITCS 122',7, 5, 1);
insert into offered_course (semester_id, course_id, inst_id, room_id, section_no) values(7, 'ITCS 201',7, 5, 1);
insert into offered_course (semester_id, course_id, inst_id, room_id, section_no) values(7, 'ITCS 209',12, 7, 1);
insert into offered_course (semester_id, course_id, inst_id, room_id, section_no) values(7, 'ITMS 205',9, 1, 1);
insert into offered_course (semester_id, course_id, inst_id, room_id, section_no) values(7, 'ITCS 221',3, 3, 1);
insert into offered_course (semester_id, course_id, inst_id, room_id, section_no) values(7, 'ITCS 214',1, 10, 1);
insert into offered_course (semester_id, course_id, inst_id, room_id, section_no) values(7, 'ITCS 222',8, 2, 1);
insert into offered_course (semester_id, course_id, inst_id, room_id, section_no) values(7, 'ITCS 224',9, 2, 1);
insert into offered_course (semester_id, course_id, inst_id, room_id, section_no) values(7, 'ITCS 341',4, 3, 1);
insert into offered_course (semester_id, course_id, inst_id, room_id, section_no) values(7, 'ITCS 313',2, 2, 1);
insert into offered_course (semester_id, course_id, inst_id, room_id, section_no) values(7, 'ITCS 323',3, 2, 1);
insert into offered_course (semester_id, course_id, inst_id, room_id, section_no) values(7, 'ITMS 302',5, 1, 1);
insert into offered_course (semester_id, course_id, inst_id, room_id, section_no) values(7, 'ITCS 327',2, 12, 1);
insert into offered_course (semester_id, course_id, inst_id, room_id, section_no) values(7, 'ITCS 336',3, 4, 1);
insert into offered_course (semester_id, course_id, inst_id, room_id, section_no) values(7, 'ITCS 335',4, 1, 1);
insert into offered_course (semester_id, course_id, inst_id, room_id, section_no) values(7, 'ITCS 409',4, 11, 1);
insert into offered_course (semester_id, course_id, inst_id, room_id, section_no) values(7, 'ITCS 422',6, 4, 1);
insert into offered_course (semester_id, course_id, inst_id, room_id, section_no) values(7, 'ITCS 427',3, 4, 1);
insert into offered_course (semester_id, course_id, inst_id, room_id, section_no) values(7, 'ARAB 101',11, 9, 1);
insert into offered_course (semester_id, course_id, inst_id, room_id, section_no) values(7, 'ENGL 101',10, 10, 1);
insert into offered_course (semester_id, course_id, inst_id, room_id, section_no) values(7, 'ENGL 102',10, 11, 1);
insert into offered_course (semester_id, course_id, inst_id, room_id, section_no) values(7, 'ENGL 201',10, 12, 1);
insert into offered_course (semester_id, course_id, inst_id, room_id, section_no) values(7, 'ENGL 202',10, 13, 1);
insert into offered_course (semester_id, course_id, inst_id, room_id, section_no) values(7, 'MATH 101',12, 13, 1);
insert into offered_course (semester_id, course_id, inst_id, room_id, section_no) values(7, 'MATH 102',12, 12, 1);
insert into offered_course (semester_id, course_id, inst_id, room_id, section_no) values(7, 'MATH 202',13, 11, 1);
insert into offered_course (semester_id, course_id, inst_id, room_id, section_no) values(7, 'HUMR 101',11, 7, 1);
insert into offered_course (semester_id, course_id, inst_id, room_id, section_no) values(7, 'PHYS 101',12, 8, 1);
insert into offered_course (semester_id, course_id, inst_id, room_id, section_no) values(7, 'HIST 121',11, 7, 1);
insert into offered_course (semester_id, course_id, inst_id, room_id, section_no) values(7, 'STAT 101',13, 12, 1);
insert into offered_course (semester_id, course_id, inst_id, room_id, section_no) values(7, 'CULT 102',11, 11, 1);
insert into offered_course (semester_id, course_id, inst_id, room_id, section_no) values(7, 'ETHC 392',1, 7, 1);
insert into offered_course (semester_id, course_id, inst_id, room_id, section_no) values(7, 'ECTE 329',14, 13, 1);
insert into offered_course (semester_id, course_id, inst_id, room_id, section_no) values(7, 'IERM 498',6, 7, 1);
insert into offered_course (semester_id, course_id, inst_id, room_id, section_no) values(7, 'ITMA 401',5, 5, 1);
insert into offered_course (semester_id, course_id, inst_id, room_id, section_no) values(7, 'ECTE 421',14, 13, 1);
insert into offered_course (semester_id, course_id, inst_id, room_id, section_no) values(7, 'MATH 201',12, 12, 1);
insert into offered_course (semester_id, course_id, inst_id, room_id, section_no) values(7, 'ITCS 401',2, 9, 1);
insert into offered_course (semester_id, course_id, inst_id, room_id, section_no) VALUES (7, 'ITCS 441', 4, 4, 1);
insert into offered_course (semester_id, course_id, inst_id, room_id, section_no) VALUES (7, 'ITCS 425', 2, 3, 1);
insert into offered_course (semester_id, course_id, inst_id, room_id, section_no) VALUES (7, 'ITCS 404', 1, 8, 1);
insert into offer_times (day, offer_id, start_time, end_time) values ('w', 2, '10:45', '12:00');
insert into offer_times (day, offer_id, start_time, end_time) values ('m', 2, '10:45', '12:00');

insert into offer_times (day, offer_id, start_time, end_time) values ('m', 3, '13:15', '14:55');
insert into offer_times (day, offer_id, start_time, end_time) values ('w', 3, '13:15', '14:55');

insert into offer_times (day, offer_id, start_time, end_time) values ('u', 4, '11:00', '11:50');
insert into offer_times (day, offer_id, start_time, end_time) values ('h', 4, '11:00', '11:50');
insert into offer_times (day, offer_id, start_time, end_time) values ('t', 4, '11:00', '11:50');

insert into offer_times (day, offer_id, start_time, end_time) values ('u', 5, '10:00', '10:50');
insert into offer_times (day, offer_id, start_time, end_time) values ('h', 5, '10:00', '10:50');
insert into offer_times (day, offer_id, start_time, end_time) values ('t', 5, '10:00', '10:50');

insert into offer_times (day, offer_id, start_time, end_time) values ('m', 6, '15:00', '16:15');
insert into offer_times (day, offer_id, start_time, end_time) values ('w', 6, '15:00', '16:15');

insert into offer_times (day, offer_id, start_time, end_time) values ('u', 7, '11:00', '11:50');
insert into offer_times (day, offer_id, start_time, end_time) values ('h', 7, '11:00', '11:50');

insert into offer_times (day, offer_id, start_time, end_time) values ('m', 8, '16:00', '17:40');
insert into offer_times (day, offer_id, start_time, end_time) values ('w', 8, '16:00', '17:40');

insert into offer_times (day, offer_id, start_time, end_time) values ('m', 9, '10:45', '12:00');
insert into offer_times (day, offer_id, start_time, end_time) values ('w', 9, '10:45', '12:00');

insert into offer_times (day, offer_id, start_time, end_time) values ('u', 10, '13:00', '14:40');
insert into offer_times (day, offer_id, start_time, end_time) values ('t', 10, '13:00', '14:40');

insert into offer_times (day, offer_id, start_time, end_time) values ('u', 11, '09:00', '10:40');
insert into offer_times (day, offer_id, start_time, end_time) values ('t', 11, '09:00', '10:40');

insert into offer_times (day, offer_id, start_time, end_time) values ('u', 12, '13:00','14:40');
insert into offer_times (day, offer_id, start_time, end_time) values ('t', 12, '13:00','14:40');
insert into offer_times (day, offer_id, start_time, end_time) values ('h', 12, '13:00','14:40');

insert into offer_times (day, offer_id, start_time, end_time) values ('m', 13, '15:00', '17:30');
insert into offer_times (day, offer_id, start_time, end_time) values ('w', 13, '15:00', '17:30');


insert into offer_times (day, offer_id, start_time, end_time) values ('u', 14, '11:00','12:40');
insert into offer_times (day, offer_id, start_time, end_time) values ('t', 14, '11:00','12:40');
insert into offer_times (day, offer_id, start_time, end_time) values ('h', 14, '11:00','12:40');

insert into offer_times (day, offer_id, start_time, end_time) values ('u', 15, '14:00', '14:50');
insert into offer_times (day, offer_id, start_time, end_time) values ('t', 15, '14:00', '14:50');
insert into offer_times (day, offer_id, start_time, end_time) values ('h', 15, '14:00', '14:50');

insert into offer_times (day, offer_id, start_time, end_time) values ('m', 16, '09:00', '10:40');
insert into offer_times (day, offer_id, start_time, end_time) values ('w', 16, '09:00', '10:40');

insert into offer_times (day, offer_id, start_time, end_time) values ('m', 17, '16:00', '17:40');
insert into offer_times (day, offer_id, start_time, end_time) values ('w', 17, '16:00', '17:40');

insert into offer_times (day, offer_id, start_time, end_time) values ('h', 18, '17:00', '18:40');
insert into offer_times (day, offer_id, start_time, end_time) values ('u', 18, '17:00', '18:40');

insert into offer_times (day, offer_id, start_time, end_time) values ('w', 19, '13:30', '14:45');
insert into offer_times (day, offer_id, start_time, end_time) values ('m', 19, '13:30', '14:45');

insert into offer_times (day, offer_id, start_time, end_time) values ('u', 20, '15:00', '16:40');
insert into offer_times (day, offer_id, start_time, end_time) values ('h', 20, '15:00', '16:40');

insert into offer_times (day, offer_id, start_time, end_time) values ('m', 21,'14:00','15:40');
insert into offer_times (day, offer_id, start_time, end_time) values ('w', 21,'14:00','15:40');

insert into offer_times (day, offer_id, start_time, end_time) values ('m', 22,'10:45','12:00');
insert into offer_times (day, offer_id, start_time, end_time) values ('w', 22,'10:45','12:00');

insert into offer_times (day, offer_id, start_time, end_time) values ('m', 23,'17:00','18:40');
insert into offer_times (day, offer_id, start_time, end_time) values ('w', 23,'17:00','18:40');

insert into offer_times (day, offer_id, start_time, end_time) values ('u', 24,'17:00','18:40');
insert into offer_times (day, offer_id, start_time, end_time) values ('t', 24,'17:00','18:40');

insert into offer_times (day, offer_id, start_time, end_time) values ('t', 25,'13:00','14:40');
insert into offer_times (day, offer_id, start_time, end_time) values ('h', 25,'13:00','14:40');

insert into offer_times (day, offer_id, start_time, end_time) values ('u', 26, '13:00', '14:40');
insert into offer_times (day, offer_id, start_time, end_time) values ('m', 26, '13:00', '14:40');
insert into offer_times (day, offer_id, start_time, end_time) values ('t', 26, '13:00', '14:40');
insert into offer_times (day, offer_id, start_time, end_time) values ('w', 26, '13:00', '14:40');

insert into offer_times (day, offer_id, start_time, end_time) values ('u', 27, '15:00', '16:40');
insert into offer_times (day, offer_id, start_time, end_time) values ('t', 27, '15:00', '16:40');


insert into offer_times (day, offer_id, start_time, end_time) values ('m', 29,'16:00', '17:40');
insert into offer_times (day, offer_id, start_time, end_time) values ('w', 29,'16:00', '17:40');

insert into offer_times (day, offer_id, start_time, end_time) values ('u', 30,'15:00', '16:40');
insert into offer_times (day, offer_id, start_time, end_time) values ('t', 30, '15:00', '16:40');

insert into offer_times (day, offer_id, start_time, end_time) values ('t', 31,'09:00', '10:40');
insert into offer_times (day, offer_id, start_time, end_time) values ('h', 31,'09:00', '10:40');

insert into offer_times (day, offer_id, start_time, end_time) values ('u', 32,'17:00', '18:40');
insert into offer_times (day, offer_id, start_time, end_time) values ('t', 32,'17:00', '18:40');

insert into offer_times (day, offer_id, start_time, end_time) values ('u', 33,'13:00', '14:40');
insert into offer_times (day, offer_id, start_time, end_time) values ('t', 33,'13:00', '14:40');

insert into offer_times (day, offer_id, start_time, end_time) values ('m', 34,'18:15', '19:55');
insert into offer_times (day, offer_id, start_time, end_time) values ('w', 34,'18:15', '19:55');





insert into offer_times (day, offer_id, start_time, end_time) values('u', 29,'9:00', '10:40');
insert into offer_times (day, offer_id, start_time, end_time) values('t', 29,'9:00', '10:40');
insert into offer_times (day, offer_id, start_time, end_time) values('m', 30,'9:00', '10:40');
insert into offer_times (day, offer_id, start_time, end_time) values('w', 30,'9:00', '10:40');
insert into offer_times (day, offer_id, start_time, end_time) values('u', 31,'9:00', '10:40');
insert into offer_times (day, offer_id, start_time, end_time) values('t', 31,'9:00', '10:40');
insert into offer_times (day, offer_id, start_time, end_time) values('u', 32,'11:00', '11:50');
insert into offer_times (day, offer_id, start_time, end_time) values('t', 32,'11:00', '11:50');
insert into offer_times (day, offer_id, start_time, end_time) values('h', 32,'11:00', '11:50');
insert into offer_times (day, offer_id, start_time, end_time) values('m', 33,'16:00', '17:40');
insert into offer_times (day, offer_id, start_time, end_time) values('w', 33,'16:00', '17:40');
insert into offer_times (day, offer_id, start_time, end_time) values('u', 34,'11:00', '12:40');
insert into offer_times (day, offer_id, start_time, end_time) values('t', 34,'11:00', '12:40');
insert into offer_times (day, offer_id, start_time, end_time) values('u', 35,'14:00', '14:50');
insert into offer_times (day, offer_id, start_time, end_time) values('t', 35,'14:00', '14:50');
insert into offer_times (day, offer_id, start_time, end_time) values('h', 35,'14:00', '14:50');
insert into offer_times (day, offer_id, start_time, end_time) values('m', 36,'9:00', '10:40');
insert into offer_times (day, offer_id, start_time, end_time) values('w', 36,'9:00', '10:40');
insert into offer_times (day, offer_id, start_time, end_time) values('u', 37,'9:00', '10:40');
insert into offer_times (day, offer_id, start_time, end_time) values('t', 37,'9:00', '10:40');
insert into offer_times (day, offer_id, start_time, end_time) values('m', 38,'19:00', '20:40');
insert into offer_times (day, offer_id, start_time, end_time) values('w', 38,'19:00', '20:40');
insert into offer_times (day, offer_id, start_time, end_time) values('m', 39,'14:00', '15:40');
insert into offer_times (day, offer_id, start_time, end_time) values('w', 39,'14:00', '15:40');
insert into offer_times (day, offer_id, start_time, end_time) values('u', 40,'11:00', '12:40');
insert into offer_times (day, offer_id, start_time, end_time) values('t', 40,'11:00', '12:40');
insert into offer_times (day, offer_id, start_time, end_time) values('u', 41,'15:00', '16:40');
insert into offer_times (day, offer_id, start_time, end_time) values('t', 41,'15:00', '16:40');
insert into offer_times (day, offer_id, start_time, end_time) values('u', 42,'16:00', '17:40');
insert into offer_times (day, offer_id, start_time, end_time) values('t', 42,'16:00', '17:40');
insert into offer_times (day, offer_id, start_time, end_time) values('m', 43,'9:00', '10:40');
insert into offer_times (day, offer_id, start_time, end_time) values('w', 43,'9:00', '10:40');
insert into offer_times (day, offer_id, start_time, end_time) values('m', 44,'16:00', '17:40');
insert into offer_times (day, offer_id, start_time, end_time) values('w', 44,'16:00', '17:40');
insert into offer_times (day, offer_id, start_time, end_time) values('u', 45,'11:00', '11:50');
insert into offer_times (day, offer_id, start_time, end_time) values('t', 45,'11:00', '11:50');
insert into offer_times (day, offer_id, start_time, end_time) values('h', 45,'11:00', '11:50');
insert into offer_times (day, offer_id, start_time, end_time) values('m', 46,'9:00', '10:40');
insert into offer_times (day, offer_id, start_time, end_time) values('w', 46,'9:00', '10:40');
insert into offer_times (day, offer_id, start_time, end_time) values('u', 47,'13:00', '14:40');
insert into offer_times (day, offer_id, start_time, end_time) values('t', 47,'13:00', '14:40');
insert into offer_times (day, offer_id, start_time, end_time) values('u', 48,'12:00', '12:50');
insert into offer_times (day, offer_id, start_time, end_time) values('t', 48,'12:00', '12:50');
insert into offer_times (day, offer_id, start_time, end_time) values('h', 48,'12:00', '12:50');
insert into offer_times (day, offer_id, start_time, end_time) values('u', 49,'10:00', '10:50');
insert into offer_times (day, offer_id, start_time, end_time) values('t', 49,'10:00', '10:50');
insert into offer_times (day, offer_id, start_time, end_time) values('h', 49,'10:00', '10:50');
insert into offer_times (day, offer_id, start_time, end_time) values('m', 50,'15:00', '16:15');
insert into offer_times (day, offer_id, start_time, end_time) values('w', 50,'15:00', '16:15');
insert into offer_times (day, offer_id, start_time, end_time) values('m', 51,'13:30', '14:45');
insert into offer_times (day, offer_id, start_time, end_time) values('w', 51,'13:30', '14:45');
insert into offer_times (day, offer_id, start_time, end_time) values('u', 52,'9:00', '9:50');
insert into offer_times (day, offer_id, start_time, end_time) values('t', 52,'9:00', '9:50');
insert into offer_times (day, offer_id, start_time, end_time) values('h', 52,'9:00', '9:50');
insert into offer_times (day, offer_id, start_time, end_time) values('u', 53,'12:00', '12:50');
insert into offer_times (day, offer_id, start_time, end_time) values('t', 53,'12:00', '12:50');
insert into offer_times (day, offer_id, start_time, end_time) values('h', 53,'12:00', '12:50');
insert into offer_times (day, offer_id, start_time, end_time) values('u', 54,'14:00', '14:50');
insert into offer_times (day, offer_id, start_time, end_time) values('t', 54,'14:00', '14:50');
insert into offer_times (day, offer_id, start_time, end_time) values('h', 54,'14:00', '14:50');
insert into offer_times (day, offer_id, start_time, end_time) values('u', 55,'18:00', '18:50');
insert into offer_times (day, offer_id, start_time, end_time) values('t', 55,'18:00', '18:50');
insert into offer_times (day, offer_id, start_time, end_time) values('h', 55,'18:00', '18:50');
insert into offer_times (day, offer_id, start_time, end_time) values('u', 56,'10:00', '10:50');
insert into offer_times (day, offer_id, start_time, end_time) values('t', 56,'10:00', '10:50');
insert into offer_times (day, offer_id, start_time, end_time) values('u', 57,'13:00', '13:50');
insert into offer_times (day, offer_id, start_time, end_time) values('t', 57,'13:00', '13:50');
insert into offer_times (day, offer_id, start_time, end_time) values('h', 57,'13:00', '13:50');
insert into offer_times (day, offer_id, start_time, end_time) values('u', 58,'15:00', '15:50');
insert into offer_times (day, offer_id, start_time, end_time) values('t', 58,'15:00', '15:50');
insert into offer_times (day, offer_id, start_time, end_time) values('h', 58,'15:00', '15:50');
insert into offer_times (day, offer_id, start_time, end_time) values('m', 59,'9:00', '10:15');
insert into offer_times (day, offer_id, start_time, end_time) values('w', 59,'9:00', '10:15');
insert into offer_times (day, offer_id, start_time, end_time) values('u', 60,'16:00', '16:50');
insert into offer_times (day, offer_id, start_time, end_time) values('t', 60,'16:00', '16:50');
insert into offer_times (day, offer_id, start_time, end_time) values('h', 60,'16:00', '16:50');
insert into offer_times (day, offer_id, start_time, end_time) values('u', 61,'13:00', '13:50');
insert into offer_times (day, offer_id, start_time, end_time) values('t', 61,'13:00', '13:50');
insert into offer_times (day, offer_id, start_time, end_time) values('h', 61,'13:00', '13:50');
insert into offer_times (day, offer_id, start_time, end_time) values('u', 62,'17:00', '18:40');
insert into offer_times (day, offer_id, start_time, end_time) values('h', 62,'17:00', '18:40');
insert into offer_times (day, offer_id, start_time, end_time) values('u', 63,'12:00', '12:50');
insert into offer_times (day, offer_id, start_time, end_time) values('h', 63,'12:00', '12:50');
insert into offer_times (day, offer_id, start_time, end_time) values('m', 64,'10:45', '12:00');
insert into offer_times (day, offer_id, start_time, end_time) values('w', 64,'10:45', '12:00');
insert into offer_times (day, offer_id, start_time, end_time) values('u', 65,'11:00', '12:40');
insert into offer_times (day, offer_id, start_time, end_time) values('t', 65,'11:00', '12:40');
insert into offer_times (day, offer_id, start_time, end_time) values('u', 66,'11:00', '11:50');
insert into offer_times (day, offer_id, start_time, end_time) values('t', 66,'11:00', '11:50');
insert into offer_times (day, offer_id, start_time, end_time) values('h', 66,'11:00', '11:50');
insert into offer_times (day, offer_id, start_time, end_time) values('u', 67,'15:00', '16:40');
insert into offer_times (day, offer_id, start_time, end_time) values('t', 67,'15:00', '16:40');
insert into offer_times (day, offer_id, start_time, end_time) values('u', 68,'17:00', '18:40');
insert into offer_times (day, offer_id, start_time, end_time) values('t', 68,'17:00', '18:40');
insert into offer_times (day, offer_id, start_time, end_time) values('u', 69,'17:00', '18:40');
insert into offer_times (day, offer_id, start_time, end_time) values('t', 69,'17:00', '18:40');
insert into offer_times (day, offer_id, start_time, end_time) values('m', 70,'14:00', '15:40');
insert into offer_times (day, offer_id, start_time, end_time) values('w', 70,'14:00', '15:40');
insert into student (student_id, username, fname, sname, tname, lname, gender, nationality, cpr) VALUES
(201910063,'s201910063', 'Husain', 'Yusuf', 'Ahmed', 'Mohamed', 'Male', 'Bahrain', 950807747);


insert into student (student_id, username, fname, sname, tname, lname, gender, nationality, cpr) VALUES
(202238845, 's202238845', 'Khalifa', 'Ghassan', 'Khalifa', 'Yaseen', 'Male', 'Bahrain', 971102256);

insert into student_info (student_id, program_id, email, phone1, phone2, flat, building, road, block, area, isactive, password, role) VALUES
(201910063,'BSIT', 'hussain.yusuf95@gmail.com', 36612926, Null, Null, 991,1227,412,'Jidhafs', true, '$2b$12$rWgGgMblfz.8GLBF4UKzGO78CiU5.fo.cNYTdm.jyoS.BfhlGadgq', 'student');




insert into student_info (student_id, program_id, email, phone1, phone2, flat, building, road, block, area, isactive, password, role) VALUES
(202238845,'BSIT', 'Khalifa.Ghassan@gmail.com', 37118879, Null, Null, 456,1122,111,'Muharraq', true, '$2b$12$RsYSMHnm0sGgp3sb3oqHSejQdqxI.Q3pqVqtOowG1HevUPS5QkHCq', 'student');
insert into examted (student_id, course_id, actual_grade) values ('201910063', 'HIST 121', 'A') ;
insert into examted (student_id, course_id, actual_grade) values ('201910063', 'ITCS 101', 'A') ;
insert into examted (student_id, course_id, actual_grade) values ('201910063', 'MATH 101', 'A') ;
insert into examted (student_id, course_id, actual_grade) values ('201910063', 'ARAB 101', 'C') ;
insert into examted (student_id, course_id, actual_grade) values ('201910063', 'ENGL 101', 'A') ;
insert into examted (student_id, course_id, actual_grade) values ('201910063', 'ENGL 102', 'A') ;
insert into examted (student_id, course_id, actual_grade) values ('201910063', 'FREN 101', 'A') ;
insert into examted (student_id, course_id, actual_grade) values ('201910063', 'GERM 101', 'A') ;
insert into examted (student_id, course_id, actual_grade) values ('201910063', 'HUMR 101', 'B') ;
insert into examted (student_id, course_id, actual_grade) values ('201910063', 'CULT 102', 'A') ;
insert into examted (student_id, course_id, actual_grade) values ('201910063', 'MATH 102', 'A') ;
insert into registration (student_id, semester_id, offer_id)  values (201910063, 1, 2);
insert into registration (student_id, semester_id, offer_id)  values (201910063, 1, 3);
insert into registration (student_id, semester_id, offer_id)  values (201910063, 1, 4);
insert into registration (student_id, semester_id, offer_id)  values (201910063, 1, 5);
insert into registration (student_id, semester_id, offer_id)  values (201910063, 1, 6);
insert into registration (student_id, semester_id, offer_id)  values (201910063, 2, 7);
insert into registration (student_id, semester_id, offer_id)  values (201910063, 2, 8);
insert into registration (student_id, semester_id, offer_id)  values (201910063, 2, 9);
insert into registration (student_id, semester_id, offer_id)  values (201910063, 2, 10);
insert into registration (student_id, semester_id, offer_id)  values (201910063, 2, 11);
insert into registration (student_id, semester_id, offer_id)  values (201910063, 3, 12);
insert into registration (student_id, semester_id, offer_id)  values (201910063, 3, 13);
insert into registration (student_id, semester_id, offer_id)  values (201910063, 3, 14);
insert into registration (student_id, semester_id, offer_id)  values (201910063, 4, 15);
insert into registration (student_id, semester_id, offer_id)  values (201910063, 4, 16);
insert into registration (student_id, semester_id, offer_id)  values (201910063, 4, 17);
insert into registration (student_id, semester_id, offer_id)  values (201910063, 4, 18);
insert into registration (student_id, semester_id, offer_id)  values (201910063, 4, 19);
insert into registration (student_id, semester_id, offer_id)  values (201910063, 4, 20);
insert into registration (student_id, semester_id, offer_id)  values (201910063, 5, 21);
insert into registration (student_id, semester_id, offer_id)  values (201910063, 5, 22);
insert into registration (student_id, semester_id, offer_id)  values (201910063, 5, 23);
insert into registration (student_id, semester_id, offer_id)  values (201910063, 5, 24);
insert into registration (student_id, semester_id, offer_id)  values (201910063, 5, 25);
insert into registration (student_id, semester_id, offer_id)  values (201910063, 6, 26);
insert into registration (student_id, semester_id, offer_id)  values (201910063, 6, 27);
insert into registration (student_id, semester_id, offer_id)  values (201910063, 6, 28);

insert into grades (registration_id, grade) values (1, 88);
insert into grades (registration_id, grade) values (2, 98);
insert into grades (registration_id, grade) values (3, 87);
insert into grades (registration_id, grade) values (4, 85);
insert into grades (registration_id, grade) values (5, 89);
insert into grades (registration_id, grade) values (6, 119);
insert into grades (registration_id, grade) values (7, 119);
insert into grades (registration_id, grade) values (8, 119);
insert into grades (registration_id, grade) values (9, 119);
insert into grades (registration_id, grade) values (10, 100);
insert into grades (registration_id, grade) values (11, 119);
insert into grades (registration_id, grade) values (12, 119);
insert into grades (registration_id, grade) values (13, 119);
insert into grades (registration_id, grade) values (14, 100);
insert into grades (registration_id, grade) values (15, 100);
insert into grades (registration_id, grade) values (16, 100);
insert into grades (registration_id, grade) values (17, 100);
insert into grades (registration_id, grade) values (18, 100);
insert into grades (registration_id, grade) values (19, 100);
insert into grades (registration_id, grade) values (20, 95);
insert into grades (registration_id, grade) values (21, 97);
insert into grades (registration_id, grade) values (22, 96);
insert into grades (registration_id, grade) values (23, 94);
insert into grades (registration_id, grade) values (24, 94);
insert into grades (registration_id, grade) values (25, 87);
insert into grades (registration_id, grade) values (26, 96);
insert into grades (registration_id, grade) values (27, 120);
insert into grades (registration_id, grade) values (28, 97);




insert into program (program_id, program_name, dep_id) values ('BSMS', 'BACHELORS DEGREE IN MULTIMEDIA SYSTEMS', 'ITMS');
insert into course(course_id, credit, minimum_credit_req, name, dep_id, type, isactive, hasexam, level) VALUES ('ITMS 201', 3, 0, 'INTRODUCTION TO MULTIMEDIA SYSTEMS', 'ITMS', 'core', True, True, 2);
insert into pre_req (course_id, pre_req_id) values ('ITMS 201', 'ITCS 201');
insert into curriculum (course_id, year, semester, program_id) VALUES ('ITMS 201', 2, 1, 'BSMS');
insert into offered_course(offer_id, semester_id, course_id, inst_id, room_id, section_no) VALUES (71, 7, 'ITMS 201', 3, 4, 1);
insert into offer_times (day, offer_id, start_time, end_time) VALUES ('m', 71, '20:00', '21:40');
insert into offer_times (day, offer_id, start_time, end_time) VALUES ('w', 71, '20:00', '21:40');