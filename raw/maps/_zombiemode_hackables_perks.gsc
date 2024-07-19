#include common_scripts\utility;
#include maps\_utility;
#include maps\_zombiemode_utility;
hack_perks()
{
	level thread Init_Zomboob_hack();
	flag_wait("power_on");
	players = getPlayers();
	for (i = 0; i < getPlayers().size; i++) {
		level maps\vapp::dvar_all("perk_weapSpreadMultiplier", 0.8);
		level maps\vapp::dvar_all("perk_weapRateMultiplier", 0.75);
		level maps\vapp::dvar_all("perk_weapReloadMultiplier", 0.67);
	}
	vending_triggers = GetEntArray( "zombie_vending", "targetname" );
	for(i = 0; i < vending_triggers.size; i ++)
	{
		struct = SpawnStruct();
		machine = getentarray(vending_triggers[i].target, "targetname");
		struct.origin = machine[0].origin + (AnglesToRight(machine[0].angles) * 18) + (0,0,48);
		struct.radius = 48;
		struct.height = 64;
		struct.script_float = 5;
		while(!IsDefined(vending_triggers[i].cost))
		{
			wait .05;
		}
		struct.script_int = Int(vending_triggers[i].HackCost);
		struct.perk = vending_triggers[i];
		vending_triggers[i].hackable = struct;
		maps\_zombiemode_equip_hacker::register_pooled_hackable_struct(struct, ::perk_hack, ::perk_hack_qualifier);
	}
}
solo_revive_expire_func()
{
	
}
Init_Zomboob_hack(){
	level.jug_hackCost = 2000;
	level.nuke_hackCost = 1350;
	level.sour_hackCost = 1250;
	level.revive_hackCost = 1000;
	level.threegun_hackCost = 3120;
	level.ads_hackCost = 500;
	level.rof_hackCost = 1250;
	level.fast_hackCost = 1500;
	vending_triggers = GetEntArray( "zombie_vending", "targetname" );
	for(i = 0; i < vending_triggers.size; i ++)
	{
		switch(vending_triggers[i].target){
			case "vending_jugg":
			vending_triggers[i].HackCost = level.jug_hackCost;
			break;
			case "vending_divetonuke":
			vending_triggers[i].HackCost = level.nuke_hackCost;
			break;
			case "vending_marathon":
			vending_triggers[i].HackCost = level.sour_hackCost;
			break;
			case "vending_revive":
			vending_triggers[i].HackCost = level.revive_hackCost;
			break;
			case "vending_additionalprimaryweapon":
			vending_triggers[i].HackCost = level.threegun_hackCost;
			break;
			case "vending_deadshot":
			vending_triggers[i].HackCost = level.ads_hackCost;
			break;
			case "vending_doubletap":
			vending_triggers[i].HackCost = level.rof_hackCost;
			break;
			case "vending_sleight":
			vending_triggers[i].HackCost = level.fast_hackCost;
			break;
		}
	}
}

