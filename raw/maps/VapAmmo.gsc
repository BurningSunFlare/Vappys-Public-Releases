#include common_scripts\utility;
#include maps\_utility;
#include maps\_hud_util;
#include maps\_load_common;
#include maps\_zombiemode_utility;
#include maps\Vapp;
WeaponRefill(weapon){
if	( 
		isSubStr( weapon, "zombie_perk_bottle" )
		|| is_equipment( weapon )
	)
	return;
	clip = undefined;
	Cust = undefined;
	ammo = undefined;
	SPammo = undefined;
	SPclip = undefined;
	Variable = undefined;
	Function = undefined;
	CurrentAmmo = undefined;
	Text = undefined;
	Chars = undefined;
	//self SwitchToWeapon(weapon); //Cancel reload to bypass accidental clip size. EDIT: This is now useless with the new system!
	//if(IsDefined(level.threegun_hacked))
	switch(weapon){
		//Grenados
		case "frag_grenade_zm":ammo = 2;clip = 2;SPclip = 4;break;
		case "zombie_cymbal_monkey":ammo = 2;clip = 1;SPclip = 2;break;
		case "claymore_zm":ammo = 1;clip = 1;break;
		case "spikemore_zm":ammo = 1;clip = 1;break;
		case "sticky_grenade_zm":ammo = 2;clip = 2;SPclip = 4;break;
		case "zombie_black_hole_bomb":ammo = 2;clip = 1;SPclip = 2;break;
		case "zombie_quantum_bomb":ammo = 2;clip = 1;SPclip = 2;break;
		case "zombie_nesting_dolls":ammo = 2;clip = 1;SPclip = 3;break;
		case "stielhandgranate":clip = 3;ammo = 1;SPclip = 3;break;
		case "mine_bouncing_betty":clip = 1;ammo = 1;break;
		//Wonder Weapons
		case "crossbow_explosive_zm": ammo = 12; SPammo = 18; clip = 1; SPclip = 2; break;
		case "crossbow_explosive_upgraded_zm": ammo = 12; SPammo = 18; clip = 1; SPclip = 2; break;
		case "defaultweapon":Chars = 8;Text = "Random +"; Function = ::NoReload;wait .1; ammo = 125; clip = 10; SPclip = 15; if (isDefined(self.jiggly_upgraded)) Cust = 175; else Cust = 125; break;
		case "defaultweapon_upgraded_zm":break;
		case "minigun_zm":wait .1; Chars = 6;Text = "sDmg +";Function = ::MiniAmmo;if (isDefined(self.Death_Upgraded)) Cust = 600; else Cust = 300; wait .1;break;
		case "minigun_upgraded_zm": Function = ::MiniAmmo;cust = 600;wait .1;break;
		case "freezegun_zm": ammo = 24; SPammo = 36; clip = 6; SPclip = 9; break; //modded. Default ammo = 24
		case "freezegun_upgraded_zm": ammo = 36; SPammo = 54; clip = 9; SPclip = 14; break; //modded. Default ammo = 36
		case "humangun_zm": clip = 3; SPclip = 5; ammo = 9; SPammo = 14; break;
		case "humangun_upgraded_zm": clip = 6; SPclip = 9; ammo = 18; SPammo = 27; break;
		case "thundergun_zm": clip = 2; SPclip = 3; ammo = 12; SPammo = 16; break;
		case "thundergun_upgraded_zm": clip = 4; SPclip = 6; ammo = 24; SPammo = 34; break;
		case "knife_ballistic_sickle_zm": clip = 1; SPclip = 2; ammo = 4; SPammo = 6; break;
		case "knife_ballistic_sickle_upgraded_zm": clip = 1; SPclip = 2; ammo = 9; SPammo = 13; break;
		case "knife_ballistic_zm": clip = 1; SPclip = 2; ammo = 4; SPammo = 6; break;
		case "knife_ballistic_upgraded_zm": clip = 1; SPclip = 2; ammo = 9; SPammo = 13; break;
		case "knife_ballistic_bowie_zm": clip = 1; SPclip = 2; ammo = 4; SPammo = 6; break;
		case "knife_ballistic_bowie_upgraded_zm": clip = 1; SPclip = 2; ammo = 9; SPammo = 13; break;
		case "microwavegundw_zm": clip = 8; SPclip = 12; ammo = 64; SPammo = 97; break;
		case "microwavegundw_upgraded_zm": clip = 12; SPclip = 18; ammo = 100; SPammo = 152; break;
		case "microwavegun_upgraded_zm": clip = 4; SPclip = 6; ammo = 24; SPammo = 36; break;
		case "microwavegun_zm": clip = 2; SPclip = 3; ammo = 10; SPammo = 15; break;
		case "ray_gun_zm": clip = 20; SPclip = 31; ammo = 160; SPammo = 243; break;
		case "ray_gun_upgraded_zm": clip = 40; SPammo = 304; SPclip = 61; ammo = 200; break;
		case "shrink_ray_zm": clip = 5; SPclip = 8; ammo = 25; SPammo = 38; break;
		case "shrink_ray_upgraded_zm": clip = 8; SPclip = 12; ammo = 40; SPammo = 61; break;
		case "sniper_explosive_zm": clip = 3; SPclip = 5; ammo = 15; SPammo = 22; break;
		case "sniper_explosive_upgraded_zm": clip = 6; SPclip = 9; ammo = 30; SPammo = 45; break;
		case "tesla_gun_zm": clip = 3; SPclip = 5; ammo = 15; SPammo = 22; break;
		case "tesla_gun_upgraded_zm": clip = 6; SPclip = 9; ammo = 30; SPammo = 45; break;
		case "ak74u_zm": clip = 20; SPclip = 30; ammo = 160; SPammo = 243; break;
		case "ak74u_upgraded_zm": clip = 40; SPclip = 61; ammo = 280; SPammo = 425; break;
		case "aug_acog_zm": clip = 30; SPclip = 46; ammo = 270; SPammo = 410; break;
		case "aug_acog_mk_upgraded_zm": clip = 30; SPclip = 46; ammo = 390; SPammo = 592; break;
		case "mk_aug_upgraded_zm": clip = 6; SPclip = 9; ammo = 30; SPammo = 45; break;
		case "famas_zm": clip = 30; SPclip = 46; ammo = 150; SPammo = 228; break;
		case "famas_upgraded_zm": clip = 45; SPclip = 69; ammo = 225; SPammo = 342; break;
		case "china_lake_zm": clip = 2; SPclip = 3; ammo = 20; SPammo = 30; break;
		case "china_lake_upgraded_zm": clip = 5; SPclip = 8; ammo = 40; SPammo = 61; break;
		case "commando_zm": clip = 30; SPclip = 46; ammo = 270; SPammo = 410; break;
		case "commando_upgraded_zm": clip = 40; SPclip = 61; ammo = 360; SPammo = 547; break;
		case "cz75_zm": clip = 15; SPclip = 23; ammo = 135; SPammo = 205; break;
		case "cz75_upgraded_zm": clip = 20; SPclip = 30; ammo = 240; SPammo = 364; break;
		case "cz75dw_zm": clip = 12; SPclip = 18; ammo = 228; SPammo = 346; break;
		case "cz75dw_upgraded_zm": clip = 20; SPclip = 30; ammo = 320; SPammo = 486; break;
		case "dragunov_zm": clip = 10; SPclip = 15; ammo = 40; SPammo = 60; break;
		case "dragunov_upgraded_zm": clip = 10; SPclip = 15; ammo = 80; SPammo = 121; break;
		case "fnfal_zm": clip = 20; SPclip = 30; ammo = 180; SPammo = 273; break;
		case "fnfal_upgraded_zm": clip = 30; SPclip = 46; ammo = 360; SPammo = 547; break;
		case "g11_lps_zm": clip = 48; SPclip = 73; ammo = 144; SPammo = 218; break;
		case "g11_lps_upgraded_zm": clip = 48; SPclip = 73; ammo = 288; SPammo = 438; break;
		case "galil_zm": clip = 35; SPclip = 53; ammo = 315; SPammo = 478; break;
		case "galil_upgraded_zm": clip = 35; SPclip = 53; ammo = 490; SPammo = 745; break;
		case "l96a1_zm": clip = 5; SPclip = 8; ammo = 45; SPammo = 68; break;
		case "l96a1_upgraded_zm": clip = 8; SPclip = 12; ammo = 72; SPammo = 109; break;
		case "m14_zm": clip = 8; SPclip = 12; ammo = 96; SPammo = 145; break;
		case "m14_upgraded_zm": clip = 16; SPclip = 24; ammo = 192; SPammo = 291; break;
		case "m16_zm": clip = 30; SPclip = 46; ammo = 120; SPammo = 182; break;
		case "m16_gl_upgraded_zm": clip = 30; SPclip = 46; ammo = 270; SPammo = 410; break;
		case "gl_m16_upgraded_zm": clip = 1; SPclip = 2; ammo = 8; SPammo = 12; break;
		case "hs10_zm": clip = 6; SPclip = 9; ammo = 36; SPammo = 54; break;
		case "hs10_upgraded_zm": clip = 8; SPclip = 12; ammo = 80; SPammo = 121; break;
		case "m1911_upgraded_zm": ammo = 50; SPammo = 76; clip = 6; SPclip = 9; break;
		case "m1911_zm": ammo = 80; SPammo = 121; clip = 8; SPclip = 12; break;
		
		case "m1911_sp": ammo = 70; SPammo = 112; clip = 7; SPclip = 12; break;
		case "m16_sp": clip = 30; SPclip = 46; ammo = 180; SPammo = 240; break;
		
		case "m72_law_zm": clip = 1; SPclip = 2; ammo = 20; SPammo = 30; break;
		case "m72_law_upgraded_zm": clip = 10; SPclip = 15; ammo = 40; SPammo = 60; break;
		case "mp5k_zm": clip = 30; SPclip = 46; ammo = 120; SPammo = 182; break;
		case "mp5k_upgraded_zm": clip = 40; SPclip = 61; ammo = 200; SPammo = 304; break;
		case "mp40_zm": clip = 32; SPclip = 49; ammo = 192; SPammo = 291; break; //Modded. Default ammo = 192
		case "mp40_upgraded_zm": clip = 64; SPclip = 98; ammo = 256; SPammo = 389; break; //Modded. Default ammo = 192
		case "mpl_zm": clip = 24; SPclip = 37; ammo = 120; SPammo = 182; break;
		case "mpl_upgraded_zm": clip = 40; SPclip = 61; ammo = 200; SPammo = 304; break;
		case "pm63_zm": clip = 20; SPclip = 30; ammo = 100; SPammo = 152; cust = 21; break;
		case "pm63_upgraded_zm": clip = 25; SPclip = 38; ammo = 225; SPammo = 342; break;
		case "python_zm": clip = 6; SPclip = 9; ammo = 84; SPammo = 127; break;
		case "python_upgraded_zm": clip = 12; SPclip = 18; ammo = 96; SPammo = 145; break;
		case "hk21_zm": clip = 125; SPclip = 190; ammo = 500; SPammo = 760; break;
		case "hk21_upgraded_zm": clip = 150; SPclip = 228; ammo = 750; SPammo = 1140; break;
		case "rottweil72_zm": clip = 2; SPclip = 3; ammo = 38; SPammo = 57; break;
		case "rottweil72_upgraded_zm": clip = 2; SPclip = 3; ammo = 60; SPammo = 91; break;
		case "rpk_zm": clip = 100; SPclip = 152; ammo = 400; SPammo = 608; break;
		case "rpk_upgraded_zm": clip = 125; SPclip = 190; ammo = 500; SPammo = 760; break;
		case "spas_zm": clip = 8; SPclip = 12; ammo = 32; SPammo = 48; break;//modded. Default ammo = 72
		case "spas_upgraded_zm": clip = 24; SPclip = 37; ammo = 96; SPammo = 145; break;//modded. Default ammo = 72
		case "spectre_zm": clip = 30; SPclip = 46; ammo = 120; SPammo = 182; break;
		case "spectre_upgraded_zm": clip = 45; SPclip = 69; ammo = 225; SPammo = 342; break;
		case "ithaca_zm": clip = 6; SPclip = 9; ammo = 54; SPammo = 82; break;
		case "ithaca_upgraded_zm": clip = 10; SPclip = 15; ammo = 60; SPammo = 91; break; //modded. Default ammo = 60
		case "zombie_thompson": clip = 20; SPclip = 30; ammo = 200; SPammo = 304; break;
		case "zombie_thompson_upgraded": clip = 40; SPclip = 61; ammo = 250; SPammo = 380; break;
		case "zombie_shotgun": clip = 6; SPclip = 9; ammo = 60; SPammo = 91; break;// Modded. Default ammo = 60
		case "zombie_shotgun_upgraded": clip = 10; SPclip = 15; ammo = 80; SPammo = 121; break;// Modded. Default ammo = 60
		case "zombie_doublebarrel_sawed": clip = 2; SPclip = 3; ammo = 80; SPammo = 121; break;// Modded. Default ammo = 60
		case "zombie_doublebarrel": clip = 2; SPclip = 3; ammo = 60; SPammo = 91; break;
		case "zombie_doublebarrel_upgraded": clip = 2; SPclip = 3; ammo = 80; SPammo = 121; break;//Modded. Default ammo = 60
		case "zombie_bar": clip = 20; SPclip = 30; ammo = 140; SPammo = 212; break;
		case "zombie_m1carbine": clip = 15; SPclip = 23; ammo = 120; SPammo = 182; break;
		case "zombie_m1carbine_upgraded": clip = 15; SPclip = 23; ammo = 150; SPammo = 228; break;
		case "zombie_fg42": clip = 32; SPclip = 49; ammo = 192; SPammo = 291; break;
		case "zombie_fg42_upgraded": clip = 64; SPclip = 98; ammo = 400; SPammo = 608; break;
		case "zombie_stg44": clip = 30; SPclip = 46; ammo = 180; SPammo = 273; break;
		case "zombie_stg44_upgraded": clip = 60; SPclip = 91; ammo = 300; SPammo = 456; break;
		case "zombie_type100_smg": clip = 30; SPclip = 46; ammo = 160; SPammo = 243; break;
		case "zombie_type100_smg_upgraded": clip = 60; SPclip = 91; ammo = 220; SPammo = 334; break;
		case "kar98k_scoped_zombie": clip = 5; SPclip = 8; ammo = 50; SPammo = 76; break;
		case "zombie_kar98k": clip = 5; SPclip = 8; ammo = 50; SPammo = 76; break;
		case "zombie_kar98k_upgraded": clip = 8; SPclip = 12; ammo = 60; SPammo = 91; break;
		case "zombie_gewehr43": clip = 10; SPclip = 15; ammo = 120; SPammo = 182; break;
		case "zombie_gewehr43_upgraded": clip = 12; SPclip = 18; ammo = 170; SPammo = 258; break;
		case "zombie_type99_rifle": clip = 5; SPclip = 8; ammo = 50; SPammo = 85; break;
		case "zombie_m1garand": clip = 8; SPclip = 12; ammo = 128; SPammo = 156; break;
		case "zombie_bar_bipod": clip = 20; SPclip = 30; ammo = 140; SPammo = 212; break;
		case "syrette_sp": 
		case "bowie_knife_zm": 
		case "knife_zm": 
		case "zombie_knuckle_crack":
		case "zombie_bowie_flourish":
		case "zombie_sickle_flourish":
		case "equip_gasmask_zm":
		case "lower_equip_gasmask_zm":
		break;
		default:ammo = 1;clip = 1;iprintlnbold( "Weapon Ammo Broke: " + weapon );break;
		}
	CurrentAmmo = Ammo;
	self setWeaponAmmoClip( weapon,clip );
	self setWeaponAmmoStock( weapon,CurrentAmmo );
	if( isDefined( Cust ) )
			self thread Custom_Ammo( Weapon, Cust, Variable, Function, Text, Chars );
	if( ( IsDefined( level.threegun_hacked ) ) )
	{
		self setWeaponAmmoClip( weapon,SPclip );
		if( IsDefined( SPammo ) && SPammo > 1 )
		self thread Weapon_Reload( Weapon, ammo, SPammo - ammo );
		//self iprintln( weapon + " Ammo: " + ammo +" Clip: " + clip);
	}
}

