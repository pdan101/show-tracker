import json
import os
from db import db
from flask import Flask
from db import Course
from db import Assignment
from db import User
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

# your routes here
@app.route("/api/courses/")
def get_courses():
    return success_response(
        {"courses": [c.serialize() for c in Course.query.all()]}
    )


@app.route("/api/courses/", methods=["POST"])
def create_course():
    body = json.loads(request.data)
    if "code" not in body or "name" not in body:
        return failure_response("Necessary information not provided!", 400)
    new_course = Course(code=body.get("code"), name=body.get("name"))
    db.session.add(new_course)
    db.session.commit()
    return success_response(new_course.serialize(), 201)

@app.route("/api/courses/<int:course_id>/")
def get_course_by_id(course_id):
    course = Course.query.filter_by(id=course_id).first()
    if course is None:
        return failure_response("Course not found!")
    return success_response(course.serialize())

@app.route("/api/courses/<int:course_id>/", methods=["DELETE"])
def delete_course(course_id):
    course = Course.query.filter_by(id=course_id).first()
    if course is None:
        return failure_response("Course not found!")
    db.session.delete(course)
    db.session.commit()
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




if __name__ == "__main__":
    port = int(os.environ.get("PORT", 5000))	
    app.run(host="0.0.0.0", port=port)
