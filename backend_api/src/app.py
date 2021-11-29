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
        {"shows": sorted([s.serialize_watch() for s in Show.query.filter_by(is_plan_to_watch=False)],
                         key=lambda show: show['finished'])}
    )


@app.route("/api/watchlist/releasesort/")
def get_shows_by_release_date():
    return success_response(
        {"shows": sorted([s.serialize_watch() for s in Show.query.filter_by(is_plan_to_watch=False)],
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
        "start_date"), finished=body.get("finished"), genre_id=find_genre.id, is_plan_to_watch=False)
    db.session.add(new_show)
    db.session.commit()

    return success_response(new_show.serialize(), 201)


@app.route("/api/watchlist/<int:show_id>/")
def get_show_by_id(show_id):
    show = Show.query.filter_by(id=show_id).first()
    if show is None or show.is_plan_to_watch:
        return failure_response("Show not found!")
    return success_response(show.serialize_watch())


@app.route("/api/watchlist/<int:show_id>/", methods=["DELETE"])
def delete_watchlist_show(show_id):
    show = Show.query.filter_by(id=show_id).first()
    if show is None or show.is_plan_to_watch:
        return failure_response("Show not found!")
    db.session.delete(show)
    db.session.commit()
    return success_response(show.serialize_watch())



@app.route("/api/planlist/")
def get_shows_by_release_date_plan():
    return success_response(
        {"shows": sorted([s.serialize_plan() for s in Show.query.filter_by(is_plan_to_watch=True)],
                         key=lambda show: show['year_released'])}
    )

@app.route("/api/planlist/", methods=["POST"])
def create_planlist_show():
    body = json.loads(request.data)
    lst = ["name", "year_released", "genre"]
    for field in lst:
        if field not in body:
            return failure_response("Necessary information not provided!", 400)
    find_genre = Genre.query.filter_by(name=body.get('genre')).first()
    if find_genre is None:
        find_genre = Genre(name=body.get('genre'))
        db.session.add(find_genre)
        db.session.commit()
    new_show = Show(name=body.get("name"), year_released=body.get("year_released"), genre_id=find_genre.id, is_plan_to_watch=True)
    db.session.add(new_show)
    db.session.commit()

    return success_response(new_show.serialize_plan(), 201)


@app.route("/api/planlist/<int:show_id>/")
def get_show_by_id_plan(show_id):
    show = Show.query.filter_by(id=show_id).first()
    if show is None or not show.is_plan_to_watch:
        return failure_response("Show not found!")
    return success_response(show.serialize_plan())


@app.route("/api/planlist/<int:show_id>/", methods=["DELETE"])
def delete_planlist_show(show_id):
    show = Show.query.filter_by(id=show_id).first()
    if show is None or not show.is_plan_to_watch:
        return failure_response("Show not found!")
    db.session.delete(show)
    db.session.commit()
    return success_response(show.serialize_plan())

if __name__ == "__main__":
    port = int(os.environ.get("PORT", 5000))
    app.run(host="0.0.0.0", port=port)