MiniAmmo(h, h2, Weapon)
{
	self.Cust_Weap_Ammo["minigun_zm"] = 2;
	self waittill_any
	(
	"disconnect",
	"death",
	"zmb_max_ammo",
	"And_minigun_zm"
	);
	self.Cust_Weap_Ammo["minigun_zm"] = 0;
}

AmmoThing(Weapon)
{
	self endon( "disconnect" );
	self endon( "death" );
	self endon( "And_" + Weapon );
	self endon( "zmb_max_ammo" );
	for(;;)
	{
		self waittill("weapon_fired");
		self notify("Go_Ahead_" + Weapon);
		self.NeedUpdateAm = true;
		wait .05;
	}
}
AmmoThing2(Weapon)
{
	self endon( "disconnect" );
	self endon( "death" );
	self endon( "And_" + Weapon );
	self endon( "zmb_max_ammo" );
	for(;;)
	{
		wait .25;
		self notify("Go_Ahead");
	}
}

Custom_Ammo( Weapon, Extra_Ammo, Variable, Function, Text, Chars )
{
	Extra_Ammo ++;
	wait .1;
	if(!IsDefined( Chars) )
		chars = 1;
	self endon("disconnect");
	self endon("death");
	self endon("And_" + Weapon);
	self endon( "zmb_max_ammo" );
	primaryWeapons = self GetWeaponsListPrimaries();
	Has_Weapon = undefined;
	Text_On = undefined;
	Clip = self GetWeaponAmmoClip( Weapon );
	Weapon_Did_Change = undefined;
	Skip = undefined;
	SkipOwwie = undefined;
	
	Amm = self maps\_physics::createText(100, undefined, "LEFT", "CENTER", 0 - Chars, 160, undefined, undefined, undefined);
	Amm.color = (0.5, 0.1, 1);
	Amm.fontScale = 1.25;
	//if( !IsDefined( Text ) )
	//	Amm setText( "+" );
	//else
	//	Amm setText( Text );
	Amm2 = self maps\_physics::createText(100, undefined, "LEFT", "CENTER", 12, 160, undefined, undefined, undefined);
	Amm2.color = (0.5, 0.1, 1);
	Amm2.fontScale = 1.25;
	//Amm2 SetValue( Extra_Ammo );
	self thread Delete_On_Notify( Amm, "And_" + Weapon, "zmb_max_ammo", "And_Text_" + Weapon, undefined, "And_Ammo: " + Weapon );
	self thread Delete_On_Notify( Amm2, "And_" + Weapon, "zmb_max_ammo", "And_Text_" + Weapon, undefined, "And_Ammo: " + Weapon );
	
	if( !IsPrimaryWeapon() )
		self notify( "And_" + Weapon );
	wait .1;
	To_Minus = Extra_Ammo;
	for(;;)
	{
		self waittill_any( "weapon_fired", "weapon_change_complete" );
		if( IsDefined( Skip ) )
		{
			Skip = undefined;
			continue;
		}
		while( Weapon != self getCurrentWeapon()  )
		{
			Amm setText(" ");
			Amm2 setText(" ");
			Text_On = undefined;
			Weapon_Did_Change = Weapon;
			Skip = true;
			wait .1;
			//iprintln( "weapon stowed away" );
		}
		
		if( IsDefined( Skip ) )
		{
			//SkipOwwie = true;
			Amm setText("+");
			Amm2 SetValue( To_Minus );
			wait .05;
			continue;
		}
		if(!self maps\_laststand::player_is_in_laststand() && Weapon == self getCurrentWeapon() )
		{

				To_Minus --;
				if( IsDefined( Function ) )
					self thread [[ Function ]]( To_Minus, Variable, Weapon );
				if(To_Minus < 1)
				{
					self notify( "And_" + Weapon );
				}
					//self setWeaponAmmoStock( Weapon, Current_Ammo );
				Has_Weapon = false;
				primaryWeapons = self GetWeaponsListPrimaries();
				for(i = 0; i < primaryWeapons.size; i++)
				{
					if(Weapon == primaryWeapons[i])
						Has_Weapon = true;
				}
				if( Has_Weapon == false )
				{
					self notify( "And_" + Weapon );
					self notify( "And_Text_" + Weapon );
				}
				else
				{
					Text_On = true;
					Weapon_Did_Change = undefined;
					Amm setText("+");
					Amm2 SetValue( To_Minus );
				}
			}
		wait .1;
	}
}


