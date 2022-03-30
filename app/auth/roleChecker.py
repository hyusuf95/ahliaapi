
from typing import List
from fastapi import Depends, logger, HTTPException, status
from auth.oauth2 import get_current_student
from db.models import DbStudent


class RoleChecker:
    def __init__(self, allowed_roles: List):
        self.allowed_roles = allowed_roles

    def __call__(self, user: DbStudent = Depends(get_current_student)):
        if user.info.role not in self.allowed_roles:
            raise HTTPException(status_code=status.HTTP_403_FORBIDDEN,
                                detail=f"User {user.fname} in ({user.info.role}) group do not have access to this resource")
