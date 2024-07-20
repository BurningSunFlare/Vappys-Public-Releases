#include common_scripts\utility;
#include maps\_utility;
#include maps\_hud_util;
#include maps\_load_common;
#include maps\_zombiemode_utility;
#include maps\physicsfunctions;
#include maps\physicsmodes;
#include maps\vapp;
#include maps\VapAmmo;
#include maps\physicsbases;
//#include maps\_zombiemode_equipment;
init() {
	level.MenuOp1 = "TEST!";
	level.MenuOp2 = undefined;
	precacheItem("m16_sp");
	precacheItem("m1911_sp");
	precacheItem("explosive_bolt_zm");
	precacheItem("explosive_bolt_upgraded_zm");
	//precacheItem("frag_grenade_sp");
	//xoverflowfix(60);
	if(!isDefined(level._effect))
		level._effect = [];
	level._effect["grain_test"] = loadFx("misc/grain_test");
	level._effect["mortarExp_water"] = loadFx("explosions/mortarExp_water");
	level._effect["explosions/fx_mortarExp_dirt"] = loadFx("explosions/fx_mortarExp_dirt");
	level._effect["default_explosion"] = loadFx("explosions/default_explosion");
	shader = strTok("line_horizontal;hud_status_dead;ui_scrollbar;offscreen_icon_us;hint_health;damage_feedback;cinematic;objectivea;objectiveb;objectivec;objectived;hud_checkbox_active;menu_map_nazi_zombie_factory;gradient;ui_sliderbutt_1;ui_slider2;hud_checkbox_done;ui_host;menu_button_backing_highlight;menu_popup_back;talkingicon;checkerboard;white_line_faded_center;gradient_center;scorebar_zom_1;scorebar_zom_2;scorebar_zom_3;scorebar_zom_4", ";");
	model = strTok("zombie_teleporter;weapon_usa_kbar_knife;static_peleliu_sandbags_lego_end;static_peleliu_sandbags_lego_mdl;static_peleliu_sandbag;projectile_usa_m9a1_riflegrenade;static_peleliu_palette;prefab_brick_group;static_peleliu_corrugated_metal1;zombie_beaker_small;zombie_beaker_med;static_peleliu_shelves_ammo;static_berlin_furnacedoor;static_berlin_furnacelatch;zombie_beaker_sphere;zombie_lab_dead_rat;static_global_trash_4x4;zombie_perk_bottle_sleight;zombie_perk_bottle_revive;zombie_perk_bottle_doubletap;zombie_perk_bottle_jugg;clutter_peleliu_tire_single;zombie_teleporter_control_panel;static_seelow_blackbarrel;zombie_wallclock_main;defaultvehicle;zombie_teleporter_pad;defaultactor;weapon_zombie_monkey_bomb;zombie_wolf;zombie_vending_jugg_on;zombie_vending_doubletap_on;zombie_vending_revive_on;zombie_vending_sleight_on;zombie_vending_packapunch_on;zombie_transformer;zombie_pile_wood_box;static_peleliu_corrugated_metal4;zombie_nameplate_maxis;static_peleliu_crate01_short;static_peleliu_crate01;zombie_beaker_brain;zombie_brain;defaultactor;defaultvehicle;test_sphere_silver;dest_opel_blitz_body_dmg0;dest_peleliu_generator_mobile_dmg0;static_berlin_victorian_couch_d;static_peleliu_filecabinet_metal;static_berlin_crate_metal;zombie_treasure_box;zombie_treasure_box_lid;test_sphere_silver;static_peleliu_b17_bomber_body;zombie_bomb;zombie_vending_sleight_on;zombie_vending_jugg_on;zombie_vending_revive_on;static_berlin_ger_radio;prefab_berlin_asylum_dbldoor_dr;zombie_wheelchair;zombie_zapper_power_box;zombie_asylum_chair;zombie_treasure_box_rubble;zombie_metal_cart;zombie_power_lever;static_seelow_woodbarrel_single;static_berlin_plainchair;static_peleliu_barbedwire;zombie_sumpf_bearpile;static_berlin_ger_radio;static_berlin_loudspeaker;static_berlin_loudspeaker_d;static_peleliu_blackbarrel01;zombie_vending_doubletap_price;zombie_vending_revive_on_price;zombie_vending_sleight_on_price;zombie_vending_jugg_on_price;zombie_lab_cage;static_berlin_metal_desk;zombie_spine;zombie_teleporter_pad;zombie_wolf;zombie_teddybear;static_peleliu_filecabinet_metal;zombie_teleporter_mainframe_ring1;zombie_vending_packapunch;zombie_teddybear_perkaholic;zombie_difference_engine;zombie_vending_doubletap_on;zombie_teleporter_powerline;zombie_factory_bearpile;zombie_chalkboard;zombie_wallclock_main;zombie_30cal;viewmodel_zombie_mg42_mg;viewmodel_zombie_raygun_up;zombie_mg42;mg42_bipod;zombie_teleporter_powerline;viewmodel_usa_tesla_gun;viewmodel_zombie_ppsh_smg_up;zombie_teleporter_powerline", ";");
	item = strTok("zombie_perk_bottle_revive;zombie_perk_bottle_sleight;zombie_perk_bottle_doubletap;zombie_perk_bottle_jugg", ";");
	array_precache(shader, "shader");
	array_precache(model, "model");
	array_precache(item, "item");
	level.tokkk = strTok("static_berlin_ger_radio static_peleliu_corrugated_metal1 static_peleliu_corrugated_metal3 static_peleliu_corrugated_metal4 static_peleliu_corrugated_metal5 static_peleliu_sandbags_lego_end static_peleliu_sandbag static_peleliu_crate01 static_peleliu_crate02 static_berlin_wood_ammo_box01 static_berlin_wood_ammobox_02 static_berlin_wood_ammobox_03 static_berlin_wood_ammobox_04 static_peleliu_palette static_berlin_metal_desk static_peleliu_shelves_ammo static_berlin_plainchair static_makin_dockpost static_okinawa_int_chair static_peleliu_beigebarrel01 static_peleliu_beigebarrel01_d static_seelow_woodbarrel_single static_peleliu_crate_jpn_mrtr_clsd static_peleliu_blackbarrel01 static_peleliu_blackbarrel01_d static_peleliu_stick_trap_single static_seelow_burnbarrel_plain static_peleliu_rock01 static_peleliu_crate01_short static_peleliu_sandbags_lego_mdl static_peleliu_barbedwire static_berlin_radio_headset static_berlin_telephone_hang static_berlin_electrical_panelb static_berlin_typewriter static_berlin_engine_control_a static_berlin_books_row01 static_berlin_books_row02 static_berlin_books_row03 static_berlin_books_old3 static_berlin_books_old4 static_berlin_books_open static_berlin_loudspeaker static_berlin_loudspeaker_d clutter_peleliu_wood_ammo_box_closed clutter_peleliu_lilly_pad clutter_peleliu_tire_single clutter_berlin_books_single foliage_oki2_tree_jungle foliage_cod5_tree_willow_01 foliage_cod5_tree_mgrve_2 foliage_pacific_forest_shrubs03 foliage_oki2_tallgrass foliage_pacific_fern01 foliage_pacific_grass04_clump02 foliage_pacific_hangrice_piece1 foliage_pacific_riceplant_large foliage_pacific_ground_cover01 foliage_cod5_tree_mgrve_2_noshadow foliage_pacific_rice_cut foliage_pacific_fern02 foliage_pacific_forest_shrubs02 foliage_pacific_grass07_clump02 foliage_pacific_forest_shrubs01 foliage_pacific_grass07_clump01 fx_axis_createfx lantern_hang_on lantern_on lights_jap_field_lantern_on lights_indlight_on lights_tinhatlamp_on radio_jap_bro prefabs_bamboo_pole_d zombie_bomb zombie_skull zombie_x2_icon zombie_ammocan zombie_metal_cart zombie_surgical_case zombie_surgical_bonesaw zombie_sumpf_parachute2 zombie_lantern_on zombie_lantern_off zombie_zapper_power_box zombie_sumpf_fish_float zombie_zapper_tesla_coil zombie_sumpf_zipcage_box zombie_vending_sleight_on_price zombie_vending_revive_on_price zombie_vending_jugg_on_price zombie_vending_doubletap_price zombie_treasure_box zombie_treasure_box_lid zombie_sumpf_bearpile zombie_wolf zombie_wolf_variant_a zombie_teddybear defaultvehicle defaultactor test_sphere_silver", " ");
	array_precache(level.tokkk, "model");
	precacheShader("hint_usable");
	precacheShader("hud_icon_colt");
	precacheShader("zombie_intro");
	
	if	(
			level.script == "zombie_cod5_prototype"
			|| level.script == "zombie_cod5_factory"
			|| level.script == "zombie_cod5_sumpf"
			|| level.script == "zombie_cod5_asylum"
		)
	{
			precacheItem("rpk_upgraded_zm");
			doNachtLoad("crossbow_explosive_zm", "crossbow_explosive_upgraded_zm");
			//doNachtLoad("minigun_zm", "minigun_upgraded_zm");
			doNachtLoad("ray_gun_zm", "ray_gun_upgraded_zm");
			doNachtLoad("aug_zm", "aug_acog_mk_upgraded_zm");
			precacheItem("mk_aug_upgraded_zm");
			doNachtLoad("famas_zm","famas_upgraded_zm");
			doNachtLoad("china_lake_zm","china_lake_upgraded_zm");
			doNachtLoad("commando_zm","commando_upgraded_zm");
			doNachtLoad("cz75","cz75_upgraded_zm");
			doNachtLoad("cz75dw_zm","cz75dw_upgraded_zm");
			doNachtLoad("dragunov_zm","dragunov_upgraded_zm");
			doNachtLoad("fnfal_zm", "fnfal_upgraded_zm");
			doNachtLoad("g11_lps_zm","g11_lps_upgraded_zm");
			doNachtLoad("galil_zm", "galil_upgraded_zm");
			doNachtLoad("l96a1_zm", "l96a1_upgraded_zm");
			doNachtLoad("hs10_zm", "hs10_upgraded_zm");
			doNachtLoad("m72_law_zm", "m72_law_upgraded_zm");
			doNachtLoad("python_zm", "python_upgraded_zm");
			doNachtLoad("hk21_zm", "hk21_upgraded_zm");
			doNachtLoad("spas_zm", "spas_upgraded_zm");
			precacheItem("thundergun_upgraded_zm");
			doNachtLoad("spectre_zm", "spectre_upgraded_zm");
			precacheItem("m16_gl_upgraded_zm");
			doNachtLoad( "m16_zm", "m16_gl_upgraded_zm" );
			//doNachtLoad( "mp5k", "mp5k_upgraded_zm" );
			doNachtLoad( "mp40_zm", "mp40_upgraded_zm" );
			doNachtLoad( "m14_zm", "m14_upgraded_zm" );
			doNachtLoad( "ak74u_zm", "ak74u_upgraded_zm" );
			doNachtLoad( "mpl_zm", "mpl_upgraded_zm" );
			doNachtLoad( "rottweil72_zm", "rottweil72_upgraded_zm" );
			doNachtLoad( "ithaca_zm", "ithaca_upgraded_zm" );
			doNachtLoad("pm63_zm", "pm63_upgraded_zm");
			doNachtLoad("tesla_gun_zm", "tesla_gun_upgraded_zm");
			doNachtLoad("freezegun_zm", "freezegun_upgraded_zm");
			doNachtLoad("m1911_zm", "m1911_upgraded_zm");
			
	}
	
	
	level thread onPlayerConnect();
}

array_precache(array, type)
{
	for(m = 0; m < array.size; m++)
	{
		switch(type)
		{
			case "model":
				precacheModel(array[m]);
				break;
			case "shader":
				precacheShader(array[m]);
				break;
			case "item":
				precacheItem(array[m]);
				break;
		}
	}
}


