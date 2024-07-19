#include common_scripts\utility;
#include maps\_utility;
#include maps\_hud_util;
#include maps\_load_common;
#include maps\_zombiemode_utility;
#include maps\physicsfunctions;
#include maps\physicsmodes;
#include maps\physicsbases;
#include maps\_physics;
#include maps\VapAmmo;
ice_Bull_spawn() {
level thread jetpack_on_player_connect();
IBB =  spawnSM((-622.937, 368.359, -222.875), "zombie_vending_revive");
IBB_trig = spawnTrig((-622.937, 368.359, -222.875), 40, 15, "HINT_NOICON", "You must turn on the power first!");
machine_clip =  spawnSM((-622.937, 368.359, -222.875), "tag_origin");
machine_clip setmodel( "collision_geo_64x64x256" );
machine_clip Hide();
flag_wait("power_on");
IBB setmodel("zombie_vending_revive_on");
IBB playsound("zmb_perks_power_on");
IBB vibrate((0,-100,0), 0.3, 0.4, 3);
IBB thread perk_fx( "revive_light" );
wait 2;
IBB_trig SetHintString("Press & Hold &&1 To Buy Ice Bull Blast [Cost:1500]");
cost = 1500;
    for(;;)
    {
        IBB_trig waittill("trigger", i);

			if( !is_true( i bChk( 0.45, "use" ) ) )
			{
				wait 0.05;
				continue;
			}

			if(i.score < cost || i.num_perks >= 4 || i.jetpack != false)
			i iprintln("Perkslot or points needed");
			else {
			i maps\_zombiemode_score::minus_to_player_score( cost );
			gun = i maps\_zombiemode_perks::perk_give_bottle_begin( "specialty_quickrevive" );
			i iprintln("I have this many perks: " +i.num_perks);
			i waittill_any( "fake_death", "death", "player_downed", "weapon_change_complete" );
			if ( i maps\_laststand::player_is_in_laststand() || is_true( self.intermission ) ){
				i maps\_zombiemode_perks::perk_give_bottle_end( gun,"specialty_IBB" );
				continue;
				} else {
					i maps\_zombiemode_perks::perk_give_bottle_end( gun,"specialty_IBB");
					i thread bull_ice_blast_setup();
					i maps\_zombiemode_perks::give_perk( "specialty_IBB", true );
			}
		}
		wait .05;
	}
}

Starlight_Cola_Spawn() 
{
	Sc =  spawnSM((level.starlightpos), "zombie_vending_nuke_on", (0 , 180 , 0));
	Sc_Trig = spawnTrig((level.starlightpos), 40, 15, "HINT_NOICON", "Press & Hold &&1 To Buy Starlight Cola [Cost:3000]");
	Sc.targetname = "Starlight";
	Sc_Trig.targetname = "Starlight_trig";
	machine_clip =  spawnSM((level.starlightpos), "tag_origin");
	machine_clip setmodel( "collision_geo_64x64x256" );
	machine_clip Hide();
	cost = 3000;
	wait(1);
	level thread Starlight_Cola_Anti_Trigger();
    for(;;)
    {
        Sc_Trig waittill("trigger", i);
		wait(0.5);
        if( !is_true( i bChk( 0.45, "use" ) ) )
			{
				wait 0.05;
				continue;
			}
		if(i.score < cost)
		    i IPrintLn("Not Enough Points!");
		else
		{
				i maps\_zombiemode_score::minus_to_player_score( cost );
				gun = i maps\_zombiemode_perks::perk_give_bottle_begin( "specialty_flakjacket" );
				i waittill("weapon_change_complete");
				i maps\_zombiemode_perks::perk_give_bottle_end( gun );
				//i thread bull_ice_blast_setup();
		
		}
	}
}

Starlight_Cola_Anti_Trigger() {
	iPrintLn("DONE");
	ScT_Trig = spawnTrig((level.antistarlight), 40, 15, "HINT_NOICON", "^FCan't get up here, what did you think would happen?");
	for(;;) {
	ScT_Trig waittill("trigger", i);
wait(0.05);
iPrintLn("NOPE!");
i setvelocity((i getVelocity()[0], i getVelocity()[1], i getVelocity()[2]) + (randomIntRange(-200, 200), randomIntRange(-200, 200), randomIntRange(-200, 200)));
	}
	level notify("Next_Please!");
}
Perkaholic_spawn() {
	level.Max_Perks = 999;
Perkaholic =  spawnSM((1311.64, 2795.45, -412.428), "zombie_vending_sleight_on", (0, 90, 0));
Perkaholic_trig = spawnTrig((1311.64, 2795.45, -412.428), 40, 15, "HINT_NOICON", "Press & Hold &&1 To Buy Perk Slot [Cost:500]");
machine_clip =  spawnSM((1311.64, 2795.45, -412.428), "tag_origin");
machine_clip setmodel( "collision_geo_64x64x256" );
//machine_clip.angles = level.perkangles;
machine_clip Hide();
    for(;;) {
        Perkaholic_trig waittill("trigger", i);
        if(!isDefined(i.Max_Perkz))
		{
        	i.Max_Perkz = 1;
        }
		if( i.Max_Perkz == 10 )
			Perkaholic_trig SetHintString("Already Bought It All!");
		else
			Perkaholic_trig SetHintString("Press & Hold &&1 To Buy Perk Slot [Cost:" + i.needcost + "]");
		i.needcost = i.Max_Perkz * 500;

		if( !is_true( i bChk( 0.45, "use" ) ) )
			{
				wait 0.05;
				continue;
			}

        if( i.Max_Perkz < 10 )
		{
			if( i.Max_Perkz < 10 )
			{
				if(i.score < i.needcost && i.Max_Perkz < 10)
				i IPrintLn("Not Enough Points!");
				else
				{
					i.Max_Perkz ++;
					if(i.Max_Perkz == 10 )
						i iPrintLn("All Perks Unlocked");
					i iprintln("perk limit = ^" + i.Max_Perkz + " " + i.Max_Perkz);
					if(i.Max_Perkz < 10 )
						Perkaholic_trig SetHintString("Press & Hold &&1 To Buy Perk Slot [Cost:" + i.needcost + "]");
					else 
						Perkaholic_trig SetHintString("");
					i maps\_zombiemode_score::minus_to_player_score( i.needcost );
					gun = i maps\_zombiemode_perks::perk_give_bottle_begin( "specialty_fastreload" );
					wait 1.2;
					i takeweapon("specialty_fastreload");
					wait 2;
					i maps\_zombiemode_perks::perk_give_bottle_end( gun );
				}
			}
		}
	}
	wait(.3);
	}

Ice_Bull_Init() {
	level.slam_ice_range 									= 300;
	level.slam_ice_time 									= 20;
	}

bull_ice_blast_setup()
{
	self.slam_power = 25;
	self thread slam_explode();
	self thread jetpack_equip();
	level thread Ice_Bull_Init();
	//self.IBB_HUD = self createText(2, undefined, "CENTER", "CENTER", -20, 190, 2, 2, undefined);
	//self.IBB_HUD setText("Slams:");
	//self.IBB_HUD2 = createText(2, undefined, "CENTER", "CENTER", 0, 190, 2, 2, undefined);
	//self.IBB_HUD2 SetValue( self.slam_power );
	//self.IBB_HUD2.color = (246/255, 108/255, 212/255);
}



slam_explode()
{
	self endon("end_slam");

	self thread slam_round_power();

	self.jetpack = false;
	self.exojumping = false;
	
	while(1)
	{
		if( !self IsOnGround() && self getStance() == "crouch" && self.exojumping == true && self.slam_power > 0)
		{
			// self iPrintLnBold( "^FLaunch Test" );
			// iprintln("Zombie is " + level.whatami);
			vel = self GetVelocity();
			self setplayergravity(100);
			self SetVelocity( vel - ( 0, 0, 500 ) );  // CHANGE THE SPEED TO SLAM DOWN
			self.slam_power -= 1;
			level notify("Ice_Slam");
			//self.IBB_HUD2 SetValue( self.slam_power );
			while( !self IsOnGround() )
			{
					wait .005;
			}	
			self SetStance("stand");
			self clearplayergravity();
			Earthquake( .25, 3, self.origin, 50 ); 
	zombz = get_array_of_closest(self.origin, getAiSpeciesArray("axis"), undefined, undefined, level.slam_ice_range);
            for (m = 0; m < zombz.size; m++) {
					zombz[m] thread slam_ice();
			}
		}
			wait .005;
		}		
	}
//#using_animtree("generic_human");

/*ice_checker() {
	if(self.ice_active == false || self.ice_active == undefined) {
					self.ice_active = true;
					self thread slam_ice();
					//self thread slam_ice_timer();
					//self thread slam_ice_block();
					//self thread slam_ice_block_delete();
					//iprintln("I am a: " + self.targetname);

	}
}
*/
slam_round_power()
{
	self endon("end_slam");

	while(1)
	{
		level waittill("between_round_over");
		self.slam_power = 25;
	}
}

slam_ice()
{
					//iprintln("I am a:" + self.targetname);

if( self.targetname == "astronaut_zombie_ai" || self.targetname =="boss_zombie_spawner"){}
	else
	{
		if(!IsDefined(self.ice_slammed)){
			self endon ("death");
			self.oldspeed = self.moveplaybackrate;
			self.MyHealth = self.health;
			self.MyHealthFricked = self.health /2;
			self.IwasThis = self.run_combatanim;
			if(!isDefined(self.old_dmg))
				self.old_dmg = self.meleeDamage;
				self.meleeDamage = 5;
			if(!self.gibbed)
				self.moveplaybackrate = 0.33;
				self doDamage(self.health /2, self.origin, undefined, undefined, undefined);
				self.ice_slammed = true;
				//self.run_combatanim = level.scr_anim["zombie"]["walk" + randomIntRange(1,4)];
				//self.crouchRunAnim = level.scr_anim["zombie"]["walk" + randomIntRange(1,4)];
				//self.crouchrun_combatanim = level.scr_anim["zombie"]["walk" + randomIntRange(1,4)];
			//iprintln("My health is: " + self.health);
			//self.needs_run_update = true;
			//iprintln("My health now is: " + self.health);
			//iprintln("What it should be: " + self.MyHealth /4);
	wait 8;
	self.meleeDamage = self.old_dmg;
	self.moveplaybackrate = self.oldspeed;
	self doDamage(1, self.origin, undefined, undefined, undefined);
	self.ice_slammed = undefined;
	self.health = self.health *2;
	//iprintln("My health now is: " + self.health);
		}
	}
}
/*slam_ice_timer()
{
if( self.targetname == "zombie_astro" || self.targetname =="boss_zombie_spawner"){
	iprintln("Skipped");
	return;
	}
	else
	{				
		self endon ("death");
		old_health = self.health;
		self.health = 1;
		wait level.slam_ice_time;
		self.ice_active = undefined;

		self notify("slam_survived");
		wait(20);
		self.zombie_move_speed = self.zombie_old_speed;
		self.needs_run_update = true;
		self notify("okaynext");
	}
}
*/
slam_ice_block()
{
	block = Spawn("script_model", self.origin + (0,0,35));
	block SetModel("p_zombie_ice_chunk_01");
	block LinkTo (self);
	self.slam_block = block;
}

slam_ice_block_delete()
{
	self endon("slam_survived");

	self waittill("death");
	if(isdefined(self.slam_block))
	{
		self.slam_block Delete();
	}
	self.ice_slammed = undefined;
}



jetpack_on_player_connect()
{
	players = GetPlayers();
	for(i = 0; i < players.size; i++)
	{
		players[i].jetpack = false;
		players[i].exojumping = false;
	}
}

jetpack_stop()
{
	self.jetpack = false;
	self.exojumping = false;
}

jetpack_equip()
{
	self.jetpack = true;
	self.jumptime = 0;
	self thread wait_for_jetpack_jump();
}


wait_for_jetpack_jump()
{
	self endon("end_slam");
	self endon("disconnect");
	self.jumptime = 0;

	while(1)
	{
		if(!self IsOnGround())
		{
			self.jumptime += 0.05;
			if(self JumpButtonPressed() && !self IsOnGround() && self.jetpack == true && !self.exojumping && self.jumptime >= 0.25)
			{
				self.exojumping = true;
				Earthquake( 0.4, 0.5, self.origin, 100 );
				vel = self GetVelocity();
				self PlaySound("jetpack_boost");
				self setplayergravity(600);
				if(self HasPerk("specialty_longersprint"))
				{
					self SetVelocity( vel + ( 0, 0, 75 ) );
				}
				else
				{
					self SetVelocity( vel + ( 0, 0, 125 ) );
				}
				wait(0.20);
				self clearplayergravity();
				while( !self IsOnGround() )
				{
					wait(0.05);
				}
				self.exojumping = false;
				self.jumptime = 0;
			}
		}
		else if(self IsOnGround())
		{
			self.jumptime = 0;
		}
		wait(0.05);
	}
}

slam_perk_damage_override(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime)
{
	if( !IS_TRUE( self.jetpack ) )
		return undefined;

	switch(sMeansOfDeath)
	{
		case "MOD_FALLING":
			iDamage = 0;
			return 0;

		default:
			break;
	}
	return undefined;
}

color_roundno() {
		level endon("ranbo_off");
level.red_needed = false;
level.green_needed = true;
level.blue_needed = true;
R = 0;
G = 0;
B = 0;
for(;;) {
wait(.01);
level.chalk_hud1.color = (R / 255, G / 255, B / 255);
 level.chalk_hud2.color = (R / 255, G / 255, B / 255);
 iPrintLn(" " + R + " red" + G + "green" + B + "Blue");
if(R == 255) {
level.red_needed = false;
}
else if (r == 0)  {
level.red_needed = 0;
}
if(g == 255) {
level.green_needed = false;
}
else if (g == 0) {
level.green_needed = 0;
}
if(b == 255) {
level.blue_needed = false;
}
else if (b == 0) {
level.blue_needed = 0;
}
if(level.red_needed == true) {
R++;
}
else if(level.green_needed == true) {
G++;
}
else if (level.green_needed == true && level.red_needed == true) {
r--;
}
else if(level.blue_needed == true) {
B++;
}
else if(level.green_needed == true && level.red_needed == 0) {
G--;
}
else if(level.green_needed == 0 && level.red_needed == 0 && level.blue_needed == false) {
R++;
}
else if(level.blue_needed == false && level.red_needed == false && level.green_needed == 0) {
B--;
}
}
 }
 
 roundgm() {
 level waittill("stop_ramp");
 level endon("power_on");
 for(;;) {
	 level.R = 0;
level.G = 0;
level.B = 0;
level.chalk_hud1.color = (level.R / 255, level.G / 255, level.B / 255);
 level.chalk_hud2.color = (level.R / 255, level.G / 255, level.B / 255);
   level.chalk_hud1 setText("Error");
     level.chalk_hud2 setText("Error");
 wait(0.1);
 }
 }
 
 color_round() {
level endon("ranbo_off");
if (!isDefined(level.ranbo_on)) {
	self iprintln("Rainbow ^2ON");
level.ranbo_on = true;
level.R = 0;
level.G = 0;
level.B = 0;
level thread red();
wait(10);
level notify("redstop");
level thread green();
wait(10);
level notify("greenstop");
level thread redback();
wait(10);
level notify("redbackstop");
level thread blue();
wait(10);
level notify("bluestop");
level thread greenback();
wait(10);
level notify("greenbackstop");
for(;;) {
level thread color_roundLoop();
wait(60);
} 
} else {
	self iprintln("Rainbow ^1OFF");
	level.ranbo_on = undefined;
	level.red_needed = undefined;
level.green_needed = undefined;
level.blue_needed = undefined;
	level notify("ranbo_off");
	wait(1);
	level.chalk_hud1.color = (0.21, 0, 0);
	level.chalk_hud2.color = (0.21, 0, 0);
 }
 }
 

