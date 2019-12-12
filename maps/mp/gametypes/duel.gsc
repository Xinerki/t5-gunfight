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

	// maps\mp\gametypes\_globallogic_utils::registerRoundSwitchDvar( level.gameType, 3, 0, 9 );
	maps\mp\gametypes\_globallogic_utils::registerTimeLimitDvar( level.gameType, 10, 0, 1440 );
	maps\mp\gametypes\_globallogic_utils::registerScoreLimitDvar( level.gameType, 0, 0, 500 );
	maps\mp\gametypes\_globallogic_utils::registerRoundLimitDvar( level.gameType, 0, 0, 15 );
	maps\mp\gametypes\_globallogic_utils::registerRoundWinLimitDvar( level.gameType, 6, 0, 10 );
	maps\mp\gametypes\_globallogic_utils::registerNumLivesDvar( level.gameType, 1, 0, 10 );

	maps\mp\gametypes\_weapons::registerGrenadeLauncherDudDvar( level.gameType, 10, 0, 1440 );
	maps\mp\gametypes\_weapons::registerThrownGrenadeDudDvar( level.gameType, 0, 0, 1440 );
	maps\mp\gametypes\_weapons::registerKillstreakDelay( level.gameType, 0, 0, 1440 );
	maps\mp\gametypes\_globallogic::registerFriendlyFireDelay( level.gameType, 15, 0, 1440 );
	
	level.teamBased = true;
	level.overrideTeamScore = true;
	// level.scoreRoundBased = true;
	level.onStartGameType = ::onStartGameType;
	level.onSpawnPlayer = ::onSpawnPlayer;
	level.onSpawnPlayerUnified = ::onSpawnPlayerUnified;
	level.onRoundEndGame = ::onRoundEndGame;
	level.onDeadEvent = ::onDeadEvent;
	
	// currentWeapon = getRandomGunFromProgression();
	
	
	level.giveCustomLoadout = ::giveCustomLoadout;
	
	game["dialog"]["gametype"] = "tdm_start";
	game["dialog"]["gametype_hardcore"] = "hctdm_start";
	game["dialog"]["offense_obj"] = "generic_boost";
	game["dialog"]["defense_obj"] = "generic_boost";
	
	// addGunToProgression( "python_speed_mp" );
	// addGunToProgression( "makarovdw_mp" );
	// addGunToProgression( "spas_mp" );
	// addGunToProgression( "ithaca_mp" );
	// addGunToProgression( "mp5k_mp" );
	// addGunToProgression( "skorpiondw_mp" );
	// addGunToProgression( "ak74u_mp" );
	// addGunToProgression( "m14_mp" );
	// addGunToProgression( "m16_mp" );
	// addGunToProgression( "famas_mp" );
	// addGunToProgression( "aug_mp" );
	// addGunToProgression( "hk21_mp" );
	// addGunToProgression( "m60_mp" );
	// addGunToProgression( "l96a1_mp" );
	// addGunToProgression( "wa2000_mp" );
	// addGunToProgression( "m202_flash_wager_mp" );
	// addGunToProgression( "m72_law_mp" );
	// addGunToProgression( "china_lake_mp" );
	// addGunToProgression( "crossbow_explosive_mp", "explosive_bolt_mp" );
	// addGunToProgression( "knife_ballistic_mp" );
	
	// SMGS
	addPrimaryToList ( "mp5k" );
	addPrimaryToList ( "uzi" );
	addPrimaryToList ( "mpl" );
	addPrimaryToList ( "mac11" );

	// SHOTGUNS
	addPrimaryToList ( "spas" );
	addPrimaryToList ( "ithaca_grip" );
	addPrimaryToList ( "rottweil72" );

	// RIFLES
	addPrimaryToList ( "m14" );
	addPrimaryToList ( "l96a1" );
	addPrimaryToList ( "psg1_acog" );

	// ASSAULT RIFLES
	addPrimaryToList ( "ak47" );
	addPrimaryToList ( "m16" );
	addPrimaryToList ( "famas" );
	addPrimaryToList ( "commando" );
	addPrimaryToList ( "galil" );

	// LMGS
	addPrimaryToList ( "stoner63" ); // this is an lmg trust me
	addPrimaryToList ( "hk21" );
	
	// SPECIAL
	addPrimaryToList ( "china_lake" );
	addPrimaryToList ( "crossbow_explosive", "explosive_bolt" );
	
	// SECONDARIES
	addSecondaryToList( "python_speed" );
	addSecondaryToList( "makarov_upgradesight" );
	addSecondaryToList( "m1911_upgradesight" );
	addSecondaryToList( "cz75_upgradesight" );
	// addSecondaryToList( "knife_ballistic_mp" );
	
	// LETHAL THROWABLES
	addLethalToList( "frag_grenade" );
	addLethalToList( "sticky_grenade" );
	addLethalToList( "hatchet" );
	//addLethalToList( "claymore_mp" );
	
	setscoreboardcolumns( "kills", "deaths", "assists" ); 
}
addPrimaryToList( gunName, altName )
{
	if ( !IsDefined( level.primaryList ) )
		level.primaryList = [];
	
	newWeapon = SpawnStruct();
	newWeapon.names = [];
	newWeapon.names[newWeapon.names.size] = gunName;
	if ( IsDefined( altName ) )
		newWeapon.names[newWeapon.names.size] = altName;
	level.primaryList[level.primaryList.size] = newWeapon;
}
addSecondaryToList( gunName, altName )
{
	if ( !IsDefined( level.secondaryList ) )
		level.secondaryList = [];
	
	newWeapon = SpawnStruct();
	newWeapon.names = [];
	newWeapon.names[newWeapon.names.size] = gunName;
	if ( IsDefined( altName ) )
		newWeapon.names[newWeapon.names.size] = altName;
	level.secondaryList[level.secondaryList.size] = newWeapon;
}
addLethalToList( gunName, altName )
{
	if ( !IsDefined( level.lethalList ) )
		level.lethalList = [];
	
	newWeapon = SpawnStruct();
	newWeapon.names = [];
	newWeapon.names[newWeapon.names.size] = gunName;
	if ( IsDefined( altName ) )
		newWeapon.names[newWeapon.names.size] = altName;
	level.lethalList[level.lethalList.size] = newWeapon;
}
giveCustomLoadout( takeAllWeapons, alreadySpawned )
{
	// if ( !IsDefined( gunCycle ) )
		// gunCycle = 1;
	
	chooseRandomBody = false;
	if ( !IsDefined( alreadySpawned ) || !alreadySpawned )
		chooseRandomBody = true;
	
	self maps\mp\gametypes\_wager::setupBlankRandomPlayer( takeAllWeapons, chooseRandomBody );
	self DisableWeaponCycling();
	
	// if ( !IsDefined( self.gunProgress ) )
		// self.gunProgress = 0;
	
	// currentWeapon = level.gunProgression[self.gunProgress].names[0];
	// self giveWeapon( currentWeapon );
	// self switchToWeapon( currentWeapon );
	// self giveWeapon( "knife_mp" );
	
	// if ( !IsDefined( alreadySpawned ) || !alreadySpawned )
		// self setSpawnWeapon( currentWeapon );
	
	// if ( IsDefined( takeAllWeapons ) && !takeAllWeapons )
		// self thread takeOldWeapons( currentWeapon );
	// else
		
	
	// currentWeapon = "ray_gun_mp";
	
	currentPrimary = level.duelPrimaryWeapon + "_mp";
	currentSecondary = level.duelSecondaryWeapon + "_mp";
	currentLethal = level.duelLethal + "_mp";
	
	if (currentPrimary != "spas_mp" && currentPrimary != "ithaca_grip_mp" && currentPrimary != "rottweil72_mp" && currentPrimary != "china_lake_mp")
	{
		currentWeapon = currentSecondary;
		self giveWeapon( currentWeapon );	
		if ( !IsDefined( alreadySpawned ) || !alreadySpawned )
			self setSpawnWeapon( currentWeapon );
			
		currentWeapon = currentLethal;
		self giveWeapon( currentWeapon );	
		if ( !IsDefined( alreadySpawned ) || !alreadySpawned )
			self setSpawnWeapon( currentWeapon );
	}
	
	currentWeapon = currentPrimary;
	self switchToWeapon( currentWeapon );
	self giveWeapon( currentWeapon );	
	if ( !IsDefined( alreadySpawned ) || !alreadySpawned )
		self setSpawnWeapon( currentWeapon );

	println( "^5GiveWeapon( " + currentPrimary + " ) -- currentPrimary" );
	println( "^5GiveWeapon( " + currentSecondary + " ) -- currentSecondary" );
	println( "^5GiveWeapon( " + currentLethal + " ) -- currentLethal" );
	

	showWeaponInfo(1, level.hudPrimary, "Primary Weapon", -128);

	if (currentPrimary != "spas_mp" && currentPrimary != "ithaca_grip_mp" && currentPrimary != "rottweil72_mp" && currentPrimary != "china_lake_mp")
	{
		showWeaponInfo(2, level.hudSecondary, "Secondary Weapon", -120);
		showWeaponInfo(3, level.hudLethal, "Lethal Throwable", -112);
	}

	self giveWeapon( "knife_mp" );	
	self EnableWeaponCycling();
	
	return currentWeapon;
}

