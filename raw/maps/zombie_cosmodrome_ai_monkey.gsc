
#include common_scripts\utility;
#include maps\_utility;
#include maps\_zombiemode_utility;
#using_animtree("generic_human");
init()
{
	level.Uses_Fizz = true; level.Fizz_Origin = ( 64, 1175, 71 );
	level.Uses_Upgrade = true;level.Upgrade_Origin = ( -786, 1311, -73 );
	level._effect["monkey_trail"] = loadfx("maps/zombie/fx_zombie_ape_spawn_trail");
	level.monkey_zombie_enter_level = ::monkey_cosmodrome_enter_level;
	level.monkey_round_start = ::monkey_cosmodrome_round_start;
}
monkey_cosmodrome_enter_level()
{
	self endon( "death" );
	end = self monkey_lander_get_closest_dest();
	end_launch = getstruct( end.target, "targetname" );
	start_launch = end_launch.origin + ( 0, 0, 2000 );
	lander = Spawn( "script_model", start_launch );
	angles = VectorToAngles( end.origin - start_launch );
	lander.angles = angles;
	lander SetModel( "zombie_lander_crashed" );
	lander hide();
	lander thread clear_lander();
	self hide();
	wait_network_frame();
	lander setclientflag(level._SCRIPTMOVER_COSMODROME_CLIENT_FLAG_MONKEY_LANDER_FX);
	self forceteleport( lander.origin );
	self linkto( lander );
	wait( 2.5 );
	lander show();
	lander MoveTo( end.origin, 0.6 );
	lander waittill( "movedone" );
	lander clearclientflag(level._SCRIPTMOVER_COSMODROME_CLIENT_FLAG_MONKEY_LANDER_FX);
	wait( 2.0 );
	self unlink();
	self show();
}
clear_lander()
{
	wait( 8.0 );
	self MoveZ( -100, 0.5 );
	self waittill( "movedone" );
	self delete();
}
monkey_lander_get_closest_dest()
{
	if(!IsDefined(level._lander_endarray))
	{
		level._lander_endarray = [];
	}
	if(!IsDefined(level._lander_endarray[self.script_noteworthy]))
	{
		level._lander_endarray[self.script_noteworthy] = [];
		end_spots = getstructarray( "monkey_land", "targetname" );
		for ( i = 0; i < end_spots.size; i++ )
		{
			if ( self.script_noteworthy == end_spots[i].script_noteworthy )
			{
				level._lander_endarray[self.script_noteworthy][level._lander_endarray[self.script_noteworthy].size] = end_spots[i];
			}
		}
	}
	choice = level._lander_endarray[self.script_noteworthy][0];
	max_dist = 100000 * 100000;
	for ( i = 0; i < level._lander_endarray[self.script_noteworthy].size; i++ )
	{
		dist = Distance2D( self.origin, level._lander_endarray[self.script_noteworthy][i].origin );
		if ( dist < max_dist )
		{
			max_dist = dist;
			choice = level._lander_endarray[self.script_noteworthy][i];
		}
	}
	return choice;
}
monkey_cosmodrome_round_start()
{
	clientnotify("MRS");
}
monkey_cosmodrome_prespawn()
{
	self.lander_death = ::monkey_cosmodrome_lander_death;
}
monkey_cosmodrome_failsafe()
{
	self endon( "death" );
	while ( true )
	{
		if ( self.state != "bhb_jump" )
		{
			//if ( !check_point_in_playable_area( self.origin ) )
			//{
			//	break;
			//}
		}
		self DoDamage( self.health + 100, self.origin );
		wait( 1 );
	}
	//assertmsg( "monkey is out of playable area at " + self.origin );
	self DoDamage( self.health + 100, self.origin );
}
monkey_cosmodrome_lander_death()
{
	self maps\_zombiemode_spawner::reset_attack_spot();
	self thread maps\_zombiemode_spawner::zombie_eye_glow_stop();
	level.monkey_death++;
	level.monkey_death_total++;
	self maps\_zombiemode_ai_monkey::monkey_remove_from_pack();
	wait_network_frame();
}

 