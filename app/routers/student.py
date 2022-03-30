
from typing import List
from fastapi import APIRouter, Depends
from auth.oauth2 import get_current_student
from db.database import get_db
from db import db_student
from schemes import StudentDisplay, ScheduleDisplay
from sqlalchemy.orm import Session



router = APIRouter(
    prefix='/student',
    tags=['student']
)


@router.get('/me', response_model=StudentDisplay)
def get_student_data(current_student: StudentDisplay = Depends(get_current_student)):
    return current_student




@router.get('/schedule', response_model=List[ScheduleDisplay])
def get_current_schedule(current_student: StudentDisplay = Depends(get_current_student), db: Session = Depends(get_db)):
    return db_student.get_current_schedule(current_student, db)





@router.get('/transcript')
def get_transcript(current_student: StudentDisplay = Depends(get_current_student), db: Session = Depends(get_db)):
    return db_student.get_transcript(current_student, db)