perk_hack_qualifier(player)
{
	perk = self.perk.script_noteworthy;
	switch(perk)
	{
		case "specialty_quickrevive":
			if( is_true( level.quick_hacked ) ) //&& !player HasPerk( perk ) )
				return false;
			else
					return true;
		case "specialty_rof":
			if( is_true(level.rof_hacked ) ) //&& !player HasPerk( perk ) )
				return false;
			else
					return true;
		case "specialty_longersprint":
			if( is_true(level.sour_hacked ) ) //&& !player HasPerk( perk ) )
				return false;
			else
					return true;
		case "specialty_fastreload":
			if( is_true(level.fast_hacked ) ) //&& !player HasPerk( perk ) )
				return false;
			else
					return true;
		case "specialty_additionalprimaryweapon":
			if( is_true( level.threegun_hacked ) ) //&& !player HasPerk( perk ) )
				return false;
			else
					return true;
		case "specialty_deadshot":
			if( is_true( level.ads_hacked ) ) //&& !player HasPerk( perk ) )
				return false;
			else
					return true;
		case "specialty_flakjacket":
			if( is_true( level.divetonuke_hacked ) ) //&& !player HasPerk( perk ) )
				return false;
			else
					return true;
		case "specialty_armorvest":
			if( is_true( level.jug_hacked ) ) //&& !player HasPerk( perk ) )
				return false;
			else
					return true;
	}
}
perk_hack(hacker)
{
	cost = 0;
	perk = GetEntArray( "zombie_vending", "targetname" );
	switch(self.perk.script_noteworthy){
	case "specialty_quickrevive":
		cost = perk["vending_revive"].HackCost * -1;
		level thread maps\_zombiemode_perks::Perk_Has_Already("specialty_quickrevive");
		level maps\vapp::dvar_all("player_lastStandBleedoutTime", "60");
		hacker playsoundtoplayer( "zmb_perks_packa_upgrade", hacker );
		if( is_true( level.quick_hacked ) )
			break;
		level.quick_hacked = true;
		return;
	case "specialty_rof":
		Cost = level.rof_hackCost * -1;
		level maps\vapp::dvar_all("perk_weapRateMultiplier", "0.55");
		level maps\vapp::dvar_all("player_burstFireCooldown", "0.1");
		hacker playsoundtoplayer( "zmb_perks_packa_upgrade", hacker );
		if( is_true( level.rof_hacked ) )
			break;
		level.rof_hacked = true;
		return;
	case "specialty_longersprint":
		cost = perk["vending_marathon"].HackCost * -1;
		hacker playsoundtoplayer( "zmb_perks_packa_upgrade", hacker );
		if( is_true( level.sour_hacked ) )
			break;
		level.sour_hacked = true;
		return;
	case "specialty_fastreload":
		cost = perk["vending_sleight"].HackCost * -1;
		level thread maps\_zombiemode_perks::Perk_Has_Already("specialty_fastreload");
		level maps\vapp::dvar_all("perk_weapReloadMultiplier", "0.37");
		hacker playsoundtoplayer( "zmb_perks_packa_upgrade", hacker );
		if( is_true( level.fast_hacked ) )
			break;
		level.fast_hacked = true;
		return;
	case "specialty_additionalprimaryweapon":
		cost = perk["vending_additionalprimaryweapon"].HackCost * -1;
		level maps\vapp::dvar_all("player_ClipSizeMultiplier", "1.52");
		level.ClipSize = 1.52;
		hacker playsoundtoplayer( "zmb_perks_packa_upgrade", hacker );
		if( is_true( level.threegun_hacked ) )
			break;
		level.threegun_hacked = true;
		return;
	case "specialty_deadshot":
		cost = perk["vending_deadshot"].HackCost * -1;
		level maps\vapp::dvar_all("perk_weapSpreadMultiplier", "0.45");
		hacker playsoundtoplayer( "zmb_perks_packa_upgrade", hacker );
		if( is_true( level.ads_hacked ) )
			break;
		level.ads_hacked = true;
		return;
	case "specialty_flakjacket":
		cost = perk["vending_divetonuke"].HackCost * -1;
		set_zombie_var( "zombie_perk_divetonuke_radius", 400 );
		set_zombie_var( "zombie_perk_divetonuke_min_damage", 4000 );
		set_zombie_var( "zombie_perk_divetonuke_max_damage", 10000 );
		hacker playsoundtoplayer( "zmb_perks_packa_upgrade", hacker );
		if( is_true( level.divetonuke_hacked ) )
			break;
		level.divetonuke_hacked = true;
		return;
	case "specialty_armorvest":
		cost = perk["vending_jugg"].HackCost * -1;
		level thread maps\_zombiemode_perks::Perk_Has_Already("specialty_armorvest");
		hacker playsoundtoplayer( "zmb_perks_packa_upgrade", hacker );
		if( is_true( level.jug_hacked ) )
			break;
		level.jug_hacked = true;
		return;
	}
		hacker notify(self.perk.script_noteworthy + "_stop");
		hacker maps\_zombiemode_score::player_add_points(Cost,Cost);
}


		