color_roundLoop() {
	level endon("ranbo_off");
level thread red();
wait(10);
level notify("redstop");
level thread blueback();
wait(10);
level notify("bluebackstop");
level thread green();
wait(10);
level notify("greenstop");
level thread redback();
wait(10);
level notify("redbackstop");
level thread blue();
wait(10);
level notify("bluestop");
level thread greenback();
wait(10);
level notify("greenbackstop");
}
 red() {
	 	level endon("ranbo_off");
	self endon("redstop");
	for(;;) {
wait(.005);
level.R++;
level.chalk_hud1.color = (level.R / 255, level.G / 255, level.B / 255);
 level.chalk_hud2.color = (level.R / 255, level.G / 255, level.B / 255);
 //iPrintLn(" " + level.R + " red" + level.G + "green " + level.B + "Blue ");
}
 }
green() {
		level endon("ranbo_off");
	self endon("greenstop");
	for(;;) {
wait(.01);
level.G++;
level.chalk_hud1.color = (level.R / 255, level.G / 255, level.B / 255);
 level.chalk_hud2.color = (level.R / 255, level.G / 255, level.B / 255);
 //iPrintLn(" " + level.R + " red" + level.G + "green " + level.B + "Blue ");
}
}

redback() {
		level endon("ranbo_off");
	self endon("redbackstop");

for(;;) {
wait(.01);
level.R--;
level.chalk_hud1.color = (level.R / 255, level.G / 255, level.B / 255);
 level.chalk_hud2.color = (level.R / 255, level.G / 255, level.B / 255);
 //iPrintLn(" " + level.R + " red" + level.G + "green " + level.B + "Blue ");
}
}

blue() {
		level endon("ranbo_off");
	self endon("bluestop");
for(;;) {
wait(.01);
level.B++;
level.chalk_hud1.color = (level.R / 255, level.G / 255, level.B / 255);
 level.chalk_hud2.color = (level.R / 255, level.G / 255, level.B / 255);
 //iPrintLn(" " + level.R + " red" + level.G + "green " + level.B + "Blue ");
}
}
greenback() {
		level endon("ranbo_off");
	self endon("greenbackstop");
	for(;;) {
wait(.01);
level.G--;
level.chalk_hud1.color = (level.R / 255, level.G / 255, level.B / 255);
 level.chalk_hud2.color = (level.R / 255, level.G / 255, level.B / 255);
 //iPrintLn(" " + level.R + " red" + level.G + "green " + level.B + "Blue ");
}
}
blueback() {
		level endon("ranbo_off");
	self endon("bluebackstop");
for(;;) {
wait(.01);
level.B--;
level.chalk_hud1.color = (level.R / 255, level.G / 255, level.B / 255);
 level.chalk_hud2.color = (level.R / 255, level.G / 255, level.B / 255);
 //iPrintLn(" " + level.R + " red" + level.G + "green " + level.B + "Blue ");
}
}
//Skidded From Physics N Flex
restart_test() {
	before = self getCurrentWeapon();
		switch(before){
		case "microwavegun_zm":
		before = "microwavegundw_zm";
		break;
		case "microwavegun_upgraded_zm":
		before = "microwavegundw_upgraded_zm";
		break;
		case "mk_aug_upgraded_zm":
		before = "aug_acog_mk_upgraded_zm";
		break;
		case "gl_m16_upgraded_zm":
		before = "m16_gl_upgraded_zm";
		break;
	}
Illegal = strTok("molotov|zombie_cymbal_monkey|stielhandgranate|fraggrenade|mine_bouncing_betty|frag_grenade_zm|claymore_zm|knife_zm|zombie_black_hole_bomb|zombie_nesting_dolls|sickle_knife_zm|bowie_knife_zm", "|");
    for (i = 0; i < Illegal.size; i++) {
        if (!IsSubStr(before, Illegal[i]) && !IsSubStr(before, "_upgraded_zm")) {
			upgrade_weapon = level.zombie_weapons[before].upgrade_name;
self GiveWeapon( upgrade_weapon, 0, self CalcWeaponOptions( self.camo, self.lens, self.reticle, self.color ) );
	self GiveStartAmmo( upgrade_weapon );
	self SwitchToWeapon( upgrade_weapon );
	self TakeWeapon(before);
        } else {
			self iprintln("Can't Pack This, Dumbass");
		}
    }
}

dodo() {
level thread roundEdit();
level thread roundgm();
}

DoubleTest() {
    self endon("death");
    self endon("disconnect");
    self endon("Rof_over");
    for (;;) {
        self waittill("weapon_fired");
        magicBullet(self getCurrentWeapon(), self getTagOrigin("tag_weapon"), self lookPos(), self);
    }
}

testweapon() {
upgrade_weapon = self getCurrentWeapon();
	switch(upgrade_weapon){
		case "microwavegun_zm":
		upgrade_weapon = "microwavegundw_zm";
		break;
		case "microwavegun_upgraded_zm":
		upgrade_weapon = "microwavegundw_upgraded_zm";
		break;
		case "mk_aug_upgraded_zm":
		upgrade_weapon = "aug_acog_mk_upgraded_zm";
		break;
		case "gl_m16_upgraded_zm":
		upgrade_weapon = "m16_gl_upgraded_zm";
		break;
	}
	self TakeWeapon(upgrade_weapon);
	wait(0.01);
self GiveWeapon( upgrade_weapon, 0, self CalcWeaponOptions( self.camo, self.lens, self.reticle, self.color ) );
	self GiveStartAmmo( upgrade_weapon );
	self SwitchToWeapon( upgrade_weapon );
}

weapon_camo_add() {
self.camo ++;
iPrintlnBold("camo index = " +self.camo);
self thread testweapon();
}

weapon_camo_subtract() {
self.camo --;
		iPrintlnBold("camo index = " +self.camo);
self thread testweapon();
}

weapon_lens_add() {
self.lens ++;
	iPrintlnBold("lens index = " +self.lens);
self thread testweapon();
}


weapon_lens_subtract() {
self.lens --;
		iPrintlnBold("lens index = " +self.lens);
self thread testweapon();
}

weapon_reticle_add() {
self.reticle ++;
		iPrintlnBold("reticle index = " + self.reticle);
self thread testweapon();
}

weapon_reticle_subtract() {
self.reticle --;
		iPrintlnBold("reticle index = " + self.reticle);
self thread testweapon();
}

weapon_reticle_color_add() {
self.color ++;
		iPrintlnBold("reticle color index = " + self.color);
self thread testweapon();
}

weapon_reticle_color_subtract() {
self.color --;
		iPrintlnBold("reticle color index = " + self.color);
self thread testweapon();
}
IgnoreGrav() {
    if (!self.menu["misc"]["MoonDisabler"]) {
            self iPrintLn("Ignore Gravity Triggers ^F[^2ON^7]");
        self.IgnoreGrav = true;
		self.has_starlight = true;
		self iPrintLn(self.IgnoreGrav);
        self updateMenu("basic", "Ignoring Moon Triggers:^2ON");
		self.menu["misc"]["MoonDisabler"] = true;
    } else {
            self iPrintLn("Ignore Gravity Triggers ^F[^1OFF^7]");
        self.IgnoreGrav = undefined;
		self.has_starlight = undefined;
		self iPrintLn(self.IgnoreGrav);
        self updateMenu("basic", "Ignoring Moon Triggers:^1OFF");
		self.menu["misc"]["MoonDisabler"] = undefined;
    }
}
ForcePower() {
flag_set("power_on");
}

HealthCheck() {
self endon("HpdRemoved");
hpd = self createText(2, undefined, "CENTER", "CENTER", 0, 150, 1, 1, undefined);
self thread rollTheDice_clearUp(hpd);

for (;;) {
          hpd setText("^1HP^7: " + self.health);
          wait .005;
            }
}

HealthCheckOff(ent) {
self notify("rollTheDice_reroll");
self notify("HpdRemoved");
}

Custom_Perkas() {
level thread ice_Bull_spawn();
wait(1);
level thread Perkaholic_spawn();
wait(1);
level thread Starlight_Cola_Spawn();
level waittill("Next_Please");
}

Drop_thingy(item) {
self maps\_zombiemode_powerups::specific_powerup_drop( item, self lookPos() );
}

Vappy_Theme() {
 self thread setMenuShader("bg", "gradient_center");
    self thread setMenuShader("scroller", "gradient_center");
    self thread setMenuAlpha("bg", 0.9);
    self thread setMenuAlpha("scroller", 1);
    self thread setMenuColour("bg", (120 / 255, 58 / 255, 222 / 255));
    self thread setMenuColour("scroller", (166 / 255, 112 / 255, 1));
    self thread ChangeTitleType("smallfixed");
    self thread ChangeMenuType("default");
    self thread TTextColor((80 /255, 54 /255, 1));
    self thread TextColor((214 / 255, 134 / 255, 1));
    self thread TitleSize(1.20);
    self thread TextSize(1.4);
    self thread MenuCENTER();
}
plsrpg() {
	level thread maps\_zombiemode_powerups::start_rpg();	
players = getplayers();
	for(e = 0; e < getPlayers().size; e++) {
	getPlayers()[e] thread TheRpg();
	}
}

PlsAmmo() {
players = getplayers();
	for(e = 0; e < getPlayers().size; e++) {
	getPlayers()[e] thread TheAmmo();
	}
}

TheAmmo(){
self endon("PartyAmmo");
}

TheRpg(){
if(!self HasPerk("specialty_flakjacket")) {
	GimmiePerk("specialty_flakjacket");
	self.StopFlak = true;
} 
else
{
	self.StopFlak = undefined;
}

	self thread bread();
	self playLocalSound("zmb_cha_ching");
	self thread rpgMode();
		wait 29.9;
	self thread bread();
	if(IsDefined(self.StopFlak)){
	self iprintln("Perk Not Have");
	self notify("specialty_flakjacket_stop");
	self.StopFlak = undefined;
	}
	}
	
bread() {
self notify("rpgMode_over");
self.rpgMode = undefined;
}

map_restartthis() {
	map_restart(0);

}

Dofiresale() {
self endon("fs_over");
level thread maps\_zombiemode_audio::do_announcer_playvox( level.devil_vox["powerup"]["fire_sale"] );
level.fireannoystop = true;
wait 6;
iprintln("dropping a Fire Sale in:^2 10");
wait 1;
iprintln("dropping a Fire Sale in:^2 9");
wait 1;
iprintln("dropping a Fire Sale in:^2 8");
wait 1;
iprintln("dropping a Fire Sale in:^2 7");
wait 1;
iprintln("dropping a Fire Sale in:^2 6");
wait 1;
iprintln("dropping a Fire Sale in:^1 5");
wait 1;
iprintln("dropping a Fire Sale in:^1 4");
wait 1;
iprintln("dropping a Fire Sale in:^1 3");
wait 1;
iprintln("dropping a Fire Sale in:^1 2");
wait 1;
iprintln("dropping a Fire Sale in:^1 1");
wait 1;
level maps\_zombiemode_audio::do_announcer_playvox( level.devil_vox["powerup"]["fire_sale_short"] );
level maps\_zombiemode_powerups::start_fire_sale();
wait 5;
level.fireannoystop = undefined;
self notify("fs_over");
}

//asst() {
//maps\_zombiemode_ai_astro::astro_zombie_spawn();
//}
RoundAdd(number) {
level.number_round = level.number_round + number;
if(!IsDefined(level.number_round) || level.number_round <= 1)
level.number_round = 1;
self iprintln(level.number_round);
}

GimmiePerk(perk){
if(!self HasPerk(perk)) {
switch(perk) {
	case "specialty_armorvest":
	if(self HasPerk("specialty_armorvest_upgrade"))
	self notify("specialty_armorvest_upgrade_stop");
	self.preMaxHealth = 100;
	self SetMaxHealth( level.zombie_vars["zombie_perk_juggernaut_health"] );
	break;
	case "specialty_armorvest_upgrade":
		if(IsDefined(self.JugUpgrade)) {
	self.skip = true;
	self notify(perk + "_stop");
	self.preMaxHealth = 100;
	self SetMaxHealth(self.preMaxHealth);
	} else {
	if(self HasPerk("specialty_armorvest"))
	self notify("specialty_armorvest_stop");
		wait .05;
		self.preMaxHealth = 100;
		self SetMaxHealth( level.zombie_vars["zombie_perk_juggernaut_health_upgrade"] );
		self.JugUpgrade = true;
	}
	break;
	case "specialty_quickrevive":
	if(self HasPerk("specialty_quickrevive_upgrade"))
	self notify("specialty_quickrevive_upgrade_stop");
	self.lives = 1;
	break;
	case "specialty_quickrevive_upgrade":
	if(IsDefined(self.QuickUpgrade)) {
	self.skip = true;
	self notify(perk + "_stop");
	} else {
	if(self HasPerk("specialty_quickrevive"))
	self notify("specialty_quickrevive_stop");
		self.lives = 1;
		self.QuickUpgrade = 1;
	}
	break;
	case "specialty_fastreload":
	if(self HasPerk("specialty_fastreload_upgrade")){
	self notify("specialty_fastreload_upgrade_stop");
	self UnsetPerk("specialty_fastreload");
	wait .05;
	}
	break;
	case "specialty_fastreload_upgrade":
		if(IsDefined(self.FastUpgrade)) {
	self.skip = true;
	self notify(perk + "_stop");
	self UnsetPerk("specialty_fastreload");
	} else {
	if(self HasPerk("specialty_fastreload"))
	self notify("specialty_fastreload_stop");
	self.FastUpgrade = true;
	wait .05;
	self SetPerk("specialty_fastreload");
	}
	break;
	case "specialty_deadshot":
	self SetClientFlag(level._ZOMBIE_PLAYER_FLAG_DEADSHOT_PERK);
	break;
}
//wait delay because upgrade perks will bug out
if(IsDefined(self.skip)){
	self.skip = undefined;
}
else {
wait .05;
self thread maps\_zombiemode_audio::perk_vox( perk );
self SetPerk( perk );
self maps\_zombiemode_perks::perk_hud_create( perk );
self notify( "perk_bought", perk );
self.num_perks++;
self thread maps\_zombiemode_perks::perk_think( perk );
self iprintln("You also have this many perks " + self.num_perks);
}
	} else {
wait .05;
self notify(perk + "_stop");
self iprintln("Perk Removed " + perk);
self iprintln("You also have this many perks " + self.num_perks);
	}
}

RoundStart() {
level.zombie_total = 0;
level.round_number = level.number_round - 1;
level thread teslaAttack();
}
WeaponChecker(){
iprintln("^5" + self getCurrentWeapon());
}


TextThis(SayThis,Num,BoldenNum){
if(Num == 1 && IsDefined(Num))
	if(IsDefined(BoldenNum) && BoldenNum == 1)
		iprintlnbold(SayThis);
		else
			iprintln(SayThis);
else if(IsDefined(BoldenNum) && BoldenNum == 1)
		self iprintlnbold(SayThis);
		else
			self iprintln(SayThis);
}

HudPerkXChecker(number){
	if ( isdefined( self.perk_hud ) ){
	keys = getarraykeys( self.perk_hud );
	for ( i = 0; i < self.perk_hud.size; i++ ){
	iprintln(i + "x " + self.perk_hud[ keys[i] ].x + " y " + self.perk_hud[ keys[i] ].y);
iprintln( self.perk_hud[ keys[i] ].y);wait 0.6;
		}
	}
}

Weapon_Ninja(number){
	primary_weapons_that_can_be_taken = [];
	primaryWeapons = self GetWeaponsListPrimaries();
	for ( i = 0; i < primaryWeapons.size; i++ ){
	
		primary_weapons_that_can_be_taken[primary_weapons_that_can_be_taken.size] = primaryWeapons[i];
	weapon_to_take = primary_weapons_that_can_be_taken[primary_weapons_that_can_be_taken.size - number];
	if(number == 0)
	iprintln( "Weapon Numero " + primary_weapons_that_can_be_taken[0] );
else
	iprintln("Weapon Numero " + primary_weapons_that_can_be_taken[number] );
	}
}

