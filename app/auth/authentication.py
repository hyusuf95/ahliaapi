from fastapi import APIRouter, HTTPException, status
from fastapi.param_functions import Depends
from fastapi.security.oauth2 import OAuth2PasswordRequestForm
from sqlalchemy.orm.session import Session
from db.database import get_db
from db import models
from db.hash import Hash
from auth import oauth2

router = APIRouter(
    tags=['authentication']
)


#   return {
#     'access_token': access_token,
#     'token_type': 'bearer',
#     'user_id': user.id,
#     'username': user.username
#   }


@router.post('/token')
def get_token(request: OAuth2PasswordRequestForm = Depends(), db: Session = Depends(get_db)):
    student = db.query(models.DbStudent).filter(
        models.DbStudent.username == request.username).first()
    if not student:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="Student Not Found!")
    if not Hash.verify(student.info.password, request.password):
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="Incorrect password")

    access_token = oauth2.create_access_token(data={'sub': student.username})

    return {
        'access_token': access_token,
        'token_type': 'bearer',
        'user_id': student.student_id
    }
