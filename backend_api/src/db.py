from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()


class Show(db.Model):
    __tablename__ = "show"
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String, nullable=False)
    year_released = db.Column(db.Integer, nullable=False)
    start_date = db.Column(db.String, nullable=False)
    finished = db.Column(db.Boolean, nullable=False)
    genre_id = db.Column(db.Integer, db.ForeignKey("genre.id"), nullable=False)

    def __init__(self, **kwargs):
        self.name = kwargs.get("name")
        self.year_released = kwargs.get("year_released")
        self.start_date = kwargs.get("start_date")
        self.finished = kwargs.get("finished")
        self.genre_id = kwargs.get("genre_id")

    def serialize(self):
        return {
            "id": self.id,
            "name": self.name,
            "genre": Genre.query.filter_by(id=self.genre_id).first().name,
            "year_released": self.year_released,
            "start_date": self.start_date,
            "finished": self.finished
        }


class Genre(db.Model):
    __tablename__ = "genre"
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String, nullable=False)
    shows = db.relationship(
        "Show", cascade="delete"
    )

    def __init__(self, **kwargs):
        self.name = kwargs.get("name")

    def serialize(self):
        return {
            "id": self.id,
            "name": self.name,
            "shows": [s.serialize() for s in self.shows]
        }


"""
-----FOR REFERENCE-----
class Assignment(db.Model):
    __tablename__ = "assignment"
    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String, nullable=False)
    due_date = db.Column(db.Integer, nullable=False)
    course_id = db.Column(db.Integer, db.ForeignKey("course.id"))

    def __init__(self, **kwargs):
        self.title = kwargs.get("title")
        self.due_date = kwargs.get("due_date")
        self.course_id = kwargs.get("course_id")

    def serialize(self):
        return {
            "id": self.id,
            "title": self.title,
            "due_date": self.due_date,
            "course": (Course.query.filter_by(id=self.course_id).first()).c_serialize()
        }

    def a_serialize(self):
        return {
            "id": self.id,
            "title": self.title,
            "due_date": self.due_date
        }
"""