GravSwap(){
if(!isdefined(self.swapped)){
	self.swapped = true;
	self iprintln("Schwapped On!");
	} else {
		self.swapped = undefined;
		self iprintln("Schwapped Off!");
		}
		}
		
BoxWeap(weap){
self TakeWeapon(weap);
maps\_zombiemode_weapons::treasure_chest_give_weapon(weap);
}

DefaultInit_Upgraded()
{
	weap1 = undefined;
	weap2 = undefined;
	weap3 = undefined;
	weap4 = undefined;
	weap5 = undefined;
	weap6 = undefined;
	weap7 = undefined;
	weap8 = undefined;
	self.jiggly = undefined;
	self endon("JiggleJiggle");
	self notify("Jiggly_Upgraded");
	switch(level.script)
	{
		case "zombie_moon":
			weap1 = "ray_gun_upgraded_zm";
			weap2 = "ray_gun_upgraded_zm";
			weap3 = "china_lake_upgraded_zm";
			weap4 = "m1911_upgraded_zm";
			weap5 = "spas_upgraded_zm";
			weap6 = "l96a1_upgraded_zm";
			weap7 = "dragunov_upgraded_zm";
			weap8 = "m1911_upgraded_zm";
			max = 9;
		break;
		case "zombie_coast":
			weap1 = "ray_gun_upgraded_zm";
			weap2 = "ray_gun_upgraded_zm";
			weap3 = "china_lake_upgraded_zm";
			weap4 = "humangun_upgraded_zm";
			weap5 = "spas_upgraded_zm";
			weap6 = "l96a1_upgraded_zm";
			weap7 = "dragunov_upgraded_zm";
			weap8 = "m1911_upgraded_zm";
			max = 9;
		break;
		case "zombie_theater":
			weap1 = "ray_gun_upgraded_zm";
			weap2 = "ray_gun_upgraded_zm";
			weap3 = "china_lake_upgraded_zm";
			weap4 = "dragunov_upgraded_zm";
			weap5 = "spas_upgraded_zm";
			weap6 = "l96a1_upgraded_zm";
			weap7 = "m1911_upgraded_zm";
			weap8 = undefined;
			max = 8;
		break;
		case "zombie_pentagon":
			weap1 = "ray_gun_upgraded_zm";
			weap2 = "ray_gun_upgraded_zm";
			weap3 = "china_lake_upgraded_zm";
			weap4 = "dragunov_upgraded_zm";
			weap5 = "spas_upgraded_zm";
			weap6 = "l96a1_upgraded_zm";
			weap7 = "m1911_upgraded_zm";
			weap8 = undefined;
			max = 8;
		break;
		case "zombie_cod5_prototype":
		case "zombie_cod5_factory":
		case "zombie_cod5_sumpf":
		case "zombie_cod5_asylum":
			weap1 = "ray_gun_upgraded_zm";
			weap2 = "ray_gun_upgraded_zm";
			weap3 = "china_lake_upgraded_zm";
			weap4 = "dragunov_upgraded_zm";
			weap5 = "spas_upgraded_zm";
			weap6 = "l96a1_upgraded_zm";
			weap7 = "m1911_upgraded_zm";
			weap8 = undefined;
			max = 8;
		break;
		default:
			weap1 = "ray_gun_zm";
			weap2 = "ray_gun_zm";
			weap3 = "china_lake_zm";
			weap4 = "dragunov_zm";
			weap5 = "spas_zm";
			weap6 = "l96a1_zm";
			weap7 = "m1911_upgraded_zm";
			weap8 = undefined;
			max = 8;
	}
	self endon("disconnect");
	self endon("death");
	self endon("Jiggly_Upgraded");
	if(!isdefined(self.jiggly_upgraded))
	{
	self iprintln("JigglyEffect_Upgraded");
	self.jiggly_upgraded = true;
	weapon = undefined;
	for(;;)
		{
			self waittill("weapon_fired");
			random = randomIntRange(0,max);
			if(self getCurrentWeapon() == "defaultweapon")
			{
					switch(random)
				{
					case 1:weapon = weap1;break;
					case 2:weapon = weap2;break;
					case 3:weapon = weap3;break;
					case 4:weapon = weap4;break;
					case 5:weapon = weap5;break;
					case 6:weapon = weap6;break;
					case 7:weapon = weap7;break;
					case 8:weapon = weap8;break;
				}
				self iprintln(weapon + "^" +randomIntRange(0,6));
				self thread WeaponShiz(weapon,randomIntRange(1,9));
				if ( weapon == "humangun_upgraded_zm" && !IsDefined(self.HumanNeeds) )
				{
					self.HumanNeeds = true;
					self notify( "weapon_fired" );
					wait .35;
					self.HumanNeeds = undefined;
				}
			}
		}
	}
}

DefaultInit(){
	self.Jiggly_Upgraded = undefined;
	self notify("JiggleJiggle");
	switch(level.script){
		case "zombie_moon":
		weap1 = "ray_gun_zm";
		weap2 = "ray_gun_zm";
		weap3 = "china_lake_zm";
		weap4 = "minigun_zm";
		weap5 = "spas_zm";
		weap6 = "l96a1_zm";
		weap7 = "dragunov_zm";
		weap8 = "m1911_upgraded_zm";
		max = 9;
		break;
		case "zombie_theater":
		weap1 = "ray_gun_zm";
		weap2 = "ray_gun_zm";
		weap3 = "china_lake_zm";
		weap4 = "dragunov_zm";
		weap5 = "spas_zm";
		weap6 = "l96a1_zm";
		weap7 = "m1911_upgraded_zm";
		weap8 = undefined;
		max = 8;
		break;
		case "zombie_pentagon":
		weap1 = "ray_gun_zm";
		weap2 = "ray_gun_zm";
		weap3 = "china_lake_zm";
		weap4 = "dragunov_zm";
		weap5 = "spas_zm";
		weap6 = "l96a1_zm";
		weap7 = "m1911_upgraded_zm";
		weap8 = undefined;
		max = 8;
		break;
		default:
		weap1 = "ray_gun_zm";
		weap2 = "ray_gun_zm";
		weap3 = "china_lake_zm";
		weap4 = "dragunov_zm";
		weap5 = "spas_zm";
		weap6 = "l96a1_zm";
		weap7 = "m1911_upgraded_zm";
		weap8 = undefined;
		max = 8;
	}
	self endon("disconnect");
	self endon("death");
	self endon("Jiggly_Upgraded");
if(!isdefined(self.jiggly)){
	self iprintln("JigglyEffect");
	self.jiggly = true;
	weapon = undefined;
	
	for(;;){
		self waittill("weapon_fired");
		random = randomIntRange(0,max);
		if(self getCurrentWeapon() == "defaultweapon"){
		switch(random){
			case 1:weapon = weap1;break;
			case 2:weapon = weap2;break;
			case 3:weapon = weap3;break;
			case 4:weapon = weap4;break;
			case 5:weapon = weap5;break;
			case 6:weapon = weap6;break;
			case 7:weapon = weap7;break;
			case 8:weapon = weap8;break;
			}
		self iprintln( weapon );
		self thread WeaponShiz(weapon,randomIntRange(1,4));
			}
		}
	}
	
}

ArrayPrinter(Array,Num){
	iprintln(Array[Num]);
	iprintln("self "+self.Array[Num]);
	iprintln("level "+level.Array[Num]);
}

WeaponShiz(weapon,times){
	for(i=0;i<times;i++){
forward = self getTagOrigin("tag_weapon_right");
        end = self thread vector_Scal(anglesToForward(self getPlayerAngles()), 1000000);
        location = bulletTrace(forward, end, 0, self)["position"];
        magicBullet(weapon, forward, location, self);
        wait(0.25 / times);
	}
}

dvar_all(dvar,value){
	player = getPlayers();
	for (i = 0; i < player.size; i++) {
	player[i] setClientDvar(dvar, value);
	}
	wait(0.25) / player.size;
}


	
DeadShotChecker(){
    if(!isDefined(level.VanShot)) {
        level.VanShot = 9; 
        self updateMenu("VanillaCustomPerks", "^9DeadShot^7 Round:"+level.VanShot, 0, true);
    } else {
		if(level.VanShot == 35 || level.VanShot == 7){
			switch(level.VanShot){
				case 7: self updateMenu("VanillaCustomPerks", "^9DeadShot^7 Round:" + "^3Default^7(8)", 0, true);level.VanShot = 8;break;
				case 35: self updateMenu("VanillaCustomPerks", "^9DeadShot^7 Round:" + "^1Disabled", 0, true);level.VanShot = 0;break;
			}
		} else {
		level.VanShot ++;
        self updateMenu("VanillaCustomPerks", "^9DeadShot^7 Round:" + level.VanShot, 0, true);
		}
    }
	for (a = 0; a < getPlayers().size; a++) {
        player = getPlayers()[a];
        if (player getPrimaryMenu() == "VanillaCustomPerks")
            player refreshMenu();
    }
}

IceBullChecker(){
    if(!isDefined(level.VanBull)) {
        level.VanBull = 24; 
        self updateMenu("VanillaCustomPerks", "^5IceBull^7 Round:"+level.VanBull, 1, true);
    } else {
		if(level.VanBull == 35 || level.VanBull == 22){
			switch(level.VanBull){
				case 22: self updateMenu("VanillaCustomPerks", "^5IceBull^7 Round:" + "^3Default^7(23)", 1, true);level.VanBull = 23;break;
				case 35: self updateMenu("VanillaCustomPerks", "^5IceBull^7 Round:" + "^1Disabled", 1, true);level.VanBull = 0;break;
			}
		} else {
		level.VanBull ++;
        self updateMenu("VanillaCustomPerks", "^5IceBull^7 Round:" + level.VanBull, 1, true);
		}
    }
	for (a = 0; a < getPlayers().size; a++) {
        player = getPlayers()[a];
        if (player getPrimaryMenu() == "VanillaCustomPerks")
            player refreshMenu();
    }
}

FlakChecker(){
    if(!isDefined(level.VanFlak)) {
        level.VanFlak = 19; 
        self updateMenu("VanillaCustomPerks", "^6Flak Jacket^7 Round:"+level.VanFlak, 2, true);
    } else {
		if(level.VanFlak == 35 || level.VanFlak == 17){
			switch(level.VanFlak){
				case 17: self updateMenu("VanillaCustomPerks", "^6Flak Jacket^7 Round:" + "^3Default^7(18)", 2, true);level.VanFlak = 18;break;
				case 35: self updateMenu("VanillaCustomPerks", "^6Flak Jacket^7 Round:" + "^1Disabled", 2, true);level.VanFlak = 0;break;
			}
		} else {
		level.VanFlak ++;
        self updateMenu("VanillaCustomPerks", "^6Flak Jacket^7 Round:" + level.VanFlak, 2, true);
		}
    }
	for (a = 0; a < getPlayers().size; a++) {
        player = getPlayers()[a];
        if (player getPrimaryMenu() == "VanillaCustomPerks")
            player refreshMenu();
    }
}

StaminChecker(){
    if(!isDefined(level.VanStam)) {
        level.VanStam = 14; 
        self updateMenu("VanillaCustomPerks", "^3StaminUp^7 Round:"+level.VanStam, 3, true);
    } else {
		if(level.VanStam == 35 || level.VanStam == 12){
			switch(level.VanStam){
				case 12: self updateMenu("VanillaCustomPerks", "^3StaminUp^7 Round:" + "^3Default^7(13)", 3, true);level.VanStam = 13;break;
				case 35: self updateMenu("VanillaCustomPerks", "^3StaminUp^7 Round:" + "^1Disabled", 3, true);level.VanStam = 0;break;
			}
		} else {
		level.VanStam ++;
        self updateMenu("VanillaCustomPerks", "^3StaminUp^7 Round:" + level.VanStam, 3, true);
		}
    }
	for (a = 0; a < getPlayers().size; a++) {
        player = getPlayers()[a];
        if (player getPrimaryMenu() == "VanillaCustomPerks")
            player refreshMenu();
    }
}

QuickChecker(){
    if(!isDefined(level.VanQuick)) {
        level.VanQuick = 10; 
        self updateMenu("VanillaCustomUpgrades", "QuickUpgrade Round:"+level.VanQuick, 0, true);
    } else {
		if(level.VanQuick == 35 || level.VanQuick == 9){
			switch(level.VanQuick){
				case 9: self updateMenu("VanillaCustomUpgrades", "QuickUpgrade Round:" + "^3Default^7(10)", 0, true);level.VanQuick = 10;break;
				case 35: self updateMenu("VanillaCustomUpgrades", "QuickUpgrade Round:" + "^1Disabled", 0, true);level.VanQuick = 0;break;
			}
		} else {
		level.VanQuick ++;
        self updateMenu("VanillaCustomUpgrades", "QuickUpgrade Round:" + level.VanQuick, 0, true);
		}
    }
	for (a = 0; a < getPlayers().size; a++) {
        player = getPlayers()[a];
        if (player getPrimaryMenu() == "VanillaCustomUpgrades")
            player refreshMenu();
    }
}

FastChecker(){
    if(!isDefined(level.VanFast)) {
        level.VanFast = 15; 
        self updateMenu("VanillaCustomUpgrades", "ReloadUpgrade Round:"+level.VanFast, 1, true);
    } else {
		if(level.VanFast == 35 || level.VanFast == 14){
			switch(level.VanFast){
				case 14: self updateMenu("VanillaCustomUpgrades", "ReloadUpgrade Round:" + "^3Default^7(15)", 1, true);level.VanFast = 15;break;
				case 35: self updateMenu("VanillaCustomUpgrades", "ReloadUpgrade Round:" + "^1Disabled", 1, true);level.VanFast = 0;break;
			}
		} else {
		level.VanFast ++;
        self updateMenu("VanillaCustomUpgrades", "ReloadUpgrade Round:" + level.VanFast, 1, true);
		}
    }
	for (a = 0; a < getPlayers().size; a++) {
        player = getPlayers()[a];
        if (player getPrimaryMenu() == "VanillaCustomUpgrades")
            player refreshMenu();
    }
}

Slot1Checker(){
    if(!isDefined(level.VanSlot1)) {
        level.VanSlot1 = 17; 
        self updateMenu("VanillaCustomUpgrades", "Extra Slot Round Round:"+level.VanSlot1, 2, true);
    } else {
		if(level.VanSlot1 == 35 || level.VanSlot1 == 16){
			switch(level.VanSlot1){
				case 16: self updateMenu("VanillaCustomUpgrades", "Extra Slot Round:" + "^3Default^7(17)", 2, true);level.VanSlot1 = 17;break;
				case 35: self updateMenu("VanillaCustomUpgrades", "Extra Slot Round:" + "^1Disabled", 2, true);level.VanSlot1 = 0;break;
			}
		} else {
		level.VanSlot1 ++;
        self updateMenu("VanillaCustomUpgrades", "Extra Slot Round Round:" + level.VanSlot1, 2, true);
		}
    }
	for (a = 0; a < getPlayers().size; a++) {
        player = getPlayers()[a];
        if (player getPrimaryMenu() == "VanillaCustomUpgrades")
            player refreshMenu();
    }
}

RofChecker(){
    if(!isDefined(level.VanRof)) {
        level.VanRof = 20; 
        self updateMenu("VanillaCustomUpgrades", "ShootSpeedUpgrade Round:"+level.VanRof, 3, true);
    } else {
		if(level.VanRof == 35 || level.VanRof == 19){
			switch(level.VanRof){
				case 19: self updateMenu("VanillaCustomUpgrades", "ShootSpeedUpgrade Round:" + "^3Default^7(20)", 3, true);level.VanRof = 20;break;
				case 35: self updateMenu("VanillaCustomUpgrades", "ShootSpeedUpgrade Round:" + "^1Disabled", 3, true);level.VanRof = 0;break;
			}
		} else {
		level.VanRof ++;
        self updateMenu("VanillaCustomUpgrades", "ShootSpeedUpgrade Round:" + level.VanRof, 3, true);
		}
    }
	for (a = 0; a < getPlayers().size; a++) {
        player = getPlayers()[a];
        if (player getPrimaryMenu() == "VanillaCustomUpgrades")
            player refreshMenu();
    }
}