showWeaponInfo(index, hudIcon, text, yPos)
{
	level.duel_weaponinfo_icon[ index ] = createLoadoutIcon( index, 0, 200, ypos ); 
	level.duel_weaponinfo_icon_text[ index ] = createLoadoutText( level.duel_weaponinfo_icon[ index ], 160 );

	level.duel_weaponinfo_icon[ index ] setLoadoutIconCoords( index, 0, 200, ypos ); 
	level.duel_weaponinfo_icon_text[ index ] setLoadoutTextCoords( 160 ); 
	
	showLoadoutAttribute( level.duel_weaponinfo_icon[ index ], hudIcon, 1, level.duel_weaponinfo_icon_text[ index ], text );
	
	if (index != 3)
		level.duel_weaponinfo_icon[ index ] SetShader( hudIcon, 64, 32 );
	
	level.duel_weaponinfo_icon[ index ] moveOverTime( 0.3 );
	level.duel_weaponinfo_icon[ index ].x = -5;
	level.duel_weaponinfo_icon[ index ].hidewheninmenu = true;
	level.duel_weaponinfo_icon_text[ index ] moveOverTime( 0.3 );
	level.duel_weaponinfo_icon_text[ index ].x = -72;
	level.duel_weaponinfo_icon_text[ index ].hidewheninmenu = true;

	self thread fadeWeaponInfo(level.duel_weaponinfo_icon[ index ], level.duel_weaponinfo_icon_text[ index ]);
}

