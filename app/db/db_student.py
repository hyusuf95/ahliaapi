from sqlalchemy.orm import Session
from schemes import StudentDisplay
from db.models import DbStudent, DbSemester, DbRegestration, DbOffer, DbGrades,DbExamted, DbCourse
from exceptionsHandler import handle_not_found
from sqlalchemy.orm import Session
from helper import grade_to_letter, calculate_gpa, calculate_cumulative

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
    #transcript = db.query(DbOffer.course_id, DbSemester.semester_name, DbGrades.grade, DbRegestration.student_id).select_from(DbOffer).filter(DbOffer.semester_id == DbSemester.semester_id).filter(DbOffer.offer_id == DbRegestration.offer_id).filter(DbRegestration.id == DbGrades.registration_id).filter(DbRegestration.student_id == current_student.student_id).filter(DbSemester.isactive != True).filter(DbSemester.registration_open != True).all()
    transcript = db.query(DbOffer.course_id, DbCourse.credit, DbSemester.semester_name, DbGrades.grade, DbRegestration.student_id).select_from(DbOffer).filter(DbOffer.semester_id == DbSemester.semester_id).filter(DbOffer.offer_id == DbRegestration.offer_id).filter(DbRegestration.id == DbGrades.registration_id).filter(DbRegestration.student_id == current_student.student_id).filter(DbSemester.isactive != True).filter(DbSemester.registration_open != True).filter(DbCourse.course_id == DbOffer.course_id).all()
        
    MainList = []
    SemesterNames = []
    Cumulative = 0
    CumulativeWP = 0    

    for result in transcript:
        semesterName = result["semester_name"]
        if semesterName in SemesterNames:
            continue
        SemesterNames.append(semesterName)
        Semester = 0
        SemesterWP = 0
        courseList = []
        for course in transcript:
            if (course["semester_name"] == semesterName):
                Semester += course["credit"]
                if not (course["grade"] >100): SemesterWP += course["credit"]
                grade = grade_to_letter(course["grade"])
                courseList.append({
                    "CourseName": course["course_id"],
                    "Grade": grade["Grade"],
                    "Points": grade["Points"],
                    "CourseCredit": course["credit"]
                })

        Cumulative += Semester
        CumulativeWP += SemesterWP

        semesterGPA = calculate_gpa(courseList, SemesterWP)
       

        MainList.append({
            "SemesterName": semesterName,
            "SemesterCreditsWithPass": Semester,
            "SemesterCreditsWithoutPass": SemesterWP,
            "CumulativeCreditsWithPass": Cumulative,
            "CumulativeCreditsWithoutPass": CumulativeWP,
            "SemesterGPA": semesterGPA,
            "Courses": courseList
            


        })

    cumulativeGPAs = calculate_cumulative(MainList)
    for semester in MainList:
        for gpa in cumulativeGPAs:
            if (semester["SemesterName"] == gpa["SemesterName"]):
                semester["CumulativeGPA"] = gpa["cumulativeGPA"]
                break


    

    return MainList




        