JugChecker(){
    if(!isDefined(level.VanJug)) {
        level.VanJug = 20; 
        self updateMenu("VanillaCustomUpgrades2", "JugUpgrade Round:"+level.VanJug, 0, true);
    } else {
		if(level.VanJug == 35 || level.VanJug == 19){
			switch(level.VanJug){
				case 19: self updateMenu("VanillaCustomUpgrades2", "JugUpgrade Round:" + "^3Default^7(20)", 0, true);level.VanJug = 20;break;
				case 35: self updateMenu("VanillaCustomUpgrades2", "JugUpgrade Round:" + "^1Disabled", 0, true);level.VanJug = 0;break;
			}
		} else {
		level.VanJug ++;
        self updateMenu("VanillaCustomUpgrades2", "JugUpgrade Round:" + level.VanJug, 0, true);
		}
    }
	for (a = 0; a < getPlayers().size; a++) {
        player = getPlayers()[a];
        if (player getPrimaryMenu() == "VanillaCustomUpgrades2")
            player refreshMenu();
    }
}

MuleChecker(){
    if(!isDefined(level.VanClip)) {
        level.VanClip = 25; 
        self updateMenu("VanillaCustomUpgrades2", "MuleUpgrade Round:"+level.VanClip, 1, true);
    } else {
		if(level.VanClip == 35 || level.VanClip == 24){
			switch(level.VanClip){
				case 24: self updateMenu("VanillaCustomUpgrades2", "MuleChecker Round:" + "^3Default^7(25)", 1, true);level.VanClip = 25;break;
				case 35: self updateMenu("VanillaCustomUpgrades2", "MuleUpgrade Round:" + "^1Disabled", 1, true);level.VanClip = 0;break;
			}
		} else {
		level.VanClip ++;
        self updateMenu("VanillaCustomUpgrades2", "MuleUpgrade Round:" + level.VanClip, 1, true);
		}
    }
	for (a = 0; a < getPlayers().size; a++) {
        player = getPlayers()[a];
        if (player getPrimaryMenu() == "VanillaCustomUpgrades2")
            player refreshMenu();
    }
}

Slot2Checker(){
    if(!isDefined(level.VanSlot2)) {
        level.VanSlot2 = 25; 
        self updateMenu("VanillaCustomUpgrades2", "Extra Slot Round:"+level.VanSlot2, 2, true);
    } else {
		if(level.VanSlot2 == 35 || level.VanSlot2 == 24){
			switch(level.VanSlot2){
				case 24: self updateMenu("VanillaCustomUpgrades2", "Extra Slot Round:" + "^3Default^7(25)", 2, true);level.VanSlot2 = 25;break;
				case 35: self updateMenu("VanillaCustomUpgrades2", "Extra Slot Round:" + "^1Disabled", 2, true);level.VanSlot2 = 0;break;
			}
		} else {
		level.VanSlot2 ++;
        self updateMenu("VanillaCustomUpgrades2", "Extra Slot Round:" + level.VanSlot2, 2, true);
		}
    }
	for (a = 0; a < getPlayers().size; a++) {
        player = getPlayers()[a];
        if (player getPrimaryMenu() == "VanillaCustomUpgrades2")
            player refreshMenu();
    }
}

VapRound(){
	level waittill("between_round_over");
switch(level.round_number){
	case 10: level.quick_hacked = true;
	iprintln("Quick Revive Upgraded");
	level thread maps\_zombiemode_perks::Perk_Has_Already("specialty_quickrevive");
	level dvar_all("player_lastStandBleedoutTime", "50");
	break;
	
	case 15: level.fast_hacked = true;
	iprintlnbold("Speed Cola Upgraded");
	level thread maps\_zombiemode_perks::Perk_Has_Already("specialty_fastreload");
	level dvar_all("perk_weapReloadMultiplier", "0.37");
	break;
	
	case 17:
	iprintlnbold("Perk Slot 5");
	level.Max_Perks = 5;break;
	
	case 20: level.rof_hacked = true;level.jug_hacked = true;
	iprintlnbold("Double Tap Upgraded");
	iprintlnbold("Jugger-Nog Upgraded");
	level thread maps\_zombiemode_perks::Perk_Has_Already("specialty_armorvest");
	level dvar_all("perk_weapRateMultiplier", "0.55");
	level dvar_all("player_burstFireCooldown", "0.1");
	break;
	
	case 25: level.threegun_hacked = true;
	level.ClipSize = 1.52;
	level dvar_all("player_ClipSizeMultiplier", "1.52");
	iprintlnbold("Perk Slot 6");
	iprintlnbold("Clip Size Upgraded");
	iprintlnbold("Mule Kick Upgraded");
	iprintlnbold("^FEverything Upgraded!!!");
	level.Max_Perks = 6;
	break;
	}
	level thread VapRound();
}

Round_Waiter(Check,Round,Text,Function,Input1,Input2,Input3,Input4,MakeTrue,MakeUndefined,MakeFalse,Thiz,Equals){
	Round --;
	flag_init(Check);
while(Round >= level.round_number){
	level waittill("between_round_over");
	}
	flag_set(Check);
	if(IsDefined(Text))
		iprintlnbold(Text);
	if(IsDefined(Function))
		level thread [[Function]](Input1,Input2,Input3,Input4);
		MakeTrue = true;
		MakeUndefined = undefined;
		MakeFalse = false;
		Thiz = Equals;
		switch(Check){
			case "QuickCheck": level.quick_hacked = true;level.VanQuick = undefined;break;
			case "SpeedCheck": level.fast_hacked = true;level.VanFast = undefined;break;
			case "DoubleCheck": level.rof_hacked = true;level.VanRof = undefined;break;
			case "JugCheck": level.jug_hacked = true;level.VanJug = undefined;break;
			case "MuleCheck": level.threegun_hacked = true;level.VanClip = undefined;level.ClipSize = 1.52;break;
			case "SlotCheck":
			case "SlotCheck2": level.Max_Perks ++;break;
			
		}
}

Vanilla_Starter()
{
	players = getPlayers();
	level CustVap();
	level thread Vanilla_Perks();
	level thread Rpg_Powerupz();
	level thread superAmmoPowerup();
	level thread Upgrade_System();
	if( IsDefined( level.Uses_Pap ) )
	{
		level thread Buy_System( "zombie_ammocan", level.PapCost, level.Pap_Origin, "Pap", ::PackaCust, "Pack Weapon:" );
		iprintlnbold("Level does use custom PAP");
	}
	if( IsDefined( level.Uses_Fizz ) )
		level thread WunderFizz();
	level thread Bonus_Rounds();
	level.melee_bonus = 65;
	level.dmg_automaticWeapon = undefined;
	level.dmg_Weapon = undefined;
	level.bonus_head = 65;
	level.bonus_neck = 65;
	level.bonus_torso = 50;
	level.BossRoundz = 7;
	level.SharePoints = maps\_zombiemode_score::get_zombie_death_player_points() / 4 /getPlayers().size;
	level.zombie_func = ::TextThis;
	
	switch( level.script )
	{
		case "zombie_coast":
			level.Uses_Tp_FX = true;
			level thread Coast_Teleporter();
		break;
		case "zombie_moon":
			level thread Moon_Teleporter();
			level.teleporter_to_nml_powerdown_time = 999999;
			level.max_astro_zombies = players.size;
			level.max_astro_round_wait = 1;
		//level.eye_color = LoadFX( "misc/fx_zombie_eye_single_blue" );
		break;
		case "zombie_cod5_prototype":
			//TeleporterZ( Model , Origin , Cost , AngleT , TargetName  , Where , Angles , Needs_power , Glow , Location , Time , Max, Back, Anglez, Stay );
			thread TeleporterZ( "zombie_carpenter" , (1011, 806, 150) , 750 , ( 0,0,0 ) , "Packerz"  , ( 1120, 831, 1770 ) , ( 0, 50, 0 ) , false , true , undefined , 30 , 125, ( 11, -13, 186 ), (0,0,0), undefined, true );
		break;
		case "zombie_cod5_sumpf":
			thread TeleporterZ( "zombie_carpenter" , (12006, -1480, -700) , 750 , ( 0,0,0 ) , "Packerz"  , ( 11371, -1962, 1000 ) , ( 0, 50, 0 ) , false , true , undefined , 30 , 125, ( 10979, -63, -707 ), (0,0,0), undefined );
		break;
		
	}
	
	for(i = 0; i<players.size; i++){
		
		Weapon = "m1911_zm";
		if(!isDefined(self.Weapon_Upgrade[Weapon])){
			Upgrade = level.zombie_weapons[Weapon].upgrade_name;
			players[i].Weapon_Upgrade[Weapon] = Weapon;
			players[i].Weapon_Upgrade[Upgrade] = Upgrade;
			players[i].Weapon_Upgrade_Enhance[Weapon] = 0;
			players[i].Weapon_Upgrade_Enhance[Upgrade] = 0;
		}
		Weapon = "thundergun_zm";
				if(!isDefined(self.Weapon_Upgrade[Weapon])){
			Upgrade = level.zombie_weapons[Weapon].upgrade_name;
			players[i].Weapon_Upgrade[Weapon] = Weapon;
			players[i].Weapon_Upgrade[Upgrade] = Upgrade;
			players[i].Weapon_Upgrade_Enhance[Weapon] = 5;
			players[i].Weapon_Upgrade_Enhance[Upgrade] = 5;
		}
		players[i] thread HUdWeaponUpgrade();
		players[i] thread HudUpgradables();
		players[i] thread Give_Trash();
	}
}

CustVap(){
	wait 2;
	iprintlnbold("Beta Test Vanilla+ By Vappy^F^1!");
	iprintlnbold("Learn More At Discord.gg/hf2nBtzVpf(Screenshot if needed)");
	level.VanillaPlus = true;
	level dvar_all("Cg_ScoreBoardFont", "6");
	level dvar_all("Cg_Development", "1");
}

Vanilla_Perks(){
	if( level.script == "zombie_moon" ){
		if(IsDefined(level.Uses_IceBull) && level.VanBull != 0){
		//level thread Round_Waiter("IceBullCheck", level.VanBull, "^5Ice Bull Blast^7 Unlocked", undefined, undefined, undefined, undefined, undefined, undefined, level.VanBull);
		level thread Moon_Fake_Perka("IceBullFake", "IBB", 1500, "^5Ice Bull Blast", level.Ice_Origin, level.Ice_Angles, "zombie_vending_revive_on", "specialty_quickrevive", "collision_geo_64x64x256", undefined, "revive_light", "IceBullCheck", "Must be Round "+level.VanBull, undefined, undefined);
		level thread Moon_Fake_Perka("StarLightFake", "StarLight", 2115, "^6StarLight Cola", level.starlightpos, level.Star_Angles, "zombie_vending_nuke_on", "specialty_flakjacket", "collision_geo_64x64x256", undefined, "divetonuke_light", "StarLightCheck", "Must be Round "+level.VanStar, undefined, undefined);
		level thread Round_Waiter("IceBullCheck", level.VanBull, undefined, undefined, undefined, undefined, undefined, undefined, undefined, level.VanBull);
		level thread Round_Waiter("StarLightCheck", level.VanStar, undefined, undefined, undefined, undefined, undefined, undefined, undefined, level.VanBull);
	}
		return;
	}
	if(IsDefined(level.Uses_Deadshot) && level.VanShot != 0){
		level thread Round_Waiter("DeadShotCheck", level.VanShot, "^9DeadShot^7 Unlocked", undefined, undefined, undefined, undefined, undefined, undefined, level.VanShot);
		level thread Fake_Perka("DeadShotFake", "deadshot", 750, "^9Dead Shot", level.Dead_Origin, level.Dead_Angles, "defaultactor", "specialty_additionalprimaryweapon", "collision_geo_64x64x256", "zom_icon_player_life", "jugg_light", "DeadShotCheck", "Must be Round "+level.VanShot, (.5, .5, .5));
	}
	
	//if(IsDefined(level.Uses_FizzyHud) && level.VanHud != 0){
	//	level thread Round_Waiter("FizzyHudCheck", level.VanHud, "^5FizzyHud^ Unlocked", undefined, undefined, undefined, undefined, undefined, undefined, level.VanHud);
	//	level thread Fake_Perka("FizzyHudFake", "FizzyHud", 500, "^5Fizzy Hud", level.Fizzy_Origin, level.Fizzy_Angles, "defaultactor", "specialty_quickrevive", "collision_geo_64x64x256", "zom_icon_community_pot_strip", "revive_light", "FizzyHudCheck", "Must be Round "+level.VanHud, (.2, .3, .8), true);
	//}
	
	if(IsDefined(level.Uses_IceBull) && level.VanBull != 0){
		level thread Round_Waiter("IceBullCheck", level.VanBull, "^5Ice Bull Blast^7 Unlocked", undefined, undefined, undefined, undefined, undefined, undefined, level.VanBull);
		level thread Fake_Perka("IceBullFake", "IBB", 1500, "^5Ice Bull Blast", level.Ice_Origin, level.Ice_Angles, "zombie_vending_revive_on", "specialty_quickrevive", "collision_geo_64x64x256", undefined, "revive_light", "IceBullCheck", "Must be Round "+level.VanBull, undefined);
	}
	
	if(IsDefined(level.Uses_Flak) && level.VanFlak != 0){
		level thread Round_Waiter("FlakCheck", level.VanFlak, "^6Flak Jacket^7 Unlocked", undefined, undefined, undefined, undefined, undefined, undefined, level.VanFlak);
		level thread Fake_Perka("PhdFake", "flakjacket", 1250, "^6Flak Jacket", level.Flak_Origin, level.Flag_Angles, "defaultactor", "specialty_additionalprimaryweapon", "collision_geo_64x64x256", "hud_burningcaricon", "revive_light", "FlakCheck", "Must be Round "+level.VanFlak, (.53, .30, 1.00));
	}
	if(IsDefined(level.Uses_StaminUp) && level.VanStam != 0){
		level thread Round_Waiter("StamCheck", level.VanStam, "^3Stamin-Up^7 Unlocked", undefined, undefined, undefined, undefined, undefined, undefined, level.VanStam);
		level thread Fake_Perka("StaminUpFake", "longersprint", 2000, "^3Stamin-Up", level.Stam_Origin, level.Stam_Angles, "zombie_vending_doubletap", "specialty_rof", "collision_geo_64x64x256", "hud_grenadepointer", "doubletap_light", "StamCheck", "Must be Round "+level.VanStam, (1.00, 0.95, 0.70));
	}
	if(level.VanQuick != 0){
		level thread Round_Waiter("QuickCheck", level.VanQuick, "Quick Revive Upgraded", maps\_zombiemode_perks::Perk_Has_Already, "specialty_quickrevive", undefined, undefined, undefined, level.quick_hacked, level.VanQuick);
		level thread Round_Waiter("QuickCheck", level.VanQuick, undefined, ::dvar_all, "player_lastStandBleedoutTime", 50);
	}
	
	if(level.VanFast != 0){
		level thread Round_Waiter("SpeedCheck", level.VanFast, "Speed Cola Upgraded", maps\_zombiemode_perks::Perk_Has_Already, "specialty_fastreload", undefined, undefined, undefined, level.fast_hacked, level.VanFast);
		level thread Round_Waiter("SpeedCheck", level.VanFast, undefined, ::dvar_all, "perk_weapReloadMultiplier", 0.37);
	}
	
	if(level.VanRof != 0){
		level thread Round_Waiter("DoubleCheck", level.VanRof, "Double Tap Upgraded", ::dvar_all, "perk_weapRateMultiplier", 0.55, undefined, undefined, level.rof_hacked, level.VanRof);
		level thread Round_Waiter("DoubleCheck", level.VanRof, undefined, ::dvar_all, "player_burstFireCooldown", 0.1);
	}	
	
	if(level.VanClip != 0){
		level thread Round_Waiter("MuleCheck", level.VanClip, "Mule Kick Upgraded", ::dvar_all, "player_ClipSizeMultiplier", 1.52, undefined, undefined, level.threegun_hacked, level.VanClip);
	}	
	
	if(level.VanJug != 0){
		level thread Round_Waiter("JugCheck", level.VanJug, "Jugger-Nog Upgraded", maps\_zombiemode_perks::Perk_Has_Already, "specialty_armorvest", undefined, undefined, undefined, level.jug_hacked, level.VanJug);
	}
	
	if(level.VanSlot1 != 0)
		level thread Round_Waiter("SlotCheck", level.VanSlot1, "Extra Perk Slot Granted", undefined, undefined, undefined, undefined, undefined, level.VanSlot1);
	if(level.VanSlot2 != 0)
		level thread Round_Waiter("SlotCheck2", level.VanSlot2, "Extra Perk Slot Granted", undefined, undefined, undefined, undefined, undefined, level.VanSlot2);
}

