from typing import List
from fastapi import APIRouter, Depends
from db.database import get_db
from sqlalchemy.orm import Session
from db import db_semesters
from schemes import SemesterDisplay

router = APIRouter(
    prefix='/semester',
    tags=['Semester']
)


@router.get('/all', response_model=List[SemesterDisplay])
def get_all_semesters(db: Session = Depends(get_db)):
    return db_semesters.get_all_semesters(db)


@router.get('/current', response_model=SemesterDisplay)
def get_current_semester(db: Session = Depends(get_db)):
    return db_semesters.get_current_semester(db)


@router.get('/openreg', response_model=SemesterDisplay, summary="Get next semester offers")
def open_regestration_semester(db: Session = Depends(get_db)):
    return db_semesters.open_regestration_semester(db)


@router.get('/{id}', response_model=SemesterDisplay)
def get_semester_by_id(id: int, db: Session = Depends(get_db)):
    return db_semesters.get_semester_by_id(id, db)