fadeWeaponInfo(icon, text)
{
	wait(5);
	
	icon moveOverTime( 0.3 );
	icon.x = 400;

	text moveOverTime( 0.3 );
	text.x = 400;
	return;
}

chooseRandomGuns()
{
	level endon( "game_ended" );
	
	// level.duelRandomWeapon = getRandomGunFromProgression();
	level.duelPrimaryWeapon = random(level.primaryList).names[0];
	level.duelSecondaryWeapon = random(level.secondaryList).names[0];
	level.duelLethal = random(level.lethalList).names[0];

	switch(level.duelPrimaryWeapon)
	{
		case "ithaca_grip":
		{
			level.hudPrimary = "menu_mp_weapons_ithaca";
		} break;
		case "psg1_acog":
		{
			level.hudPrimary = "menu_mp_weapons_psg1";
		} break;
		case "stoner63":
		{
			level.hudPrimary = "menu_mp_weapons_stoner63a";
		} break;
		case "crossbow_explosive":
		{
			level.hudPrimary = "menu_mp_weapons_crossbow";
		} break;
		default:
		{
			level.hudPrimary = "menu_mp_weapons_" + level.duelPrimaryWeapon;
		} break;
	}

	switch(level.duelSecondaryWeapon)
	{
		case "python_speed":
		{
			level.hudSecondary = "menu_mp_weapons_python";
		} break;
		case "m1911_upgradesight":
		{
			level.hudSecondary = "menu_mp_weapons_colt";
		} break;
		case "makarov_upgradesight":
		{
			level.hudSecondary = "menu_mp_weapons_makarov";
		} break;
		case "cz75_upgradesight":
		{
			level.hudSecondary = "menu_mp_weapons_cz75";
		} break;
		default:
		{
			level.hudSecondary = "menu_mp_weapons_" + level.duelSecondaryWeapon;
		} break;
	}

	switch(level.duelLethal)
	{
		case "frag_grenade":
		{
			level.hudLethal = "hud_grenadeicon";
		} break;
		case "sticky_grenade":
		{
			level.hudLethal = "hud_icon_sticky_grenade";
		} break;
		default:
		{
			level.hudLethal = "hud_" + level.duelLethal; // aka "hud_hatchet"
		} break;
	}
	
	PreCacheShader(level.hudPrimary);
	PreCacheShader(level.hudSecondary);
	PreCacheShader(level.hudLethal);
}
getRandomGunFromProgression()
{	
	weaponIDKeys = GetArrayKeys( level.tbl_weaponIDs );
	numWeaponIDKeys = weaponIDKeys.size;
	
	while ( true )
	{
		randomIndex = RandomInt( numWeaponIDKeys );
		baseWeaponName = "";
		weaponName = "";
		
		id = random( level.tbl_weaponIDs );
		if ( ( id[ "slot" ] != "primary" ) && ( id[ "slot" ] != "secondary" ) )
			continue;
			
		if ( id[ "reference" ] == "weapon_null" )
			continue;
			
		if ( id[ "cost" ] == "-1" )
			continue;
			
		baseWeaponName = id[ "reference" ];
		attachmentList = id[ "attachment" ];
		weaponName = addRandomAttachmentToWeaponName( baseWeaponName, attachmentList );
		
		if ( !IsDefined( level.usedBaseWeapons ) )
		{
			level.usedBaseWeapons = [];
			level.usedBaseWeapons[0] = "strela";
		}
		skipWeapon = false;
		for ( i = 0 ; i < level.usedBaseWeapons.size ; i++ )
		{
			if ( level.usedBaseWeapons[i] == baseWeaponName )
			{
				skipWeapon = true;
				break;
			}
		}
		if ( skipWeapon )
			continue;
		level.usedBaseWeapons[level.usedBaseWeapons.size] = baseWeaponName;
		weaponName = weaponName+"_mp";
		
		return weaponName;
	}
}
addRandomAttachmentToWeaponName( baseWeaponName, attachmentList )
{
	if ( !IsDefined( attachmentList ) )
		return baseWeaponName;
		
	attachments = StrTok( attachmentList, " " );
	attachments = array_remove( attachments, "dw" ); 
	if ( attachments.size <= 0 )
		return baseWeaponName;
		
	attachments[attachments.size] = "";
	attachment = random( attachments );
	if ( attachment == "" )
		return baseWeaponName;
		
	return baseWeaponName+"_"+attachment;
}
onStartGameType()
{
	SetDvar( "scr_teambalance", 1 );
	SetDvar( "scr_disable_cac", 1 );
	MakeDvarServerInfo( "scr_disable_cac", 1 );
	SetDvar( "scr_disable_weapondrop", 1 );
	SetDvar( "scr_game_perks", 0 );
	SetDvar( "scr_player_healthregentime", 0 );
	level.killstreaksenabled = 0;
	level.hardpointsenabled = 0;
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
	
	// allowed[0] = "gun";
	allowed[0] = "tdm";
	
	level.displayRoundEndText = false;
	maps\mp\gametypes\_gameobjects::main(allowed);
	
	maps\mp\gametypes\_spawning::create_map_placed_influencers();
	
	maps\mp\gametypes\_rank::registerScoreInfo( "win", 2 );
	maps\mp\gametypes\_rank::registerScoreInfo( "loss", 1 );
	maps\mp\gametypes\_rank::registerScoreInfo( "tie", 1.5 );
	
	maps\mp\gametypes\_rank::registerScoreInfo( "kill", 500 );
	maps\mp\gametypes\_rank::registerScoreInfo( "headshot", 500 );
	maps\mp\gametypes\_rank::registerScoreInfo( "assist_75", 250 );
	maps\mp\gametypes\_rank::registerScoreInfo( "assist_50", 250 );
	maps\mp\gametypes\_rank::registerScoreInfo( "assist_25", 250 );
	maps\mp\gametypes\_rank::registerScoreInfo( "assist", 250 );
	
	level thread chooseRandomGuns();
	
	if ( !isOneRound() )
	{
		level.displayRoundEndText = true;
		if( isScoreRoundBased() )
		{
			maps\mp\gametypes\_globallogic_score::resetTeamScores();
		}
	}
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
// onRoundEndGame( winningTeam )
// {
	// if ( isdefined( winningTeam ) && (winningTeam == "allies" || winningTeam == "axis") )
		// [[level._setTeamScore]]( winningTeam, [[level._getTeamScore]]( winningTeam ) + 1 );	
	
	// if ( game["roundswon"]["allies"] == game["roundswon"]["axis"] )
		// winner = "tie";
	// else if ( game["roundswon"]["axis"] > game["roundswon"]["allies"] )
		// winner = "axis";
	// else
		// winner = "allies";
	
	// return winner;
// }
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
// onScoreCloseMusic()
// {
    // while( !level.gameEnded )
    // {
        // axisScore = [[level._getTeamScore]]( "axis" );
	    // alliedScore = [[level._getTeamScore]]( "allies" );
	    // scoreLimit = level.scoreLimit;
	    // scoreThreshold = scoreLimit * .1;
	    // scoreDif = abs(axisScore - alliedScore);
	    // scoreThresholdStart = abs(scoreLimit - scoreThreshold);
	    // scoreLimitCheck = scoreLimit - 10;
        
        // if (alliedScore > axisScore)
	    // {
		    // currentScore = alliedScore;
	    // }		
	    // else
	    // {
		    // currentScore = axisScore;
	    // }
        
        // if ( scoreDif <= scoreThreshold && scoreThresholdStart <= currentScore )
	    // {
		    
		    // thread maps\mp\gametypes\_globallogic_audio::set_music_on_team( "TIME_OUT", "both" );
		    // thread maps\mp\gametypes\_globallogic_audio::actionMusicSet();
		    // return;
	    // }
        
        // wait(.5);
    // }
// } 