shader_check( Perk )
{
	Shader = undefined;
	Color = undefined;
	if( level.script == "zombie_theater"
	||	level.script == "zombie_cod5_prototype"
	||	level.script == "zombie_cod5_sumpf"
	||	level.script == "zombie_cod5_factory"
	||	level.script == "zombie_cod5_asylum"
	||	level.script == "zombie_pentagon"
	)
	{
		switch(perk)
		{
				case "specialty_deadshot": Shader = "zom_icon_player_life"; Color = ( .5,.5,.5 ); break;
				case "specialty_longersprint": Shader = "hud_grenadepointer"; Color = ( 1.00, 0.95, 0.70 ); break;
				case "specialty_flakjacket": Shader = "hud_burningcaricon"; Color = ( .53, .30, 1.00 ); break;
		}
	}
	if( IsDefined( Shader ) && IsDefined( Color ) )
	{
		self.CustShader[Perk] = Shader;
		self.CustColor[Perk] = Color;
	}
}

Fake_Perka(TargetName, Perk, Cost, String, Location, Angles, Model, Bottle, Clip, Shader, FX, Checks, Requirement, Color, Bypass){
Ent =  spawnSM((Location), Model);
Ent.angles = Angles;
Ent.targetname = TargetName;
//iprintln( "Spawned" + " " + TargetName );
Trig = spawnTrig((Location), 40, 15, "HINT_NOICON", "You must turn on the power first!");
Trig.targetname = TargetName + "_trig";
machine_clip =  spawnSM((Location), "tag_origin");
machine_clip setmodel( Clip );
machine_clip Hide();
machine_clip.angles = Angles;
flag_wait("power_on");
iprintln("power is on");
if(isDefined(Checks)){
Trig SetHintString(Requirement);
flag_wait(Checks);
}
if(model != "defaultactor")
Ent setmodel(Model+"_on");
Ent playsound("zmb_perks_power_on");
Ent vibrate((0,-100,0), 0.3, 0.4, 3);
Ent thread perk_fx( FX );
wait 2;
Trig SetHintString("Press & Hold &&1 To Buy "+String+ " Cost ["+Cost+"]");
    for(;;)
    {
        Trig waittill("trigger", i);
		if( !is_true( i bChk( 0.45, "use" ) ) )
			{
				wait 0.05;
				continue;
			}

		if(!isDefined(i.Bought_Perk["specialty_"+Perk]) && level.zombie_vars["zombie_powerup_rpg_on"] == false){
			if(i.score < cost || i.num_perks >= level.Max_Perks && !isDefined(Bypass) )
			i iprintln("Perkslot or points needed");
			else 
			{
				if(!isDefined(i.CustShader.size))
				i.CustShader = [];
				if(!isDefined(i.CustColor.size))
				i.CustColor = [];
				i.CustShader["specialty_"+Perk] = Shader;
				i.CustColor["specialty_"+Perk] = Color;
				
				i maps\_zombiemode_score::minus_to_player_score( cost );
				gun = i maps\_zombiemode_perks::perk_give_bottle_begin( Bottle );
				i waittill_any( "fake_death", "death", "player_downed", "weapon_change_complete" );
				if ( i maps\_laststand::player_is_in_laststand() || is_true( self.intermission ) )
				{
					i maps\_zombiemode_perks::perk_give_bottle_end( gun,"specialty_"+Perk );
					continue;
				}
				else 
				{
					i maps\_zombiemode_perks::perk_give_bottle_end( gun,"specialty_"+Perk);
					i maps\_zombiemode_perks::give_perk( "specialty_"+Perk, true, undefined );
					level notify("Cust_Perk_Bought");
				}
			}
		}
	}
}

Moon_Fake_Perka(TargetName, Perk, Cost, String, Location, Angles, Model, Bottle, Clip, Shader, FX, Checks, Requirement, Color, Bypass)
{
	Trig = TargetName + "_trig";
	Ent =  spawnSM((Location), Model);
	Ent.angles = Angles;
	Ent.targetname = TargetName;
	Trig = spawnTrig((Location), 40, 15, "HINT_NOICON", "You must turn on the power first!");
	Trig.targetname = TargetName + "_trig";
	machine_clip =  spawnSM((Location), "tag_origin");
	machine_clip setmodel( Clip );
	machine_clip Hide();
	machine_clip.angles = Angles;
	flag_wait("power_on");
	iprintln("power is on");
	if( isDefined( Checks) )
	{
		Trig SetHintString(Requirement);
		flag_wait(Checks);
	}
	if(model != "defaultactor")
		Ent setmodel(Model+"_on");
	Ent playsound("zmb_perks_power_on");
	Ent vibrate((0,-100,0), 0.3, 0.4, 3);
	Ent thread perk_fx( FX );
	wait 2;
	Trig SetHintString("Press & Hold &&1 To Buy "+String+ " Cost ["+Cost+"]");
	for(;;)
	{
		Trig waittill("trigger", i);
		if( !is_true( i bChk( 0.45, "use" ) ) )
			{
				wait 0.05;
				continue;
			}

		if(!isDefined(i.Bought_Perk["specialty_"+Perk]) && level.zombie_vars["zombie_powerup_rpg_on"] == false)
		{
			if(!IsDefined(i.Max_Perkz))
				i.Max_Perkz = 1;
			if(i.score < cost || i.num_perks >= i.Max_Perkz && !isDefined(Bypass) )
				i iprintln("Perkslot or points needed");
			else
			{
				if(!isDefined(i.CustShader.size))
				i.CustShader = [];
				if(!isDefined(i.CustColor.size))
				i.CustColor = [];
				i.CustShader["specialty_"+Perk] = Shader;
				i.CustColor["specialty_"+Perk] = Color;
				i maps\_zombiemode_score::minus_to_player_score( cost );
				gun = i maps\_zombiemode_perks::perk_give_bottle_begin( Bottle );
				i waittill_any( "fake_death", "death", "player_downed", "weapon_change_complete" );
				if ( i maps\_laststand::player_is_in_laststand() || is_true( self.intermission ) )
				{
						i maps\_zombiemode_perks::perk_give_bottle_end( gun,"specialty_"+Perk );
						continue;
				}
				else 
				{
					i maps\_zombiemode_perks::perk_give_bottle_end( gun,"specialty_"+Perk);
					i maps\_zombiemode_perks::give_perk( "specialty_"+Perk, true, undefined );
					level notify("Cust_Perk_Bought");
				}
			}
		}
	}
}

Rpg_Powerupz()
{
    for(;;)
    {
		level waittill("between_round_over");
        zombie = [];
        wait(randomIntRange(400, 750));
        for(;;)
        {
            wait .1;
            enemy = getAiSpeciesArray("axis", "all");
            zombie = enemy[randomInt(enemy.size)];
            //if(!zombie inMap()) // original code, in case this method does a sad
			if(zombie zMap() && !zombie is_boss() )
                break;
        }
        zombie waittill("death");
        point = zombie.origin+(0, 0, 40);
        temp = spawnSM(point, "tag_origin");
        power[0] = spawnSM(point, "zombie_zapper_tesla_coil");
        power[1] = spawnSM(point, power[0].model, (90, 0, 0));
        power[2] = spawnSM(point, power[0].model, (180, 0, 0));
        power[3] = spawnSM(point, power[0].model, (-90, 0, 0));
        for(m = 0; m < power.size; m++)
        {
            power[m] linkTo(temp);
            power[m] thread deleteOnGrab(temp);
            power[m] thread maps\_zombiemode_powerups::powerup_timeout();
        }
        playSoundatPosition("spawn_powerup", temp.origin);
        temp playLoopSound("spawn_powerup_loop");
        temp thread maps\_zombiemode_powerups::powerup_wobble();
        temp thread maps\_zombiemode_powerups::powerup_timeout();
        temp thread GrabRpg();
    }
}

GrabRpg()
{
    self endon("powerup_timedout");
    self endon("powerup_grabbed");
    while(isDefined(self))
    {
        p = getPlayers();
        for(m = 0; m < p.size; m++)
        {
            if(distance(p[m].origin, self.origin) < 64)
            {
                playFx(loadFx("misc/fx_zombie_powerup_grab"), self.origin);
                playFx(loadFx("misc/fx_zombie_powerup_wave"), self.origin);
                level thread plsrpg();
                wait .1;
                playSoundAtPosition("powerup_grabbed", self.origin);
                self stopLoopSound();
                self delete();
                self notify("powerup_grabbed");
            }
        }
        wait .05;
    }
}

Bottomless_Clip(){
self endon("Bottomless_Over");
for(;;){
	primary_weapons = self GetWeaponsList();
	self setWeaponAmmoClip( primary_weapons[0],999 );
	self setWeaponAmmoClip( primary_weapons[1],999 );
	self setWeaponAmmoClip( primary_weapons[2],999 );
	self setWeaponAmmoClip( primary_weapons[3],999 );
	self setWeaponAmmoClip( primary_weapons[4],999 );
	self setWeaponAmmoClip( primary_weapons[5],999 );
	self setWeaponAmmoClip( primary_weapons[6],999 );
	self setWeaponAmmoClip( primary_weapons[7],999 );
	self setWeaponAmmoClip( primary_weapons[8],999 );
	self setWeaponAmmoClip( primary_weapons[9],999 );
	self.Weapon_Ammo ++;
	wait(0.1);
	}
}


//Not renaming test_wait, this is actually a reference to the source engine testscript scripting
Test_Wait(Person,Wait,Function,Input1,Input2,Input3,Input4,Function2,SInput1,SInput2,SInput3,SInput4,Entity){
	wait Wait;
	if(IsDefined(Entity)){
		Entity thread [[Function]](Input1,Input2,Input3,Input4);
		Entity thread [[Function2]](SInput1,SInput2,SInput3,SInput4);
	}
else if(Person == 1 &&IsDefined(Person)){
		self thread [[Function]](Input1,Input2,Input3,Input4);
		self thread [[Function2]](SInput1,SInput2,SInput3,SInput4);
	} else {
			level thread [[Function]](Input1,Input2,Input3,Input4);
			level thread [[Function2]](SInput1,SInput2,SInput3,SInput4);
	}
}

FizzyHUD_setup(){
	switch(level.script){
		case "zombie_coast": level.Boss_Health = level.director_max_damage_taken; break;
	}
if(IsDefined(level.Boss_Health))
	//self.Boss_HUD = self createText(2, undefined, "CENTER", "CENTER", -20, 170, 2, 2, undefined);
	//self.IBB_HUD = self createText(2, undefined, "CENTER", "CENTER", -20, 190, 2, 2, undefined);
	self.Health_Hud = self createText(2, undefined, "CENTER", "CENTER", -20, 210, 2, 2, undefined);
	self thread FizzyHUD_Check();
	self thread FizzyHUD_Health();
	//Amm setText("^2+^5 " + self.Weapon_Ammo + " pizza");
}

FizzyHUD_Check()
{
	self endon("specialty_FizzyHud_stop");
	self endon("death");
	self endon("disconnect");
	player = GetPlayers();
	self.Boss_HUD setText("^1BOSS^7:^1 "+level.BossHUD+"^7 / ^5"+level.director_max_damage_taken);
	self.IBB_HUD setText("Slams: ^5"+self.slam_power);
	for(;;)
	{
		level waittill_any("Ice_Slam","Boss_Hurt", "between_round_over","Cust_Perk_Bought");
		wait .05;
		if(level.BossHUD <= level.Boss_Health * player.size - level.frackit && IsDefined(level.BossHUD) && IsDefined( self.BossHUD ) )
		self.Boss_HUD setText("^1BOSS^7:^1 "+level.BossHUD+"^7 / ^5"+level.director_max_damage_taken);
		else
		self.Boss_HUD setText("");
		//if( IsDefined( self.IBB_HUD ) )
		//self.IBB_HUD setText("Slams: ^5"+self.slam_power);
	}
}

FizzyHUD_Health(){
self endon("specialty_FizzyHud_stop");
self endon("death");
self endon("disconnect");
for(;;){
	if(self.health<=self.maxhealth/1.5 && self.health > self.maxhealth/2)
		num = "^3";
	else if (self.health<=self.maxhealth/2)
		num = "^1";
	else
		num = "^2";
	if( IsDefined( self.Health_Hud ) )
	self.Health_Hud setText("^1HEALTH^7:"+num+self.health);wait .05;
	}
}

HUdWeaponUpgrade() {
    self endon("death");
    self endon("disconnect");
    bar = self createRectangle("BOTTOM", "BOTTOM", 0, 0, 200, 20, (0, 0, 0), "menu_button_backing_highlight", 2, .7, self);
    text = self createText(getFont(), 1, "CENTER", "BOTTOM", 0, -10, 3, (1 / 1), "", self);
    for (;;) {
		Weapon = self getCurrentWeapon();
		Upgrade = level.zombie_weapons[Weapon].upgrade_name;
		self.Weapon_Upgrade_Enhance["mk_aug_upgraded_zm"] = self.Weapon_Upgrade_Enhance["aug_acog_mk_upgraded_zm"];
		self.Weapon_Upgrade_Enhance["gl_m16_upgraded_zm"] = self.Weapon_Upgrade_Enhance["m16_gl_upgraded_zm"];
		if(!isDefined(self.Weapon_Upgrade[Weapon])){
			if( IsPrimaryWeapon(Weapon) )
			{
				self.Weapon_Upgrade[Weapon] = Weapon;
				self.Weapon_Upgrade[Upgrade] = Upgrade;
				self.Weapon_Upgrade_Enhance[Weapon] = 0;
				self.Weapon_Upgrade_Enhance[Upgrade] = 0;
				self.Weapon_Upgrade_Enhance["mk_aug_upgraded_zm"] = self.Weapon_Upgrade_Enhance["aug_acog_mk_upgraded_zm"];
				self.Weapon_Upgrade_Enhance["gl_m16_upgraded_zm"] = self.Weapon_Upgrade_Enhance["m16_gl_upgraded_zm"];
				
				self.Weapon_Upgrade_Enhance["m16_gl_upgraded_zm"] = self.Weapon_Upgrade_Enhance["m16_sp"];
				self.Weapon_Upgrade_Enhance["m1911_upgraded_zm"] = self.Weapon_Upgrade_Enhance["m1911_sp"];
			}
		}
		switch(self.Weapon_Upgrade_Enhance[Weapon]){
			case 1:
			bar.color = (.1,.6,.1);
			text.color = (.1,.8,.1);
			text.font = "small";
			text setText("Basic");
			break;
			case 2:
			bar.color = (.1,.1,.6);
			text.color = (.1,.1,.8);
			text.font = "default";
			text setText("Advanced");
			break;
			case 3:
			bar.color = (.4,.2,.8);
			text.color = (.6,.3,.8);
			text.font = "smallfixed";
			text setText("Epic");
			break;
			case 4:
			bar.color = (.6,.5,0);
			text.color = (.8,.8,0);
			text.font = "bigfixed";
			text setText("Legendary");
			break;
			case 5:
			text.font = "bigfixed";
			text setText("?Specialty?");
			bar thread alwaysColourful();
			text thread alwaysColourful();
			break;
			default:
			bar.color = (0,0,0);
			text.color = (.2,.2,.2);
			text.font = "default";
			text setText("Unknown?");
		}
		self waittill_any("weapon_change_complete","Weapon_Change");
		bar notify("colours_over");
		text notify("colours_over");
	}
}

