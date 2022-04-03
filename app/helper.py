from db.models import DbOfferTime, DbOffer
from sqlalchemy.orm import Session

def grade_to_letter(grade: float):

    char: str = None
    points: float = None

    if (grade<60):
        char = 'F'
        points = 0.00
    elif (grade >= 60 and grade <= 63):
        char = 'D'
        points = 1.00
    elif (grade >= 64 and grade <= 66):
        char = 'D+'
        points = 1.33
    elif (grade >= 67 and grade <= 69):
        char = 'C-'
        points = 1.67
    elif (grade >= 70 and grade <= 73):
        char = 'C'
        points = 2.00
    elif (grade >= 74 and grade <= 76):
        char = 'C+'
        points = 2.33
    elif (grade >= 77 and grade <= 79):
        char = 'B-'
        points = 2.67
    elif (grade >=80 and grade <= 83):
        char = 'B'
        points = 3.00

    elif (grade >= 84 and grade <= 86):
        char = 'B+'
        points = 3.33
    elif (grade >= 87 and grade <=89):
        char = 'A-'
        points = 3.67
    elif (grade >= 90 and grade <= 100):
        char = 'A'
        points = 4.00
    elif (grade == 120 or grade == 119):
        char = 'P'
    else:
        char = 'Error'

    return {
        "Grade": char,
        "Points": points
    }





def checkCollision(existings, new_course):
    conflict = False
    for e in existings:
        eDay = e["day"]
        for n in new_course:
            nDay = n["day"]
            if (eDay == nDay):
                eStart: str = e["start_time"]
                eStart: str = int(eStart.replace(":", ""))
                eEnd: str = e["end_time"]
                eEnd: str = int(eEnd.replace(":", ""))
                nStart: str = n["start_time"]
                nStart: str = int(nStart.replace(":", ""))
                nEnd: str = n["end_time"]
                nEnd: str = int(nEnd.replace(":", ""))

                intervals = [(eStart, eEnd), (nStart, nEnd)]
                intervals.sort()
                for i in range(1, len(intervals)):
                    if intervals[i][1] <= intervals[i - 1][1]:
                        conflict = True
                        break
    return conflict



def get_course_time(CourseName: str, semesterID: int, db: Session):
    time = db.query(DbOfferTime.day, DbOfferTime.start_time, DbOfferTime.end_time).join(DbOffer).filter(DbOfferTime.offer_id == DbOffer.offer_id).filter(DbOffer.course_id == CourseName).filter(DbOffer.semester_id == semesterID).all()
    timeObject = []

    for t in time:
        timeObject.append({
            "day": t[0],
            "start_time": t[1],
            "end_time": t[2]
        })
    return timeObject




def calculate_gpa(semester, SemesterWP):
   
    totalWeight = 0
    gpa = 0
    for course in semester:
        if (course["Points"]):
            weight = course["Points"] * course["CourseCredit"]
            totalWeight+=weight
    if (SemesterWP):
        gpa = totalWeight/SemesterWP
        return round(gpa,2)
    else:
        return "P"



def calculate_cumulative(Transcript):
    tempGPA = 0
    gpaweight = 0
    GPAs = []
    for semester in Transcript:
        semesterName= semester["SemesterName"]
        cumulativeWP = semester["CumulativeCreditsWithoutPass"]
        semesterWP = semester["SemesterCreditsWithoutPass"]
        semesterGPA = semester["SemesterGPA"]

        if (semesterWP):
            gpaweight += semesterWP * semesterGPA
            gpa = round(gpaweight/cumulativeWP, 2)
            tempGPA = gpa
        else:
            gpa=tempGPA

        
        GPAs.append({
                "SemesterName": semesterName,
                "cumulativeGPA": gpa
        })
        

    return GPAs
        


        