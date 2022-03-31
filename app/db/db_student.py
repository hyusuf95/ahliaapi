from sqlalchemy.orm import Session
from schemes import StudentDisplay
from db.models import DbStudent, DbSemester, DbRegestration, DbOffer, DbGrades,DbExamted
from exceptionsHandler import handle_not_found
from sqlalchemy.orm import Session
from helper import grade_to_letter

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

        MainList = []
        semesterNames = []
        for t in transcript:
            semesterName = t["semester_name"]
            if (semesterName not in semesterNames):
                semesterNames.append(semesterName)
        
        #calculate gpa
        
        for s in semesterNames:
            
            CoursesList = []
            for t in transcript:
                if (t["semester_name"] == s):
                    CoursesList.append(
                        {
                            "Course": t["course_id"],
                            "Grade": grade_to_letter(t["grade"])
                        }
                    )
            object = {"SemesterName": s, "Courses": CoursesList}
            MainList.append(object)




        examted = db.query(DbExamted.course_id).filter(DbExamted.student_id == current_student.student_id).all()
        ExamtedList = []
        for e in examted:
            ExamtedList.append(e[0])
        
        MainList.append({"Examted Courses (Grade E)": ExamtedList })


        return MainList

        



