from sqlalchemy import true
from db.database import Base
from sqlalchemy.orm import relationship


class DbCollege(Base):
    __tablename__ = 'college'
    departments = relationship(
        'DbDepartment', back_populates='college', viewonly=True)


    deans = relationship("DbDean", back_populates="college", viewonly=True, uselist=True)


class DbDepartment(Base):
    __tablename__ = 'department'
    college = relationship(
        'DbCollege', back_populates='departments', viewonly=True, uselist=False)

    instructors = relationship("DbInstructorInfo", back_populates="department", viewonly=True, uselist=True)
    
    programs = relationship("DbProgram", back_populates='department', viewonly=True, uselist=True)
    chairs = relationship("DbChair", back_populates='department', viewonly=True, uselist=True)
    courses = relationship("DbCourse", back_populates="department", viewonly=True, uselist=True)
    
class DbProgram(Base):
    __tablename__ = 'program'

    department = relationship("DbDepartment", back_populates='programs', viewonly=True, uselist=False)
    students = relationship("DbSInfo", back_populates="program", viewonly=True, uselist=True)
    curriculum = relationship("DbCurriculum", back_populates="program", viewonly=True)

class DbInstructor(Base):
    __tablename__ = 'instructor'

    info = relationship("DbInstructorInfo", back_populates='instructor',
                        viewonly=True, uselist=False)
    dean = relationship("DbDean", back_populates="deaninfo", viewonly=True, uselist=False)
    chair = relationship("DbChair", back_populates="chairinfo", viewonly=True, uselist=False)
    offers = relationship("DbOffer", back_populates="instructor", viewonly=True, uselist=True)


class DbInstructorInfo(Base):
    __tablename__ = 'instructor_info'

    instructor = relationship(
        "DbInstructor", back_populates='info', viewonly=True)

    department = relationship("DbDepartment", back_populates="instructors", viewonly=True, uselist=False)



class DbStudent(Base):
    __tablename__ = 'student'
    info = relationship("DbSInfo", back_populates='student',
                        viewonly=True, uselist=False)

    regestrations = relationship("DbRegestration", back_populates="student", viewonly=True, uselist=True)


class DbSInfo(Base):
    __tablename__ = 'student_info'
    student = relationship(
        "DbStudent", back_populates='info', viewonly=True)
    program = relationship("DbProgram", back_populates="students", viewonly=True, uselist=False)
    
    


class DbDean(Base):
    __tablename__ = 'dean'
    college = relationship("DbCollege", back_populates="deans", viewonly=True, uselist=False)
    deaninfo = relationship("DbInstructor", back_populates="dean", viewonly=True, uselist=False) #Check uselist later
    


class DbChair(Base):
    __tablename__ = 'chair'
    department = relationship("DbDepartment", back_populates="chairs", viewonly=True, uselist=False)
    chairinfo = relationship("DbInstructor", back_populates="chair", viewonly=True, uselist=False)


class DbCourse(Base):
    __tablename__ = 'course'
    department = relationship("DbDepartment", back_populates="courses", viewonly=True, uselist=False)
    courseinprereq = relationship("DbPreReq", foreign_keys="[DbPreReq.course_id]", back_populates="course", viewonly=True)
    courseprereq =relationship("DbPreReq",foreign_keys="[DbPreReq.course_id]", back_populates="prereq", viewonly=True)
    offers = relationship("DbOffer", back_populates="course", viewonly=True, uselist=True)
    examted = relationship("DbExamted", back_populates="course", viewonly=True, uselist=False)
    curriculum = relationship("DbCurriculum", back_populates="course", viewonly=True)

class DbPreReq(Base):
    __tablename__ = 'pre_req'
    course = relationship("DbCourse",foreign_keys="[DbPreReq.course_id]", back_populates="courseinprereq", viewonly=True)
    prereq = relationship("DbCourse",foreign_keys="[DbPreReq.pre_req_id]", back_populates="courseprereq", viewonly=True)


class DbCurriculum(Base):
    __tablename__ = 'curriculum'
    course = relationship("DbCourse", back_populates="curriculum", viewonly=True, uselist=False)
    program = relationship("DbProgram", back_populates="curriculum", viewonly=True)


class DbSemester(Base):
    __tablename__ = 'semester'
    offers = relationship("DbOffer", back_populates="semester", viewonly=True, uselist=True)
    regestrations = relationship("DbRegestration", back_populates="semester", viewonly=True, uselist=True)


class DbRoom(Base):
    __tablename__ = 'room'
    offers = relationship("DbOffer", back_populates="room", viewonly=True, uselist=True)


class DbOffer(Base):
    __tablename__ = 'offered_course'
    semester = relationship("DbSemester", back_populates="offers", viewonly=True, uselist=False)
    course = relationship("DbCourse", back_populates="offers", viewonly=True, uselist=False)
    instructor = relationship("DbInstructor", back_populates="offers", viewonly=True, uselist=False)
    room =  relationship("DbRoom", back_populates="offers", viewonly=True, uselist=False)
    time = relationship("DbOfferTime", back_populates="offer", viewonly=True, uselist=True)
    regestrations = relationship("DbRegestration", back_populates="offer", viewonly=True, uselist=True)

class DbOfferTime(Base):
    __tablename__ = 'offer_times'
    offer = relationship("DbOffer", back_populates="time", viewonly=True, uselist=False)


class DbRegestration(Base):
    __tablename__ = 'registration'
    student = relationship("DbStudent", back_populates="regestrations", viewonly=True, uselist=False)
    semester = relationship("DbSemester", back_populates="regestrations", viewonly=True, uselist=False)
    offer = relationship("DbOffer", back_populates="regestrations", viewonly=True, uselist=False)
    grade = relationship("DbGrades", back_populates="regestration",  viewonly=True, uselist=False)



class DbGrades(Base):
    __tablename__ = 'grades'
    regestration = relationship("DbRegestration", back_populates="grade", viewonly=True, uselist=False)




class DbExamted(Base):
    __tablename__ = 'examted'
    course = relationship("DbCourse", back_populates="", viewonly=True, uselist=False)
