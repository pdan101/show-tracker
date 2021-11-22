import json
import os
from db import db
from flask import Flask
from db import Show
from db import Genre
from flask import request

app = Flask(__name__)
db_filename = "show-tracker.db"

app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///%s" % db_filename
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False
app.config["SQLALCHEMY_ECHO"] = True

db.init_app(app)
with app.app_context():
    db.create_all()


def success_response(data, code=200):
    return json.dumps(data), code


def failure_response(message, code=404):
    return json.dumps({"error": message}), code


@app.route("/")
def bruh():
    print("Hello World!")


@app.route("/api/watchlist/")
def get_shows():
    return success_response(
        {"shows": sorted([s.serialize() for s in Show.query.all()],
                         key=lambda show: show['finished'])}
    )


@app.route("/api/watchlist/releasesort/")
def get_shows_by_release_date():
    return success_response(
        {"shows": sorted([s.serialize() for s in Show.query.all()],
                         key=lambda show: show['year_released'])}
    )


@app.route("/api/genrelist/")
def get_genres():
    return success_response(
        {"genres": sorted([g.serialize() for g in Genre.query.all()],
                          key=lambda g: g['name'])}
    )


@app.route("/api/watchlist/", methods=["POST"])
def create_watchlist_show():
    body = json.loads(request.data)
    lst = ["name", "year_released", "start_date", "finished", "genre"]
    for field in lst:
        if field not in body:
            return failure_response("Necessary information not provided!", 400)
    find_genre = Genre.query.filter_by(name=body.get('genre')).first()
    if find_genre is None:
        find_genre = Genre(name=body.get('genre'))
        db.session.add(find_genre)
        db.session.commit()
    new_show = Show(name=body.get("name"), year_released=body.get("year_released"), start_date=body.get(
        "start_date"), finished=body.get("finished"), genre_id=find_genre.id)
    db.session.add(new_show)
    db.session.commit()

    return success_response(new_show.serialize(), 201)


@app.route("/api/watchlist/<int:show_id>/")
def get_show_by_id(show_id):
    show = Show.query.filter_by(id=show_id).first()
    if show is None:
        return failure_response("Show not found!")
    return success_response(show.serialize())


@app.route("/api/watchlist/<int:show_id>/", methods=["DELETE"])
def delete_watchlist_show(show_id):
    show = Show.query.filter_by(id=show_id).first()
    if show is None:
        return failure_response("Course not found!")
    db.session.delete(show)
    db.session.commit()
    return success_response(show.serialize())


if __name__ == "__main__":
    port = int(os.environ.get("PORT", 5000))
    app.run(host="0.0.0.0", port=port)


"""
-----FOR REFERENCE-----
@app.route("/api/courses/<int:course_id>/")
def get_course_by_id(course_id):
    course = Course.query.filter_by(id=course_id).first()
    if course is None:
        return failure_response("Course not found!")
    return success_response(course.serialize())


@app.route("/api/users/", methods=["POST"])
def create_user():
    body = json.loads(request.data)
    if "name" not in body or "netid" not in body:
        return failure_response("Necessary information not provided!", 400)
    new_user = User(name=body.get("name"), netid=body.get("netid"))
    db.session.add(new_user)
    db.session.commit()
    return success_response(new_user.serialize(), 201)


@app.route("/api/users/<int:user_id>/")
def get_user_by_id(user_id):
    user = User.query.filter_by(id=user_id).first()
    if user is None:
        return failure_response("User not found!")
    return success_response(user.serialize())


@app.route("/api/courses/<int:course_id>/add/", methods=["POST"])
def assign_user_to_course(course_id):
    course = Course.query.filter_by(id=course_id).first()
    if course is None:
        return failure_response("Course not found!")
    body = json.loads(request.data)
    user_id = body.get("user_id")
    user_type = body.get("type")
    if user_id is None or user_type is None:
        return failure_response("Necessary information not provided!", 400)
    user = User.query.filter_by(id=user_id).first()
    if user is None:
        return failure_response("User not found!")
    if user_type == "student":
        user.student_courses.append(course)
    if user_type == "instructor":
        user.instructor_courses.append(course)
    db.session.commit()
    return success_response(course.serialize())


@app.route("/api/courses/<int:course_id>/assignment/", methods=["POST"])
def create_assignment(course_id):
    course = Course.query.filter_by(id=course_id).first()
    if course is None:
        return failure_response("Course not found!")
    body = json.loads(request.data)
    if "title" not in body or "due_date" not in body:
        return failure_response("Necessary information not provided!", 400)
    new_assignment = Assignment(
        title=body.get("title"),
        due_date=body.get("due_date"),
        course_id=course_id
    )
    db.session.add(new_assignment)
    db.session.commit()
    return success_response(new_assignment.serialize(), 201)
"""
