from flask_sqlalchemy import SQLAlchemy
import requests
from dotenv import load_dotenv
import os

db = SQLAlchemy()

load_dotenv()
key = os.getenv('KEY')
base_url = 'https://pixabay.com/api/'


class Show(db.Model):
    __tablename__ = "show"
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String, nullable=False)
    year_released = db.Column(db.Integer, nullable=False)
    start_date = db.Column(db.String, nullable=True)
    finished = db.Column(db.Boolean, nullable=True)
    genre_id = db.Column(db.Integer, db.ForeignKey("genre.id"), nullable=False)
    is_plan_to_watch = db.Column(db.Boolean, nullable=False)
    user_id = db.Column(db.Integer, db.ForeignKey("user.id"), nullable=False)
    image_url = db.Column(db.String, nullable=True)

    def __init__(self, **kwargs):
        self.name = kwargs.get("name")
        self.year_released = kwargs.get("year_released")
        self.start_date = kwargs.get("start_date")
        self.finished = kwargs.get("finished")
        self.genre_id = kwargs.get("genre_id")
        self.is_plan_to_watch = kwargs.get("is_plan_to_watch")
        self.user_id = kwargs.get("user_id")
        payload = {'key': key,
                   'q': "+".join(self.name.split()), 'image_type': "photo"}
        r = requests.get(base_url, params=payload)
        try:
            self.image_url = r.json().get('hits')[0].get('largeImageURL')
        except Exception as e:
            self.image_url = 'https://st4.depositphotos.com/14953852/22772/v/600/depositphotos_227725020-stock-illustration-image-available-icon-flat-vector.jpg'

    def serialize(self):
        if not self.is_plan_to_watch:
            return {
                "id": self.id,
                "name": self.name,
                "genre": Genre.query.filter_by(id=self.genre_id).first().name,
                "year_released": self.year_released,
                "start_date": self.start_date,
                "finished": self.finished,
                "image_url": self.image_url
            }
        else:
            return {
                "id": self.id,
                "name": self.name,
                "genre": Genre.query.filter_by(id=self.genre_id).first().name,
                "year_released": self.year_released,
                "image_url": self.image_url
            }

    def serialize_watch(self):
        return {
            "id": self.id,
            "name": self.name,
            "genre": Genre.query.filter_by(id=self.genre_id).first().name,
            "year_released": self.year_released,
            "start_date": self.start_date,
            "finished": self.finished,
            "image_url": self.image_url
        }

    def serialize_plan(self):
        return {
            "id": self.id,
            "name": self.name,
            "genre": Genre.query.filter_by(id=self.genre_id).first().name,
            "year_released": self.year_released,
            "image_url": self.image_url
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
            "shows": [s.serialize_plan() for s in self.shows]
        }


class User(db.Model):
    __tablename__ = "user"
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String, nullable=False)
    shows = db.relationship("Show", cascade="delete")

    def __init__(self, **kwargs):
        self.username = kwargs.get("username")

    def serialize(self):
        return {
            "id": self.id,
            "username": self.username,
        }
