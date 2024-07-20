#include maps\_utility;
#include common_scripts\utility;
#include maps\_zombiemode_utility;
#include maps\_zombiemode_net;
#using_animtree( "generic_human" );
init()
{
	if( !maps\_zombiemode_weapons::is_weapon_included( "microwavegundw_zm" ) )
	{
		return;
	}
	PrecacheModel( GetWeaponModel( "microwavegunlh_zm" ) );
	PrecacheModel( GetWeaponModel( "microwavegunlh_upgraded_zm" ) );
	level._ZOMBIE_ACTOR_FLAG_MICROWAVEGUN_INITIAL_HIT_RESPONSE = 6;
	level._ZOMBIE_ACTOR_FLAG_MICROWAVEGUN_EXPAND_RESPONSE = 9;
	maps\_zombiemode_spawner::register_zombie_damage_callback( ::microwavegun_zombie_damage_response );
	maps\_zombiemode_spawner::register_zombie_death_animscript_callback( ::microwavegun_zombie_death_response );
	set_zombie_var( "microwavegun_cylinder_radius", 180 );
	set_zombie_var( "microwavegun_sizzle_range", 480 );
	level._effect["microwavegun_zap_shock_dw"] = loadfx( "weapon/microwavegun/fx_zap_shock_ug" );
	level._effect["microwavegun_zap_shock_eyes_dw"] = loadfx( "weapon/microwavegun/fx_zap_shock_eyes_dw" );
	level._effect["microwavegun_zap_shock_lh"] = loadfx( "weapon/microwavegun/fx_zap_shock_ug" );
	level._effect["microwavegun_zap_shock_eyes_lh"] = loadfx( "weapon/microwavegun/fx_zap_shock_eyes_lh" );
	level._effect["microwavegun_zap_shock_ug"] = loadfx( "weapon/microwavegun/fx_zap_shock_ug" );
	level._effect["microwavegun_zap_shock_eyes_ug"] = loadfx( "weapon/microwavegun/fx_zap_shock_eyes_ug" );
	level._effect["microwavegun_sizzle_blood_eyes"] = loadfx( "weapon/microwavegun/fx_sizzle_blood_eyes" );
	level._effect["microwavegun_sizzle_death_mist"] = loadfx( "weapon/microwavegun/fx_sizzle_mist" );
	level._effect["microwavegun_sizzle_death_mist_low_g"]	= loadfx( "weapon/microwavegun/fx_sizzle_mist_low_g" );
	if( !isDefined( level._zombie_microwavegun_zap_death ) )
	{
		level._zombie_microwavegun_zap_death = [];
	}
	level._zombie_microwavegun_zap_death["zombie"] = [];
	level._zombie_microwavegun_zap_death["zombie"][0] = %ai_zombie_tesla_death_a;
	level._zombie_microwavegun_zap_death["zombie"][1] = %ai_zombie_tesla_death_b;
	level._zombie_microwavegun_zap_death["zombie"][2] = %ai_zombie_tesla_death_c;
	level._zombie_microwavegun_zap_death["zombie"][3] = %ai_zombie_tesla_death_d;
	level._zombie_microwavegun_zap_death["zombie"][4] = %ai_zombie_tesla_death_e;
	level._zombie_microwavegun_zap_death["quad_zombie"] = [];
	level._zombie_microwavegun_zap_death["quad_zombie"][0] = %ai_zombie_quad_death_tesla;
	level._zombie_microwavegun_zap_death["quad_zombie"][1] = %ai_zombie_quad_death_tesla_2;
	level._zombie_microwavegun_zap_death["quad_zombie"][2] = %ai_zombie_quad_death_tesla_3;
	level._zombie_microwavegun_zap_death["quad_zombie"][3] = %ai_zombie_quad_death_tesla_4;
	if( !isDefined( level._zombie_microwavegun_zap_crawl_death ) )
	{
		level._zombie_microwavegun_zap_crawl_death = [];
	}
	level._zombie_microwavegun_zap_crawl_death["zombie"] = [];
	level._zombie_microwavegun_zap_crawl_death["zombie"][0] = %ai_zombie_tesla_crawl_death_a;
	level._zombie_microwavegun_zap_crawl_death["zombie"][1] = %ai_zombie_tesla_crawl_death_b;
	level._zombie_microwavegun_zap_crawl_death["quad_zombie"] = [];
	level._zombie_microwavegun_zap_crawl_death["quad_zombie"][0] = %ai_zombie_tesla_crawl_death_a;
	level._zombie_microwavegun_zap_crawl_death["quad_zombie"][1] = %ai_zombie_tesla_crawl_death_b;
	if( !isDefined( level._zombie_microwavegun_sizzle_death ) )
	{
		level._zombie_microwavegun_sizzle_death = [];
	}
	level._zombie_microwavegun_sizzle_death["zombie"] = [];
	level._zombie_microwavegun_sizzle_death["zombie"][0] = %ai_zombie_microwave_death_a;
	level._zombie_microwavegun_sizzle_death["zombie"][1] = %ai_zombie_microwave_death_b;
	level._zombie_microwavegun_sizzle_death["zombie"][2] = %ai_zombie_microwave_death_c;
	level._zombie_microwavegun_sizzle_death["zombie"][3] = %ai_zombie_microwave_death_walking_a;
	level._zombie_microwavegun_sizzle_death["zombie"][4] = %ai_zombie_microwave_death_walking_b;
	level._zombie_microwavegun_sizzle_death["zombie"][5] = %ai_zombie_microwave_death_walking_c;
	level._zombie_microwavegun_sizzle_death["quad_zombie"] = [];
	level._zombie_microwavegun_sizzle_death["quad_zombie"][0] = %ai_zombie_quad_microwave_death_a;
	level._zombie_microwavegun_sizzle_death["quad_zombie"][1] = %ai_zombie_quad_microwave_death_b;
	level._zombie_microwavegun_sizzle_death["quad_zombie"][2] = %ai_zombie_quad_microwave_death_c;
	if( !isDefined( level._zombie_microwavegun_sizzle_crawl_death ) )
	{
		level._zombie_microwavegun_sizzle_crawl_death = [];
	}
	level._zombie_microwavegun_sizzle_crawl_death["zombie"] = [];
	level._zombie_microwavegun_sizzle_crawl_death["zombie"][0] = %ai_zombie_crawl_microwave_death_a;
	level._zombie_microwavegun_sizzle_crawl_death["zombie"][1] = %ai_zombie_crawl_microwave_death_b;
	level._zombie_microwavegun_sizzle_crawl_death["zombie"][2] = %ai_zombie_crawl_microwave_death_c;
	level._zombie_microwavegun_sizzle_crawl_death["zombie"][3] = %ai_zombie_crawl_microwave_death_walking_a;
	level._zombie_microwavegun_sizzle_crawl_death["zombie"][4] = %ai_zombie_crawl_microwave_death_walking_b;
	level._zombie_microwavegun_sizzle_crawl_death["zombie"][5] = %ai_zombie_crawl_microwave_death_walking_c;
	level thread microwavegun_on_player_connect();
	level._microwaveable_objects = [];
}
add_microwaveable_object(ent)
{
	level._microwaveable_objects = add_to_array(level._microwaveable_objects, ent, false);
}
remove_microwaveable_object(ent)
{
	level._microwaveable_objects = array_remove(level._microwaveable_objects, ent);
}
microwavegun_on_player_connect()
{
	for( ;; )
	{
		level waittill( "connecting", player );
		player thread wait_for_microwavegun_fired();
	}
}
wait_for_microwavegun_fired()
{
	self endon( "disconnect" );
	self waittill( "spawned_player" );
	for( ;; )
	{
		self waittill( "weapon_fired" );
		currentweapon = self GetCurrentWeapon();
		if( ( currentweapon == "microwavegun_zm" ) || ( currentweapon == "microwavegun_upgraded_zm" ) )
		{
			self thread microwavegun_fired( currentweapon == "microwavegun_upgraded_zm" );
		}
	}
}
microwavegun_network_choke()
{
	level.microwavegun_network_choke_count++;
	if ( !(level.microwavegun_network_choke_count % 10) )
	{
		wait_network_frame();
		wait_network_frame();
		wait_network_frame();
	}
}
microwavegun_fired(upgraded)
{
	if ( !IsDefined( level.microwavegun_sizzle_enemies ) )
	{
		level.microwavegun_sizzle_enemies = [];
		level.microwavegun_sizzle_vecs = [];
	}
	self microwavegun_get_enemies_in_range(upgraded, false);
	self microwavegun_get_enemies_in_range(upgraded, true);
	level.microwavegun_network_choke_count = 0;
	for ( i = 0; i < level.microwavegun_sizzle_enemies.size; i++ )
	{
		microwavegun_network_choke();
		level.microwavegun_sizzle_enemies[i] thread microwavegun_sizzle_zombie( self, level.microwavegun_sizzle_vecs[i], i );
	}
	level.microwavegun_sizzle_enemies = [];
	level.microwavegun_sizzle_vecs = [];
}
microwavegun_get_enemies_in_range(upgraded, microwaveable_objects)
{
	view_pos = self GetWeaponMuzzlePoint();
	test_list = undefined;
	range = level.zombie_vars["microwavegun_sizzle_range"];
	cylinder_radius = level.zombie_vars["microwavegun_cylinder_radius"];
	if(microwaveable_objects)
	{
		test_list = level._microwaveable_objects;
		range *= 10;
		cylinder_radius *= 10;
	}
	else
	{
		test_list = GetAISpeciesArray("axis", "all");
	}
	zombies = get_array_of_closest( view_pos, test_list, undefined, undefined, range);
	if ( !isDefined( zombies ) )
	{
		return;
	}
	sizzle_range_squared = range * range;
	cylinder_radius_squared = cylinder_radius * cylinder_radius;
	forward_view_angles = self GetWeaponForwardDir();
	end_pos = view_pos + vector_scale( forward_view_angles, range );
	for ( i = 0; i < zombies.size; i++ )
	{
		if ( !IsDefined( zombies[i] ) || (IsAI(zombies[i]) && !IsAlive( zombies[i] )) )
		{
			continue;
		}
		test_origin = zombies[i] getcentroid();
		test_range_squared = DistanceSquared( view_pos, test_origin );
		if ( test_range_squared > sizzle_range_squared )
		{
			zombies[i] microwavegun_debug_print( "range", (1, 0, 0) );
			return;
		}
		normal = VectorNormalize( test_origin - view_pos );
		dot = VectorDot( forward_view_angles, normal );
		if ( 0 > dot )
		{
			zombies[i] microwavegun_debug_print( "dot", (1, 0, 0) );
			continue;
		}
		radial_origin = PointOnSegmentNearestToPoint( view_pos, end_pos, test_origin );
		if ( DistanceSquared( test_origin, radial_origin ) > cylinder_radius_squared )
		{
			zombies[i] microwavegun_debug_print( "cylinder", (1, 0, 0) );
			continue;
		}
		if ( 0 == zombies[i] DamageConeTrace( view_pos, self ) )
		{
			zombies[i] microwavegun_debug_print( "cone", (1, 0, 0) );
			continue;
		}
		if(IsAI(zombies[i]))
		{
			level.microwavegun_sizzle_enemies[level.microwavegun_sizzle_enemies.size] = zombies[i];
			dist_mult = (sizzle_range_squared - test_range_squared) / sizzle_range_squared;
			sizzle_vec = VectorNormalize( test_origin - view_pos );
			if ( 5000 < test_range_squared )
			{
				sizzle_vec = sizzle_vec + VectorNormalize( test_origin - radial_origin );
			}
			sizzle_vec = (sizzle_vec[0], sizzle_vec[1], abs( sizzle_vec[2] ));
			sizzle_vec = vector_scale( sizzle_vec, 100 + 100 * dist_mult );
			level.microwavegun_sizzle_vecs[level.microwavegun_sizzle_vecs.size] = sizzle_vec;
		}
		else
		{
			zombies[i] notify("microwaved",self);
		}
	}
}
microwavegun_debug_print( msg, color )
{
}
microwavegun_sizzle_zombie( player, sizzle_vec, index )
{
	if( !IsDefined( self ) || !IsAlive( self ) )
	{
		return;
	}
	if ( IsDefined( self.microwavegun_sizzle_func ) )
	{
		self [[ self.microwavegun_sizzle_func ]]( player );
		return;
	}
	self.no_gib = true;
	self.gibbed = true;
	self DoDamage( self.health + 666, player.origin, player );
	if ( self.health <= 0 )
	{
		points = 10;
		if ( !index )
		{
			points = maps\_zombiemode_score::get_zombie_death_player_points();
		}
		else if ( 1 == index )
		{
			points = 30;
		}
		player maps\_zombiemode_score::player_add_points( "thundergun_fling", points );
		self.microwavegun_death = true;
		instant_explode = false;
		if ( !self.isdog )
		{
			if ( self.has_legs )
			{
				self.deathanim = random( level._zombie_microwavegun_sizzle_death[self.animname] );
			}
			else
			{
				self.deathanim = random( level._zombie_microwavegun_sizzle_crawl_death[self.animname] );
			}
		}
		else
		{
			self.a.nodeath = undefined;
			instant_explode = true;
		}
		if ( is_true( self.is_traversing ) || is_true( self.in_the_ceiling ) )
		{
			self.deathanim = undefined;
			instant_explode = true;
		}
		if ( instant_explode )
		{
			if( isdefined( self.animname ) && self.animname != "astro_zombie" )
			{
				self thread setup_microwavegun_vox( player );
			}
			self setclientflag( level._ZOMBIE_ACTOR_FLAG_MICROWAVEGUN_EXPAND_RESPONSE );
			self thread microwavegun_sizzle_death_ending();
		}
		else
		{
			if( isdefined( self.animname ) && self.animname != "astro_zombie" )
			{
				self thread setup_microwavegun_vox( player, 6 );
			}
			self setclientflag( level._ZOMBIE_ACTOR_FLAG_MICROWAVEGUN_INITIAL_HIT_RESPONSE );
			self.nodeathragdoll = true;
			self.handle_death_notetracks = ::microwavegun_handle_death_notetracks;
		}
	}
}
microwavegun_handle_death_notetracks( note )
{
	if ( note == "expand" )
	{
		self setclientflag( level._ZOMBIE_ACTOR_FLAG_MICROWAVEGUN_EXPAND_RESPONSE );
	}
	else if ( note == "explode" )
	{
		self clearclientflag( level._ZOMBIE_ACTOR_FLAG_MICROWAVEGUN_EXPAND_RESPONSE );
		self thread microwavegun_sizzle_death_ending();
	}
}
microwavegun_sizzle_death_ending()
{
	
	if ( !IsDefined( self ) )
	{
		return;
	}
	self hide();
	wait( 0.1 );
	self self_delete();
}

