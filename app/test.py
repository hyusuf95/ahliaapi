
from db.models import DbOfferTime, DbOffer
from db.database import engine, session as db
from db import models 
# from db.db_semesters import open_regestration_semester



models.Base.metadata.create_all(engine)
models.Base.prepare(engine, reflect=True)





#[{'day': 'u', 'start_time': '15:00', 'end_time': '16:40'}, {'day': 't', 'start_time': '15:00', 'end_time': '16:40'}]

# select offer_times.day, offer_times.start_time, offer_times.end_time from offer_times
# join offered_course on offer_times.offer_id = offered_course.offer_id where offered_course.course_id='ITCS 404'
# and offered_course.semester_id = 7;



