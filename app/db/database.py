from sqlalchemy.ext.automap import automap_base
from sqlalchemy.orm import sessionmaker, Session
from sqlalchemy import create_engine
from configparser import ConfigParser



config = ConfigParser()
config.read('app/config/config.ini')

username = config['Database']['username']
password = config['Database']['password']
server = config['Database']['server']
dbname = config['Database']['dbname']
port = config['Database']['port']

engine = create_engine(f'postgresql+psycopg2://{username}:{password}@{server}:{port}/{dbname}')
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
session = Session(engine)


Base = automap_base()


def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