micro_do_damage( source_enemy, arc_num, player )
{
	
	player endon( "disconnect" );

	if ( arc_num > 1 )
	{
		wait( RandomFloat( 0.2, 0.6 ) * arc_num );
	}

	if( !IsDefined( self ) || !IsAlive( self ) )
	{
		// guy died on us 
		return;
	}

	if ( !self.isdog )
	{
		if( self.has_legs )
		{
			self.deathanim = random( level._zombie_tesla_death[self.animname] );
		}
		else
		{
			self.deathanim = random( level._zombie_tesla_crawl_death[self.animname] );
		}
	}
	else
	{
		self.a.nodeath = undefined;
	}
	
	if( is_true( self.is_traversing))
	{
		self.deathanim = undefined;
	}

	if( source_enemy != self )
	{
		if ( player.tesla_arc_count > 3 )
		{
			wait_network_frame();
			player.tesla_arc_count = 0;
		}
		
		player.tesla_arc_count++;
		source_enemy micro_play_arc_fx( self );
	}

	while ( player.tesla_network_death_choke > level.tesla_network_death_choke )
	{
		//iprintln( "TESLA: Choking Tesla Damage. Dead enemies this network frame: " + player.tesla_network_death_choke );		
		wait( 0.05 ); 
	}

	if( !IsDefined( self ) || !IsAlive( self ) )
	{
		// guy died on us 
		return;
	}

	player.tesla_network_death_choke++;

	self.tesla_death = true;
	self microwavegun_zap_death_fx( arc_num );
	
	// use the origin of the arc orginator so it pics the correct death direction anim
	origin = source_enemy.origin;
	if ( source_enemy == self || !IsDefined( origin ) )
	{
		origin = player.origin;
	}

	if( !IsDefined( self ) || !IsAlive( self ) )
	{
		// guy died on us 
		return;
	}
	
	if ( IsDefined( self.tesla_damage_func ) )
	{
		//self [[ self.tesla_damage_func ]]( origin, player );
		return;
	}
	else
	{
		self DoDamage( self.health + 666, origin, player );
	}
	player maps\_zombiemode_score::player_add_points( "death", "MOD_MELEE", "" );

// 	if ( !player.tesla_powerup_dropped && player.tesla_enemies_hit >= level.zombie_vars["tesla_kills_for_powerup"] )
// 	{
// 		player.tesla_powerup_dropped = true;
// 		level.zombie_vars["zombie_drop_item"] = 1;
// 		level thread maps\_zombiemode_powerups::powerup_drop( self.origin );
// 	}

}