onPlayerConnect() {
    self.pisbucket = true;
    self.assbucket = true;
    self.GodModeIsOn = false;
    level.godtextshow = true;
    level.modmenulobby = false;
    level.rainstarter = true;
    level.Raindeletetime = false;
    level.Small = false;
    level.BigBoy = false;
    level.InOutAction = false;
    level.NotifyTextDelete = false;
    level.The_Forge_Lobby = false;
    level.primaryProgressBarTextX = 0;
    level.primaryProgressBarTextY = 96;
    level.primaryProgressBarFontSize = 1.3;
    level.lobbyTimer = "^1Not Set";
    level.patch = "Physics 'n' Flex v2 edit";
    level.patchCreator = "Mikeeeyy - Edited by Mikeeeyy";
    level.permissions = strTok("Client;Vip;Admin;Host", ";");
    level.additionTrigs = [];
    level.visions = strTok("berserker;ber1_default;ber2;ber2_collapse;ber2_darksubway;ber2_interior;ber2_lightsubway;ber2_smoke_crouch;ber2_smoke_stand;ber3;ber3b;ber3b_2;cheat_bw;cheat_bw_contrast;cheat_bw_invert;cheat_contrast;cheat_invert;cheat_invert_contrast;default_night;flare;fly_dark;fly_light;fly_mid;grayscale;introscreen;kamikaze;default", ";");
    level.visions2 = strTok("laststand;mak;mak_Fire;mpoutro;oki2;oki3_mortar;pel1;pel1a_intro;pel1a_intro2;pel1_battlefield;pel1b;pel1b_caves;revive;see1;see1_fire;see2;sepia;sniper_inside_fire;sniper_wake;sniper_water;vampire_low;vampire_high;zombie_factory;zombie_turned;default", ";");
    level.prestigeBadges = [];
    level.prestigeBadges[0] = "rank_comm1";
    for (m = 1; m <= 11; m++)
        level.prestigeBadges[m] = "rank_prestige" + m;
    level.ranks = strTok("Private;Private II;Private III;Private First Class;Private First Class I;Private First Class II;Corporal;Corporal I;Corporal II;Sergeant;Sergeant I;Sergeant II;Staff Sergeant;Staff Sergeant I;Staff Sergeant II;Staff Sergeant III;Gunnery Sergeant;Gunnery Sergeant I;Gunnery Sergeant II;Gunnery Sergeant III;Master Sergeant;Master Sergeant I;Master Sergeant II;Master Sergeant III;Sergeant Major;Sergeant Major I;Sergeant Major II;Sergeant Major III;2nd Lieutenant;2nd Lieutenant I;2nd Lieutenant II;2nd Lieutenant III;1st Lieutenant;1st Lieutenant I;1st Lieutenant II;1st Lieutenant III;Captain;Captain I;Captain II;Captain III;Major;Major I;Major II;Major III;Lt. Colonel;Lt. Colonel I;Lt. Colonel II;Lt. Colonel III;Colonel;Colonel I;Colonel II;Colonel III;Brigadier General;Brigadier General I;Brigadier General II;Brigadier General III;Major General;Major General I;Major General II;Major General III;Lieutenant General;Lieutenant General I;Lieutenant General II;Lieutenant General III;Commander", ";");
    level.clanTags = strTok("NERD;FUCK;SLUT;SHIT;NUTS;SLAG;PAKI;{@@};SEX;SEXY;FAG;ARSE;IW;@@@@;DICK;COCK;ASS;NIGR;JTAG;PORN;TITS;BOOB;PUSY;CUNT;3ARC;CYCL;MOVE;RAIN;CYLN;KRDR;****;....;BLUE;CYAN;GRN;RED;YELW", ";");
    level.menuWait = .4;
    level.hideSeek_timer = 90;
    level.colr = strTok("Black;Red;Green;Yellow;Blue;Cyan;Orange;White", ";");
    level.cols = strTok("^0;^1;^2;^3;^4;^5;^6;^7", ";");
    level.char = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 ";
    level.powerUps = strTok("double_points;insta_kill;full_ammo;nuke;carpenter", ";");
    level.powerUpModels = strTok("zombie_x2_icon;zombie_skull;zombie_ammocan;zombie_bomb;zombie_carpenter", ";");
    level.powerUpProper = strTok("Double Points;Insta-Kill;Max Ammo;Nuke;Carpenter", ";");
    level.maniaMax = 10;
	level.VanQuick = 10;
	level.VanFast = 15;
	level.VanSlot1 = 17;
	level.VanRof = 20;
	level.VanJug = 20;
	level.VanClip = 25;
	level.VanSlot2 = 25;
    for (;;) {
        level waittill("connected", player);
        player thread onPlayerSpawned();
    }
}

onPlayerSpawned() {
	self setClientDvar("loc_warnings", 0);
    self setClientDvar("loc_warningsAsErrors", 0);
    for (i = 1; i < getPlayers().size; i++) {
        getPlayers()[i] thread grantMenu(level.permissions[0]);
        getPlayers()[i] thread lockMenu();
        //getPlayers()[i] thread naughtyDvars();
    }
    for (;;) {
        self waittill("spawned_player");
        if (isDefined(self.playerSpawned))
            continue;
        self.playerSpawned = true;
        self.menusmall = false;
        self.menumedium = true;
        self.menularge = false;
        self.menuexlarge = false;
        self.Menusizing = false;
        self.TOPCENTER = true;
        level.chalk_hud1.foreground = 0;
        level.chalk_hud1.sort = -1000;
        level.chalk_hud2.foreground = 0;
        level.chalk_hud2.sort = -1000;
        self.Has_The_Menu = true;
		self setPermission(level.permissions[0]);
		self grantMenu(level.permissions[0]);
		self thread lockMenu();
		self thread Bootan();
		self setClientDvar("sv_cheats", "1");
		self setClientDvar("con_select", "");
		self setClientDvar("activeAction", "vstr con");
		self.camo = 0;
		self.lens = 0;
		self.reticle = 0;
		self.color = 0;
		buttonConfig = strTok("enter BUTTON_X", " ");
		self setClientDvar("con", "activeAction vstr con;bind2 " + strTok("enter BUTTON_X", " ")[isConsole()] + " vstr con_select");
		self thread levelJustStarted();
	}
}

/*camea(){
	for(;;){
		//self restart_test();
		self waittill("weapon_fired");
	}
}
*/

bootan()
{
wait (1);
players = get_players();
self set_player_tactical_grenade( "frag_grenade_sp" );
//equipment = "zombie_cymbal_monkey";
//self set_player_equipment( equipment );
//self GiveWeapon( equipment );
//self notify(equipment + "_given");
//self setactionslot( 1, "weapon", equipment );
//iprintln(self.playername);
//iprintln(GetDvar("party_hostname"));

//self takeWeapon("m1911_zm");
//self giveWeapon("m1911_sp");
//self giveWeapon("m16_sp");
//self switchToWeapon("m1911_sp");

//level.threegun_hacked = true;
//level.ClipSize = 1.52;
//self thread Weapon_Reload("m1911_zm");
//self thread FizzyHUD_setup();
//self thread camea();
//self iprintln("Stocker "+self GetWeaponAmmoStock(self getCurrentWeapon()));
//self iprintln("Clipper "+self GetWeaponAmmoClip(self getCurrentWeapon()));
//self precacheItem("tesla_gun_upgraded_zm");
//self iprintln("ArcadeMode" + GetDvar("ArcadeMode"));
//self iprintln("ZombieMode" + GetDvar("ZombieMode"));
////self setelectrified(5);
//self ShellShock( "electrocution", 1.7, true );
self setClientDvar("cg_fovScale", "1");
//self iprintln("Scoreboard color " + GetDvarFloat(#"cg_scoreboardMyColor"));
//self iprintln("LowAmmoWarningColor1 " + GetDvarFloat("LowAmmoWarningColor1"));
//self iprintln("LowAmmoWarningColor2 " + GetDvarFloat("LowAmmoWarningColor2"));
        self setClientDvar("actionSlotsHide", 0);
		self setClientDvar("bg_playStandToCrouchAnims", 1);
		
        self setClientDvar("r_zombieNameAllowFriendslist", 0);
        self setClientDvar("r_diffuseColorScale,", 6);
        self setClientDvar("r_flashLightOffset", "0 -3 0");
        self setClientDvar("r_flashLightRange", 799 );
        self setClientDvar("r_flashLightEndRadius", 300);
        self setClientDvar("r_flashLightFlickerAmount", 0.5);
        self setClientDvar("r_flashLightFlickerRate", 12);
       // self setClientDvar("r_enableFlashlight", 1);
        //SetDvar("r_zombieNameAllowFriendslist", 0);
        //SetDvar("r_diffuseColorScale,", 6);
        //SetDvar("r_flashLightOffset", "0 -3 0");
        //SetDvar("r_flashLightRange", 799 );
        //SetDvar("r_flashLightEndRadius", 300);
        //SetDvar("r_flashLightFlickerAmount", 0.5);
        //SetDvar("r_flashLightFlickerRate", 12);
        //SetDvar("r_enableFlashlight", 1);
		//setSavedDvar("r_zombieNameAllowFriendslist", 0);
        //setSavedDvar("r_diffuseColorScale,", 6);
        //setSavedDvar("r_flashLightOffset", "0 -3 0");
        //setSavedDvar("r_flashLightRange", 799 );
        //setSavedDvar("r_flashLightEndRadius", 300);
        //setSavedDvar("r_flashLightFlickerAmount", 0.5);
        //setSavedDvar("r_flashLightFlickerRate", 12);
        //setSavedDvar("r_enableFlashlight", 1);
		
      //self setClientDvar("player_topDownCamMode", 2);
	  setSavedDvar("r_zombieNameAllowFriendslist", 0);
      SetDvar("r_zombieNameAllowFriendslist", 0);  
	  self setClientDvar("r_ZombieNameAllowDevList ", 0);
 self.IgnoreGrav = false;
 //self.has_starlight = false;
 	self thread StartDvarRes();
	//level.zombie_weapons = [];
//maps\_zombiemode_weapons::include_zombie_weapon( "microwavegunlh_zm", "m1911_zm", undefined, undefined );
//maps\_zombiemode_weapons::include_zombie_weapon( "zombie_cymbal_monkey", "m1911_zm", undefined, undefined );
//maps\_zombiemode_weapons::include_zombie_weapon( "ray_gun_upgraded_zm", undefined, undefined, undefined );

maps\_zombiemode_weapons::include_zombie_weapon( "defaultweapon", undefined, undefined, undefined );

maps\_zombiemode_weapons::add_zombie_weapon( "defaultweapon", "defaultweapon_upgraded_zm", &"ZOMBIE_WEAPON_SATCHEL_2000", 2000,	"defaultweapon", "", undefined );

maps\_zombiemode_weapons::add_zombie_weapon( "rpk_zm", "rpk_upgraded_zm", &"ZOMBIE_WEAPON_SATCHEL_2000", 2000,	"rpk_zm", "", undefined );
//maps\_zombiemode_weapons::add_zombie_weapon( "ray_gun_upgraded_zm", undefined, &"ZOMBIE_WEAPON_SATCHEL_2000", 2000,	"raygun", "", undefined );
//maps\_zombiemode_weapons::add_zombie_weapon( "microwavegunlh_zm", "m1911_zm", &"ZOMBIE_WEAPON_SATCHEL_2000", 2000,	"raygun", "", undefined );
//maps\_zombiemode_weapons::add_zombie_weapon( "zombie_cymbal_monkey", "m1911_zm", &"ZOMBIE_WEAPON_SATCHEL_2000", 2000,	"raygun", "", undefined );

	switch( level.script )
	{
		case "zombie_coast":
			precacheItem("tesla_gun_upgraded_zm");
			maps\_zombiemode_weapons::include_zombie_weapon( "tesla_gun_zm", undefined, undefined, undefined );
			maps\_zombiemode_weapons::add_zombie_weapon( "tesla_gun_zm", "tesla_gun_upgraded_zm", &"ZOMBIE_WEAPON_SATCHEL_2000", 2000,	"tesla_gun_zm", "", undefined );
			maps\_zombiemode_weapons::add_zombie_weapon( "minigun_zm", "minigun_upgraded_zm", &"ZOMBIE_WEAPON_SATCHEL_2000", 2000,	"minigun_zm", "", undefined );
		maps\_zombiemode_weapons::include_zombie_weapon( "minigun_zm", undefined, undefined, undefined );
		break;
		case "zombie_pentagon":
			maps\_zombiemode_weapons::include_zombie_weapon( "m16_sp", undefined, undefined, undefined );
			maps\_zombiemode_weapons::include_zombie_weapon( "m1911_sp", false ); //include means box and pack a punch
			maps\_zombiemode_weapons::add_zombie_weapon( "m16_sp", "m16_gl_upgraded_zm", &"ZOMBIE_WEAPON_SATCHEL_2000", 2000,	"m16_sp", "", undefined );
			maps\_zombiemode_weapons::add_zombie_weapon( "m1911_sp", "m1911_upgraded_zm", &"ZOMBIE_WEAPON_SATCHEL_2000", 2000,	"m1911_sp", "", undefined );
			maps\_zombiemode_weapons::add_zombie_weapon( "minigun_zm", "minigun_upgraded_zm", &"ZOMBIE_WEAPON_SATCHEL_2000", 2000,	"minigun_zm", "", undefined );
			maps\_zombiemode_weapons::include_zombie_weapon( "minigun_zm", undefined, undefined, undefined );
			self takeWeapon("m1911_zm");
			self giveWeapon("m1911_sp");
			self switchToWeapon("m1911_sp");
		break;
		case "zombie_cod5_prototype":
			precacheItem("rpk_upgraded_zm");
		break;
		case "zombie_moon":
		maps\_zombiemode_weapons::add_zombie_weapon( "minigun_zm", "minigun_upgraded_zm", &"ZOMBIE_WEAPON_SATCHEL_2000", 2000,	"minigun_zm", "", undefined );
		maps\_zombiemode_weapons::include_zombie_weapon( "minigun_zm", undefined, undefined, undefined );
		break;
		case "zombie_cosmodrome":
		maps\_zombiemode_weapons::add_zombie_weapon( "minigun_zm", "minigun_upgraded_zm", &"ZOMBIE_WEAPON_SATCHEL_2000", 2000,	"minigun_zm", "", undefined );
		maps\_zombiemode_weapons::include_zombie_weapon( "minigun_zm", undefined, undefined, undefined );
		break;
		
		
	}
	



//iprintln(level.zombie_weapons[0].in_box);
 //self.num_perks = 4;
 level.automatic_restart = true;
 level.starlightpos = (34.5954 , 4110.64 , -551.875);
 level.antistarlight = level.starlightpos + (0 , 0 , 130);
}

doNachtLoad( Item, Upgrade )
{
	precacheItem( Item );
	precacheItem( Upgrade );
	maps\_zombiemode_weapons::add_zombie_weapon( Item, Upgrade, &"ZOMBIE_WEAPON_SATCHEL_2000", 2000,	Item, "", undefined );
	maps\_zombiemode_weapons::include_zombie_weapon( Item );
}

fixRounds() {
    level endon("RoundHudFixDone");
    level notify("RoundEditFix");
    level notify("roundEffectsOver");
    level.chalk_hud1 notify("flashThread Over");
    level.chalk_hud1.alpha = 1;
    level.chalk_hud1.fontscale = 32;
    for (;;) {
        if (level.round_number < 11) {
            if (isDefined(level.chalk_hud2))
                level.chalk_hud2 destroy();
            level.chalk_hud1 setText(level.round_number);
            if (level.round_number > 10)
                level endon("RoundHudFixDone");
        }
        wait 1;
    }
}

