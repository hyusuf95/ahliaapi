from routers import student, department, semester, reg, program
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from auth import authentication
from db.database import engine
from db import models

app = FastAPI()
app.include_router(authentication.router)
app.include_router(student.router)
app.include_router(semester.router)
app.include_router(department.router)
app.include_router(reg.router)
app.include_router(program.router)

origins = [
    'http://127.0.0.1:5500',
    '*'
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.get('/')
def index():
    return {'message': 'Welcome to Ahlia API - 2'}


models.Base.metadata.create_all(engine)
models.Base.prepare(engine, reflect=True)