micro_flag_hit( enemy, hit )
{
	if( IsArray( enemy ) )
	{
		for( i = 0; i < enemy.size; i++ )
		{
			enemy[i].zombie_tesla_hit = hit;
		}
	}
	else
	{
		enemy.zombie_tesla_hit = hit;
	}
}

micro_damage_init( mod, damageweapon, player, hit_location, hit_origin )
{
	player endon( "disconnect" );

	if ( IsDefined( player.tesla_enemies_hit ) && player.tesla_enemies_hit > 0 )
	{
		//iprintln( "TESLA: Player: '" + player.playername + "' currently processing tesla damage" );
		return;
	}

	if( IsDefined( self.zombie_tesla_hit ) && self.zombie_tesla_hit )
	{
		// can happen if an enemy is marked for tesla death and player hits again with the tesla gun
		return;
	}

	//iprintln( "TESLA: Player: '" + player.playername + "' hit with the tesla gun" );

	//TO DO Add Tesla Kill Dialog thread....
	
	player.tesla_enemies = undefined;
	player.tesla_enemies_hit = 1;
	player.tesla_powerup_dropped = false;
	player.tesla_arc_count = 0;
	
	self micro_arc_damage( mod, damageweapon, player, self, 1 );
	

	player.tesla_enemies_hit = 0;
	
}