NuhUhuHNu( Weapon, Custom_Ammo, Variable, Function )
{
	
	self endon( "disconnect" );
	self endon( "death" );
	self endon( "And_" + Weapon );
	self endon( "zmb_max_ammo" );
	self thread AmmoThing(Weapon);
	self thread AmmoThing2(Weapon);
	Has_Weapon = undefined;
	Text_On = undefined;
	Clip = self GetWeaponAmmoClip( Weapon );
	Weapon_Did_Change = undefined;
	
	Amm = self maps\_physics::createText(100, undefined, "CENTER", "CENTER", 300, 160, 300, 100, undefined);
    Amm.color = (0.5, 0.1, 1);
    Amm.fontScale = 1.25;

    Amm2 = self maps\_physics::createText(100, undefined, "CENTER", "CENTER", 317, 160, 300, 100, undefined);
    Amm2.color = (0.5, 0.1, 1);
    Amm2.fontScale = 1.25;
	
	Amm setText("+");
	Amm2 SetValue(Custom_Ammo);
	
	self thread Delete_On_Notify( Amm, "And_" + Weapon, "zmb_max_ammo", "End_Textz_" + Weapon, undefined, "End_Custom: " + Weapon );
	self thread Delete_On_Notify( Amm2, "And_" + Weapon, "zmb_max_ammo", "End_Textz_" + Weapon, undefined, "End_Custom: " + Weapon );
	for(;;)
	{
		if( Weapon != self getCurrentWeapon() &&  Weapon_Did_Change != Weapon )
		{
			//self notify( "End_Textz_" + Weapon );
			Amm setText(" ");
			Amm2 setText(" ");
			Weapon_Did_Change = Weapon;
			self waittill( "weapon_change_complete" );
			continue;
		}
		if(!self maps\_laststand::player_is_in_laststand() && Weapon == self getCurrentWeapon() )
		{
			Has_Weapon = false;
				if(Custom_Ammo < 1)
				{
					self notify( "And_" + Weapon );
				}
			else
			{
					if( !IsDefined( level.SuperAmmo ) && IsDefined(self.NeedUpdateAm) )
					{
						Custom_Ammo --;
						self.NeedUpdateAm = undefined;
					}
				if( IsDefined( Function ) )
					self thread [[ Function ]]( Custom_Ammo, Variable, Weapon );
			}
			primaryWeapons = self GetWeaponsListPrimaries();
			for(i = 0; i < primaryWeapons.size; i++)
			{
				if(Weapon == primaryWeapons[i])
					Has_Weapon = true;
			}
			if( Has_Weapon == false )
			{
				self notify( "And_" + Weapon );
				self notify( "End_Textz_" + Weapon );
			}
			else
			{
			
				Weapon_Did_Change = undefined;
				Amm setText("+");
				Amm2 SetValue(Custom_Ammo);
				Text_On = true;
			}
		}
		self waittill_any("Go_Ahead","Go_Ahead_" + Weapon);
		if( !IsDefined( self.NeedUpdateAm ) )
		{
			wait .1;
			continue;
		}
			
	}
	
}

