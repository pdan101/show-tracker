from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()


class Show(db.Model):
    __tablename__ = "show"
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String, nullable=False)
    year_released = db.Column(db.Integer, nullable=False)
    start_date = db.Column(db.String, nullable=True)
    finished = db.Column(db.Boolean, nullable=True)
    genre_id = db.Column(db.Integer, db.ForeignKey("genre.id"), nullable=False)
    is_plan_to_watch = db.Column(db.Boolean, nullable=False)

    def __init__(self, **kwargs):
        self.name = kwargs.get("name")
        self.year_released = kwargs.get("year_released")
        self.start_date = kwargs.get("start_date")
        self.finished = kwargs.get("finished")
        self.genre_id = kwargs.get("genre_id")
        self.is_plan_to_watch = kwargs.get("is_plan_to_watch")

    def serialize(self):
        if not self.is_plan_to_watch:
            return {
                "id": self.id,
                "name": self.name,
                "genre": Genre.query.filter_by(id=self.genre_id).first().name,
                "year_released": self.year_released,
                "start_date": self.start_date,
                "finished": self.finished
            }
        else:
            return {
                "id": self.id,
                "name": self.name,
                "genre": Genre.query.filter_by(id=self.genre_id).first().name,
                "year_released": self.year_released
            }

    def serialize_watch(self):
        return {
            "id": self.id,
            "name": self.name,
            "genre": Genre.query.filter_by(id=self.genre_id).first().name,
            "year_released": self.year_released,
            "start_date": self.start_date,
            "finished": self.finished
        }

    def serialize_plan(self):
        return {
            "id": self.id,
            "name": self.name,
            "genre": Genre.query.filter_by(id=self.genre_id).first().name,
            "year_released": self.year_released
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