micro_get_enemies_in_area( mod, damageweapon, player, origin, distance )
{
	
	distance_squared = distance * distance;
	enemies = [];

	if ( !IsDefined( player.tesla_enemies ) )
	{
		player.tesla_enemies = GetAiSpeciesArray( "axis", "all" );
		player.tesla_enemies = get_array_of_closest( origin, player.tesla_enemies );
	}

	zombies = player.tesla_enemies; 

	if ( IsDefined( zombies ) )
	{
		for ( i = 0; i < zombies.size; i++ )
		{
			if ( !IsDefined( zombies[i] ) )
			{
				continue;
			}

			test_origin = zombies[i] GetTagOrigin( "j_head" );

			if ( IsDefined( zombies[i].zombie_tesla_hit ) && zombies[i].zombie_tesla_hit == true )
			{
				continue;
			}

			if ( is_magic_bullet_shield_enabled( zombies[i] ) )
			{
				continue;
			}

			if ( DistanceSquared( origin, test_origin ) > distance_squared )
			{
				continue;
			}

			if ( !BulletTracePassed( origin, test_origin, false, undefined ) )
			{
				continue;
			}

			enemies[enemies.size] = zombies[i];
		}
	}

	return enemies;
	
}

micro_play_arc_fx( target )
{
	
	if ( !IsDefined( self ) || !IsDefined( target ) )
	{
		// TODO: can happen on dog exploding death
		wait( level.tesla_arc_travel_time );
		return;
	}
	
	tag = "J_SpineUpper";

	if ( self.isdog )
	{
		tag = "J_Spine1";
	}

	target_tag = "J_SpineUpper";

	if ( target.isdog )
	{
		target_tag = "J_Spine1";
	}
	
	origin = self GetTagOrigin( tag );
	target_origin = target GetTagOrigin( target_tag );
	distance_squared = level.tesla_min_fx_distance * level.tesla_min_fx_distance;

	if ( DistanceSquared( origin, target_origin ) < distance_squared )
	{
		//iprintln( "TESLA: Not playing arcing FX. Enemies too close." );		
		return;
	}
	
	fxOrg = Spawn( "script_model", origin );
	fxOrg SetModel( "tag_origin" );

	fx = PlayFxOnTag( level._effect["microwavegun_zap_shock_lh"], fxOrg, "tag_origin" );
	//playsoundatposition( "wpn_tesla_bounce", fxOrg.origin );
	
	fxOrg MoveTo( target_origin, level.tesla_arc_travel_time );
	fxOrg waittill( "movedone" );
	fxOrg delete();
	
}