UpgradeAmmo(){
	weapon = self getCurrentWeapon();
	upgrade = level.zombie_weapons[weapon].upgrade_name;
	Downgrade = NonUpgrad(weapon);
	self maps\_zombiemode_spawner::weapons_list(weapon);
	switch(self.NewDam){		
		case "Def":
		case "Frosty":
		case "FrostyUpgraded":
		case "Ray":
		case "RayUpgraded":
		case "Sniplode":
		case "SniplodeUpgraded":
		case "tesla_gun_zm":
		case "tesla_gun_upgraded_zm":
		case "ReturnDamage":
		case "Death_Machine":
		case "Specialty":
		Max = 5;
		break;
		default:Max = 4;
			}
			if( Wall_weapon_list( weapon ) && self.NewDam != "Specialty" )
				Max = 3;
			self iprintln( "Max Upgrade Level:" + Max);
		if(self.Weapon_Upgrade_Enhance[weapon] < Max){
			self.Weapon_Upgrade_Enhance[weapon] ++;
			self.Weapon_Upgrade_Enhance[Upgrade] = self.Weapon_Upgrade_Enhance[weapon];
			self.Weapon_Upgrade_Enhance[Downgrade] = self.Weapon_Upgrade_Enhance[weapon];
			self notify("Weapon_Change");
	}
}

Wall_weapon_list( weapon )
{
	switch( weapon )
	{
		case "ithaca_zm":
		case "ithaca_upgraded_zm":
		case "rottweil72_zm":
		case "rottweil72_upgraded_zm":
		case "mpl_zm":
		case "mpl_upgraded_zm":
		case "mp40_zm":
		case "mp40_upgraded_zm":
		case "pm63_zm":
		case "pm63_upgraded_zm":
		case "m14_zm":
		case "m14_upgraded_zm":
		case "m16_zm":
		case "m16_upgraded_zm":
		case "m16_gl_upgraded_zm":
		case "mp5k_zm":
		case "mp5k_upgraded_zm":
		case "zombie_bar":
		case "zombie_thompson":
		case "zombie_thompson_upgraded":
		case "zombie_stg44":
		case "zombie_stg44_upgraded":
		case "zombie_shotgun":
		case "zombie_shotgun_upgraded":
		case "zombie_doublebarrel":
		case "zombie_doublebarrel_upgraded":
		case "zombie_doublebarrel_sawed":
		case "zombie_fg42":
		case "zombie_fg42_upgraded":
		case "zombie_gewehr43":
		case "zombie_gewehr43_upgraded":
		case "zombie_kar98k":
		case "zombie_kar98k_upgraded":
		case "kar98k_scoped_zombie":
		case "zombie_m1carbine":
		case "zombie_m1carbine_upgraded":
		case "zombie_bar_bipod":
		case "zombie_m1garand":
		case "zombie_type99_rifle":
		return true;
		default: return false;
	}
	
}

HudUpgradables(){
	self endon("death");
    self endon("disconnect");
	text = self createText(getFont(), 1, "Center", "BOTTOM", -300, -10, 3, (1 / 1), "", self);
	text2 = self createText(getFont(), 1, "Center", "BOTTOM", -275, -10, 3, (1 / 1), "", self);
	text2.color = ( .7, .2, .9 );
	if(!IsDefined( self.Trash ) )
		self.Trash = 25;
	for(;;)
	{
		text SetText("Trash:"); 
		text2 SetValue( self.Trash ); 
		self waittill("UpdateTrash");
		text2 fontPulse(4);
	}
}

fontPulse(BigNess)
{
	self endon("death");
    self endon("disconnect");
	self.baseFontScale = self.fontScale;
	self.maxFontScale = self.fontScale * BigNess;
	self.inFrames = 3;
	self.outFrames = 5;
	scaleRange = self.maxFontScale - self.baseFontScale;
	
	while ( self.fontScale < self.maxFontScale )
	{
		self.fontScale = min( self.maxFontScale, self.fontScale + (scaleRange / self.inFrames) );
		wait 0.05;
	}
		
	while ( self.fontScale > self.baseFontScale )
	{
		self.fontScale = max( self.baseFontScale, self.fontScale - (scaleRange / self.outFrames) );
		wait 0.05;
	}
}

Give_Trash(){
	self endon("death");
    self endon("disconnect");
		half_prize = level.round_number + 5;
		full_prize = level.round_number + 10;
	for(;;){
		level waittill("between_round_over");
		Prize = 25;
		if(level.round_number >= 12 )
			Prize = 50;
		if(level.round_number >= 22)
			Prize = 75;
		if(level.round_number == half_prize){
			self.Trash += Prize / 2;
			self notify("UpdateTrash");
		}
		if(level.round_number == full_prize){
		self.Trash += Prize;
		self notify("UpdateTrash");
		half_prize = level.round_number + 5;
		full_prize = level.round_number + 10;
		}
	}
}

NonUpgrad( weaponname )
{
					//iprintln("Weaponname "+weaponname);
        if( !isdefined( weaponname ) || weaponname == "" )
        {
                return undefined;
        }

        weaponname = ToLower( weaponname );

        ziw_keys = GetArrayKeys( level.zombie_weapons );
        for ( i=0; i<level.zombie_weapons.size; i++ )
        {
                if ( IsDefined(level.zombie_weapons[ ziw_keys[i] ].upgrade_name) && 
                         level.zombie_weapons[ ziw_keys[i] ].upgrade_name == weaponname )
                {
                        return ziw_keys[i];
                }
        }
        return weaponname;
}

Bonus_Rounds()
{
	max = 2;
	self endon("death");
    self endon("disconnect");
	level.dog_func = ::DogMode;
	for(;;)
	{
		level waittill("between_round_over");
		if(level.round_number >= 20){
		level.zombie_ai_limit = 34;
		SetAILimit( level.zombie_ai_limit );
		}
		level.bosz = undefined;
		//if(level.round_number >= level.BossRoundz)
		//	iprintln("true");
		level.zombie_func = undefined;
		level.quad_func = undefined;
		wait 3;
		if(flag("dog_round"))
		{
		level.maxDogsAttackingPerPlayer = 3;
		level.spawnTimeWaitMin = 0;
		level.spawnTimeWaitMax = 1;
		level waittill("between_round_over");
		}
		if(level.round_number >= level.BossRoundz)
		{
			text = undefined;
			switch( level.bozz )
			{
			case 1:
			text = "Double Dmg/Health Mode!";
			level.zombie_func = ::DoubleMode;
			level.quad_func = ::DoubleMode;
			level.bozz = 2;
			level.bosz = true;
			break;
			default:
			text = "Silly Mode!";
			level.zombie_func = ::SillyMode;
			level.quad_func = ::SillyMode;
			level.bozz = 1;
			level.bosz = true;
			}
			iprintlnbold( "BONUS ROUND: " + text );
			level.BossRoundz = level.round_number + randomIntRange(5,8);
		}
	}
}

DogMode(){}

DoubleMode()
{
	self.no_gib = true;
	wait .05;
	self.health *= 2.5;
	self.meleeDamage += 45;
	if(level.script == "zombie_moon")
	self SpeedMode(70);
	else
	self SpeedMode(85);
}

SpeedMode(Rand)
{
	if(level.script == "zombie_moon")
	self setModel("c_zom_moon_pressure_suit_body_zombie");
	Max = RandomIntRange(0,100);
	if(Rand > Max)
	switch( level.script )
	{
		case "zombie_coast":
		Max = RandomIntRange(0,5);
		if( Max == 1 )
			self.run_combatanim = level.scr_anim["human_zombie"]["walk2"];
		if( Max == 2 )
			self.run_combatanim = level.scr_anim["director_zombie"]["sprint1"];
		if( Max == 3 )
			self.run_combatanim = level.scr_anim["zombie"]["sprint5"];
		if( Max == 4 )
			self.run_combatanim = level.scr_anim["zombie"]["sprint6"];
		break;
		case "zombie_moon":
		Max = RandomIntRange(0,3);
		if( Max == 1 )
			self.run_combatanim = level.scr_anim["zombie"]["sprint5"];
		if( Max == 2 )
			self.run_combatanim = level.scr_anim["zombie"]["sprint6"];
		break;
		case "zombie_cosmodrome":
		Max = RandomIntRange(0,7);
		if( Max == 1 )
		self.run_combatanim = level.scr_anim["monkey_zombie"]["run1"];
		if( Max == 2 )
		self.run_combatanim = level.scr_anim["monkey_zombie"]["run2"];
		if( Max == 3 )
		self.run_combatanim = level.scr_anim["monkey_zombie"]["sprint1"];
		if( Max == 4 )
		self.run_combatanim = level.scr_anim["monkey_zombie"]["sprint2"];
		if( Max == 5 )
		self.run_combatanim = level.scr_anim["monkey_zombie"]["sprint3"];
		if( Max == 6 )
		self.run_combatanim = level.scr_anim["monkey_zombie"]["sprint4"];
		break;
	}
	
}

SillyMode(){
	self.health /= 1.3;
	self.meleeDamage = 45;
	self.Silly = true;
	self.moveplaybackrate = 1.45;
	self doDamage(1, self.origin, undefined, undefined, undefined);
}

Upgrade_System(Model){
	Model = "zombie_skull";
	Ent =  spawnSM((level.Upgrade_Origin), Model);
	Ent.targetname =  "Trash";
	Ent.angles = (0,0,0);
	Trig = spawnTrig((level.Upgrade_Origin), 50, 25, "HINT_NOICON", "You must turn on the power first!");
	Trig.targetname = "Trash_trig";
	Trig SetHintString("Upgrade System: ?Unknown Cost?");
	Ent setmodel(Model);
	playfxontag( level._effect["powerup_on_solo"], Ent, "tag_origin" );
    for(;;)
    {
		Trig waittill("trigger", i);
		weapon = i getCurrentWeapon();
		upgrade = level.zombie_weapons[weapon].upgrade_name;
		Downgrade = NonUpgrad(weapon);
		maps\_zombiemode_spawner::weapons_list(weapon);
		switch(i.Weapon_Upgrade_Enhance[weapon]){
			case 0:Cost = 25;break;
			case 1:Cost = 35;break;
			case 2:Cost = 55;break;
			case 3:Cost = 75;break;
			case 4:Cost = 80;break;
			default: Cost = 999999; break;
			
		}
		Trig SetHintString("Upgrade System: ^3Trash^7 " +Cost);
		if( !is_true( i bChk( 0.45, "use", undefined, true, "Upgrading Weapon...", (1, 1, 1), ( 106/255, 162/255, 1 ) ) ) )
			{
				wait 0.05;
				continue;
			}
			
		if( i.Trash < Cost  )
		i iprintln("^3I want your trash^7, ^1stupid^7!");
		else
		{
			init = i.Weapon_Upgrade_Enhance[weapon];
			i UpgradeAmmo();
			wait_network_frame();
			if(init != i.Weapon_Upgrade_Enhance[weapon])
			{
				i.Trash -= Cost;
				i notify("UpdateTrash");
			}
		}
	}
}

Buy_System( Model, Cost, Pos, TargetName, Function, Text, Input1, Input2 )
{
	Ent =  spawnSM((Pos), Model);
	Ent.angles = (0,0,0);
	Ent.targetname = TargetName;
	Trig = spawnTrig((Pos), 50, 25, "HINT_NOICON", "You must turn on the power first!");
	Trig SetHintString("Upgrade System: ?Unknown Cost?");
	Trig.targetname = TargetName + "_trig";
	Ent setmodel(Model);
	flag = undefined;
	playfxontag( level._effect["powerup_on_solo"], Ent, "tag_origin" );
    for(;;)
    {
		Trig waittill("trigger", i);
		Trig SetHintString(Text + " " + Cost);
		if( !is_true( i bChk( 0.55, "use", undefined, true, "Purchasing...", (1, 1, 1), ( 106/255, 162/255, 1 ) ) ) )
			{
				wait 0.05;
				continue;
			}

		if( i.score < Cost  )
		i iprintln("^3I want your points^7, ^1stupid^7!");
		else
		{
			flag = i [[ Function ]]( Input1, Input2 );
			wait_network_frame();
			if (!IsDefined( flag ) )
			{
				i maps\_zombiemode_score::minus_to_player_score( Cost );
			}
		}
	}
}

PackaCust()
{
	weapon = self getCurrentWeapon();
	if( !IsDefined( level.zombie_weapons[weapon].upgrade_name ) )
	{
		self iprintln( "Weapon cannot be upgraded" );
		return true;
	}
	
	upgrade_weapon = level.zombie_weapons[weapon].upgrade_name;
	
	self TakeWeapon( weapon );
	
	self iprintln( "Upgraded to " + upgrade_weapon );
		
	self notify( "And_" + Weapon );
	self notify( "End_" + Weapon );
	
	//if(IsDefined(self.WeaponBack))
	//{
	//	if (isDefined( self.pack_a_punch_weapon_options[weapon] ) )
	//	return self.pack_a_punch_weapon_options[weapon];
	//	else
	//	return;
	//}

	if(IsDefined(level.VanillaPlus && weapon != "defaultweapon"))
		self thread maps\vapp::Test_Wait(1,.4,maps\VapAmmo::WeaponRefill,weapon);
	if ( !isDefined( self.pack_a_punch_weapon_options ) )
	{
		self.pack_a_punch_weapon_options = [];
	}
	
	camo_index = RandomIntRange(2,4);
	switch(upgrade_weapon){
		case "m1911_upgraded_zm":
		case "knife_ballistic_upgraded_zm":
		case "ray_gun_upgraded_zm":
		case "china_lake_upgraded_zm":
		case "m72_law_upgraded_zm":
		case "g11_lps_upgraded_zm":
		case "hs10_upgraded_zm":
		case "rottweil72_upgraded_zm":
		case "cz75dw_upgraded_zm":
		case "pm63_upgraded_zm":
		case "mpl_upgraded_zm":
		case "cz75_upgraded_zm":
		case "python_upgraded_zm":
		case "freezegun_upgraded_zm":
		case "tesla_gun_upgraded_zm":
		case "thundergun_upgraded_zm":
		case "sniper_explosive_zm":
		case "humangun_zm":
		camo_index = 15;
		break;
		//Sickle has 1 camo really. either that, or i can't tell.
		case "knife_ballistic_sickle_zm":
		case "microwavegun_upgraded_zm":
		case "microwavegundw_upgraded_zm":
		//I like wave gun without camo better.
		camo_index = undefined;
		break;
		
		case "minigun_upgraded_zm":
		case "minigun_zm":
		upgrade_weapon = "minigun_zm";
			self GiveWeapon("minigun_zm");
			self SwitchToWeapon("minigun_zm");
		if(!isDefined(self.Death_Upgraded))
		{
			wait .05;
			self thread maps\VapAmmo::WeaponRefill("minigun_zm");
			self.Death_Upgraded = true;
		}
		break;
		case "mp40_upgraded_zm":
		camo_index = 15;
		if(level.script == "zombie_moon")
		{
			self notify( upgrade_weapon + "Specialty_Over" );
			self thread maps\vapp::Weapon_Specialty( upgrade_weapon, "china_lake_upgraded_zm", 30, 5, true, "China Lake" );
		}
			break;
		
		case "defaultweapon_upgraded_zm":
		upgrade_weapon = "defaultweapon";
			self GiveWeapon("defaultweapon");
			self SwitchToWeapon("defaultweapon");
		if(!isDefined(self.jiggly_upgraded))
		{
			self thread maps\vapp::DefaultInit_Upgraded();wait .05;
			self thread maps\VapAmmo::WeaponRefill("defaultweapon");
		}
			break;
	}
	lens_index = randomIntRange( 0, 6 );
	reticle_index = randomIntRange( 0, 21 );
	reticle_color_index = randomIntRange( 0, 6 );


	self GiveWeapon( upgrade_weapon, 0, self CalcWeaponOptions( camo_index, lens_index, reticle_index, reticle_color_index ) );
	self GiveStartAmmo( upgrade_weapon );
	self SwitchToWeapon( upgrade_weapon );
	//self.pack_a_punch_weapon_options[weapon] = self CalcWeaponOptions( camo_index, lens_index, reticle_index, reticle_color_index );
	
	
	
}

