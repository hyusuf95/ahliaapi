from typing import List
from fastapi import APIRouter, Depends
from db import db_department
from db.database import get_db
from sqlalchemy.orm import Session
from auth.roleChecker import RoleChecker
from schemes import DepartmentDisplay
allow_create_resource = RoleChecker(["student"])


router = APIRouter(
    prefix='/department',
    tags=['department'],
    dependencies=[Depends(allow_create_resource)]
)


@router.get('/all', response_model=List[DepartmentDisplay])
def get_all_departments(db: Session = Depends(get_db)):
    return db_department.get_all_departments(db)