micro_arc_damage( mod, damageweapon, player, source_enemy, arc_num )
{
	player endon( "disconnect" );
	if(player GetCurrentWeapon() == "microwavegundw_upgraded_zm")
	level.DoExtra = true;
	

	//iprintln( "TESLA: Evaulating arc damage for arc: " + arc_num + " Current enemies hit: " + player.tesla_enemies_hit );

	micro_flag_hit( self, true );
	wait_network_frame();

	radius_decay = level.tesla_radius_decay * arc_num;
	enemies = micro_get_enemies_in_area(  mod, damageweapon, player, self GetTagOrigin( "j_head" ), level.tesla_radius_start - radius_decay );
	micro_flag_hit( enemies, true );

	self thread micro_do_damage( source_enemy, arc_num, player );

	//iprintln( "TESLA: " + enemies.size + " enemies hit during arc: " + arc_num );
			
	for( i = 0; i < enemies.size; i++ )
	{
		if( enemies[i] == self )
		{
			continue;
		}
		
		if ( micro_end_arc_damage(  mod, damageweapon, player, arc_num + 1, player.tesla_enemies_hit ) )
		{			
			micro_flag_hit( enemies[i], false );
			continue;
		}

		player.tesla_enemies_hit++;
		enemies[i].microwavegun_dw_death = true;
		enemies[i] thread microwavegun_zap_death_fx( damageweapon );
		if ( enemies[i].has_legs )
			{
				enemies[i].deathanim = random( level._zombie_microwavegun_zap_death[enemies[i].animname] );
			}
			else
			{
				enemies[i].deathanim = random( level._zombie_microwavegun_zap_crawl_death[enemies[i].animname] );
			}
			enemies[i] DoDamage( self.health + 666, self.origin, player );
			player maps\_zombiemode_score::add_to_player_score(100);
		//enemies[i] micro_arc_damage( mod, damageweapon, player,self, arc_num + 1 );
		wait .2;
	}
}

