from sqlalchemy.orm import Session
from db.models import DbCollege
from schemes import CollegeBase


def get_all_colleges(db: Session):
    return db.query(DbCollege).all()
