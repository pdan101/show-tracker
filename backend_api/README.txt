Names: Prithwish Dan, Joyce Wu
NetIDs: pd337, jyw55

Server Address: TBD (http://0.0.0.0:5000/ for now when running app.py)

Routes:
GET /api/watchlist/

POST /api/watchlist/
Request Body:
{
  "name": "Arcane",
  "genre": "Science Fantasy",
  "year_released": 2021,
  "start_date": "11/20/2021",
  "finished": false
}

DELETE /api/watchlist/<int:show_id>/
