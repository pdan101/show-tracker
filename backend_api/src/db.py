from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()

# your classes here
instructor_association_table = db.Table(
  "instructor_association",
  db.Model.metadata,
  db.Column("course_id", db.Integer, db.ForeignKey("course.id")),
  db.Column("instructor_id", db.Integer, db.ForeignKey("user.id"))
)

student_association_table = db.Table(
  "student_association",
  db.Model.metadata,
  db.Column("course_id", db.Integer, db.ForeignKey("course.id")),
  db.Column("student_id", db.Integer, db.ForeignKey("user.id"))
)

class Course(db.Model):
    __tablename__ = "course"
    id = db.Column(db.Integer, primary_key=True)
    code = db.Column(db.String, nullable=False)
    name = db.Column(db.String, nullable=False)
    assignments = db.relationship("Assignment", cascade="delete")
    instructors = db.relationship(
        "User", secondary=instructor_association_table, back_populates="instructor_courses"
    )
    students = db.relationship(
        "User", secondary=student_association_table, back_populates="student_courses"
    )

    def __init__(self, **kwargs):
        self.code = kwargs.get("code")
        self.name = kwargs.get("name")

    def serialize(self):
        return {
            "id": self.id,
            "code": self.code,
            "name": self.name,
            "assignments": [a.a_serialize() for a in self.assignments],
            "instructors": [i.i_serialize() for i in self.instructors],
            "students": [s.i_serialize() for s in self.students]
        }

    def c_serialize(self):
        return {
            "id": self.id,
            "code": self.code,
            "name": self.name
        }

    def c2_serialize(self):
        return {
            "id": self.id,
            "code": self.code,
            "name": self.name,
            "assignments": [a.a_serialize() for a in self.assignments]
        }
      

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

# make a table with users (name, netid)
class User(db.Model):
    __tablename__ = "user"
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String, nullable=False)
    netid = db.Column(db.String, nullable=False)
    instructor_courses = db.relationship(
        "Course", secondary=instructor_association_table, back_populates="instructors"
    )
    student_courses = db.relationship(
        "Course", secondary=student_association_table, back_populates="students"
    )

    def __init__(self, **kwargs):
        self.name = kwargs.get("name")
        self.netid = kwargs.get("netid")

    def serialize(self):
        return {
            "id": self.id,
            "name": self.name,
            "netid": self.netid,
            "courses": [c.c2_serialize() for c in self.instructor_courses] + [c.c2_serialize() for c in self.student_courses]
        }

    def i_serialize(self):
        return {
            "id": self.id,
            "name": self.name,
            "netid": self.netid
        }