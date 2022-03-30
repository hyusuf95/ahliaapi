from sqlalchemy.orm import Session
from db.models import DbDepartment


def get_all_departments(db: Session):
    return db.query(DbDepartment).all()
