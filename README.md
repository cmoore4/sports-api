# Sports API v.1


This is the source code running the sports API.  It's everything needed to start running a local copy of the API.  Currently it supports only the NFL.  The first few days, it will simply be a sql file and reference documentation, no code.  Code will be written to fit the spec.

## Methods

Base url: http://api.example.com/v1/football/nfl/

Common params:

*fields* - a comma separated list of fields, surrounded by parenthesis, of fields to return

ex: teams/123?fields=(headCoach,venue)

*limit* - the maximum number of response objecs to return.  This cannot exceed the limit imposed by the API itself.

ex: limit=50

*offset* - the number of results to exclude from the front of the list. The first result will be the n+1th result.

ex: offset=50

*type* - the format of the return object.  Most methods support xml, json, and csv by default.

*suppress_error_codes* - can be set to true in order to always return a 200 HTTP response code instead of the proper HTTP response code.  Error messages will still be included in the response object.


### teams


| Method | URL    | Alias |
|:------ |:----- |:----- |
| GET    | ```teams``` | |
| GET    | ```teams/afc``` | ```teams?q=(conference:afc)``` |
| GET    | ```teams/nfc``` | ```teams?q=(conference:nfc)``` |
| GET    | ```teams/afc/<division>``` | ```teams?q=(conference:afc,division:<division>)``` |
| GET    | ```teams/nfc/<division>``` | ```teams?q=(conference:nfc,division:<division>)``` |
| GET    | ```teams/<id>``` | ```teams?q=(id:<id>)``` |
| GET    | ```teams/<name>``` | ```teams?q=(name:<team_name>)``` |

**Responses**

*200*:

```json
{
	"<team_name>": {
		"city": <city>,
		"owner": <owner_name>,
		"headCoach": <head_coach_name>,
		"offensiveCoordinator": <oc_name>,
		"defensiveCoordinator": <dc_name>,
		"conference": <conference>,
		"division": <division>,
		"homeField": {
			"name": <venue_name>,
			"city": <venue_city>,
			"capacity": <venue_capacity>
		},
		"established": <establishment_year>,
		"divisionalStanding": <div_standing>,
		"conferenceStanding": <con_standing>
	}
}
```

**```division```**: NORTH, SOUTH, EAST, WEST

**```div_standing```**: 1-4

**```con_standing```**: 1-16


*403*:

```json
{
	"error":{
		"error": 403,
		"message": "Rate limit exceeded",
		"description": "IP may not exceed 60 API calls a minute",
		"userMessage": "The application must wait before retrieveing more information from the severs.",
		"code": "RATE:001"
	}
}
```

### players

| Method | URL    | Alias |
|:------ |:----- |:----- |
| GET    | ```players``` | |
| GET    | ```players/<playerid>``` | ```players?q=(id:<id>)``` |
| GET    | ```roster/<team_name>``` | ```players?q=(team:<team_name>)``` |
| GET    | ```players/<position>``` | ```players?q=(position:<position_abbr>)``` |

**Responses**

*200*:

```json
{
	"players":[
		{
			"lastname": <player_lastname>,
			"firstname": <player_firstname>,
			"nickname": <player_nickname>,
			"position": <position_abbr>,
			"team": <team_name>,
			"status": <player_status>
		}
	]
}
```

**```player_status```**: ACTIVE, INACTIVE, PRACTICE, IR, PUP
