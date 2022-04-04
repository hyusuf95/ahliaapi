
from fastapi import HTTPException as HE, status
from sqlalchemy import text
from sqlalchemy.orm import Session
from schemes import StudentDisplay
from db.models import DbRegestration, DbGrades, DbOffer, DbSemester, DbSInfo, DbCurriculum, DbCourse, DbExamted, DbPreReq
import db.db_semesters as db_semesters
from helper import grade_to_letter, checkCollision, get_course_time



# Handle Not found
def handle_not_found(object):
    if not object:
        raise HE(status_code=status.HTTP_404_NOT_FOUND,
                 detail="Error. Not found")



# Handle adding course



# Course has to be offered for next semester
# Within Curriculum
# First time to be taken
# if repeat, Grade less than C
# Only next semester offers
# Not Already registered
# Maximum 18 Credits or 9 (summer)
# No Clash
#Take Prereq or examted




def handle_adding_course(offer, current_student: StudentDisplay, db: Session):




    offer = offer.__dict__
    courseName = offer["course_id"]
    next_semester = db_semesters.open_regestration_semester(db)

    StudentProgram = db.query(DbSInfo.program_id).filter(DbSInfo.student_id == current_student.student_id).first()[0]

    takenCourseProgram = db.query(DbOffer.course_id, DbCurriculum.program_id).select_from(DbOffer).filter(DbOffer.course_id == DbCurriculum.course_id).filter(DbOffer.offer_id == offer["offer_id"]).first()

    #Handle course not in curriculum
    if (StudentProgram != takenCourseProgram[1]):
        raise HE(status_code=status.HTTP_403_FORBIDDEN, detail=f"Course {takenCourseProgram[1]} not in your Curriculum")



    #Only next semester offers

    if (offer["semester_id"] != next_semester.semester_id):
        raise HE(status_code=status.HTTP_400_BAD_REQUEST, detail="This offer not within next semester, Do not show this message in the APP")






    allCourses = db.query(DbOffer.course_id, DbSemester.semester_name, DbGrades.grade, DbRegestration.student_id).select_from(DbOffer).filter(DbOffer.semester_id == DbSemester.semester_id).filter(DbOffer.offer_id == DbRegestration.offer_id).filter(DbRegestration.id == DbGrades.registration_id).filter(DbRegestration.student_id == current_student.student_id).all()


    result = []
    for course in allCourses:
        result.append({
            "courseName": course[0],
            "semester": course[1],
            "grade": course[2]
        })


