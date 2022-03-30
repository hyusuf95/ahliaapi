from typing import List
from fastapi import APIRouter, Depends
from auth.oauth2 import get_current_student
from db.database import get_db
from sqlalchemy.orm import Session
from schemes import StudentDisplay, RegestrationDisplay
from db import db_reg




router = APIRouter(
    prefix='/registration',
    tags=["Registration"]
)




@router.get('/registered',
summary="Get courses that are registered for next semester",
response_model=List[RegestrationDisplay]
)
def next_reg(current_student: StudentDisplay = Depends(get_current_student), db:Session=Depends(get_db)):
    return db_reg.next_reg(current_student, db)


@router.post('/add/{offer_id}')
def register_course(offer_id:int, current_student: StudentDisplay = Depends(get_current_student), db:Session=Depends(get_db)):
    return db_reg.register_course(current_student, db, offer_id)






@router.delete('/delete/{offer_id}')
def drop_course(offer_id:int, current_student: StudentDisplay = Depends(get_current_student), db:Session=Depends(get_db)):
    return db_reg.drop_course(current_student, db, offer_id)