Weapon_Reload( Weapon, Current_Ammo, Extra_Ammo )
{
	self endon("disconnect");
	self endon("death");
	self endon("End_" + Weapon);
	self endon( "zmb_max_ammo" );
	primaryWeapons = self GetWeaponsListPrimaries();
	Has_Weapon = undefined;
	Text_On = undefined;
	Clip = self GetWeaponAmmoClip( Weapon );
	Weapon_Did_Change = undefined;
	
	Amm = self maps\_physics::createText(100, undefined, "CENTER", "CENTER", 330, 160, 300, 100, undefined);
	Amm.color = (0.1, 0.5, 1);
	Amm.fontScale = 1.25;
	Amm setText( "+" );
	Amm2 = self maps\_physics::createText(100, undefined, "CENTER", "CENTER", 342, 160, 300, 100, undefined);
	Amm2.color = (0.1, 0.5, 1);
	Amm2.fontScale = 1.25;
	Amm2 SetValue( Extra_Ammo );
	self thread Delete_On_Notify( Amm, "End_" + Weapon, "zmb_max_ammo", "End_Text_" + Weapon, undefined, "End_Ammo: " + Weapon );
	self thread Delete_On_Notify( Amm2, "End_" + Weapon, "zmb_max_ammo", "End_Text_" + Weapon, undefined, "End_Ammo: " + Weapon );
	
	if( !IsPrimaryWeapon() )
		self notify( "End_" + Weapon );
	wait .1;
	self setWeaponAmmoStock( Weapon, Current_Ammo );
	To_Minus = self GetWeaponAmmoStock( Weapon );
	for(;;)
	{
		if( Weapon != self getCurrentWeapon() &&  Weapon_Did_Change != Weapon ){
		Amm setText(" ");
		Amm2 setText(" ");
		Text_On = undefined;
		Weapon_Did_Change = Weapon;
		self waittill( "weapon_change_complete" );
		continue;
		}
		if(!self maps\_laststand::player_is_in_laststand() && Weapon == self getCurrentWeapon() )
		{
			if(To_Minus != self GetWeaponAmmoStock( Weapon ) )
			{
				OrigAmmo = self GetWeaponAmmoStock( Weapon );
				To_Minus -= self GetWeaponAmmoStock( Weapon );
				Extra_Ammo -= To_Minus;
				if(Extra_Ammo < 1)
				{
					self setWeaponAmmoStock( Weapon, OrigAmmo + Extra_Ammo + Clip );
					self notify( "End_" + Weapon );
				}
				else
					self setWeaponAmmoStock( Weapon, Current_Ammo );
			}
			To_Minus = self GetWeaponAmmoStock(Weapon);
			Has_Weapon = false;
			primaryWeapons = self GetWeaponsListPrimaries();
			for(i = 0; i < primaryWeapons.size; i++)
			{
				if(Weapon == primaryWeapons[i])
					Has_Weapon = true;
			}
			if( Has_Weapon == false )
			{
				self notify( "End_" + Weapon );
				self notify( "End_Text_" + Weapon );
			}
			else
			{
				Text_On = true;
				Weapon_Did_Change = undefined;
				Amm setText("+");
				Amm2 SetValue(Extra_Ammo);
			}
		}
		wait .4;
	}
}

IsPrimaryWeapon( Weapon )
{
	if(self.sessionstate == "spectator")
		return false;
	primaryWeapons = self GetWeaponsListPrimaries();
	for(i = 0; i < primaryWeapons.size; i++)
		if(Weapon == primaryWeapons[i]
	|| Weapon == "microwavegun_zm"
	|| Weapon == "microwavegun_upgraded_zm"
	|| Weapon == "gl_m16_upgraded_zm"
	|| Weapon == "mk_aug_upgraded_zm"
	)
			return true;
		return false;
}

NoReload(Ammo, h2, Weapon)
{
	self setWeaponAmmoStock(Weapon,0);
	self setWeaponAmmoClip(Weapon,Ammo);
}