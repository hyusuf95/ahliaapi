from sqlalchemy.orm import Session
from db.models import DbSemester
import exceptionsHandler
from fastapi import HTTPException, status


def get_all_semesters(db: Session):
    return db.query(DbSemester).all()


def get_current_semester(db: Session):
    activeSemester = db.query(DbSemester).filter(
        DbSemester.isactive == True).first()
    if (activeSemester):
        return activeSemester
    else:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND,
                            detail="There are no active semesters")


def open_regestration_semester(db: Session):
    activeSemester = db.query(DbSemester).filter(
        DbSemester.registration_open == True).first()
    if (activeSemester):
        return activeSemester
    else:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND,
                            detail="Regestration is closed")


def get_semester_by_id(id: int, db: Session):
    semester = db.query(DbSemester).filter(
        DbSemester.semester_id == id).first()
    exceptionsHandler.handle_not_found(semester)
    return semester