WunderFizz()
{
	
	Model = "zombie_carpenter";
	Cost = 1500;
	TargetName = "Fizz";
	Pos = level.Fizz_Origin;
	is_used = undefined;
	
	Ent =  spawnSM((Pos), Model);
	Ent.angles = (0,0,0);
	Ent.targetname = TargetName;
	Trig = spawnTrig((Pos), 50, 25, "HINT_NOICON", "You must turn on the power first!");
	Trig SetHintString("Upgrade System: ?Unknown Cost?");
	Trig.is_used = undefined;
	Trig.Perk = undefined;
	Trig.Option2 = undefined;
	Trig.targetname = TargetName + "_trig";
	Ent setmodel(Model);
	playfxontag( level._effect["powerup_on_solo"], Ent, "tag_origin" );
    for(;;)
    {
		Trig waittill("trigger", i);
		if( !IsDefined( Trig.is_used ) && !IsDefined( Trig.Option2 ) )
		Trig SetHintString("Wunderfizz: " + Cost);
		wait(0.05);
		if( IsDefined( Trig.is_used ) && i.playername != Trig.is_used )
			continue;

        if( !is_true( i bChk( 0.55, "use", undefined, true, "Wunderfizz", (123/255, 106/255, 1), ( 106/255, 162/255, 1 ) ) ) )
			{
				wait 0.05;
				continue;
			}

		if( i.score < Cost && !IsDefined( Trig.is_used )  )
		i iprintln("^3I want your points^7, ^1stupid^7!");
		else
		{
			if( !IsDefined( Trig.is_used ) )
			{
				i Fizz_Logic( Trig, Cost );
				continue;
			}
			if( IsDefined( Trig.Option2 ) )
			{
				i shader_check( Trig.Perk );
				i maps\_zombiemode_perks::give_perk( Trig.Perk, true, undefined );
				Trig notify( "Grabbed" );
			}
			wait_network_frame();
		}
	}
}

Fizz_Logic(Ent, Cost)
{
	if ( self.num_perks >= level.Max_Perks )
	{
		self iprintln( "Too many perks" );
		return;
	}
	Perks = 0;
	PerkName = [];
	Ent.is_used = self.playername;
	
	/*if( !self HasPerk( "specialty_StarLight")
	{
		Perks++;
		PerkName[ Perks ] = "specialty_StarLight";
	}
	if( !self HasPerk( "specialty_FizzyHud")
	{
		Perks++;
		PerkName[ Perks ] = "specialty_FizzyHud";
	}
	if( !self HasPerk( "specialty_IBB")
	{
		Perks++;
		PerkName[ Perks ] = "specialty_IBB";
	}
	*/
	
	
	if(!self HasPerk( "specialty_fastreload_upgrade")
	|| !self HasPerk( "specialty_fastreload") )
	{
		Perks++;
		PerkName[ Perks ] = "specialty_fastreload";
	}

	if( !self HasPerk( "specialty_quickrevive_upgrade")
	|| !self HasPerk( "specialty_quickrevive") )
	{
		Perks++;
		PerkName[ Perks ] = "specialty_quickrevive";
	}
	if( !self HasPerk( "specialty_additionalprimaryweapon") )
	{
		Perks++;
		PerkName[ Perks ] = "specialty_additionalprimaryweapon";
	}
	if( !self HasPerk( "specialty_longersprint") )
	{
		Perks++;
		PerkName[ Perks ] = "specialty_longersprint";
	}
	if( !self HasPerk( "specialty_flakjacket") )
	{
		Perks++;
		PerkName[ Perks ] = "specialty_flakjacket";
	}

	if( !self HasPerk( "specialty_armorvest_upgrade")
	|| !self HasPerk( "specialty_armorvest") )
	{
		Perks++;
		PerkName[ Perks ] = "specialty_armorvest";
	}
	if( !self HasPerk( "specialty_deadshot") )
	{
		Perks++;
		PerkName[ Perks ] = "specialty_deadshot";
	}
	
	if ( Perks == 0 )
	{
		self iprintln( "Max Perks Already" );
		return;
	}
	
	self maps\_zombiemode_score::minus_to_player_score( Cost );
	
	random = 0;
	
	for(i = 0; i < 60; i++)
	{
		random = randomIntRange( 1, Perks + 1 );
		Ent SetHintString("^1PERK: " + PerkName[ random ]);
		wait .05;
	}
	wait .1;
	Ent SetHintString("^2PERK: " + PerkName[ random ]);
	iprintln("^2PERK: " + PerkName[ random ]);
	iprintln(random);
	Ent.Perk = PerkName[ random ];
	Ent.Option2 = true;
	Ent thread Wunder_Timer();
	//Ent thread WaitNot(8, "Grabbed");
	Ent thread WaitNot(8, "Grabbed");
	
	
	//Ent SetHintString("Wunderfizz: " + Cost);
}

Wunder_Timer()
{
	self waittill_any( "Grabbed", "Timeout" );
	self.is_used = undefined;
	self.Option2 = undefined;
}

WaitNot( Time, Not1 )
{
	self endon( "Grabbed" );
	wait( Time );
	self notify( "Timeout" );
}

Friendly_Convert(time, attacker, anim1, anim2)
{
	Enemy = getAiSpeciesArray("axis", "all");
	 for (i = 0; i < Enemy.size; i++) {
		 
		 Enemy[i] thread Friendly_Convert2();
	 }

	 
}

DeathTime(time, attacker)
{
	attacker iprintln("Seconds: " + time);
	self endon("death");
	wait time;
	self DoDamage( self.health + 666, self.origin, attacker, attacker, "none", "MOD_IMPACT" );
}

Friendly_Convert2(time, attacker, anim1, anim2){
	self.animz = anim;
	if( self.targetname == "astronaut_zombie_ai" || self.targetname =="boss_zombie_spawner")
		return;
	self OrientMode( "face default" );
	self.ignoreall = true;
	self.team = "allies";
	self.aiteam = "allies";
	self.airank = "Turned";
	self.name = "I AM THE ONE";
	self SetHUDWarningType( "zombie_friend" );
	self setzombiename( "BRaaaiiiiNNNNNZZZ" );
	self.activatecrosshair = true;
	self.meleeDamage=0;
	self.health = 999999;
	self.moveplaybackrate = 1.2;
	iprintln("EFFECTED");
	self.needs_run_update = true;
	
	if ( !is_true( self.completed_emerging_into_playable_area ) )
	{
		self waittill( "completed_emerging_into_playable_area" );

		// turn off find flesh
		self OrientMode( "face default" );
		
	}
		self notify( "stop_find_flesh" );
	self.run_combatanim = level.scr_anim[anim1][anim2];
	self doDamage(1, self.origin, undefined, undefined, undefined);
	self thread DeathTime(time, attacker);
	self SetGoalPos( self.origin );
	
	// don't start reacting until traverse is done
	if ( is_true( self.is_traversing ) )
	{
		self waittill( "zombie_end_traverse" );
	}
	
	while(self.health > 0){	
		self thread turned_local_blast();
		wait 1;
		self doDamage(1);
		self notify( "zombie_acquire_enemy" );
		self.ignoreall = true;
		self.ignoreme = true;
	}
}

turned_local_blast( attacker )
{	
close = [];
	zombies = getAiSpeciesArray("axis", "all");
	v_turned_blast_pos = self.origin;
	

		
	if ( !isDefined( zombies ) )
	{
		return;
	}

	f_turned_range_sq = 99 * 99;
	
	n_flung_zombies = 0; // Tracks number of flung zombies, compares to ZM_AAT_TURNED_MAX_ZOMBIES_FLUNG
	for ( i = 0; i < zombies.size; i++ )
	{
if(zombies[i].targetname == "boss_zombie_spawner"){
	level.zomz = zombies[i];
	zombies[i].team = "allies";
	continue;
}

		// If current ai_zombie is already dead
		if ( !IsDefined( zombies[i] ) || !IsAlive( zombies[i] ) )
		{
			continue;
		}
		
		// If current ai_zombie is immune to indirect results from the AAT
		
		// If current zombie is the one hit by Turned, bypass checks
		if ( zombies[i] == self )
		{
			continue;
		}

		// Get current zombie's data
		v_curr_zombie_origin = zombies[i] GetCentroid();
		if ( DistanceSquared( v_turned_blast_pos, v_curr_zombie_origin ) > f_turned_range_sq )
		{
			continue;
		}
		

		//destination_point = getClosest(  v_curr_zombie_origin );
		
		
		// Executes the fling.
		zombies[i] DoDamage( 30000, v_curr_zombie_origin, attacker, attacker, "none", "MOD_IMPACT" );

		// Adds a slight variance to the direction of the fling
		n_random_x = RandomFloatRange( -3, 3 );
		n_random_y = RandomFloatRange( -3, 3 );

		zombies[i] StartRagdoll( true );
		zombies[i] LaunchRagdoll ( 33 * VectorNormalize( v_curr_zombie_origin - v_turned_blast_pos + ( n_random_x, n_random_y, 33 ) ), "torso_lower" );

		// Limits the number of zombies zm_aat
		
	}
	zombies = getClosest( self.origin, getAiSpeciesArray( "axis" , "all" ) );
	level.zomz.team = "axis";
	//iprintln(zombies.origin);
	self SetGoalPos( zombies.origin );
}

TeleporterZ( Model , Origin , Cost , AngleT , TargetName  , Where , Angles , Needs_power , Glow , Location , Time , Max, Back, Anglez, Stay, Pause )
{
	LoopTrue = false;
	Trig = TargetName + "_trig";
	Tp =  spawnSM( ( Origin ) , Model );
	Trig = spawnTrig( ( Origin ) , 25, 25, "HINT_NOICON", "You must turn on the power first!");
	Trig SetHintString("You must turn on the power first!");
	Tp setmodel(Model);
	Tp.targetname = Targetname;
	if( IsDefined( Needs_power ) && IsDefined( Glow ) )
		playfxontag( level._effect["powerup_on_red"], Tp, "tag_origin" );
	if( is_true( Needs_power ) )
		flag_wait( "power_on" );
	if( IsDefined( Location ) )
		Trig SetHintString( Location + " [Cost:] " + Cost );
	else
	Trig SetHintString( "Teleport to the unknown [Cost:] " + Cost );
	playfxontag( level._effect["powerup_on_solo"], Tp, "tag_origin" );	
    for(;;)
    {
		LoopTrue = false;
		Trig waittill("trigger", i);

		if( IsDefined( i.Block_Tp ) )
		{
			if( !IsDefined( i.annoyance ) )
				i.annoyance = 0;


			if( i.annoyance == 10 )
			{
				i iprintln("Teleporter is cooling down...");
				i.annoyance = 0;
			}
			else
			{
				i.annoyance ++;
			}
			continue;
		}
		//LoopTrue = i bChk( 1, "use" );
		//i iprintln( LoopTrue );
		if( !is_true( i bChk( 0.55, "use", undefined, true, "Teleporting...", (1, 1, 1), ( 106/255, 162/255, 1 ) ) ) )
			{
				wait 0.05;
				continue;
			}

		if(i.score >= Cost)
		{
			if( IsDefined( i.Block_Tp ) )
				continue;
			//i.Block_Tp = true;
			i maps\_zombiemode_score::minus_to_player_score( Cost );
			i thread TeleporterDo( Where , Angles , Time , Max , Back , Anglez, Stay, Pause );
		} 
		else i iprintln("^3Not enuf^7,^3 buckaroo^7!");
	}
}

Tp_Exhaust( Max, Time )
{
	self endon("Stop_Tp");
	self endon("disconnect");
	self endon("death");
	self.Block_Tp = true;
	//Time = 15; Max = 15;
	wait 5;
	wait Time;
	wait Max;
	self.Block_Tp = undefined;
	self iprintln( "Teleporter Cooldown Lifted" );
}