micro_end_arc_damage(  mod, damageweapon, player, arc_num, enemies_hit_num)
{
	enemies_hit_num += 5;
	arc_num += 5;
if( IsDefined( level.VanillaPlus ) && IsDefined( player.Weapon_Upgrade_Enhance["microwavegundw_zm"] ) ){
enemies_hit_num -= player.Weapon_Upgrade_Enhance["microwavegundw_zm"] -1;
arc_num  -= player.Weapon_Upgrade_Enhance["microwavegundw_zm"] -1;
}
if(player GetCurrentWeapon() == "microwavegundw_upgraded_zm"){
level.DoExtra = true;
enemies_hit_num -= 2;
arc_num  -= 2;
level.DoExtra = undefined;
}

	if ( arc_num >= level.tesla_max_arcs )
	{
		//iprintln( "TESLA: Ending arcing. Max arcs hit" );
		
		
		return true;
		//TO DO Play Super Happy Tesla sound
	}

	if ( enemies_hit_num >= level.tesla_max_enemies_killed )
	{
		//iprintln( "TESLA: Ending arcing. Max enemies killed" );		
		
		
		return true;
	}

	radius_decay = level.tesla_radius_decay * arc_num;
	if ( level.tesla_radius_start - radius_decay <= 0 )
	{
	//	//iprintln( "TESLA: Ending arcing. Radius is less or equal to zero" );
		
		
		return true;
	}
	
	
	return false;
	//TO DO play Tesla Missed sound (sad)
}

