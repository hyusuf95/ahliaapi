from typing import List, Optional
from pydantic import BaseModel


# Singles


class College(BaseModel):
    college_id: str
    college_name: str

    class Config():
        orm_mode = True


class Department(BaseModel):
    dep_id: str
    dep_name: str
    college: College

    class Config():
        orm_mode = True


class Program(BaseModel):
    program_id: str
    program_name: str
    department: Department

    class Config():
        orm_mode = True


class StudentInfo(BaseModel):
    program: Program
    phone1: int
    phone2: Optional[int] = None
    flat: Optional[int] = None
    building: int
    road: int
    block: int
    area: str
    email: str
    role: str

    class Config():
        orm_mode = True


class Student(BaseModel):
    student_id: str
    fname: str
    sname: str
    tname: str
    lname: str

    class Config():
        orm_mode = True


class InstructorInfo(BaseModel):
    email: str
    role: str
    department: Department
    class Config():
        orm_mode=True


class Instructor(BaseModel):
    fname: str
    sname: Optional[str] = None
    tname: Optional[str] = None
    lname: str
    info: InstructorInfo
    class Config():
        orm_mode=True


class Room(BaseModel):
    type: Optional[str] = None
    room_id: int
    class Config():
        orm_mode=True


class Semester(BaseModel):
    semester_name: str

    class Config():
        orm_mode = True


class CourseInOffer(BaseModel):
    course_id: str
    name: str
    credit: int
    

    class Config():
        orm_mode = True


class Offer(BaseModel):
    semester: Semester
    course: CourseInOffer

    class Config():
        orm_mode = True


class Time(BaseModel):
    day: str
    start_time: str
    end_time: str
    class Config():
        orm_mode = True


class OfferInReg(BaseModel):
    offer_id: int
    course: CourseInOffer
    room: Room
    time: List[Time]
    class Config():
        orm_mode=True


class OfferInSemester(BaseModel):
    offer_id: int
    course: CourseInOffer
    section_no: int
    time: List[Time]
    class Config():
        orm_mode = True



class Time(BaseModel):
    day: str
    start_time: str
    end_time: str
 
    class Config():
        orm_mode=True



########################## Transcript ########################

class OfferInTranscript(BaseModel):
    course_id: str
    class Config():
        orm_mode = True




class GradeInTranscript(BaseModel):
    grade: int
    
    class Config():
        orm_mode=True


class Transcript(BaseModel):
    semester: Semester
    offer: OfferInTranscript
    grade: GradeInTranscript
    class Config():
        orm_mode = True

###########################Schedule#########################


class OfferInSchedule(BaseModel):
    
    course_id: str
    section_no: int
    time: List[Time]
    instructor: Instructor
    room: Room


    class Config():
        orm_mode=True




class StudentDisplay(BaseModel):
    student_id: int
    fname: str
    sname: str
    tname: str
    lname: str
    gender: str
    nationality: str
    cpr: int
    info: StudentInfo

    class Config():
        orm_mode = True


class DepartmentDisplay(BaseModel):
    dep_id: str
    college_id: str
    dep_name: str
    college: College

    class Config():
        orm_mode = True

class SemesterDisplay(BaseModel):
    semester_id: int
    semester_name: str
    start_date: str
    end_date: str
    registration_open: bool
    offers: List[OfferInSemester]

    class Config():
        orm_mode = True



class CurriculumDisplay(BaseModel):
    year: int
    semester: int
    course: CourseInOffer

    class Config():
        orm_mode=True




class ScheduleDisplay(BaseModel):
    semester: Semester
    offer: OfferInSchedule
    class Config():
        orm_mode=True


class RegestrationDisplay(BaseModel):
    offer: OfferInReg
    class Config():
        orm_mode = True