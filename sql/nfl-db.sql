CREATE SEQUENCE uniqueid;

CREATE TABLE venues (
	id integer NOT NULL UNIQUE DEFAULT nextval('uniqueid'),
	name varchar(120) NOT NULL,
	city varchar(60) NOT NULL,
	capacity integer
);

CREATE TABLE teams (
	id integer NOT NULL UNIQUE DEFAULT nextval('uniqueid'),
	name varchar(60) NOT NULL,
	city varchar(60) NOT NULL,
	owner varchar(80),
	head_coach varchar(80),
	offensive_coordinator varchar(80),
	defensive_coordinator varchar(80),
	conference varchar(3) NOT NULL,
	division varchar(5) NOT NULL,
	home_venue_id integer,
	established integer DEFAULT NULL,
	divisional_standing integer DEFAULT NULL,
	conference_standing integer DEFAULT NULL,
	CONSTRAINT team_home_venue_fk FOREIGN KEY (home_venue_id)
		REFERENCES venues(id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TYPE player_status AS ENUM ('ACTIVE', 'INACTIVE', 'PRACTICE', 'IR', 'PUP');
CREATE TYPE position_abbr AS ENUM (
	'QB', 'RB', 'FB', 'WR', 'TE',
	'OL', 'C', 'G', 'LG', 'RG', 'T', 'LT', 'RT',
	'K', 'KR', 'OW',
	'DL', 'DE', 'DT', 'NT',
	'LB', 'ILB', 'OLB', 'MLB',
	'DB', 'CB', 'FS', 'SS', 'S', 'P', 'PR'
);
CREATE TABLE players (
	id integer NOT NULL UNIQUE DEFAULT nextval('uniqueid'),
	lastname varchar(80) NOT NULL,
	firstname varchar(80) NOT NULL,
	position position_abbr NULL,
	team_id integer DEFAULT NULL,
	status player_status DEFAULT NULL,
	depth varchar(20) DEFAULT null,
	starter boolean DEFAULT false,
	draft_position integer DEFAULT 0,
	college varchar(256) DEFAULT null,
	CONSTRAINT players_team_fk FOREIGN KEY (team_id)
		REFERENCES teams(id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE player_histories (
	player_id integer,
	team_id integer,
	start_date date DEFAULT NULL,
	end_date date DEFAULT NULL,
	position position_abbr DEFAULT NULL,
	CONSTRAINT players_history_player_fk FOREIGN KEY (player_id)
		REFERENCES players(id) ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT players_history_team_fk FOREIGN KEY (team_id)
		REFERENCES teams(id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE games (
	id integer NOT NULL UNIQUE DEFAULT nextval('uniqueid'),
	venue_id integer DEFAULT NULL,
	completed boolean DEFAULT false,
	active boolean DEFAULT false,
	kickoff_time timestamp DEFAULT NULL,
	home_team_id integer NOT NULL,
	away_team_id integer NOT NULL,
	home_score integer DEFAULT NULL,
	away_score integer DEFAULT NULL,
	playoff boolean DEFAULT false,
	season integer NOT NULL,
	season_week integer DEFAULT NULL,
	CONSTRAINT games_home_team_fk FOREIGN KEY (home_team_id)
		REFERENCES teams(id) ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT games_away_team_fk FOREIGN KEY (away_team_id)
		REFERENCES teams(id) ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT games_venue_fk FOREIGN KEY (venue_id)
		REFERENCES venues(id) ON UPDATE CASCADE ON DELETE CASCADE
);