microwavegun_dw_zombie_hit_response_internal( mod, damageweapon, player )
{
	player endon( "disconnect" );
	if ( !IsDefined( self ) || !IsAlive( self ) )
	{
		return;
	}
	
	if( IsDefined( level.VanillaPlus ) )
	{
	self micro_damage_init(mod, damageweapon, player);
	}
	
	if ( !self.isdog )
	{
		if ( self.has_legs )
		{
			self.deathanim = random( level._zombie_microwavegun_zap_death[self.animname] );
		}
		else
		{
			self.deathanim = random( level._zombie_microwavegun_zap_crawl_death[self.animname] );
		}
	}
	else
	{
		self.a.nodeath = undefined;
	}
	if ( is_true( self.is_traversing ) )
	{
		self.deathanim = undefined;
	}
	self.microwavegun_dw_death = true;
	self thread microwavegun_zap_death_fx( damageweapon );
	if ( IsDefined( self.microwavegun_zap_damage_func ) )
	{
		self [[self.microwavegun_zap_damage_func]]( player );
		return;
	}
	else
	{
		self DoDamage( self.health + 666, self.origin, player );
	}
	player maps\_zombiemode_score::player_add_points( "death", "", "" );
	if( randomintrange(0,101) >= 75 )
	{
		player thread maps\_zombiemode_audio::create_and_play_dialog( "kill", "micro_dual" );
	}
}
microwavegun_zap_get_shock_fx( weapon )
{
	if ( weapon == "microwavegundw_zm" )
	{
		return level._effect["microwavegun_zap_shock_ug"];
	}
	else if ( weapon == "microwavegunlh_zm" )
	{
		return level._effect["microwavegun_zap_shock_ug"];
	}
	else
	{
		return level._effect["microwavegun_zap_shock_ug"];
	}
}
microwavegun_zap_get_shock_eyes_fx( weapon )
{
	if ( weapon == "microwavegundw_zm" )
	{
		return level._effect["microwavegun_zap_shock_eyes_ug"];
	}
	else if ( weapon == "microwavegunlh_zm" )
	{
		return level._effect["microwavegun_zap_shock_eyes_ug"];
	}
	else
	{
		return level._effect["microwavegun_zap_shock_eyes_ug"];
	}
}
microwavegun_zap_head_gib( weapon )
{
	self endon("death");
	network_safe_play_fx_on_tag( "microwavegun_zap_death_fx", 2, microwavegun_zap_get_shock_eyes_fx( weapon ), self, "J_Eyeball_LE" );
}
microwavegun_zap_death_fx( weapon )
{
	tag = "J_SpineUpper";
	if ( self.isdog )
	{
		tag = "J_Spine1";
	}
	network_safe_play_fx_on_tag( "microwavegun_zap_death_fx", 2, microwavegun_zap_get_shock_fx( weapon ), self, tag );
	self playsound( "wpn_imp_tesla" );
	if ( is_true( self.head_gibbed ) )
	{
		return;
	}
	if ( IsDefined( self.microwavegun_zap_head_gib_func ) )
	{
		self thread [[ self.microwavegun_zap_head_gib_func ]]( weapon );
	}
	else if ( "quad_zombie" != self.animname )
	{
		self thread microwavegun_zap_head_gib( weapon );
	}
}
microwavegun_zombie_damage_response( mod, hit_location, hit_origin, player, amount )
{
	if ( self is_microwavegun_dw_damage() )
	{
		self thread microwavegun_dw_zombie_hit_response_internal( mod, self.damageweapon, player );
		return true;
	}
	return false;
}
microwavegun_zombie_death_response()
{
	if ( self enemy_killed_by_dw_microwavegun() )
	{
		return true;
	}
	else if ( self enemy_killed_by_microwavegun() )
	{
		return true;
	}
	return false;
}
is_microwavegun_dw_damage()
{
	return IsDefined( self.damageweapon ) && (self.damageweapon == "microwavegundw_zm" || self.damageweapon == "microwavegundw_upgraded_zm" || self.damageweapon == "microwavegunlh_zm" || self.damageweapon == "microwavegunlh_upgraded_zm") && (self.damagemod == "MOD_IMPACT");
}
enemy_killed_by_dw_microwavegun()
{
	return is_true( self.microwavegun_dw_death );
}
is_microwavegun_damage()
{
	return IsDefined( self.damageweapon ) && (self.damageweapon == "microwavegun_zm" || self.damageweapon == "microwavegun_upgraded_zm") && (self.damagemod != "MOD_GRENADE" && self.damagemod != "MOD_GRENADE_SPLASH");
}
enemy_killed_by_microwavegun()
{
	return is_true( self.microwavegun_death );
}
microwavegun_sound_thread()
{
	self endon( "disconnect" );
	self waittill( "spawned_player" );
	for( ;; )
	{
		result = self waittill_any_return( "grenade_fire", "death", "player_downed", "weapon_change", "grenade_pullback" );
		if ( !IsDefined( result ) )
		{
			continue;
		}
		if ( ( result == "weapon_change" || result == "grenade_fire" ) && self GetCurrentWeapon() == "microwavegun_zm" )
		{
			self PlayLoopSound( "tesla_idle", 0.25 );
		}
		else
		{
			self notify ("weap_away");
			self StopLoopSound(0.25);
		}
	}
}
setup_microwavegun_vox( player, waittime )
{
	level notify( "force_end_microwave_vox" );
	level endon( "force_end_microwave_vox" );
	if( !isdefined( waittime ) )
	{
		waittime = .05;
	}
	wait( waittime );
	if ( 50 > RandomIntRange( 1, 100 ) && isdefined( player ) )
	{
		player thread maps\_zombiemode_audio::create_and_play_dialog( "kill", "micro_single" );
	}
}

 