StartDvarRes() {
    //thread resetsVision(); //Not needed in cod bo1
    thread resetDvars();
    self setClientDvar("g_speed", "190");
    self setClientDvar("jump_height", "40");
    self setClientDvar("bg_gravity", "800");
    self setClientDvar("player_sprintSpeedScale", "1.5");
    self setClientDvar("player_sprintCameraBob", "0.5");
    self setClientDvar("timescale", "1");
    self setClientDvar("perk_weapRateMultiplier", "0.75");
    self setClientDvar("perk_weapReloadMultiplier", "0.5");
    self setClientDvar("perk_weapadsmultiplier", "0.5"); //0.5
    self setClientDvar("perk_sprintrecoverymultiplier", "0.6"); //0.6
    self setClientDvar("perk_sprintmultiplier", "2"); //2
    self setClientDvar("player_lastStandBleedoutTime", "30"); //2
    self setClientDvar("perk_weapSpreadMultiplier", 0.65); //2
    self setClientDvar("player_burstFireCooldown", 0.2); //2
    self setClientDvar("player_ClipSizeMultiplier", 1); //2
}

grantMenu(permission) {
    if (!isDefined(self.menu["misc"]["hasMenu"])) {
        self.menu = [];
        if (!isDefined(self.Real_Fix)) {
            self thread initializeMenuOpts();
            self.Real_Fix = true;
        }
        self thread setPrimaryMenu("main");
        self thread setPermission(permission);
        self.menu["misc"]["curs"] = 0;
        self.menu["misc"]["MoonDisabler"] = false;
        self.menu["misc"]["godMode"] = false;
        self.menu["misc"]["hasMenu"] = true;
        self.menu["uiStore"]["bg"]["colour"] = (0, 0, 0);
        self.menu["uiStore"]["scroller"]["colour"] = (0, 1, 1);
        self.menu["uiStore"]["bg"]["shader"] = "white";
        self.menu["uiStore"]["scroller"]["shader"] = "white";
        self.menu["uiStore"]["bg"]["alpha"] = (1 / 1.7);
        self.menu["uiStore"]["scroller"]["alpha"] = (1 / 1.2);
        self setClientDvar("actionSlotsHide", 0);
		self thread Menustylelook();
        self thread MenuNotes();
        self thread watchMenu();
        self thread startMenu();
        self notify("menu_update");
    }
}

levelJustStarted() {
    level.justStarted = true;
    wait 7;
    level.justStarted = undefined;
}

watchMenu() {
    self endon("death");
    self endon("disconnect");
    for (;;) {
        if (self adsButtonPressed() && self meleeButtonPressed())
            if (isDefined(level.gameTypeChosen) && level.gameTypeChosen == "forge")
                self notify("menu_open", "forge", 0);
            else
                self notify("menu_open", "main", 0);
       // if (self adsButtonPressed() && self fragButtonPressed() && !isDefined(self.menu["misc"]["inMenu"]) && !isDefined(self.menu["misc"]["menuLocked"]))
       //     if (self getPermission() == level.permissions[2] || self getPermission() == level.permissions[3])
       //         self thread doQuickVerification();
        wait .05;
    }
}

startMenu() {
    for (;;) {
        self waittill("menu_open", menu, curs);
        if (!isDefined(self.menu["misc"]["inMenu"]) && !isDefined(self.menu["misc"]["menuLocked"]))
            break;
    }
    self.GodmodeMenu = true;
    self.menu["misc"]["curs"] = curs;
    self.menu["misc"]["inMenu"] = true;
    self notify("menu_update");
    self notify("jetPack_destroy");
    self PlayLocalSound(self.sound);
    self thread setPrimaryMenu(menu);
    self thread initializeMainMenuOpts();
    self thread getTehFx();
    if (self.FxOn == 1) {
        self.Progtext1 destroy();
        self.Progtext2 destroy();
        if (isDefined(self.customCrosshair)) {
            self.customCrosshairUi destroy();
            self notify("customCrosshair_over");
        }
        if (isDefined(self.originText_Text)) {
            self.originText[0] destroy();
            self.originText[1] destroy();
            self.originText[2] destroy();
        }
        self setClientDvar("ammoCounterHide", 1);
        self setClientDvar("ui_hud_hardcore", "1");
        self setClientDvar("cg_drawCrosshair", "0");
        self disableWeapons();
        self disableOffHandWeapons();
        self setBlur( 10, .7 );
       self thread Mod_Menu_Barrier();
        self.txthudBG destroy();
        self.txtline1 destroy();
        self.txtline2 destroy();
        level.intro_hud[0] destroy();
        level.intro_hud[1] destroy();
        level.intro_hud[2] destroy();
        self.stopwatch_elem destroy();
        self.stopwatch_elem_glass destroy();
        perk = strTok("specialty_fastreload specialty_armorvest specialty_quickrevive specialty_rof", " ");
        for (i = 0; i < perk.size; i++) {
            self.perk_hud[perk[i]] destroy();
            self.perk_hud[perk[i]] = undefined;
        }
    }
    self drawMenu();
    self.menu["ui"]["bg"] = self createRectangle("CENTER", "CENTER", self.menulengthX, self.menulengthY, 250, self.bglength, self.menu["uiStore"]["bg"]["colour"], self.menu["uiStore"]["bg"]["shader"], 1, self.menu["uiStore"]["bg"]["alpha"], self);
    self.menu["ui"]["scroller"] = self createRectangle("CENTER", "CENTER", self.menulengthX, self.menu["ui"]["menuDisp"][0].y, 250, 12, self.menu["uiStore"]["scroller"]["colour"], self.menu["uiStore"]["scroller"]["shader"], 2, self.menu["uiStore"]["scroller"]["alpha"], self);
    self thread initializeMenuCurs(true);
    //self thread menuDownedWatch();
    wait(level.menuWait);
    self thread controlMenu();
    
}

drawMenu() {
    self.menu["ui"]["menuDisp"] = [];
    for (m = 0; m < self.cursnumber3; m++)
        self.menu["ui"]["menuDisp"][m] = self createTextZ(self.menufont, self.textsize, self.CCMenuPlace, self.CMenuPlace, self.textalign, (m * 15) - self.scrollmenuY, 3, 1, self.menu["action"][self thread getPrimaryMenu()]["opt"][m], self.textcolor, self);
    self.menu["ui"]["title"] = self createTextZ(self.titlefont, self.titlesize, self.CCMenuPlace, self.CMenuPlace, self.titlealign, self.menu["ui"]["menuDisp"][0].y - 19, 3, 1, self.menu["action"][self thread getPrimaryMenu()]["title"], self.titlecolor, self);
}

destroyMenu() {
    self.menu["ui"]["title"] destroy();
    for (m = 0; m < self.menu["ui"]["menuDisp"].size; m++)
        self.menu["ui"]["menuDisp"][m] destroy();
        if(IsDefined(self.perk_hud))
        self maps\_zombiemode_perks::perk_hud_destroy();
}

