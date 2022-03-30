from fastapi import HTTPException, status
from sqlalchemy.orm import Session
import exceptionsHandler as ex
from db.models import DbOffer, DbRegestration
from  schemes import StudentDisplay
from db.db_semesters import open_regestration_semester




def next_reg(current_student: StudentDisplay, db: Session):
    opened_semester = open_regestration_semester(db)
    return db.query(DbRegestration).filter(DbRegestration.semester_id == opened_semester.semester_id).filter(DbRegestration.student_id == current_student.student_id).all()



def register_course(current_student: StudentDisplay, db: Session, offerid: int):
    opened_semester = open_regestration_semester(db)
    Offer = db.query(DbOffer).filter(DbOffer.offer_id == offerid).first()
    if not (Offer):
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=f"Offer ID {offerid} not found")
    ex.handle_adding_course(Offer, current_student, db)
    new_reg = DbRegestration(
        student_id = current_student.student_id,
        semester_id = opened_semester.semester_id,
        offer_id = offerid
    )

    db.add(new_reg)
    db.commit()
    db.refresh(new_reg)

    return {"msg": f"Course {Offer.course_id} Registered Succesfully"}




def drop_course(current_student: StudentDisplay, db: Session, offerid: int):
    opened_semester = open_regestration_semester(db)
    Offer = db.query(DbOffer).filter(DbOffer.offer_id == offerid).first()
    if not (Offer):
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=f"Offer ID {offerid} not found")
    
    reg = db.query(DbRegestration).filter(DbRegestration.student_id == current_student.student_id).filter(DbRegestration.offer_id == offerid).first()

    if not (reg):
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Course Can not be dropped because it is not registered.")

    db.delete(reg)
    db.commit()
    return {"msg": "Course Dropped Successfully"}