#The query
# select pre_req.pre_req_id from registration
# join offered_course on registration.offer_id = offered_course.offer_id
# join pre_req on offered_course.course_id = pre_req.course_id
# where registration.student_id = 201910063 and offered_course.course_id = 'ITMS 205'


    #Validate prereq
    preReqCourses = db.query(DbPreReq.pre_req_id).filter(DbPreReq.course_id == courseName).all()


    for prereq in preReqCourses:
        print(prereq[0])
        if (prereq[0]): #If there is a requirement check grade
            query = f"select grades.grade from grades join registration r on grades.registration_id = r.id join offered_course oc on r.offer_id = oc.offer_id where oc.course_id = '{prereq[0]}' and r.student_id = {current_student.student_id};"

            PreReqGrade = db.execute(query).first()


            if (PreReqGrade):
                if (PreReqGrade[0] < 60):
                        raise HE(status_code=status.HTTP_428_PRECONDITION_REQUIRED, detail=f"You have to pass {preReqCourses[0][0]} course in order to register {courseName} Course")
            elif (not PreReqGrade):
                raise HE(status_code=status.HTTP_428_PRECONDITION_REQUIRED, detail=f"Course {courseName} can not be registered, {preReqCourses[0][0]} need to be taken as prerequisite.")
            
        
        
        
        
        # print(queryExamted)
        # PreReqGrade = db.execute(query).first()
        # PreReqExamted = db.execute(queryExamted).first()
        # for prereq in preReqCourses:
        #     prereq = prereq[0]
        #     #If prereq not found in takencourses
        #     if (PreReqGrade < 60):
        #         print(query)
        #         print("************************************************")
        #         print(PreReqExamted)
        #         #Check examted Courses
        #         if not (PreReqExamted and prereq in PreReqExamted):
        #             raise HE(status_code=status.HTTP_428_PRECONDITION_REQUIRED, detail=f'Course {courseName} can not be registered, {prereq} need to be taken as prerequisite.')












    for r in result:
        #If course has been taken before
        if (courseName == r["courseName"]):
            #Get the taken course
            takenCourse = db.query(DbOffer.course_id, DbSemester.semester_name, DbGrades.grade, DbRegestration.student_id).select_from(DbOffer).filter(DbOffer.semester_id == DbSemester.semester_id).filter(DbOffer.offer_id == DbRegestration.offer_id).filter(DbRegestration.id == DbGrades.registration_id).filter(DbRegestration.student_id == current_student.student_id).filter(DbOffer.course_id == r["courseName"]).all()

            takenGrade = takenCourse[0][2]
            letter = grade_to_letter(takenGrade)

            if (takenGrade >= 70):
                raise HE(status_code=status.HTTP_409_CONFLICT, detail= f"{r['courseName']} course has been taken on {r['semester']} and grade {letter['Grade']} was scored")



    new_course_time = get_course_time(takenCourseProgram[0], next_semester.__dict__["semester_id"], db)


    RegisteredCourses = db.query(DbCourse.course_id).join(DbOffer).filter(DbCourse.course_id == DbOffer.course_id).join(DbSemester).filter(DbOffer.semester_id ==DbSemester.semester_id).join(DbRegestration).filter(DbRegestration.offer_id == DbOffer.offer_id).filter(DbRegestration.student_id == current_student.student_id).filter(DbSemester.semester_id == next_semester.semester_id).all()
    
    for r in RegisteredCourses:
        existing_course_time = get_course_time(r[0],next_semester.__dict__["semester_id"], db)
        if(checkCollision(existing_course_time, new_course_time)):
            
            raise HE(status_code=status.HTTP_409_CONFLICT, detail=f"{takenCourseProgram[0]} Clash with {r[0]} Course")



    #Check if not already registered
    dublicate = db.query(DbRegestration).filter(DbRegestration.offer_id == offer["offer_id"]).filter(DbRegestration.student_id == current_student.student_id).first()
    if (dublicate):
        raise HE(status_code=status.HTTP_400_BAD_REQUEST, detail=f"{takenCourseProgram[0]} already registered")



    #Check maximum credits
    RegisteredCredits = db.query(DbCourse.credit).join(DbOffer).filter(DbCourse.course_id == DbOffer.course_id).join(DbSemester).filter(DbOffer.semester_id ==DbSemester.semester_id).join(DbRegestration).filter(DbRegestration.offer_id == DbOffer.offer_id).filter(DbRegestration.student_id == current_student.student_id).filter(DbSemester.semester_id == next_semester.semester_id).all()
    sum = 0
    for credit in RegisteredCredits:
        sum+=credit[0]

    currentSemesterName = next_semester.__dict__["semester_name"]
    isSummer = ('SUMMER' in currentSemesterName.upper()) 
    CourseToBeRegCredit = db.query(DbCourse.credit).filter(DbCourse.course_id == takenCourseProgram[0]).first()[0]

    if (isSummer):
        if(sum + CourseToBeRegCredit > 9):
            raise HE(status_code=status.HTTP_406_NOT_ACCEPTABLE, detail='Can not register more than 9 credits in Summer Course')
    else:
        if(sum + CourseToBeRegCredit > 18):
            raise HE(status_code=status.HTTP_406_NOT_ACCEPTABLE, detail='Can not register more than 18 credits')


    #Check if course is examted    
    isTaken = db.query(DbExamted).filter(DbExamted.course_id == courseName).filter(DbExamted.student_id == current_student.student_id).all()
    if (isTaken):
        raise HE(status_code=status.HTTP_409_CONFLICT, detail=f"Course {courseName} can not be registered because it is examted")
