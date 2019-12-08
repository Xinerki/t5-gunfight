#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
main()
{
	if(GetDvar( #"mapname") == "mp_background")
		return;
	
	maps\mp\gametypes\_globallogic::init();
	maps\mp\gametypes\_callbacksetup::SetupCallbacks();
	maps\mp\gametypes\_globallogic::SetupCallbacks();
	maps\mp\gametypes\_globallogic_utils::registerTimeLimitDvar( "duel", 10, 0, 1440 );
	maps\mp\gametypes\_globallogic_utils::registerScoreLimitDvar( "duel", 4, 0, 500 );
	maps\mp\gametypes\_globallogic_utils::registerRoundLimitDvar( "duel", 0, 0, 15 );
	maps\mp\gametypes\_globallogic_utils::registerRoundWinLimitDvar( "duel", 0, 0, 10 );
	maps\mp\gametypes\_globallogic_utils::registerNumLivesDvar( "duel", 1, 0, 10 );
	maps\mp\gametypes\_weapons::registerGrenadeLauncherDudDvar( level.gameType, 10, 0, 1440 );
	maps\mp\gametypes\_weapons::registerThrownGrenadeDudDvar( level.gameType, 0, 0, 1440 );
	maps\mp\gametypes\_weapons::registerKillstreakDelay( level.gameType, 0, 0, 1440 );
	maps\mp\gametypes\_globallogic::registerFriendlyFireDelay( level.gameType, 15, 0, 1440 );
	level.scoreRoundBased = true;
	level.teamBased = true;
	level.onStartGameType = ::onStartGameType;
	level.onSpawnPlayer = ::onSpawnPlayer;
	level.onSpawnPlayerUnified = ::onSpawnPlayerUnified;
	level.onPlayerKilled = ::onPlayerKilled;
	level.onDeadEvent = ::onDeadEvent;
	level.onRoundSwitch = ::onRoundSwitch;
	level.onRoundEndGame = ::onRoundEndGame;
	
	// level.giveCustomLoadout = ::giveCustomLoadout;
	
	game["dialog"]["gametype"] = "tdm_start";
	game["dialog"]["gametype_hardcore"] = "hctdm_start";
	game["dialog"]["offense_obj"] = "generic_boost";
	game["dialog"]["defense_obj"] = "generic_boost";
	
	
	setscoreboardcolumns( "kills", "deaths", "kdratio", "assists" ); 
}
onStartGameType()
{
	SetDvar( "scr_disable_weapondrop", 1 );
	SetDvar( "scr_game_perks", 0 );
	level.killstreaksenabled = 0;
	level.hardpointsenabled = 0;
	setDvar( "scr_xpscale", 0 );
	setDvar( "ui_allow_teamchange", 0 );
	makedvarserverinfo( "ui_allow_teamchange", 0 );
	setClientNameMode("auto_change");
	maps\mp\gametypes\_globallogic_ui::setObjectiveText( "allies", &"OBJECTIVES_TDM" );
	maps\mp\gametypes\_globallogic_ui::setObjectiveText( "axis", &"OBJECTIVES_TDM" );
	
	if ( level.splitscreen )
	{
		maps\mp\gametypes\_globallogic_ui::setObjectiveScoreText( "allies", &"OBJECTIVES_TDM" );
		maps\mp\gametypes\_globallogic_ui::setObjectiveScoreText( "axis", &"OBJECTIVES_TDM" );
	}
	else
	{
		maps\mp\gametypes\_globallogic_ui::setObjectiveScoreText( "allies", &"OBJECTIVES_TDM_SCORE" );
		maps\mp\gametypes\_globallogic_ui::setObjectiveScoreText( "axis", &"OBJECTIVES_TDM_SCORE" );
	}
	maps\mp\gametypes\_globallogic_ui::setObjectiveHintText( "allies", &"OBJECTIVES_TDM_HINT" );
	maps\mp\gametypes\_globallogic_ui::setObjectiveHintText( "axis", &"OBJECTIVES_TDM_HINT" );
	
	level.spawnMins = ( 0, 0, 0 );
	level.spawnMaxs = ( 0, 0, 0 );
	maps\mp\gametypes\_spawnlogic::placeSpawnPoints( "mp_tdm_spawn_allies_start" );
	maps\mp\gametypes\_spawnlogic::placeSpawnPoints( "mp_tdm_spawn_axis_start" );
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( "allies", "mp_tdm_spawn" );
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( "axis", "mp_tdm_spawn" );
	maps\mp\gametypes\_spawning::updateAllSpawnPoints();
	level.spawn_axis_start= maps\mp\gametypes\_spawnlogic::getSpawnpointArray("mp_tdm_spawn_axis_start");
	level.spawn_allies_start= maps\mp\gametypes\_spawnlogic::getSpawnpointArray("mp_tdm_spawn_allies_start");
	
	level.mapCenter = maps\mp\gametypes\_spawnlogic::findBoxCenter( level.spawnMins, level.spawnMaxs );
	setMapCenter( level.mapCenter );
	spawnpoint = maps\mp\gametypes\_spawnlogic::getRandomIntermissionPoint();
	setDemoIntermissionPoint( spawnpoint.origin, spawnpoint.angles );
	
	allowed[0] = "tdm";
	
	level.displayRoundEndText = false;
	maps\mp\gametypes\_gameobjects::main(allowed);
	
	
	maps\mp\gametypes\_spawning::create_map_placed_influencers();
	
	
	
	if ( !isOneRound() )
	{
		level.displayRoundEndText = true;
		if( isScoreRoundBased() )
		{
			maps\mp\gametypes\_globallogic_score::resetTeamScores();
		}
	}
}
onPlayerKilled(eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration)
{
	thread checkAllowSpectating();
}
onDeadEvent( team )
{	
	if ( team == game["attackers"] )
	{
		duel_endGameWithKillcam( game["defenders"], game["strings"][game["attackers"]+"_eliminated"] );
	}
	else if ( team == game["defenders"] )
	{
		duel_endGameWithKillcam( game["attackers"], game["strings"][game["defenders"]+"_eliminated"] );
	}
}
duel_endGame( winningTeam, endReasonText )
{
	if ( isdefined( winningTeam ) )
		[[level._setTeamScore]]( winningTeam, [[level._getTeamScore]]( winningTeam ) + 1 );
	
	thread maps\mp\gametypes\_globallogic::endGame( winningTeam, endReasonText );
}
duel_endGameWithKillcam( winningTeam, endReasonText )
{
	level thread maps\mp\gametypes\_killcam::startLastKillcam();
	duel_endgame( winningTeam, endReasonText );
}
checkAllowSpectating()
{
	wait ( 0.05 );
	
	update = false;
	livesLeft = !(level.numLives && !self.pers["lives"]);
	if ( !level.aliveCount[ game["attackers"] ] && !livesLeft )
	{
		level.spectateOverride[game["attackers"]].allowEnemySpectate = 1;
		update = true;
	}
	if ( !level.aliveCount[ game["defenders"] ] && !livesLeft )
	{
		level.spectateOverride[game["defenders"]].allowEnemySpectate = 1;
		update = true;
	}
	if ( update )
		maps\mp\gametypes\_spectating::updateSpectateSettings();
}
onRoundSwitch()
{
	if ( !isdefined( game["switchedsides"] ) )
		game["switchedsides"] = false;
	
	if ( game["teamScores"]["allies"] == level.scorelimit - 1 && game["teamScores"]["axis"] == level.scorelimit - 1 )
	{
		
		aheadTeam = getBetterTeam();
		if ( aheadTeam != game["defenders"] )
		{
			game["switchedsides"] = !game["switchedsides"];
		}
		else
		{
			level.halftimeSubCaption = "";
		}
		level.halftimeType = "overtime";
	}
	else
	{
		level.halftimeType = "halftime";
		game["switchedsides"] = !game["switchedsides"];
	}
}
getBetterTeam()
{
	kills["allies"] = 0;
	kills["axis"] = 0;
	deaths["allies"] = 0;
	deaths["axis"] = 0;
	
	for ( i = 0; i < level.players.size; i++ )
	{
		player = level.players[i];
		team = player.pers["team"];
		if ( isDefined( team ) && (team == "allies" || team == "axis") )
		{
			kills[ team ] += player.kills;
			deaths[ team ] += player.deaths;
		}
	}
	
	if ( kills["allies"] > kills["axis"] )
		return "allies";
	else if ( kills["axis"] > kills["allies"] )
		return "axis";
	
	
	if ( deaths["allies"] < deaths["axis"] )
		return "allies";
	else if ( deaths["axis"] < deaths["allies"] )
		return "axis";
	
	
	
	if ( randomint(2) == 0 )
		return "allies";
	return "axis";
}
onSpawnPlayerUnified()
{
	self.usingObj = undefined;
	
	if ( level.useStartSpawns && !level.inGracePeriod )
	{
		level.useStartSpawns = false;
	}
	
	maps\mp\gametypes\_spawning::onSpawnPlayer_Unified();
}
onSpawnPlayer()
{
	pixbeginevent("TDM:onSpawnPlayer");
	self.usingObj = undefined;
	if ( level.inGracePeriod )
	{
		spawnPoints = maps\mp\gametypes\_spawnlogic::getSpawnpointArray( "mp_tdm_spawn_" + self.pers["team"] + "_start" );
		
		if ( !spawnPoints.size )
			spawnPoints = maps\mp\gametypes\_spawnlogic::getSpawnpointArray( "mp_sab_spawn_" + self.pers["team"] + "_start" );
			
		if ( !spawnPoints.size )
		{
			spawnPoints = maps\mp\gametypes\_spawnlogic::getTeamSpawnPoints( self.pers["team"] );
			spawnPoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_NearTeam( spawnPoints );
		}
		else
		{
			spawnPoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random( spawnPoints );
		}		
	}
	else
	{
		spawnPoints = maps\mp\gametypes\_spawnlogic::getTeamSpawnPoints( self.pers["team"] );
		spawnPoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_NearTeam( spawnPoints );
	}
	
	self spawn( spawnPoint.origin, spawnPoint.angles, "tdm" );
	pixendevent();
}
onEndGame( winningTeam )
{
	if ( isdefined( winningTeam ) && (winningTeam == "allies" || winningTeam == "axis") )
		[[level._setTeamScore]]( winningTeam, [[level._getTeamScore]]( winningTeam ) + 1 );	
}
onRoundEndGame( roundWinner )
{
	if ( game["roundswon"]["allies"] == game["roundswon"]["axis"] )
		winner = "tie";
	else if ( game["roundswon"]["axis"] > game["roundswon"]["allies"] )
		winner = "axis";
	else
		winner = "allies";
	
	return winner;
}
onScoreCloseMusic()
{
    while( !level.gameEnded )
    {
        axisScore = [[level._getTeamScore]]( "axis" );
	    alliedScore = [[level._getTeamScore]]( "allies" );
	    scoreLimit = level.scoreLimit;
	    scoreThreshold = scoreLimit * .1;
	    scoreDif = abs(axisScore - alliedScore);
	    scoreThresholdStart = abs(scoreLimit - scoreThreshold);
	    scoreLimitCheck = scoreLimit - 10;
        
        if (alliedScore > axisScore)
	    {
		    currentScore = alliedScore;
	    }		
	    else
	    {
		    currentScore = axisScore;
	    }
        
        if ( scoreDif <= scoreThreshold && scoreThresholdStart <= currentScore )
	    {
		    
		    thread maps\mp\gametypes\_globallogic_audio::set_music_on_team( "TIME_OUT", "both" );
		    thread maps\mp\gametypes\_globallogic_audio::actionMusicSet();
		    return;
	    }
        
        wait(.5);
    }
} 