TeleporterDo(Where , Angles , Time , Max , Back , Anglez, Stay, Pause)
{
	self endon("Stop_Tp");
	self endon("disconnect");
	self endon("death");
	// I am very lazy to fix the time :)
	self thread Tp_Exhaust( Max );
	self.ignoreme = true;
	self EnableInvulnerability();
	self FreezeControls(true);
	self VisionSetNaked("Flare",5);
	if( IsDefined( level.Uses_Tp_FX ) )
	self setelectrified(6);
	self ShellShock( "explosion", 2, true );
	wait 3;
	self ZoomyOut();
	self notify("stop_fov");
	self FreezeControls(false);
	self VisionSetNaked("Default",10);
	self ShellShock( "explosion", 1, true );
	self SetOrigin(Where);
	self SetPlayerAngles(Angles);
	self ZoomyIn();
	self notify("stop_fov");
	wait .05;
	self setClientDvar( "cg_fov", 65 );
	self setClientDvar( "cg_fov", GetDvarFloat( #"cg_fov_default") );
	if( IsDefined( Stay ) ){
		wait .1;
	while( !self IsOnGround() ){
			if(is_true( pause ))
				self setPlayerGravity( 115 );
		self SetVelocity( (0,0,self getVelocity()[2] ) );
		wait .05;
	}
		self ShellShock( "explosion", 2, true );
		wait 5;
	self.ignoreme = false;
	self DisableInvulnerability();
	if(is_true( pause ))
				self setPlayerGravity( 800 );
	return;
	}
	wait Time;
	self VisionSetNaked("Flare",5);
	if( IsDefined( level.Uses_Tp_FX ) )
	self setelectrified(6);
	self ShellShock( "explosion", 2, true );
	wait 3;
	self ZoomyOut();
	self notify("stop_fov");
	self SetOrigin(Back);
	if(is_true( pause ))
				self setPlayerGravity( 115 );
	self SetPlayerAngles(Anglez);
	self thread ZoomyIn();
	wait .1;
	while( !self IsOnGround() ){
		self SetVelocity( (0,0,self getVelocity()[2] ) );
		wait .05;
	}
	self notify("stop_fov");
	self VisionSetNaked("Default",10);
	self ShellShock( "explosion", 1, true );
	if(is_true( pause ))
			self setPlayerGravity( 800 );
	wait 5;
	self.ignoreme = false;
	self DisableInvulnerability();

}

ZoomyOut( Input, Input2 )
{
	self endon("stop_fov");
	self endon("disconnect");
	ToThis = GetDvarFloat( #"cg_fov" ) * 17;
	Init = GetDvarFloat( #"cg_fov" );
	Max = 180;
	for(i=Init;i<Max;i+=ToThis/Max)
	{
		self setClientDvar("cg_fov", i);
		wait .05;
	}
	if( IsDefined( Input ) )
	{
		self EnableInvulnerability();
		while( !self IsOnGround() )
		{
			self SetVelocity( (0,0,self getVelocity()[2] ) );
			wait .05;
		}
		self VisionSetNaked("Default",10);
		self DisableInvulnerability();
		self ShellShock( "explosion", 1, true );
		self DisableInvulnerability();
		wait 5;
		self.ignoreme = false;
		wait Input2;
		self.Block_Tp = undefined;
	}
}

ZoomyIn(Input, Input2)
{
	self endon("stop_fov");
	self endon("disconnect");
	ToThis = GetDvarFloat( #"cg_fov_default" );
	Init = GetDvarFloat( #"cg_fov" );
	Max = ToThis;
	for(i=180;i>Max;i-=Init/Max+5)
	{
		self setClientDvar("cg_fov", i);
		wait .05;	
	}
	if( IsDefined( Input ) )
	{
		self EnableInvulnerability();
		while( !self IsOnGround() )
		{
			self SetVelocity( (0,0,self getVelocity()[2] ) );
			wait .05;
		}
		self VisionSetNaked("Default",10);
		self DisableInvulnerability();
		self ShellShock( "explosion", 1, true );
		self DisableInvulnerability();
		wait 5;
		self.ignoreme = false;
		wait Input2;
		self.Block_Tp = undefined;
	}
}

Coast_Teleporter()
{
	thread TeleporterZ("zombie_carpenter",(56,1590,900),1500,( 0,0,0 ), "Packerz" , (-4058,775,150),(0,50,0),true,true,undefined,60, 200, (-1517,656,2900),(0,100,0),undefined);
	Trigger_Create("Stop", (-2100,841,-300), 3600 , 35, "^1FUCK", "Stop_Tp", ::TextThis,::TpThing,::ZoomyIn,"^FLol imagine falling down",(-1517,656,2900),true, undefined, undefined, 290);
}

Moon_Teleporter()
{
	level thread TeleporterZ("zombie_carpenter",(87,4269,-530),750,( 0,0,0 ), "Packerz" , (14032,-14496,1700),(0,50,0),true,true,undefined,0, 5, (-1517,656,2900),(0,100,0),true);
	wait 1;
	level thread TeleporterZ("zombie_carpenter",(14213,-14143,-630),500,( 0,0,0 ), "Spawn" , (-625,178,400),(0,50,0),true,true,"Spawn",0, 30, (-1517,656,2900),(0,100,0),true);
	level.tesla_max_arcs = 5;
	level.tesla_max_enemies_killed = 5;
	level.tesla_radius_start = 300;
	level.tesla_radius_decay = 20;
	level.tesla_head_gib_chance = 100;
	level.tesla_arc_travel_time =	0.3;
	level.tesla_kills_for_powerup = 15;
	level.tesla_min_fx_distance = 128;
	level.tesla_network_death_choke = 4;
	level Perkaholic_spawn();
}

Trigger_Create(TargetNamez, Origin, Width, Height, Text, Notify, Function1, Function2, Function3, Input1, Input2, Input3, Input4, Input5, Input6 )
{
	TargetNamez = spawnTrig( ( Origin ), Width, Height, "HINT_NOICON", Text);
	TargetNamez Create_Trigger( Text, Notify, Function1, Function2, Function3, Input1, Input2, Input3, Input4, Input5, Input6 );
}

Create_Trigger( Text, Notify, Function1, Function2, Function3, Input1, Input2, Input3, Input4, Input5, Input6 )
{
	self SetHintString( Text );
	self.Function1 = Function1;
	self.Function2 = Function2;
	self.Function3 = Function3;
	self.input1 = Input1;
	self.input2 = Input2;
	self.input3 = Input3;
	self.input4 = Input4;
	self.input5 = Input5;
	self.input6 = Input6;
	for(;;)
	{
		self waittill("trigger", i);
		i notify(Notify);
		wait .05;
		i [[ self.Function1 ]]( self.input1, self.input4 );
		i [[ self.Function2 ]]( self.input2, self.input5 );
		i [[ self.Function3 ]]( self.input3, self.input6 );
		wait_network_frame();
	}
}

TpThing(Input){
	self SetOrigin(Input);
}

Minigun_Powerup(weapon, Time, Endon)
{
	self endon(Endon);
	Enemy = getAiSpeciesArray("axis", "all");
	 for (i = 0; i < Enemy.size; i++) {
		 if(Enemy[i].targetname == "boss_zombie_spawner")
		 Enemy[i].team = "allies";
	 }
	position = self.origin + (0, 0, 60);
	base_pos = position + (0, 0, 60);
	//start_yaw = VectorToAngles( base_pos - self.origin );
	//start_yaw = (0, start_yaw[1], 0);
	attacher = spawnSM(undefined, "tag_origin");
	weapon_model = spawn( "script_model", position );
	self thread Delete_On_Notify(weapon_model, Endon, "disconnect");
	//weapon_model.angles = start_yaw;
	//attacher linkTo(self);
	weapon_model linkTo(self);
	modelname = GetWeaponModel( weapon );
	weapon_model setmodel( modelname );
	weapon_model useweaponhidetags( weapon );
	attacher MoveTo( base_pos, 1, 0.25, 0.25 );
	playfxontag( level._effect["powerup_on_solo"], weapon_model, "tag_origin" );
	//self thread DoFloaty();
	//attacker = self;
	for ( i = 0; i < Time; i++ )
	{
		zombies = getClosest( self.origin, getAiSpeciesArray( "axis" , "all" ) );
		//yaw = start_yaw + (RandomIntRange( -3, 3 ), i * 10, 0);
		//weapon_model.angles = yaw;
		flash_pos = weapon_model GetTagOrigin( "tag_flash" );
		weapon_model linkTo(self);
		MagicBullet( "dragunov_upgraded_zm", flash_pos, zombies GetCentroid(), self );
		wait .05;
		wait_network_frame();
	}

	weapon_model Delete();
	Enemy = getAiSpeciesArray("allies", "all");
	 for (i = 0; i < Enemy.size; i++) {
		 if(Enemy[i].targetname == "boss_zombie_spawner")
		 Enemy[i].team = "axis";
	 }
}

Hud_Swish(Ent, Notify, Color1, Color2, Time, Faded)
{
    self endon("disconnect");
    self endon("death");
    self endon(Notify);
	if( !IsDefined( Notify ) )
		return;
	if( !IsDefined( Time ) )
		Time = 1;
	
    for (;;) {
		if( IsDefined( Faded ) )
			Ent fadeOverTime(1);
		Ent.color = Color1;
		if( !IsDefined( Color1 ) || !IsDefined( Color2 ) )
			Ent.color = (randomInt(255) / 255, randomInt(255) / 255, randomInt(255) / 255);
        wait Time;
		if( IsDefined( Faded ) )
			Ent fadeOverTime(1);
		Ent.color = Color2;
		if( !IsDefined( Color1 ) || !IsDefined( Color2 ) )
			Ent.color = (randomInt(255) / 255, randomInt(255) / 255, randomInt(255) / 255);
		wait Time;
		
    }
}

Weapon_Specialty( Weapon, Fired_Weapon, Max, To_Minus, Stuff, Talk )
{
	self endon( Weapon + "Specialty_Over" );
	self endon( "disconnect" );
	To_Minus *= -1;
	Add = 0;
	if( IsDefined( Stuff ) )
	{
		self iprintlnbold(Talk + " Must be upgraded in" );
		self iprintlnbold( "tier list for extra damage!" );
	}
	for(;;)
	{
		self waittill("weapon_fired");
		if( self getCurrentWeapon() != Weapon )
			continue;
		Subtraction = self.Weapon_Upgrade_Enhance[Weapon] * To_Minus;
		To_Max = Max + Subtraction;
		Add ++;
		if(Add >= To_Max)
		{
			Add = 0;
			magicBullet( Fired_Weapon, self getTagOrigin("tag_weapon"), self lookPos(), self );
		}
	}
	
}
Delete_On_Notify( Thing, Notify, Notify2, Notify3, Text )
{
	self endon("disconnect");
	self waittill_any( Notify, Notify2, Notify3 );
	self iprintln(Text);
	Thing destroy();
	Thing delete();
}

Tp_To_Self( Entity )
{
	//self iprintln( "ENTITY IS " + Entity );
	Pos = self.origin;
	Ent = getEntArray( Entity, "targetname" );
	//Ent = getentarray("script_model", "classname");
	EntTrigger = getEntArray(Entity + "_trig", "targetname");
    for (m = 0; m < Ent.size; m++)
	{
			//Ent[m] SetOrigin( self.origin );
			Ent[m].origin = self.origin;
			EntTrigger[m].origin = self.origin;
			//EntTrigger[m] SetOrigin( self.origin );
			//iprintln( Ent[m] + " Teleported to" + self.origin );
			//iprintln( Ent[m].origin[0] );
			//self iprintln( self.origin[1] );
			//iprintln( Ent[m].targetname );
			//iprintln( Ent[m] );
			//iprintln( EntTrigger[m] );
	}
	
}

Ent_Forge( Flag, pos, Entity )
{
	Ent = getEntArray( Entity, "targetname" );
	EntTrigger = getEntArray( Entity + "_trig", "targetname" );
	for( m = 0; m < Ent.size; m++ )
	{
		Origin = Ent[m].origin;
		Angles = Ent[m].angles;
		if( is_true( Flag ) )
		{
			if( Angles[0] + pos[0] >= 360 )
				pos[0] -= 360;
			if( Angles[1] + pos[1] >= 360 )
				pos[1] -= 360;
			if( Angles[2] + pos[2] >= 360 )
				pos[2] -= 360;
			Ent[m].angles += ( pos[0], pos[1] ,pos[2] );
		}
		else
		{
			Ent[m].origin += ( pos[0], pos[1] ,pos[2] );
			EntTrigger[m].origin += ( pos[0], pos[1] ,pos[2] );
		}
	}
}

Ent_Position( Entity )
{
	Ent = getEntArray( Entity, "targetname" );
	for( m = 0; m < Ent.size; m++ )
	{
		self iprintln( "Pos: " + Ent[m].origin + " Angles: " + Ent[m].angles );
	}
}


mOption( var, newVar )
{
	var = newVar;
	return newVar;
}

MenuOp( toMenu, var, newVar, var2, newVar2 )
{
	if( IsDefined( var ) )
		level.MenuOp1 = mOption( var, newVar );
	if( IsDefined( var2 ) )
	level.MenuOp2 = mOption( var2, newVar2 );

	self refreshmenu();
	self newMenu( toMenu );
}

bChk( Time, Input, Input2, Hud, TextH, Color, Fade )
{
	if( !IsDefined( Input ) )
		return false;
		if( IsDefined( self.HudBar ) )
		{
			self.HudBar maps\_hud_util::destroyElem();
			self.HudBar = undefined;
		}
		if( IsDefined( self.HudText ) )
		{
			self.HudText destroy();
		}

	//Time *= 20;
	numma = 0;
	text = " ";
	Hold_Button = true;
	if( !IsDefined( Time ) )
		Time = 0.05;
	switch( tolower( Input ) )
	{
		case "jump":
			Input = ::testJump;
			iprintln( "Jump is being tested" );
			text += "jump";
		break;
		
		case "attack":
		    Input = ::testAttack;
		    text += "attack";
		break;
		
		case "ads":
		    Input = ::testAds;
		    text += "ads";
		break;
		
		//case "stance":
		//    Input = ::testStance;
		//    text += "stance";
		//break;
		
		case "sprint":
		    Input = ::testSprint;
		    text += "sprint";
		break;
		
		case "melee":
		    Input = ::testMelee;
		    text += "melee";
		break;
		
		case "offhand":
		    Input = ::testOffhand;
		    text += "testOffhand";
		break;

		case "frag":
			Input = ::testFrag;
			text += "frag";
		break;

		case "use":
			Input = ::testUse;
			text += "use";
		break;

		default: iprintln( "Incorrect Button" ); return;
	}

	if( IsDefined( Input2 ) )
	switch( tolower( Input2 ) )
	{
		case "jump":
			Input2 = ::testJump;
			iprintln( "Jump is being tested" );
			text += "jump";
		break;
		
		case "attack":
		    Input2 = ::testAttack;
		    text += "attack";
		break;
		
		case "ads":
		    Input2 = ::testAds;
		    text += "ads";
		break;
		
		//case "stance":
		//    Input = ::testStance;
		//    text += "stance";
		//break;
		
		case "sprint":
		    Input2 = ::testSprint;
		    text += "sprint";
		break;
		
		case "melee":
		    Input2 = ::testMelee;
		    text += "melee";
		break;
		
		case "offhand":
		    Input2 = ::testOffhand;
		    text += "testOffhand";
		break;

		case "frag":
			Input2 = ::testFrag;
			text += "frag";
		break;

		case "use":
			Input2 = ::testUse;
			text += "use";
		break;

		default: iprintln( "Incorrect Button 2" ); return;
	}
	if( IsDefined( TextH ) )
	{
		self.HudText = newclientHudElem( self );
		self.HudText.alignX = "center";
		self.HudText.alignY = "middle";
		self.HudText.horzAlign = "center";
		self.HudText.vertAlign = "bottom";
		self.HudText.y = -113;
		self.HudText.foreground = true;
		self.HudText.font = "default";
		self.HudText.fontScale = 1.8;
		self.HudText.alpha = 1;
		self.HudText.color = Color;
		self.HudText setText( TextH );
		self.HudText fadeOverTime( Time );
		if( IsDefined( Fade ) )
			self.HudText.color = Fade;

	}
	

	if( is_true( Hud ) )
	{
		self.HudBar = self maps\_hud_util::createPrimaryProgressBar();
		self.HudBar maps\_hud_util::updateBar( 0.01, 1 / ( Time - .05 ) );
	}
	if( !is_true( Hud ) )
		self.HudBar maps\_hud_util::destroyElem();

	if( !IsDefined( Input2 ) )
	while( is_true( Hold_Button ) && numma < Time )
	{
	    if( is_true ( [[ Input ]]( self ) ) )
	    {
	        wait 0.05;
		    numma += 0.05;
	    }
	    else
		{
	    	Hold_Button = false;
		}
	}
	else
	while( is_true( Hold_Button ) && numma < Time )
	{
	    if( is_true ( [[ Input ]]( self ) ) && is_true ( [[ Input2 ]]( self ) ) )
	    {
	        wait 0.05;
		    numma += 0.05;
	    }
	    else
		{
	    	Hold_Button = false;
		}
	}

	if( IsDefined( self.HudText ) )
	{
		self.HudText destroy();
	}
	self.HudBar maps\_hud_util::destroyElem();

	if( numma > Time )
		return true;
	else
		return false;
}


testJump( who )
{
	return who jumpbuttonpressed();
}

testJumping( who )
{
	time = 0;
	while( time < 5 && testJump() )
	{
		if( is_true( testJump( who ) ) )
			who iprintln( true );
		wait 0.05;
	}
}

testJumpingStop( who )
{
	time = 0;
	testme = true;
	while( time < 5 && testme == true )
	{
		if( is_true( testJump( who ) ) )
			who iprintln( true );
			else
			testme = false;
		time += 0.05;
		wait 0.05;
	}
	if( time == 5 )
		self iprintln( "Test is correct!" );
}

//I made these for the function to test buttons in a loop.

testAttack( who )
{
    return who attackbuttonpressed();
}

testAds( who )
{
    return who adsbuttonpressed();
}

//testStance( who )
//{
//   // return who stancebuttonpressed();
//}

testSprint( who )
{
    return who sprintbuttonpressed();
}


testMelee( who )
{
    return who meleebuttonpressed();
}

testOffhand( who )
{
    return who secondaryoffhandbuttonpressed();
}

testFrag( who )
{
	return who fragButtonPressed();
}

testUse( who )
{
	return who UseButtonPressed();
}

testHud()
{
	if( is_true( self bChk( 0.45, "jump", "sprint", true, "Test", (1, 1, 1), ( 106/255, 162/255, 1 ) ) ) )
		self iprintln( "Task Completed" );
}

zMap()
{
	if( !IsDefined( self ) )
		return false;
		
	if( is_true( self.completed_emerging_into_playable_area ) )
		return true;
	else
		return false;
}

is_boss()
{
	if( !IsDefined( self ) )
		return false;
	if( self.targetname == "astronaut_zombie_ai" || self.targetname =="boss_zombie_spawner")
		return true;
	else
		return false;
}


