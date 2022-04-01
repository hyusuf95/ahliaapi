from sqlalchemy.orm import Session

from schemes import StudentDisplay
from db.models import DbStudent, DbSemester, DbRegestration, DbOffer, DbGrades,DbExamted, DbCourse
from exceptionsHandler import handle_not_found
from sqlalchemy.orm import Session
from helper import grade_to_letter, get_semester_gpa

def get_student_by_id(id: int, db: Session):
    student = db.query(DbStudent).filter(
        DbStudent.student_id == id).first()
    handle_not_found(student)
    return student


def get_current_schedule(current_student: StudentDisplay, db: Session):
    activeSemester = db.query(DbSemester).filter(DbSemester.isactive == True).first()
    schedule = db.query(DbRegestration).filter( DbRegestration.student_id == current_student.student_id).filter(DbRegestration.semester_id == activeSemester.semester_id).all()
    return schedule



def get_transcript(current_student: StudentDisplay, db:Session):
        transcript = db.query(DbOffer.course_id, DbSemester.semester_name, DbGrades.grade, DbRegestration.student_id).select_from(DbOffer).filter(DbOffer.semester_id == DbSemester.semester_id).filter(DbOffer.offer_id == DbRegestration.offer_id).filter(DbRegestration.id == DbGrades.registration_id).filter(DbRegestration.student_id == current_student.student_id).filter(DbSemester.isactive != True).filter(DbSemester.registration_open != True).all()
        transcript = db.query(DbOffer.course_id, DbCourse.credit, DbSemester.semester_name, DbGrades.grade, DbRegestration.student_id).select_from(DbOffer).filter(DbOffer.semester_id == DbSemester.semester_id).filter(DbOffer.offer_id == DbRegestration.offer_id).filter(DbRegestration.id == DbGrades.registration_id).filter(DbRegestration.student_id == current_student.student_id).filter(DbSemester.isactive != True).filter(DbSemester.registration_open != True).filter(DbCourse.course_id == DbOffer.course_id).all()

        MainList = []
        semesterNames = []
        for t in transcript:
            semesterName = t["semester_name"]
            if (semesterName not in semesterNames):
                semesterNames.append(semesterName)
        
        #calculate gpa
        
        CumulativeCredits = 0
        CumulativeWithoutPass = 0
        for s in semesterNames:
            SemesterCredits = 0
            SemesterWithoutPass = 0
            CoursesList = []
            for t in transcript:
                if (t["semester_name"] == s):
                    SemesterCredits+=t["credit"]
                    if not (t["grade"]>100): #If not p
                        SemesterWithoutPass+=t["credit"]
                    CoursesList.append(
                        {
                            "Course": t["course_id"],
                            "Grade": grade_to_letter(t["grade"]),
                            "Credit": t["credit"]
                        }
                    )
            CumulativeCredits+=SemesterCredits
            CumulativeWithoutPass+=SemesterWithoutPass
            CreditsObject = {"SemesterCredits": SemesterCredits, "CumulativeCredits": CumulativeCredits, "SemesterCreditsWithoutPass": SemesterWithoutPass,"CumulativeWithoutPass": CumulativeWithoutPass}
            object = {"SemesterName": s, "Courses": CoursesList}
            
            MainList.append(object)
            MainList.append({"Credits": CreditsObject})



        examted = db.query(DbExamted.course_id).filter(DbExamted.student_id == current_student.student_id).all()
        ExamtedList = []
        for e in examted:
            ExamtedList.append(e[0])
        
        MainList.append({"Examted Courses (Grade E)": ExamtedList })
        return MainList




        



