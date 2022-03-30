
from app.schemes import StudentDisplay
from db.models import DbCurriculum, DbSInfo
from sqlalchemy.orm import Session




def student_curriculum(current_student: StudentDisplay, db: Session):
    program = db.query(DbSInfo).filter(DbSInfo.student_id == current_student.student_id).first().program_id
    curriculum = db.query(DbCurriculum).filter(DbCurriculum.program_id == program).all()
    return curriculum