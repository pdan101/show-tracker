Names: Prithwish Dan, Joyce Wu
NetIDs: pd337, jyw55

Server Address: TBD

Routes:
GET /api/watchlist/

GET /api/planlist/

POST /api/watchlist/
Request Body:
{
  "name": "Arcane",
  "genre": "Science Fantasy",
  "year_released": 2021,
  "start_date": "11/20/2021",
  "finished": false
}

POST /api/planlist/
Request Body:
{
  "name": "Squid Game",
  "genre": "Thriller",
  "year_released": 2021
}
