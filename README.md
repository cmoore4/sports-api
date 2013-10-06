# Sports API v.1


This is the source code running the sports API.  Its everything needed to start running a local copy of the API.  Currently it supports only the NFL.  The first few days, it will simply be a sql file and reference documentation, no code.  Code will be written to fit the spec.

## Shared Paramters

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

Rate limiting will return the following response, and all other errors will follow this pattern.

*403*:

```json
{
	"error":{
		"error": 403,
		"message": "Rate limit exceeded",
		"description": "IP may not exceed 60 API calls a minute",
		"userMessage": "The application must wait before retrieving more information from the severs.",
		"code": "RATE:001"
	}
}
```

## Method List

- [teams](#teams)
- [players](#players)
- [roster](#players)


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
	"teams": [
		"<team_name>": {
			"city": <city:String>,
			"owner": <owner_name:String>,
			"headCoach": <head_coach_name:String>,
			"offensiveCoordinator": <oc_name:String>,
			"defensiveCoordinator": <dc_name:String>,
			"conference": <conference:EnumString>,
			"division": <division:EnumString>,
			"homeField": {
				"name": <venue_name:String>,
				"city": <venue_city:String>,
				"capacity": <venue_capacity:Int>
			},
			"established": <establishment_year:Int>,
			"divisionalStanding": <div_standing:Int>,
			"conferenceStanding": <con_standing:Int>
		},
		{...}
	]
}
```

**```division```**: NORTH, SOUTH, EAST, WEST

**```div_standing```**: 1-4

**```con_standing```**: 1-16


### players

| Method | URL    | Alias |
|:------ |:----- |:----- |
| GET    | ```players``` | |
| GET    | ```players/<playerid>``` | ```players?q=(id:<id>)``` |
| GET    | ```roster/<team_name>``` | ```players?q=(team:<team_name>)``` |
| GET    | ```players/<position>``` | ```players?q=(position:<position_abbr>)``` |

| Type   | Paramter  |  Options | Note |
|:------ |:--------- |:-------- |:---- |
| GET    | active    | false/true | Players signed to a team or practice squad, default true |
| GET    | history   | false/true | Include [history](#history) object within each player object |

By default, only active players, signed to a team and/or on the practive squad, are returned.

The roster method is provided for convenience, and allows either team id or team name as the second url paramter.

**Responses**

*200*:

```json
{
	"players":[
		{
			"lastname": <player_lastname:String>,
			"firstname": <player_firstname:String>,
			"number": <player_number:Int>
			"nickname": <player_nickname:String>,
			"position": <position_abbr:EnumString>,
			"team": <team_name:String>,
			"status": <player_status:EnumString>,
			"depth": <depth_number:Int>,
			"starter": <starter_boolean:Bool>,
			"draftNumber": <draft_position:Int>,
			"draftYear": <draft_year:Int>,
			"yearsActive": <years_active:Int>,
			"gamesPlayed": <games_played:Int>,
			"college": <college_name:String>,
			"retired": <retirement_year:Int>
		},
		{...}
	]
}
```

**```player_status```**: ACTIVE, INACTIVE, PRACTICE, IR, PUP

**```position_abbr```**: QB, RB, FB, WR, TE,OL, C, G, LG, RG, T, LT, RT,K, KR, OW,DL, DE, DT, NT,LB, ILB, OLB, MLB,DB, CB, FS, SS, S, P, PR

null will be returned for any value with untrusted or incomplete data. 0 is a valid value, as expected (for instance, practice squad players have 0 games played, but are active players).