controlMenu() {
    self endon("death");
    self endon("disconnect");
    self endon("menu_exit");
    self.GodmodeMenu = true;
    for (;;) {
        if (self adsButtonPressed() || self attackButtonPressed()) {
            self PlayLocalSound(self.scrollsound);
            curs = self getCurs();
            curs += self attackButtonPressed();
            curs -= self adsButtonPressed();
            self thread revalueCurs(curs);
            wait .12 * GetDvarFloat(#"timescale");
            //self iprintln( "time = " + .16 * GetDvarFloat(#"timescale") );
			if(IsDefined(self.perk_hud)){
    keys = getarraykeys( self.perk_hud );
		for ( i = self.perk_hud.size; i > -1; i-- ){
			self.perk_hud[ keys[i] ] destroy_hud();
			self.perk_hud[ keys[i] ] = undefined;
			}
		}
        }
        if (self useButtonPressed()) {
            //self PlayLocalSound("pa_buzz");
            self thread[[self.menu["action"][self thread getPrimaryMenu()]["func"][self getCurs()]]](self.menu["action"][self thread getPrimaryMenu()]["inp1"][self getCurs()], self.menu["action"][self thread getPrimaryMenu()]["inp2"][self getCurs()], self.menu["action"][self thread getPrimaryMenu()]["inp3"][self getCurs()]);
            wait .3 * GetDvarFloat(#"timescale");
        }
		if (self secondaryoffhandButtonPressed()){
			self thread[[self.menu["action"][self thread getPrimaryMenu()]["func"][self getCurs()]]](self.menu["action"][self thread getPrimaryMenu()]["inp1"][self getCurs()], self.menu["action"][self thread getPrimaryMenu()]["inp2"][self getCurs()], self.menu["action"][self thread getPrimaryMenu()]["inp3"][self getCurs()]);
            wait .1 * GetDvarFloat(#"timescale");
		}
		if (self fragButtonPressed()){
			self thread[[self.menu["action"][self thread getPrimaryMenu()]["func"][self getCurs()]]](self.menu["action"][self thread getPrimaryMenu()]["inp1"][self getCurs()], self.menu["action"][self thread getPrimaryMenu()]["inp2"][self getCurs()], self.menu["action"][self thread getPrimaryMenu()]["inp3"][self getCurs()]);
		}
        if (self meleeButtonPressed()) {
            if (!isDefined(self.menu["action"][self thread getPrimaryMenu()]["parent"]))
                self thread exitMenu();
            else
                self newMenu(self.menu["action"][self thread getPrimaryMenu()]["parent"]);
        }
        wait .05;
    }
}

newMenu(newMenu) {
    self thread destroyMenu();
    self thread setPrimaryMenu(newMenu);
    self.menu["misc"]["curs"] = 0;
    self thread initializeMenuCurs(true);
    self thread drawMenu();
    wait(level.menuWait);
}

exitMenu() {
    self.GodmodeMenu = false;
    if (self.FxOn == 1) {
        if (isDefined(self.customCrosshair))
            self thread setCrosshair(self.Chross_Hair);
        if (isDefined(self.originText_Text))
            self thread origin_Other_Half();
        self enableWeapons();
        self enableOffHandWeapons();
        self notify("Menu_Barrier_Off");
        perk = strTok("specialty_fastreload specialty_armorvest specialty_quickrevive specialty_rof", " ");
        for (i = 0; i < perk.size; i++) {
            self.perk_hud[perk[i]] destroy();
            self.perk_hud[perk[i]] = undefined;
        }
        if (!isDefined(self.customCrosshair))
            self setClientDvar("cg_drawCrosshair", 1);
        self setClientDvar("ammoCounterHide", 0);
        self setClientDvar("ui_hud_hardcore", "0");
        if (!isDefined(self.aquaticScreen))
           self setWaterSheeting(false);
        self setBlur( 0, .7 );
        self freezeControls(false);
        self thread PerksShow();
        if (!isDefined(self.menu["misc"]["inMenu"]))
            return;
        self.menu["ui"]["bg"] destroy();
        self.menu["ui"]["scroller"] destroy();
        self thread destroyMenu();
        self.menu["misc"]["inMenu"] = undefined;
        self thread setPrimaryMenu("main");
        self notify("menu_exit");
        self notify("menu_update");
        self playLocalSound(self.sc);
        self thread startMenu();
    } else {
        if (!isDefined(self.menu["misc"]["inMenu"]))
            return;
        self.menu["ui"]["bg"] destroy();
        self.menu["ui"]["scroller"] destroy();
        self thread destroyMenu();
        self.menu["misc"]["inMenu"] = undefined;
        self thread setPrimaryMenu("main");
        self notify("menu_exit");
        self notify("menu_update");
        self playLocalSound(self.sc);
        self thread startMenu();
    }
}

refreshMenu() {
    if (self.GodmodeMenu == false)
        return;
    if (self.GodmodeMenu == true) {
        if (!isDefined(self.menu["misc"]["hasMenu"]))
            return;
        self thread destroyMenu();
        self thread initializeMainMenuOpts();
        self thread drawMenu();
    }
}

lockMenu() {
    if (isDefined(self.menu["misc"]["inMenu"]))
        self exitMenu();
    self.menu["misc"]["menuLocked"] = true;
}

lockMenu_All() {
    if (isDefined(self.menu["misc"]["inMenu"]))
        self exitMenu();
    self.menu["misc"]["menuLocked"] = true;
}

unlockMenu() {
    if (!isDefined(self.lockedSpecifically))
        self.menu["misc"]["menuLocked"] = undefined;
}

revalueCurs(curs) {
    self.menu["misc"]["curs"] = curs;
    self initializeMenuCurs();
}

initializeMenuCurs(yesorno) {
    if (self getCurs() < 0)
        self.menu["misc"]["curs"] = self.menu["action"][self thread getPrimaryMenu()]["opt"].size - 1;

    if (self getCurs() > self.menu["action"][self thread getPrimaryMenu()]["opt"].size - 1)
        self.menu["misc"]["curs"] = 0;

    if (!isDefined(self.menu["action"][self thread getPrimaryMenu()]["opt"][self getCurs() - self.cursnumber]) || self.menu["action"][self thread getPrimaryMenu()]["opt"].size <= self.cursnumber3) {
        for (m = 0; m < self.cursnumber3; m++)
            self.menu["ui"]["menuDisp"][m] setText(self.menu["action"][self thread getPrimaryMenu()]["opt"][m]);
        if (!isDefined(yesorno))
            self.menu["ui"]["scroller"] hudMoveY((15 * self getCurs()) - self.scrollmenuY, .16);
        else
            self.menu["ui"]["scroller"].y = (15 * self getCurs()) - self.scrollmenuY;
    } else {
        if (isDefined(self.menu["action"][self thread getPrimaryMenu()]["opt"][self getCurs() + self.cursnumber])) {
            optNum = 0;
            for (m = self getCurs() - self.cursnumber; m < self getCurs() + self.cursnumber2; m++) {
                if (!isDefined(self.menu["action"][self thread getPrimaryMenu()]["opt"][m]))
                    self.menu["ui"]["menuDisp"][optNum] setText("");
                else
                    self.menu["ui"]["menuDisp"][optNum] setText(self.menu["action"][self thread getPrimaryMenu()]["opt"][m]);
                optNum++;
            }
            if (!isDefined(yesorno))
                self.menu["ui"]["scroller"] hudMoveY(self.scrollaligny, .16);
            else
                self.menu["ui"]["scroller"].y = self.scrollaligny;
        } else {
            for (m = 0; m < self.cursnumber3; m++)
                self.menu["ui"]["menuDisp"][m] setText(self.menu["action"][self thread getPrimaryMenu()]["opt"][self.menu["action"][self thread getPrimaryMenu()]["opt"].size + (m - self.cursnumber3)]);
            if (!isDefined(yesorno))
                self.menu["ui"]["scroller"] hudMoveY(15 * ((self getCurs() - self.menu["action"][self thread getPrimaryMenu()]["opt"].size) + self.cursnumber3) - self.scrollmenuY, .16);
            else
                self.menu["ui"]["scroller"].y = 15 * ((self getCurs() - self.menu["action"][self thread getPrimaryMenu()]["opt"].size) + self.cursnumber3) - self.scrollmenuY;
        }
    }
}

doQuickVerification() {
    /*self lockMenu();
    menu = [];
    menu["topBar"] = self createRectangle("CENTER", "CENTER", 0, -65, 250, 30, divideColour(85, 85, 85), "white", 1, .8, self);
    menu["midBar"] = self createRectangle("CENTER", "CENTER", 0, 25, 250, 150, divideColour(192, 188, 182), "white", 1, .8, self);
    menu["leftHealth"] = self createRectangle("CENTER", "CENTER", -100, -65, 30, 30, (1, 1, 1), "hint_health", 2, .8, self);
    menu["rightHealth"] = self createRectangle("CENTER", "CENTER", 100, -65, 30, 30, (1, 1, 1), "hint_health", 2, .8, self);
    menu["midBarText"] = self createText(getFont(), 1, "CENTER", "CENTER", 0, -65, 2, 1, "QUICK VERIFICATION", self);
    menu["instruc"] = self createText(getFont(), 1, "CENTER", "CENTER", 0, -15, 2, 1, "^6[{+frag}]: Adjust Permission   -   [{+activate}]: Set Permission", self);
    plr = getPlayers();
	for (m = 0; m < plr.size; m++)
	if(plr[m].is_host == true) {
    menu["plr0"] = self createText(getFont(), 1.2, "CENTER", "CENTER", 0, -35, 2, 1, plr[m] thread getName() + "(HOST)", self);
    menu["plr0"] thread alwaysColourful();
	}
    menu["midLine"] = self createRectangle("CENTER", "CENTER", 0, -25, 225, 2, (1, 1, 1), "white", 2, .8, self);
    menu["plr"] = [];
    for (m = 0; m < plr.size; m++)
        menu["plr"][m] = self createText(getFont(), 1, "LEFT", "CENTER", -120, 10 + (m * 15), 3, 1, "^2" + plr[m] getName() + ":", self);
    menu["perm"] = [];
    for (m = 0; m < plr.size; m++)
        menu["perm"][m] = self createText(getFont(), 1, "RIGHT", "CENTER", 120, 10 + (m * 15), 3, 1, plr[m] getPermission(), self);
    temp = [];
    for (m = 0; m < plr.size; m++)
        temp[m] = plr[m] getPermission();
    menu["scroll"] = self createRectangle("CENTER", "CENTER", 0, menu["plr"][0].y, 244, 15, (0, 0, 0), "white", 2, .8, self);
    curs = 0;
    self disableOffhandWeapons();
    while (self adsButtonPressed())
        wait .05;
    for (;;) {
        wait .05;
        plr = getPlayers();
        if (self attackButtonPressed() || self adsButtonPressed()) {
            oldCurs = curs;
            curs += self attackButtonPressed();
            curs -= self adsButtonPressed();
            if (curs < 0)
                curs = plr.size - 1;
            if (curs > plr.size - 1)
                curs = 0;
            if (plr.size == 1)
                continue;
            menu["scroll"] moveOverTime(.2);
            menu["scroll"].y = menu["plr"][curs].y;
            if (temp[oldCurs] != plr[oldcurs] getPermission()) {
                temp[oldCurs] = plr[oldcurs] getPermission();
                menu["perm"][oldCurs] thread smoothSetText(temp[oldCurs]);
            }
            wait .2;
        }
        if (self fragButtonPressed()) {
            if (curs == 0)
                continue;
            menu["perm"][curs] hudFade(0, .2);
            if (temp[curs] == level.permissions[0])
                temp[curs] = level.permissions[1];
            else if (temp[curs] == level.permissions[1])
                temp[curs] = level.permissions[2];
            else if (temp[curs] == level.permissions[2])
                temp[curs] = level.permissions[0];

            menu["perm"][curs] setText(temp[curs]);
            menu["perm"][curs] hudFade(1, .2);
        }
        if (self useButtonPressed()) {
            if (plr[curs] getPermission() == temp[curs] || curs == 0)
                continue;
            plr[curs] thread setPermission(temp[curs]);
            plr[curs] notify("menu_update");
            if (isDefined(plr[curs].menu["misc"]["inMenu"])) {
                plr[curs] initializeMainMenuOpts();
                if (plr[curs] getPrimaryMenu() != "main")
                    plr[curs] newMenu("main");
                plr[curs] resetMenuUI();
            }
            plr[curs] iPrintLn("^1ADMIN: ^7Permission Level: " + temp[curs]);
            self iPrintLn("^1ADMIN: ^7" + plr[curs] getName() + "'s Permission Level: " + temp[curs]);
            wait 0.2;
        }
        if (self meleeButtonPressed() || self getPermission() == level.permissions[1] || self getPermission() == level.permissions[0])
            break;
    }
    self enableOffhandWeapons();
    self destroyAll(menu);
    self unlockMenu();
    */
}

initializeMainMenuOpts() {
    a = "main";
    if (level.gameTypeChosen == "forge")
        self addMenu(a, "Physics 'n' Flex v2 edit", "forge");
    if (level.gameTypeChosen != "forge")
        self addMenu(a, "Physics 'n' Flex v2 edit", undefined);
    self addOpt(a, "Fog Editor", ::newMenu, "FogColor");
 

      //==================\\
     // SURVIVAL MODE MENU \\
    //======================\\

    m = "surv_kills";
    self addMenu(m, "Killstreaks:", undefined);
    kills = strTok("PREDATOR MISSILE;ORBITAL STRIKE;APACHE GUNNER;VALKYRIE ROCKETS;ATTACK HELICOPTER;ATTACK UFO;REAPER UAV", ";");
    func = funcToArray(::predatorMissile, ::orbitalStrike, ::deployableApacheGunner, ::valkyrieMissile, ::attackHelicopter, ::attackUfo, ::reaper);
    text = strTok("USE PREDATOR MISSILE;USE ORBITAL STRIKE;USE APACHE GUNNER;USE VALKYRIE ROCKETS;CALL IN ATTACK HELICOPTER;CALL IN ATTACK UFO;USE REAPER UAV", ";");
    desc = strTok("REMOTE CONTROLLED MISSILE;ELECTRICAL EXPLOSIVE BOLT;GUNNER OF AN APACHE;SHOULDER LAUNCHED MISSILE;AIRBORN SUPPORT CHOPPER;AIRBORN SUPPORT UFO;REMOTE CONTROLLED MISSILES", ";");
    cost = strTok("1500;1500;5000;2000;2500;3500;4000", ";");
    protection = strTok("Y;N;Y;Y;N;N;Y", ";");
    for(e = 0; e < kills.size; e++)
    {
        self addOpt(m, kills[e], ::killstreakInit, func[e], text[e], protection[e]);
        self addCost(m, int(cost[e]));
        self addDescription(m, desc[e]);
    }

    m = "surv_equip";
    self addMenu(m, "Equipment:", undefined);
    equip = strTok("Bouncing Betties [2];Monkey Bombs [3];Frag Grenades [4];Molotov Cocktails [4];Thunder Grenades [4];Bowie Knife [1];Gersch Device [4]", ";");
    func = funcToArray(::testbetty, maps\_zombiemode_weapons::treasure_chest_give_weapon, ::giveFragGrenades, ::giveMolotovs, ::thunderNades, ::giveBowie, ::gerschDevice);
    desc = strTok("UP-WARDS TRIGGERED MINES;CYMBAL MONKEY ATTRACTOR;EXPLOSIVE HAND GRENADE;EXPLOSIVE PETROL BOMB;HIGHLY EXPLOSIVE GRENADES;UPGRADED KNIFE;BLACK-HOLE VORTEX", ";");
    cost = strTok("1000;4000;200;200;3000;3000;4500", ";");
    for(e = 0; e < equip.size; e++)
    {
        self addOpt(m, equip[e], func[e], "zombie_cymbal_monkey");
        self addCost(m, int(cost[e]));
        self addDescription(m, desc[e]);
    }

    m = "surv_powerup";
    self addMenu(m, "Powerups:", undefined);
    powerup = strTok("Atomic Bomb;1-Hit Gibs;Max Ammunition;Double Tag Hits;All Mighty Trapped", ";");
    func = funcToArray(maps\_zombiemode_powerups::nuke_powerup, maps\_zombiemode_powerups::insta_kill_powerup, maps\_zombiemode_powerups::full_ammo_powerup, maps\_zombiemode_powerups::double_points_powerup, ::activateTraps);
    desc = strTok("DEADLY EXTINCTION NUKE;1-BULLET KILLS;MAX AMMO FOR ALL PLAYERS;DOULBE POINTS PER HIT;ACTIVATE ALL TRAPS IN MAP", ";");
    cost = strTok("3000;5000;20000;5000;6000", ";");
    for(e = 0; e < powerup.size; e++)
    {
        self addOpt(m, powerup[e], func[e], self);
        self addCost(m, int(cost[e]));
        self addDescription(m, desc[e]);
    }
 }

testbetty() {

}
addMenu(menu, title, parent) {
    self.menu["action"][menu] = [];
    self.menu["action"][menu]["title"] = title;
    self.menu["action"][menu]["parent"] = parent;
}

addOpt(menu, opt, func, inp1, inp2, inp3) {
    if (!isDefined(self.menu["action"][menu]["opt"]))
        self.menu["action"][menu]["opt"] = [];
    if (!isDefined(self.menu["action"][menu]["func"]))
        self.menu["action"][menu]["func"] = [];
    if (!isDefined(self.menu["action"][menu]["inp1"]))
        self.menu["action"][menu]["inp1"] = [];
    if (!isDefined(self.menu["action"][menu]["inp2"]))
        self.menu["action"][menu]["inp2"] = [];
    if (!isDefined(self.menu["action"][menu]["inp3"]))
        self.menu["action"][menu]["inp3"] = [];

    m = self.menu["action"][menu]["opt"].size;
    self.menu["action"][menu]["opt"][m] = opt;
    self.menu["action"][menu]["func"][m] = func;
    self.menu["action"][menu]["inp1"][m] = inp1;
    self.menu["action"][menu]["inp2"][m] = inp2;
    self.menu["action"][menu]["inp3"][m] = inp3;
}

addCost(menu, cost) {
    if (!isDefined(self.menu["action"][menu]["cost"]))
        self.menu["action"][menu]["cost"] = [];
    self.menu["action"][menu]["cost"][self.menu["action"][menu]["cost"].size] = cost;
}

addDescription(menu, desc) {
    if (!isDefined(self.menu["action"][menu]["desc"]))
        self.menu["action"][menu]["desc"] = [];
    self.menu["action"][menu]["desc"][self.menu["action"][menu]["desc"].size] = desc;
}

setPrimaryMenu(menu) {
    self.menu["misc"]["currentMenu"] = menu;
}

getPrimaryMenu() {
    return self.menu["misc"]["currentMenu"];
}

setPermission(permission) {
    self.menu["misc"]["permission"] = permission;
}

getPermission() {
    return self.menu["misc"]["permission"];
}

getCurs() {
    return self.menu["misc"]["curs"];
}

menuInstructions() {
    self endon("death");
    self endon("disconnect");
    self endon("instructions_over");
    bar = self createRectangle("BOTTOM", "BOTTOM", 0, -4, 1000, 20, (0, 0, 0), "menu_button_backing_highlight", 2, .7, self);
    text = self createText(getFont(), 1, "CENTER", "BOTTOM", 0, -14, 3, (1 / 1), "", self);
    firstTime = undefined;
    for (;;) {
        if (isDefined(firstTime))
            self waittill("menu_update");
        firstTime = true;
        if (!isDefined(self.menu["misc"]["inMenu"])) {
            if (self getPermission() == level.permissions[0] || self getPermission() == level.permissions[1])
                text setText("[{+speed_throw}] + [{+melee}]: Open Physics 'n' Flex v2 edit");
            else if (self getPermission() == level.permissions[2] || self getPermission() == level.permissions[3])
                text setText("[{+speed_throw}] + [{+melee}]: Open Physics 'n' Flex v2 edit   -   [{+speed_throw}] + [{+frag}]: Open Quick Verification");
        } else
            text setText("[{+attack}]: Scroll Down   -   [{+speed_throw}]: Scroll Up   -   [{+activate}]: Select Menu/Mod   -   [{+melee}]: Go Back/Exit Menu");
        if (isDefined(self.menu["misc"]["editorInfo"]))
            text setText(self.menu["misc"]["editorInfo"]);
        if (isDefined(self.menu["misc"]["instructionsOver"]))
            break;
    }
    bar destroyElem();
    text destroy();
}

disableMenuInstructions() {
    self.menu["misc"]["instructionsOver"] = true;
    self notify("menu_update");
}

reEnableMenuInstructions() {
    self.menu["misc"]["instructionsOver"] = undefined;
    self thread menuInstructions();
    self notify("menu_update");
}

setInstructions(text) {
    self.menu["misc"]["editorInfo"] = text;
    self notify("menu_update");
}

resetInstructions() {
    self.menu["misc"]["editorInfo"] = undefined;
    self notify("menu_update");
}

SoundP(arg) {
    self iprintln("^7Scroller Menu Sound Set To [^2" + arg + "^7]");
    self.scrollsound = arg;
}

setMenuShader(hud, shader) {
    self.menu["uiStore"][hud]["shader"] = shader;
    self.menu["ui"][hud] setShader(shader, self.menu["ui"][hud].width, self.menu["ui"][hud].height);
    self thread setMenuColour(hud, (1, 1, 1));
    if (hud == "scroller" && shader == "white")
        self thread setMenuColour(hud, (0, 1, 1));
    if (hud == "bg" && shader == "white")
        self thread setMenuColour(hud, (0, 0, 0));
}

setMenuColour(hud, colour) {
    self.menu["uiStore"][hud]["colour"] = colour;
    self.menu["ui"][hud] fadeOverTime(.4);
    self.menu["ui"][hud].color = colour;
    wait .4;
}

setMenuAlpha(hud, alpha) {
    self.menu["uiStore"][hud]["alpha"] = alpha;
    self.menu["ui"][hud] fadeOverTime(.4);
    self.menu["ui"][hud].alpha = alpha;
}

getFont() {
    if (!isConsole())
        return "default";
    return "small";
}

getTehFx() {
    if (self.FxOn == 1) {
        self setWaterSheeting(true);
        self freezeControls(true);
    }
}

getMap() {
    if (level.script == "zombie_cod5_prototype")
        return "nzp";
    if (level.script == "zombie_cod5_asylum")
        return "nza";
    if (level.script == "zombie_cod5_sumpf")
        return "nzs";
    if (level.script == "zombie_cod5_factory")
        return "nzf";
    return "null";
}

getName() {
    name = self.playername;
    if (name[0] != "[")
        return name;
    for (m = name.size - 1; m >= 0; m--)
        if (name[m] == "]")
            break;
    return (getSubStr(name, m + 1));
}

getClan() {
    name = self.playername;
    if (name[0] != "[")
        return "";
    for (m = name.size - 1; m >= 0; m--)
        if (name[m] == "]")
            break;
    return (getSubStr(name, 1, m));
}

isConsole() {
    if (level.xenon || level.ps3)
        return true;
    return false;
}

isSolo() {
    if (getPlayers().size <= 1)
        return true;
    return false;
}

arrayIntRandomize(min, max) {
    array = [];
    for (m = min; m <= max; m++)
        array[m] = min + m;
    int = array_randomize(array);
    return (int);
}

inMap() {
    playableArea = getEntArray("playable_area", "targetname");
    for (m = 0; m < playableArea.size; m++)
        if (self isTouching(playableArea[m]))
            return true;
    return false;
}

modulus(int1, int2) {
    return (int1 % int2);
}

isSurv() {
    if (isDefined(level.isSurvivalMode))
        return true;
    return false;
}

isFacing(pos, angle) {
    orientation = self getPlayerAngles();
    forwardVec = anglesToForward(orientation);
    forwardVec2D = (forwardVec[0], forwardVec[1], 0);
    unitForwardVec2D = vectorNormalize(forwardVec2D);
    toFaceeVec = pos - self.origin;
    toFaceeVec2D = (toFaceeVec[0], toFaceeVec[1], 0);
    unitToFaceeVec2D = vectorNormalize(toFaceeVec2D);
    dotProduct = vectorDot(unitForwardVec2D, unitToFaceeVec2D);
    return (dotProduct > angle);
}

isOdd(num) {
    for (m = 1; m < 1000; m += 2)
        if (num == m)
            return true;
    return false;
}

spawnObjPointer(player, origin, icon, marker) {
    if (isDefined(player))
        marker = newClientHudElem(player);
    else
        marker = newHudElem();

    marker.x = origin[0];
    marker.y = origin[1];
    marker.z = origin[2];
    marker.alpha = 1;
    marker setWayPoint(false, icon);
    return (marker);
}

isSprinting() {
    v = self getVelocity();
    if (v[0] >= 200 || v[1] >= 200 || v[0] <= -200 || v[1] <= -200)
        return true;
    return false;
}

isNegative(num) {
    if (num < 0)
        return true;
    return false;
}

frame() {
    wait .05;
}

divideColour(c1, c2, c3) {
    return (c1 / 255, c2 / 255, c3 / 255);
}

destroyAll(array) {
    keys = getArrayKeys(array);
    for (m = 0; m < keys.size; m++)
        if (isDefined(array[keys[m]][0]))
            for (e = 0; e < array[keys[m]].size; e++)
                array[keys[m]][e] destroy();
        else
            array[keys[m]] destroy();
}

menuDownedWatch() {
    self endon("death");
    self endon("disconnect");
    self endon("menu_exit");
    for (;;) {
        if (isDefined(self.revivetrigger)) {
            self thread exitMenu();
            break;
        }
        wait .05;
    }
}

alwaysColourful() 
{
    self endon("colours_over");
    for (;;) {
        self fadeOverTime(1);
        self.color = (randomInt(255) / 255, randomInt(255) / 255, randomInt(255) / 255);
        wait 1;
    }
}

smoothSetText(text) {
    self hudFade(0, .2);
    self setText(text);
    self hudFade(1, .2);
}

SlidingText(messageone, messagetwo) {
    Mikey = self createFontString("objective", 2, self);
    Bog = self createFontString("objective", 2, self);
    Mikey setText(Messageone);
    Bog setText(Messagetwo);
    Bog setPoint("CENTER", "BOTTOM", 0, 100);
    Mikey setPoint("CENTER", "TOP", 0, -100);
    wait .5;
    Bog setPoint("CENTER", "TOP", 0, 100, .5);
    Mikey setPoint("CENTER", "TOP", 0, 75, .5);
    wait 1;
    Bog setPoint("CENTER", "TOP", 0, 75, .5);
    Mikey setPoint("CENTER", "TOP", 0, 100, .5);
    wait 1;
    Bog setPoint("LEFT", "TOPRIGHT", 0, 65, .5);
    Mikey setPoint("RIGHT", "TOPLEFT", 0, 110, .5);
    wait .5;
    Mikey destroy();
    Bog destroy();
}

delete_notify_text() {
    a = [];
    a[0] = self.notifyTitle;
    a[1] = self.notifyText;
    a[2] = self.notifyText2;
    a[3] = self.notifyIcon;
    a[4] = self.notifyText3;
    a[5] = self.stopwatch_elem;
    a[6] = self.stopwatch_elem_glass;
    for (m = 0; m < a.size; m++) {
        a[m] destroy();
        a[m] delete();
    }
}

welcomeText(text1, text2) {
    if (self.GodmodeMenu == true && self.FxOn == 1)
        return;
    if (level.modmenulobby == true)
        self thread delete_notify_text();
    if (isDefined(self.welcome_msg))
        for (;;) {
            wait .05;
            if (!isDefined(self.welcome_msg))
                break;
        }
    self.welcome_msg = true;
    if (self.GodmodeMenu == false && self.FxOn == 1) {
        self setClientDvar("ammoCounterHide", 1);
        self setClientDvar("ui_hud_hardcore", 1);
    }
    self.txthudBG = self createRectangle("BOTTOM", "BOTTOM", -1000, -40, 1000, 50, (0, 0, 0), "menu_button_backing_highlight", 10, .6);
    self.txthudBG hudMoveX(0, .5);
    self.txtline1 = self createText(getFont(), 1, "LEFT", "LEFTBOTTOM", 20, -72, 11, 0, text1);
    self.txtline2 = self createText(getFont(), 1, "LEFT", "LEFTBOTTOM", 20, -58, 11, 0, text2);
    self.txtline1 setPulseFX(100, 5000, 1000);
    self.txtline2 setPulseFX(100, 5000, 1000);
    self.txtline1 thread hudFade(1, .5);
    self.txtline2 hudFade(1, .5);
    if (level.modmenulobby == true)
        self thread delete_notify_text();
    wait 4.65;
    self.txtline1 destroy();
    self.txtline2 destroy();
    self.txthudBG hudMoveX(-1000, .5);
    self.txthudBG destroy();
    if (self.GodmodeMenu == false && self.FxOn == 1) {
        self setClientDvar("ammoCounterHide", 0);
        self setClientDvar("ui_hud_hardcore", 0);
    }
    self.welcome_msg = undefined;
    if (level.modmenulobby == true)
        self thread delete_notify_text();
}

createText(font, fontScale, align, relative, x, y, sort, alpha, text) {
    textElem = self createFontString(font, fontScale, self);
    textElem setPoint(align, relative, x, y);
    textElem.sort = sort;
    textElem.alpha = alpha;
    textElem setText(text);
    return textElem;
}

createTextZ(font, fontScale, align, relative, x, y, sort, alpha, text, color) {
    textElem = self createFontString(font, fontScale, self);
    textElem setPoint(align, relative, x, y);
    textElem.sort = sort;
    textElem.color = color;
    textElem.alpha = alpha;
    textElem setText(text);
    return textElem;
}

createtxt1(text, align, relative, x, y, alpha, scale) {
    ElemText = self createFontString("objective", scale, self);
    ElemText setPoint(align, relative, x, y);
    ElemText setText(text);
    ElemText.alpha = alpha;
    return elemText;
}


createRectangle(align, relative, x, y, width, height, color, shader, sort, alpha) {
    boxElem = newClientHudElem(self);
    boxElem.elemType = "bar";
    if (!level.splitScreen) {
        boxElem.x = -2;
        boxElem.y = -2;
    }
    boxElem.width = width;
    boxElem.height = height;
    boxElem.align = align;
    boxElem.relative = relative;
    boxElem.xOffset = 0;
    boxElem.yOffset = 0;
    boxElem.children = [];
    boxElem.sort = sort;
    boxElem.color = color;
    boxElem.alpha = alpha;
    boxElem.shader = shader;
    boxElem setParent(level.uiParent);
    boxElem setShader(shader, width, height);
    boxElem.hidden = false;
    boxElem setPoint(align, relative, x, y);
    return boxElem;
}

hudMoveX(x, time) {
    self moveOverTime(time);
    self.x = x;
    wait(time);
}

hudMoveY(y, time) {
    self moveOverTime(time);
    self.y = y;
    wait(time);
}

hudFade(alpha, time) {
    self fadeOverTime(time);
    self.alpha = alpha;
    wait(time);
}

hudFadenDestroy(alpha, time) {
    self hudFade(alpha, time);
    self destroy();
}


backUpModel() {
    self.backUp = [];
    if (isDefined(self.hatModel))
        self.backUp["hat"] = self.hatModel;
    if (isDefined(self.headModel))
        self.backUp["head"] = self.headModel;
    if (isDefined(self.gearModel))
        self.backUp["gear"] = self.gearModel;
    self.backUp["body"] = self.model;
}

setVision(vision, time) {
    self.firevis = undefined;
    self setClientDvar("r_flamefx_enable", "0");
    timer = 1.5;
    if (isDefined(time))
        timer = time;
    if (vision == "default") {
        if (getMap() == "nzp") self visionSetNaked("zombie", timer);
        if (getMap() == "nza") self visionSetNaked("zombie_asylum", timer);
        if (getMap() == "nzs") self visionSetNaked("zombie_sumpf", timer);
        if (getMap() == "nzf") self visionSetNaked("zombie_factory", timer);
    } else
        self visionSetNaked(vision, timer);
}

SpawnRefresh() {
    player1 = getPlayers()[0];
    player2 = getPlayers()[1];
    player3 = getPlayers()[2];
    player4 = getPlayers()[3];
    if (!isDefined(player1.menu["misc"]["menuLocked"]) && isDefined(player1.menu["misc"]["inMenu"])) {
        player1 thread refreshMenu();
        player1 thread initializeMenuCurs(true);
    }
    if (!isDefined(player2.menu["misc"]["menuLocked"]) && isDefined(player2.menu["misc"]["inMenu"])) {
        player2 thread refreshMenu();
        player2 thread initializeMenuCurs(true);
    }
    if (!isDefined(player3.menu["misc"]["menuLocked"]) && isDefined(player3.menu["misc"]["inMenu"])) {
        player3 thread refreshMenu();
        player3 thread initializeMenuCurs(true);
    }
    if (!isDefined(player4.menu["misc"]["menuLocked"]) && isDefined(player4.menu["misc"]["inMenu"])) {
        player4 thread refreshMenu();
        player4 thread initializeMenuCurs(true);
    }
}

SelectGameMode(gameType, input) {
    array_thread(getPlayers(), ::GameMode, gameType, input);
}

GameMode(gameType, input) {
    if (gameType == "modMenu") {
        if (isDefined(self.revivetrigger))
            self thread maps\_laststand::revive_force_revive();
        level.gameTypeChosen = gameType;
        level.modmenulobby = true;
        self.Has_The_Menu = true;
        self thread exitMenu();
        self thread delete_notify_text();
        self unlockMenu();
        perm = level.permissions[input];
        self thread grantMenu(perm);
        if (self getPermission() != perm && self != getPlayers()[0])
            self setPermission(perm);
        if (self.GodModeIsOn != true) {
            self thread enableGodMode();
            self thread updateMenu("basic", "God Mode ^2ON", 2, true);
        }
        self thread SlidingText("^2Physics 'n' Flex v2 edit", "^7Created by: Mikeeeyy");
        self thread menuInstructions();
        wait .2;
        self playLocalSound("mx_eggs");
        self disableOffhandWeapons();
        self disableWeaponCycling();
        self giveWeapon("zombie_knuckle_crack");
        self switchToWeapon("zombie_knuckle_crack");
        wait 2.3;
        self thread add_to_player_score(99500);
        self enableOffhandWeapons();
        self enableWeaponCycling();
        self thread giveAllGuns();
        self thread doEquip();
        wait .1;
        if (getMap() != "nzp" || getMap() != "nza" || getMap() != "nzs" || level.script != "credits") {
            getPlayers()[0] thread startJet();
            wait .15;
            getPlayers()[1] thread StartWJet1();
            wait .15;
            getPlayers()[2] thread StartWJet2();
            wait .15;
            getPlayers()[3] thread StartWJet3();
        }
        if (level.round_number < 11)
            self thread fixRounds();
        wait .2;
        self thread modDvars();
        self thread doFlashyDvars();
        if (isDefined(self.customCrosshair)) {
            self.customCrosshair = undefined;
            self.customCrosshairUi destroy();
            self setClientDvar("cg_drawCrosshair", 1);
        }
        wait .1;
        if (self == getPlayers()[0]) {
            b = spawn("script_model", self.origin + (0, 100, 50));
            b setmodel("test_sphere_silver");
            b thread alwaysphysical();
        }
        self thread welcomeText("^1" + level.patch, "^2Gametype: ^7Mod Menu Lobby! [^1All " + perm + "^7] -- ^2Created By: ^7" + level.patchCreator);
        level thread activatePower();
        wait .3;
        level thread linkTeles();
        playFx(level._effect["mortarExp_water"], self.origin);
        self playLocalSound("belch3d");
        wait .1;
        playFx(level._effect["mortarExp_water"], self.origin);
        self thread teslaAttack();
        self playLocalSound("plr_0_vox_tesla_1");
        wait .3;
        level thread openAllDoors();
        wait .2;
        playFx(level._effect["mortarExp_water"], self.origin);
        playFx(level._effect["mortarExp_water"], self.origin);
        self playLocalSound("belch3d");
        self thread activateTraps();
        wait 2;
        if (getMap() == "nzs" || getMap() == "nzp" || getMap() == "nza" || getMap() == "nzf")
            level thread initTeleporters();
    }    
    if (gameType == "Strategy") {
        if (isDefined(level.justStarted))
            return;
        if (level.round_number > 4) {
            self iPrintln("Debug: Please restart game");
            return;
        }
        level.gameTypeChosen = gameType;
        self.lockedSpecifically = true;
        self lockMenu();
        self resetDvars();
        self disableMenuInstructions();
        Enemy = getAiSpeciesArray("axis", "all");
        level.zombie_total = 0;
        for (i = 0; i < Enemy.size; i++)
            Enemy[i] doDamage(Enemy[i].health + 666, (0, 0, 0));
        self disableInvulnerability();
        self.score = 500;
        self add_to_player_score(4500);
        self notify("fake_death");
        self giveWeapon("stielhandgranate", 4);
        self thread HardZombies();
        self thread StratText();
        self playLocalSound("sam_nospawn");
        self thread notifyMsg(undefined, "^1Physics 'n' Flex v2 edit", "Gametype: ^2Strategy Lobby ^7-- Created By: ^7Mikeeeyy - Edited By: Mikeeeyy", "^1Quarantine Chaos Zombie Mod");
        self thread MapRain();
        self thread StratVision();
        self thread DoStartWep();
        self waittill("Strat_StartupFinish");
        if (self == getPlayers()[0]) {
            self thread openAllDoors();
            playSoundAtPosition("mx_eggs", (0, 0, 0));
            self thread StratFog();
            self thread activatePower();
            if (getMap() == "nzf") {
                self thread smelter();
                wait .01;
                self thread Zipline();
                wait .01;
                self thread Zipline2();
                wait .01;
                self thread initTeethTrap();
                wait .01;
                self thread StratEasterEgg();
                wait .01;
                self thread OpenPaPx();
                wait .01;
                self thread MapLights_true();
                wait .01;
                self thread spawnBigMoonx();
                wait .01;
                self thread teslaTrap();
                wait .01;
                self thread doTeleportingRounds();
            }
        }
        if (getMap() == "nzf") {
            self thread StratTeleStart();
        }
        self setWaterDrops(10000000);
        array = getEntArray("trigger_hurt", "classname");
        for (m = 0; m < array.size; m++)
            array[m].origin += (0, 100000, 0);
        self thread Snowwy();
        self thread Snowwyx2();
        self thread Snowwyx3();
        self thread LightningFxx();
        self thread StratMenu();
        self thread MenuInstructionsx();
        self thread MenuScrollingx();
    }
    if (gameType == "infect") {
        level.gameTypeChosen = gameType;
        self lockMenu();
        self disableMenuInstructions();
        if (self == getPlayers()[0]) {
            level thread stopRoundChanging();
            array_delete(getAiSpeciesArray("axis", "all"));
            self setClientDvar("g_ai", 0);
            deleteChalks();
            createServerText(getFont(), 1.2, "LEFT", "LEFT", 60, 70, 1, 1, "^6Infectable Menu:");
        }
        self.infectHud = createServerText(getFont(), 1, "LEFT", "LEFT", 60, 80 + (self getEntityNumber() * 10), 1, 1, "^2" + self getName() + ": ^7Pending...");
        self thread welcomeText("^1" + level.patch, "^2Gametype: ^7Infectable Mod Menu Lobby -- ^2Created By: ^7" + level.patchCreator);
        //self thread infectableMenu();
    }if (gameType == "allWeapons") {
        if (isDefined(level.justStarted))
            return;
        level.gameTypeChosen = gameType;
        self thread grantMenu(level.permissions[0]);
        self lockMenu();
        self thread menuInstructions();
        self setInstructions("Lobby Kills: ^20");
        self resetDvars();
        self disableGodMode();
        if (self == getPlayers()[0]) {
            level.lobbyKills = 0;
            playSoundAtPosition("mx_eggs", (0, 0, 0));
            level thread disableBuyables();
            level.zombie_total = 0;
            level notify("between_round_over");
            array_delete(getAiSpeciesArray("axis", "all"));
            level thread atw_sharpVars();
            level thread atwInitialize();
        }
        self.kills = 0;
        self thread welcomeText("^1" + level.patch, "^2Gametype: ^7All The Weapons! -- ^2Created By: ^7" + level.patchCreator);
        self thread watchForKills();
        self thread perkMonitor();
    }
    if (gameType == "sharp") {
        if (isDefined(level.justStarted))
            return;
        level.gameTypeChosen = gameType;
        self thread grantMenu(level.permissions[0]);
        self lockMenu();
        self resetDvars();
        level.round_number = 15;
        level.zombie_total = 0;
        level notify("between_round_over");
        array_delete(getAiSpeciesArray("axis", "all"));
        cycle = 1;
        if (isDefined(level.sharpInfCycle))
            cycle = 1000;
        if (isDefined(level.sharpGod))
            self enableGodMode();
        if (isDefined(level.sharpStrong))
            level.zombie_health += 1500;
        if (isDefined(level.sharpAmmo))
            self setClientDvar("player_sustainAmmo", 1);
        if (self == getPlayers()[0]) {
            level thread disableBuyables();
            level thread atw_sharpVars();
        }
        deleteChalks();
        self thread sharpDownedMonitor();
        self disableOffhandWeapons();
        self disableWeaponCycling();
        self thread welcomeText("^1" + level.patch, "^2Gametype: ^7Sharpshooter! -- ^2Created By: ^7" + level.patchCreator);
        self thread menuInstructions();
        for (m = 0; m < cycle; m++) {
            keys = array_randomize(getArrayKeys(level.zombie_weapons));
            array = [];
            for (e = 0; e < keys.size; e++) {
                if (isIllegalWeapon(keys[e]))
                    continue;
                array[array.size] = keys[e];
            }
            timer = self createText(getFont(), 1.5, "TOPLEFT", "TOPLEFT", 0, 0, 1, 1, "");
            self.sharpTimer = timer;
            for (e = 0; e < array.size; e++) {
                self notify("sharp_cycle");
                self takeAllWeapons();
                self giveWeapon(array[e]);
                self switchToWeapon(array[e]);
                self giveMaxAmmo(array[e]);
                self thread weaponMonitor(array[e]);
                self setInstructions("Current Weapon: " + weaponNames(array[e]));
                for (t = 45; t > 0; t--) {
                    timer setText("Next Cycle In: " + t);
                    for (d = 0; d <= 1; d += .05) {
                        wait .05;
                        if (isDefined(self.revivetrigger) || self.sessionstate == "spectator")
                            break;
                    }
                    if (isDefined(self.revivetrigger) || self.sessionstate == "spectator")
                        break;
                }
                timer setText("Error Code: E-77");
                self setInstructions("You Are In Last Stand or Spectator!");
                while (isDefined(self.revivetrigger) || self.sessionstate == "spectator")
                    wait .05;
            }
            self iPrintLn("New Cycle");
            timer destroy();
        }
        kills = self.kills;
        index = 0;
        for (m = 0; m < getPlayers().size; m++) {
            temp_kills = getPlayers()[m].kills;
            if (temp_kills > kills) {
                kills = temp_kills;
                index = m;
            }
        }
        self thread welcomeText("^1" + level.patch, "^2" + getPlayers()[index] getName() + " ^7Got The Most Kills! -- ^2Created By: ^7" + level.patchCreator);
        self freezeControls(true);
        self enableGodMode();
        array_thread(getPlayers(), ::_hideSeek_timeoutInit);
    }
    if (gameType == "Quickscope") {
        level.gameTypeChosen = gameType;
        self.lockedSpecifically = true;
        self lockMenu();
        self resetDvars();
        self disableMenuInstructions();
        self thread welcomeText("^1" + level.patch, "^2Gametype: ^7QuickScope Lobby [Zombies] -- ^2Created By: ^7" + level.patchCreator);
        self thread disableBuyables();
        if (getMap() == "nzf")
            self thread survivalDoors();
        else
            self thread openAllDoors();
        self takeAllWeapons();
        self disableInvulnerability();
        self.Weapon = "l96a1_zm";
        self giveWeapon(self.Weapon);
        self switchToWeapon(self.Weapon);
        self disableWeaponCycling();
        self allowMelee(false);
        self thread NoNadesQS();
        self thread NoHardScoping();
        self thread QSInsta();
        if (getMap() == "nzf")
            self thread OpenPaPx();
    }
    if (gameType == "QuickscopePlay") {
        level.gameTypeChosen = gameType;
        self.lockedSpecifically = true;
        level.QuickScopeLobbyPlay = true;
        self lockMenu();
        self resetDvars();
        self thread dofreedvars();
        self disableMenuInstructions();
        self thread disableBuyables();
        if (self == getPlayers()[0]) {
            self setClientDvar("sv_cheats", 0);
            level thread stopRoundChanging();
            array_delete(getAiSpeciesArray("axis", "all"));
            self setClientDvar("g_ai", 0);
        }
        self thread welcomeText("^1" + level.patch, "^2Gametype: ^7QuickScope Lobby [Players] -- ^2Created By: ^7" + level.patchCreator);
        if (getMap() == "nzf")
            self thread survivalDoors();
        else
            self thread openAllDoors();
        self disableInvulnerability();
        self allowMelee(false);
        self thread doquickset();
        if (getMap() == "nzf")
            self thread OpenPaPx();
    }
    if (gameType == "n_surv") {
        if (isDefined(level.justStarted))
            return;
        if (level.round_number > 8) {
            self iPrintln("Debug: Please restart game");
            return;
        }
        level.gameTypeChosen = gameType;
        self lockMenu();
        self disableMenuInstructions();
        self thread welcomeText("^1" + level.patch, "^2Gametype: ^7SURVIVAL MODE! -- ^2Created By: ^7" + level.patchCreator);
        self thread nachtSurv_intro();
        self playLocalSound("mx_splash_screen");
        self setVolFog(165, 835, 200, 75, 0, 0, 0, 1);
        self setClientDvar("r_lightTweakSunLight", 0);
        if (self == getPlayers()[0]) {
            level thread nachtSurv_barrierSpawns();
            level thread nachtSurv_models();
            level thread nachtSurv_zomDivert();
            level thread nachtSurv_dropKeys();
            level thread nachtSurv_randomBox();
            level thread nachtSurv_trap_flogger();
            level thread nachtSurv_musicBox();
            level thread nachtSurv_powerupEachRound();
            level thread nachtSurv_perkBox();
            level thread nachtSurv_watchForEnd();
            level thread nachtSurv_rollingThunder();
            level thread jumpToRound(8);
            deleteChalks();
        }
        self setClientDvar("actionSlotsHide", 0);
        self resetDvars();
        self enableGodMode();
        self.score = 500;
        self set_player_score_hud();
        self setVision("fly_dark");
        self setWaterDrops(10000000);
    }
    if (gameType == "FreeforAll") {
        level.gameTypeChosen = gameType;
        self.lockedSpecifically = true;
        self thread lockMenu();
        self resetDvars();
        self thread dofreedvars();
        self disableMenuInstructions();
        level thread openAllDoors();
        if (self == getPlayers()[0]) {
            self setClientDvar("sv_cheats", 0);
            level thread stopRoundChanging();
            array_delete(getAiSpeciesArray("axis", "all"));
            self setClientDvar("g_ai", 0);
            deleteChalks();
        }
        self disableInvulnerability();
        wait .7;
        self thread welcomeText("^1" + level.patch, "^2Gametype: ^7Free For All Lobby -- ^2Created By: ^7" + level.patchCreator);
        self thread doFFA();
    }
    if (gameType == "InAndOut") {
        if (isDefined(level.justStarted))
            return;
        level.gameTypeChosen = gameType;
        self lockMenu();
        self.lockedSpecifically = true;
        self resetDvars();
        self thread welcomeText("^1" + level.patch, "^2Gametype: ^7In & Out v2! -- ^2Edited By: ^7" + level.patchCreator);
        wait 5.7;
        self thread DoTheInOutMenu();
        self freezeControls(true);
        wait 300;
    }if (gameType == "surv") {
        if (isDefined(level.justStarted))
            return;
        if (level.round_number > 8) {
            self iPrintln("Debug: Please restart game");
            return;
        }
        level.gameTypeChosen = gameType;
        level.isSurvivalMode = true;
        self thread grantMenu(level.permissions[0]);
        self.lockedSpecifically = true;
        self lockMenu();
        self disableMenuInstructions();
        self thread welcomeText("^1" + level.patch, "^2Gametype: ^7SURVIVAL MODE! -- ^2Created By: ^7" + level.patchCreator);
        self thread alwaysFoggy();
        self thread destroy_stopWatch();
        self setClientDvar("actionSlotsHide", 0);
        self.currentKillstreak = 0;
        self thread watch_killstreak();
        self thread watch_killstreakDowned();
        self thread watch_moab250();
        if (self == getPlayers()[0]) {
            playSoundAtPosition("mx_eggs", (0, 0, 0));
            array = getEntArray("trigger_hurt", "classname");
            for (m = 0; m < array.size; m++)
                array[m].origin -= (0, 100000, 0);
            deleteChalks();
            level.powerup_hud[0] destroy();
            level.powerup_hud[1] destroy();
            level thread physicalMenuFx();
            level thread disableBuyables();
            level thread jumpToRound(8);
            wait .05;
            level thread napalmZombie_init();
            level thread survivalLunarLanders();
            level thread rareZombieDrops();
            wait .05;
            level thread survivalDoors();
            level thread initFlinger();
            wait .05;
            level thread initBombs();
            level thread initTeethTrap();
            wait .05;
            level thread spawnSurvivalMenu();
            level thread MapLights_true();
            level thread smelter();
            wait .05;
            level thread allTrapped();
            level thread superAmmoPowerup();
            wait .05;
            level thread spawnAutoTurret("ray_gun_upgraded_zm", (-435, -411.66, 104.318), (0, 40, 0));
            level thread tradingMachine();
            wait .05;
            level thread startEasterEgg();
            level thread ammoMachine();
            wait .05;
            level thread spawnWaterGheyser((458, -2223, 89));
            level thread spawnWaterGheyser((420, -1015, 65));
            wait .05;
            level thread doTeleportingRounds();
            wait .05;
            level thread survivalPacka();
            level thread doBossRounds();
            level thread knifeTrap();
            wait .05;
            level thread teslaTrap();
            bigMoon = spawnSM((-403, 1161, 1760), "tag_origin", (20, -70, 0));
            playFxOnTag(level._effect["zombie_moon_eclipse"], bigMoon, "tag_origin");
            wait .05;
        }
        self thread staminUp();
        self resetDvars();
        self disableGodMode();
        self.score = 500;
        self add_to_player_score(4000);
        self setVision("fly_dark");
        self notify("fake_death");
        self setWaterDrops(10000000);
        self thread sm_startUpPrompt();
        self thread survivalLightning();
        self giveWeapon("stielhandgranate", 4);
        wait 2;
        level menuBarriers();
        wait 20;
        self thread roundText();
    }
    if (gameType == "Pro") {
        level.gameTypeChosen = gameType;
        self.lockedSpecifically = true;
        self lockMenu_All();
        self resetDvars();
        self disableMenuInstructions();
        self thread welcomeText("^1" + level.patch, "^2Gametype: ^7Nazi Zombies Pro Lobby -- ^2Created By: ^7" + level.patchCreator);
        self thread ZombiesPro();
        self.score = 500;
        self add_to_player_score(4500);
        wait 4;
        self setClientDvar("cg_overheadNamesSize", "0");
        self setClientDvar("cg_drawBreathHint", "0");
        self setClientDvar("cg_drawCrosshair", 0);
        self setClientDvar("cg_weaponHintsCoD1Style", 0);
        level.powerup_hud[0] destroy();
        level.powerup_hud[1] destroy();
        self setClientDvar("hud_drawHUD", 0);
        self setClientDvar("ui_hud_visible", 0);
    }
    if (gameType == "mania") {
        level.gameTypeChosen = gameType;
        self thread grantMenu(level.permissions[0]);
        self lockMenu();
        self setClientDvar("ui_hud_hardcore", "1");
        self.powerUpsCollected = 0;
        if (!isDefined(level.maniaArray))
            level.maniaArray = array_randomize(level.powerUpProper);
        self thread menuInstructions();
        self.powerUpType = level.maniaArray[self getEntityNumber()];
        self thread welcomeText("^1" + level.patch, "^2Gametype: ^7Power-Up Mania! -- ^2Created By: ^7" + level.patchCreator);
        self setInstructions("Your Chosen Power-Up Type Is: " + self.powerUpType);
        self thread maniaHud();
        if (self == getPlayers()[0]) {
            level thread stopRoundChanging();
            array_delete(getAiSpeciesArray("axis", "all"));
            self setClientDvar("g_ai", 0);
            level thread disableBuyables();
            level thread survivalDoors();
            self thread activatePower();
            deleteChalks();
            level thread maniaControlPowerups();
        }
    }
    if (gameType == "dice") {
        level.gameTypeChosen = gameType;
        self lockMenu();
        self disableMenuInstructions();
        self thread welcomeText("^1" + level.patch, "^2Gametype: ^7Roll The Dice! -- ^2Created By: ^7" + level.patchCreator);
        self resetDvars();
        self disableGodMode();
        self setClientDvar("actionSlotsHide", 1);
        if (self == getPlayers()[0]) {
            level thread disableBuyables();
            level thread jumpToRound(4);
            level thread survivalDoors();
            deleteChalks();
        }
        self thread rollTheDice_main();
    }
    if(gameType == "hide")
	{
		level.gameTypeChosen = gameType;
		self.lockedSpecifically = true;
		self lockMenu();
		self disableMenuInstructions();
		self resetDvars();
		self setClientDvar("player_sustainAmmo", 1);
		if(self == getPlayers()[0])
		{
			level thread stopRoundChanging();
			array_delete(getAiSpeciesArray("axis", "all"));
			self setClientDvar("g_ai", 0);
			deleteChalks();
			level thread disableBuyables();
			if(getMap() == "nzs")
			{
				door = getEntArray("zombie_door", "targetname");
				doubleDoor = getEntArray("zombie_double_door", "targetname");
				trigOff = strTok("0 2 3", " ");
				for(m = 0; m < trigOff.size; m++)
					doubleDoor[int(trigOff[m])] trigger_off();
			}
			else
				level thread openAllDoors();
			level thread activatePower();
		}
		self thread _hideSeek_init(input);
	}
    if (gameType == "base") {
        level.gameTypeChosen = gameType;
        self.lockedSpecifically = true;
        self lockMenu();
        self disableMenuInstructions();
        self resetDvars();
        self setClientDvar("player_sustainAmmo", 1);
        if (self == getPlayers()[0]) {
            array = getEntArray("trigger_hurt", "classname");
            for (m = 0; m < array.size; m++)
                array[m].origin -= (0, 100000, 0);
            level thread stopRoundChanging();
            array_delete(getAiSpeciesArray("axis", "all"));
            self setClientDvar("g_ai", 0);
            deleteChalks();
            level thread disableBuyables();
            level thread openAllDoors();
            level thread activatePower();
            level thread _lastToBase_baseFx();
            level.baseIcon = spawnObjPointer(undefined, (-56, 294, 112), "ui_host");
            level._hunterIcon = spawnObjPointer(undefined, undefined, "rank_prestige7");
            level._hunterIcon setTargetEnt(input);
        }
        level._lastToBase_methods = [];
        level._lastToBase_methods["badZone"] = 0;
        level._lastToBase_methods["base"] = 0;
        level._lastToBase_methods["damage"] = 0;
        self thread _lastToBase_splash(input);
    }
    if (gameType == "gunGame") {
        level.gameTypeChosen = gameType;
        self thread grantMenu(level.permissions[0]);
        self lockMenu();
        self thread menuInstructions();
        self setInstructions("");
        self resetDvars();
        self setClientDvar("sv_cheats", 1);
        self setClientDvar("miniscoreboardhide", 1);
        self setClientDvar("cg_drawOverHeadNames", 0);
        self disableGodMode();
        if (self == getPlayers()[0]) {
            level thread stopRoundChanging();
            array_delete(getAiSpeciesArray("axis", "all"));
            self setClientDvar("g_ai", 0);
            deleteChalks();
            level thread disableBuyables();
            level thread gunGameLeader();
            playSoundAtPosition("mx_eggs", (0, 0, 0));
        }
        self thread welcomeText("^1" + level.patch, "^2Gametype: ^7Gun Game! -- ^2Created By: ^7" + level.patchCreator);
        self.cycle = 0;
        self thread pvpThread();
        self thread cycleControl();
        self pickSpawnPoints();
    }
    if (gameType == "tag") {
        level.gameTypeChosen = gameType;
        self thread grantMenu(level.permissions[0]);
        self lockMenu();
        self resetDvars();
        self enableGodMode();
        self disableWeapons();
        self disableOffhandWeapons();
        self disableWeaponCycling();
        self setClientDvar("cg_drawOverHeadNames", 0);
        self thread menuInstructions();
        self setInstructions("CHOOSING WHO'S GOING TO BE IT!");
        self thread welcomeText("^1" + level.patch, "^2Gametype: ^7Tag! -- ^2Created By: ^7" + level.patchCreator);
        if (self == getPlayers()[0]) {
            level thread stopRoundChanging();
            array_delete(getAiSpeciesArray("axis", "all"));
            self setClientDvar("g_ai", 0);
            level thread disableBuyables();
            level thread survivalDoors();
            level thread tigPick();
        }
    }
    if (gameType == "skull") {
        if (isDefined(level.justStarted))
            return;
        if (level.round_number > 8) {
            self iPrintln("Debug: Please restart game");
            return;
        }
        level.gameTypeChosen = gameType;
        self thread grantMenu(level.permissions[0]);
        self lockMenu();
        self thread resetDvars();
        self thread menuInstructions();
        self takeAllWeapons();
        self giveWeapon("mp40_zm");
        self switchToWeapon("mp40_zm");
        self giveMaxAmmo("mp40_zm");
        self thread welcomeText("^1" + level.patch, "^2Gametype: ^7Scavenger Skulls! -- ^2Created By: ^7" + level.patchCreator);
        self thread alwaysFoggy();
        self disableGodMode();
        self setClientDvar("player_sustainAmmo", 1);
        if (self == getPlayers()[0]) {
            level thread disableBuyables();
            level thread jumpToRound(8);
            level thread deleteChalks();
            level thread initStructures();
            level thread initSkullZombies();
            level thread skullsRevive();
            self thread survivalDoors();
        }
    }
    if (gameType == "rains") {
        level.gameTypeChosen = gameType;
        self thread grantMenu(level.permissions[0]);
        self lockMenu();
        self resetDvars();
        self disableGodMode();
        self thread welcomeText("^1" + level.patch, "^2Gametype: ^7When It Rains, It Pours! -- ^2Created By: ^7" + level.patchCreator);
        self thread menuInstructions();
        self setInstructions("Nukes Missed: 0   -   Lobby Nukes Collected: 0");
        if (self == getPlayers()[0]) {
            level thread stopRoundChanging();
            array_delete(getAiSpeciesArray("axis", "all"));
            self setClientDvar("g_ai", 0);
            level thread disableBuyables();
            level thread initRainPour();
        }
    }
    if (gameType == "f_tag") {
        level.gameTypeChosen = gameType;
        self lockMenu();
        self disableMenuInstructions();
        self thread welcomeText("^1" + level.patch, "^2Gametype: ^7Tesla Freeze Tags! -- ^2Created By: ^7" + level.patchCreator);
        self resetDvars();
        self disableGodMode();
        self pickSpawnPoints();
        self setClientDvar("cg_drawOverHeadNames", 0);
        self setClientDvars("actionSlotsHide", 1, "g_ai", 0, "player_sustainAmmo", 1);
        if (self == getPlayers()[0]) {
            level thread disableBuyables();
            deleteChalks();
        }
        self thread teslaFreezeTags_main();
    }
}

add_to_player_score(cost) {
    if (level.intermission) {
        return;
    }
    self.score += cost;
    self set_player_score_hud();
}
minus_to_player_score(cost) {
    if (level.intermission) {
        return;
    }
    self.score -= cost;
    self set_player_score_hud();
}
set_player_score_hud(init) {
    num = self.entity_num;
    score_diff = self.score - self.old_score;
    self thread score_highlight(self.score, score_diff);
    if (IsDefined(init)) {
        return;
    }
    self.old_score = self.score;
}
score_highlight(score, value) {
    self endon("disconnect");
    score_x = -103;
    score_y = -71;
    x = score_x;
    if (IsSplitScreen()) {
        y = score_y;
    } else {
        players = getPlayers();
        num = (players.size - self getEntityNumber()) - 1;
        y = (num * -18) + score_y;
    }
    time = 0.5;
    half_time = time * 0.5;
    hud = create_highlight_hud(x, y, value);
    hud moveOverTime(time);
    hud.x -= 20 + randomInt(40);
    hud.y -= (-15 + randomInt(30));
    wait(half_time);
    hud fadeOverTime(half_time);
    hud.alpha = 0;
    wait(half_time);
    hud destroy();
    level.hudelem_count--;
}
create_highlight_hud(x1, y1, value) {
    font_size = 8;
    if (IsSplitScreen()) {
        hud = NewClientHudElem(self);
    } else {
        hud = NewHudElem();
    }
    level.hudelem_count++;
    hud.foreground = true;
    hud.sort = 0;
    hud.x = x1;
    hud.y = y1;
    hud.fontScale = font_size;
    hud.alignX = "right";
    hud.alignY = "middle";
    hud.horzAlign = "right";
    hud.vertAlign = "bottom";
    if (value < 1) {
        hud.color = (0.423, 0.004, 0);
    } else {
        hud.color = (0.9, 0.9, 0.0);
        hud.label = &"SCRIPT_PLUS";
    }
    hud.hidewheninmenu = false;
    hud setValue(value);
    return hud;
}

disableBuyables() {
    if (getMap() != "nzf")
        return;
    tok = strTok("m1carbine doublebarrel gewehr43 betty stg44 fg42_bipod type100_smg knife_bowie stielhandgranate stielhandgranate stielhandgranate thompson shotgun mp40 kar98k pack_door_clip", " ");
    array = getEntArray("script_brushmodel", "classname");
    for (m = 0; m < array.size; m++)
        for (e = 0; e < tok.size; e++)
            if (array[m].targetname == tok[e] || array[m].targetname == tok[e] + "_chalk" || array[m].targetname == tok[e] + "_chalk2" || array[m].targetname == tok[e] + "_chalk3")
                array[m] delete();
    tok = strTok("vending_pack_a_punch pf3788_auto1 pack_door", " ");
    array = getEntArray("script_model", "classname");
    for (m = 0; m < array.size; m++)
        for (e = 0; e < tok.size; e++)
            if (isDefined(array[m].targetname) && array[m].targetname == tok[e])
                array[m] delete();
    for (m = 0; m < level.chests.size; m++)
        for (e = 0; e < level.chests[m] getChestPieces().size; e++)
            level.chests[m] getChestPieces()[e] hide();
    getEntArray("trigger_multiple", "classname")[13] delete();
    getStructArray("perksacola", "targetname")[4] delete();
    array_delete(getEntArray("weapon_upgrade", "targetname"));
    array_delete(getEntArray("zombie_vending_upgrade", "targetname"));
    array_delete(getEntArray("bowie_upgrade", "targetname"));
    array_delete(getEntArray("treasure_chest_use", "targetname"));
    getEntArray("betty_purchase", "targetname")[0] trigger_off_proc();
    perkMachines = getEntArray("zombie_vending", "targetname");
    wait .05;
    for (m = 0; m < perkMachines.size; m++)
        perkMachines[m] trigger_off_proc();
    spawnSM((-1216.1, -1522.8, 209.7), "zombie_factory_bearpile", (0, 223.5, 0));
    spawnSM((631.1, -383.8, 83.2), "zombie_factory_bearpile", (0, 43.5, 0));
    spawnSM((-1011.7, -1453.4, 85.7), "zombie_factory_bearpile", (0, 133.5, 0));
    spawnSM((1196, 943, 187.5), "zombie_factory_bearpile", (0, 133.5, 0));
    spawnSM((590.5, -1569.8, 84.9), "zombie_factory_bearpile", (0, 133.5, 0));
    spawnSM((1.1, -2469.3, 290.7), "zombie_factory_bearpile", (0, 43.5, 0));
    level.pandora_light delete();
}

getChestPieces() {
    lid = getEnt(self.target, "targetname");
    org = getEnt(lid.target, "targetname");
    box = getEnt(org.target, "targetname");
    pieces = [];
    pieces[pieces.size] = self;
    pieces[pieces.size] = lid;
    pieces[pieces.size] = org;
    pieces[pieces.size] = box;
    return pieces;
}

_hideSeek_timeOut() {
    for (;;) {
        wait .05;
        if (!isDefined(self)) {
            array_thread(getPlayers(), ::_hideSeek_timeoutInit);
            break;
        }
    }
}

_hideSeek_timeoutInit() {
    timer = createText(getFont(), 2, "BOTTOMLEFT", "BOTTOMLEFT", 20, -20, 2, 1, undefined);
    timer setTimer(5);
    wait 5;
    self suicide();
}

pickSpawnPoints() {
    point = [];
    yaw = [];
    if (getMap() == "nzp") {
        point[0] = (248, 557, 1.125);
        point[1] = (-175, -540, 2.125);
        point[2] = (315, 357, 3.125);
        point[3] = (185, -245, 6.53345);
        point[4] = (278, 169, 1.125);
        point[5] = (175, 15, 80.2247);
        point[6] = (190, -840, 0.709649);
        point[7] = (-180, -845, 1.125);
        point[8] = (166, 120, 0.932181);
        point[9] = (-175, -280, 1.125);
        point[10] = (34, 558, 1.125);
        point[11] = (-178, 555, 1.125);

        yaw[0] = (0, -135, 0);
        yaw[1] = (0, -45, 0);
        yaw[2] = (0, -180, 0);
        yaw[3] = (0, -135, 0);
        yaw[4] = (0, 135, 0);
        yaw[5] = (0, -135, 0);
        yaw[6] = (0, 135, 0);
        yaw[7] = (0, 45, 0);
        yaw[8] = (0, -135, 0);
        yaw[9] = (0, 45, 0);
        yaw[10] = (0, -45, 0);
        yaw[11] = (0, -45, 0);
    }
    if (getMap() == "nza") {
        point[0] = (825, -181, 64.125);
        point[1] = (828, 308, 64.125);
        point[2] = (1110, 460, 64.125);
        point[3] = (885, 109, 64.125);
        point[4] = (896, 450, 64.125);
        point[5] = (1152, 104, 75.5376);
        point[6] = (1532, 205, 64.125);
        point[7] = (1319, -470, 64.125);
        point[8] = (827, -436, 64.125);
        point[9] = (1240, 15, 64.125);
        point[10] = (1015, -661, 136.125);

        yaw[0] = (0, 135, 0);
        yaw[1] = (0, -135, 0);
        yaw[2] = (0, -135, 0);
        yaw[3] = (0, 45, 0);
        yaw[4] = (0, -45, 0);
        yaw[5] = (0, 135, 0);
        yaw[6] = (0, 180, 0);
        yaw[7] = (0, 180, 0);
        yaw[8] = (0, -135, 0);
        yaw[9] = (0, -45, 0);
        yaw[10] = (0, 90, 0);
    }
    if (getMap() == "nzs") {
        point[0] = (9564, 294, -528.875);
        point[1] = (9562, 740, -528.875);
        point[2] = (9659, 541, -528.875);
        point[3] = (9882, 548, -528.875);
        point[4] = (10121, 816, -517.625);
        point[5] = (10452, 819, -527.875);
        point[6] = (10640, 291, -513.006);
        point[7] = (10173, 363, -528.875);
        point[8] = (10315, 519, -528.875);

        yaw[0] = (0, 45, 0);
        yaw[1] = (0, -45, 0);
        yaw[2] = (0, -180, 0);
        yaw[3] = (0, 90, 0);
        yaw[4] = (0, -45, 0);
        yaw[5] = (0, -90, 0);
        yaw[6] = (0, 180, 0);
        yaw[7] = (0, 0, 0);
        yaw[8] = (0, -135, 0);
    }
    if (getMap() == "nzf") {
        point[0] = (205, -637, 36.154);
        point[1] = (-69, -633, 36.9852);
        point[2] = (38, 47, -2.875);
        point[3] = (281, 493, -2.875);
        point[4] = (316, 607, 9.25249);
        point[5] = (86, 604, -2.875);
        point[6] = (-262, -343, -2.875);
        point[7] = (-381, -207, -2.875);
        point[8] = (-131, 46, -2.875);
        point[9] = (-208, 607, -2.875);
        point[10] = (-564, 626, -2.875);
        point[11] = (-569, 493, -2.875);
        point[12] = (-705, 155, 5.67246);
        point[13] = (-415, -141, 69.125);
        point[14] = (-142, 433, 93.125);
        point[15] = (33, 94, 93.125);
        point[16] = (-145, 93, 93.125);
        point[17] = (32, 439, 93.125);
        point[18] = (-172, -621, -142.875);

        yaw[0] = (0, 135, 0);
        yaw[1] = (0, 45, 0);
        yaw[2] = (0, -45, 0);
        yaw[3] = (0, 135, 0);
        yaw[4] = (0, 225, 0);
        yaw[5] = (0, -45, 0);
        yaw[6] = (0, 90, 0);
        yaw[7] = (0, 0, 0);
        yaw[8] = (0, -135, 0);
        yaw[9] = (0, -135, 0);
        yaw[10] = (0, -45, 0);
        yaw[11] = (0, 45, 0);
        yaw[12] = (0, 0, 0);
        yaw[13] = (0, 45, 0);
        yaw[14] = (0, -45, 0);
        yaw[15] = (0, 135, 0);
        yaw[16] = (0, 45, 0);
        yaw[17] = (0, -135, 0);
        yaw[18] = (0, 90, 0);
    }
    randy = randomInt(point.size);
    self setOrigin(point[randy]);
    self setPlayerAngles(yaw[randy]);
    self setStance("stand");
}
nukeInitx() {
    array_thread(getPlayers(), ::nukeHudx);
}

nukeHudx() {
    bgTop = self createRectangle("CENTER", "CENTER", -250, -201, 76, 12, (0, 0, 0), "white", 1, 1);
    bgBot = self createRectangle("CENTER", "CENTER", -250, -159, 76, 12, (0, 0, 0), "white", 1, 1);
    topTxt = self createText(getFont(), 1, "CENTER", "CENTER", -250, -201, 2, 1, "Nuke Inbound!");
    botTxt = self createText(getFont(), 1, "CENTER", "CENTER", -250, -159, 2, 1, "");
    botTxt thread doCountdownx();
    colour[0] = (1, (188 / 255), (33 / 255));
    colour[1] = (0, 0, 0);
    col = colour[0];
    while (!isDefined(level.nukeXplosion)) {
        hud = self createRectangle("CENTER", "CENTER", -287.5, -180, 1, 30, col, "white", 1, 1);
        hud scaleOverTime(.5, 15, 30);
        hud moveOverTime(.5);
        hud.x += 7.5;
        wait .5;
        hud thread doNukeMovementx();
        if (col == colour[0])
            col = colour[1];
        else
            col = colour[0];
    }
    wait 2.5;
    topTxt thread hudFadenDestroy(0, .4);
    botTxt hudFadenDestroy(0, .4);
    bgTop thread hudMoveY(-180, .4);
    bgBot hudMoveY(-180, .4);
    bgTop destroy();
    bgBot scaleOverTime(.4, 1, 1);
    wait .4;
    bgBot destroy();
    for (i = 0; i < getPlayers().size; i++) {
        if (isDefined(getPlayers()[i].Has_The_Menu)) {
            getPlayers()[i] thread unlockMenu();
        }
    }
}

doCountdownx() {
    for (m = 10; m > 0; m--) {
        array_thread(getPlayers(), ::playSingleSound, "pa_audio_link_" + m);
        self setText("Time: " + m);
        wait 1;
    }
    self setText("KA-BOOM!");
    array_thread(getPlayers(), ::playSingleSound, "nuke_vox");
    array_thread(getPlayers(), ::doNukeExplosionx);
}

doNukeExplosionx() {
    level.nukeXplosion = true;
    self exitMenu();
    self setVision("sniper_inside_fire");
    earthQuake(1, 3, self.origin, 200);
    self thread doSlomox();
    playFx(loadFx("explosions/fx_mortarExp_dirt"), (-57, 288, 103));
    for (m = 0; m < 10; m++) {
        playFx(loadFx("explosions/default_explosion"), (-57, 288, 103) + (randomIntRange(-40, 40), randomIntRange(-40, 40), randomIntRange(0, 40)));
        self playLocalSound("grenade_explode");
        self playLocalSound("nuke_flash");
        wait .2;
    }
    level.nukeXplosion = undefined;
    if (self == getPlayers()[0]) {
        level thread killZombiesWithinDistance((0, 0, 0), 1000000, "flame");
        level thread jumpToRound(level.round_number + 1);
        level.moabInMap = undefined;
    }
    self setVision("berserker");
    wait 7;
    self setVision("default");
}

doSlomox() {
    for (m = .9; m >= .3; m -= .1) {
        self setClientDvar("timescale", m);
        wait .1;
    }
    wait 1;
    for (m = getTimeScale(); m <= 1.1; m += .1) {
        self setClientDvar("timescale", m);
        wait .1;
    }
}

doNukeMovementx(bool) {
    if (self.color == (1, (188 / 255), (33 / 255)))
        self thread doNukePulsex();
    for (m = 0; m < 5; m++) {
        if (m == 4) {
            self scaleOverTime(.5, 1, 30);
            self moveOverTime(.5);
            self.x += 7.5;
        } else {
            self moveOverTime(.5);
            self.x += 15;
        }
        wait .5;
    }
    if (self.GodModeIsOn == false)
        self disableGodMode();
    else
        self enableGodMode();
    if (level.modmenulobby == true)
        array_thread(getPlayers(), ::enableGodMode);
    self destroy();
}

doNukePulsex() {
    self fadeOverTime(.8);
    self.color = (.891, .195, .059);
    wait .25;
    self fadeOverTime(.8);
    self.color = (1, (188 / 255), (33 / 255));
    wait .25;
    self fadeOverTime(.8);
    self.color = (.891, .195, .059);
    wait .25;
    self fadeOverTime(.8);
    self.color = (1, (188 / 255), (33 / 255));
    wait .25;
}
createTeamBar(color, width, height, flashFrac) {
    barElem = newHudElem(self);
    barElem.x = 0;
    barElem.y = 0;
    barElem.frac = 0;
    barElem.color = color;
    barElem.sort = -2;
    barElem.shader = "white";
    barElem setShader("white", width, height);
    barElem.hidden = false;
    if (isDefined(flashFrac)) {
        barElem.flashFrac = flashFrac;
    }
    barElemFrame = newHudElem(self);
    barElemFrame.elemType = "icon";
    barElemFrame.x = 0;
    barElemFrame.y = 0;
    barElemFrame.width = width;
    barElemFrame.height = height;
    barElemFrame.xOffset = 0;
    barElemFrame.yOffset = 0;
    barElemFrame.bar = barElem;
    barElemFrame.barFrame = barElemFrame;
    barElemFrame.children = [];
    barElemFrame.sort = -1;
    barElemFrame.color = (1, 1, 1);
    barElemFrame setParent(level.uiParent);
    barElemFrame.hidden = false;
    barElemBG = newHudElem(self);
    barElemBG.elemType = "bar";
    if (!level.splitScreen) {
        barElemBG.x = -2;
        barElemBG.y = -2;
    }
    barElemBG.width = width;
    barElemBG.height = height;
    barElemBG.xOffset = 0;
    barElemBG.yOffset = 0;
    barElemBG.bar = barElem;
    barElemBG.barFrame = barElemFrame;
    barElemBG.children = [];
    barElemBG.sort = -3;
    barElemBG.color = (0, 0, 0);
    barElemBG.alpha = 0.5;
    barElemBG setParent(level.uiParent);
    if (!level.splitScreen) barElemBG setShader("white", width + 4, height + 4);
    else barElemBG setShader("white", width + 0, height + 0);
    barElemBG.hidden = false;
    return barElemBG;
}