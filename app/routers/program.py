
from db.database import get_db
from auth.oauth2 import get_current_student
from schemes import CurriculumDisplay
from sqlalchemy.orm import Session
from fastapi import APIRouter, Depends
from typing import List
from schemes import StudentDisplay
from db import db_program

router = APIRouter(
    prefix='/program',
    tags=['Program']
)


@router.get('/curriculum', response_model=List[CurriculumDisplay])
def get_student_curriculum(current_student: StudentDisplay = Depends(get_current_student), db:Session = Depends(get_db)):
    return db_program.student_curriculum(current_student, db)