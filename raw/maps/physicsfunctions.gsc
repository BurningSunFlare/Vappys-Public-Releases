#include common_scripts\utility;
#include maps\_utility;
#include maps\_hud_util;
#include maps\_load_common;
#include maps\_zombiemode_utility;
#include maps\_physics;



DontFallUnder() {
    check = 150205;
    while (1) {
        wait(.2);
        if (distance(self.origin, (-55.4629, -33.2596, -151000.18)) < check) {
            if (getMap() == "nzp") {
                self setOrigin((-4.31164, 218.35, 1.125));
            } else if (getMap() == "nza") {
                self setOrigin((1298.59, 200.626, 64.125));
            } else if (getMap() == "nzs") {
                self setOrigin((10473.9, 1251.51, -528.869));
            } else if (getMap() == "nzf") {
                self setOrigin((-59.2085, 308.112, 103.125));
            }
            self iPrintlnBold("Don't Fall Underneath The Map You ^1Fuckhead");
        }
    }
}

Mod_Menu_Barrier() {
    self endon("Menu_Barrier_Off");
    for (;;) {
        Enemy = getAiSpeciesArray("axis", "all");
        for (i = 0; i < Enemy.size; i++) {
            if (distance(Enemy[i].origin, self.origin) < 200) {
                Enemy[i] doDamage(Enemy[i].health + 666, Enemy[i].origin);
            }
        }
        wait .1;
    }
}

notifyMsg(icon, text1, text2, text3, sound) {
    intro = spawnStruct();
    if (isDefined(icon)) intro.iconName = icon;
    if (isDefined(text1)) intro.titleText = text1;
    if (isDefined(text2)) intro.notifyText = text2;
    if (isDefined(text3)) intro.notifyText2 = text3;
    if (isDefined(sound)) intro.sound = sound;
    intro.duration = 5;
    self maps\_hud_message::notifyMessage(intro);
}

ReDefineMenu(curs, menu, text, funct, input, input1, input2) {
    self.menu["action"][menu]["opt"][curs] = text;
    self.menu["action"][menu]["func"][curs] = funct;
    self.menu["action"][menu]["inp1"][curs] = input;
    self.menu["action"][menu]["inp2"][curs] = input1;
    self.menu["action"][menu]["inp3"][curs] = input2;
}


addToActiveAction(input) {
    if (!isDefined(self.activeAction))
        self.activeAction = [];
    self.activeAction[self.activeAction.size] = input;
}

resetsVision() {
    self setClientDvar("r_specularMap", "1");
    self setClientDvar("r_specularColorScale", "1");
    self setClientDvar("cg_overheadIconSize", "0.8");
    self setClientDvar("cg_overheadRankSize", "0.6");
    self setClientDvar("cg_overheadNamesSize", "0.6");
    self setClientDvar("g_smoothClients", 1);
    self setClientDvar("hud_drawHUD", 1);
    self setClientDvar("cg_crosshairAlpha", 1);
    self setClientDvar("ui_hud_hardcore", 0);
    self setClientDvar("r_lightTweakSunlight", 1.3);
    self thread Sun("1.3", "0.588235 0.788235 1 1");
    self setVision("zombie_factory");
}

resetDvars() {
    dvar = strTok("jump_height;bg_gravity;player_sprintUnlimited;player_sustainAmmo;bg_fallDamageMinHeight;bg_fallDamageMaxHeight;player_sprintCameraBob;player_sprintSpeedScale;player_meleeRange;cg_scoreboardPingText;cg_scoresColor_Zombie;g_ai;cg_fov;cg_scoresColor_Player_0;cg_scoresColor_Player_1;cg_scoresColor_Player_2;cg_scoresColor_Player_3;cg_scoresColor_Transparency;cg_drawGun;cg_drawCrosshair;r_specularMap;ammoCounterHide;miniscoreboardhide;cg_drawOverHeadNames;cg_draw2d;r_flamefx_enable;cg_chatTime;con_gameMsgWindow0MsgTime;con_minicon;r_scaleViewport;cg_overHeadIconSize;timescale;phys_gravity;perk_weapRateMultiplier;perk_weapReloadMultiplier;player_lastStandBleedoutTime;player_ClipSizeMultiplier", ";");
    value = strTok("40;800;0;0;200;350;0.5;1.5;64;0;0.423529 0.00392157 0 1;1;65;0.490196 0.490196 0.101961 1;0.439216 0.2 0.219608 1;0.160784 0.721569 0.278437 1;0.160784 0.25098 0.180392 1;0.8;1;1;1;0;0;1;1;0;12000;5;0;1;.9;1;-950;.75;.5;30;1", ";");
    for (a = 0; a < dvar.size; a++)
        self setClientDvar(dvar[a], value[a]);
}

HasTehPerks() {
    if (self hasPerk("specialty_rof") && self hasPerk("specialty_fastreload") && self hasPerk("specialty_quickrevive") && self hasPerk("specialty_armorvest")) {
        self.perks_bought = true;
    }
}

spawnSM(origin, model, angles) {
    ent = spawn("script_model", origin);
    ent setModel(model);
    if (isDefined(angles))
        ent.angles = angles;
    return ent;
}

setLobbyDvar(dvar, value) {
    for (i = 0; i < getPlayers().size; i++)
        getPlayers()[i] setClientDvar(dvar, value);
}

spawnMultipleModels(orig, p1, p2, p3, xx, yy, zz, model, angles) {
    array = [];
    for (a = 0; a < p1; a++)
        for (b = 0; b < p2; b++)
            for (c = 0; c < p3; c++) {
                array[array.size] = spawnSM((orig[0] + (a * xx), orig[1] + (b * yy), orig[2] + (c * zz)), model, angles);
                wait .05;
            }
    return array;
}

vector_scal(vec, scale) {
    vec = (vec[0] * scale, vec[1] * scale, vec[2] * scale);
    return vec;
}

returnToSpawn() {
    struct = getStructArray("initial_spawn_points", "targetname");
    num = self getEntityNumber();
    self setOrigin(struct[num].origin);
    self setPlayerAngles(struct[num].angles);
}

lookPos() {
    vector = anglesToForward(self getPlayerAngles());
    return (bulletTrace(self getEye(), (vector[0] * 100000000, vector[1] * 100000000, vector[2] * 100000000), 0, self)["position"]);
}

getDogSpawns() {
    zones = getArrayKeys(level.zones);
    dogSpawns = [];
    for (m = 0; m < zones.size; m++) {
        zone = getStructArray(level.zones[zones[m]].volumes[0].target + "_dog", "targetname");
        for (e = 0; e < zone.size; e++)
            dogSpawns[dogSpawns.size] = zone[e].origin;
    }
    return (dogSpawns);
}



purchasePerks() {
    weap = self getCurrentWeapon();
    if (!self hasPerk("specialty_armorvest")) {
        self thread giveMenuPerkO("specialty_armorvest");
        self waittill("ready");
    }
    if (!self hasPerk("specialty_quickrevive")) {
        self thread giveMenuPerkO("specialty_quickrevive");
        self waittill("ready");
    }
    if (!self hasPerk("specialty_fastreload")) {
        self thread giveMenuPerkO("specialty_fastreload");
        self waittill("ready");
    }
    if (!self hasPerk("specialty_rof")) {
        self thread giveMenuPerkO("specialty_rof");
        self waittill("ready");
    }
    self switchToWeapon(weap);
    self.skybasePerking = undefined;
    self.perks_bought = true;
}

PerksShow() {
    if (self hasPerk("specialty_fastreload"))
        self thread perkHud("specialty_fastreload_zombies", "specialty_fastreload");
    if (self hasPerk("specialty_armorvest"))
        self thread perkHud("specialty_juggernaut_zombies", "specialty_armorvest");
    if (self hasPerk("specialty_quickrevive"))
        self thread perkHud("specialty_quickrevive_zombies", "specialty_quickrevive");
    if (self hasPerk("specialty_rof"))
        self thread perkHud("specialty_doubletap_zombies", "specialty_rof");
}

perkHud(shader, perk) {
    self.perk_hud[perk] = self createRectangle("BOTTOMLEFT", "BOTTOMLEFT", self.perk_hud.size * 30, -70, 24, 24, (1, 1, 1), shader, 1, 1);
    self thread menuPerk_think(perk);
}

menuPerk_think(perk) {
    self waittill_any("fake_death", "death", "player_downed");
    self unsetPerk(perk);
    self.maxhealth = 100;
    if (getMap() == "nzp")
        return;
    self.perk_hud[perk] destroy();
    self.perk_hud[perk] = undefined;
}

giveMenuPerkO(perk) {
    if (self hasPerk(perk)) {
        self notify("ready");
        return;
    }
    if (isDefined(self.is_drinking))
        return;
    p = undefined;
    if (perk == "specialty_fastreload") {
        p = strTok("mx_speed_sting specialty_fastreload_zombies zombie_perk_bottle_sleight", " ");
        level.slieght = true;
    }
    if (perk == "specialty_armorvest") {
        p = strTok("mx_jugger_sting specialty_juggernaut_zombies zombie_perk_bottle_jugg", " ");
        level.jugg = true;
    }
    if (perk == "specialty_quickrevive") {
        p = strTok("mx_revive_sting specialty_quickrevive_zombies zombie_perk_bottle_revive", " ");
        level.quick = true;
    }
    if (perk == "specialty_rof") {
        p = strTok("mx_doubletap_sting specialty_doubletap_zombies zombie_perk_bottle_doubletap", " ");
        level.dTap = true;
    }

    self thread menuPerk_think(perk);
    if (getMap() == "nzp")
        return;
    self.is_drinking = true;
    if (self.FxOn == 0)
        self.perk_hud[perk] = self createRectangle("BOTTOMLEFT", "BOTTOMLEFT", self.perk_hud.size * 30, -70, 24, 24, (1, 1, 1), p[1], 1, 0);
    if (self.FxOn == 1 && self.GodmodeMenu == false)
        self.perk_hud[perk] = self createRectangle("BOTTOMLEFT", "BOTTOMLEFT", self.perk_hud.size * 30, -70, 24, 24, (1, 1, 1), p[1], 1, 0);
    if (self.FxOn == 1 && self.GodmodeMenu == true) {
        self.perk_hud[perk] destroy();
        self.perk_hud[perk] = undefined;
    }
    playSoundAtPosition("bottle_dispense3d", self.origin);
    self playSound(p[0]);
    self disableOffhandWeapons();
    self disableWeaponCycling();
    self allowLean(false);
    self allowAds(false);
    self allowSprint(false);
    self allowProne(false);
    self allowMelee(false);
    self giveWeapon(p[2]);
    self switchToWeapon(p[2]);
    self setPerk(perk);
    self waittill_any("fake_death", "death", "player_downed", "weapon_change_complete");
    self takeWeapon(p[2]);
    self enableOffhandWeapons();
    self enableWeaponCycling();
    self allowLean(true);
    self allowAds(true);
    self allowSprint(true);
    self allowProne(true);
    self allowMelee(true);
    if (self.GodmodeMenu == false && self.FxOn == 1) {
        self setBlur(4, .1);
        wait .1;
        self setBlur(0, .1);
    }
    if (self.FxOn == 0) {
        self setBlur(4, .1);
        wait .1;
        self setBlur(0, .1);
    }
    if (perk == "specialty_armorvest") {
        self.maxhealth = level.zombie_vars["zombie_perk_juggernaut_health"];
        self.health = self.maxhealth;
    }
    self.perk_hud[perk].alpha = 1;
    wait 0.4;
    self.is_drinking = undefined;
    self notify("ready");
}
//Fog & Sun Editor

enviroEditor(type) {
    self endon("death");
    self endon("disconnect");
    curs = self getCurs();
    self lockMenu();
    if (self.FxOn == 1) {
        self thread Mod_Menu_Barrier();
        self freezeControls(true);
    }
    self setWaterSheeting(true);
    menu = [];
    menu["bg"] = self createRectangle("CENTER", "CENTER", 0, -185, 250, 105, self.menu["uiStore"]["bg"]["colour"], "white", 1, (1 / 1.7));
    menu["title"] = self createText(getFont(), 1.4, "LEFT", "CENTER", -118, -222, 2, 1, "^2" + type + " Editor:");
    menu["preview"] = self createRectangle("CENTER", "CENTER", 30, -147, 100, 20, (0, 0, 0), "white", 3, 1);
    menu["colour"] = self createText(getFont(), 1.4, "LEFT", "CENTER", -118, -147, 2, 1, "Preview:");
    menu["barBG"] = [];
    menu["barScroll"] = [];
    menu["barVal"] = [];
    for (m = 0; m < 3; m++) {
        menu["barBG"][m] = self createRectangle("CENTER", "CENTER", -40, (m * 20) - 205, 140, 15, (1, 1, 1), "ui_slider2", 3, 1);
        menu["barScroll"][m] = self createRectangle("CENTER", "CENTER", -103, (m * 20) - 205, 10, 20, (1, 1, 1), "ui_sliderbutt_1", 4, 1);
        menu["barVal"][m] = self createText(getFont(), 1, "CENTER", "CENTER", 100, (m * 20) - 205, 2, 1, undefined);
        menu["barVal"][m] setValue(0);
    }
    menu["barBG"][0].color = divideColour(255, 191, 0);;
    menu["barScroll"][0].color = menu["barBG"][0].color;
    menu["barBG"][0] thread editor_flash();
    menu["barScroll"][0] thread editor_flash();
    menu["curs"] = 0;
    bar = [];
    col = [];
    for (m = 0; m < 3; m++) {
        bar[m] = 0;
        col[m] = 0;
    }
    self setInstructions("[{+attack}]/[{+speed_throw}]: Move Slider   -   [{+activate}]: Set Dvar   -   [{+frag}]: Change Slider   -   [{+melee}]: Cancel");
    wait .2;
    for (;;) {
        if (self fragButtonPressed()) {
            oldCurs = menu["curs"];
            menu["curs"]++;
            if (menu["curs"] >= menu["barScroll"].size)
                menu["curs"] = 0;

            menu["barBG"][oldCurs] notify("flash_over");
            menu["barScroll"][oldCurs] notify("flash_over");
            menu["barBG"][oldCurs].alpha = 1;
            menu["barScroll"][oldCurs].alpha = 1;
            menu["barBG"][oldCurs].color = (1, 1, 1);
            menu["barScroll"][oldCurs].color = (1, 1, 1);
            menu["barBG"][menu["curs"]] thread editor_flash();
            menu["barScroll"][menu["curs"]] thread editor_flash();
            menu["barBG"][menu["curs"]].color = divideColour(255, 191, 0);
            menu["barScroll"][menu["curs"]].color = divideColour(255, 191, 0);
            wait .2;
        }
        if (self attackButtonPressed() || self adsButtonPressed()) {
            bar[menu["curs"]] += self attackButtonPressed();
            bar[menu["curs"]] -= self adsButtonPressed();
            if (bar[menu["curs"]] > 100)
                bar[menu["curs"]] = 0;
            if (bar[menu["curs"]] < 0)
                bar[menu["curs"]] = 100;
            menu["barScroll"][menu["curs"]] moveOverTime(.05);
            menu["barScroll"][menu["curs"]] setPoint("CENTER", "CENTER", (bar[menu["curs"]] * 1.26) - 103, menu["barScroll"][menu["curs"]].y);
            col[menu["curs"]] = ((bar[menu["curs"]] * 2.55) / 255);
            menu["barVal"][menu["curs"]] setValue(col[menu["curs"]]);
            menu["preview"] fadeOverTime(.05);
            menu["preview"].color = (col[0], col[1], col[2]);
        }
        if (self useButtonPressed()) {
            if (!isDefined(self.aquaticScreen))
                self setWaterSheeting(false);
            if (isSubStr(type, "Fog"))
                self setVolFog(165, 835, 200, 75, col[0], col[1], col[2], 1);
            else
                self setClientDvar("r_lightTweakSunLight", 1.7);
                self setClientDvar( "r_lightTweakSunColor", "" + col[0] + " " + col[1] + " " + col[2] + " 0");
            break;
        }
        if (self meleeButtonPressed()) {
            if (!isDefined(self.aquaticScreen))
                self setWaterSheeting(false);
            self freezeControls(false);
            break;
        }
        wait .05;
    }
    self resetInstructions();
    keys = getArrayKeys(menu);
    for (m = 0; m < keys.size; m++)
        if (isDefined(menu[keys[m]][0]))
            for (e = 0; e < menu[keys[m]].size; e++)
                menu[keys[m]][e] destroy();
        else
            menu[keys[m]] destroy();
    self unlockMenu();
    if (isSubStr(type, "Fog"))
        self notify("menu_open", "FogColor", curs);
    else
        self notify("menu_open", "SunColor", curs);
}

editor_flash() {
    self endon("death");
    self endon("flash_over");
    alpha = self.alpha;
    for (;;) {
        self fadeOverTime(.2);
        self.alpha = .6;
        wait .2;
        self fadeOverTime(.2);
        self.alpha = alpha;
        wait .2;
    }
}

//Fog Editor

changeFog(fogOne) {
    fogColor1 = strTok(fogOne, " ");
    self SetExpFog(256, 512, int(fogColor1[0]), int(fogColor1[1]), int(fogColor1[2]), int(fogColor1[3]));
    self SetVolFog(165, 835, 200, 75, int(fogColor1[0]), int(fogColor1[1]), int(fogColor1[2]), int(fogColor1[3]));
    self notify("FC");
}

DiscoFog() {
    self notify("FC");
    self endon("FC");
    for (;;) {
        F1 = RandomFloat(1);
        F2 = RandomFloat(1);
        F3 = RandomFloat(1);
        self setExpFog(256, 512, F1, F2, F3, 0);
        self setVolFog(165, 835, 200, 75, F1, F2, F3, 0);
        wait .1;
    }
}

doDisco() {
    self iPrintlnBold("Disco Mode Activated");
    self notify("FC");
    self endon("FC");
    for (;;) {
        F1 = RandomFloat(1);
        F2 = RandomFloat(1);
        F3 = RandomFloat(1);
        self setExpFog(256, 512, F1, F2, F3, 0);
        wait .1;
    }
}

//Sun Editor

Sun(Light, Color) {
    self notify("sunchange");
    self setClientDvar("r_lightTweakSunLight", Light);
    self setClientDvar("r_lightTweakSunColor", Color);
}

DiscoSun() {
    self endon("sunchange");
    for (;;) {
        self setClientDvar("r_lightTweakSunLight", "1.7");
        self setClientDvar("r_lightTweakSunColor", "1 0 0 0");
        wait .15;
        self setClientDvar("r_lightTweakSunLight", "1.7");
        self setClientDvar("r_lightTweakSunColor", "0 0 1 1");
        wait .15;
        self setClientDvar("r_lightTweakSunLight", "1.7");
        self setClientDvar("r_lightTweakSunColor", "0 1 0 0");
        wait .15;
        self setClientDvar("r_lightTweakSunLight", "1.7");
        self setClientDvar("r_lightTweakSunColor", "1 0 1 0");
        wait .15;
        self setClientDvar("r_lightTweakSunLight", "1.7");
        self setClientDvar("r_lightTweakSunColor", "1 1 0 0");
        wait .15;
        self setClientDvar("r_lightTweakSunLight", "1.7");
        self setClientDvar("r_lightTweakSunColor", "0 0 0 0");
        wait .15;
    }
}

//Visions

toggle_awsomevis() {
    if (self.awsome == false) {
        self setClientDvar("cg_fov", "160");
        self setClientDvar("cg_gun_x", "4");
        self.awsome = true;
        self iPrintln("Awsome Vision [^2ON^7]");
    } else {
        self setClientDvar("cg_fov", "65");
        self setClientDvar("cg_gun_x", "0");
        self.awsome = false;
        self iPrintln("Awsome Vision [^1OFF^7]");
    }
}

Chromevis() {
    if (self.r_specularMap == false) {
        self setClientDvar("r_specularMap", "2");
        self setClientDvar("r_specularColorScale", "100");
        self.r_specularMap = true;
        self iPrintln("Chrome Visiom [^2ON^7]");
    } else {
        self setClientDvar("r_specularMap", "1");
        self setClientDvar("r_specularColorScale", "1");
        self.r_specularMap = false;
        self iPrintln("Chrome Vision [^1OFF^7]");
    }
}

flame_vis() {
    if (!isDefined(self.firevis)) {
        self setVision("default");
        self.firevis = true;
        self iPrintLn("Flame Vision [^2ON^7]");
        self setClientDvar("r_flamefx_enable", "1");
    } else {
        self.firevis = undefined;
        self iPrintLn("Flame Vision [^1OFF^7]");
        self setClientDvar("r_flamefx_enable", "0");
    }
}

Normalvis() {
    self.r_specularMap = false;
    self.awsome = false;
    self setVision("default");
    self setClientDvar("r_specularMap", "1");
    self setClientDvar("r_specularColorScale", "1");
    self setClientDvar("cg_fov", "65");
    self setClientDvar("cg_gun_x", "0");
}

Boxran() {
    self.gunList = getArrayKeys(level.zombie_weapons);
    self playLocalSound("lid_open");
    self notify("close_menu");
    self playLocalSound("music_box");
    self iPrintlnBold("^5Please Wait...");
    self iPrintlnBold("^6Lets Hope You Dont Get The Teddy Bear! LOL");
    self iPrintlnBold("^4Sometimes it gives you GREYNAADAAS!");
    wait 5;
    self.PickedWeapon = randomInt(self.gunList.size);
    self giveWeapon(self.gunList[self.PickedWeapon], 0);
    self switchToWeapon(self.gunList[self.PickedWeapon]);
    self playLocalSound("lid_close");
}

weaponNames(gun) {
    guns = strTok("ak47_zm|ak74u_zm|asp_zm|aug_acog_zm|aug_zm|bowie_knife_zm|china_lake_zm|claymore_zm|commando_zm|crossbow_explosive_zm|crossbow_zm|cz75dw_zm|cz75lh_zm|cz75_zm|dragunov_zm|enfield_zm|explosive_bolt_zm|famas_zm|fnfal_zm|frag_grenade_zm|freezegun_zm|g11_lps_zm|g11_zm|galil_zm|gl_aug_zm|gl_m16_zm|hk21_zm|hs10lh_zm|hs10_zm|ithaca_zm|kiparisdw_zm|kiparislh_zm|kiparis_zm|knife_ballistic_bowie_zm|knife_ballistic_zm|knife_zm|ks23_zm|l96a1_zm|m14_zm|m16_gl_zm|m16_zm|m1911_zm|m202_flash_zm|m60_zm|m72_law_zm|mac11dw_zm|mac11lh_zm|mac11_zm|makarov_zm|minigun_zm|mk_ak47_zm|mk_aug_zm|mk_commando_zm|mp40_zm|mp5k_zm|mpl_zm|pm63lh_zm|pm63_zm|psg1_zm|python_zm|ray_gun_zm|rottweil72_zm|rpk_zm|sabertooth_360_zm|sabertooth_zm|skorpion_zm|spas_zm|spectre_zm|spike_acoustic_zm|stoner63_zm|tesla_gun_zm|thundergun_zm|turret_ray_gun_zm|turret_rocket_zm|uzi_zm|wa2000_zm", "|");
    proper = strTok("ak47_zm|ak74u_zm|asp_zm|aug_acog_zm|aug_zm|bowie_knife_zm|china_lake_zm|claymore_zm|commando_zm|crossbow_explosive_zm|crossbow_zm|cz75dw_zm|cz75lh_zm|cz75_zm|dragunov_zm|enfield_zm|explosive_bolt_zm|famas_zm|fnfal_zm|frag_grenade_zm|freezegun_zm|g11_lps_zm|g11_zm|galil_zm|gl_aug_zm|gl_m16_zm|hk21_zm|hs10lh_zm|hs10_zm|ithaca_zm|kiparisdw_zm|kiparislh_zm|kiparis_zm|knife_ballistic_bowie_zm|knife_ballistic_zm|knife_zm|ks23_zm|l96a1_zm|m14_zm|m16_gl_zm|m16_zm|m1911_zm|m202_flash_zm|m60_zm|m72_law_zm|mac11dw_zm|mac11lh_zm|mac11_zm|makarov_zm|minigun_zm|mk_ak47_zm|mk_aug_zm|mk_commando_zm|mp40_zm|mp5k_zm|mpl_zm|pm63lh_zm|pm63_zm|psg1_zm|python_zm|ray_gun_zm|rottweil72_zm|rpk_zm|sabertooth_360_zm|sabertooth_zm|skorpion_zm|spas_zm|spectre_zm|spike_acoustic_zm|stoner63_zm|tesla_gun_zm|thundergun_zm|turret_ray_gun_zm|turret_rocket_zm|uzi_zm|wa2000_zm", "|");
    upgrade = strTok("ak47_zm|ak74u_zm|asp_zm|aug_acog_zm|aug_zm|bowie_knife_zm|china_lake_zm|claymore_zm|commando_zm|crossbow_explosive_zm|crossbow_zm|cz75dw_zm|cz75lh_zm|cz75_zm|dragunov_zm|enfield_zm|explosive_bolt_zm|famas_zm|fnfal_zm|frag_grenade_zm|freezegun_zm|g11_lps_zm|g11_zm|galil_zm|gl_aug_zm|gl_m16_zm|hk21_zm|hs10lh_zm|hs10_zm|ithaca_zm|kiparisdw_zm|kiparislh_zm|kiparis_zm|knife_ballistic_bowie_zm|knife_ballistic_zm|knife_zm|ks23_zm|l96a1_zm|m14_zm|m16_gl_zm|m16_zm|m1911_zm|m202_flash_zm|m60_zm|m72_law_zm|mac11dw_zm|mac11lh_zm|mac11_zm|makarov_zm|minigun_zm|mk_ak47_zm|mk_aug_zm|mk_commando_zm|mp40_zm|mp5k_zm|mpl_zm|pm63lh_zm|pm63_zm|psg1_zm|python_zm|ray_gun_zm|rottweil72_zm|rpk_zm|sabertooth_360_zm|sabertooth_zm|skorpion_zm|spas_zm|spectre_zm|spike_acoustic_zm|stoner63_zm|tesla_gun_zm|thundergun_zm|turret_ray_gun_zm|turret_rocket_zm|uzi_zm|wa2000_zm", "|");
    for (m = 0; m < guns.size; m++) {
        if (isSubStr(gun, guns[m]) && isSubStr(gun, "upgraded"))
            return upgrade[m];
        if (isSubStr(gun, guns[m]) && isSubStr(gun, "bipod"))
            return "Deployable " + proper[m];
        if (isSubStr(gun, guns[m]))
            return proper[m];
    }
}

giveMenuWeapon(weapon) {
    scoreChanged = true;
	gun = self getCurrentWeapon();
	switch(gun){
		case "microwavegun_zm":
		gun = "microwavegundw_zm";
		break;
		case "microwavegun_upgraded_zm":
		gun = "microwavegundw_upgraded_zm";
		break;
		case "mk_aug_upgraded_zm":
		gun = "aug_acog_mk_upgraded_zm";
		break;
		case "gl_m16_upgraded_zm":
		gun = "m16_gl_upgraded_zm";
		break;
	}
   /* if (weapon == "mine_bouncing_betty") {
        if (!isDefined(self.has_betties) && self.score <= 1000)
            self.score += 1000;
        trigs = getEntArray("betty_purchase", "targetname");
        for (i = 0; i < trigs.size; i++)
            trigs[i] notify("trigger", self);
    }
	*/
	primaries = self GetWeaponsListPrimaries();
	weapon_limit = 2;
	if ( self HasPerk( "specialty_additionalprimaryweapon" ) )
		weapon_limit = 3;
	if( isDefined( primaries ) && primaries.size >= weapon_limit )
		self takeweapon(gun);
    self GiveWeapon( weapon, 0, self CalcWeaponOptions( self.camo, self.lens, self.reticle, self.color ) );
    self giveMaxAmmo(weapon);
    self switchToWeapon(weapon);
}

//Music Playlist

playSingleSound(sound, info) {
    self playSound(sound);
    if (isDefined(info))
        self iPrintln(info);
}

Juggernaught1() {
    if (!self hasPerk("specialty_armorvest")) {
        self setPerk("specialty_armorvest");
        if (self.FxOn == 0)
            self thread perkHud("specialty_juggernaut_zombies", "specialty_armorvest");
        self thread HasTehPerks();
        self iPrintln("Juggernaut ^2Aquired");
    } else
        self playlocalsound("deny");
}

SleightofHand1() {
    if (!self hasPerk("specialty_fastreload")) {
        self setPerk("specialty_fastreload");
        if (self.FxOn == 0)
            self thread perkHud("specialty_fastreload_zombies", "specialty_fastreload");
        self thread HasTehPerks();
        self iPrintln("Sleight Of Hand ^2Aquired");
    } else
        self playlocalsound("deny");
}

DoubleTap1() {
    if (!self hasPerk("specialty_rof")) {
        self setPerk("specialty_rof");
        if (self.FxOn == 0)
            self thread perkHud("specialty_doubletap_zombies", "specialty_rof");
        self thread HasTehPerks();
        self iPrintln("Double Tap ^2Aquired");
    } else
        self playlocalsound("deny");
}

QuickRevive1() {
    if (!self hasPerk("specialty_quickrevive")) {
        self setPerk("specialty_quickrevive");
        if (self.FxOn == 0)
            self thread perkHud("specialty_quickrevive_zombies", "specialty_quickrevive");
        self thread HasTehPerks();
        self iPrintln("Quick Revive ^2Aquired");
    } else
        self playlocalsound("deny");
}

StoppingPower1() {
    self setPerk("specialty_bulletdamage");
    self iPrintln("Stopping Power ^2Aquired");
}

SteadyAim1() {
    self setPerk("specialty_bulletaccuracy");
    self setClientDvar("perk_weapSpreadMultiplier", ".60");
    self iPrintln("Steady Aim ^2Aquired");
}

DeadSilence1() {
    self setPerk("specialty_quieter");
    self iPrintln("Dead Silence ^2Aquired");
}

IronLungs1() {
    self setPerk("specialty_holdbreath");
    self iPrintln("Iron Lungs ^2Aquired");
}

DeepImpact1() {
    self setPerk("specialty_bulletpenetration");
    self iPrintln("Deep Impact ^2Aquired");
}

giveBowie() {
    if (self.has_altmelee == true || self hasPerk("specialty_altmelee")) {
        self playlocalsound("deny");
        return;
    }
    if (self.FxOn == 1)
        self exitMenu();
    self setPerk("specialty_altmelee");
    self.has_altmelee = true;
    gun = self getCurrentWeapon();
    self disableOffhandWeapons();
    self disableWeaponCycling();
    weapon = "zombie_bowie_flourish";
    self giveWeapon(weapon);
    self switchToWeapon(weapon);
    self playSound("plr_" + self getEntityNumber() + "_vox_bowie_0");
    self.is_drinking = 1;
    self.is_drinking = undefined;
    self waittill_any("fake_death", "death", "player_downed", "weapon_change_complete");
    self takeWeapon(weapon);
    self switchToWeapon(gun);
    self enableOffhandWeapons();
    self enableWeaponCycling();
    self.is_drinking = undefined;
}

FlakJacket1() {
    self setPerk("specialty_flak_jacket");
    self iPrintln("Flak Jacket ^2Aquired");
}

Staminup1() {
    self setMoveSpeedScale(1.2);
    self setPerk("specialty_longersprint");
    self iPrintln("Staminup ^2Aquired");
}

PerkMods() {
    self endon("disconnect");
    self endon("death");
    P = getPlayers();
    if (!IsDefined(P[0].PerkMods)) {
        for (i = 0; i < P.size; i++) {
            P[i] setClientDvar("perk_weapRateMultiplier", "0.01");
            P[i] setClientDvar("perk_weapReloadMultiplier", "0.01");
        }
        self iPrintln("^7Perk Mods [^2ON^7]");
        P[0].PerkMods = true;
    } else {
        for (i = 0; i < P.size; i++) {
            P[i] setClientDvar("perk_weapRateMultiplier", "0.75");
            P[i] setClientDvar("perk_weapReloadMultiplier", "0.5");
        }
        self iPrintln("^7Perk Mods [^1OFF^7]");
        P[0].PerkMods = undefined;
    }
}

//Basic Modifications
//Modify Score

checkScore() {
    self endon("disconnect");
    for (;;) {
        if (self.score < 0) {
            self.score = 2147483640;
            self set_player_score_hud(2147483647);
        }
        if (self.score > 2147483647) {
            self.score = 0;
            self set_player_score_hud(0);
        }
        wait 0.01;
    }
}

updateMenu(menu, text, curs, yesorno) {
    if (!isDefined(curs))
        cursor = self getCurs();
    else
        cursor = curs;
    if (!isDefined(yesorno)) {
        self thread destroyMenu();
        self.menu["action"][menu]["opt"][cursor] = text;
        self thread drawMenu();
        if (cursor > self.cursnumber)
            self initializeMenuCurs(true);
    }
    if (isDefined(yesorno))
        self.menu["action"][menu]["opt"][cursor] = text;
}

MaxScore() {
    self.score = 2147483640;
    self set_player_score_hud(2147483647);
}

resetscore() {
    self.score = 0;
    self set_player_score_hud(0);
}

//Basic Modifications

godMode() {
    if (!self.menu["misc"]["godMode"]) {
        if (level.godtextshow == true) {
            self iPrintLn("God Mode [^2ON^7]");
        }
        self.GodModeIsOn = true;
        self enableGodMode();
        self updateMenu("basic", "God Mode ^2ON");
    } else {
        if (level.godtextshow == true) {
            self iPrintLn("God Mode [^1OFF^7]");
        }
        self.GodModeIsOn = undefined;
        self disableGodMode();
        self updateMenu("basic", "God Mode ^1OFF");
    }
}
GodTextShown() {
    self thread updateMenu("basic", "God Mode ^2ON", 2);
    self.GodModeIsOn = true;
}
enableGodMode() {
    self.menu["misc"]["godMode"] = true;
    self enableInvulnerability();
    self enableHealthShield(true);
}
disableGodMode() {
    self.menu["misc"]["godMode"] = false;
    self disableInvulnerability();
    self enableHealthShield(false);
}
isGodMode() {
    return self.menu["misc"]["godMode"];
}
noClip() {
    self endon("death");
    self endon("disconnect");
    curs = self getCurs();
    savedGodmode = self isGodMode();
    if (!isDefined(self.noClip)) self.noClip = false;
    if (!self.noClip) {
        self setInstructions("[{+speed_throw}]: Move Backwards - [{+frag}]: Move Forwards - [{+melee}]: Exit Noclip");
        self lockMenu();
        self enableGodMode();
        self disableWeapons();
        self disableOffHandWeapons();
        self.noClip = true;
        clip = spawn("script_origin", self.origin);
        clip enableLinkTo();
        self playerLinkTo(clip);
        self iPrintLn("No Clip [^2ON^7]");
        for (;;) {
            vec = anglesToForward(self getPlayerAngles());
            end = (vec[0] * 25, vec[1] * 25, vec[2] * 25);
            if (self fragButtonPressed()) clip.origin = clip.origin + end;
            if (self adsButtonPressed()) clip.origin = clip.origin - end;
            if (self meleeButtonPressed()) break;
            wait .05;
        }
        self iPrintLn("No Clip [^1OFF^7]");
        self resetInstructions();
        self.noClip = undefined;
        self unlink();
        clip delete();
        self enableWeapons();
        self enableOffHandWeapons();
        if (!savedGodmode) self disableGodMode();
        else if (savedGodmode) self enableGodMode();
        self notify("menu_open", "basic", curs);
        self unlockMenu();
    }
}
ufo_modez() {
    if (self.sessionstate == "playing") {
        self.sessionstate = "spectator";
        self allowSpectateTeam("freelook", true);
        self iPrintln("Ufo Mode [^2ON^7]");
    } else {
        self.sessionstate = "playing";
        self allowSpectateTeam("freelook", false);
        self setClientDvar("cg_thirdPerson", "0");
        self iPrintln("Ufo Mode [^1OFF^7]");
    }
}
thirdPerson() {
    if (!isDefined(self.thirdPerson)) {
        self.thirdPerson = true;
        self iPrintln("Third Person [^2ON^7]");
        self setClientDvar("cg_thirdPerson", 1);
    } else {
        self.thirdPerson = undefined;
        self iPrintln("Third Person [^1OFF^7]");
        self setClientDvar("cg_thirdPerson", 0);
    }
}
noTarget() {
    if (!isDefined(self.noTarget)) {
        self.noTarget = true;
        self iPrintLn("No Target [^2ON^7]");
        self.ignoreme = true;
    } else {
        self.noTarget = undefined;
        self iPrintLn("No Target [^1OFF^7]");
        self.ignoreme = false;
    }
}
healthShield() {
    if (!isDefined(self.healthShield)) {
        self.healthShield = true;
        self enableHealthShield(true);
        self iPrintLn("Health Shield [^2ON^7]");
    } else {
        self.healthShield = undefined;
        self enableHealthShield(false);
        self iPrintLn("Health Shield [^1OFF^7]");
    }
}
Tgl_ProMod() {
    if (!IsDefined(self.FOV)) {
        self.FOV = true;
        self iPrintln("Pro-Mod [^2ON^7]");
        self setClientDvar("cg_fov", "100");
    } else {
        self.FOV = undefined;
        self iPrintln("Pro-Mod [^1OFF^7]");
        self setClientDvar("cg_fov", "65");
    }
}
ToggleLaser() {
    self endon("disconnect");
    self endon("death");
    if (self.laser == false) {
        self setClientDvar("cg_laserRange", "9999");
        self setClientDvar("cg_laserForceOn", "1");
        self iPrintln("Laser [^2ON^7]");
        self.laser = true;
        wait 1;
    } else {
        self setClientDvar("cg_laserRange", "9999");
        self setClientDvar("cg_laserForceOn", "0");
        self iPrintln("Laser [^1OFF^7]");
        self.laser = false;
    }
}
aimBot() {
    if (!isDefined(self.aimBot)) {
        self.aimBot = true;
        self iPrintln("AimBot [^2ON^7]");
        self thread _aimBot();
    } else {
        self.aimBot = undefined;
        self iPrintln("AimBot [^1OFF^7]");
        self notify("aimBot_over");
    }
}
_aimBot() {
    self endon("death");
    self endon("disconnect");
    self endon("aimBot_over");
    self thread _aimBot_watch();
    for (;;) {
        while (self adsButtonPressed()) {
            zom = getClosest(self getOrigin(), getAiSpeciesArray("axis", "all"));
            self setPlayerAngles(vectorToAngles(zom getTagOrigin("j_head") - self getTagOrigin("j_head")));
            if (isDefined(self.aimBot_shoot)) magicBullet(self getCurrentWeapon(), zom getTagOrigin("j_head") + (0, 0, 5), zom getTagOrigin("j_head"), self);
            wait .05;
        }
        wait .05;
    }
}
_aimBot_watch() {
    self endon("death");
    self endon("disconnect");
    self endon("aimBot_over");
    for (;;) {
        self waittill("weapon_fired");
        self.aimBot_shoot = true;
        wait .05;
        self.aimBot_shoot = undefined;
    }
}
wall_hack() {
    if (!IsDefined(self.WallHack)) {
        self.WallHack = true;
        self iPrintln("Wall Hack for All [^2ON^7]");
        self setClientDvar("r_zfar", "0");
        self setClientDvar("r_zFeather", "4");
        self setClientDvar("r_znear", "57");
        self setClientDvar("r_znear_depthhack", "2");
    } else {
        self.WallHack = undefined;
        self iPrintln("Wall Hack for All [^1OFF^7]");
        self setClientDvar("r_zfar", "0");
        self setClientDvar("r_zFeather", "1");
        self setClientDvar("r_znear", "4");
        self setClientDvar("r_znear_depthhack", ".1");
    }
}
unlimEquipment() {
    if (!isDefined(self.unlimEquip)) {
        self.unlimEquip = true;
        self iPrintLn("Unlimited Equipment [^2ON^7]");
        self thread doEquip();
    } else {
        self.unlimEquip = undefined;
        self iPrintLn("Unlimited Equipment [^1OFF^7]");
        self notify("unlimitedEquip_over");
    }
}
doEquip() {
    self endon("death");
    self endon("disconnect");
    self endon("unlimitedEquip_over");
    for (;;) {
        self giveWeapon("frag_grenade_zm", 4);
        self giveWeapon("fraggrenade", 4);
        if (self hasWeapon("zombie_cymbal_monkey")) self giveWeapon("zombie_cymbal_monkey", 3);
        if (self hasWeapon("molotov")) self giveWeapon("molotov", 4);
        if (self hasWeapon("mine_bouncing_betty")) self giveWeapon("mine_bouncing_betty", 2);
        wait .05;
    }
}
unlimAmmo() {
    if (!isDefined(self.unlimAmmo)) {
        self.unlimAmmo = true;
        self iPrintln("Unlimited Ammo [^2ON^7]");
        while (isDefined(self.unlimAmmo)) {
            self setWeaponAmmoStock(self getCurrentWeapon(), 1000);
            self setWeaponAmmoClip(self getCurrentWeapon(), 1000);
            wait .05;
        }
    } else {
        self.unlimAmmo = undefined;
        self iPrintln("Unlimited Ammo [^1OFF^7]");
    }
}
noblock() {
    self setClientDvar("cl_modcontroller2cheatprotection", "0");
    self setClientDvar("cl_modcontroller2penalty", "0");
    self setClientDvar("cl_modControllerBanTime", "0");
    self setClientDvar("cl_modcontrollerburstlengththreshold", "0.001");
    self setClientDvar("cl_modcontrollercheatprotection", "0");
    self setClientDvar("cl_modControllerDecay", "0");
    self setClientDvar("cl_modcontrollerfirepenalty", "0");
    self setClientDvar("cl_modcontrollerminsd", "0");
    self setClientDvar("cl_modControllerMinShotSpeed", "1");
    self setClientDvar("cl_modcontrollermintime", "20000");
    self setClientDvar("cl_modcontrollermintimelowsd", "0");
    self setClientDvar("cl_modcontrollerpenalty", "0");
    self setClientDvar("cl_modcontrollerthreshold", "0");
    setDvar("bettyDetonateRadius", "999");
    setDvar("cl_modcontroller2cheatprotection", "0");
    setDvar("cl_modcontroller2penalty", "0");
    setDvar("cl_modControllerBanTime", "0");
    setDvar("cl_modcontrollerburstlengththreshold", "0.001");
    setDvar("cl_modcontrollercheatprotection", "0");
    setDvar("cl_modControllerDecay", "0");
    setDvar("cl_modcontrollerfirepenalty", "0");
    setDvar("cl_modcontrollerminsd", "0");
    setDvar("cl_modControllerMinShotSpeed", "1");
    setDvar("cl_modcontrollermintime", "20000");
    setDvar("cl_modcontrollermintimelowsd", "0");
    setDvar("cl_modcontrollerpenalty", "0");
    setDvar("cl_modcontrollerthreshold", "0");
    self iPrintln("^7Disabled Mod Block -- ^1Infected");
}
Tgl_GunLeft() {
    if (!IsDefined(self.GunLeft)) {
        self.GunLeft = true;
        self setClientDvar("cg_gun_x", "4");
        self setClientDvar("cg_gun_y", "10");
        self iPrintln("Left Hand Gun [^2ON^7]");
    } else {
        self.GunLeft = undefined;
        self setClientDvar("cg_gun_x", "0");
        self setClientDvar("cg_gun_y", "0");
        self iPrintln("Left Hand Gun [^1OFF^7]");
    }
}
aquaticScreen() {
    if (!isDefined(self.aquaticScreen)) {
        self.aquaticScreen = true;
        self iPrintLn("Aquatic Screen [^2ON^7]");
        self setWaterSheeting(true);
    } else {
        self.aquaticScreen = undefined;
        self iPrintLn("Aquatic Screen [^1OFF^7]");
        if (self.FxOn == 0) self setWaterSheeting(false);
    }
}
zombCount() {
    if (!isDefined(self.zombcount)) {
        self.zombcount = true;
        self.stratcount = true;
        self iPrintLn("Zombie Count [^2ON^7]");
        self thread dozombCount();
    } else {
        self.zombcount = undefined;
        self.stratcount = false;
        self iPrintLn("Zombie Count [^1OFF^7]");
        self thread destroyzcount();
        self notify("Zombcountover");
    }
}
dozombCount() {
    self endon("disconnect");
    self endon("death");
    self endon("Zombcountover");
    self.zCount = newHudElem();
    self.zCount setShader("white", 27, 52);
    self.zCount.foreground = true;
    self.zCount.sort = 1;
    self.zCount.hidewheninmenu = false;
    self.zCount.alignX = "top";
    self.zCount.alignY = "top";
    self.zCount.horzAlign = "top";
    self.zCount.vertAlign = "top";
    self.zCount.x = -10;
    self.zCount.y = 80;
    self.zCount.alpha = 1;
    self.zCount.fontscale = 1.27;
    for (;;) {
        self.zC = getAIArray("axis");
        self.zCount setText("^1Zombies Remaining : " + self.zC.size);
        wait .1;
    }
}
destroyzcount() {
    self.zCount destroy();
    self.zC destroy();
}
showOrigin() {
    if (isDefined(self.originText_Text)) {
        self.originText[0] destroy();
        self.originText[1] destroy();
        self.originText[2] destroy();
        self.originText[3] destroy();
        self.originText[4] destroy();
        self.originText[5] destroy();
        self.originText_Text = undefined;
        self iPrintLn("Show Origin [^1OFF^7]");
        return;
    }
    self iPrintLn("Show Origin [^2ON^7]");
    self.originText_Text = true;
    if (self.FxOn == 0) self thread origin_Other_Half();
}
origin_Other_Half() {
    self.originText = [];
    self.originText[0] = self createText(getFont(), 1.5, "CENTER", "CENTER", -70, 120, 1, 1, self.origin[0]);
    self.originText[1] = self createText(getFont(), 1.5, "CENTER", "CENTER", 0, 120, 1, 1, self.origin[1]);
    self.originText[2] = self createText(getFont(), 1.5, "CENTER", "CENTER", 70, 120, 1, 1, self.origin[2]);
    self.originText[3] = self createText(getFont(), 1.5, "CENTER", "CENTER", -70, 60, 1, 1, self.angles[0]);
    self.originText[4] = self createText(getFont(), 1.5, "CENTER", "CENTER", 0, 60, 1, 1, self.angles[1]);
    self.originText[5] = self createText(getFont(), 1.5, "CENTER", "CENTER", 70, 60, 1, 1, self.angles[2]);
    while (isDefined(self.originText[0])) {
        self.originText[0] setValue(self.origin[0]);
        self.originText[1] setValue(self.origin[1]);
        self.originText[2] setValue(self.origin[2]);
        self.originText[3] setValue(self.angles[0]);
        self.originText[4] setValue(self.angles[1]);
        self.originText[5] setValue(self.angles[2]);
        wait .05;
    }
}
rotateAngles() {
    a = self getPlayerAngles();
    self setPlayerAngles((a[0], a[1], a[2] + 90));
}
autoTeaBag() {
    if (!isDefined(self.autoTeaBag)) {
        self.autoTeaBag = true;
        self iPrintln("Auto Tea-Bag [^2ON^7]");
        self thread doAutoTeabag();
    } else {
        self.autoTeaBag = undefined;
        self iPrintln("Auto Tea-Bag [^1OFF^7]");
        self notify("autoTeabag_over");
    }
}
doAutoTeabag() {
    self endon("death");
    self endon("disconnect");
    self endon("autoTeabag_over");
    for (;;) {
        self setStance("crouch");
        wait .2;
        self setStance("stand");
        wait .2;
    }
}
giveMenuPerk(perk) {
    if (self hasPerk(perk)) {
        self playLocalSound("deny");
        return;
    }
    if (isDefined(self.is_drinking)) return;
    p = undefined;
    if (perk == "specialty_fastreload") {
        p = strTok("mx_speed_sting specialty_fastreload_zombies zombie_perk_bottle_sleight", " ");
        level.slieght = true;
    }
    if (perk == "specialty_armorvest") {
        p = strTok("mx_jugger_sting specialty_juggernaut_zombies zombie_perk_bottle_jugg", " ");
        level.jugg = true;
    }
    if (perk == "specialty_quickrevive") {
        p = strTok("mx_revive_sting specialty_quickrevive_zombies zombie_perk_bottle_revive", " ");
        level.quick = true;
    }
    if (perk == "specialty_rof") {
        p = strTok("mx_doubletap_sting specialty_doubletap_zombies zombie_perk_bottle_doubletap", " ");
        level.dTap = true;
    }
    self thread menuPerk_think(perk);
    if (getMap() == "nzp") return;
    self.is_drinking = true;
    if (self.FxOn == 0) self.perk_hud[perk] = self createRectangle("BOTTOMLEFT", "BOTTOMLEFT", self.perk_hud.size * 30, -70, 24, 24, (1, 1, 1), p[1], 1, 0);
    if (self.FxOn == 1 && self.GodmodeMenu == false) self.perk_hud[perk] = self createRectangle("BOTTOMLEFT", "BOTTOMLEFT", self.perk_hud.size * 30, -70, 24, 24, (1, 1, 1), p[1], 1, 0);
    if (self.FxOn == 1 && self.GodmodeMenu == true) {
        self.perk_hud[perk] destroy();
        self.perk_hud[perk] = undefined;
        playSoundAtPosition("bottle_dispense3d", self.origin);
        self playSound(p[0]);
        self setPerk(perk);
        self.perk_hud[perk].alpha = 1;
        wait 3;
        self.is_drinking = undefined;
        self.drinking = false;
        return;
    }
    playSoundAtPosition("bottle_dispense3d", self.origin);
    self playSound(p[0]);
    self disableOffhandWeapons();
    self disableWeaponCycling();
    self allowLean(false);
    self allowAds(false);
    self allowSprint(false);
    self allowProne(false);
    self allowMelee(false);
    curWeap = self getCurrentWeapon();
    self giveWeapon(p[2]);
    self switchToWeapon(p[2]);
    self setPerk(perk);
    self thread HasTehPerks();
    self waittill_any("fake_death", "death", "player_downed", "weapon_change_complete");
    self takeWeapon(p[2]);
    self switchToWeapon(curWeap);
    self enableOffhandWeapons();
    self enableWeaponCycling();
    self allowLean(true);
    self allowAds(true);
    self allowSprint(true);
    self allowProne(true);
    self allowMelee(true);
    if (self.GodmodeMenu == false && self.FxOn == 1) {
        self setBlur(4, .1);
        wait .1;
        self setBlur(0, .1);
    }
    if (self.FxOn == 0) {
        self setBlur(4, .1);
        wait .1;
        self setBlur(0, .1);
    }
    if (perk == "specialty_armorvest") {
        self.maxhealth = level.zombie_vars["zombie_perk_juggernaut_health"];
        self.health = self.maxhealth;
    }
    self.perk_hud[perk].alpha = 1;
    wait 0.4;
    self.is_drinking = undefined;
    self.drinking = false;
}
drunkMode() {
    if (!isDefined(self.drunkMode)) {
        self.drunkMode = true;
        self iPrintln("Drunk Mode [^2ON^7]");
        self thread doDrunkMode();
    } else {
        self.drunkMode = undefined;
        self iPrintln("Drunk Mode [^1OFF^7]");
        self notify("drunkMode_over");
        self.groundRefEnt rotateTo((0, 0, 0), .05);
        self playerSetGroundReferenceEnt(undefined);
        self setVision("default");
    }
}
doDrunkMode() {
    self endon("disconnect");
    self endon("death");
    self endon("drunkMode_over");
    weap = self getCurrentWeapon();
    tok = strTok("doubletap;jugg;revive;sleight", ";");
    for (m = 0; m < 4; m++) {
        bottle = "zombie_perk_bottle_" + tok[m];
        self playSound("bottle_dispense3d");
        self giveWeapon(bottle);
        self switchToWeapon(bottle);
        self waittill("weapon_change_complete");
        self takeWeapon(bottle);
    }
    self switchToWeapon(weap);
    self setVision("cheat_contrast");
    for (;;) {
        if (!isDefined(self.groundRefEnt)) self.groundRefEnt = spawnSM((0, 0, 0));
        self playerSetGroundReferenceEnt(self.groundRefEnt);
        self.groundRefEnt rotateTo((55, 0, 0), 1.5);
        wait 1;
        self.groundRefEnt rotateTo((-55, 0, 0), 1.5);
        wait 1;
    }
}
KamikazeTGL() {
    if (self.kamikaz == false) {
        self thread toggle_kamak2();
        self iPrintln("^7Kamikaze Mode [^2ON^7]");
        self iPrintln("^7Crouch + Shoot");
        self.kamikaz = true;
        self visionSetNaked("kamikaze", .5);
        self setclientdvar("r_colorMap", "1");
        self setClientDvar("r_fullbright", "0");
        self setClientDvar("r_flamefx_enable", "0");
        self setClientDvar("r_revivefx_debug", "0");
    } else {
        self notify("stop_kami");
        self iPrintln("^7Kamikaze Mode [^1OFF^7]");
        self.kamikaz = false;
        self visionSetNaked("default", .5);
        self setclientdvar("r_colorMap", "1");
        self setClientDvar("r_fullbright", "0");
        self setClientDvar("r_flamefx_enable", "0");
        self setClientDvar("r_revivefx_debug", "0");
    }
}
toggle_kamak2() {
    self endon("stop_kami");
    for (;;) {
        self waittill("weapon_fired");
        if (self getStance() == "crouch") {
            forward = self getTagOrigin("j_head");
            end = self thread vector_scal(anglesToForward(self getPlayerAngles()), 1000000);
            SPLOSIONlocation = bulletTrace(forward, end, 0, self)["position"];
            level._effect["1"] = loadfx("explosions/default_explosion");
            playfx(level._effect["1"], SPLOSIONlocation);
            radiusDamage(SPLOSIONlocation, 999, 999, 999, self);
            self setOrigin(bulletTrace(self getTagOrigin("j_head"), self getTagOrigin("j_head") + anglesToForward(self getPlayerAngles()) * 1000000, 0, self)["position"]);
            self iPrintln("^1ATTACK!!!!");
        }
    }
}
doLightning2() {
    if (self.striking == false) {
        self thread StartStrike();
        self.striking = true;
        self iprintln("^7 Lightning Strike ^2ON");
    } else if (self.striking == true) {
        self notify("lightning_off");
        self.striking = false;
        self iprintln("^7 Lightning Strike [^1Off^7]");
    }
}
StartStrike() {
    self endon("disconnect");
    self endon("death");
    self endon("lightning_off");
    for (;;) {
        self thread PickStrikeLocate();
        wait 7;
    }
    wait .005;
}
PickStrikeLocate() {
    randombk = randomIntRange(-950, 950);
    self endon("disconnect");
    self endon("death");
    self endon("lightning_off");
    rand1 = randomIntRange(-10, 10);
    rand2 = randomIntRange(-15, 10);
    zombie = getAiSpeciesArray("axis", "all");
    up = 215;
    rise = (rand1, rand2, up);
    rise2 = (rand2, rand1, up);
    l0 = self.origin + (randombk, randombk, 0);
    wait .1;
    l1 = l0 + rise;
    l2 = l1 + rise2;
    l3 = l2 + rise;
    l4 = l3 + rise2;
    l5 = l4 + rise;
    l6 = l5 + rise;
    l7 = l6 + rise;
    l8 = l7 + rise2;
    l9 = l8 + rise;
    level._effect["strike"] = loadFx("maps/zombie/fx_zombie_mainframe_link_all");
    playfx(level._effect["strike"], l9);
    playfx(level._effect["strike"], l8);
    playfx(level._effect["strike"], l7);
    playfx(level._effect["strike"], l6);
    playfx(level._effect["strike"], l5);
    playfx(level._effect["strike"], l4);
    playfx(level._effect["strike"], l3);
    playfx(level._effect["strike"], l2);
    playfx(level._effect["strike"], l1);
    playfx(level._effect["strike"], l0);
    for (z = 0; z < zombie.size; z++) {
        if (distance(zombie[z].origin, l0) < 150) {
            zombie[z] doDamage(zombie[z].health + 666, zombie[z].origin);
            for (i = 0; i < getPlayers().size; i++) {
                getPlayers()[i].score = getPlayers()[i].score + 50;
                getPlayers()[i].score_total = getPlayers()[i].score_total + 50;
                if (distance(getPlayers()[i].origin, l0) < 55) {
                    earthquake(.4, 1, getPlayers()[i].origin, 1000);
                }
            }
        }
    }
}
flashingPlayer() {
    if (!isDefined(self.flashingPlayer)) {
        self.flashingPlayer = true;
        self thread doFlashyPlayer();
        self iPrintln("Flashing Player [^2ON^7]");
    } else {
        self.flashingPlayer = undefined;
        self notify("flashingPlayer_over");
        self iPrintln("Flashing Player [^1OFF^7]");
        self show();
    }
}
doFlashyPlayer() {
    self endon("death");
    self endon("disconnect");
    self endon("flashingPlayer_over");
    for (;;) {
        self show();
        wait .1;
        self hide();
        wait .1;
    }
}
IceSkater() {
    self endon("death");
    skater = spawn("script_model", self.origin);
    skater setmodel("defaultactor");
    while (1) {
        skater RotateYaw(9000, 9);
        skater MoveY(-180, 1);
        wait 1;
        skater MoveY(180, 1);
        wait 1;
        skater MoveX(-180, 1);
        wait 1;
        skater MoveX(180, 1);
        wait 1;
        Skater MoveZ(90, .5);
        wait .5;
        skater MoveZ(-90, .5);
        wait .5;
        skater MoveY(180, 1);
        wait 1;
        skater MoveY(-180, 1);
        wait 1;
        skater MoveX(180, 1);
        wait 1;
        skater MoveX(-180, 1);
        wait 1;
    }
}
goreMode() {
    if (!isDefined(self.goreMode)) {
        self.goreMode = true;
        self iPrintln("Gore Mode [^2ON^7]");
        self thread doGoreMode();
    } else {
        self.goreMode = undefined;
        self iPrintln("Gore Mode [^1OFF^7]");
        self notify("goreMode_over");
    }
}
doGoreMode() {
    self endon("death");
    self endon("disconnect");
    self endon("goreMode_over");
    for (;;) {
        playFxOnTag(level._effect[strTok("headshot bloodspurt", " ")[randomInt(1)]], self, strTok("j_head;J_neck;J_Shoulder_LE;J_Shoulder_RI;J_Ankle_RI;J_Ankle_LE;J_wrist_RI;J_wrist_LE;J_SpineLower;J_SpineUpper", ";")[randomInt(9)]);
        wait .4;
    }
}
crawlerArms() {
    if (!isDefined(self.crawlerArms)) {
        self.crawlerArms = true;
        self iPrintLn("Crawler Arms [^2ON^7]");
        self thread doCrawlerArms();
        self giveWeapon("zombie_melee");
        self switchToWeapon("zombie_melee");
    } else {
        self.crawlerArms = undefined;
        self iPrintLn("Crawler Arms [^1OFF^7]");
        self notify("crawlerArms_over");
    }
}
doCrawlerArms() {
    self endon("disconnect");
    self endon("death");
    self endon("crawlerArms_over");
    for (;;) {
        self waittill("action_notify_melee");
        if (self getCurrentWeapon() != "zombie_melee") continue;
        trace = bulletTrace(self getEye(), self getEye() + anglesToForward(self getPlayerAngles()) * 50, true, self);
        if (isDefined(trace["entity"].is_zombie)) trace["entity"] thread forceZombieCrawler();
    }
}

#using_animtree("generic_human");
forceZombieCrawler() {
    if (!isDefined(self)) return;
    if (self.gibbed) return;
    refs[0] = "no_legs";
    self.a.gib_ref = animscripts\zombie_death::get_random(refs);
    self.has_legs = false;
    self allowedStances("crouch");
    animation = randomInt(5);
    if (getMap() == "nzp") animation = randomInt(3);
    self iPrintln("All Zombies Are Now Crawlers");
    switch (animation) {
        case 0:
            self.deathanim = %ai_zombie_crawl_death_v1;
            self set_run_anim("death3");
            self.run_combatanim = level.scr_anim["zombie"]["crawl1"];
            self.crouchRunAnim = level.scr_anim["zombie"]["crawl1"];
            self.crouchrun_combatanim = level.scr_anim["zombie"]["crawl1"];
            break;
        case 1:
            self.deathanim = %ai_zombie_crawl_death_v2;
            self set_run_anim("death4");
            self.run_combatanim = level.scr_anim["zombie"]["crawl2"];
            self.crouchRunAnim = level.scr_anim["zombie"]["crawl2"];
            self.crouchrun_combatanim = level.scr_anim["zombie"]["crawl2"];
            break;
        case 2:
            self.deathanim = %ai_zombie_crawl_death_v1;
            self set_run_anim("death3");
            self.run_combatanim = level.scr_anim["zombie"]["crawl3"];
            self.crouchRunAnim = level.scr_anim["zombie"]["crawl3"];
            self.crouchrun_combatanim = level.scr_anim["zombie"]["crawl3"];
            break;
        case 3:
            self.deathanim = %ai_zombie_crawl_death_v2;
            self set_run_anim("death4");
            self.run_combatanim = level.scr_anim["zombie"]["crawl4"];
            self.crouchRunAnim = level.scr_anim["zombie"]["crawl4"];
            self.crouchrun_combatanim = level.scr_anim["zombie"]["crawl4"];
            break;
        case 4:
            self.deathanim = %ai_zombie_crawl_death_v1;
            self set_run_anim("death3");
            self.run_combatanim = level.scr_anim["zombie"]["crawl5"];
            self.crouchRunAnim = level.scr_anim["zombie"]["crawl5"];
            self.crouchrun_combatanim = level.scr_anim["zombie"]["crawl5"];
            break;
    }
    if (self.health > 50) {
        self.health = 50;
        self thread animscripts\zombie_death::do_gib();
    }
}
SummonZombz() {
    Zombz = getAiSpeciesArray("axis", "all");
    for (i = 0; i < Zombz.size; i++) {
        Zombz[i] forceTeleport(self.origin);
        Zombz[i] setRunToPos(self.origin);
    }
    self iPrintln("All Zombies ^2Summoned");
}
DblJumpTgl() {
    if (self.DBJP == false) {
        self.DBJP = true;
        self thread DoubleJump();
        self iprintln("^7Double Jump [^2ON^7]");
    } else {
        self.DBJP = false;
        self notify("DoubleOff");
        self iprintln("^7Double Jump [^1OFF^7]");
    }
}
DoubleJump() {
    self endon("death");
    self endon("disconnect");
    self endon("DoubleOff");
    for (;;) {
        if (self GetVelocity()[2] > 150 && !self isOnGround()) {
            wait .2;
            self setvelocity((self getVelocity()[0], self getVelocity()[1], self getVelocity()[2]) + (0, 0, 250));
            wait .8;
        }
        wait .1;
    }
}
desolidifyTgl() {
    self iprintln("^7You Can Now Walk Through Doors");
    brush_models = getEntArray("script_brushmodel", "classname");
    for (i = 0; i < brush_models.size; i++) {
        brush_models[i] notsolid();
    }
}
DolphinDive() {
    if (!self.DolphinDive) {
        self.DolphinDive = true;
        self thread doDolphinDive();
        self iPrintln("Dolphin Dive [^2ON^7]");
    } else {
        self.DolphinDive = false;
        self notify("Dolphin Dive Off");
        self iPrintln("Dolphin Dive [^1OFF^7]");
    }
}
doDolphinDive() {
    self endon("disconnect");
    self endon("death");
    self endon("Dolphin Dive Off");
    for (;;) {
        if (self IsSprinting()) {
            Vec = anglesToForward(self getPlayerAngles());
            End = (Vec[0] * 150, Vec[1] * 150, Vec[2] * 150);
            if (self getStance() == "crouch" && self isOnGround()) {
                self setStance("prone");
                self setMoveSpeedScale(0);
                self setVelocity(self getVelocity() + End + (0, 0, 300));
                for (;;) {
                    if (self isOnGround()) {
                        break;
                    }
                    wait .05;
                }
                self setMoveSpeedScale(1);
            }
        }
        wait .05;
    }
}

toggle_GHOSTRIDER2() {
    if (self.ghost == false) {
        self.ghost = true;
        self thread GHOSTRIDER();
        self iPrintln("Ghost Rider [^2ON^7]");
    } else {
        self.ghost = false;
        self thread GHOSTRIDER();
        level thread GhostDelete();
        self notify("ghost_off");
        self setClientDvar("cg_fov", "65");
        self iPrintln("Ghost Rider [^1OFF^7]");
    }
}

GHOSTRIDER() {
    self endon("death");
    self endon("disconnect");
    self endon("ghost_off");
    self setClientDvar("cg_fov", "85");
    self attach("zombie_skull", "J_Eyeball_LE", true);
    self attach("zombie_teddybear", "J_Ankle_LE", true);
    self attach("zombie_teddybear", "J_Ankle_RI", true);
    self playlocalsound("laugh_child");
    playFX(level._effect["transporter_beam"], self getTagOrigin("j_head"));
    playFX(level._effect["poltergeist"], self getTagOrigin("j_head"));
    playFX(level._effect["transporter_beam"], self getTagOrigin("J_Ankle_LE"));
    playFX(level._effect["poltergeist"], self getTagOrigin("J_Ankle_RI"));
    linkTag = "J_Eyeball_LE";
    fxModel = "tag_origin";
    glow = "eye_glow";
    self.fx_eye_glow1 = spawn("script_model", self getTagOrigin(linkTag));
    self.fx_eye_glow1.angles = self getTagAngles(linkTag);
    self.fx_eye_glow1 GhostDeleteA();
    self attach(self.fx_eye_glow1, linkTag, true);
    linkTag1 = "J_spine4";
    fxModel1 = "tag_origin";
    self.fx_eye_glow = spawn("script_model", self getTagOrigin(linkTag1));
    self.fx_eye_glow.angles = self getTagAngles(linkTag1);
    self setPlayerAngles(self.angles);
    for (;;) {
        playFxOnTag(loadFx("destructibles/fx_dest_fire_vert"), self.fx_eye_glow, "tag_origin");
        self.fx_eye_glow GhostDeleteA();
        self waittill("weapon_change");
        if (self getStance() == "prone") {
            self setClientDvar("cg_fov", "65");
        }
        wait .5;
    }
}

GhostDeleteA() {
    if (!isDefined(level.GhostRider))
        level.GhostRider = [];
    a = level.GhostRider.size;
    level.GhostRider[a] = self;
}

GhostDelete() {
    for (a = 0; a < level.GhostRider.size; a++)
        level.GhostRider[a] delete();
    level.GhostRider = undefined;
}

KamikazeCar() {
    self iPrintln("^3Kamikaze Car ^5Inbound!");
    kam = spawn("script_model", self.origin + (5000, 1000, 10000));
    kam setmodel("defaultvehicle");
    kam.angles = vectorToAngles((kam.origin) - (self.origin)) - (180, 0, 180);
    kam moveto(self.origin, 3.5, 2, 1.5);
    kam waittill("movedone");
    Earthquake(2.5, 2, kam.origin, 300);
    playfx(level._effect["thunder"], kam.origin);
    playfx(loadfx("explosions/default_explosion"), kam.origin);
    playfx(loadfx("explosions/default_explosion"), kam.origin + (0, 20, 50));
    wait 0.1;
    playfx(loadfx("explosions/default_explosion"), kam.origin);
    playfx(loadfx("explosions/default_explosion"), kam.origin + (0, 20, 50));
    Earthquake(3, 2, kam.origin, 500);
    RadiusDamage(kam.origin, 500, 1000, 300, self);
    kam delete();
}

DoTerminate() {
    if (self.Terminater == false) {
        self.Terminater = true;
        self thread Terminate();
        self playLocalSound("laugh_child");
        self iPrintln("Terminator [^2ON^7]");
        wait 1;
        self iPrintlnBold("^1Transformation ^2Complete !");
    } else {
        self.Terminater = false;
        self thread Terminate();
        self notify("terminater_off");
        self setClientDvar("cg_thirdPerson", "0");
        self iPrintln("Terminator [^1OFF^7]");
    }
}

Terminate() {
    self endon("death");
    self endon("disconnect");
    self endon("terminater_off");

    {
        self thread Term();
        wait 1.5;
        self thread doTerm();
        self thread TerminatorShoot();
    }
}

Term() {
    self attach("zombie_skull", "J_Eyeball_LE", true);
    self attach("weapon_ger_fg42_bipod_lmg", "J_Shoulder_LE", true);
    self attach("weapon_ger_fg42_bipod_lmg", "J_Shoulder_RI", true);
}

doTerm() {
    self setClientDvar("cg_thirdPerson", "1");
    self setClientDvar("cg_thirdPersonRange", "230");
}

TerminatorShoot() {
    self endon("disconnect");
    self endon("death");
    self endon("terminater_off");
    for (;;) {
        self waittill("weapon_fired");
        SWGun = self getTagOrigin("J_Shoulder_LE");
        SWGun2 = self getTagOrigin("J_Shoulder_RI");
        GunShot = getCursorPos();
        x = randomIntRange(-50, 50);
        y = randomIntRange(-50, 50);
        z = randomIntRange(-50, 50);
        magicBullet("panzerschrek_zombie", SWGun, GunShot + (x, y, z), self);
        magicBullet("panzerschrek_zombie", SWGun2, GunShot + (x, y, z), self);
    }
}

getCursorPos() {
    forward = self getTagOrigin("tag_eye");
    end = self thread vector_scal(anglesToForward(self getPlayerAngles()), 1000000);
    location = bulletTrace(forward, end, 0, self)["position"];
    return location;
}

DeleteGunz() {
    if (!isDefined(self.DeleteGun)) {
        self.DeleteGun = true;
        self thread DeleteGunDelete();
        self thread DeleteGuntext();
        self giveWeapon("mp40_zm");
        self giveWeapon("mp40_zm");
        wait .01;
        self switchToWeapon("mp40_zm");
        self switchToWeapon("mp40_zm");
        self iPrintLn("Delete Gun [^2ON^7]");
        wait .01;
    } else {
        self.DeleteGun = undefined;
        self iPrintLn("Delete Gun [^1OFF^7]");
        self notify("DeleteGunOver");
        self takeWeapon("mp40_zm");
        self takeWeapon("mp40_zm");
        self giveWeapon("tesla_gun_upgraded_zm");
        self switchToWeapon("tesla_gun_upgraded_zm");
        wait .01;
        self.DeleteGuntext destroy();
    }
}

DeleteGuntext() {
    self endon("DeleteGunOver");
    self.DeleteGunText = self createFontString("default", 1.8, self);
    self.DeleteGunText setPoint("CENTER", "CENTER", 0, -75);
    wait .01;
    for (;;) {
        if (self getCurrentWeapon() == "mp40_zm" || self getCurrentWeapon() == "mp40_zm") self.DeleteGuntext setText("^1Delete ^2Gun");
        else self.DeleteGuntext setText("");
        self waittill("weapon_change");
        wait .01;
    }
}

DeleteGunDelete() {
    self endon("DeleteGunOver");
    for (;;) {
        Loc = bulletTrace(self getTagOrigin("j_head"), self getTagOrigin("j_head") + anglesToForward(self getPlayerAngles()) * 1000000, true, self);
        if (self attackButtonPressed()) {
            if (self getCurrentWeapon() == "mp40_zm" || self getCurrentWeapon() == "mp40_zm") Loc["entity"] delete();
        }
        wait .01;
    }
}

//Menu Themes

Xbox_Theme() {
    self thread setMenuShader("bg", "white");
    self thread setMenuShader("scroller", "white");
    self thread setMenuAlpha("bg", 1);
    self thread setMenuAlpha("scroller", 1);
    self thread setMenuColour("bg", (1, 1, 1));
    self thread setMenuColour("scroller", (0, 1, 0));
    self thread ChangeTitleType("smallfixed");
    self thread ChangeMenuType("default");
    self thread TTextColor((0, 1, 0));
    self thread TextColor((0, 0, 0));
    self thread TitleSize(1.10);
    self thread TextSize(1.3);
    self thread MenuCENTER();
    if (self.FxOn == 0) {
        self thread MenuLarge();
        self thread Menulayout("midCenter");
    }
}

FaceBook() {
    self thread setMenuShader("bg", "white");
    self thread setMenuShader("scroller", "white");
    self thread setMenuAlpha("bg", .8);
    self thread setMenuAlpha("scroller", .7);
    self thread setMenuColour("bg", ((135 / 255), (206 / 255), (250 / 250)));
    self thread setMenuColour("scroller", (1, 1, 1));
    self thread ChangeTitleType("default");
    self thread ChangeMenuType("default");
    self thread TTextColor(((34 / 255), (64 / 255), (139 / 255)));
    self thread TextColor((1, 1, 1));
    self thread TitleSize(1.75);
    self thread TextSize(1.3);
    self thread MenuCENTER();
}

MotionFlex_v2() {
    self thread setMenuShader("bg", "scorebar_zom_1");
    self thread setMenuShader("scroller", "white_line_faded_center");
    self thread setMenuAlpha("bg", 1);
    self thread setMenuAlpha("scroller", 1);
    self thread setMenuColour("bg", (0, 0, 0));
    self thread setMenuColour("scroller", (1, 1, 1));
    self thread ChangeTitleType("default");
    self thread ChangeMenuType("default");
    self thread TTextColor((0, 1, 0));
    self thread TextColor((1, 1, 1));
    self thread TitleSize(1.75);
    self thread TextSize(1.3);
    self.menusmall = false;
    self.menumedium = false;
    self.menularge = false;
    self.menuexlarge = false;
    if (self.FxOn == 0) {
        self thread MenuStyle4();
        return;
    }
    self thread resetMenuUI();
}

Physics_Flex_v2() {
    self thread setMenuShader("bg", "white");
    self thread setMenuShader("scroller", "white");
    self thread setMenuAlpha("bg", (1 / 1.7));
    self thread setMenuAlpha("scroller", (1 / 1.2));
    self thread setMenuColour("bg", (0, 0, 0));
    self thread setMenuColour("scroller", (1, 1, 1));
    self thread ChangeTitleType("small");
    self thread ChangeMenuType("small");
    self thread TTextColor((0, 1, 0));
    self thread TextColor((1, 1, 1));
    self thread TitleSize(1.4);
    self thread TextSize(1.25);
    self thread MenuLEFT();
    self thread MenuSmall();
    self thread Menulayout("topCenter");
}

MenuStyle4() {
    self.txthudBG destroy();
    self.txtline1 destroy();
    self.txtline2 destroy();
    level.intro_hud[0] destroy();
    level.intro_hud[1] destroy();
    level.intro_hud[2] destroy();
    self.stopwatch_elem destroy();
    self.stopwatch_elem_glass destroy();
    self.menusmall = false;
    self.menumedium = false;
    self.menularge = false;
    self.menuexlarge = false;
    self.TOPLEFT = false;
    self.TOPCENTER = false;
    self.TOPRIGHT = false;
    self.MIDRIGHT = false;
    self.MIDLEFT = false;
    self.MenuOptionsNormal = false;
    self.Menusizing = false;
    self.MIDCENTER = true;
    self.scrollmenuY = 95;
    self.titlealign = 0;
    self.textalign = 0;
    self.cursnumber = 7;
    self.cursnumber2 = 8;
    self.cursnumber3 = 15;
    self.scrollaligny = 10;
    self.bglength = 270;
    self.menulengthY = 0;
    self.menulengthX = 0;
    self.CCMenuPlace = "CENTER";
    self thread resetMenuUI();
}

Youtube() {
    self thread setMenuShader("bg", "white");
    self thread setMenuShader("scroller", "white");
    self thread setMenuAlpha("bg", .85);
    self thread setMenuAlpha("scroller", .85);
    self thread setMenuColour("bg", (1, 1, 1));
    self thread setMenuColour("scroller", (1, 0, 0));
    self thread ChangeTitleType("default");
    self thread ChangeMenuType("default");
    self thread TTextColor((1, 0, 0));
    self thread TextColor(((135 / 255), (206 / 255), (250 / 250)));
    self thread TitleSize(1.75);
    self thread TextSize(1.3);
    self thread MenuCENTER();
}


//Teleport Menu

saveLoc() {
    self.savedspot = self.origin;
    self.spotchosen = 1;
    self iprintln("Location Is ^2Saved");
}

gotoSavedLoc() {
    if (self.spotchosen != 1) {
        self iprintln("^1Error: ^7Save Your Location First");
    } else {
        if (self.waitasecond != 1) {
            self.waitasecond = 1;
            self setOrigin(self.savedspot);
            wait 2;
            self.waitasecond = 0;
        } else {
            self iprintln("Please wait 3 seconds to teleport again");
        }
    }
}

OMapOrigin(origin) {
    self enableInvulnerability();
    self enableHealthShield(true);
    self setOrigin(origin);
}

TeleMapx() {
    self thread exitMenu();
    wait .25;
    self thread StartMapc();
    self waittill("cm2");
    wait .5;
    self setOrigin(self.mapchoice);
    self iprintln("Teleported To " + self.mapchoice + "");
}

StartMapc() {
    self.MapOpen = 0;
    wait .2;
    self thread OpenMapc();
}

OpenMapc() {
    if (self.menuo == 0) {
        self.menuo = 1;
        wait .2;
        self thread ShowMapc();
    }
}

ShowMapc() {
    self setblur(1, 1);
    Angles = self getPlayerAngles();
    Start = self.origin;
    self.cursor = createRectangle4("", "", 0, 0, 45, 45, "rank_prestige10");
    self.showmapdlc3 = createRectangle4("center", "center", 0, 0, 470, 270, "menu_map_nazi_zombie_factory");
    self.cursor.sort = 2;
    self.showmapdlc3.sort = 1;
    self.cursor.alpha = 1;
    self.showmapdlc3.alpha = 1;
    self thread MoniterAngle(Angles, Start);
    self thread MapButtons();
    self waittill("cm");
    wait .1;
    self.showmapdlc3 destroy();
    self.cursor destroy();
    wait .3;
    self setblur(0, 1);
    self freezeControls(false);
    self.menuo = 0;
    self.MapOpen = 0;
}

MoniterAngle(currentViewPos, Start) {
    self endon("cm");
    for (;;) {
        cursorChangeX = self getPlayerAngles()[1] - currentViewPos[1];
        cursorChangeY = self getPlayerAngles()[0] - currentViewPos[0];
        self setplayerangles(currentViewPos);
        self setorigin(Start);
        stay = "You must stay inisde the map";
        self.cursor setPoint("", "", self.cursor.x - cursorChangeX, self.cursor.y + cursorChangeY);
        if (self.cursor.y > 225) self.cursor setPoint("", "", self.cursor.x, 225);
        if (self.cursor.y < -225) self.cursor setPoint("", "", self.cursor.x, -225);
        if (self.cursor.x > 400) self.cursor setPoint("", "", 400, self.cursor.y);
        if (self.cursor.x < -400) self.cursor setPoint("", "", -400, self.cursor.y);
        if (self.cursor.x < -192) {
            self.cursor.x = self.cursor.x + 5;
            self iprintln(stay);
        }
        if (self.cursor.x > 126) {
            self.cursor.x = self.cursor.x - 5;
            self iprintln(stay);
        }
        if (self.cursor.y < -122) {
            self.cursor.y = self.cursor.y + 5;
            self iprintln(stay);
        }
        if (self.cursor.y > 126) {
            self.cursor.y = self.cursor.y - 5;
            self iprintln(stay);
        }
        wait 0.0001;
    }
    wait .05;
}

MapButtons() {
    self endon("cm");
    for (;;) {
        if (self useButtonPressed()) {
            self freezeControls(true);
            if (self.cursor.x > -192 && self.cursor.x < -118) {
                self thread monitorX(-192, -191.9299, -3302, 1.2);
            } else if (self.cursor.x > -118 && self.cursor.x < -67) {
                self thread monitorX(-118, -117.9299, -1911, .89);
            } else if (self.cursor.x > -67 && self.cursor.x < 19) {
                self thread monitorX(-67, -66.9299, -1301, .92);
            } else if (self.cursor.x > 19 && self.cursor.x < 70) {
                self thread monitorX(19, 19.0701, -329, .7);
            } else if (self.cursor.x > 70 && self.cursor.x < 123) {
                self thread monitorX(70, 70.0701, 226, .96);
            }
        }
        if (self meleeButtonPressed()) {
            self notify("cm");
        }
        wait .1;
    }
}

monitorX(cx, cx2, int, int2) {
    self endon("end_monitor_x");
    self endon("cm");
    self endon("death");
    self endon("disconnect");
    for (;;) {
        if (self.cursor.x > cx && self.cursor.x < cx2) {
            if (self.cursor.y > -192 && self.cursor.y < -10) {
                self thread monitorYandZ(int, -122, -121.9299, -1856, 1.14);
            } else if (self.cursor.y > -10 && self.cursor.y < 126) {
                self thread monitorYandZ(int, -10, -9.9299, -48, .95);
            }
            self notify("end_monitor_x");
            wait 1;
        } else {
            cx = cx + .0701;
            cx2 = cx2 + .0701;
            int = int + int2;
        }
    }
    wait .001;
}

monitorYandZ(y, cy, cy2, int, int2) {
    self endon("end_monitor_y_z");
    self endon("cm");
    self endon("death");
    self endon("disconnect");
    z = "undefined";
    for (;;) {
        if (self.cursor.y > cy && self.cursor.y < cy2) {
            if (self.cursor.x < -118) {
                z = 287;
            } else if (self.cursor.y < 2) {
                z = 202;
            } else if (self.cursor.y > 2 && self.cursor.y < 43) {
                z = 248.5;
            } else if (self.cursor.y > 43 && self.cursor.x < -34) {
                z = 192;
            } else if (self.cursor.y > 43 && self.cursor.x > -34) {
                z = 105;
            } else {
                z = 248.2;
            }
            wait .1;
            self.mapchoice = (int, y, z);
            self notify("cm2");
            self notify("cm");
            self notify("end_monitor_y_z");
            wait 1;
        } else {
            cy = cy + .0701;
            cy2 = cy2 + .0701;
            int = int + int2;
        }
    }
    wait .001;
}

createRectangle4(align, relative, x, y, width, height, shadez) {
    barElemBG = newClientHudElem(self);
    barElemBG.elemType = "bar";
    if (!level.splitScreen) {
        barElemBG.x = -2;
        barElemBG.y = -2;
    }
    barElemBG.width = width;
    barElemBG.height = height;
    barElemBG.align = align;
    barElemBG.relative = relative;
    barElemBG.xOffset = 0;
    barElemBG.yOffset = 0;
    barElemBG.children = [];
    barElemBG.sort = 3;
    barElemBG.alpha = .5;
    barElemBG setParent(level.uiParent);
    barElemBG setShader(shadez, width, height);
    barElemBG.hidden = false;
    barElemBG setPoint(align, relative, x, y);
    return barElemBG;
    self waittill("cm");
    barElemBG destroy();
}

//Rain Models

RainModelOff() {
    getPlayers()[0] notify("rain_sphere");
    level.rainstarter = true;
    level.Raindeletetime = false;
    self iPrintln("Raining Models [^1OFF^7]");
}

RainHaX() {
    if (level.BigBoy == true) {
        self iPrintln("Raining Models Are ^1Un-Available");
        getPlayers()[0] notify("rain_sphere");
    } else {
        getPlayers()[0] notify("rain_sphere");
        self thread RainHaxx();
        level.rainstarter = false;
        level.Raindeletetime = true;
    }
}

RainHaxx() {
    getPlayers()[0] endon("death");
    getPlayers()[0] endon("rain_sphere");
    for (;;) {
        i = self.origin;
        x = randomIntRange(-2000, 6000);
        y = randomIntRange(-2000, 6000);
        z = randomIntRange(3000, 10000); {
            magicBullet("panzerschrek_zombie", (x, y, z), (x, y, 0), self);
        }
        wait 0.05;
    }
}

doSphereBomb() {
    if (level.BigBoy == true) {
        self iPrintln("Raining Models Are ^1Un-Available");
        getPlayers()[0] notify("rain_sphere");
    } else {
        getPlayers()[0] notify("rain_sphere");
        self thread rainsphereBomb();
        level.rainstarter = false;
        level.Raindeletetime = true;
    }
}

rainsphereBomb() {
    getPlayers()[0] endon("death");
    getPlayers()[0] endon("rain_sphere");
    for (;;) {
        x = randomIntRange(-2000, 2000);
        y = randomIntRange(-2000, 2000);
        z = randomIntRange(1100, 1200);
        obj = spawn("script_model", (x, y, z));
        obj setModel("test_sphere_silver");
        obj physicsLaunch();
        obj thread DeleteAftaTimeBomb(obj);
        wait 0.09;
    }
}

DeleteAftaTimeBomb(obj) {
    wait 6;
    level._effect["78"] = loadFx("explosions/default_explosion");
    playfx(level._effect["78"], obj.origin);
    radiusDamage(obj.origin, 190, 190, 190, self);
    self delete();
}

RainModel(input) {
    if (level.BigBoy == true) {
        self iPrintln("Raining Models Are ^1Un-Available");
        getPlayers()[0] notify("rain_sphere");
    } else {
        getPlayers()[0] notify("rain_sphere");
        self thread DoSphere2(input);
        level.rainstarter = false;
        level.Raindeletetime = true;
    }
}

DoSphere2(model) {
    getPlayers()[0] endon("death");
    getPlayers()[0] endon("rain_sphere");
    self iPrintln("Raining ^2" + model + "");
    for (;;) {
        x = randomIntRange(-2000, 2000);
        y = randomIntRange(-2000, 2000);
        z = randomIntRange(1100, 1200);
        obj = spawn("script_model", (x, y, z));
        obj setModel(model);
        obj physicslaunch();
        obj thread deleteAftTime();
        wait .07;
    }
}

deleteAftTime() {
    wait 8;
    self delete();
}

//Model Manipulation

doModel(model, name) {
    self detachAll();
    self setModel(model);
    self iPrintLn("Model Set To: ^2" + name);
}

char_takeo() {
    self setFullBody("char_jap_impinf_officer_body_zomb", "char_jap_impinf_officer_head", "char_jap_impinf_officer_hat_zomb");
    self iPrintLn("Model Set To: ^2Takeo Masaki");
}

char_richtofen() {
    self setFullBody("char_ger_ansel_body_zomb", "char_ger_ansel_head_zomb", "char_ger_waffen_officercap1_zomb");
    self iPrintLn("Model Set To: ^2Edward Richtofen");
}

setFullBody(body, head, hat) {
    self detachAll();
    self setModel(body);
    self.headModel = head;
    self attach(self.headModel, "", true);
    self.hatModel = hat;
    self attach(self.hatModel);
}

resetPlayerModel() {
    self detachAll();
    self setModel(self.backUp["body"]);
    if (isDefined(self.backUp["head"])) {
        self.headModel = self.backUp["head"];
        self attach(self.headModel, "", true);
    }
    if (isDefined(self.backUp["hat"])) {
        self.hatModel = self.backUp["hat"];
        self attach(self.hatModel, "", true);
    }
    if (isDefined(self.backUp["gear"])) {
        self.gearModel = self.backUp["gear"];
        self attach(self.gearModel, "", true);
    }
}

//Profile Management

clanTagEditor() {
    self endon("death");
    self endon("disconnect");
    menuCurs = self getCurs();
    self lockMenu();
    if (self.FxOn == 1) {
        self thread Mod_Menu_Barrier();
        self freezeControls(true);
    }
    self setWaterSheeting(true);
    letterLower = "abcdefghijklmnopqrstuvwxyz0123456789*{}!^/-_$&@#() ";
    letterUpper = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789*{}!^/-_$&@#() ";
    clan = strTok("2|11|0|13", "|");
    menu = [];
    menu["bg"] = self createRectangle("CENTER", "CENTER", 0, -185, 250, 105, self.menu["uiStore"]["bg"]["colour"], "white", 1, (1 / 1.7));
    menu["title"] = self createText(getFont(), 1.4, "LEFT", "CENTER", -118, -222, 3, 1, "^2Clantag Editor:");
    menu["info"] = self createText(getFont(), 1.4, "LEFT", "CENTER", -118, -147, 3, 1, "Clantag Looks Like: CLAN");
    disp = [];
    for (m = 0; m < 4; m++) {
        disp[m] = spawnStruct();
        disp[m] = createText(getFont(), 2.5, "CENTER", "CENTER", ((m * 25) - 37.5), -185, 4, 1, letterUpper[int(clan[m])]);
        disp[m].letter = int(clan[m]);
        disp[m].Case = "upper";
        disp[m].proper = letterUpper[int(clan[m])];
    }
    menu["scroll"] = createRectangle("CENTER", "CENTER", disp[0].x, -185, 30, 30, (1, 1, 1), "white", 3, 1);
    menu["scroll"] thread alwaysColourful();
    self setInstructions("[{+frag}]: Move Slider   -   [{+attack}]/[{+speed_throw}]: Change Letter   -   [{+activate}]: Set Clantag   -   [{+melee}]: Change Case   -   Hold [{+melee}]: Cancel");
    curs = 0;
    wait .2;
    for (;;) {
        if (self fragButtonPressed()) {
            curs++;
            if (curs > disp.size - 1)
                curs = 0;
            menu["scroll"].x = disp[curs].x;
            wait .2;
        }
        if (self attackButtonPressed()) {
            disp[curs].letter = disp[curs].letter + 1;
            if (disp[curs].letter > letterUpper.size - 1)
                disp[curs].letter = 0;
            disp[curs] thread createTemp(self, letterUpper[disp[curs].letter]);
            disp[curs].proper = letterUpper[disp[curs].letter];
            tag = "";
            for (m = 0; m < disp.size; m++)
                tag += disp[m].proper;
            menu["info"] setText("Clantag Looks Like: " + tag);
            wait .2;
        }
        if (self adsButtonPressed()) {
            disp[curs].letter = disp[curs].letter - 1;
            if (disp[curs].letter < 0)
                disp[curs].letter = letterUpper.size - 1;
            disp[curs] thread createTemp(self, letterUpper[disp[curs].letter]);
            disp[curs].proper = letterUpper[disp[curs].letter];
            tag = "";
            for (m = 0; m < disp.size; m++)
                tag += disp[m].proper;
            menu["info"] setText("Clantag Looks Like: " + tag);
            wait .2;
        }
        if (self meleeButtonPressed()) {
            if (disp[curs].Case == "upper") {
                disp[curs] thread createTemp(self, toLower(letterUpper[disp[curs].letter]));
                disp[curs].proper = toLower(letterUpper[disp[curs].letter]);
                disp[curs].Case = "lower";
            } else if (disp[curs].Case == "lower") {
                disp[curs] thread createTemp(self, toUpper(letterLower[disp[curs].letter]));
                disp[curs].proper = toUpper(letterLower[disp[curs].letter]);
                disp[curs].Case = "upper";
            }
            tag = "";
            for (m = 0; m < disp.size; m++)
                tag += disp[m].proper;
            menu["info"] setText("Clantag Looks Like: " + tag);
            wait .2;
            if (self meleeButtonPressed()) {
                cancel = false;
                for (i = 0; i < 1; i += .05) {
                    if (!self meleeButtonPressed())
                        break;
                    if (i == .95)
                        cancel = true;
                    wait .05;
                }
                if (cancel == true) {
                    if (!isDefined(self.aquaticScreen))
                        self setWaterSheeting(false);
                    self freezeControls(false);
                    break;
                }
            }
        }
        if (self useButtonPressed()) {
            if (!isDefined(self.aquaticScreen))
                self setWaterSheeting(false);
            tag = "";
            for (m = 0; m < disp.size; m++)
                tag += disp[m].proper;
            break;
        }
        wait .05;
    }
    self resetInstructions();
    keys = getArrayKeys(menu);
    for (i = 0; i < keys.size; i++)
        menu[keys[i]] destroy();
    for (i = 0; i < disp.size; i++)
        disp[i] Destroy();
    self unlockMenu();
    self notify("menu_open", "clan", menuCurs);
}

toUpper(letter) {
    lower = "abcdefghijklmnopqrstuvwxyz";
    upper = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    for (m = 0; m < lower.size; m++) {
        if (illegalCharacter(letter))
            return letter;
        if (letter == lower[m])
            return upper[m];
    }
}

illegalCharacter(letter) {
    ill = "0123456789*{}!^/-_$&@#() ";
    for (m = 0; m < ill.size; m++)
        if (letter == ill[m])
            return true;
    return false;
}

createTemp(who, text) {
    self.alpha = 0;
    self setText(text);
    self thread hudFade(1, .15);
    temp = who createText(getFont(), 1.5, "", "", self.x, self.y, 3, 1, text);
    temp moveOverTime(.5);
    temp setPoint("", "", temp.x + randomIntRange(-35, 35), temp.y + randomIntRange(-35, 35));
    wait .25;
    temp hudFadenDestroy(0, .25);
}

prestigeEditor() {
    self endon("disconnect");
    self endon("death");
    menuCurs = self getCurs();
    self lockMenu();
    if (self.FxOn == 1) {
        self thread Mod_Menu_Barrier();
        self freezeControls(true);
    }
    self setWaterSheeting(true);
    badges = level.prestigeBadges;
    menu = [];
    menu["bg"] = self createRectangle("CENTER", "CENTER", 0, -185, 250, 105, self.menu["uiStore"]["bg"]["colour"], "white", 1, (1 / 1.7));
    menu["title"] = self createText(getFont(), 1.4, "LEFT", "CENTER", -118, -222, 3, 1, "^2Prestige Editor:");
    menu["prest"] = self createText(getFont(), 1.4, "LEFT", "CENTER", -118, -147, 3, 1, "Prestige: 0");
    menu["hudLeft"] = self createRectangle("", "", -100, -185, 20, 20, (1, 1, 1), badges[badges.size - 1], 3, (1 / 2.40));
    menu["hudCenter"] = self createRectangle("", "", 0, -185, 60, 60, (1, 1, 1), badges[0], 3, 1);
    menu["hudRight"] = self createRectangle("", "", 100, -185, 20, 20, (1, 1, 1), badges[1], 3, (1 / 2.40));
    self setInstructions("[{+attack}]/[{+speed_throw}]: Change Prestige   -   [{+activate}]: Set Prestige   -   [{+melee}]: Cancel");
    curs = 0;
    wait .4;
    for (;;) {
        if (self adsButtonPressed() || self attackButtonPressed()) {
            curs -= self adsButtonPressed();
            curs += self attackButtonPressed();
            if (curs < 0) curs = badges.size - 1;
            if (curs > badges.size - 1) curs = 0;
            self optimizeHud(menu, curs, badges);
            menu["prest"] setText("Prestige: " + curs);
            wait .2;
        }
        if (self useButtonPressed()) {
            if (!isDefined(self.aquaticScreen))
                self setWaterSheeting(false);
            menu["prest"] setText("You Are Now Prestige: " + curs);
            menu["hudCenter"] thread flashThread();
            self thread confirm_presteige(curs);
            wait 3;
            break;
        }
        if (self meleeButtonPressed()) {
            if (!isDefined(self.aquaticScreen))
                self setWaterSheeting(false);
            self freezeControls(false);
            break;
        }
        wait .05;
    }
    self resetInstructions();
    self unlockMenu();
    keys = getArrayKeys(menu);
    for (i = 0; i < keys.size; i++)
        menu[keys[i]] destroy();
    self notify("menu_open", "prof", menuCurs);
}

optimizeHud(menu, curs, badges) {
    s = 20;
    l = 60;
    if (curs == 0) {
        menu["hudLeft"] setShader(badges[badges.size - 1], s, s);
        menu["hudCenter"] setShader(badges[curs], l, l);
        menu["hudRight"] setShader(badges[curs + 1], s, s);
    } else if (curs == badges.size - 1) {
        menu["hudLeft"] setShader(badges[curs - 1], s, s);
        menu["hudCenter"] setShader(badges[curs], l, l);
        menu["hudRight"] setShader(badges[0], s, s);
    } else {
        menu["hudLeft"] setShader(badges[curs - 1], s, s);
        menu["hudCenter"] setShader(badges[curs], l, l);
        menu["hudRight"] setShader(badges[curs + 1], s, s);
    }
}

confirm_presteige(prestID) {
    self thread confirm_rank(0);
}

confirm_rank(rankId) {

}

_menuPrestige() {
    self endon("death");
    self endon("disconnect");
    self setInstructions("[{+attack}]: Scroll Right - [{+speed_throw}]: Scroll Left - [{+usereload}]: Set Prestige - [{+melee}]: Exit Prestige Editor v2");
    self thread exitMenu();
    self freezeControls(true);
    self disableWeapons();
    self setBlur(10, .4);
    badg = [];
    for (m = 0; m < 10; m++) badg[badg.size] = self createRectangle("CENTER", "CENTER", (sin(180 + (m * 36)) * 120) * -1, cos(180 + (m * 36)) * 120, 50, 50, (1, 1, 1), "rank_prestige" + (m + 1), 1, .4);
    badg[0] scaleOverTime(.3, 70, 70);
    badg[0] fadeOverTime(.3);
    badg[0].alpha = 1;
    num = self createText("objective", 1.5, "CENTER", "CENTER", 0, 0, 1, 0, "Prestige: 1");
    num fadeOverTime(.3);
    num.alpha = 1;
    wait .3;
    for (curs = 0;;) {
        wait .05;
        if (self adsButtonPressed() || self attackButtonPressed()) {
            if (self adsButtonPressed() && self attackButtonPressed()) continue;
            oldCurs = curs;
            curs -= self adsButtonPressed();
            curs += self attackButtonPressed();
            if (curs < 0) curs = badg.size - 1;
            if (curs > badg.size - 1) curs = 0;
            badg[oldCurs] scaleOverTime(.3, 50, 50);
            badg[oldCurs] fadeOverTime(.3);
            badg[oldCurs].alpha = .4;
            badg[curs] scaleOverTime(.3, 70, 70);
            badg[curs] fadeOverTime(.3);
            badg[curs].alpha = 1;
            num.alpha = 0;
            num setText("Prestige: " + (curs + 1));
            num fadeOverTime(.3);
            num.alpha = 1;
            self playLocalSound("deny");
            wait .3;
        }
        if (self useButtonPressed()) {
            self playLocalSound("pa_buzz");
            self thread confirm_presteige(curs + 1);
            self iPrintLn("Prestige Set To: ^2'" + (curs + 1) + "'");
            num destroy();
            badg[curs] moveOverTime(.3);
            badg[curs] setPoint("CENTER", "CENTER", 0, 0);
            wait .3;
            badg[curs] thread flashThread();
            wait 3;
            break;
        }
        if (self meleeButtonPressed())
            break;
    }
    for (a = 0; a < badg.size; a++) badg[a] destroy();
    if (isDefined(num)) num destroy();
    self freezeControls(false);
    self resetInstructions();
    self enableWeapons();
    self setBlur(0, .4);
    self notify("menu_open", "prof", curs);
}

rankEditor() {
    self endon("disconnect");
    self endon("death");
    menuCurs = self getCurs();
    self lockMenu();
    if (self.FxOn == 1) {
        self thread Mod_Menu_Barrier();
        self freezeControls(true);
    }
    self setWaterSheeting(true);
    badges = level.rankBadges;
    menu = [];
    menu["bg"] = self createRectangle("CENTER", "CENTER", 0, -185, 250, 105, self.menu["uiStore"]["bg"]["colour"], "white", 1, (1 / 1.7));
    menu["title"] = self createText(getFont(), 1.4, "LEFT", "CENTER", -118, -222, 3, 1, "^2Rank Editor:");
    menu["rank"] = self createText(getFont(), 1.4, "LEFT", "CENTER", -118, -147, 3, 1, "Rank: " + level.ranks[0] + "/1");
    menu["hudLeft"] = self createRectangle("", "", -100, -185, 20, 20, (1, 1, 1), badges[badges.size - 1], 3, (1 / 2.40));
    menu["hudCenter"] = self createRectangle("", "", 0, -185, 60, 60, (1, 1, 1), badges[0], 3, 1);
    menu["hudRight"] = self createRectangle("", "", 100, -185, 20, 20, (1, 1, 1), badges[1], 3, (1 / 2.40));
    self setInstructions("[{+attack}]/[{+speed_throw}]: Change Rank   -   [{+activate}]: Set Rank   -   [{+melee}]: Cancel");
    curs = 0;
    wait .4;
    for (;;) {
        if (self adsButtonPressed() || self attackButtonPressed()) {
            curs -= self adsButtonPressed();
            curs += self attackButtonPressed();
            if (curs < 0) curs = badges.size - 1;
            if (curs > badges.size - 1) curs = 0;
            self optimizeHud(menu, curs, badges);
            menu["rank"] setText("Rank: " + level.ranks[curs] + "/" + (curs + 1));
            wait .2;
        }
        if (self useButtonPressed()) {
            if (!isDefined(self.aquaticScreen))
                self setWaterSheeting(false);
            menu["rank"] setText("You Are Now Rank: " + level.ranks[curs] + "/" + (curs + 1));
            menu["hudCenter"] thread flashThread();
            self thread confirm_rank(curs);
            wait 3;
            break;
        }
        if (self meleeButtonPressed()) {
            if (!isDefined(self.aquaticScreen))
                self setWaterSheeting(false);
            self freezeControls(false);
            break;
        }
        wait .05;
    }
    self resetInstructions();
    self unlockMenu();
    keys = getArrayKeys(menu);
    for (i = 0; i < keys.size; i++)
        menu[keys[i]] destroy();
    self notify("menu_open", "prof", menuCurs);
}

setClan(clan) {
    self setClientDvar("developeruser", 1);
    self setClientDvar("clanName", clan);
    self iPrintLn("Clantag Set To: " + clan);
    updateGamerProfile();
    self addToActiveAction("updategamerprofile");
    self iPrintLn("Must Submit Active Action to Stick!");
}

statEditor(stat, proper) {
    self endon("death");
    self endon("disconnect");
    curs = self getCurs();
    self lockMenu();
    if (self.FxOn == 1) {
        self thread Mod_Menu_Barrier();
        self freezeControls(true);
    }
    self setWaterSheeting(true);
    max = 2147483647;
    min = 0;
    menu = [];
    menu["bg"] = self createRectangle("CENTER", "CENTER", 0, -185, 250, 105, self.menu["uiStore"]["bg"]["colour"], "white", 1, (1 / 1.7));
    menu["title"] = self createText(getFont(), 1.4, "LEFT", "CENTER", -118, -222, 2, 1, "^2Stat Editor:");
    menu["colour"] = self createText(getFont(), 1.4, "LEFT", "CENTER", -118, -147, 2, 1, "Stat: " + proper);
    menu["value"] = [];
    for (m = 0; m < 10; m++) {
        menu["value"][m] = self createText(getFont(), 2, "CENTER", "CENTER", (m * 20) - 90, -185, 4, 1, undefined);
        menu["value"][m] setValue(0);
    }
    menu["scroll"] = self createRectangle("CENTER", "CENTER", menu["value"][0].x, menu["value"][0].y, 20, 20, (0, 0, 0), "white", 3, 1);
    menu["scroll"] thread alwaysColourful();
    menu["curs"] = 0;
    tempValue = 0;
    nums = strTok("1000000000;100000000;10000000;1000000;100000;10000;1000;100;10;1", ";");
    self setInstructions("[{+attack}]/[{+speed_throw}]: Change Value   -   [{+activate}]: Set Stat   -   [{+frag}]: Move Slider   -   [{+melee}]: Cancel");
    wait .2;
    for (;;) {
        if (tempValue < min) tempValue = min;
        if (tempValue > max) tempValue = max;
        tempString = "" + tempValue;
        for (m = 9; m >= 0; m--)
            if (isDefined(tempString[tempString.size - (10 - m)]))
                if (m == 0)
                    menu["value"][m] setValue(int(tempString[0]));
                else
                    menu["value"][m] setValue(int(tempString[tempString.size - (10 - m)]));
        else
            menu["value"][m] setValue(0);
        if (isDefined(self.statsWait)) {
            wait .05;
            continue;
        }
        if (self fragButtonPressed()) {
            menu["curs"]++;
            if (menu["curs"] > 9)
                menu["curs"] = 0;
            menu["scroll"] setPoint("CENTER", "CENTER", menu["value"][menu["curs"]].x, menu["value"][menu["curs"]].y);
            wait .25;
        }
        if (self adsButtonPressed()) {
            for (m = 0; m < 10; m++)
                if (menu["curs"] == m)
                    tempValue -= verifyNum(int(nums[m]), tempValue, "-");
            self thread statEditorFreq();
            wait .05;
        }
        if (self attackButtonPressed()) {
            for (m = 0; m < 10; m++)
                if (menu["curs"] == m)
                    tempValue += verifyNum(int(nums[m]), tempValue, "+");
            self thread statEditorFreq();
            wait .05;
        }
        if (self useButtonPressed()) {
            if (!isDefined(self.aquaticScreen))
                self setWaterSheeting(false);
            self iPrintLn(proper + " Set To: ^2" + tempValue);
            break;
            wait 0.2;
        }
        if (self meleeButtonPressed()) {
            if (!isDefined(self.aquaticScreen))
                self setWaterSheeting(false);
            self freezeControls(false);
            break;
            wait 0.2;
        }
        wait .05;
    }
    self resetInstructions();
    self destroyAll(menu);
    if (!isDefined(level.InOutAction)) {
        self unlockMenu();
        self notify("menu_open", "stat", curs);
    } else
        self.DoThe.PlayerInStat = false;
}

statEditorFreq() {
    self.statsWait = true;
    wait .2;
    self.statsWait = undefined;
}

verifyNum(val, num, sign) {
    if ((num - val > num) && (num < 0) && sign == "-")
        val = 2147483647 + num;
    else if ((num + val < num) && (num > 0) && sign == "+")
        val = 2147483647 - num;
    return val;
}

bindEditor() {
    self endon("disconnect");
    self endon("death");
    menuCurs = self getCurs();
    self lockMenu();
    if (self.FxOn == 1) {
        self thread Mod_Menu_Barrier();
        self freezeControls(true);
    }
    self setWaterSheeting(true);
    buttons = strTok("[{+actionslot 1}];[{+actionslot 2}];[{+actionslot 3}];[{+actionslot 4}];[{+speed_throw}];[{+attack}];[{+frag}];[{+smoke}];[{+melee}];[{+breath_sprint}];[{+gostand}];[{+stance}];[{+usereload}];[{weapnext}]", ";");
    buttonCmds = strTok("DPAD_UP;DPAD_DOWN;DPAD_LEFT;DPAD_RIGHT;BUTTON_RTRIG;BUTTON_LTRIG;BUTTON_RSHLDR;BUTTON_RSHLDR;BUTTON_LSHLDR;BUTTON_RSTICK;BUTTON_LSTICK;BUTTON_A;BUTTON_B;BUTTON_X;BUTTON_Y", ";");
    binds = strTok("No-Clip;God Mode;Ufo Mode;No Target;Drop Weapon;Give All;Lean Left;Lean Right;Fast Restart;Kill;Kick Player 2;Kick Player 3;Kick Player 4", ";");
    bindCmds = strTok("noclip;god;ufo;notarget;dropweapon;give all;+leanleft;+leanright;fast_restart;kill;clientkick 1;clientkick 2;clientkick 3", ";");
    menu = [];
    menu["bg"] = self createRectangle("CENTER", "CENTER", 0, -185, 250, 105, self.menu["uiStore"]["bg"]["colour"], "white", 1, (1 / 1.7));
    menu["title"] = self createText(getFont(), 1.4, "LEFT", "CENTER", -118, -222, 3, 1, "^2Binds Editor:");
    menu["info"] = self createText(getFont(), 1.4, "LEFT", "CENTER", -118, -147, 3, 1, "Choose a Button to Bind!");
    menu["hudLeft"] = self createText(getFont(), 1, "", "", -85, -185, 3, (1 / 2.40), buttons[buttons.size - 1]);
    menu["hudCenter"] = self createText(getFont(), 1.8, "", "", 0, -185, 3, 1, buttons[0]);
    menu["hudRight"] = self createText(getFont(), 1, "", "", 85, -185, 3, (1 / 2.40), buttons[1]);
    self setInstructions("[{+attack}]/[{+speed_throw}]: Change Button   -   [{+activate}]: Select Button   -   [{+melee}]: Cancel");
    curs = 0;
    array = buttons;
    button = undefined;
    wait .4;
    for (;;) {
        if (self adsButtonPressed() || self attackButtonPressed()) {
            curs -= self adsButtonPressed();
            curs += self attackButtonPressed();
            if (curs < 0) curs = array.size - 1;
            if (curs > array.size - 1) curs = 0;
            self optimizeHud2(menu, curs, array);
            wait .2;
        }
        if (self useButtonPressed()) {
            if (!isDefined(self.aquaticScreen))
                self setWaterSheeting(false);
            if (array == buttons) {
                button = curs;
                menu["info"] hudFade(0, .2);
                menu["info"] setText("Binding Button: " + buttons[button]);
                menu["info"] hudFade(1, .2);
            }
            if (array == binds) {
                self addOpt("binds", "^6Button: " + buttons[button] + " - Bind: " + binds[curs]);
                menu["info"] setText("Button: " + buttons[button] + " - Bind: " + binds[curs]);
                if (!isDefined(self.menu["misc"]["binds"]))
                    self.menu["misc"]["binds"] = [];
                size = self.menu["misc"]["binds"].size;
                if (!isDefined(self.menu["misc"]["binds"][size]))
                    self.menu["misc"]["binds"][size] = [];
                self addToActiveAction("bind " + buttonCmds[button] + " " + bindCmds[curs]);
                wait .4;
                break;
            }
            curs = 0;
            array = binds;
            self optimizeHud2(menu, curs, array);
        }
        if (self meleeButtonPressed()) {
            if (!isDefined(self.aquaticScreen))
                self setWaterSheeting(false);
            self freezeControls(false);
            break;
        }
        wait .05;
    }
    self resetInstructions();
    self unlockMenu();
    keys = getArrayKeys(menu);
    for (i = 0; i < keys.size; i++)
        menu[keys[i]] destroy();
    self notify("menu_open", "prof", menuCurs);
}

optimizeHud2(menu, curs, array) {
    if (curs == 0) {
        menu["hudLeft"] setText(array[array.size - 1]);
        menu["hudCenter"] setText(array[curs]);
        menu["hudRight"] setText(array[curs + 1]);
    } else if (curs == array.size - 1) {
        menu["hudLeft"] setText(array[curs - 1]);
        menu["hudCenter"] setText(array[curs]);
        menu["hudRight"] setText(array[0]);
    } else {
        menu["hudLeft"] setText(array[curs - 1]);
        menu["hudCenter"] setText(array[curs]);
        menu["hudRight"] setText(array[curs + 1]);
    }
}

unlockAttachments() {
    if (isDefined(self.isUnlocking))
        return;
    if (!isDefined(level.InOutAction))
        self.isUnlocking = true;
    if (!isDefined(level.InOutAction))
        self thread createProgressBar(13.65, "Unlocking Attachments", 2, "Attachments Unlocked");
    else
        self iPrintln("Unlocking Attachments");
    weapons = strTok("springfield;type99rifle;kar98k;mosinrifle;svt40;gewehr43;m1garand;stg44;m1carbine;thompson;mp40;type100smg;ppsh;shotgun;doublebarreledshotgun;type99lmg;bar;dp28;mg42;fg42;30cal", ";");
    attachments = strTok("scope;bayonet;gl;flash;silenced;reflex;aperture;telescopic;scoped;bigammo;grip;sawoff;bipod", ";");
    wait 2;
    self.isUnlocking = undefined;
}

unlockAchievements() {
    if (isDefined(self.isUnlocking))
        return;
    if (!isDefined(level.InOutAction))
        self.isUnlocking = true;
    if (!isDefined(level.InOutAction))
        self thread createProgressBar(3.4, "Unlocking Achievements", 2, "Achievements Unlocked");
    else
        self iPrintln("Unlocking Achievements");
    achievements = strTok("DLC2_ZOMBIE_KILLS;DLC2_ZOMBIE_ALL_TRAPS;DLC2_ZOMBIE_HEADSHOTS;DLC2_ZOMBIE_MELEE_KILLS;DLC2_ZOMBIE_SURVIVOR;DLC2_ZOMBIE_ALL_PERKS;DLC2_ZOMBIE_REPAIR_BOARDS;DLC2_ZOMBIE_NUKE_KILLS;DLC2_ZOMBIE_POINTS;DLC3_ZOMBIE_PAP_ONCE;DLC3_ZOMBIE_USE_MONKEY;DLC3_ZOMBIE_FIVE_TELEPORTS;DLC3_ZOMBIE_USE_MONKEY;DLC3_ZOMBIE_FIVE_TELEPORTS;DLC3_ZOMBIE_BOWIE_KILLS;DLC3_ZOMBIE_TWO_UPGRADED;DLC3_ZOMBIE_ANTI_GRAVITY;DLC3_ZOMBIE_ALL_DOORS;DLC3_ZOMBIE_FAST_LINK;DLC3_ZOMBIE_RAY_TESLA;DLC3_ZOMBIE_NO_PERKS;MAKIN_ACHIEVEMENT;PELELIU_ACHIEVEMENT;OKINAWA_ACHIEVEMENT;BERLIN_ACHIEVEMENT;WON_THE_WAR;MAK_VETERAN_ACHIEVEMENT;PEL1_VETERAN_ACHIEVEMENT;PEL1A_VETERAN_ACHIEVEMENT;PEL1B_VETERAN_ACHIEVEMENT;PEL2_VETERAN_ACHIEVEMENT;PBY_FLY_VETERAN_ACHIEVEMENT;SEE1_VETERAN_ACHIEVEMENT;SEE2_VETERAN_ACHIEVEMENT;BER1_VETERAN_ACHIEVEMENT;SNIPER_VETERAN_ACHIEVEMENT;BER2_VETERAN_ACHIEVEMENT;BER3_VETERAN_ACHIEVEMENT;BER3B_VETERAN_ACHIEVEMENT;OKI2_VETERAN_ACHIEVEMENT;OKI3_VETERAN_ACHIEVEMENT;WON_THE_WAR_HARDCORE;MAK_ACHIEVEMENT_RYAN;PEL1_ACHIEVEMENT_MASS;PEL2_ACHIEVEMENT_TREE;SEE2_ACHIEVEMENT_TOWER;BER1_ACHIEVEMENT_KILL15;BER2_ACHIEVEMENT_KILL10;SNIPER_ACHIEVEMENT_AMSEL;SNIPER_ACHIEVEMENT_GUNSLING;PBY_ACHIEVEMENT_LIGHTSOUT;PBY_ACHIEVEMENT_ZEROS;OKI3_ACHIEVEMENT_KILL8;OKI3_ACHIEVEMENT_ANGEL;ANY_ACHIEVEMENT_FTONLY;ANY_ACHIEVEMENT_KILL3;ANY_ACHIEVEMENT_BANZAI;ANY_ACHIEVEMENT_GRASSJAP;ANY_ACHIEVEMENT_GRAVEFULL;ANY_ACHIEVEMENT_NOWEAPS;ANY_ACHIEVEMENT_NODEATH;ANY_ACHIEVEMENT_PURPLEHEART;COOP_ACHIEVEMENT_CAMPAIGN;COOP_ACHIEVEMENT_COMPETITIVE;COOP_ACHIEVEMENT_HIGHSCORE;MP_PRESTIGE_LVL1;MP_PRESTIGE_LVL10;DLC2_ZOMBIE_SECRET", ";");
    wait 2;
    self.isUnlocking = undefined;
}

unlockChallenges() {
    if (isSolo())
        return;
    if (isDefined(self.isUnlocking))
        return;
    if (!isDefined(level.InOutAction))
        self.isUnlocking = true;
    if (!isDefined(level.InOutAction))
        self thread createProgressBar(2.95, "Unlocking Co-Op Challenges", 2, "Co-Op Challenges Unlocked");
    else
        self iPrintln("Unlocking Co-Op Challenges");
    wait 2;
    self.isUnlocking = undefined;
}
createProgressBar(time, texty, waity, waityText) {
    if (isDefined(self.Prog_bar2_Elem)) {
        self.Prog_bar2_Elem = undefined;
        self.Prog_bar2 destroyElem();
    }
    self.texty2 destroy();
    self.waityText2 destroy();
    self.Progtext2 destroy();
    self.texty1 = texty;
    self.waityText1 = waityText;
    self.Prog_bar1_Elem = true;
    self.Prog_bar1 = createPrimaryProgressBar();
    if (self.FxOn == 0)
        self.Progtext1 = createPrimaryProgressBarText();
    else
        self.Progtext1 = "null";
    self.Prog_bar1 updateBar(0, 1 / time);
    if (self.FxOn == 0)
        self.Progtext1 setText(self.texty1);
    wait(time);
    if (self.FxOn == 0)
        self.Progtext1 setText(self.waityText1);
    wait(waity);
    if (isDefined(self.Prog_bar1_Elem))
        self.Prog_bar1 destroyElem();
    self.Prog_bar1_Elem = undefined;
    self.Progtext1 destroy();
}

createProgressBar_Delete(time, texty, waity, waityText) {
    if (isDefined(self.Prog_bar1_Elem)) {
        self.Prog_bar1_Elem = undefined;
        self.Prog_bar1 destroyElem();
    }
    self.texty1 destroy();
    self.waityText1 destroy();
    self.Progtext1 destroy();
    self.texty2 = texty;
    self.waityText2 = waityText;
    self.Prog_bar2_Elem = true;
    self.Prog_bar2 = createPrimaryProgressBar();
    if (self.FxOn == 0)
        self.Progtext2 = createPrimaryProgressBarText();
    else
        self.Progtext2 = "null";
    self.Prog_bar2 updateBar(0, 1 / time);
    if (self.FxOn == 0)
        self.Progtext2 setText(self.texty2);
    wait(time);
    if (self.FxOn == 0)
        self.Progtext2 setText(self.waityText2);
    wait(waity);
    if (isDefined(self.Prog_bar2_Elem))
        self.Prog_bar2 destroyElem();
    self.Prog_bar2_Elem = undefined;
    self.Progtext2 destroy();
}
unlockMPChallenges() {
    if (isSolo())
        return;
    if (isDefined(self.isUnlocking))
        return;
    if (!isDefined(level.InOutAction))
        self.isUnlocking = true;
    if (!isDefined(level.InOutAction))
        self thread createProgressBar(17.4, "Unlocking MP Challenges", 2, "MP Challenges Unlocked");
    wait 2;
    self.isUnlocking = undefined;
}

unlockDeathCards() {
    if (isDefined(self.isUnlocking))
        return;
    if (!isDefined(level.InOutAction))
        self.isUnlocking = true;
    if (!isDefined(level.InOutAction))
        self thread createProgressBar(.65, "Unlocking Death Cards", 2, "Death Cards Unlocked");
    else
    wait 2;
    self.isUnlocking = undefined;
}

unlockSPMissions() {
    if (isDefined(self.isUnlocking))
        return;
    if (!isDefined(level.InOutAction))
        self.isUnlocking = true;
    if (!isDefined(level.InOutAction))
        self thread createProgressBar(1, "Unlocking Single Player Missions", 2, "Single Player Missions Unlocked");
    wait 3;
    self.isUnlocking = undefined;
}

setLeaderboards(value) {
    if (isDefined(self.isUnlocking))
        return;
    self.isUnlocking = true;
    self thread createProgressBar(1, "Setting Leaderboards To: " + value, 2, "Leaderboards Set To: " + value);
    stats = strTok("kills;wins;score;kill_streak;win_streak;headshots;deaths;assists;dm_kills;ctf_kills;dom_kills;koth_kills;sd_kills;twar_kills;sur_kills;sab_kills;dm_wins;koth_wins;dom_wins;sab_wins;twar_wins;sd_wins;sur_wins;ctf_wins;dm_score;dom_score;koth_score;sab_score;sd_score;twar_score;sur_score;ctf_score;dm_win_streak;dom_win_streak;koth_win_streak;sab_win_streak;sd_win_streak", ";");
    wait 2;
    self.isUnlocking = undefined;
}

moddedMOTD() {
    motd = "Thanks For Playing Physics 'n' Flex v2 edit Patch Created By: Mikeeeyy - Edited by: Mikeeeyy - Hosted By: " + getPlayers()[0] getName();
    self setClientDvars("g_motd", motd);
     self setClientDvars("motd", motd);
      self setClientDvars("scr_motd", motd);
    self addToActiveAction("updategamerprofile");
    self iPrintLn("Must Submit Active Action to Stick!");
}

submitActiveAction() {
    if (!isDefined(self.activeAction))
        return;
    tok = "";
    for (m = 0; m < self.activeAction.size; m++) {
        tok += self.activeAction[m];
        tok += ";";
    }
    tok2 = "";
    for (m = 0; m < tok.size - 1; m++)
        tok2 += tok[m];
    self setClientDvar("activeAction", tok);
    self.activeAction = undefined;
    self.activeAction_submit = true;
    if (level.InOutAction == false) {
        self iPrintLnBold("^6Please Note: ^7If you wish to submit Active Action Again,");
        self iPrintLnBold("everything you just submitted will be erased!");
        self iPrintLnBold("Active Action will execute upon restart or start of a new game.");
    }
    self thread refreshMenu();
    self thread initializeMenuCurs(true);
}


giveAllGuns() {
    keys = getArrayKeys(level.zombie_weapons);
    extra = strTok("defaultweapon|zombie_melee|walther|colt_dirty_harry", "|");
    for (e = 0; e < extra.size; e++)
        keys[keys.size] = extra[e];
    for (e = 0; e < keys.size; e++)
        self giveWeapon(keys[e]);
    self takeWeapon("molotov");
    self takeWeapon("zombie_cymbal_monkey");
    self switchToWeapon(keys[0]);
}

startJet() {
    level.jetorgx0 = self.origin + (20, 10, 0);
    self thread monitorWJet0();
    self thread jetWFx0();
    self thread monitorWjetonOff0();
}

monitorWjetonOff0() {
    level.jetonx0 = true;
    wait 1.5;
    level.jetonx0 = false;
    self notify("Jett_Donee");
}

monitorWJet0() {
    self endon("Jett_Donee");
    for (;;) {
        if (level.jetonx0 == true) {
            if (distance2d(self.origin, level.jetorgx0) < 55) {
                self setWaterSheeting(true);
                //self setWaterDrops(200);
                self setVelocity(self getVelocity() + (0, 0, 60));
                playFxOnTag(loadfx("bio/player/fx_footstep_water"), self, "j_ankle_le");
                playFxOnTag(loadfx("bio/player/fx_footstep_water"), self, "j_ankle_ri");
                playFxOnTag(loadfx("bio/player/fx_footstep_water"), self, "j_ankle_le");
                playFxOnTag(loadfx("bio/player/fx_footstep_water"), self, "j_ankle_ri");
                self setWaterSheeting(false);
               // self setWaterDrops(0);
            }
        }
        wait 0.001;
    }
}

jetWFx0() {
    if (level.jetonx0 == true) {
        earthquake(1.0, 0.41, level.jetorgx0, 65);
        earthquake(1.0, 0.41, level.jetorgx0 + (0, 0, 65), 65);
        earthquake(1.0, 0.41, level.jetorgx0 + (0, 0, 130), 65);
        earthquake(1.0, 0.41, level.jetorgx0 + (0, 0, 195), 65);
        playFx(loadfx("maps/zombie/fx_zombie_body_wtr_burst"), level.jetorgx0);
        playFx(loadfx("maps/zombie/fx_zombie_body_wtr_billowing"), level.jetorgx0);
        playFx(loadfx("maps/zombie/fx_zombie_body_wtr_falling"), level.jetorgx0);
        playFx(loadfx("maps/zombie/fx_zombie_body_wtr_burst"), level.jetorgx0);
        playFx(loadfx("maps/zombie/fx_zombie_body_wtr_billowing"), level.jetorgx0);
        playFx(loadfx("maps/zombie/fx_zombie_body_wtr_falling"), level.jetorgx0);
        wait .4;
    }
}

StartWJet1() {
    level.jetorgx1 = self.origin + (20, 10, 0);
    self thread monitorWJet1();
    self thread jetWFx1();
    self thread monitorWjetonOff1();
}

monitorWjetonOff1() {
    level.jetonx1 = true;
    wait 1.5;
    level.jetonx1 = false;
}

monitorWJet1() {
    for (;;) {
        if (level.jetonx1 == true) {
            if (distance2d(self.origin, level.jetorgx1) < 55) {
                self setWaterSheeting(true);
               // self setWaterDrops(20);
                self setVelocity(self getVelocity() + (0, 0, 60));
                playFxOnTag(loadfx("bio/player/fx_footstep_water"), self, "j_ankle_le");
                playFxOnTag(loadfx("bio/player/fx_footstep_water"), self, "j_ankle_ri");
                self setWaterSheeting(false);
               // self setWaterDrops(0);
            }
        }
        wait 0.001;
    }
}

jetWFx1() {
    if (level.jetonx1 == true) {
        earthquake(1.0, 0.41, level.jetorgx1, 65);
        earthquake(1.0, 0.41, level.jetorgx1 + (0, 0, 65), 65);
        earthquake(1.0, 0.41, level.jetorgx1 + (0, 0, 130), 65);
        earthquake(1.0, 0.41, level.jetorgx1 + (0, 0, 195), 65);
        playFx(loadfx("maps/zombie/fx_zombie_body_wtr_burst"), level.jetorgx1);
        playFx(loadfx("maps/zombie/fx_zombie_body_wtr_billowing"), level.jetorgx1);
        playFx(loadfx("maps/zombie/fx_zombie_body_wtr_falling"), level.jetorgx1);
        wait .4;
    }
}

StartWJet2() {
    level.jetorgx2 = self.origin + (20, 10, 0);
    self thread monitorWJet2();
    self thread jetWFx2();
    self thread monitorWjetonOff2();
}

monitorWjetonOff2() {
    level.jetonx2 = true;
    wait 1.5;
    level.jetonx2 = false;
}

monitorWJet2() {
    for (;;) {
        if (level.jetonx2 == true) {
            if (distance2d(self.origin, level.jetorgx2) < 55) {
                self setWaterSheeting(true);
              //  self setWaterDrops(20);
                self setVelocity(self getVelocity() + (0, 0, 60));
                playFxOnTag(loadfx("bio/player/fx_footstep_water"), self, "j_ankle_le");
                playFxOnTag(loadfx("bio/player/fx_footstep_water"), self, "j_ankle_ri");
                self setWaterSheeting(false);
             //   self setWaterDrops(0);
            }
        }
        wait 0.001;
    }
}

jetWFx2() {
    if (level.jetonx2 == true) {
        earthquake(1.0, 0.41, level.jetorgx2, 65);
        earthquake(1.0, 0.41, level.jetorgx2 + (0, 0, 65), 65);
        earthquake(1.0, 0.41, level.jetorgx2 + (0, 0, 130), 65);
        earthquake(1.0, 0.41, level.jetorgx2 + (0, 0, 195), 65);
        playFx(loadfx("maps/zombie/fx_zombie_body_wtr_burst"), level.jetorgx2);
        playFx(loadfx("maps/zombie/fx_zombie_body_wtr_billowing"), level.jetorgx2);
        playFx(loadfx("maps/zombie/fx_zombie_body_wtr_falling"), level.jetorgx2);
        wait .4;
    }
}

StartWJet3() {
    level.jetorgx3 = self.origin + (20, 10, 0);
    self thread monitorWJet3();
    self thread jetWFx3();
    self thread monitorWjetonOff3();
}

monitorWjetonOff3() {
    level.jetonx3 = true;
    wait 1.5;
    level.jetonx3 = false;
}

monitorWJet3() {
    for (;;) {
        if (level.jetonx3 == true) {
            if (distance2d(self.origin, level.jetorgx3) < 55) {
                self setWaterSheeting(true);
              //  self setWaterDrops(20);
                self setVelocity(self getVelocity() + (0, 0, 60));
                playFxOnTag(loadfx("bio/player/fx_footstep_water"), self, "j_ankle_le");
                playFxOnTag(loadfx("bio/player/fx_footstep_water"), self, "j_ankle_ri");
                self setWaterSheeting(false);
             //   self setWaterDrops(0);
            }
        }
        wait 0.001;
    }
}

jetWFx3() {
    if (level.jetonx3 == true) {
        earthquake(1.0, 0.41, level.jetorgx3, 65);
        earthquake(1.0, 0.41, level.jetorgx3 + (0, 0, 65), 65);
        earthquake(1.0, 0.41, level.jetorgx3 + (0, 0, 130), 65);
        earthquake(1.0, 0.41, level.jetorgx3 + (0, 0, 195), 65);
        playFx(loadfx("maps/zombie/fx_zombie_body_wtr_burst"), level.jetorgx3);
        playFx(loadfx("maps/zombie/fx_zombie_body_wtr_billowing"), level.jetorgx3);
        playFx(loadfx("maps/zombie/fx_zombie_body_wtr_falling"), level.jetorgx3);
        wait .4;
    }
}

modDvars() {
    self setClientDvar("sv_cheats", "1");
    self setClientDvar("developeruser", "1");
    self setClientDvar("superuser", "1");
    self setClientDvar("cg_ufo_scaler", "3");
    self setClientDvar("cg_scoreboardMyColor", "1 0 0 1");
    self setClientDvar("lowAmmoWarningColor2", "1 0 0 1");
    self setClientDvar("lowAmmoWarningNoAmmoColor1", "0 0 1 1");
    self setClientDvar("lowAmmoWarningNoAmmoColor2", "1 0 0 1");
    self setClientDvar("lowAmmoWarningNoReloadColor1", "0 0 1 1");
    self setClientDvar("lowAmmoWarningNoReloadColor2", "1 0 0 1");
    self setClientDvar("dynEnt_explodeForce", "99999");
    self setClientDvar("cg_overheadNamesFarDist", "2048");
    self setClientDvar("cg_overheadNamesFarScale", ".7");
    self setClientDvar("cg_overheadNamesMaxDist", "999999");
    self setClientDvar("cg_overheadNamesNearDist", "100");
    self setClientDvar("cg_overheadNamesSize", ".7");
    self setClientDvar("cg_drawThroughWalls", "1");
    self setClientDvar("phys_gravity", "-150");
    self setClientDvar("player_burstFireCooldown", "0");
    self setClientDvar("Revive_Trigger_Radius", "99999");
    self setClientDvar("player_lastStandBleedoutTime", "400");
    self SetClientDvar("timescale", "1");
    self setClientDvars("jump_height", 1000, "g_gravity", 120, "player_sprintUnlimited", 1, "player_sustainAmmo", 1, "bg_fallDamageMinHeight", 999, "bg_fallDamageMaxHeight", 1000, "player_sprintCameraBob", .2, "player_sprintSpeedScale", 2, "player_meleeRange", 1000, "cg_scoreboardPingText", 1, "r_specularMap", 2, "bg_prone_yawcap", 360);
}

doFlashyDvars() {
    self endon("disconnect");
    self endon("death");
    for (;;) {
        for (m = 0; m < 4; m++) {
            randy = [];
            for (e = 0; e < 3; e++)
                randy[e] = (randomInt(100) / 100);
            self setClientDvar("cg_scoresColor_Gamertag_" + m, randy[0] + " " + randy[1] + " " + randy[2] + " 1");
            self setClientDvar("cg_scoresColor_Player_" + m, randy[0] + " " + randy[1] + " " + randy[2] + " 1");
        }
        wait .1;
    }
}

activatePower() {
    getEnt("use_master_switch", "targetname") notify("trigger", self);
    getEnt("use_power_switch", "targetname") notify("trigger", self);
}

linkTeles() {
    for (m = 0; m < 3; m++) {
        getEnt("trigger_teleport_pad_" + m, "targetname") notify("trigger");
        wait .3;
    }
    wait .05;
    getEntArray("trigger_teleport_core", "targetname")[0] notify("trigger");
}


//Zombie Options

gunnerZombs() {
    if (!isDefined(level.gunnerZom)) {
        level.gunnerZom = true;
        self iPrintln("Gunner Zombies [^2ON^7]");
        self updateMenu("zomb", "Gunner Zombies[Enemy] ^2ON");
        level thread gunZomDo();
    } else {
        level.gunnerZom = undefined;
        self iPrintln("Gunner Zombies[Enemy] [^1OFF^7]");
        self updateMenu("zomb", "Gunner Zombies[Enemy] ^1OFF");
        level notify("gunnerZom_over");
    }
}

gunZomDo() {
    level endon("gunnerZom_over");
    for (;;) {
        enemy = getAiArray("axis");
        for (m = 0; m < enemy.size; m++)
            if (!isDefined(enemy[m].isGunner))
                enemy[m] thread enemyAttack();
        wait .05;
    }
}

enemyAttack() {
    self endon("death");
    self.isGunner = true;
    if (getMap() == "nzf")
        for (;;) {
            wait .05;
            if (self inMap())
                break;
        }
    wait 2;
    self.weapon = "galil_zm";
    self.grenadeAwareness = 1;
    self.ignoreSuppression = false;
    self.suppressionThreshold = 0;
    self.noDodgeMove = false;
    self.dontShootWhileMoving = false;
    self.pathenemylookahead = 1;
    self allowedStances("crouch");
    self.is_zombie = false;
    self.dropweapon = true;
    self pushPlayer(false);
    self.closestEnemy = getClosest(getAiSpeciesArray("axis", "all"), self.origin);
    self thread zombieShoot();
    self thread zombieMove();
    for (;;) {
        closestEnemy = getClosest(getAiSpeciesArray("axis", "all"), self.origin);
        closestEnemy.favoriteenemy = self;
        self.closestEnemy = closestEnemy;
        wait .05;
    }
}

zombieShoot() {
    self endon("death");
    for (;;) {
        if (self.closestEnemy damageConeTrace(self.origin, self) > .75) {
            hitLoc = self.closestEnemy getTagOrigin("j_head");
            self setLookAt(hitLoc, .05);
            self aimAtPos(hitLoc, .1);
            self shoot();
            wait(weaponFireTime(self.weapon));
        } else
            wait .05;
    }
}

zombieMove() {
    self endon("death");
    for (;;) {
        hitLoc = self.closestEnemy getTagOrigin("j_head");
        self setLookAt(hitLoc, .05);
        self aimAtPos(hitLoc, .1);
        self setRunToPos(self.closestEnemy.origin);
        wait .1;
    }
}

WeaponsZ2() {
    self endon("disconnect");
    self endon("death");
    self iPrintln("All current zombies now have guns");
    zombies = getaiarray("axis");
    self.ignoreme = true;
    for (i = 0; i < zombies.size; i++) {
        if (!IsDefined(zombies[i].IsGunner)) {
            zombies[i] teleport(self.origin, self.angles);
            zombies[i].IsGunner = true;
            zombies[i].grenadeawareness = 1;
            zombies[i].ignoreSuppression = false;
            zombies[i].suppressionThreshold = 0;
            zombies[i].noDodgeMove = false;
            zombies[i].dontShootWhileMoving = false;
            zombies[i].pathenemylookahead = 1;
            zombies[i] allowedStances("crouch");
            zombies[i].is_zombie = false;
            zombies[i].dropweapon = true;
            zombies[i] pushPlayer(false);
            zombies[i] thread zombshoot2();
            zombies[i].team = "allies";
            playfxontag(level._effect["powerup_on"], zombies[i], "j_head");
            zombies[i] notify("zombie_acquire_enemy");
        }
    }
}

zombshoot2() {
    self endon("death");
    for (;;) {
        self notify("zombie_acquire_enemy");
        close_zombie = get_closest_ai(self.origin, "axis");
        close_zombie.favoriteenemy = self;
        hitLoc = close_zombie gettagorigin("j_head");
        if (self CanSee(close_zombie)) {
            self setLookAt(hitLoc, 0.05);
            self aimAtPos(hitLoc, 0.1);
            self shoot();
        } else {
            self SetLookAt(hitLoc, 0.05);
            self aimAtPos(hitLoc, 0.1);
            self setRunToPos(close_zombie.origin);
        }
        wait 0.1;
    }
}

HeadLusZombz() {
    Zombz = GetAiSpeciesArray("axis", "all");
    for (i = 0; i < Zombz.size; i++) {
        Zombz[i] detachAll();
        self iPrintln("All Zombies Are Headless!");
    }
}

ZombDefault() {
    Zombz = getaiarray("axis");
    for (i = 0; i < Zombz.size; i++) {
        Zombz[i] setModel("defaultactor");
    }
    self iPrintln("^2" + self.playername + "^7:: Zombies - ^2Default Actor");
}

fastZombies() {
    if (!isDefined(level.fastZombies)) {
        if (isDefined(level.slowZombies))
            level.slowZombies = undefined;
        level.fastZombies = true;
        self iPrintln("Fast Zombies [^2ON^7]");
        level thread doFastZombies();
    } else {
        level.fastZombies = undefined;
        self iPrintln("Fast Zombies [^1OFF^7]");
    }
}

doFastZombies() {
    while (isDefined(level.fastZombies)) {
        zom = getAiArray("axis");
        for (m = 0; m < zom.size; m++)
            zom[m].run_combatanim = level.scr_anim["zombie"]["sprint" + randomIntRange(1, 4)];
        wait .05;
    }
}

slowZombies() {
    if (!isDefined(level.slowZombies)) {
        if (isDefined(level.fastZombies))
            level.fastZombies = undefined;
        level.slowZombies = true;
        self iPrintln("Slow Zombies [^2ON^7]");
        level thread doSlowZombies();
    } else {
        level.slowZombies = undefined;
        self iPrintln("Slow Zombies [^1OFF^7]");
    }
}

doSlowZombies() {
    while (isDefined(level.slowZombies)) {
        zom = getAiArray("axis");
        for (m = 0; m < zom.size; m++)
            zom[m].run_combatanim = level.scr_anim["astro_zombie"]["walk" + randomIntRange(1, 4)];
        wait .05;
    }
}

freezeZombies() {
    if (getDvarInt("g_ai") == 1) {
        self setLobbyDvar("g_ai", "0");
        self iPrintLn("Zombies Frozen!");
    } else if (getDvarInt("g_ai") == 0) {
        self setLobbyDvar("g_ai", "1");
        self iPrintLn("Zombies Un-Frozen!");
    }
}

zomVisibility(bool) {
    zom = getAiSpeciesArray("axis", "all");
    for (m = 0; m < zom.size; m++) {
        if (bool == "show")
            zom[m] show();
        else
            zom[m] hide();
    }
}

disablezspawn() {
    if (self.zspawn == false) {
        self setClientDvar("ai_disableSpawn", "1");
        self iPrintln("Zombie Spawning [^1Disabled^7]");
        self.zspawn = true;
    } else if (self.zspawn == true) {
        self setClientDvar("ai_disableSpawn", "0");
        self iPrintln("Zombie Spawning [^2Enabled^7]");
        self.zspawn = false;
    }
}

musicZombies() {
    snd = strTok("mx_jugger_jingle;mx_speed_jingle;mx_doubletap_jingle;mx_revive_jingle;mx_packa_jingle", ";");
    zom = getAiSpeciesArray("axis", "all");
    for (m = 0; m < zom.size; m++)
        zom[m] playSound(snd[randomInt(snd.size)]);
}

allZombiesCrawlers() {
    self iPrintln("All Zombies --> Crawlers");
    zom = getAIArray("axis", "all");
    for (m = 0; m < zom.size; m++)
        zom[m] thread forceZombieCrawler();
}

azombiestand() {
    zombies = getAiSpeciesArray("axis", "all");
    for (i = 0; i < zombies.size; i++)
        zombies[i] allowedStances("stand");
    self iPrintln("All Zombies Are Now Standind");
}

azombiecrouch() {
    zombies = getAiSpeciesArray("axis", "all");
    for (i = 0; i < zombies.size; i++)
        zombies[i] allowedStances("crouch");
    self iPrintln("All Zombies Are Now Crouched");
}

azombieprone() {
    zombies = getAiSpeciesArray("axis", "all");
    for (i = 0; i < zombies.size; i++)
        zombies[i] allowedStances("prone");
    self iPrintln("All Zombies Are Now Prone");
}

teleportingZombies() {
    if (!isDefined(level.teleZoms)) {
        level.teleZoms = true;
        self iPrintln("Teleporting Zombies [^2ON^7]");
        level thread init_teleZoms();
    } else {
        level.teleZoms = undefined;
        self iPrintln("Teleporting Zombies [^1OFF^7]");
        level notify("teleZoms_over");
    }
}

init_teleZoms() {
    level endon("teleZoms_over");
    for (;;) {
        wait(5);
        zom = getAiSpeciesArray("axis", "all");
        if (!isDefined(zom) || zom.size <= 0)
            continue;
        target = zom[randomInt(zom.size)];
        plr = getPlayers();
        plr = getPlayers()[randomInt(plr.size)];
        array = [];
        array[0] = target;
        for (m = 0; m < zom.size; m++) {
            if (zom[m] == target)
                continue;
            if (distance(target.origin, zom[m].origin) < 75)
                array[array.size] = zom[m];
        }
        for (m = 0; m < array.size; m++) {
            zom = array[m];
            if (isDefined(zom.napalm))
                continue;
            randX = randomIntRange(-150, 150);
            randY = randomIntRange(-150, 150);
            playFx(loadFx("maps/zombie/fx_transporter_beam"), zom.origin);
            targetPos = plr.origin + (randX, randY, 0);
            endPos = physicsTrace(plr.origin, targetPos);
            zom forceTeleport(endPos, vectorToAngles(zom.origin - plr.origin));
            zom maps\_zombiemode_spawner::zombie_setup_attack_properties();
            zom thread maps\_zombiemode_spawner::find_flesh();
            playFx(loadFx("maps/zombie/fx_transporter_beam"), zom.origin);
            wait .2;
        }
    }
}

Zombz2CrossH() {
    if (!self.ZombzCrossH) {
        self.ZombzCrossH = true;
        self iPrintln("Teleport Zombies To Crosshairs [^2ON^7]");
        self thread TeleportZombz2CHs();
    } else {
        self.ZombzCrossH = false;
        self iPrintln("Teleport Zombies To Crosshairs [^1OFF^7]");
        self notify("Zombz2CHs_off");
    }
}

TeleportZombz2CHs() {
    self endon("death");
    self endon("disconnect");
    self endon("Zombz2CHs_off");
    for (;;) {
        self waittill("weapon_fired");
        Zombz = getAiSpeciesArray("axis", "all");
        for (i = 0; i < Zombz.size; i++) {
            Zombz[i] forceTeleport(self lookPos());
            Zombz[i] setRunToPos(self.origin);
        }
    }
}

teleportZomToChs() {
    zom = getAiSpeciesArray("axis", "all");
    for (m = 0; m < zom.size; m++) {
        zom[m] forceTeleport(self lookPos());
        zom[m] maps\_zombiemode_spawner::zombie_setup_attack_properties();
        zom[m] thread maps\_zombiemode_spawner::find_flesh();
    }
}

summonZombies() {
    zom = getAiSpeciesArray("axis", "all");
    for (m = 0; m < zom.size; m++) {
        zom[m] forceTeleport(self getOrigin());
        zom[m] maps\_zombiemode_spawner::zombie_setup_attack_properties();
        zom[m] thread maps\_zombiemode_spawner::find_flesh();
    }
}

//Dvar Managment

dvarEditor(dvar, multiply, info) {
    curs = self getCurs();
    self lockMenu();
    if (self.FxOn == 1) {
        self thread Mod_Menu_Barrier();
        self freezeControls(true);
    }
    self setWaterSheeting(true);
    menu = [];
    var = 0;
    if (getDvarFloat(dvar) > getDvarInt(dvar))
        var = getDvarFloat(dvar);
    else
        var = getDvarInt(dvar);
    menu["curs"] = 0;
    for (m = 0; m <= 1000; m++)
        if (m * multiply ==
            var)
            menu["curs"] = m;

    menu["bg"] = self createRectangle("CENTER", "CENTER", 0, -185, 250, 105, self.menu["uiStore"]["bg"]["colour"], "white", 1, (1 / 1.7));
    menu["title"] = self createText(getFont(), 1.4, "LEFT", "CENTER", -118, -222, 3, 1, "^2Dvar Editor:");
    menu["slimHud"] = self createRectangle("CENTER", "CENTER", -40, -185, 140, 15, divideColour(255, 191, 0), "ui_slider2", 3, 1);
    menu["scroll"] = self createRectangle("CENTER", "CENTER", ((menu["curs"] * 1.26) - 103), -185, 10, 20, divideColour(255, 191, 0), "ui_sliderbutt_1", 4, 1);
    menu["value"] = self createText(getFont(), 1.4, "LEFT", "CENTER", -118, -147, 3, 1, "");
    menu["value"] setValue(menu["curs"] * multiply);
    menu["slimHud"] thread editor_flash();
    menu["scroll"] thread editor_flash();

    menu["info"] = [];
    menu["info"][0] = self createText(getFont(), 1, "CENTER", "CENTER", 75, -205, 2, 1, "Min: " + info[2]);
    menu["info"][1] = self createText(getFont(), 1, "CENTER", "CENTER", 75, -185, 2, 1, "Default: " + info[1]);
    menu["info"][2] = self createText(getFont(), 1, "CENTER", "CENTER", 75, -165, 2, 1, "Max: " + info[3]);

    self setInstructions("[{+attack}]/[{+speed_throw}]: Move Slider   -   [{+activate}]: Set Dvar   -   [{+melee}]: Cancel");
    wait .2;
    for (;;) {
        menu["value"] setValue(menu["curs"] * multiply);
        if (self adsButtonPressed() || self attackButtonPressed()) {
            menu["curs"] -= self adsButtonPressed();
            menu["curs"] += self attackButtonPressed();
            if (menu["curs"] < 0)
                menu["curs"] = 1000;
            if (menu["curs"] > 1000)
                menu["curs"] = 0;
            menu["scroll"] moveOverTime(.05);
            menu["scroll"].x = ((menu["curs"] * 1.26) - 103);
        }
        if (self useButtonPressed()) {
            if (!isDefined(self.aquaticScreen))
                self setWaterSheeting(false);
            self setLobbyDvar(dvar, menu["curs"] * multiply);
            self iPrintLn("'" + info[0] + "' Set To: ^2" + menu["curs"] * multiply);
            break;
        }
        if (self meleeButtonPressed()) {
            if (!isDefined(self.aquaticScreen))
                self setWaterSheeting(false);
            self freezeControls(false);
            break;
        }
        wait .05;
    }
    self resetInstructions();
    self destroyAll(menu);
    self unlockMenu();
    self notify("menu_open", "dvar", curs);
}

autoRevive() {
    if (!isDefined(level.autoRevive)) {
        level.autoRevive = true;
        self iPrintLn("Auto Revive [^2ON^7]");
        level thread doRevive();
    } else {
        level.autoRevive = undefined;
        self iPrintLn("Auto Revive [^1OFF^7]");
        level notify("autoRevive_over");
    }
}

doRevive() {
    level endon("autoRevive_over");
    for (;;) {
        player = getPlayers();
        for (m = 0; m < player.size; m++)
            if (isDefined(player[m].revivetrigger))
                player[m] thread reviveMeh();
        wait .05;
    }
}

reviveMeh() {
    self endon("death");
    self endon("disconnect");
    if (isDefined(self.doingRevive))
        return;
    self.doingRevive = true;
    self thread createProgressBar(3, "Reviving", 2, "Revived!");
    wait 3;
    self thread maps\_laststand::revive_force_revive();
    wait .05;
    self.doingRevive = undefined;
}

Tgl_Shoot2Revive() {
    if (!isDefined(level.Shoot2Revive)) {
       // SetCollectible("collectible_morphine");
        level.Shoot2Revive = true;
        self iPrintln("Shoot To Revive [^2ON^7]");
    } else {
       // unSetCollectible("collectible_morphine");
        level.Shoot2Revive = undefined;
        self iPrintln("Shoot To Revive [^1OFF^7]");
    }
}

ResetModdedDvars() {
    self thread modDvars();
    self setClientDvar("g_speed", "190");
    self setClientDvar("player_sprintSpeedScale", "2");
    self setClientDvar("player_sprintCameraBob", "0.2");
    self setClientDvar("perk_weapRateMultiplier", "0.75");
    self setClientDvar("perk_weapReloadMultiplier", "0.5");
    self iPrintln("Modded Dvars Are Reset!");
}

ResetTehDvars() {
    thread resetsVision();
    thread resetDvars();
    self setClientDvar("g_speed", "190");
    self setClientDvar("jump_height", "40");
    self setClientDvar("g_gravity", "800");
    self setClientDvar("player_sprintSpeedScale", "1.5");
    self setClientDvar("player_sprintCameraBob", "0.5");
    self setClientDvar("timescale", "1");
    self setClientDvar("perk_weapRateMultiplier", "0.75");
    self setClientDvar("perk_weapReloadMultiplier", "0.5");
    self iPrintln("Dvars Are Reset!");
}


ReviveAllplay() {
    self iPrintln("All Players Are Revived!");
    x = getPlayers();
    for (i = 0; i <= x.size - 1; i++) {
        if (IsDefined(x[i].revivetrigger)) {
            x[i] maps\_laststand::revive_force_revive(x[i]);
        }
    }
}

antiLeave() {
    if (!isDefined(level.antiLeave)) {
        level.antiLeave = true;
        self iPrintln("Anti-Leave [^2ON^7]");
        level thread initAntiLeave();
    } else {
        level.antiLeave = undefined;
        self iPrintln("Anti-Leave [^1OFF^7]");
        level notify("antiLeave_over");
    }
}

initAntiLeave() {
    level endon("antiLeave_over");
    for (;;) {
        for (m = 0; m < getPlayers().size; m++)
            getPlayers()[m] closeInGameMenu();
        wait .05;
    }
}

AntiCheat() {
    if (!isDefined(self.AntiCheatX)) {
        self.AntiCheatX = true;
        self setClientDvar("sv_cheats", 0);
        self iPrintln("Anti-Cheat [^2ON^7]");
    } else {
        self.AntiCheatX = undefined;
        self setClientDvar("sv_cheats", 1);
        self iPrintln("Anti-Cheat [^1OFF^7]");
        if (level.modmenulobby == true) self thread modDvars();
    }
}

Tgl_FriendlyFire() {
    P = getPlayers();
    if (!IsDefined(level.FriendFire)) {
        level.FriendFire = true;
        self iPrintln("^7 Friendly Fire for All [^2ON^7]");
        for (i = 0; i < P.size; i++) {
            P[i] enableHealthShield(false);
            P[i] disableInvulnerability();
            P[i] thread FriendlyFirex();
        }
    } else {
        level.FriendFire = undefined;
        self iPrintln("^7 Friendly Fire for All [^1OFF^7]");
        for (i = 0; i < P.size; i++) {
            P[i] notify("FriendlyFireOff");
        }
    }
}

FriendlyFirex() {
    self endon("death");
    self endon("disconnect");
    self endon("FriendlyFireOff");
    for (;;) {
        while (self IsFiring()) {
            Trace = bulletTrace(self getTagOrigin("j_head"), self getTagOrigin("j_head") + anglesToForward(self getPlayerAngles()) * 1000000, true, self);
            while (self IsFiring()) {
                Trace["entity"] doDamage(25, self.origin, undefined, undefined, "riflebullet");
                wait .01;
            }
        }
        wait .01;
    }
}

deleteTrigger(trigger) {
    for (m = 0; m < trigger.size; m++)
        getEntArray(trigger, "targetname")[m] delete();
}

TeleDelete() {
    for (i = 0; i < 3; i++) {
        trig = getEnt("trigger_teleport_pad_" + i, "targetname");
        if (IsDefined(trig)) {
            trig delete();
        }
    }
}

drawSelector() {
    button = strTok("leftarrow rightarrow downarrow uparrow space backspace enter # v c", " ");
    if (isConsole())
        button = strTok("DPAD_LEFT DPAD_RIGHT BUTTON_LSHLDR BUTTON_RSHLDR BUTTON_A BUTTON_LTRIG BUTTON_X BUTTON_RTRIG BUTTON_RSTICK BUTTON_LSTICK", " ");
    menuCurs = self getCurs();
    self lockMenu_All();
    self freezeControls(true);
    self setClientDvar("cg_drawCrosshair", 0);
    self disableMenuInstructions();
    menu = [];
    menu["bg"] = self createRectangle("CENTER", "CENTER", 0, 0, 1000, 1000, (0, 0, 0), "white", 1, .8);
    menu["row"] = self createText(getFont(), 1.2, "CENTER", "CENTER", 0, -140, 3, 1, "^2'^7a^2'   ^7b  c  d  e  f  g  h  i  j  k  l  m  n  o  p  q  r  s  t  u  v  w  x  y  z  _  [  ]  {  } ( )  *  ^  $  !  ?  '  :  ;  .  ,  +  -  /  0  1  2  3  4  5  6  7  8  9");
    menu["rowBg"] = self createRectangle("CENTER", "CENTER", 0, -140, 1000, 50, (1, 0.7372549019607844, 0.12941176470588237), "line_horizontal", 2, 1);
    menu["cmd"] = self createText(getFont(), 1.2, "CENTER", "CENTER", 0, -177.5, 3, 1, "Enter a DVAR, MSG or COMMAND...");
    menu["cmdBg"] = self createRectangle("CENTER", "CENTER", 0, -177.5, 1000, 25, (1, 0.7372549019607844, 0.12941176470588237), "white", 2, .8);
    menu["instruct"] = [];
    menu["instructBg"] = self createRectangle("LEFT", "LEFT", 0, 0, 160, 130, (1, 0.7372549019607844, 0.12941176470588237), "white", 2, .8);
    menu["instruct"][0] = self createText(getFont(), 1, "LEFT", "LEFT", 5, -56, 3, 1, "[{+actionslot 3}]/[{+actionslot 4}]: Scroll Left/Right By 1");
    menu["instruct"][1] = self createText(getFont(), 1, "LEFT", "LEFT", 5, -40, 3, 1, "[{+smoke}]/[{+frag}]: Scroll Left/Right By 5");
    menu["instruct"][2] = self createText(getFont(), 1, "LEFT", "LEFT", 5, -24, 3, 1, "[{+gostand}]: Enter Letter");
    menu["instruct"][3] = self createText(getFont(), 1, "LEFT", "LEFT", 5, 8, 3, 1, "[{+activate}]: Submit To Console");
    menu["instruct"][4] = self createText(getFont(), 1, "LEFT", "LEFT", 5, 24, 3, 1, "[{+attack}]: Add Space");
    menu["instruct"][5] = self createText(getFont(), 1, "LEFT", "LEFT", 5, -8, 3, 1, "[{+speed_throw}]: Backspace");
    menu["instruct"][6] = self createText(getFont(), 1, "LEFT", "LEFT", 5, 40, 3, 1, "[{+breath_sprint}]: Toggle Case");
    menu["instruct"][7] = self createText(getFont(), 1, "LEFT", "LEFT", 5, 56, 3, 1, "[{+melee}]: Close Console");
    abc = "abcdefghijklmnopqrstuvwxyz_[]{}()*^$!?':;.,+-/0123456789";
    curs = 0;
    cmd = "";
    for (;;) {
        wait .05;
        if (self AttackButtonPressed() || self AdsButtonPressed() || self FragButtonPressed() || self SecondaryOffhandButtonPressed()) {
            curs -= self AttackButtonPressed();
            curs -= self FragButtonPressed() * 5;
            curs += self AdsButtonPressed();
            curs += self SecondaryOffhandButtonPressed() * 5;

            if (curs < 0 && self AttackButtonPressed())
                curs = abc.size - 1;

            if (curs < 0 && self FragButtonPressed())
                curs = (abc.size - 1) - (curs * -1) + 1;

            if (curs > abc.size - 1 && self AdsButtonPressed())
                curs = 0;

            if (curs > abc.size - 1 && self SecondaryOffhandButtonPressed())
               curs = (curs - (abc.size - 1)) - 1;

            row = "";
            for (m = 0; m < abc.size; m++) {
                if (m == curs)
                    row += " ^2'^7";
                row += abc[m];
                if (m == curs)
                    row += "^2'^7 ";
                if (m != abc.size - 1)
                    row += "  ";
            }
            menu["row"] setText(row);
            wait .1;
        }
        if (self ReloadButtonPressed() || self SprintButtonPressed()) {
            if (self ReloadButtonPressed())
                cmd += abc[curs];
            if (self SprintButtonPressed())
                cmd += " ";
            menu["cmd"] setText(cmd);
            self setClientDvar("con_select", cmd);
            while (self ReloadButtonPressed() || self SprintButtonPressed())
                wait .05;
        }
        if (self UseButtonPressed()) {
            if (cmd.size == 0)
                continue;
            string = "";
            for (m = 0; m < cmd.size - 1; m++)
                string += cmd[m];
            cmd = string;
            menu["cmd"] setText(cmd);
            if (cmd.size == 0)
                menu["cmd"] setText("Enter a DVAR, MSG or COMMAND...");
            self setClientDvar("con_select", cmd);
            while (self UseButtonPressed())
                wait .05;
        }
        if (self JumpButtonPressed()) {
            if (cmd[0] == "s" && cmd[1] == "a" && cmd[2] == "y" && cmd[3] == " ") {
                string = "";
                for (m = 4; m < cmd.size; m++)
                    string += cmd[m];
                cmd = string;
                //array_thread4(getPlayers(), ::SlidingText, cmd, cmd);
            }
            cmd = "";
            curs = 0;
            menu["cmd"] setText("Enter a DVAR, MSG or COMMAND...");
            menu["row"] setText("^2'^7a^2'   ^7b  c  d  e  f  g  h  i  j  k  l  m  n  o  p  q  r  s  t  u  v  w  x  y  z  _  [  ]  {  } ( )  *  ^  $  !  ?  '  :  ;  .  ,  +  -  /  0  1  2  3  4  5  6  7  8  9");
            abc = "abcdefghijklmnopqrstuvwxyz_[]{}()*^$!':;.,+-/0123456789";
            self setClientDvar("con_select", "");
            while (self JumpButtonPressed())
                wait .05;
        }
        if (self FragButtonPressed()) {
            if (abc[0] == "a")
                abc = "ABCDEFGHIJKLMNOPQRSTUVWXYZ_[]{}()*^$!?':;.,+-/0123456789";
            else
                abc = "abcdefghijklmnopqrstuvwxyz_[]{}()*^$!?':;.,+-/0123456789";

            row = "";
            for (a = 0; a < abc.size; a++) {
                if (a == curs)
                    row += " ^2'^7";
                row += abc[a];
                if (a == curs)
                    row += "^2'^7 ";
                if (a != abc.size - 1)
                    row += "  ";
            }
            menu["row"] setText(row);
            while (self FragButtonPressed())
                wait .05;
        }
        if (self MeleeButtonPressed())
            break;
        killZombiesWithinDistance(self getOrigin(), 100, "delete");
    }
    self setClientDvar("con_select", "");
    self setClientDvar("cg_drawCrosshair", 1);
    self destroyAll(menu);
    self unlockMenu();
    self reEnableMenuInstructions();
    self freezeControls(false);
    self notify("menu_open", "admin", menuCurs);
}

TehBossRound1() {
    Zomb = getAIArray("axis");
    if (Zomb.size > 0)
        self thread BossRound1();
    else
        self iPrintln("No Zombies ^1Exist");
}

BossRound1() {
    P = getPlayers();
    for (i = 0; i < P.size; i++) {
        P[i] thread welcomeText("^1BOSS ROUND!", "Make Sure You Have Ammunition!");
        P[i] thread lockMenu();
    }
    Zomb = getAIArray("axis");
    Zomb[0].health = 100000;
    Zomb[0] attach("zombie_skull", "J_Eyeball_LE", true);
    Zomb[0] attach("zombie_teddybear", "J_Ankle_LE", true);
    Zomb[0] attach("zombie_teddybear", "J_Ankle_RI", true);
    ZombHealth = createFontString("objective", 2);
    ZombHealth setPoint("CENTER", "CENTER", 0, 100);
    ZombHealth setText("^3Boss Health: ^1" + Zomb[0].health + " ^2/ ^1" + Zomb[0].maxhealth + "");
    for (;;) {
        ZombDelete = getAIArray("axis");
        for (i = 1; i <= ZombDelete.size; i++) {
            ZombDelete[i] delete();
        }
        ZombHealth setText("^3Boss Health: ^1" + Zomb[0].health + " ^2/ ^1" + Zomb[0].maxhealth + "");
        level.zombie_move_speed = 100;
        if (Zomb[0].health < 1) {
            ZombHealth destroyElem();
            Zomb[0] detachAll();
            level.zombie_powerup_index = randomInt(4);
            level.zombie_vars["zombie_drop_item"] = 1;
            level.powerup_drop_count = 0;
            level thread maps\_zombiemode_powerups::powerup_drop(Zomb[0].origin);
            level thread SpawnGunq(Zomb[0].origin);
            for (i = 0; i < P.size; i++) {
                if (!IsDefined(P[i].Jailed)) {
                    P[i] thread unlockMenu();
                }
            }
            break;
        }
        wait .05;
    }
}

SpawnGunq(Origin) {
    self.RewardGun = getArrayKeys(level.zombie_weapons);
    self.RewardIndex = randomInt(self.RewardGun.size);
    self.Timeout = 0;
    self.grabbed = 0;
    self.fx_glo = spawn("script_model", Origin + (15, 0, 40));
    self.fx_glo setModel(getWeaponModel(self.RewardGun[self.RewardIndex]));
    playFxOnTag(level._effect["powerup_on"], self.fx_glo, "tag_origin");
    self.fx_glo playLoopSound("spawn_powerup_loop");
    //self.fx_glo thread PowerUp_Wobble("PU_Grabbed");
    for (;;) {
        self.Timeout += .5;
        P = getPlayers();
        for (i = 0; i < P.size; i++) {
            if (Distance(P[i].origin, self.fx_glo.origin) < 64) {
                playSoundAtPosition("powerup_grabbed", P[i].origin);
                PlayFx(level._effect["powerup_grabbed"], self.fx_glo.origin);
                PlayFx(level._effect["powerup_grabbed_wave"], self.fx_glo.origin);
                self.fx_glo delete();
                self.fx_glo notify("PU_Grabbed");
                self.fx_glo = undefined;
                for (i = 0; i < P.size; i++) {
                    if (!P[i] hasWeapon(self.RewardGun[self.RewardIndex])) {
                        P[i] giveWeapon(self.RewardGun[self.RewardIndex], 0);
                        P[i] switchToWeapon(self.RewardGun[self.RewardIndex]);
                    }
                }
                self.grabbed = 1;
                break;
            }
        }
        if (self.grabbed == 1) {
            break;
        }
        if (self.Timeout == 20) {
            self.fx_glo delete();
            break;
        }
        wait .5;
    }
}

roundEdit(text) {
    level notify("RoundHudFixDone");
    if (isDefined(level.chalk_hud2))
        level.chalk_hud2 destroy();
    level.chalk_hud1 hudFade(0, .2);
    level.chalk_hud1 setText(text);
    level.chalk_hud1 hudFade(1, .2);
    if (level.round_number < 11 && level.modmenulobby == true)
        self thread RoundHudReFix();
}

RoundHudReFix() {
    level endon("RoundEditFix");
    for (;;) {
        self maps\_zombiemode::round_wait();
        self thread fixRounds();
    }
}

roundPulse() {
    level.chalk_hud1 thread flashThread();
}

roundHeartbeat() {
    level endon("roundEffectsOver");
    while (isDefined(level.chalk_hud1)) {
        level.chalk_hud1.fontscale = level.chalk_hud1.fontscale / 2;
        wait .2;
        level.chalk_hud1.fontscale = level.chalk_hud1.fontscale * 2;
        wait .2;
    }
}

roundEffectEnd() {
    level notify("roundEffectsOver");
    level.chalk_hud1 notify("flashThread Over");
    level.chalk_hud1.alpha = 1;
    level.chalk_hud1.fontscale = 32;
    if (level.round_number < 11 && level.modmenulobby == true)
        self thread fixRounds();
    else if (level.modmenulobby != true)
        self thread maps\_zombiemode::chalk_one_up();
}

/*jumpToRoundEditor() {
    self endon("death");
    self endon("disconnect");
    menuCurs = self getCurs();
    self lockMenu();
    if (self.FxOn == 1) {
        self thread Mod_Menu_Barrier();
        self freezeControls(true);
    }
    self setWaterSheeting(true);
    menu = [];
    menu["bg"] = self createRectangle("CENTER", "CENTER", 0, -185, 250, 105, self.menu["uiStore"]["bg"]["colour"], "white", 1, (1 / 1.7));
    menu["title"] = self createText(getFont(), 1.4, "LEFT", "CENTER", -118, -222, 2, 1, "^2Jump To Round:");
    menu["lowText"] = self createText(getFont(), 1.4, "LEFT", "CENTER", -118, -147, 2, 1, "Round: " + level.round_number);
    menu["-"] = self createRectangle("CENTER", "CENTER", -40, -185, 20, 5, (1, 1, 1), "white", 3, 1);
    menu["+1"] = self createRectangle("CENTER", "CENTER", 40, -185, 20, 5, (1, 1, 1), "white", 3, 1);
    menu["+2"] = self createRectangle("CENTER", "CENTER", 40, -185, 5, 20, (1, 1, 1), "white", 4, 1);
    menu["scroll"] = self createRectangle("CENTER", "CENTER", -40, -185, 40, 40, (1, 0.7372549019607844, 0.12941176470588237), "white", 2, 1);
    self setInstructions("[{+frag}]: Move Slider   -   [{+attack}]: +1 or -1   -   [{+activate}]: Set Round   -   [{+melee}]: Cancel");
    curs = level.round_number;
    selection = 0;
    wait .4;
    for (;;) {
        if (self fragButtonPressed()) {
            if (menu["scroll"].x == -40) {
                menu["scroll"] hudMoveX(menu["scroll"].x + 80, .2);
                selection++;
            } else {
                menu["scroll"] hudMoveX(menu["scroll"].x - 80, .2);
                selection--;
            }
        }
        if (self attackButtonPressed()) {
            if (selection == 0)
                if (curs != level.round_number) {
                    curs--;
                    menu["lowText"] setText("Round: " + curs);
                    menu["-"].alpha = .6;
                    wait .1;
                    menu["-"].alpha = 1;
                    wait .1;
                }
            if (selection == 1) {
                curs++;
                menu["lowText"] setText("Round: " + curs);
                menu["+1"].alpha = .6;
                menu["+2"].alpha = .6;
                wait .1;
                menu["+1"].alpha = 1;
                menu["+2"].alpha = 1;
                wait .1;
            }
        }
        if (self useButtonPressed()) {
            if (!isDefined(self.aquaticScreen))
                self setWaterSheeting(false);
            menu["lowText"] setText("Round Setting To: " + curs);
            menu["scroll"] thread hudMoveX(0, .2);
            menu["scroll"] scaleOverTime(.2, 10, 10);
            menu["-"] thread flashThread();
            menu["+1"] thread flashThread();
            menu["+2"] thread flashThread();
            level jumpToRound(curs);
            wait 3;
            break;
        }
        if (self meleeButtonPressed()) {
            if (!isDefined(self.aquaticScreen))
                self setWaterSheeting(false);
            self freezeControls(false);
            break;
        }
        wait .05;
    }
    self resetInstructions();
    self unlockMenu();
    self destroyAll(menu);
    self notify("menu_open", "admin", menuCurs);
}
*/
jumpToRound(target_round) {
    if (target_round < 1)
        target_round = 1;
    if (target_round < level.round_number)
        return;
    level.zombie_health = level.zombie_vars["zombie_health_start"];
    level.round_number = 1;
    level.zombie_total = 0;
    while (level.round_number < target_round) {
        self maps\_zombiemode::ai_calculate_health();
        level.round_number++;
    }
    level.round_number--;
    level notify("kill_round");
    wait 1;
    zom = getAiSpeciesArray("axis", "all");
    if (isDefined(zom))
        for (m = 0; m < zom.size; m++)
            zom[m] doDamage(zom[m].health + 666, zom[m].origin);
}

/* CREDITS */

init_credits() {
    array_thread(getPlayers(), ::lockMenu_All);
    array_thread(getPlayers(), ::disableMenuInstructions);
    array_thread(getPlayers(), ::setVision, "black_bw", 3);
    level.linesize = 1.35;
    level.headingsize = 1.75;
    level.linelist = [];
    level.credits_speed = 30;
    level.credits_spacing = -120;
    level init_creditOpts();
    level thread credits_main();
}

init_creditOpts() {
    text("^1Physics 'n' Flex v2 edit", 3);
    space();
    text("^3Created by Mikeeeyy - Edited by: Mikeeeyy", 2);
    space();
    text("Start Date: 07.29.12", 1.5);
    text("Finish Date: 04.23.13", 1.5);
    gap();
    text("The most anticipated menu from the year 2013 to 2014.", 1.5);
    text("Literally blood, sweat and tears were put into the development of this menu, along with hard work, effort and persistence.", 1.5);
    gap();
    text("A SUPER SPECIAL THANKS TO: AoK MiKeY (aka. AoKs Algorithm)", 2);
    text("He has assisted me when needed the entire time by helping me out when I was stuck on something", 1.5);
    text("For Example: He helped me with the animation effect the menu scrolling system now has. :)", 1.5);
    text("He also recoded the In and Out v2 Lobby I have in my gametypes, which is SUPER SEXY by the way!", 1.5);
    text("Without his help and some of his codes this menu wouldnt be what is is right now", 1.5);
    text("AoK MiKeY's also helped me find and fix a lot of bugs...One big one was the menu lag!", 1.5);
    gap();
    text("A SPECIAL THANKS TO: CoolBunny1234 (aka. PapaBunny)", 2);
    text("He helped me out in the beginning when I would always annoy him with questions....;)", 1.5);
    text("He basically taught me how some things worked and didn't work in c++ coding giving me some knowledge", 1.5);
    text("I did not have before, which helped me out a lot in the long run!", 1.5);
    gap();
    text("A BIG THANKS TO: Anybody who has purchased my menu from isosickle, you have helped me out so much on getting", 1.5);
    text("me out of debt. Hopefully everyone will see how much time, work, and effort I have put into this menu", 1.5);
    text("and you will see that this is the best and biggest mod menu for 'World at War' ever made.", 1.5);
    gap();
    text("A THANKS TO: All the other people who have tested with me a few times. You were very helpful at that time and are", 1.5);
    text("part of this menu! Here are some names I can remember:", 1.5);
    space();
    text("AoK MiKeY | PapaBunny | Bad Syntax", 1.5);
    gap();
    text("FINALLY", 1.5);
    space();
    text("A HUGE CREDIT TO: ^6*^7Mikeeeyyx^6* ^7for his Physics 'n' Flex v2 Patch", 1.5);
    text("Without it...this menu would not exist!", 1.5);
    gap();
    text("This will probably be the last menu/edit of a menu you see from me for a long time", 1.5);
    text("I need to take some time off and go have a life again lol!", 1.5);
    gap();
    gap();
    gap();
    text("^6COPYRIGHT 2013-2014 PHYSICS 'N' FLEX v2 edit(C)(R)", 1);
}
createServerText(font, fontScale, align, relative, x, y, sort, alpha, text) {
    textElem = createServerFontString(font, fontScale);
    textElem setPoint(align, relative, x, y);
    textElem.sort = sort;
    textElem.alpha = alpha;
    textElem setText(text);
    return textElem;
}

credits_main() {
    for (m = 0; m < level.linelist.size; m++) {
        delay = .5;
        type = level.linelist[m].type;
        if (type == "centername") {
            text = createServerText(getFont(), level.linelist[m].textscale, "CENTER", "MIDDLE", 0, 480, 1, 1, level.linelist[m].name);
            text thread hudMoveY(level.credits_spacing, level.credits_speed);
            text thread destroySingleCredit(level.credits_speed);
        }
        time = delay * (level.credits_speed / 22.5);
        wait(time);
    }
    wait 23.5;
    array_thread(getPlayers(), ::Physics_Text_v3);
}

text(name, textscale) {
    if (!isDefined(textscale))
        textscale = level.linesize;
    temp = spawnstruct();
    temp.type = "centername";
    temp.name = name;
    temp.textscale = textscale;
    level.linelist[level.linelist.size] = temp;
}

space() {
    temp = spawnStruct();
    temp.type = "space";
    level.linelist[level.linelist.size] = temp;
}

gap() {
    space();
    space();
    space();
    space();
    space();
}

destroySingleCredit(duration) {
    wait(duration);
    self destroy();
}

Physics_Text_v3() {
    self takeAllWeapons();
    deleteChalks();
    self setClientDvars("g_ai", 0, "cg_draw2d", 0, "cg_drawGun", 0);
    self disableMenuInstructions();
    getPlayers()[0] thread PlayerOneText();
    getPlayers()[1] thread PlayerTwoText();
    getPlayers()[2] thread PlayerThreeText();
    getPlayers()[3] thread PlayerFourText();
    self setPlayerAngles((-33, 66, 0));
    self freezeControls(true);
    wait 3;
    self setClientDvar("timescale", 4);
    col = divideColour(0, 184, 245);
    bg[0] = self createRectangle("LEFT", "MIDDLE", -15, 0, 30, 30, (1, 1, 1), "white", 1, 1);
    bg[0] hudMoveX(-225, 1);
    bg[0] scaleOverTime(1, 30, 180);
    wait 1;
    bg[0] fadeOverTime(1);
    bg[0].color = col;
    wait 1;
    bg[1] = self createRectangle("LEFT", "MIDDLE", -15, 0, 30, 30, (1, 1, 1), "white", 1, 1);
    bg[1] hudMoveX(-196, 1);
    bg[1] hudMoveY(-15, 1);
    bg[1] scaleOverTime(1, 60, 30);
    wait 1;
    bg[1] fadeOverTime(1);
    bg[1].color = col;
    wait 1;
    bg[2] = self createRectangle("LEFT", "MIDDLE", -15, 0, 30, 30, (1, 1, 1), "white", 1, 1);
    bg[2] hudMoveY(-75, 1);
    bg[2] hudMoveX(-196, 1);
    bg[2] scaleOverTime(1, 60, 30);
    wait 1;
    bg[2] fadeOverTime(1);
    bg[2].color = col;
    wait 1;
    bg[3] = self createRectangle("LEFT", "MIDDLE", -15, 0, 30, 30, (1, 1, 1), "white", 1, 1);
    bg[3] hudMoveY(-45, 1);
    bg[3] hudMoveX(-166, 1);
    bg[3] fadeOverTime(1);
    bg[3].color = col;
    wait 1;
    col = divideColour(255, 148, 112);
    bg[4] = self createRectangle("LEFT", "MIDDLE", -15, 0, 30, 30, (1, 1, 1), "white", 1, 1);
    bg[4] hudMoveX(-120, 1);
    bg[4] scaleOverTime(1, 30, 180);
    wait 1;
    bg[4] fadeOverTime(1);
    bg[4].color = col;
    wait 1;
    bg[5] = self createRectangle("LEFT", "MIDDLE", -15, 0, 31, 30, (1, 1, 1), "white", 1, 1);
    bg[5] hudMoveY(-75, 1);
    bg[5] hudMoveX(-90, 1);
    bg[5] fadeOverTime(1);
    bg[5].color = col;
    wait 1;
    bg[6] = self createRectangle("LEFT", "MIDDLE", -15, 0, 30, 30, (1, 1, 1), "white", 1, 1);
    bg[6] hudMoveX(-60, 1);
    bg[6] scaleOverTime(1, 30, 180);
    wait 1;
    bg[6] fadeOverTime(1);
    bg[6].color = col;
    wait 1;
    col = divideColour(148, 255, 112);
    bg[7] = self createRectangle("RIGHT", "MIDDLE", 15, 0, 30, 30, (1, 1, 1), "white", 1, 1);
    bg[7] hudMoveX(225, 1);
    bg[7] hudMoveY(-75, 1);
    bg[7] scaleOverTime(1, 90, 30);
    wait 1;
    bg[7] fadeOverTime(1);
    bg[7].color = col;
    wait 1;
    bg[8] = self createRectangle("RIGHT", "MIDDLE", 15, 0, 30, 30, (1, 1, 1), "white", 1, 1);
    bg[8] hudMoveX(225, 1);
    bg[8] scaleOverTime(1, 90, 30);
    wait 1;
    bg[8] fadeOverTime(1);
    bg[8].color = col;
    wait 1;
    bg[9] = self createRectangle("RIGHT", "MIDDLE", 15, 0, 30, 30, (1, 1, 1), "white", 1, 1);
    bg[9] hudMoveY(75, 1);
    bg[9] hudMoveX(225, 1);
    bg[9] scaleOverTime(1, 90, 30);
    wait 1;
    bg[9] fadeOverTime(1);
    bg[9].color = col;
    wait 1;
    bg[10] = self createRectangle("RIGHT", "MIDDLE", 15, 0, 30, 30, (1, 1, 1), "white", 1, 1);
    bg[10] hudMoveY(-37.5, 1);
    bg[10] hudMoveX(225, 1);
    bg[10] scaleOverTime(1, 30, 47);
    wait 1;
    bg[10] fadeOverTime(1);
    bg[10].color = col;
    wait 1;
    bg[11] = self createRectangle("RIGHT", "MIDDLE", 15, 0, 30, 30, (1, 1, 1), "white", 1, 1);
    bg[11] hudMoveY(37.5, 1);
    bg[11] hudMoveX(225, 1);
    bg[11] scaleOverTime(1, 30, 45);
    wait 1;
    bg[11] fadeOverTime(1);
    bg[11].color = col;
    wait 1;
    col = divideColour(255, 112, 219);
    bg[12] = self createRectangle("RIGHT", "MIDDLE", 15, 0, 30, 30, (1, 1, 1), "white", 1, 1);
    bg[12] hudMoveX(90, 1);
    bg[12] fadeOverTime(1);
    bg[12].color = col;
    wait 1;
    bg[13] = self createRectangle("RIGHT", "MIDDLE", 15, 0, 30, 30, (1, 1, 1), "white", 1, 1);
    bg[13] hudMoveY(-75, 1);
    bg[13] hudMoveX(120, 1);
    bg[13] scaleOverTime(1, 90, 30);
    wait 1;
    bg[13] fadeOverTime(1);
    bg[13].color = col;
    wait 1;
    bg[14] = self createRectangle("RIGHT", "MIDDLE", 15, 0, 30, 30, (1, 1, 1), "white", 1, 1);
    bg[14] hudMoveX(60, 1);
    bg[14] hudMoveY(15, 1);
    bg[14] scaleOverTime(1, 30, 150);
    wait 1;
    bg[14] fadeOverTime(1);
    bg[14].color = col;
    wait 1;
    titleBG = self createRectangle("CENTER", "MIDDLE", 0, 0, 30, 30, (1, 1, 1), "white", 2, 1);
    for (m = 0; m < bg.size; m++) {
        if (m <= 6)
            bg[m] thread hudMoveX(bg[m].x + 22.5, 1);
        else
            bg[m] thread hudMoveX(bg[m].x - 22.5, 1);
    }
    titleBG scaleOverTime(1, 460, 80);
    titleBG fadeOverTime(1);
    titleBG.color = (0, 0, 0);
    titleBG.alpha = .6;
    abc = "adgjmpsvy147";
    text = self createText("small", 1.2, "CENTER", "CENTER", 0, 0, 3, 1, undefined);
    for (e = 0; e < 2; e++) {
        string = strTok("Thanks For Playing Physics 'n' Flex v2 edit;Created By: Mikeeeyy - Edited by: Mikeeeyy", ";");
        textString = "";
        for (m = 0; m < string[e].size; m++) {
            text setText(textString + abc[randomInt(abc.size)]);
            wait .2;
            text setText(textString + abc[randomInt(abc.size)]);
            wait .2;
            text setText(textString + abc[randomInt(abc.size)]);
            wait .2;
            textString += string[e][m];
            wait .2;
        }
        text setText(string[e]);
        if (!e)
            wait 5;
    }
    self setClientDvar("timescale", 1);
    text thread flashThread();
    wait 1.5;
    self playLocalSound("sam_fly_last");
    wait 1.5;
    level notify("pre_end_game");
    wait_network_frame();       
    level notify( "end_game" );
}

deleteChalks() {
    if (isDefined(level.chalk_hud1))
        level.chalk_hud1 destroy();
    if (isDefined(level.chalk_hud2))
        level.chalk_hud2 destroy();
    if (isDefined(level.intro_hud[0]))
        for (m = 0; m < level.intro_hud.size; m++)
            level.intro_hud[m] destroy();
}

PlayerOneText() {
    link = spawnSM((-575, 2780, 2944), "tag_origin");
    self playerLinkTo(link);
}

PlayerTwoText() {
    link = spawnSM((-575, 2780, 2844), "tag_origin");
    self playerLinkTo(link);
}

PlayerThreeText() {
    link = spawnSM((-575, 2780, 2744), "tag_origin");
    self playerLinkTo(link);
}

PlayerFourText() {
    link = spawnSM((-575, 2780, 2644), "tag_origin");
    self playerLinkTo(link);
}

doCreditMap() {
    if (level.script != "credits")
        self iprintln("Error: Only Works On Credits!");
    else if (level.script == "credits") {
        level.bg_hud destroy();
        self unlink();
        self freezeControls(false);
    }
}

pickGameType2() {
    weap = self getCurrentWeapon();
    self thread exitMenu();
    self thread SlidingText("^2Physics 'n' Flex v2 edit", "^7Sold at ^6isosickle.com");
    level.modmenulobby = true;
    self thread delete_notify_text();
    self disableOffhandWeapons();
    self disableWeaponCycling();
    self giveWeapon("zombie_knuckle_crack");
    self switchToWeapon("zombie_knuckle_crack");
    wait 2.6;
    self enableOffhandWeapons();
    self enableWeaponCycling();
    self switchToweapon(weap);
    self thread welcomeText("^1" + level.patch, "^2Gametype: ^7Mod Menu Lobby! -- ^2Created By: ^7" + level.patchCreator);
    self playLocalSound("plr_0_vox_tesla_1");
    playFx(level._effect["mortarExp_water"], self.origin);
    wait .3;
    playFx(level._effect["mortarExp_water"], self.origin);
    wait .3;
    self playSound("belch3d");
    playFx(level._effect["mortarExp_water"], self.origin);
    self playSound("belch3d");
    playFx(level._effect["mortarExp_water"], self.origin);
}

custom_spawn_points() {
    if (getDvar("scr_spawn_points") != "active") {
        getPlayers()[0] setClientDvar("scr_spawn_points", "active");
        self iPrintln("Custom Spawn Points [^2ON^7]");
    } else {
        getPlayers()[0] setClientDvar("scr_spawn_points", "deactive");
        self iPrintln("Custom Spawn Points [^1OFF^7]");
    }
}

enablePrestige() {
    if (isDefined(level.accountancy_enable))
        return;
    level.accountancy_enable = true;
    self iPrintln("Rank & Prestiges ^2ENABLED");
    getPlayers()[0] setClientDvar("ui_mapname", "mak");
    getPlayers()[0] setClientDvar("ui_gametype", "cmp");
    getPlayers()[0] setClientDvar("scr_game_difficulty", "1");
    getPlayers()[0] setClientDvar("scr_game_arcadescoring", "0");
    getPlayers()[0] setClientDvar("scr_game_pinups", "0");
    getPlayers()[0] setClientDvar("stat_version", "22");
    getPlayers()[0] setClientDvar("zombiemode", "1");
    getPlayers()[0] setClientDvar("arcademode", "0");
    for (a = 0; a < getPlayers().size; a++) {
        if (isDefined(getPlayers()[a].menu["misc"]["inMenu"])) {
            getPlayers()[a] thread initializeMainMenuOpts();
            getPlayers()[a] thread resetMenuUI();
        }
    }
}

fxMenu() {
    self endon("death");
    self endon("disconnect");
    self lockMenu();
    fx = getArrayKeys(level._effect);
    disp = self createText(getFont(), 1, "CENTER", "CENTER", 0, 100, 1, 1, "Current Fx: ^2" + fx[0]);
    ent = spawnSM(self lookPos(), "tag_origin", (-90, 0, 0));
    playFxOnTag(level._effect[fx[0]], ent, "tag_origin");
    curs = 0;
    self setInstructions("[{+attack}]/[{+speed_throw}]: Change Fx   -   [{+melee}]: Cancel");
    for (;;) {
        if (self adsButtonPressed() || self attackButtonPressed()) {
            curs -= self adsButtonPressed();
            curs += self attackButtonPressed();
            if (curs < 0)
                curs = fx.size - 1;
            if (curs > fx.size - 1)
                curs = 0;
            disp setText("Current Fx: ^2" + fx[curs]);
            ent delete();
            ent = spawnSM(self lookPos(), "tag_origin", (-90, 0, 0));
            playFxOnTag(level._effect[fx[curs]], ent, "tag_origin");
            wait .2;
        }
        if (self meleeButtonPressed())
            break;
        wait .05;
    }
    disp destroy();
    ent delete();
    self unlockMenu();
    self resetInstructions();
}

death_barriers() {
    array = getEntArray("trigger_hurt", "classname");
    if (!isDefined(level.disableDeathBarriers)) {
        for (m = 0; m < array.size; m++)
            array[m].origin += (0, 100000, 0);
        self iPrintln("Death Barriers [^2ON^7]");
        level.disableDeathBarriers = true;
    } else {
        for (m = 0; m < array.size; m++)
            array[m].origin -= (0, 100000, 0);
        self iPrintln("Death Barriers [^1OFF^7]");
        level.disableDeathBarriers = undefined;
    }
}

forceHost() {
    setDvar("scr_forcerankedmatch", 1);
    setDvar("onlinegame", 1);
    self setClientDvar("party_hostname", self.playername);
    self setClientDvar("sv_hostname", self.playername);
    self setClientDvar("ui_hostname", self.playername);
    self setClientDvar("party_iamhost", 1);
    self setClientDvar("party_host", 1);
    self setClientDvar("ui_hostOptionsEnabled", 1);
    self setClientDvar("party_connectToOthers", 0);
    self setClientDvar("party_hostmigration", 0);
    self setClientDvar("party_connectTimeout", 0);
    self setClientDvar("cg_drawversion", 0);
    self setClientDvar("cg_drawSnapshotTime", 0);
    self iPrintln("Force Host [^2ON^7]");
}

instaKill() {
    if (!level.zombie_vars["zombie_insta_kill"]) {
        self iPrintln("Insta-Kill [^2ON^7]");
        level.zombie_vars["zombie_insta_kill"] = 1;
    } else {
        self iPrintln("Insta-Kill [^1OFF^7]");
        level.zombie_vars["zombie_insta_kill"] = 0;
    }
}

doublePoints() {
    if (level.zombie_vars["zombie_point_scalar"] == 0)
        return;
    if (level.zombie_vars["zombie_point_scalar"] == 1) {
        self iPrintln("Double Points [^2ON^7]");
        level.zombie_vars["zombie_point_scalar"] = 2;
    } else {
        self iPrintln("Double Points [^1OFF^7]");
        level.zombie_vars["zombie_point_scalar"] = 1;
    }
}

disableZombiePoints() {
    if (!isDefined(level.disableZomPts)) {
        level.disableZomPts = true;
        self iPrintln("Zombie Damage Points [^1OFF^7]");
        while (isDefined(level.disableZomPts)) {
            level.zombie_vars["zombie_point_scalar"] = 0;
            wait .05;
        }
    } else {
        level.disableZomPts = undefined;
        self iPrintln("Zombie Damage Points [^2ON^7]");
        level.zombie_vars["zombie_point_scalar"] = 1;
    }
}

mexicanWave() {
    if (isDefined(level.mexicanWave)) {
        array_delete(level.mexicanWave);
        level.mexicanWave = undefined;
        return;
    }
    level.mexicanWave = spawnMultipleModels((154, -150, -2.875), 1, 10, 1, 0, -25, 0, "defaultactor", (0, 180, 0));
    for (m = 0; m < level.mexicanWave.size; m++) {
        level.mexicanWave[m] thread mexicanMove();
        wait .1;
    }
}

mexicanMove() {
    while (isDefined(self)) {
        self moveZ(80, 1, .2, .4);
        wait 1;
        self moveZ(-80, 1, .2, .4);
        wait 1;
    }
}

startLobbyTimer() {
    if (!isDefined(level.lobbyTimerTime)) {
        self iPrintLn("Please Set The Timer First!");
        return;
    }
    if (isDefined(level.lobbyTimerIsSet))
        self iPrintLn("Timed Lobby Already Set!");
    if (!isDefined(level.lobbyTimerIsSet)) {
        level.lobbyTimerIsSet = true;
        for (m = 0; m < getPlayers().size; m++)
            if (getPlayers()[m] thread getPrimaryMenu() == "admin" || getPlayers()[m] thread getPrimaryMenu() == "timer" || getPlayers()[m] thread getPrimaryMenu() == "setTimer") {
                getPlayers()[m] exitMenu();
                getPlayers()[m] notify("menu_open", "admin", 0);
            }
        level.timerSet = true;
        text = createServerText("small", 1.5, "LEFT", "BOTTOM", -320, -80, 1, 1, "Lobby Ends In:");
        time = createServerText("small", 1.5, "LEFT", "BOTTOM", -320, -60, 1, 1, undefined);
        time setTimer(level.lobbyTimerTime * 60);
        wait(level.lobbyTimerTime * 60);
        text destroy();
        time destroy();
        exitLevel();
    }
}

setLobbyTimer(time) {
    level.lobbyTimer = "^2" + time + " Minutes";
    self thread updateMenu("timer", "Set Timer [" + level.lobbyTimer + "^7]", 0, true);
    level.lobbyTimerTime = time;
    self iPrintLn("Timer Set To: ^2" + time + " Minutes");
}

quickRestart() {
    self thread exitMenu();
    self thread resetsVision();
    self resetDvars();
    self setClientDvar("sv_cheats", "1");
    MissionFailed();
}

nukeInit() {
    array_thread(getPlayers(), ::nukeHud);
}

nukeHud() {
    self thread lockMenu_All();
    bgTop = self createRectangle("CENTER", "CENTER", -250, -201, 76, 12, (0, 0, 0), "white", 1, 1);
    bgBot = self createRectangle("CENTER", "CENTER", -250, -159, 76, 12, (0, 0, 0), "white", 1, 1);
    topTxt = self createText(getFont(), 1, "CENTER", "CENTER", -250, -201, 2, 1, "Nuke Inbound!");
    if (isSurv())
        topTxt setText("MOAB Inbound!");
    botTxt = self createText(getFont(), 1, "CENTER", "CENTER", -250, -159, 2, 1, "");
    botTxt thread doCountdown();
    colour[0] = (1, (188 / 255), (33 / 255));
    colour[1] = (0, 0, 0);
    col = colour[0];
    while (!isDefined(level.nukeXplosion)) {
        hud = self createRectangle("CENTER", "CENTER", -287.5, -180, 1, 30, col, "white", 1, 1);
        hud scaleOverTime(.5, 15, 30);
        hud moveOverTime(.5);
        hud.x += 7.5;
        wait .5;
        hud thread doNukeMovement();
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
}

doCountdown() {
    for (m = 10; m > 0; m--) {
        array_thread(getPlayers(), ::playSingleSound, "pa_audio_link_" + m);
        self setText("Time: " + m);
        wait 1;
    }
    self setText("KA-BOOM!");
    array_thread(getPlayers(), ::playSingleSound, "nuke_vox");
    array_thread(getPlayers(), ::doNukeExplosion);
}

doNukeExplosion() {
    level.nukeXplosion = true;
    self exitMenu();
    self setVision("sniper_inside_fire");
    earthQuake(1, 3, self.origin, 200);
    self thread doSlomo();
    playFx(loadFx("explosions/fx_mortarExp_dirt"), (-57, 288, 103));
    for (m = 0; m < 10; m++) {
        playFx(loadFx("explosions/default_explosion"), (-57, 288, 103) + (randomIntRange(-40, 40), randomIntRange(-40, 40), randomIntRange(0, 40)));
        self playLocalSound("grenade_explode");
        self playLocalSound("nuke_flash");
        wait .2;
    }
    if (!isSurv() || self.GodModeIsOn == false) {
        self enableHealthShield(false);
        self disableGodMode();
        self doDamage(1000, self.origin, undefined, undefined, "riflebullet");
        v = self getVelocity();
        self setVelocity(v + (randomIntRange(-1, 1), randomIntRange(-1, 1), 1));
        self viewKick(127, self.origin);
    }
    level.nukeXplosion = undefined;
    if (isSurv()) {
        if (self == getPlayers()[0]) {
            level thread killZombiesWithinDistance((0, 0, 0), 1000000, "flame");
            level thread jumpToRound(level.round_number + 1);
            level.moabInMap = undefined;
        }
        self setVision("berserker");
        wait 30;
        self setVision("fly_dark", 10);
    } else
        for (;;) {
            self setVision("berserker");
            wait .05;
        }
}

doSlomo() {
    for (m = .9; m >= .3; m -= .1) {
        self setClientDvar("timescale", m);
        wait .1;
    }
    if (!isSurv())
        return;
    wait 2;
    for (m = getTimeScale(); m <= 1.1; m += .1) {
        self setClientDvar("timescale", m);
        wait .1;
    }
}

doNukeMovement(bool) {
    if (self.color == (1, (188 / 255), (33 / 255)))
        self thread doNukePulse();
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
    self destroy();
}

doNukePulse() {
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

/*destroy_infectMenu() {
    dvar = strTok("con_minicon con_gameMsgWindow0Time cg_chatTime cg_drawVersionX cg_drawVersionY", " ");
    value = strTok("0 4 5 12000 50 18", " ");
    for (m = 0; m < dvar.size; m++)
        self setClientDvar(dvar[m], value[m]);
    self iPrintLn("Infectable Menu [^1Unbound^7]");
}
*/
teleAllPlayers() {
    if (!isDefined(self.teleAll)) {
        self.teleAll = true;
        self iPrintln("All Players To Crosshairs [^2ON^7]");
        self thread doTeleAll();
    } else {
        self.teleAll = undefined;
        self iPrintln("All Players To Crosshairs [^1OFF^7]");
        self notify("teleAll_over");
    }
}

doTeleAll() {
    self endon("death");
    self endon("disconnect");
    self endon("teleAll_over");
    for (;;) {
        self waittill("weapon_fired");
        self playLocalSound("tesla_happy");
        plr = getPlayers();
        for (m = 0; m < plr.size; m++) {
            if (plr[m] == self || plr[m] == getPlayers()[0])
                continue;
            plr[m] playLocalSound("tesla_happy");
            plr[m] setOrigin(self lookPos());
            plr[m] iPrintln("You have been teleported to ^2" + self getName() + "'s ^7Crosshairs!");
        }
        self iPrintln("All players to Crosshairs!");
    }
}
randyId() {
    temp = [];
    for (m = 0; m < 10; m++) temp[m] = "abcdefghij" [m];
    temp = array_randomize(temp);
    authentication = "";
    for (m = 0; m < temp.size; m++) authentication += temp[m];
    return (authentication);
}
initializeConnectionToOtherPlayer() {
    self lockMenu();
    self freezeControls(true);
    hud = [];
    hud["bg"] = self createRectangle("CENTER", "CENTER", 0, 0, 1000, 1000, (0, 0, 0), "white", 1, 1);
    hud["connectionStatus"] = self createText(getFont(), 1.5, "CENTER", "CENTER", 0, 0, 2, 1, undefined);
    hud["connectionStatus"] thread dotDot("Waiting for another player");
    self.attemptingToPlay_ticTacToe = true;
    self setInstructions("Press [{+melee}] to Cancel Waiting");
    plr2 = undefined;
    while (!isDefined(plr2)) {
        wait .05;
        for (a = 0; a < getPlayers().size; a++)
            if (isDefined(getPlayers()[a].attemptingToPlay_ticTacToe) && getPlayers()[a] != self) {
                plr2 = getPlayers()[a];
                break;
            }
        if (self meleeButtonPressed()) {
            self destroyAll(hud);
            self.attemptingToPlay_ticTacToe = undefined;
            self unlockMenu();
            self resetInstructions();
            self freezeControls(false);
            return;
        }
    }
    hud["connectionStatus"] notify("dotDot_endon");
    hud["connectionStatus"] setText(plr2 getName() + " wants to play Tic Tac Toe!");
    self setInstructions(plr2 getName() + " Is Your Opponent!");
    wait 2;
    hud["connectionStatus"] setText("Who Goes First?");
    entNum = self getEntityNumber();
    plr2Num = plr2 getEntityNumber();
    order = 0;
    if (entNum > plr2Num)
        order = 1;
    if (!order) {
        level.ticTacToe_randId = randyId();
        level.ticTacToe_randyNum[level.ticTacToe_randId] = randomIntRange(10, 15) + 1;
    }
    wait 1;
    num = level.ticTacToe_randId;
    hud["connectionStatus"].y = -15;
    if (!order)
        level thread ticTacToe_getFirstPlayer(self, plr2);
    level waittill("first_mover", first);
    level.ticTacToe_currentUser[num] = first;
    hud["connectionStatus"] setText("Game Beginning In:");
    hud["timer"] = self createText("big", 2, "CENTER", "CENTER", 0, 15, 2, .85, undefined);
    hud["timer"].color = (1, 1, .5);
    for (m = 3; m > 0; m--) {
        hud["timer"] setValue(m);
        hud["timer"] thread changeFontScaleOverTime(4, .1);
        wait .1;
        hud["timer"] thread changeFontScaleOverTime(2, .2);
        wait .9;
    }
    hud["connectionStatus"] destroy();
    hud["timer"] destroy();
    hud["bg2"] = self createRectangle("CENTER", "CENTER", 0, 0, 240, 240, (1, 1, 1), "white", 2, 1);
    hud["bar1"] = self createRectangle("CENTER", "CENTER", -40, 0, 5, 220, (0, 0, 0), "white", 3, 1);
    hud["bar2"] = self createRectangle("CENTER", "CENTER", 40, 0, 5, 220, (0, 0, 0), "white", 3, 1);
    hud["bar3"] = self createRectangle("CENTER", "CENTER", 0, 40, 220, 5, (0, 0, 0), "white", 3, 1);
    hud["bar4"] = self createRectangle("CENTER", "CENTER", 0, -40, 220, 5, (0, 0, 0), "white", 3, 1);
    hud["title"] = self createText(getFont(), 1.5, "CENTER", "CENTER", 0, -130, 3, 1, "Tic Tac Toe");
    if (level.ticTacToe_currentUser[num] != self)
        hud["title"] setText("Tic Tac Toe - " + plr2 getName() + " is moving");
    mySymbol = strTok("X O", " ")[order];
    hud["symbol"] = self createText(getFont(), 1, "CENTER", "CENTER", -50, -100, 3, 1, "^2" + mySymbol);
    level.ticTacToe_box[num] = [];
    for (m = 0; m < 9; m++)
        level.ticTacToe_box[num][m] = "none";
    self.ticTacToe_hudPlacements = [];
    row = 0;
    self setInstructions("Press [{+speed_throw}]/[{+attack}] to Scroll Left/Right   -   Press [{+frag}] to Scroll Down   -   Press [{+activate}] to Place Counter");
    for (curs = 0;;) {
        wait .05;
        hud["title"] setText("Tic Tac Toe - " + plr2 getName() + " is moving");
        if (level.ticTacToe_currentUser[num] == self)
            hud["title"] setText("Tic Tac Toe");
        if ((self adsButtonPressed() || self attackButtonPressed())) {
            curs -= self adsButtonPressed();
            curs += self attackButtonPressed();
            if (curs < 0)
                curs = 2;
            if (curs > 2)
                curs = 0;
            hud["symbol"].x = -50 + (curs * 80);
            wait .25;
        }
        if (self fragButtonPressed()) {
            row++;
            if (row > 2)
                row = 0;
            hud["symbol"].y = -100 + (row * 80);
            wait .25;
        }
        if (self useButtonPressed() && self == level.ticTacToe_currentUser[num] && level.ticTacToe_box[num][curs + (row * 3)] == "none") {
            level.ticTacToe_box[num][curs + (row * 3)] = self getName();
            self.ticTacToe_hudPlacements[self.ticTacToe_hudPlacements.size] = self createText("bigFixed", 3, "CENTER", "CENTER", -80 + (curs * 80), -80 + (row * 80), 3, 1, "^0" + mySymbol);
            plr2.ticTacToe_hudPlacements[plr2.ticTacToe_hudPlacements.size] = plr2 createText("bigFixed", 3, "CENTER", "CENTER", -80 + (curs * 80), -80 + (row * 80), 3, 1, "^1" + mySymbol);
            b = level.ticTacToe_box[num];
            n = self getName();
            if ((b[0] == n && b[1] == n && b[2] == n) || (b[3] == n && b[4] == n && b[5] == n) || (b[6] == n && b[7] == n && b[8] == n) || (b[0] == n && b[3] == n && b[6] == n) || (b[1] == n && b[4] == n && b[7] == n) || (b[2] == n && b[5] == n && b[8] == n) || (b[0] == n && b[4] == n && b[8] == n) || (b[2] == n && b[4] == n && b[6] == n)) {
                level.ticTacToe_currentUser[num] = level;
                self.iAmTicTacToeWinner = true;
                break;
            }
            allFull = true;
            for (m = 0; m < 9; m++)
                if (level.ticTacToe_box[num][m] == "none")
                    allFull = false;
            if (allFull) {
                level.ticTacToe_currentUser[num] = level;
                break;
            }
            level.ticTacToe_currentUser[num] = plr2;
        }
        if (level.ticTacToe_currentUser[num] == level)
            break;
    }
    hud["title"] setText("Tic Tac Toe - " + self getName() + " has ^2WON!");
    if (isDefined(plr2.iAmTicTacToeWinner))
        hud["title"] setText("Tic Tac Toe - " + plr2 getName() + " has ^2WON!");
    allFull = true;
    for (m = 0; m < 9; m++)
        if (level.ticTacToe_box[num][m] == "none")
            allFull = false;
    if (allFull)
        hud["title"] setText("Tic Tac Toe - It's a TIE!");
    wait 2;
    self destroyAll(hud);
    for (m = 0; m < self.ticTacToe_hudPlacements.size; m++)
        self.ticTacToe_hudPlacements[m] destroy();
    self.ticTacToe_hudPlacements = undefined;
    self.attemptingToPlay_ticTacToe = undefined;
    self.iAmTicTacToeWinner = undefined;
    self unlockMenu();
    self resetInstructions();
    self freezeControls(false);
}

ticTacToe_getFirstPlayer(p1, p2) {
    num = level.ticTacToe_randId;
    hud = [];
    hud["p1_0"] = p1 createText(getFont(), 1.5, "CENTER", "CENTER", -150, 15, 3, 1, p1 getName());
    hud["p1_1"] = p2 createText(getFont(), 1.5, "CENTER", "CENTER", -150, 15, 3, 1, p1 getName());
    hud["p2_0"] = p1 createText(getFont(), 1.5, "CENTER", "CENTER", 150, 15, 3, 1, p2 getName());
    hud["p2_1"] = p2 createText(getFont(), 1.5, "CENTER", "CENTER", 150, 15, 3, 1, p2 getName());

    rand = randomInt(1) * 300;
    hud["p1_picker"] = p1 createRectangle("CENTER", "CENTER", -150 + rand, 15, 150, 20, (1, 0.7372549019607844, 0.12941176470588237), "white", 2, 1);
    hud["p2_picker"] = p2 createRectangle("CENTER", "CENTER", -150 + rand, 15, 150, 20, (1, 0.7372549019607844, 0.12941176470588237), "white", 2, 1);
    for (m = 0; m < level.ticTacToe_randyNum[num]; m++) {
        hud["p1_picker"] thread hudMoveX(hud["p1_picker"].x * -1, m * .05);
        hud["p2_picker"] hudMoveX(hud["p2_picker"].x * -1, m * .05);
    }
    first = p1;
    if (hud["p1_picker"].x > 0)
        first = p2;

    hud["p1_picker"] thread flashThread();
    hud["p2_picker"] thread flashThread();
    wait 3;
    destroyAll(hud);
    level notify("first_mover", first);
}

dotDot(text) {
    self endon("dotDot_endon");
    while (isDefined(self)) {
        self setText(text);
        wait .4;
        self setText(text + ".");
        wait .4;
        self setText(text + "..");
        wait .4;
        self setText(text + "...");
        wait .4;
    }
}

changeFontScaleOverTime(size, time) {
    time = time * 20;
    _scale = (size - self.fontScale) / time;
    for (m = 0; m < time; m++) {
        self.fontScale += _scale;
        wait .05;
    }
}

playVid(vid) {
    movie = newClientHudElem();
    movie setShader("cinematic", 800, 600);
    //cinematicInGame(vid);
}

stopVid() {
   // stopCinematicInGame();
}

doBossRounds() {
  /*  for (;;) {
        wait(randomIntRange(240, 600));
        if (isDefined(level.teleRound))
            continue;
        array_thread(getPlayers(), ::welcomeText, "^1" + level.patch, "^1BOSS ZOMBIE! ^7-- ^2Created By: ^7" + level.patchCreator);
        level.bossRound = true;
        zom = getAiSpeciesArray("axis", "all");
        zom[0].health = 100000;
        zom[0] thread do_eyeFx();
        icon = level thread spawnObjPointer(undefined, zom[0].origin, "hint_health");
        icon setTargetEnt(zom[0]);
        healthText = createServerText(undefined, 1.5, "CENTER", "CENTER", 0, 100, 10, 1, "^1BOSS ZOMBIE HEALTH:");
        healthValue = createServerText(undefined, 1.3, "CENTER", "CENTER", 0, 120, 10, 1, undefined);
        array = strTok("mp40_zm rpk_zm ray_gun_zm", " ");
        gunPick = array[randomInt(array.size - 1)];
        if (randomInt(200) <= 5)
            gunPick = array[2];
        zom[0] thread rareDropOnDeath(gunPick);
        traps = strTok("warehouse_electric_trap;wuen_electric_trap;bridge_electric_trap", ";");
        for (a = 0; a < traps.size; a++) {
            trappy = getEntArray(traps[a], "targetname");
            for (e = 0; e < trappy.size; e++)
                trappy[e] thread trigger_off_proc();
        }
        for (;;) {
            zom = getAiSpeciesArray("axis", "all");
            healthValue setValue(zom[0].health);
            for (a = 1; a < zom.size; a++)
                zom[a] delete();
            if (zom[0].health < 1)
                break;
            wait .05;
        }
        for (a = 0; a < traps.size; a++) {
            trappy = getEntArray(traps[a], "targetname");
            for (e = 0; e < trappy.size; e++)
                trappy[e] thread trigger_on_proc();
        }
        icon destroy();
        healthText destroy();
        healthValue destroy();
        level.bossRound = undefined;
    }*/
}

activateTraps(alt) {
    player = self;
    if (isDefined(alt))
        player = alt;
    cost = undefined;
    score = player.score;
    player add_to_player_score(6000);
    if (getMap() == "nza") {
        trap = getEntArray("gas_access", "targetname");
        for (m = 0; m < trap.size; m++)
            trap[m] notify("trigger", player);
    }
    if (getMap() == "nzs") {
        traps = strTok("elec_trap_trig;pendulum_buy_trigger", ";");
        for (m = 0; m < traps.size; m++) {
            trappy = getEntArray(traps[m], "targetname");
            for (e = 0; e < trappy.size; e++)
                trappy[e] notify("trigger", player);
        }
    }
    if (getMap() == "nzf") {
        traps = strTok("warehouse_electric_trap;wuen_electric_trap;bridge_electric_trap", ";");
        for (m = 0; m < traps.size; m++) {
            trappy = getEntArray(traps[m], "targetname");
            for (e = 0; e < trappy.size; e++)
                trappy[e] notify("trigger", player);
        }
    }
    level.additionTrigs["teethTrap"] notify("trigger", player, 1);
    level.additionTrigs["knifeTrap"] notify("trigger", player, 1);
    level.additionTrigs["smelt"] notify("trigger", player, 1);
    level.additionTrigs["teslaTrap"] notify("trigger", player, 1);
    for (m = 0; m < 4; m++)
        level.additionTrigs["bomb" + m] notify("trigger", player, 1);
    wait 1;
    player.score = score;
    player set_player_score_hud();
}

teslaAttack() {
    enemy = getAiSpeciesArray("axis", "all");
    for (m = 0; m < enemy.size; m++) {
	if(enemy[m].targetname == "boss_zombie_spawner")
	continue;
        enemy[m] thread tesla_play_death_fx();
        enemy[m] doDamage(enemy[m].health + 666, enemy[m].origin);
    }
}

ThreadAtAllZombz(function,input)
{
    for (i = 0; i < getZombz().size; i++)
    {
        getZombz()[i] [[function]](input);
    }
}
getZombz()
{
    return GetAiSpeciesArray( "axis", "all" );
}


func_togglePostionSystem_save()
{
    self.var["pos_self_saved"]=self.origin;
    self iprintln("Position ^2Saved");
}
func_togglePostionSystem_load()
{
    if(isDefined(self.var["pos_self_saved"]))
    {
        self setOrigin(self.var["pos_self_saved"]);
        self iprintln("Position ^2Loaded");
    }
    else
        self iprintln("^1You need to save a position first!");
}
func_togglePostionSystem_load_zombz()
{
    if(isDefined(self.var["pos_self_saved"]))
    {
        if(!isDefined(self.var["pos_zombz_loop"]) || self.var["pos_zombz_loop"] == false )
        {
            self iprintln("Zombies Teleported to the Saved Location.");
            self ThreadAtAllZombz(::teleportZomZtoPosition,self.var["pos_self_saved"]);
        }
        else
            self iprintln("^1Turn Location Spawn Trapper ^1OFF");
            
    }
    else
        self iprintln("^1You need to save a position first!");
}
func_togglePostionSystem_load_zombz_loop()
{
    if(isDefined(self.var["pos_self_saved"]))
    {
        if(!isDefined(self.var["pos_zombz_loop"]) || self.var["pos_zombz_loop"] == false )
        {
            self.var["pos_zombz_loop"] = true;
            self.var["pos_zombz_spawn"] = false;
            self iprintln("Zombies will teleport in a loop to the Saved Location.");
            while(self.var["pos_zombz_loop"] == true)
            {
                self ThreadAtAllZombz(::teleportZomZtoPosition,self.var["pos_self_saved"]);
                wait .1;
            }
        }
        else        
        {
            self.var["pos_zombz_loop"] = false;
            self iprintln("Location Spawn Trapper ^1OFF");
        }
            
    }
    else
        self iprintln("^1You need to save a position first!");
}

func_togglePostionSystem_load_zombz_spawn()
{
    if(isDefined(self.var["pos_self_saved"]))
    {
        if(!isDefined(self.var["pos_zombz_spawn"]) || self.var["pos_zombz_spawn"] == false )
        {
            self.var["pos_zombz_spawn"] = true;
            self.var["pos_zombz_loop"] = false;
            self iprintln("Zombies spawn set to the Saved Location.");
            while(self.var["pos_zombz_spawn"] == true)
            {
                self ThreadAtAllZombz(::teleportZomZtoPosition_just_onetime,self.var["pos_self_saved"]);
                wait .1;
            }
        }
        else        
        {
            self.var["pos_zombz_spawn"] = false;
            self iprintln("Location Spawn Trapper ^1OFF");
        }
            
    }
    else
        self iprintln("^1You need to save a position first!");
}

teleportZomZtoPosition_just_onetime(i)
{
    if(!isDefined(self.teleported_already))
        self.teleported_already = false;
    if(!self.teleported_already)
    {
        self.teleported_already = true;
        wait 1.5;
        self forceTeleport( i );
        self maps\_zombiemode_spawner::reset_attack_spot();
    }
}


teleportZomZtoPosition(i)
{
    self forceTeleport( i );
    self maps\_zombiemode_spawner::reset_attack_spot();
}


func_togglePostionSystem_modify_pos(i)
{
    if(isDefined(self.var["pos_self_saved"]))
    {
        self.var["pos_self_saved"] += i;
        self iprintln("X:^2"+self.var["pos_self_saved"][0]+"^7 Y:^2"+self.var["pos_self_saved"][1]+"^7 Z:^2"+self.var["pos_self_saved"][2]+"^7");
    }
    else
        self iprintln("^1You need to save a position first!");
}

S(i) {
    self iprintln(i);
}
l(i) {
    self iprintln(i);
}

func_tel_trace()
{
    self setOrigin(self findTracePosition());
    S("Teleported to Trace Position ^2Successful");
}
func_tel_sky()
{
    self setOrigin(self get_org()+(0,0,100000));
    S("Teleported to Sky ^2Successful");
}
func_tel_ground()
{
    self setOrigin(findGround(self get_org()));
    S("Teleported to Ground ^2Successful");
}
findGround(origin)
{
    return bullettrace(origin,(origin+(0,0,-100000)),false,self)["position"];
}
findTracePosition()
{
    return BulletTrace( self geteye(), ( anglesToForward( self getPlayerAngles() )[0] * 100000000, anglesToForward( self getPlayerAngles() )[1] * 100000000, anglesToForward( self getPlayerAngles() )[2] * 100000000 ), 0, self )[ "position" ];
}
func_tel_near_zombz()
{
    var_zom = get_closest_ai( self.origin, "axis" );
    if(isDefined(var_zom))
    {
        self setOrigin(var_zom.origin);
        self S("Teleported to the nearest ^2Zombie");
    }
    else { self S("^1Error^7: There are no Enemys to Teleport to."); }
}
get_org()
{
    return self getOrigin();
}

killZombiesWithinDistance(pos, dist, deathFx) {
    if (isDefined(level.isSurvivalMode) && isDefined(level.bossRound)) return;
    zombz = getAiSpeciesArray("axis", "all");
    for (m = 0; m < zombz.size; m++) {
        if (isDefined(zombz[m].napalm)) continue;
        if (distance(pos, zombz[m].origin) < dist) switch (deathFx) {
            case "tesla":
                zombz[m] thread tesla_play_death_fx();
                zombz[m] doDamage(zombz[m].health + 666, zombz[m].origin, undefined, undefined, "riflebullet");
                break;
            case "headGib":
                zombz[m] thread maps\_zombiemode_spawner::zombie_head_gib();
                zombz[m] doDamage(zombz[m].health + 666, zombz[m].origin, undefined, undefined, "riflebullet");
                break;
            case "flame":
                zombz[m] thread animscripts\zombie_death::flame_death_fx();
                zombz[m] doDamage(zombz[m].health + 666, zombz[m].origin, undefined, undefined, "riflebullet");
                break;
            case "delete":
                zombz[m] delete();
                break;
            default:
                zombz[m] doDamage(zombz[m].health + 666, zombz[m].origin, undefined, undefined, "riflebullet");
                break;
        }
    }
}
tesla_play_death_fx() {
    tag = "J_SpineUpper";
    if (self.type == "dog") tag = "J_Spine1";
    fx = strTok("tesla_shock;tesla_shock_secondary", ";");
    playFxOnTag(level._effect[fx[randomInt(fx.size)]], self, tag);
    self playSound("imp_tesla");
    if (self.type != "dog") {
        if (randomInt(100) < level.zombie_vars["tesla_head_gib_chance"]) {
            wait(randomFloat(.53, 1));
            self maps\_zombiemode_spawner::zombie_head_gib();
        } else playFxOnTag(level._effect["tesla_shock_eyes"], self, "J_Eyeball_LE");
    }
}

//Projectiles

clusterGrenades() {
    if (!isDefined(self.clusterNadez)) {
        self.clusterNadez = true;
        self iPrintLn("Cluster Grenades [^2ON^7]");
        self thread watchForGrenades();
    } else {
        self.clusterNadez = undefined;
        self iPrintLn("Cluster Grenades [^1OFF^7]");
        self notify("clusterGrenades_over");
    }
}
watchForGrenades() {
    self endon("death");
    self endon("disconnect");
    self endon("clusterGrenades_over");
    for (;;) {
        self waittill("grenade_fire", grenade, name);
        grenade thread createClusterGrenade(name);
    }
}
createClusterGrenade(type) {
    prevorigin = self.origin;
    while (1) {
        if (!isdefined(self)) break;
        prevorigin = self.origin;
        wait .1;
    }
    prevorigin += (0, 0, 5);
    numSecondaries = 8;
    aiarray = getaiarray();
    if (aiarray.size == 0) return;
    ai = undefined;
    for (i = 0; i < aiarray.size; i++) {
        if (aiarray[i].team == "allies") {
            ai = aiarray[i];
            break;
        }
    }
    if (!isdefined(ai)) ai = aiarray[0];
    oldweapon = ai.grenadeweapon;
    ai.grenadeweapon = type;
    for (i = 0; i < numSecondaries; i++) {
        velocity = getClusterGrenadeVelocity();
        timer = 1.5 + i / 6 + randomfloat(0.1);
        ai magicGrenadeManual(prevorigin, velocity, timer);
    }
    ai.grenadeweapon = oldweapon;
}
getClusterGrenadeVelocity() {
    yaw = randomFloat(360);
    pitch = randomFloatRange(65, 85);
    amntz = sin(pitch);
    cosPitch = cos(pitch);
    amntx = cos(yaw) * cosPitch;
    amnty = sin(yaw) * cosPitch;
    speed = randomFloatRange(400, 600);
    velocity = (amntx, amnty, amntz) * speed;
    return velocity;
}
deleteTextAfterTime(time) {
    wait(time);
    self destroy();
}
gerschDevice() {
    self endon("death");
    self endon("disconnect");
    self endon("Gersh_Device");
    self.POKE_Skull Delete();
    self.StalkingZombies = 0;
    self notify("EndPokemon");
    self notify("T_Knives_Off");
    self.teleNades = undefined;
    self notify("teleportNades_over");
    self notify("Thunder_Nades");
    self.nukeNades = undefined;
    self notify("nukeNades_over");
    self.has_thunderNades = undefined;
    if (isDefined(self.has_gersch)) return;
    nades = 4;
    txt = self createText(getFont(), 1, "TOPRIGHT", "TOPRIGHT", -20, 20, 1, 1, nades + " Gersch Devices Left");
    txt thread deleteTextAfterTime(1);
    self giveWeapon("frag_grenade_zm", 4);
    self.has_gersch = true;
    for (;;) {
        self waittill("grenade_fire", grenade, weapName);
        if ((isSubStr(weapName, "granate") || isSubStr(weapName, "frag")) && !isDefined(grenade.gersch_device)) {
            grenade.gersch_device = true;
            nades--;
            string = nades + " Gersch Devices Left";
            if (nades == 1) string = nades + " Gersch Device Left";
            txt = self createText(getFont(), 1, "TOPRIGHT", "TOPRIGHT", -20, 20, 1, 1, string);
            txt thread deleteTextAfterTime(1);
            grenade hide();
            grenade.gersch = spawnSM(grenade.origin, "static_berlin_ger_radio", grenade.angles);
            grenade.gersch linkTo(grenade);
            self thread gerschDevice_init(grenade);
            if (nades <= 0) break;
        }
    }
    self.has_gersch = undefined;
}
gerschDevice_init(grenade, pos) {
    for (;;) {
        grenade resetMissileDetonationTime();
        pos = grenade getOrigin();
        wait .05;
        if (pos == grenade getOrigin()) break;
    }
    wait 0.6;
    grenade delete();
    grenade.gersch delete();
    if (isDefined(pos))
        if (distance(pos, level.eggLever.origin) < 100) level notify("leverCaptured");
    earthquake(.5, 1, pos, 90);
    fx = spawnSM(pos, "tag_origin", (-90, 0, 0));
    playFxOnTag(level._effect["zombie_flashback_american"], fx, "tag_origin");
    gersh = spawnSM(pos, "tag_origin");
    gersh createEnemyPointOfInterest(2000, 1);
    gersh thread create_teleportPoint();
    gersh thread gerschFunction();
    tok = strTok("pad_warmup;explo_shockwave_l;electrical_surge;spawn;bolt", ";");
    for (m = 0; m < 15; m++) {
        playFx(level._effect["lightning_dog_spawn"], gersh.origin);
        playFx(loadFx("misc/fx_zombie_couch_effect"), gersh.origin);
        for (e = 0; e < tok.size; e++) playSoundAtPosition(tok[e], gersh.origin);
        wait 1;
    }
    gersh notify("gersh_over");
    fx delete();
    gersh delete();
}
createEnemyPointOfInterest(attract_dist, num_attractors, added_poi_value, start_turned_on) {
    if (!isDefined(added_poi_value)) self.added_poi_value = 0;
    else self.added_poi_value = added_poi_value;
    if (!isDefined(start_turned_on)) start_turned_on = true;
    self.script_noteworthy = "zombie_poi";
    self.poi_active = start_turned_on;
    if (isDefined(attract_dist)) self.poi_radius = attract_dist * attract_dist;
    else self.poi_radius = undefined;
    self.num_poi_attracts = num_attractors;
    self.attract_to_origin = true;
}
create_teleportPoint() {
    self endon("gersh_over");
    for (;;) {
        wait .05;
        plr = getPlayers();
        for (m = 0; m < plr.size; m++) {
            user = plr[m];
            if (distance(self.origin, user.origin) < 80) {
                loc = getDogSpawns()[randomInt(getDogSpawns().size)];
                playFx(loadFx("maps/zombie/fx_transporter_beam"), self.origin);
                user setOrigin(loc);
                user playLocalSound("teleport_2d_fnt");
                user thread[[level.teleport_ae_funcs[randomInt(level.teleport_ae_funcs.size)]]]();
                playFx(loadFx("maps/zombie/fx_transporter_beam"), self.origin);
            }
        }
    }
}
gerschFunction() {
    self endon("gersh_over");
    for (;;) {
        wait .05;
        zombz = getAiSpeciesArray("axis", "all");
        for (m = 0; m < zombz.size; m++) zombz[m] forceTeleport(zombz[m].origin, vectorToAngles((zombz[m].origin) - (self.origin)));
        self thread killZombiesWithinDistance(self.origin, 100, "tesla");
    }
}

teleportGrenades() {
    if (!isDefined(self.teleNades)) {
        self.teleNades = true;
        self.POKE_Skull Delete();
        self.StalkingZombies = 0;
        self notify("EndPokemon");
        self notify("T_Knives_Off");
        self notify("Thunder_Nades");
        self.has_thunderNades = undefined;
        self notify("Gersh_Device");
        self.has_gersch = undefined;
        self.nukeNades = undefined;
        self notify("nukeNades_over");
        self iPrintln("Teleporting Grenades [^2ON^7]");
        self thread doTeleportGrenades();
    } else {
        self.teleNades = undefined;
        self iPrintln("Teleporting Grenades [^1OFF^7]");
        self notify("teleportNades_over");
    }
}
doTeleportGrenades() {
    self endon("death");
    self endon("disconnect");
    self endon("teleportNades_over");
    for (;;) {
        self waittill("grenade_fire", grenade, weapName);
        if (isSubStr(weapName, "granate") || isSubStr(weapName, "frag")) grenade thread init_teleportPlayers();
    }
}
init_teleportPlayers(pos) {
    while (isDefined(self)) {
        pos = self getOrigin();
        wait .05;
    }
    plr = getPlayers();
    for (m = 0; m < plr.size; m++) {
        user = plr[m];
        if (distance(pos, user.origin) < 100) {
            loc = getDogSpawns()[randomInt(getDogSpawns().size)];
            playFx(loadFx("maps/zombie/fx_transporter_beam"), pos);
            user setOrigin(loc);
            user playLocalSound("teleport_2d_fnt");
            user thread[[level.teleport_ae_funcs[randomInt(level.teleport_ae_funcs.size)]]]();
            playFx(loadFx("maps/zombie/fx_transporter_beam"), user.origin);
        }
    }
}
nukeNades() {
    if (!isDefined(self.nukeNades)) {
        self.nukeNades = true;
        self.POKE_Skull Delete();
        self.StalkingZombies = 0;
        self notify("EndPokemon");
        self notify("T_Knives_Off");
        self.teleNades = undefined;
        self notify("teleportNades_over");
        self notify("Thunder_Nades");
        self.has_thunderNades = undefined;
        self notify("Gersh_Device");
        self.has_gersch = undefined;
        self iPrintLn("Nuke Nades [^2ON^7]");
        self thread doNukeNades();
    } else {
        self.nukeNades = undefined;
        self iPrintLn("Nuke Nades [^1OFF^7]");
        self notify("nukeNades_over");
    }
}
doNukeNades() {
    self endon("disconnect");
    self endon("death");
    self endon("nukeNades_over");
    for (;;) {
        self waittill("grenade_fire", grenade, name);
        if (isSubStr(name, "frag") || isSubStr(name, "granate")) {
            grenade hide();
            grenadeNuke = spawnSM(grenade.origin, "zombie_bomb", grenade.angles + (0, 0, 40));
            playFxOnTag(loadFx("misc/fx_zombie_powerup_on"), grenadeNuke, "tag_origin");
            grenadeNuke linkTo(grenade);
            grenade thread nadeXplosion(grenadeNuke);
        }
    }
}
nadeXplosion(nuke) {
    wait .1;
    for (;;) {
        self resetMissileDetonationTime();
        origin1 = self getOrigin();
        wait .05;
        origin2 = self getOrigin();
        if (origin1 == origin2) break;
    }
    origin = self.origin;
    playFx(level._effect["lightning_dog_spawn"], origin);
    playSoundAtPosition("pre_spawn", origin);
    playSoundAtPosition("bolt", origin);
    wait 1.5;
    nuke delete();
    self detonate();
    playSoundAtPosition("nuke_flash", origin);
    playFx(loadFx("misc/fx_zombie_mini_nuke"), origin + (0, 0, 30));
    playFx(level._effect["powerup_grabbed"], origin);
    playFx(level._effect["powerup_grabbed_wave"], origin);
}
Pokemon2(Equipment) {
    self endon("disconnect");
    self endon("EndPokemon");
    self.teleNades = undefined;
    self notify("teleportNades_over");
    self notify("Thunder_Nades");
    self.has_thunderNades = undefined;
    self notify("Gersh_Device");
    self.has_gersch = undefined;
    self.nukeNades = undefined;
    self notify("nukeNades_over");
    self notify("NukesOff");
    self notify("EndAllx");
    self notify("T_Knives_Off");
    if (level.strategy == 0) {
        self iPrintln("Equipment Updated to ^2" + Equipment + "");
    }
    if (self.StalkingZombies == 0) {
        self iPrintlnBold("^1Currently Hunting Pokemon");
        self.StalkingZombies = 1;
        self.PokemonCaught = false;
        self waittill("grenade_fire", GrenadeWeapon);
        self.POKE_Skull = spawn("script_model", GrenadeWeapon.origin);
        self.POKE_Skull setModel("zombie_skull");
        self.POKE_Skull linkTo(GrenadeWeapon);
        self thread PokeballOnFloor(GrenadeWeapon);
        self iPrintlnBold("And now We Wait...");
        self waittill("on_the_floor");
        while (1) {
            Poke = getAiSpeciesArray("axis", "all");
            for (i = 0; i < Poke.size; i++) {
                if (distance(GrenadeWeapon.origin, Poke[i].origin) < 100) {
                    self.PokemonCaught = true;
                    playFx(level._effect["zombie_mainframe_link_all"], GrenadeWeapon.origin);
                    self iPrintlnBold("Yes I Caught A Wild Zombie");
                    Poke[i] forceTeleport(GrenadeWeapon.origin);
                    wait 1;
                    Poke[i] forceTeleport((1639.11, -670.561, 138.125));
                    wait 1;
                    Poke[i] attach("char_ger_waffen_officercap1_zomb", "j_head", true);
                    Poke[i].team = "allies";
                    GrenadeWeapon delete();
                    self.POKE_Skull Delete();
                    self.POKE_Skull unlink();
                    self waittill("grenade_fire", GrenadeWeapon);
                    self.POKE_Skull = spawn("script_model", GrenadeWeapon.origin);
                    self.POKE_Skull setModel("zombie_skull");
                    self.POKE_Skull linkTo(GrenadeWeapon);
                    wait 1;
                    for (;;) {
                        if (GrenadeWeapon.getVelocity[0] == 0 && GrenadeWeapon.getVelocity[1] == 0 && GrenadeWeapon.getVelocity[2] == 0) {
                            Poke[i] forceTeleport(GrenadeWeapon.origin);
                            playFx(level._effect["zombie_mainframe_link_all"], GrenadeWeapon.origin);
                            self iPrintlnBold("Go Zombie,I Chose YOU!");
                            wait 1;
                            GrenadeWeapon delete();
                            self.POKE_Skull Delete();
                            self.StalkingZombies = 0;
                            self notify("EndPokemon");
                        }
                        wait .1;
                    }
                }
            }
            wait .1;
        }
    } else {
        self iPrintlnBold("Already Hunting Pokemon");
    }
}
PokeballOnFloor(Gren) {
    self endon("disconnect");
    self endon("EndPokemon");
    for (;;) {
        if (Gren.getVelocity[0] == 0 && Gren.getVelocity[1] == 0 && Gren.getVelocity[2] == 0) {
            self notify("on_the_floor");
            if (self.PokemonCaught == false) {
                Gren resetmissiledetonationtime();
                wait 1.5;
            } else {
                break;
            }
        }
        wait .01;
    }
}
throwingknifes2(Equipment) {
    self.teleNades = undefined;
    self.POKE_Skull Delete();
    self.StalkingZombies = 0;
    self notify("EndPokemon");
    self notify("teleportNades_over");
    self notify("Thunder_Nades");
    self.has_thunderNades = undefined;
    self notify("Gersh_Device");
    self.has_gersch = undefined;
    self.nukeNades = undefined;
    self notify("nukeNades_over");
    self notify("NukesOff");
    self notify("EndAllx");
    self notify("NukesOff");
    self.taco = 1;
    self thread waitforfrag();
    self thread UnlimKnives();
    if (level.strategy == 0) {
        self iPrintln("Equipment Updated to ^2" + Equipment + "");
    }
}
UnlimKnives() {
    self endon("disconnect");
    self endon("T_Knives_Off");
    for (;;) {
        self giveMaxAmmo("frag_grenade_zm");
        self setWeaponAmmoClip("frag_grenade_zm", 4);
        wait 1;
    }
}
Throwing_Knife() {
    ent = self getEntityNumber();
    self waittill("grenade_fire", grenadeWeapon);
    grenadeWeapon hide();
    ThrowingKnife = spawn("script_model", grenadeWeapon.origin);
    ThrowingKnife setModel("weapon_usa_kbar_knife");
    ThrowingKnife linkTo(grenadeWeapon);
    grenadeWeapon thread MonitorKnife(ent);
    grenadeWeapon thread rotateKnife(ent);
    grenadeWeapon thread OnFloor(ent);
    grenadeWeapon resetMissileDetonationTime();
    self waittill("deleteKnife");
    self notify("knife_monitor_done");
    grenadeWeapon delete();
    ThrowingKnife delete();
}
OnFloor(ent) {
    self endon("ondafloor");
    for (;;) {
        if (self.getVelocity[0] == 0 && self.getVelocity[1] == 0 && self.getVelocity[2] == 0) {
            wait .5;
            getPlayers()[ent] notify("deleteKnife");
            self notify("ondafloor");
            wait 50;
        }
        wait .05;
    }
}
rotateKnife(ent) {
    getPlayers()[ent] endon("knife_monitor_done");
    for (;;) {
        self rotateRoll(360, .3);
        wait .4;
    }
}
MonitorKnife(ent) {
    getPlayers()[ent] endon("knife_monitor_done");
    self endon("hit");
    victim = getAiArray("axis");
    for (;;) {
        wait .05;
        for (s = 0; s < victim.size; s++) {
            if (self isTouching(victim[s])) {
                victim[s] thread TKHit(ent, self.origin);
                self notify("hit");
                wait 15;
            }
        }
    }
}
TKHit(ent, gash) {
    getPlayers()[ent].score += 100;
    getPlayers()[ent].score_total += 100;
    playFx(level._effect["headshot"], gash);
    getPlayers()[ent] notify("deleteKnife");
    self doDamage(self.health + 999, getPlayers()[ent].origin, undefined, undefined, "riflebullet");
}
waitforfrag() {
    self endon("disconnect");
    self endon("T_Knives_Off");
    for (;;) {
        if (self fragbuttonpressed()) {
            self thread Throwing_Knife();
            wait .05;
            self setClientDvar("cg_drawGun", "0");
        }
        wait .05;
        self setClientDvar("cg_drawGun", "1");
    }
}
TglGren() {
    self endon("death");
    self endon("disconnect");
    self notify("fx_gren");
    self notify("EndAll");
    self notify("EndAllx");
    self notify("Done");
    level.trigz delete();
    level.trigz destroy();
    if (self.PowerGrenUps == false) {
        self.PowerGrenUps = true;
        self thread SpawnGrenPowers();
        self iPrintln("Spawn Power-Ups [^2ON^7]");
    } else {
        self.PowerGrenUps = false;
        self notify("SpawnGPsOff");
        self iPrintln("Spawn Power-Ups [^1OFF^7]");
    }
}
SpawnGrenPowers() {
    self endon("SpawnGPsOff");
    self endon("EndAll");
    for (;;) {
        self waittill("grenade_fire", GrenadeWeapon);
        self thread GrenadeOriginFollowx(GrenadeWeapon);
        GrenadeWeapon waittill("explode");
        level.zombie_devgui_power = 1;
        level.zombie_vars["zombie_drop_item"] = 1;
        level.powerup_drop_count = 0;
        level thread maps\_zombiemode_powerups::powerup_drop(self.GrenFX);
        wait .1;
    }
}
GrenadeOriginFollowx(Gren) {
    self endon("EndAll");
    Gren endon("explode");
    for (;;) {
        self.GrenFX = Gren.origin;
        wait .01;
    }
}
GrenFxOff() {
    self notify("fx_gren");
    self notify("SpawnGPsOff");
    self.PowerGrenUps = 0;
    self notify("EndAll");
    self notify("EndAllx");
    self notify("Done");
    level.trigz delete();
    level.trigz destroy();
    self notify("SpawnPerkPsOffx");
    self iPrintln("Grenade Fx [^1OFF^7]");
}
NukeGren() {
    self thread GrenFX(LoadFx("misc/fx_zombie_mini_nuke"), "Nuke");
}
PowerUpGren() {
    self thread GrenFX(level._effect["powerup_grabbed"], "Power Up Grabbed");
}
FireGren() {
    self thread GrenFX(LoadFx("env/fire/fx_fire_player_torso"), "Fire");
}
TeleBeamGren() {
    self thread GrenFX(LoadFx("maps/zombie/fx_transporter_beam"), "Teleporter Beam");
}
DogGibGren() {
    self thread GrenFX(LoadFx("maps/zombie/fx_zombie_dog_explosion"), "Dog Gib");
}
DogSpwnGren() {
    self thread GrenFX(LoadFx("maps/zombie/fx_zombie_dog_lightning_buildup"), "Dog Spawn");
}
CeilDustGren() {
    self thread GrenFX(LoadFx("env/dirt/fx_dust_ceiling_impact_lg_mdbrown"), "Ceiling Dust");
}
SteamGren() {
    self thread GrenFX(LoadFx("maps/zombie/fx_zombie_mainframe_steam"), "Mainframe Steam");
}
AC130Gren() {
    self thread GrenFX(LoadFx("explosions/default_explosion"), "AC-130");
}
TorsoGren() {
    self thread GrenFX(LoadFx("env/electrical/fx_elec_player_sm"), "Electric Torso");
}
ZombRiseGren() {
    self thread GrenFX(LoadFx("maps/mp_maps/fx_mp_zombie_hand_dirt_burst"), "Zombie Rise");
}
PadStartGren() {
    self thread GrenFX(LoadFx("maps/zombie/fx_transporter_pad_start"), "Transporter Pad Start");
}
LinkAllGren() {
    self thread GrenFX(level._effect["zombie_mainframe_link_all"], "Teleporter Link All");
}
GrenFX(fx, text) {
    self endon("death");
    self endon("disconnect");
    self endon("EndAll");
    self notify("fx_gren");
    self endon("fx_gren");
    self notify("SpawnGPsOff");
    self notify("EndAllx");
    self notify("Done");
    level.trigz delete();
    level.trigz destroy();
    self iPrintln("^2" + text + " ^7Grenades Set");
    for (;;) {
        self waittill("grenade_fire", GrenadeWeapon);
        self thread GrenadeOriginFollowx(GrenadeWeapon);
        GrenadeWeapon waittill("explode");
        playFx(fx, self.GrenFX);
    }
}

NoBFX() {
    self notify("EndUppy");
    self iPrintln("All Gun Mods [^1OFF^7]");
}
PansMod() {
    self thread ChangeofGun("panzerschrek_zombie", "Pansershreks");
}
UpColtMod() {
    self thread ChangeofGun("colt_dirty_harry", "Upgraded Colt");
}
MagMod() {
    self thread ChangeofGun("zombie_sw_357", "Magnum");
}
PTMod() {
    self thread ChangeofGun("ptrs41_zombie", "PTRS -41");
}
BARMod() {
    self thread ChangeofGun("zombie_bar", "BAR");
}
DBLMod() {
    self thread ChangeofGun("zombie_doublebarrel", "Double Barrel");
}
MP40Mod() {
    self thread ChangeofGun("mp40_zm", "MP40");
}
PPSHMod() {
    self thread ChangeofGun("mp40_zm", "PPSH-44");
}
TOMMYMod() {
    self thread ChangeofGun("zombie_thompson", "Thompson");
}
TGMod() {
    self thread ChangeofGun("zombie_shotgun", "Trench Gun");
}
BrownMod() {
    self thread ChangeofGun("zombie_30cal", "Browning");
}
MG42Mod() {
    self thread ChangeofGun("zombie_mg42", "MG42");
}
Stg44Mod() {
    self thread ChangeofGun("zombie_stg44", "Stg-44");
}
ChangeofGun(shot, text) {
    self notify("EndUppy");
    self endon("death");
    self endon("disconnect");
    self endon("EndUppy");
    self iPrintln("Weapon Now Firing ^2" + text);
    for (;;) {
        self waittill("weapon_fired");
        forward = self getTagOrigin("tag_weapon_right");
        end = self thread vector_Scal(anglesToForward(self getPlayerAngles()), 1000000);
        location = bulletTrace(forward, end, 0, self)["position"];
        magicBullet(shot, forward, location, self);
        wait .1;
    }
}

shootPowerups() {
    self notify("SpawnPerkPsOff");
    if (!isDefined(self.shootPowerUps)) {
        self.shootPowerUps = true;
        self.PerkPower = false;
        self iPrintln("Shoot Power-Ups [^2ON^7]");
        self thread _shootPowerups();
    } else {
        self.shootPowerUps = undefined;
        self iPrintln("Shoot Power-Ups [^1OFF^7]");
        self notify("shootPowerUps_over");
    }
}
_shootPowerups() {
    self endon("death");
    self endon("disconnect");
    self endon("shootPowerUps_over");
    for (;;) {
        self waittill("weapon_fired");
        level.zombie_vars["zombie_drop_item"] = true;
        level.powerup_drop_count = false;
        self thread maps\_zombiemode_powerups::powerup_drop(self lookPos());
    }
}

Tgl_PerkPowers() {
    self notify("shootPowerUps_over");
    if (self.PerkPower == false) {
        self.PerkPower = true;
        self.shootPowerUps = undefined;
        self thread SpawnPerkPowers();
        self iPrintln("Spawn Perk Power-Ups [^2ON^7]");
    } else {
        self.PerkPower = false;
        self notify("SpawnPerkPsOff");
        self iPrintln("Spawn Perk Power-Ups [^1OFF^7]");
    }
}
SpawnPerkPowers() {
    self endon("death");
    self endon("disconnect");
    self endon("SpawnPerkPsOff");
    for (;;) {
        self waittill("weapon_fired");
        eye = self getEye();
        vec = anglesToForward(self getPlayerAngles());
        end = (vec[0] * 100000000, vec[1] * 100000000, vec[2] * 100000000);
        Location = bulletTrace(eye, end, 0, self)["position"];
        self thread DropPoint(Location);
        wait 5;
    }
}
DropPoint(drop_point) {
    PowerUp = spawn("script_model", drop_point + (0, 0, 40));
    Playable_Area = getEntArray("playable_area", "targetname");
    valid_drop = false;
    for (i = 0; i < Playable_Area.size; i++) {
        if (PowerUp isTouching(Playable_Area[i])) {
            valid_drop = true;
            break;
        }
    }
    if (!valid_drop) {
        PowerUp delete();
        return;
    }
    PowerUp thread TehPowerDrop();
}
TehPowerDrop() {
    PerkModels = strTok("zombie_3rd_perk_bottle_jugg|zombie_3rd_perk_bottle_revive|zombie_3rd_perk_bottle_sleight|zombie_3rd_perk_bottle_doubletap", "|");
    PerkSounds = strTok("mx_jugger_sting|mx_revive_sting|mx_speed_sting|mx_doubletap_sting", "|");
    PerkPerks = strTok("specialty_armorvest|specialty_quickrevive|specialty_fastreload|specialty_rof|specialty_bulletdamage|specialty_bulletpenetration|specialty_holdbreath|specialty_quieter|specialty_flak_jacket|specialty_bulletaccuracy|specialty_longersprint", "|");
    PerkBottles = strTok("zombie_perk_bottle_jugg|zombie_perk_bottle_revive|zombie_perk_bottle_sleight|zombie_perk_bottle_doubletap", "|");
    RandomPerk = randomInt(PerkBottles.size);
    self setModel(PerkModels[RandomPerk]);
    playSoundAtPosition("spawn_powerup", self.origin);
    self playLoopSound("spawn_powerup_loop");
    self thread maps\_zombiemode_powerups::powerup_timeout();
    self thread maps\_zombiemode_powerups::powerup_wobble();
    self thread PowerUp_Grabbed(PerkSounds[RandomPerk], PerkPerks[RandomPerk], PerkBottles[RandomPerk]);
}
PowerUp_Grabbed(Sound, Perk, PerkBottle) {
    self endon("powerup_timedout");
    self endon("powerup_grabbed");
    while (IsDefined(self)) {
        P = getPlayers();
        for (i = 0; i < P.size; i++) {
            if (distance(P[i].origin, self.origin) < 64) {
                playFx(loadFx("misc/fx_zombie_powerup_grab"), self.origin);
                playFx(loadFx("misc/fx_zombie_powerup_wave"), self.origin);
                P[i] playLocalSound(Sound);
                P[i] thread purchasePerks();
                wait(0.1);
                playSoundAtPosition("powerup_grabbed", self.origin);
                self stopLoopSound();
                self delete();
                self notify("powerup_grabbed");
            }
        }
        wait 0.1;
    }
}

bulletFxOver() {
    self notify("bulletFx_over");
}
bulletFx(fx) {
    self notify("bulletFx_over");
    self endon("death");
    self endon("disconnect");
    self endon("bulletFx_over");
    for (;;) {
        self waittill("weapon_fired");
        earthquake(.5, 1, self.origin, 90);
        loc = self lookPos();
        radiusDamage(loc, 150, 300, 100, self);
        earthquake(1.5, 1, loc, 90);
        playFx(loadFx(fx), loc);
    }
}

//Vip Modifications

setCrosshairUi(crosshair) {
    if (self.FxOn == 1) {
        self.customCrosshairUi destroy();
        self notify("customCrosshair_over");
    }
    self.Chross_Hair = crosshair;
    self.customCrosshairUi setText(self.Chross_Hair);
}
customCrosshair(crosshair) {
    if (!isDefined(self.customCrosshair)) {
        if (self.FxOn == 1) {
            self thread setCrosshair(crosshair);
            self.customCrosshairUi destroy();
            self iPrintLn("Custom Crosshair [^2ON^7]");
            self.customCrosshair = true;
        } else {
            if (self.FxOn == 0) {
                self thread setCrosshair(crosshair);
                self setClientDvar("cg_drawCrosshair", 0);
                self iPrintLn("Custom Crosshair [^2ON^7]");
                self.customCrosshair = true;
            }
        }
    } else {
        self notify("customCrosshair_over");
        self.customCrosshairUi destroy();
        if (self.FxOn == 1 && isDefined(self.menu["misc"]["inMenu"])) self setClientDvar("cg_drawCrosshair", 0);
        else self setClientDvar("cg_drawCrosshair", 1);
        self iPrintLn("Custom Crosshair [^1OFF^7]");
        self.customCrosshair = undefined;
    }
}
setCrosshair(crosshair) {
    self endon("death");
    self endon("disconnect");
    self endon("customCrosshair_over");
    if (isDefined(self.customCrosshairUi)) {
        self setCrosshairUi(crosshair);
        return;
    } else {
        self.Chross_Hair = crosshair;
        self.customCrosshairUi = self createText(getFont(), 2, "CENTER", "CENTER", 0, 0, 1, 1, self.Chross_Hair);
        for (;;) {
            self.customCrosshairUi fadeOverTime(1);
            self.customCrosshairUi.color = (randomInt(255) / 255, randomInt(255) / 255, randomInt(255) / 255);
            wait 1;
        }
    }
}
flyableUfo() {
    self endon("disconnect");
    self endon("death");
    curs = self getCurs();
    self lockMenu();
    self enableInvulnerability();
    savedGodmode = self isGodMode();
    savedOrigin = self getOrigin();
    self setClientDvar("cg_thirdPerson", 1);
    self setClientDvar("cg_thirdPersonRange", 500);
    self setClientDvar("ui_hud_hardcore", 1);
    self setClientDvar("cg_drawCrosshair", 0);
    ufo = [];
    ufo["top"] = spawnSM((self.origin[0], self.origin[1], 800), "zombie_teleporter_pad");
    ufo["bottom"] = spawnSM((self.origin[0], self.origin[1], 800), "zombie_teleporter_pad", (0, 0, -180));
    ufo["fx"] = spawnSM((self.origin[0], self.origin[1], 800), "tag_origin", (-270, 0, 0));
    ufo["bottom"] linkTo(ufo["top"]);
    ufo["fx"] linkTo(ufo["top"]);
    ufo["top"] thread ufoAngles(self);
    self playerLinkTo(ufo["top"]);
    playFxOnTag(loadFx("maps/zombie/fx_zombie_factory_marker"), ufo["fx"], "tag_origin");
    playFxOnTag(loadFx("maps/mp_maps/fx_mp_light_lamp"), ufo["fx"], "tag_origin");
    self hide();
    self enableGodMode();
    self setVision("fly_dark");
    self disableWeapons();
    self disableOffHandWeapons();
    self.justShot = undefined;
    self setInstructions("[{+speed_throw}]: Navigate Ufo - [{+attack}]: Shoot - [{+activate}]: Drop Bomb - [{+melee}]: Exit Ufo");
    wait .3;
    for (;;) {
        if (self adsButtonPressed()) {
            vec = anglesToForward(self getPlayerAngles());
            end = (vec[0] * (50 * .7), vec[1] * (50 * .7), 0);
            ufo["top"] moveTo(ufo["top"].origin + end, .1);
        }
        if (self attackButtonPressed()) {
            if (!isDefined(self.justShot)) {
                self.justShot = true;
                self thread ufoShoot(ufo["top"]);
            }
        }
        if (self useButtonPressed()) {
            if (!isDefined(self.justShotNuke)) {
                self.justShotNuke = true;
                self thread ufoNuke();
            }
        }
        if (self meleeButtonPressed()) {
            self notify("menu_open", "vip", curs);
            break;
        }
        wait .05;
    }
    keys = getArrayKeys(ufo);
    for (m = 0; m < keys.size; m++) ufo[keys[m]] delete();
    self setOrigin(savedOrigin);
    self enableWeapons();
    self enableOffHandWeapons();
    self setClientDvar("cg_thirdPerson", 0);
    self setClientDvar("cg_thirdPersonRange", 120);
    self setClientDvar("ui_hud_hardcore", 0);
    if (!isDefined(self.customCrosshair)) self setClientDvar("cg_drawCrosshair", 1);
    self disableInvulnerability();
    if (!savedGodmode) self disableGodMode();
    else if (savedGodmode) self enableGodMode();
    self show();
    self setVision("default");
    self.justShot = undefined;
    self resetInstructions();
    self unlockMenu();
}
ufoAngles(who) {
    while (isDefined(self)) {
        who takeWeapon("frag_grenade_zm");
        self rotateTo(who getPlayerAngles(), .1);
        wait .05;
    }
}
ufoShoot(ufo) {
    self endon("disconnect");
    self endon("death");
    for (m = 0; m < 5; m++) {
        orb = spawnSM(ufo.origin, "tag_origin");
        playFxOnTag(loadFx("misc/fx_zombie_powerup_on"), orb, "tag_origin");
        playSoundAtPosition("weap_rgun_fire", ufo.origin);
        orb moveTo(self lookPos(), .4);
        orb thread impactSound("grenade_explode");
        wait .1;
    }
    self.justShot = undefined;
}
ufoNuke() {
    self endon("disconnect");
    self endon("death");
    nuke = spawnSM(self.origin - (0, 0, 10), "zombie_bomb", (90, 0, 0));
    playSoundAtPosition("weap_pnzr_fire", nuke.origin);
    newLocation = physicsTrace(nuke.origin, (nuke.origin[0], nuke.origin[1], -2000));
    if (level.modmenulobby != true) nuke moveTo(newLocation - (0, 0, 120), .4, .2);
    if (level.modmenulobby == true) nuke moveTo(newLocation, .4, .2);
    wait .4;
    playFx(loadFx("misc/fx_zombie_mini_nuke"), nuke.origin);
    playFx(loadFx("misc/fx_zombie_mini_nuke_hotness"), nuke.origin);
    playSoundAtPosition("nuke_flash", nuke.origin);
    playSoundAtPosition("nuked", nuke.origin);
    killZombiesWithinDistance(nuke.origin, 200, "flame");
    doPlayerDamage(nuke.origin - (0, 0, 100), 200);
    earthQuake(1, 1, self.origin, 100);
    nuke delete();
    self.justShotNuke = true;
    wait 1;
    self.justShotNuke = undefined;
}
impactSound(sound) {
    self waittill("movedone");
    playSoundAtPosition(sound, self.origin);
    playFx(loadFx("misc/fx_zombie_powerup_grab"), self.origin);
    playFx(loadFx("misc/fx_zombie_powerup_wave"), self.origin);
    killZombiesWithinDistance(self.origin, 150, "tesla");
    doPlayerDamage(self.origin, 150);
    earthQuake(.4, 1, self.origin, 100);
    self delete();
}
doPlayerDamage(orig, dist) {
    for (e = 0; e < getPlayers().size; e++)
        if (distance(getPlayers()[e].origin, orig) <= dist) {
            if (!getPlayers()[e] hasPerk("specialty_armorvest") || getPlayers()[e].health - 100 < 1) radiusDamage(getPlayers()[e].origin, 10, getPlayers()[e].health + 100, getPlayers()[e].health + 100);
            else getPlayers()[e] doDamage(50, getPlayers()[e].origin);
        }
}
UFOToggle() {
    if (self.UFOZ == false) {
        self.UFOZ = true;
        self thread UFO2();
        self iprintln("^7UFO [^2ON^7]");
    } else if (self.UFOZ == true) {
        self.UFOZ = false;
        self thread UfoKill();
        self iprintln("^7UFO [^1OFF^7]");
    }
}
UFO2() {
    self endon("disconnect");
    self endon("UFOdone");
    self.UFO = spawn("script_model", (-960, 1365.8, 682));
    self.UFO setModel("zombie_teleporter_pad");
    self.UFO.angles = (0, 0, 0);
    self.UFO2 = spawn("script_model", (-960, 1365.8, 682));
    self.UFO2 setModel("zombie_teleporter_pad");
    self.UFO2.angles = (-180, 0, 0);
    self.UFOL = spawn("script_model", (-960, 1365.8, 682));
    self.UFOL setModel("tag_origin");
    self.UFOL.angles = (-270, 0, 0);
    self.UFOL linkTo(self.UFO2);
    self.UFO moveTo(self.origin + (0, 0, 750), .3);
    self.UFO2 moveTo(self.origin + (0, 0, 750), .3);
    playFxOnTag(loadFx("maps/zombie/fx_zombie_factory_marker"), self.UFOL, "tag_origin");
    playFxOnTag(level._effect["mp_light_lamp"], self.UFOL, "tag_origin");
    wait 2;
    self.UFO thread Think4(self);
    self.UFO2 thread Think4(self);
    self endon("UFOdone");
    for (;;) {
        self.UFO rotateYaw(360, .49);
        self.UFO2 rotateYaw(360, .49);
        wait .5;
    }
}
Think4(Owner) {
    Owner endon("death");
    Owner endon("disconnect");
    Owner endon("UFOdone");
    for (;;) {
        zom = get_closest_ai(self.origin, "axis");
        self Moveto(zom.origin + (0, 0, 750), 50);
        wait .5;
        self thread Fire4(zom.origin, Owner, zom, self);
        wait .01;
    }
}
Fire4(Target, Owner, zom, EF) {
    Orb = spawn("script_model", self.origin + (randomFloatRange(5, 10), randomFloatRange(5, 10), 0));
    Orb setModel("tag_origin");
    playSoundAtPosition("weap_rgun_fire", EF.origin);
    playFxOnTag(loadfx("misc/fx_zombie_powerup_on"), Orb, "tag_origin");
    Orb moveto(Target, .4);
    wait .2;
    playSoundAtPosition("Grenade_explode", Target);
    killZombiesWithinDistance(Target, 150, "tesla");
    earthquake(0.4, 1, Target, 100);
    playFx(level._effect["misc/fx_zombie_powerup_grab"], Target);
    Orb delete();
    wait 1;
}
UFOkill() {
    self notify("UFOdone");
    self.UFO delete();
    self.UFO2 delete();
    self.UFOL delete();
}
PetPave() {
    if (!isDefined(self.petpave)) {
        self.petpave = true;
        self thread PetPavez();
        self iPrintLn("Pet Pavelow [^2ON^7]");
    } else {
        self.petpave = undefined;
        self thread ppkill();
        self iPrintLn("Pet Pavelow [^1OFF^7]");
    }
}
PetPavez() {
    self endon("pavelow");
    self.Pet = true;
    self.rad = (0, 0, 200);
    self.rad2 = (90, 0, 250);
    self.pet = spawn("script_model", self.origin + self.rad);
    self.pet setmodel("tag_origin");
    self.pet thread Followv(self);
    self.pet thread Thinkv(self);
    self.Spin = spawn("script_model", self.origin + self.rad2);
    self.Spin setmodel("tag_origin1");
    self.Spin thread Followv(self);
    self.car = spawn("script_model", self.origin);
    self.car setModel("defaultvehicle");
    self.car.angles = (self.origin);
    self.car linkTo(self.pet, "tag_origin", (0, 0, 200));
    self.Bladez[1] = spawn("script_model", self.origin + (0, 0, 250));
    self.Bladez[1] SetModel("zombie_teleporter_powerline");
    self.Bladez[1].angles = (90, 0, 90);
    self.Bladez[1] linkTo(self.Spin, "tag_origin1", (0, 0, 250));
    self.Bladez[1] thread FollowMex(self);
    self.Bladez[2] = spawn("script_model", self.Bladez[1].origin);
    self.Bladez[2] SetModel(self.Bladez[1].model);
    self.Bladez[2].angles = (90, 0, -90);
    self.Bladez[2] linkTo(self.Spin, "tag_origin1", (0, 0, 250));
    self.Bladez[2] thread FollowMex(self);
    self.Bladez[3] = spawn("script_model", self.Bladez[1].origin);
    self.Bladez[3] SetModel(self.Bladez[1].model);
    self.Bladez[3].angles = (90, 0, -180);
    self.Bladez[3] linkTo(self.Spin, "tag_origin1", (0, 0, 250));
    self.Bladez[3] thread FollowMex(self);
    self.Bladez[4] = spawn("script_model", self.Bladez[1].origin);
    self.Bladez[4] SetModel(self.Bladez[1].model);
    self.Bladez[4].angles = (90, 0, 0);
    self.Bladez[4] linkTo(self.Spin, "tag_origin1", (0, 0, 250));
    self.Bladez[4] thread FollowMex(self);
    self.Bladez[5] = spawn("script_origin", self.Bladez[1].origin);
    self.Bladez[5] SetModel(self.Bladez[1].model);
    self.Bladez[5].angles = (90, 0, 180);
    self.Bladez[5] linkTo(self.Spin, "tag_origin1", (0, 0, 250));
    self.Bladez[5] thread FollowMex(self);
    for (;;) {
        self.Bladez[1] rotateYaw(360, 2);
        self.Bladez[2] rotateYaw(360, 2);
        self.Bladez[3] rotateYaw(360, 2);
        self.Bladez[4] rotateYaw(360, 2);
        self.Bladez[5] rotateYaw(360, 2);
        wait 1;
    }
}
Followv(Owner) {
    Owner endon("pavelow");
    Owner endon("disconnect");
    Owner endon("death");
    for (;;) {
        if (self.origin != Owner.origin) {
            self moveto(Owner.origin, .5);
        }
        wait .01;
    }
}
Thinkv(Owner) {
    Owner endon("pavelow");
    Owner endon("death");
    Owner endon("disconnect");
    for (;;) {
        zom = get_closest_ai(self.origin, "axis");
        self Moveto(zom.origin + (0, 0, 750), 50);
        wait 2;
        self thread Firezx(zom.origin, Owner, zom, self);
        wait .2;
    }
}
Firezx(Target, Owner, zom, EF) {
    self endon("pavelow");
    Orb = spawn("script_model", self.car.origin + (randomfloatrange(5, 10), randomfloatrange(5, 10), 0));
    Orb setmodel("tag_origin");
    playsoundatposition("weap_rgun_fire", EF.origin);
    playfxOnTag(loadfx("maps/zombie/fx_zombie_wire_spark"), Orb, "tag_origin");
    Orb moveto(Target, .4);
    wait .2;
    playsoundatposition("Grenade_explode", Target);
    radiusDamage(Target, 200, 600, 400);
    earthquake(0.4, 1, Target, 100);
    playfx(level._effect["explosions/fx_mortarExp_dirt"], Target);
    Orb delete();
}
FollowMex(Owner) {
    Owner endon("pavelow");
    Owner endon("disconnect");
    Owner endon("death");
    for (;;) {
        if (self.origin != Owner.origin + (0, 0, 250)) {
            self moveto(Owner.origin + (0, 0, 250), .5);
        }
        wait .01;
    }
}
ppkill() {
    self notify("pavelow");
    self.pet delete();
    self.Spin delete();
    self.car delete();
    self.rad delete();
    self.rad2 delete();
    self.Bladez[1] delete();
    self.Bladez[2] delete();
    self.Bladez[3] delete();
    self.Bladez[4] delete();
    self.Bladez[5] delete();
}
CarePackage() {
    level endon("CareOver");
    self giveWeapon("frag_grenade_zm", 4);
    self lockMenu();
    self iPrintlnBold("Press [{+frag}] To Call Care Package at Grenade");
    self waittill("grenade_fire", GrenadeWeapon);
    self thread GrenadeOriginFollow2(GrenadeWeapon);
    GrenadeWeapon waittill("explode");
    CarePack[0] = spawn("script_model", (-575, 1517, 710));
    CarePack[0] setModel("defaultvehicle");
    TempAngs = vectorToAngles((CarePack[0].origin) - (self.CareGren));
    MoreTempAngs = TempAngs + (0, 180, 0);
    CarePack[0].angles = (CarePack[0].angles[0], MoreTempAngs[1], CarePack[0].angles[2]);
    CarePack[1] = spawn("script_model", CarePack[0].origin + (-17, -3, 60));
    CarePack[1] setModel("zombie_teleporter_powerline");
    CarePack[1].angles = (90, 0, 90);
    CarePack[2] = spawn("script_model", CarePack[1].origin);
    CarePack[2] setModel(CarePack[1].model);
    CarePack[2].angles = (90, 0, -90);
    CarePack[3] = spawn("script_model", CarePack[1].origin);
    CarePack[3] setModel(CarePack[1].model);
    CarePack[3].angles = (90, 0, -180);
    CarePack[4] = spawn("script_model", CarePack[1].origin);
    CarePack[4] setModel(CarePack[1].model);
    CarePack[4].angles = (90, 0, 0);
    CarePack[5] = spawn("script_origin", CarePack[1].origin);
    for (i = 1; i < 5; i++) {
        CarePack[i] linkTo(CarePack[5]);
    }
    CarePack[5] thread Rotate_Model(360, .5);
    CarePack[0] moveTo((self.CareGren[0], self.CareGren[1], CarePack[0].origin[2]), 7, 0, 1.5);
    CarePack[5] moveTo((self.CareGren[0], self.CareGren[1], CarePack[1].origin[2]), 7, 0, 1.5);
    CarePack[5] waittill("movedone");
    if (level.script == "nazi_zombie_sumpf") {
        CareModel = "test_sphere_silver";
    } else {
        CareModel = "static_peleliu_filecabinet_metal";
    }
    CarePack[6] = spawn("script_model", CarePack[5].origin);
    CarePack[6] setModel(CareModel);
    CarePack[6].angles = (0, 0, 90);
    CarePack[7] = spawn("script_model", CarePack[5].origin + (-17, 0, 0));
    CarePack[7] setModel(CarePack[6].model);
    CarePack[7].angles = CarePack[6].angles;
    CarePack[8] = spawn("script_model", CarePack[5].origin + (-8.5, 0, 0));
    for (i = 6; i < 8; i++) {
        CarePack[i] linkTo(CarePack[8]);
    }
    CarePack[8] moveTo(self.CareGren + (0, 0, 13), 2.2, 1.5);
    CarePack[8] waittill("movedone");
    self unlockMenu();
    wait 1;
    Destination = (-1971, -1954, 730);
    TempAngs = vectorToAngles((CarePack[0].origin) - (Destination));
    MoreTempAngs = TempAngs + (0, 180, 0);
    CarePack[0] rotateTo((CarePack[0].angles[0], MoreTempAngs[1], CarePack[0].angles[2]), 2, .5, .5);
    CarePack[0] moveTo(Destination, 7, 1.5);
    CarePack[5] moveTo(Destination, 7, 1.5);
    for (i = 0; i < 6; i++) {
        CarePack[i] thread deleteOverTime();
    }
    TrigOrig = self.CareGren + (0, -29, 0);
    CarePackTrig = Spawn("trigger_radius", TrigOrig, 1, 50, 50);
    CarePackTrig setCursorHint("HINT_NOICON");
    CarePackTrig setHintString("Press &&1 To Take Care Package [^2Power-Up^7]");
    for (;;) {
        CarePackTrig waittill("trigger", i);
        if (i UseButtonPressed() && i.is_zombie == false) {
            i freezeControls(true);
            CarePackageBar = i thread createProgressBar(1.4, "Capturing!", .75, "Captured!");
            wait 1.5;
            i freezeControls(false);
            for (i = 6; i < 9; i++) {
                CarePack[i] delete();
            }
            CarePackTrig delete();
            playFx(level._effect["body_remove"], TrigOrig);
            playFx(loadFx("env/electrical/fx_elec_short_oneshot"), TrigOrig);
            playFx(loadFx("explosions/default_explosion"), TrigOrig);
            level.zombie_powerup_index = randomInt(4);
            level.zombie_vars["zombie_drop_item"] = 1;
            level.powerup_drop_count = 0;
            level thread maps\_zombiemode_powerups::powerup_drop(TrigOrig);
            level notify("CareOver");
        }
    }
}
Rotate_Model(amount, time) {
    for (;;) {
        self rotateYaw(amount, time);
        wait(time);
    }
}
GrenadeOriginFollow2(Gren) {
    Gren endon("explode");
    for (;;) {
        self.CareGren = Gren.origin;
        wait .01;
    }
}
deleteOverTime(time) {
    wait(time);
    self delete();
}
sentrygunspawn() {
    if (!isDefined(self.sentry_gun)) {
        self.sentry_gun = true;
        self updateMenu("vip", "Sentry Gun ^2Placed");
        self iprintln("Sentry Gun ^2Placed");
        self thread SentryGun("viewmodel_zombie_mg42_mg", (0, 0, 40));
        self thread Sentry_Barrier();
    } else {
        self.sentry_gun = undefined;
        self updateMenu("vip", "Sentry Gun ^1Not Placed");
        self iprintln("Sentry Gun ^1Not Placed");
        self notify("TurretDone");
        self.Turret delete();
        self.TurretStand delete();
    }
}
SentryGun(arg, rise) {
    self endon("TurretDone");
    self.turret = spawnSM(self.origin + rise + (0, 50, 0), arg);
    self.TurretStand = spawnSM(self.origin + (0, 50, 0), "static_berlin_metal_desk");
    self.TurretStand.team = "allies";
    self.Turret.team = "allies";
    level.zombie = getClosest(self getOrigin(), getAiSpeciesArray("axis", "all"));
    for (;;) {
        Enemy = getAiSpeciesArray("axis", "all");
        for (i = 0; i < Enemy.size; i++) {
            if (Distance(Enemy[i].origin, self.TurretStand.origin) <= 500) {
                self.Turret thread TurretLookz1();
                self.Turret thread TurretFirez1();
            } else {
                self.Turret thread TurretLookz1();
            }
        }
        wait 1;
    }
}
Sentry_Barrier() {
    self endon("TurretDone");
    for (;;) {
        Enemy = getAiSpeciesArray("axis", "all");
        for (i = 0; i < Enemy.size; i++) {
            if (distance(Enemy[i].origin, self.Turret.origin) < 100) {
                Enemy[i] doDamage(Enemy[i].health + 666, Enemy[i].origin);
            }
        }
        wait .1;
    }
}
TurretFirez1() {
    if (level.script == "nazi_zombie_factory" || level.script == "nazi_zombie_sumpf") self thread Shootingz1("zombie_mg42", self);
    else self thread Shootingz1("mg42_bipod", self);
}
Shootingz1(gun) {
    Enemy = getAiSpeciesArray("axis", "all");
    for (i = 0; i < Enemy.size; i++) {
        level.zombie = get_closest_ai(self.origin, "axis", "all");
        wait 1;
        magicBullet(gun, self getTagOrigin("tag_flash"), level.zombie.origin + (0, 0, 30), self);
    }
}
TurretLookz1() {
    self rotateTo(VectorToAngles(level.zombie.origin - self.origin), .5);
}
StartPrecision() {
    self thread exitMenu();
    self thread StartMapc();
    self waittill("cm2");
    wait 1;
    self thread PrecisionAirstrike();
    self thread PrecisionTimer();
    self iprintln("Precision Airstrike Called On " + self.mapchoice + "");
}
PrecisionAirstrike() {
    self endon("disconnect");
    self endon("death");
    self endon("precision_over");
    for (;;) {
        randy = randomIntRange(-300, 300);
        wait .1;
        air = self.mapchoice + (100, 75, 1200);
        ground = self.mapchoice * (1, 1, 0);
        random = (randy, randy, 0);
        wait .1;
        magicBullet("panzerschrek_zombie", air, ground, self);
        wait .3;
        magicBullet("panzerschrek_zombie", air + random, ground + random, self);
        wait .3;
        magicBullet("panzerschrek_zombie", air + random, ground + random, self);
        wait .3;
        wait .1;
    }
}
PrecisionTimer() {
    wait 10;
    self notify("precision_over");
}
RaynPopx() {
    if (!isDefined(self.raypop)) {
        self.raypop = true;
        self iPrintLn("Ray n Pop [^2ON^7]");
        self thread RaynPop();
    } else {
        self.raypop = undefined;
        self iPrintLn("Ray n Pop [^1OFF^7]");
        self thread raypopdel();
        self notify("raynpopoff");
    }
}
raypopdel() {
    self.skull delete();
    self.Fx delete();
}
RaynPop() {
    self endon("disconnect");
    self endon("death");
    self endon("raynpopoff");
    self.Skull = spawn("script_model", self.origin + (0, 0, 95));
    self.Skull setModel("zombie_skull");
    self.Skull.angles = self.angles + (0, 90, 0);
    self.Skull thread SkullFollow(self);
    self.Skull thread SkullThink(self);
    playFxOnTag(Loadfx("maps/zombie/fx_zombie_wire_spark"), self.Skull, "tag_origin");
    playFxOnTag(Loadfx("misc/fx_zombie_powerup_on"), self.Skull, "tag_origin");
}
SkullFollow(Plyr) {
    Plyr endon("disconnect");
    Plyr endon("death");
    Plyr endon("raynpopoff");
    for (;;) {
        self.origin = Plyr.origin + (0, 0, 95);
        self.angles = Plyr.angles + (0, 90, 0);
        wait .01;
    }
}
SkullThink(Plyr) {
    Plyr endon("death");
    Plyr endon("disconnect");
    Plyr endon("raynpopoff");
    for (;;) {
        Enemy = getAiSpeciesArray("axis", "all");
        for (i = 0; i < Enemy.size; i++) {
            if (Distance(Enemy[i].origin, self.origin) < 350) {
                self.Fx = spawn("script_model", self.origin);
                self.Fx setModel("tag_origin");
                self.Fx playSound("weap_rgun_fire");
                playFxOnTag(Loadfx("maps/zombie/fx_zombie_wire_spark"), self.Fx, "tag_origin");
                playFxOnTag(Loadfx("misc/fx_zombie_powerup_on"), self.Fx, "tag_origin");
                self.Fx moveTo(Enemy[i] getTagOrigin("j_head"), 1);
                wait 1;
                Enemy[i] maps\_zombiemode_spawner::zombie_head_gib();
                Enemy[i] doDamage(Enemy[i].health + 666, Enemy[i].origin, Plyr);
                self.Fx delete();
            }
        }
        wait .05;
    }
}
xPlosiveBullets() {
    if (!isDefined(self.xPlosiveBullets)) {
        self.xPlosiveBullets = true;
        self iPrintLn("Explosive Bullets [^2ON^7]");
        self thread doXplosiveBullets();
    } else {
        self.xPlosiveBullets = undefined;
        self iPrintLn("Explosive Bullets [^1OFF^7]");
        self notify("xPlosiveBullets_over");
    }
}
doXplosiveBullets() {
    self endon("disconnect");
    self endon("death");
    self endon("xPlosiveBullets_over");
    for (;;) {
        self waittill("weapon_fired");
        loc = self lookPos();
        for (m = 0; m < 5; m++) playFx("zombie/fx_idgun_vortex_explo_zod_zmb", (loc[0] + randomIntRange(-15, 15), loc[1] + randomIntRange(-15, 15), loc[2]));
    }
}
initAC130(isWalking) {
    if (getMap() == "nzf") self thread doAC130((-65, -392, 2000), isWalking);
}
doAC130(spawnLoc, isWalking) {
    self endon("disconnect");
    self endon("death");
    curs = self getCurs();
    self lockMenu();
    self enableInvulnerability();
    self.acEnding = undefined;
    savedOrigin = self getOrigin();
    savedGodmode = self isGodMode();
    base = 0;
    attacher = 0;
    if (!isDefined(isWalking)) {
        base = spawnSM(spawnLoc, "tag_origin");
        yaw = randomIntRange(-360, 360);
        attacher = spawnSM((cos(yaw) * 900, sin(yaw) * 900, spawnLoc[2]), "tag_origin");
        attacher linkTo(base);
        self playerLinkTo(attacher);
        self hide();
    }
    self disableWeapons();
    self hide();
    self thread doAC130Weapons();
    self setInstructions("[{+attack}]: Shoot Missile/Bullet - [{+frag}]: Switch Weapons - [{+melee}]: Exit AC130 Spectre");
    if (!isDefined(level.isSurvivalMode))
        for (;;) {
            base rotateYaw(360, 60);
            for (m = 0; m <= 60; m += .05) {
                if (isDefined(self.acEnding)) break;
                wait .05;
            }
            if (isDefined(self.acEnding)) break;
            wait .05;
        } else {
            base rotateYaw(360, 60);
            wait 60;
        }
    if (!isDefined(isWalking)) {
        self unlink();
        self setOrigin(savedOrigin);
        attacher delete();
        base delete();
    }
    self notify("ac130_over");
    for (m = 0; m < self.ac130HudArray.size; m++) self.ac130HudArray[m] destroy();
    self notify("menu_open", "vip", curs);
    self disableInvulnerability();
    if (!savedGodmode) self disableGodMode();
    else if (savedGodmode) self enableGodMode();
    self resetInstructions();
    self show();
    self enableWeapons();
    self setClientDvar("cg_fov", 65);
    self unlockMenu();
}
doAC130Weapons() {
    self endon("disconnect");
    self endon("death");
    self endon("ac130_over");
    currentWeapon = "105mm";
    self.ac130Weapon40Count = 0;
    self.ac130Weapon25Count = 0;
    self ac130_fov(currentWeapon);
    self ac130_hud(currentWeapon);
    for (;;) {
        if (self fragButtonPressed()) {
            if (currentWeapon == "105mm") currentWeapon = "40mm";
            else if (currentWeapon == "40mm") currentWeapon = "25mm";
            else currentWeapon = "105mm";
            self ac130_fov(currentWeapon);
            self ac130_hud(currentWeapon);
            wait .1;
        }
        if (self attackButtonPressed()) {
            if (currentWeapon == "105mm") {
                if (!isDefined(self.ac130Weapon105OnHold)) {
                    self.ac130Weapon105OnHold = true;
                    playSoundAtPosition("weap_pnzr_fire", self.origin);
                    earthQuake(.1, 1, self.origin, 1000);
                    self ac130_105();
                    self thread ac130_105Wait();
                }
            } else if (currentWeapon == "40mm") {
                if (!isDefined(self.ac130Weapon40OnHold)) {
                    self.ac130Weapon40Count++;
                    playSoundAtPosition("weap_pnzr_fire", self.origin);
                    earthQuake(.1, 1, self.origin, 1000);
                    self ac130_40();
                    if (self.ac130Weapon40Count >= 5) self thread ac130_40Wait();
                    wait .3;
                }
            } else if (currentWeapon == "25mm") {
                if (!isDefined(self.ac130Weapon25OnHold)) {
                    self.ac130Weapon25Count++;
                    playSoundAtPosition("weap_ppsh_fire", self.origin);
                    earthQuake(.1, 1, self.origin, 1000);
                    self ac130_25();
                    if (self.ac130Weapon25Count >= 15) self thread ac130_25Wait();
                    wait .05;
                }
            }
        }
        if (self meleeButtonPressed() && self.pisbucket == true) self.acEnding = true;
        wait .05;
    }
}
ac130_105Wait() {
    wait 5;
    self.ac130Weapon105OnHold = undefined;
}
ac130_40Wait() {
    self.ac130Weapon40OnHold = true;
    wait 3;
    self.ac130Weapon40Count = 0;
    self.ac130Weapon40OnHold = undefined;
}
ac130_25Wait() {
    self.ac130Weapon25OnHold = true;
    wait 2;
    self.ac130Weapon25Count = 0;
    self.ac130Weapon25OnHold = undefined;
}
ac130_hud(cannon) {
    if (!isDefined(self.ac130HudArray)) self.ac130HudArray = [];
    for (m = 0; m < self.ac130HudArray.size; m++) self.ac130HudArray[m] destroy();
    if (cannon == "105mm") cannon = "21;0;2;24;-20;0;2;24;0;-11;40;2;0;11;40;2;0;-39;2;57;0;39;2;57;-48;0;57;2;49;0;57;2;-155;-122;2;21;-154;122;2;21;155;122;2;21;155;-122;2;21;-145;132;21;2;145;-132;21;2;-145;-132;21;2;146;132;21;2";
    if (cannon == "40mm") cannon = "0;-70;2;115;0;70;2;115;-70;0;115;2;70;0;115;2;0;-128;14;2;0;128;14;2;-128;0;2;14;128;0;2;14;0;-35;8;2;0;35;8;2;-29;0;2;8;29;0;2;8;-64;0;2;9;64;0;2;9;0;-85;10;2;0;85;10;2;-99;0;2;10;99;0;2;10";
    if (cannon == "25mm") cannon = "0;-10;10;2;0;10;10;2;-10;0;2;10;10;0;2;10;50;-60;20;2;60;-50;2;20;-50;-60;20;2;-60;-50;2;20;50;60;20;2;60;50;2;20;-50;60;20;2;-60;50;2;20";
    cannon = strTok(cannon, ";");
    for (m = 0; m < cannon.size + 1; m += 4) self.ac130HudArray[self.ac130HudArray.size] = self createRectangle("CENTER", "MIDDLE", int(cannon[m]), int(cannon[(m + 1)]), int(cannon[(m + 2)]), int(cannon[(m + 3)]), (1, 1, 1), "white", 1, 1);
}
ac130_fov(cannon) {
    if (cannon == "105mm") self setClientDvar("cg_fov", 65);
    else if (cannon == "40mm") self setClientDvar("cg_fov", 35);
    else self setClientDvar("cg_fov", 20);
}
ac130_105() {
    self endon("disconnect");
    self endon("death");
    bul = spawnSM(self.origin, "zombie_bomb");
    bul.angles = vectorToAngles(self.origin - self lookPos()) - (180, 0, 0);
    bul moveTo(self lookPos(), .4);
    bul thread ac130_105impact();
}
ac130_105impact() {
    self waittill("movedone");
    playSoundAtPosition("grenade_explode", self.origin);
    playFx(loadFx("explosions/default_explosion"), self.origin);
    killZombiesWithinDistance(self.origin, 300, "flame");
    doPlayerDamage(self.origin, 300);
    earthQuake(1, 1, self.origin, 100);
    self delete();
    darkScreen = self createRectangle("CENTER", "CENTER", 0, 0, 1000, 1000, (0, 0, 0), "white", -10, 0);
    darkScreen thread hudFade(.6, .2);
    wait .4;
    darkScreen thread hudFade(0, .8);
    darkScreen destroy();
}
ac130_40() {
    self endon("disconnect");
    self endon("death");
    bul = spawnSM(self.origin, "zombie_skull");
    bul moveTo(self lookPos(), .4);
    bul thread ac130_40impact();
}
ac130_40impact() {
    self waittill("movedone");
    playSoundAtPosition("grenade_explode", self.origin);
    playFx(loadFx("explosions/default_explosion"), self.origin);
    killZombiesWithinDistance(self.origin, 100, "flame");
    doPlayerDamage(self.origin, 100);
    earthQuake(.4, 1, self.origin, 100);
    self delete();
}
ac130_25() {
    self endon("disconnect");
    self endon("death");
    bul = spawnSM(self.origin, "projectile_usa_m9a1_riflegrenade", vectorToAngles(self.origin - self lookPos()));
    bul moveTo(self lookPos(), .2);
    bul thread ac130_25impact();
}
ac130_25impact() {
    self waittill("movedone");
    playSoundAtPosition("weap_ptrs_fire_dist", self.origin);
    playFx(loadFx("env/electrical/fx_elec_short_oneshot"), self.origin);
    killZombiesWithinDistance(self.origin, 50);
    doPlayerDamage(self.origin, 50);
    earthQuake(.2, 1, self.origin, 100);
    self delete();
}
StartHarrier() {
    self endon("disconnect");
    self endon("death");
    curs = self getCurs();
    self thread lockMenu();
    savedOrigin = self getOrigin();
    self setClientDvar("cg_thirdPerson", "1");
    self setClientDvar("cg_thirdPersonRange", "500");
    self setClientDvar("cg_thirdpersonangle", "6");
    self.harrier = spawn("script_model", self.origin);
    self.harrier setModel("defaultvehicle");
    self playerLinkTo(self.harrier);
    self takeAllWeapons();
    self giveWeapon("zombie_bar");
    self giveWeapon("mp40_zm");
    self switchToWeapon("mp40_zm");
    self setClientDvar("cg_thirdPerson", "1");
    self enableInvulnerability();
    self enableHealthShield(true);
    self setClientDvar("cg_drawGun", "0");
    self setClientDvar("ui_hud_hardcore", "1");
    self setClientDvar("cg_drawCrosshair", "1");
    self setClientDvar("perk_weapspreadmultiplier", ".01");
    self.weap = strTok("AUTO-TURRET|MISSLES", "|");
    self.name = strTok("zombie_30cal|colt_dirty_harry", "|");
    self.weaponHUD = self createFontString("objective", 1.4, self);
    self.weaponHUD setPoint("TOPRIGHT", "TOPRIGHT", 0, 23);
    self.weaponHUD setText("CURRENT WEAPON: ^1PANZERSCHREK");
    self.speedHUD = self createFontString("objective", 1.4, self);
    self.speedHUD setPoint("CENTER", "TOP", -65, 9);
    self.speedHUD setText("SPEED: 50 MPH");
    self hide();
    self thread monitorYs();
    self thread watchShoot();
    self.speed = 35;
    self.cursss = 0;
    self thread alwaysberunning();
    self setInstructions("[{+speed_throw}]: Slow Down - [{+frag}]: Speed Up - [{+attack}]: Shoot - [{weapnext}]: Switch Weapon - [{+melee}]: Exit Harrier");
    for (;;) {
        if (self fragButtonPressed()) {
            if (self.speed < 150) self.speed += 5;
            wait .2;
            while (self fragButtonPressed()) {
                if (self.speed < 150) self.speed += 5;
                self updates();
                wait .05;
            }
        }
        if (self adsButtonPressed()) {
            if (self.speed > 0) self.speed -= 5;
            wait .2;
            while (self adsButtonPressed()) {
                if (self.speed > 0) self.speed -= 5;
                self updates();
                wait .05;
            }
        }
        if (self meleeButtonPressed()) {
            self.harrier delete();
            self notify("harrier_done");
            self setOrigin(savedOrigin);
            self setClientDvar("cg_thirdPerson", "0");
            self.speedHUD destroy();
            self.weaponHUD destroy();
            self setClientDvar("cg_drawGun", "1");
            self setClientDvar("cg_drawCrosshair", "1");
            self setClientDvar("ui_hud_hardcore", "0");
            self visionSetNaked("default", "1");
            self SetClientDvar("r_brightness", "0");
            self SetClientDvar("cg_thirdPerson", "0");
            self SetClientDvar("cg_thirdPersonRange", "120");
            self setClientDvar("cg_thirdpersonangle", "0");
            self notify("menu_open", "vip", curs);
            self resetInstructions();
            self thread unlockMenu();
            self thread giveAllGuns();
            self show();
            break;
        }
        self updates();
        self.harrier.angles = self getPlayerAngles();
        self setWeaponAmmoClip("m1911_zm", 8);
        self setWeaponAmmoClip("frag_grenade_zm", 0);
        wait 0.01;
    }
}
updates() {
    speed = ceil(self.speed);
    self.weaponHUD setText("Current Weapon: ^1" + self.weap[self.cursss]);
    self.speedHUD setText("Speed: ^1" + speed + " ^7MPH");
}
watchShoot() {
    self endon("disconnect");
    self endon("death");
    self endon("harrier_done");
    self giveWeapon("molotov");
    for (;;) {
        close_zombie = get_closest_ai(self.origin, "axis");
        self waittill("weapon_fired");
        if (self getCurrentWeapon() != "zombie_30cal") {
            for (i = 0; i < 10; i++) {
                magicBullet(self.name[self.cursss], self.origin + (0, 0, 20), self GetCursorP0s(), self);
                wait .01;
            }
        }
    }
}
Sh00ting(gun, controller) {
    self endon("disconnect");
    self endon("death");
    self endon("harrier_done");
    self endon("weapon_change");
    for (;;) {
        level.zombie = get_closest_ai(self.origin, "axis");
        level.zombie doDamage(10, level.zombie.origin);
        magicbullet(gun, self getTagOrigin("tag_flash"), level.zombie.origin + (0, 0, 30), controller);
        wait .01;
    }
}
alwaysberunning() {
    self endon("disconnect");
    self endon("death");
    self endon("harrier_done");
    for (;;) {
        vec = anglesToForward(self getPlayerAngles());
        end = (vec[0] * (self.speed * .7), vec[1] * (self.speed * .7), vec[2] * (self.speed * .7));
        self.harrier.origin = self.harrier.origin + end;
        wait 0.01;
    }
}
GetCursorP0s() {
    forward = self getTagOrigin("tag_eye");
    end = self thread vector_Scal(anglesToForward(self getPlayerAngles()), 1000000);
    location = bulletTrace(forward, end, 0, self)["position"];
    return location;
}
monitorYs() {
    self endon("disconnect");
    self endon("death");
    self endon("harrier_done");
    self.cursss = 0;
    for (;;) {
        self waittill("weapon_change");
        self updates();
        self.cursss++;
        if (self.cursss == 1) self thread Sh00ting(self, "zombie_mg42");
        if (self.cursss > 1) self.cursss = 0;
        wait 0.05;
    }
}
orbitalStrike() {
    if (getMap() == "nzf") self doOrbitalStrike(loadfx("maps/mp_maps/fx_mp_light_lamp"), loadFx("maps/zombie/fx_zombie_mainframe_link_all"));
    else if (getMap() == "nzs") self doOrbitalStrike(loadFx("env/light/fx_ray_ceiling_amber_dim_sm"), loadFx("maps/zombie/fx_zombie_dog_lightning_buildup"));
    else self doOrbitalStrike(loadFx("env/light/fx_ray_ceiling_amber_dim_sm"), loadFx("misc/fx_zombie_couch_effect"));
}
doOrbitalStrike(fx, fx2) {
    self endon("disconnect");
    self endon("death");
    curs = self getCurs();
    self lockMenu();
    orb = spawnSM(self lookPos(), "tag_origin", (-90, 0, 0));
    for (m = 0; m < 10; m++) playFxOnTag(fx, orb, "tag_origin");
    self iPrintlnBold("Press [{+activate}] To Call In Strike At Marker");
    self iPrintlnBold("Press [{+melee}] To Abort Strike");
    wait .2;
    for (;;) {
        orb moveTo(self lookPos(), .1);
        if (self useButtonPressed() && self getStance() != "prone") {
            self playLocalSound("pa_buzz");
            wait 3;
            for (m = 0; m < 20; m++) playFx(fx2, orb.origin);
            zombz = get_array_of_closest(orb.origin, getAiSpeciesArray("axis"), undefined, undefined, 300);
            for (m = 0; m < zombz.size; m++) {
                wait(randomFloatRange(.2, .3));
                zombz[m] maps\_zombiemode_spawner::zombie_head_gib();
                zombz[m] doDamage(10000, zombz[m].origin, self);
                playSoundatPosition("nuked", Zombz[m].origin);
            }
            break;
        }
        if (self meleeButtonPressed() && self getStance() != "prone") {
            self playLocalSound("pa_buzz");
            self notify("menu_open", "vip", curs);
            break;
        }
        wait .05;
    }
    orb delete();
    self unlockMenu();
    self notify("OrbitOver");
}
predatorMissile() {
    if (getMap() == "nzf") self doPredatorMissile(loadFx("maps/mp_maps/fx_mp_zombie_hand_dirt_burst"), (-1200, 1100, 2400), (50, -45, 0));
    if (getMap() == "nzs") self doPredatorMissile(loadFx("maps/mp_maps/fx_mp_zombie_hand_dirt_burst"), (10341, 612, 408));
    if (getMap() == "nza") self doPredatorMissile(loadFx("maps/mp_maps/fx_mp_zombie_hand_dirt_burst"), (221, 20, 1337));
    if (getMap() == "nzp") self doPredatorMissile(loadFx("env/dirt/fx_dust_ceiling_impact_lg_mdbrown"), (-51, 45, 150));
}
doPredatorMissile(fx, spawnPoint, spawnAngles) {
    curs = self getCurs();
    savedOrigin = self getOrigin();
    savedGodmode = self isGodMode();
    self lockMenu();
    self enableInvulnerability();
    self hide();
    self allowADS(false);
    self allowCrouch(false);
    self allowMelee(false);
    self allowSprint(false);
    self disableWeapons();
    self disableOffHandWeapons();
    self setInstructions("[{+attack}]: Boost");
    bg = self createRectangle("CENTER", "CENTER", 0, 0, 1000, 1000, (0, 0, 0), "white", 1, 0);
    bg hudFade(1, .2);
    coords = strTok("21;0;2;24;-20;0;2;24;0;-11;40;2;0;11;40;2;0;-39;2;57;0;39;2;57;-48;0;57;2;49;0;57;2;-155;-122;2;21;-154;122;2;21;155;122;2;21;155;-122;2;21;-145;132;21;2;145;-132;21;2;-145;-132;21;2;146;132;21;2", ";");
    hud = [];
    for (m = 0; m < coords.size; m += 4) {
        hud[hud.size] = self createRectangle("CENTER", "CENTER", int(coords[m]), int(coords[m + 1]), int(coords[m + 2]), int(coords[m + 3]), (1, 1, 1), "white", 2, 0);
        hud[hud.size - 1] thread hudFade(1, .2);
    }
    self setVision("introscreen");
    missile = spawnSM(spawnPoint, "zombie_bomb", vectorToAngles(self.origin - self lookPos()) - (180, 0, 0));
    missile setInvisibleToPlayer(self);
    for (m = 0; m < 5; m++) playFxOnTag(loadFx("misc/fx_zombie_powerup_on"), missile, "tag_origin");
    self playerLinkTo(missile);
    self setPlayerAngles(spawnAngles);
   self setClientDvars("cg_drawGun", 0, "ui_hud_hardcore", 1, "cg_drawCrosshair", 0);
    wait .2;
    bg hudFade(0, .2);
    missile playSound("weap_pnzr_fire");
    speed = 25;
    boost = false;
    for (;;) {
        ang = self getPlayerAngles();
        if (ang[0] < 20) self setPlayerAngles((20, ang[1], ang[2]));
        vector = anglesToForward(missile.angles);
        forward = missile.origin + (vector[0] * speed, vector[1] * speed, vector[2] * speed);
        collision = bulletTrace(missile.origin, forward, false, self);
        missile.angles = (vectorToAngles((lookPos() - (0, 0, 70)) - missile.origin));
        missile moveTo(forward, .05);
        if (self attackButtonPressed() && !boost) {
            boost = true;
            self setClientDvar("cg_fov", 75);
            self playLocalSound("bridge_hit");
            speed = 75;
        }
        if (collision["surfacetype"] != "default" && collision["fraction"] < 1) {
            expPos = missile.origin;
            for (m = 0; m < 360; m += 80) playFx(loadFx("explosions/default_explosion"), (expPos[0] + (200 * cos(m)), expPos[1] + (200 * sin(m)), expPos[2]));
            earthquake(1, 1.6, expPos, 250);
            killZombiesWithinDistance(expPos, 400, "flame");
            doPlayerDamage(expPos, 200);
            playSoundAtPosition("grenade_explode", expPos);
            playSoundAtPosition("nuked", expPos);
            break;
        }
        wait .05;
    }
    self resetInstructions();
    self enableWeapons();
    self enableOffHandWeapons();
    self allowADS(true);
    self allowCrouch(true);
    self allowMelee(true);
    self allowSprint(true);
    self show();
    self unlink();
    missile delete();
    bg hudFade(1, .2);
    for (m = 0; m < hud.size; m++) hud[m] thread hudFadenDestroy(0, .2);
    wait .2;
    self disableInvulnerability();
    if (!savedGodmode) self disableGodMode();
    else if (savedGodmode) self enableGodMode();
    self freezeControls(false);
    self unlockMenu();
    self setOrigin(savedOrigin);
    self notify("menu_open", "vip", curs);
    self setVision("default");
   self setClientDvars("cg_drawGun", 1, "ui_hud_hardcore", 0, "cg_drawCrosshair", 1, "cg_fov", 65);
    bg hudFadenDestroy(0, .2);
    self notify("Predator Missile Over");
}
dropWeaponsAtChs() {
    if (isDefined(self.Drop_Weaps_Cross)) self iprintln("Weapons Already Dropped!");
    if (!isDefined(self.Drop_Weaps_Cross)) {
        self.Drop_Weaps_Cross = true;
        keys = getArrayKeys(level.zombie_weapons);
        for (m = 0; m < keys.size; m++) {
            model = spawn("weapon_" + keys[m], self lookPos() + (randomIntRange(-40, 40), randomIntRange(-60, 60), 60), 4);
            model giveMaxAmmo();
            model thread deleteAfter30();
            self thread resetAfter31();
        }
    }
}
deleteAfter30() {
    wait 30;
    wait(randomInt(3));
    self delete();
}
resetAfter31() {
    wait 31;
    self.Drop_Weaps_Cross = undefined;
}
reaper(isWalking) {
    self endon("death");
    self endon("disconnect");
    self.reaperOver = undefined;
    curs = self getCurs();
    self lockMenu();
    self enableInvulnerability();
    savedPos = self getOrigin();
    savedGodmode = self isGodMode();
    self disableWeapons();
    int = randomInt(360);
    reaper = 0;
    if (!isDefined(isWalking)) {
        reaper = spawnSM((cos(int) * 1200, sin(int) * 1200, 2000), "defaultvehicle");
        reaper setInvisibleToPlayer(self);
        self playerLinkTo(reaper);
        self setPlayerAngles((59, 126, 0));
        self thread reaperRotate(reaper, int);
        self hide();
    }
    if (isDefined(level.isSurvivalMode)) self thread reaperTimeOut();
    self thread reaperZoom();
    ui = strTok("0;15;40;2;0;-15;40;2;20;0;2;30;-20;0;2;30;-35;0;30;2;35;0;30;2", ";");
    hud = [];
    for (m = 0; m < ui.size + 1; m += 4) hud[hud.size] = self createRectangle("CENTER", "CENTER", int(ui[m]), int(ui[(m + 1)]), int(ui[(m + 2)]), int(ui[(m + 3)]), (1, 1, 1), "white", 1, 1);
    self thread UIDetect(hud, "reaperOver", 150);
    self setInstructions("[{+speed_throw}]: Zoom In - [{+attack}]: Launch Missile - [{+melee}]: Exit Reaper UAV");
    for (;;) {
        if (self attackButtonPressed()) {
            bomb = spawnSM(self getTagOrigin("tag_weapon_left"), "zombie_bomb");
            bomb playSound("weap_pnzr_fire");
            for (;;) {
                vector = anglesToForward(bomb.angles);
                forward = bomb.origin + (vector[0] * 45, vector[1] * 45, vector[2] * 45);
                collision = bulletTrace(bomb.origin, forward, false, self);
                bomb.angles = (vectorToAngles((lookPos() - (0, 0, 70)) - bomb.origin));
                bomb moveTo(forward, .05);
                if (collision["surfacetype"] != "default" && collision["fraction"] < 1) {
                    expPos = bomb.origin;
                    for (m = 0; m < 360; m += 80) playFx(loadFx("explosions/default_explosion"), (expPos[0] + (200 * cos(m)), expPos[1] + (200 * sin(m)), expPos[2]));
                    earthquake(1, 1.6, expPos, 250);
                    killZombiesWithinDistance(expPos, 400, "flame");
                    doPlayerDamage(expPos, 200);
                    bomb playSound("grenade_explode");
                    self playLocalSound("grenade_explode_dist");
                    break;
                }
                if (self meleeButtonPressed()) break;
                wait .05;
            }
            bomb delete();
        }
        wait .05;
        if (isDefined(self.reaperOver)) break;
        if (self meleeButtonPressed()) break;
    }
    self resetInstructions();
    self notify("reaperOver");
    self setClientDvar("cg_fov", 65);
    for (m = 0; m < hud.size; m++) hud[m] destroy();
    if (!isDefined(isWalking)) {
        reaper delete();
        self unlink();
        self setOrigin(savedPos);
    }
    self unlockMenu();
    self show();
    self notify("menu_open", "vip", curs);
    self disableInvulnerability();
    if (!savedGodmode) self disableGodMode();
    else if (savedGodmode) self enableGodMode();
    self enableWeapons();
}
reaperZoom() {
    self endon("death");
    self endon("disconnect");
    self endon("reaperOver");
    for (;;) {
        wait .05;
        if (self adsButtonPressed()) {
            self setClientDvar("cg_fov", 35);
            continue;
        }
        if (!self adsButtonPressed()) self setClientDvar("cg_fov", 65);
    }
}
reaperRotate(reaper, int) {
    self endon("death");
    self endon("disconnect");
    self endon("reaperOver");
    firstLoc = reaper.origin;
    for (;;) {
        for (m = int; m < 720; m += .5) {
            loc = (cos(m) * 1200, sin(m) * 1200, 2000);
            angles = vectorToAngles(loc - reaper.origin);
            reaper moveTo(loc, .1);
            reaper rotateTo((angles[0], angles[1], angles[2] - 40), .1);
            wait .1;
        }
    }
}
reaperTimeOut() {
    self endon("death");
    self endon("disconnect");
    wait 45;
    self.reaperOver = true;
}
UIDetect(hud, endUpon, dist) {
    self endon("death");
    self endon("disconnect");
    self endon(endUpon);
    for (;;) {
        zombz = getAiSpeciesArray("axis", "all");
        for (m = 0; m < zombz.size; m++)
            if (distance(self lookPos(), zombz[m].origin) < dist)
                for (e = 0; e < hud.size; e++) hud[e].color = (1, 0, 0);
        wait .05;
        for (e = 0; e < hud.size; e++) hud[e].color = (1, 1, 1);
    }
}
StealthBomber() {
    if (!IsDefined(level.BomberInUse)) {
        if (getMap() == "nzf") self thread SpawnStealthBomber((-960, 1365.8, 682), (1210, -3566.2, 682));
        if (getMap() == "nzs") self thread SpawnStealthBomber((12454.4, -1286.07, 396.84), (7517.75, 2917.76, 396.847));
        if (getMap() == "nza") self thread SpawnStealthBomber((-1667.89, -1212.33, 1050.76), (1844.59, 1421.16, 1050.76));
        if (getMap() == "nzp") self thread SpawnStealthBomber((-454.815, -1611.51, 484.719), (830.339, 2015.8, 484.719));
    } else {
        self iPrintln("Stealth Bomber Is ^1In Use");
        wait 1;
    }
}
SpawnStealthBomber(SpawnPoint, EndPoint) {
    self endon("StealthOver");
    level.BomberInUse = true;
    self.BomberHasFnd = true;
    StealthBomber = spawn("script_model", SpawnPoint);
    StealthBomber setModel("defaultvehicle");
    StealthBomber.angles = vectorToAngles(StealthBomber.origin - Endpoint) - (0, 180, 0);
    StealthBomber moveTo(EndPoint, 15);
    for (i = 0; i < 120; i++) {
        magicBullet("colt_dirty_harry", StealthBomber.origin, StealthBomber.origin - (0, 0, 682), self);
        wait .1;
        earthquake(0.6, 5, StealthBomber.origin, 850);
    }
    self notify("Strat_Stealth");
    StealthBomber delete();
    level.BomberInUse = undefined;
}
StealthBombx() {
    self thread exitMenu();
    self thread StartMapc();
    self waittill("cm2");
    wait 1;
    self thread SpawnStealthBomberc();
}
SpawnStealthBomberc() {
    self endon("StealthOver");
    level.BomberInUse = true;
    self.BomberHasFnd = true;
    self exitMenu();
    StealthBomber = spawn("script_model", (-960, 1365.8, 682));
    StealthBomber setModel("defaultvehicle");
    StealthBomber.angles = vectorToAngles(StealthBomber.origin - self.mapchoice) - (0, 180, 0);
    StealthBomber moveTo(self.mapchoice, 15);
    for (i = 0; i < 120; i++) {
        magicBullet("colt_dirty_harry", StealthBomber.origin, StealthBomber.origin - (0, 0, 682), self);
        wait .1;
        earthquake(0.6, 5, StealthBomber.origin, 850);
    }
    self notify("Strat_Stealth");
    StealthBomber delete();
    level.BomberInUse = undefined;
}
anoyingGuy() {
    if (!isDefined(self.anoyingGuy)) {
        self iPrintLn("Anoying Guy [^2ON^7]");
        self.anoyingGuy = true;
        self thread doAnoyingGuy();
    } else {
        self iPrintLn("Anoying Guy [^1OFF^7]");
        self.anoyingGuy = undefined;
        self notify("anoyingGuy_over");
    }
}
doAnoyingGuy() {
    self endon("disconnect");
    self endon("death");
    self endon("anoyingGuy_over");
    for (;;) {
        self playSound("plr_0_vox_ppsh_0");
        wait 3;
        self playSound("plr_3_vox_kill_headdist_5");
        wait 3;
    }
}
miniGame() {
    curs = self getCurs();
    self lockMenu();
    self freezeControls(true);
    self setBlur(1, 1);
    savedGodmode = self isGodMode();
    self enableInvulnerability();
    round = 10;
    bg = self createRectangle("CENTER", "CENTER", 0, 0, 1000, 1000, (0, 0, 0), "white", -100, .8);
    if (isDefined(level.gameTypeChosen) && level.gameTypeChosen == "hide") {
        bg.alpha = 1;
        round = 100;
    }
    text = self createText("smallFixed", 1.5, "CENTER", "TOP", 0, 60, 5, 1, "MINI GAME - PRESS THE BUTTONS!");
    text thread alwaysColourful();
    text2 = self createText("smallFixed", 1.2, "CENTER", "TOP", 0, 80, 5, 1, "ROUND 1");
    buttons = strTok("[{+speed_throw}];[{+attack}];[{+melee}];[{+frag}];[{+activate}]", ";");
    space = " ";
    for (e = 0; e < round; e++) {
        text2 setText("ROUND " + (e + 1));
        tok = [];
        order = "";
        for (m = 0; m < 4; m++) {
            randy = buttons[randomInt(buttons.size)];
            tok[m] = randy;
            order += randy;
            if (m < 3) order += space;
        }
        hud = self createText(getFont(), 2, "CENTER", "CENTER", 0, 0, 5, 1, order);
        check = [];
        for (m = 0; m < 4; m++) check[m] = self createRectangle("CENTER", "CENTER", m * 15 - 22, 40, 10, 20, (1, 0, 0), "ui_sliderbutt_1", 6, 1);
        for (m = 0; m < tok.size; m++) {
            for (;;) {
                if (self adsButtonPressed() && tok[m] == "[{+speed_throw}]") break;
                if (self attackButtonPressed() && tok[m] == "[{+attack}]") break;
                if (self meleeButtonPressed() && tok[m] == "[{+melee}]") break;
                if (self fragButtonPressed() && tok[m] == "[{+frag}]") break;
                if (self useButtonPressed() && tok[m] == "[{+activate}]") break;
                if (isDefined(level.seekerReleased)) break;
                wait .05;
            }
            check[m] fadeOverTime(.2);
            check[m].color = (0, 1, 0);
            if (isDefined(level.seekerReleased)) break;
            wait .3;
        }
        hud destroy();
        for (m = 0; m < check.size; m++) check[m] destroy();
        if (isDefined(level.seekerReleased)) break;
    }
    text destroy();
    text2 destroy();
    bg destroy();
    self freezeControls(false);
    self unlockMenu();
    self notify("menu_open", "vip", curs);
    self setBlur(0, 1);
    self disableInvulnerability();
    if (!savedGodmode) self disableGodMode();
    else if (savedGodmode) self enableGodMode();
}
vertexProtector() {
    if (!isDefined(self.vertexProtector)) {
        self.vertexProtector = true;
        self iPrintLn("Vertex Protector [^2ON^7]");
        self thread doVertexProtector();
    } else {
        self.vertexProtector = undefined;
        self iPrintLn("Vertex Protector [^1OFF^7]");
        self notify("vertexProtector_over");
    }
}
doVertexProtector() {
    self endon("disconnect");
    self endon("death");
    skull = spawnSM(self.origin + (0, 0, 95), "zombie_skull", self.angles + (0, 90, 0));
    playFxOnTag(loadFx("maps/zombie/fx_zombie_wire_spark"), skull, "tag_origin");
    playFxOnTag(loadFx("misc/fx_zombie_powerup_on"), skull, "tag_origin");
    skull thread skullFollowPlayer(self);
    for (;;) {
        enemy = getClosest(skull.origin, getAiSpeciesArray("axis", "all"));
        if (isDefined(enemy) && enemy damageConeTrace(skull.origin, skull) > .75 && distance(enemy.origin, self.origin) < 350) {
            fx = spawnSM(skull.origin, "tag_origin");
            fx playSound("weap_rgun_fire");
            playFxOnTag(loadFx("maps/zombie/fx_zombie_wire_spark"), fx, "tag_origin");
            playFxOnTag(loadFx("misc/fx_zombie_powerup_on"), fx, "tag_origin");
            fx moveTo(enemy getTagOrigin("j_head"), .2);
            wait .2;
            enemy maps\_zombiemode_spawner::zombie_head_gib();
            enemy doDamage(enemy.health + 666, enemy.origin);
            fx delete();
        }
        wait .05;
        if (!isDefined(self.vertexProtector)) break;
    }
    skull delete();
}
skullFollowPlayer(plr) {
    plr endon("disconnect");
    plr endon("death");
    while (isDefined(plr.vertexProtector)) {
        self moveTo(plr.origin + (0, 0, 95), .1);
        self rotateTo(plr.angles + (0, 90, 0), .1);
        wait .05;
    }
}
chargedGyrationBarrels() {
    if (!isDefined(self.chargedGyrationBarrels)) {
        self.chargedGyrationBarrels = true;
        self iPrintLn("Charged Gyration Barrels [^2ON^7]");
        self thread dochargedGyrationBarrels();
    } else {
        self.chargedGyrationBarrels = undefined;
        self iPrintLn("Charged Gyration Barrels [^1OFF^7]");
        self notify("chargedGyrationBarrels_over");
    }
}
RotateEntYaw(Yaw, Time) {
    while (IsDefined(self)) {
        self RotateYaw(Yaw, Time);
        wait Time;
    }
}
dochargedGyrationBarrels() {
    self endon("disconnect");
    self endon("death");
    link = spawnSM(self.origin + (0, 0, 30), "tag_origin");
    link thread rotateEntYaw(360, 2);
    barrel[0] = spawnSM(self.origin + (0, 50, 30), "zombie_beaker_brain");
    barrel[1] = spawnSM(self.origin + (0, -50, 30), "zombie_beaker_brain");
    for (m = 0; m < barrel.size; m++) {
        playFxOnTag(loadFx("maps/zombie/fx_zombie_wire_spark"), barrel[m], "tag_origin");
        playFxOnTag(loadFx("maps/mp_maps/fx_mp_light_lamp"), barrel[m], "tag_origin");
        barrel[m] linkTo(link);
    }
    link thread linkFollowPlayer(self);
    for (;;) {
        zombz = getAiSpeciesArray("axis", "all");
        for (m = 0; m < zombz.size; m++)
            for (e = 0; e < barrel.size; e++) self thread killZombiesWithinDistance(self.origin, 60, "tesla");
        wait .05;
        if (!isDefined(self.chargedGyrationBarrels)) break;
    }
    link delete();
    for (m = 0; m < barrel.size; m++) barrel[m] delete();
}
linkFollowPlayer(plr) {
    plr endon("disconnect");
    plr endon("death");
    while (isDefined(plr.chargedGyrationBarrels)) {
        self moveTo(plr.origin + (0, 0, 30), .1);
        wait .05;
    }
}
valkyrieMissile() {
    self endon("death");
    self endon("disconnect");
    curs = self getCurs();
    self lockMenu();
    self disableWeapons();
    savedOrigin = self getOrigin();
    savedGodmode = self isGodMode();
    self enableInvulnerability();
    self setVision("introscreen");
    coords = strTok("15;0;2;30;-15;0;2;30;0;-15;30;2;0;15;30;2;25;0;20;2;-25;0;20;2;0;25;2;20;0;-25;2;20;87;100;26;2;100;87;2;26;-87;100;26;2;100;-87;2;26;87;-100;26;2;-100;87;2;26;-87;-100;26;2;-100;-87;2;26", ";");
    hud = [];
    for (m = 0; m < coords.size; m += 4) {
        hud[hud.size] = self createRectangle("CENTER", "CENTER", int(coords[m]), int(coords[m + 1]), int(coords[m + 2]), int(coords[m + 3]), (1, 1, 1), "white", 2, 0);
        hud[hud.size - 1] thread hudFade(1, .2);
    }
    self setInstructions("[{+attack}]: Launch Missile - [{+melee}]: Exit Valkyrie Missile");
    valkyries = 0;
    for (;;) {
        wait .05;
        if (self attackButtonPressed()) {
            valkyries++;
            bomb = spawnSM(self getTagOrigin("tag_weapon_left"), "zombie_bomb", (vectorToAngles((lookPos() - (0, 0, 70)) - self getTagOrigin("tag_weapon_left"))));
            bomb setInvisibleToPlayer(self);
            self playSound("weap_pnzr_fire");
            self hide();
            self playerLinkTo(bomb);
            for (;;) {
                vector = anglesToForward(bomb.angles);
                forward = bomb.origin + (vector[0] * 45, vector[1] * 45, vector[2] * 45);
                collision = bulletTrace(bomb.origin, forward, false, self);
                bomb.angles = (vectorToAngles((lookPos() - (0, 0, 70)) - bomb.origin));
                bomb moveTo(forward, .05);
                wait .05;
                if (collision["surfacetype"] != "default" && collision["fraction"] < 1) {
                    expPos = bomb.origin;
                    for (m = 0; m < 360; m += 80) playFx(loadFx("explosions/default_explosion"), (expPos[0] + (200 * cos(m)), expPos[1] + (200 * sin(m)), expPos[2]));
                    earthquake(1, 1.6, expPos, 250);
                    killZombiesWithinDistance(expPos, 400, "flame");
                    doPlayerDamage(expPos, 200);
                    bomb playSound("grenade_explode");
                    self playLocalSound("grenade_explode_dist");
                    bomb delete();
                    break;
                }
            }
            self setOrigin(savedOrigin);
        }
        if (valkyries == 2) break;
        if (self meleeButtonPressed() && self.assbucket == true) break;
    }
    self resetInstructions();
    bg = self createRectangle("CENTER", "CENTER", 0, 0, 1000, 1000, (0, 0, 0), "white", 1, 0);
    for (m = 0; m < hud.size; m++) hud[m] thread hudFadenDestroy(0, .2);
    bg hudFade(1, .2);
    self show();
    self unlockMenu();
    self notify("menu_open", "vip", curs);
    self enableWeapons();
    self setVision("default");
    self setOrigin(savedOrigin);
    self disableInvulnerability();
    if (!savedGodmode) self disableGodMode();
    else if (savedGodmode) self enableGodMode();
    bg hudFadenDestroy(0, .6);
    self notify("valkerie Over");
}
deployableApacheGunner(isWalking) {
    self endon("death");
    self endon("disconnect");
    curs = self getCurs();
    self lockMenu();
    self setInstructions("[{+attack}]: Shoot - [{+melee}]: Exit Apache Gunner");
    bg = self createRectangle("CENTER", "CENTER", 0, 0, 1000, 1000, (0, 0, 0), "white", 1, 0);
    bg hudFade(1, .2);
    self disableWeapons();
    savedOrigin = self getOrigin();
    savedGodmode = self isGodMode();
    self enableInvulnerability();
    self setVision("introscreen");
    apache = 0;
    chopper = 0;
    if (!isDefined(isWalking)) {
        apache = spawnHelicopter(getPlayers()[0].origin + (500, 500, 1000));
        for (m = 0; m < apache.size; m++) apache[m] setInvisibleToPlayer(self);
        chopper = apache[0];
        self playerLinkTo(chopper);
        self hide();
    }
    overwatch = 0;
    coords = strTok("0;-70;2;115;0;70;2;115;-70;0;115;2;70;0;115;2;0;-128;14;2;0;128;14;2;-128;0;2;14;128;0;2;14;0;-35;8;2;0;35;8;2;-29;0;2;8;29;0;2;8;-64;0;2;9;64;0;2;9;0;-85;10;2;0;85;10;2;-99;0;2;10;99;0;2;10", ";");
    hud = [];
    for (m = 0; m < coords.size; m += 4) {
        hud[hud.size] = self createRectangle("CENTER", "CENTER", int(coords[m]), int(coords[m + 1]), int(coords[m + 2]), int(coords[m + 3]), (1, 1, 1), "white", 2, 0);
        hud[hud.size - 1] thread hudFade(1, .2);
    }
    uiHud = [];
    uiHud[0] = hud[8];
    uiHud[1] = hud[9];
    uiHud[2] = hud[10];
    uiHud[3] = hud[11];
    self thread UIDetect(uiHud, "apacheOver", 100);
    bg hudFadenDestroy(0, .6);
    self thread apacheGunner();
    movements = 6;
    if (!isDefined(level.isSurvivalMode)) movements = 100000000000;
    for (m = 0; m < movements; m++) {
        wait .05;
        if (self meleeButtonPressed()) break;
        if (isDefined(isWalking)) continue;
        for (;;) {
            zombz = getAiSpeciesArray("axis", "all");
            if (!isDefined(zombz[0])) wait .05;
            randy = randomInt(zombz.size);
            overwatch = zombz[randy];
            if (isDefined(zombz[randy])) break;
            if (self meleeButtonPressed()) break;
            wait .05;
        }
        dest = getAboveBuildingsLocation(overwatch.origin + (0, 0, 1000));
        chopper moveTo(dest, 3, 1, 1);
        chopper rotateTo((chopper.angles[0], vectorToAngles(chopper.origin - dest)[1] - 180, chopper.angles[2]), 3, 1, 1);
        for (e = 0; e <= 10; e += .05) {
            wait .05;
            if (self meleeButtonPressed()) break;
        }
    }
    self notify("apacheOver");
    self resetInstructions();
    bg = self createRectangle("CENTER", "CENTER", 0, 0, 1000, 1000, (0, 0, 0), "white", 1, 0);
    bg hudFade(1, .05);
    self setVision("default");
    for (m = 0; m < hud.size; m++) hud[m] thread hudFadenDestroy(0, .03);
    bg hudFadenDestroy(0, .03);
    self show();
    self unlockMenu();
    if (!isDefined(isWalking)) {
        for (m = 0; m < apache.size; m++) apache[m] delete();
        self setOrigin(savedOrigin);
    }
    self notify("menu_open", "vip", curs);
    self enableWeapons();
    self setVision("default");
    self disableInvulnerability();
    if (!savedGodmode) self disableGodMode();
    else if (savedGodmode) self enableGodMode();
}
#using_animtree("generic_human");
apacheGunner() {
    self endon("death");
    self endon("disconnect");
    self endon("apacheOver");
    deathFx[0] = %death_explosion_run_B_v2;
    deathFx[1] = %death_explosion_run_L_v2;
    deathFx[2] = %death_explosion_run_F_v2;
    deathFx[3] = %death_explosion_run_R_v2;
    for (;;) {
        if (self attackButtonPressed()) {
            for (e = 0; e < 2; e++) {
                pos = self lookPos();
                magicBullet("zombie_sw_357", self.origin - (0, 0, 2), pos);
                earthquake(.25, 1, self.origin, 90);
                zombz = getAiSpeciesArray("axis", "all");
                for (m = 0; m < zombz.size; m++)
                    if (distance(zombz[m].origin, pos) <= 100) {
                        zombz[m].deathanim = deathFx[randomInt(deathFx.size)];
                        zombz[m] animMode("nogravity");
                        zombz[m] doDamage(99999, self.origin, undefined, undefined, "pistolbullet");
                    }
                doPlayerDamage(pos, 50);
                earthquake(1.5, 1, pos, 100);
                for (m = 0; m < 5; m++) playFx(loadFx("env/electrical/fx_elec_short_oneshot"), (pos[0] + randomIntRange(-15, 15), pos[1] + randomIntRange(-15, 15), pos[2]));
                wait .1;
            }
            wait .1;
        }
        wait .05;
    }
}
spawnHelicopter(pos) {
    prop[0] = spawnSM(pos, "defaultvehicle");
    prop[1] = spawnSM(prop[0].origin + (-17, -3, 60), "zombie_teleporter_powerline", (90, 0, 90));
    prop[2] = spawnSM(prop[1].origin, prop[1].model, (90, 0, -90));
    prop[3] = spawnSM(prop[1].origin, prop[1].model, (90, 0, -180));
    prop[4] = spawnSM(prop[1].origin, prop[1].model, (90, 0, 0));
    prop[5] = spawnSM(prop[1].origin, "tag_origin");
    for (m = 1; m < 5; m++) prop[m] linkTo(prop[5]);
    prop[5] thread rotateEntYaw(360, .5);
    prop[5] thread heliKeepUp(prop[0]);
    return prop;
}
heliKeepUp(ent) {
    while (isDefined(self)) {
        self moveTo(ent.origin + (-17, -3, 60), .05);
        wait .05;
    }
}
getAboveBuildingsLocation(location) {
    trace = bullettrace(location + (0, 0, 10000), location, false, undefined);
    startorigin = trace["position"] + (0, 0, -514);
    zpos = 0;
    maxxpos = 13;
    maxypos = 13;
    for (xpos = 0; xpos < maxxpos; xpos++)
        for (ypos = 0; ypos < maxypos; ypos++) {
            thisstartorigin = startorigin + ((xpos / (maxxpos - 1) - .5) * 1024, (ypos / (maxypos - 1) - .5) * 1024, 0);
            thisorigin = bullettrace(thisstartorigin, thisstartorigin + (0, 0, -10000), false, undefined);
            zpos += thisorigin["position"][2];
        }
    zpos = zpos / (maxxpos * maxypos);
    zpos = zpos + 850;
    return (location[0], location[1], zpos);
}
jetPack() {
    self endon("death");
    self endon("disconnect");
    self endon("jetPack_destroy");
    self exitMenu();
    self iPrintLn("JetPack ^2Activated");
    self iPrintLn("Hold [{+frag}] To Use");
    self iPrintLn("Enter The Menu To Turn JetPack ^1Off");
    jetPack = 100;
    bar = self createPrimaryProgressBar(self);
    bar setPoint("CENTER", "CENTER", 0, 120);
    text = self createText("smallFixed", 1, "CENTER", "CENTER", 0, 110, 1, 1, "JetPack Fuel " + jetPack + "^2/^7100");
    if (getMap() == "nzp") fx = loadFx("env/electrical/fx_elec_short_oneshot");
    else fx = level._effect["mp_elec_broken_light_1shot"];
    self thread jetPackDestroy(bar, text);
    for (;;) {
        if (self fragButtonPressed() && jetPack > 0) {
            self playSound("elec_jib_zombie");
            playFx(fx, self getTagOrigin("j_ankle_ri"));
            playFx(fx, self getTagOrigin("j_ankle_le"));
            playFx(loadFx("env/fire/fx_fire_player_md"), self getTagOrigin("j_ankle_ri"));
            playFx(loadFx("env/fire/fx_fire_player_md"), self getTagOrigin("j_ankle_le"));
            earthquake(.15, .2, self getTagOrigin("j_spine4"), 50);
            jetPack--;
            if (self getVelocity()[2] < 300) self setVelocity(self getVelocity() + (0, 0, 60));
        }
        if (jetPack < 100 && !self fragButtonPressed()) jetPack++;
        text setText("JetPack Fuel " + jetPack + "^2/^7100");
        bar updateBar(jetPack / 100);
        bar.bar fadeOverTime(.05);
        bar.bar.color = (1, jetPack / 100, jetPack / 100);
        wait .05;
    }
}
jetPackDestroy(hud1, hud2) {
    self waittill_any("death", "disconnect", "jetPack_destroy");
    hud1 destroyElem();
    hud2 destroyElem();
}
forgePickup() {
    if (!isDefined(self.forgePickup)) {
        self.forgePickup = true;
        self iPrintLn("Forge Pickup [^2ON^7]");
        self iPrintLn("Press [{+frag}] To Pickup/Drop Items");
        self thread doPickup();
    } else {
        self.forgePickup = undefined;
        self iPrintLn("Forge Pickup [^1OFF^7]");
        self notify("forgePickup_over");
    }
}
doPickup() {
    self endon("disconnect");
    self endon("death");
    self endon("forgePickup_over");
    for (;;) {
        wait .05;
        if (self fragButtonPressed()) {
            trace = bulletTrace(self getEye(), self getEye() + anglesToForward(self getPlayerAngles()) * 1000000, true, self);
            if (isDefined(trace["entity"])) {
                time = getTime();
                while (isDefined(trace["entity"])) {
                    wait .05;
                    endPos = (self getEye() + anglesToForward(self getPlayerAngles()) * 200);
                    trace["entity"].origin = endPos;
                    trace["entity"] forceTeleport(endPos);
                    if (self getPermission() == level.permissions[1] || self getPermission() == level.permissions[2]) trace["entity"] setOrigin(endPos);
                    if (self fragButtonPressed() && (getTime() - time) > 400) break;
                }
            }
            wait .6;
        }
    }
}
laughHolic() {
    if (!isDefined(self.laughHolic)) {
        self.laughHolic = true;
        self iPrintln("Laugh-o-Holic [^2ON^7]");
        self thread initLaughy();
    } else {
        self.laughHolic = undefined;
        self iPrintln("Laugh-o-Holic [^1OFF^7]");
        self notify("laughy_over");
    }
}
initLaughy() {
    self endon("disconnect");
    self endon("death");
    self endon("laughy_over");
    snd = strtok("vox_gen_laugh_0;vox_gen_laugh_1;vox_gen_laugh_2;vox_gen_laugh_3", ";");
    for (;;) {
        for (m = 0; m < snd.size; m++) {
            self playSound("plr_" + self getEntityNumber() + "_" + snd[m]);
            wait 2;
        }
        wait .05;
    }
}
codJumper() {
    if (!isDefined(self.codJumper)) {
        self.codJumper = true;
        self iPrintln("Cod Jumper [^2ON^7]");
        self thread doCodJumper();
        self giveWeapon("asp_zm");
        self switchToWeapon("asp_zm");
    } else {
        self.codJumper = undefined;
        self iPrintln("Cod Jumper [^1OFF^7]");
        self notify("codJumper_over");
    }
}
doCodJumper() {
    self endon("death");
    self endon("disconnect");
    self endon("codJumper_over");
    cans = undefined;
    for (;;) {
        self waittill("weapon_fired");
        if (self getCurrentWeapon() == "asp_zm") {
            if (isDefined(cans))
                for (m = 0; m < cans.size; m++) cans[m] delete();
            cans = spawnMultipleModels(self lookPos(), 4, 4, 1, 10, 10, 0, "zombie_ammocan");
            for (m = 0; m < cans.size; m++) playFxOnTag(level._effect["powerup_on"], cans[m], "tag_origin");
            self thread codJumpDetect(cans);
        }
    }
}
codJumpDetect(cans) {
    while (isDefined(cans[0]) && isDefined(self.codJumper)) {
        for (m = 0; m < cans.size; m++) {
            plr = getPlayers();
            for (e = 0; e < plr.size; e++) {
                if (distance(cans[m].origin, plr[e].origin) < 10) {
                    v = plr[e] getVelocity();
                    cans[m] rotateYaw(360, .3);
                    plr[e] setVelocity((v[0], v[1], randomIntRange(9000, 10000)));
                }
            }
        }
        wait .05;
    }
    for (m = 0; m < cans.size; m++) cans[m] delete();
}
spawnCar() {
    if (!isDefined(self.Drivable_Vehicle)) {
        self.Drivable_Vehicle = true;
        self iPrintLn("Drivable Car [^2ON^7]");
       // maps\_aircraft::main("defaultvehicle", "defaultvehicle", 0);
        self.car_drive = spawnVehicle("defaultvehicle", "new_tank", "defaultvehicle", self lookPos(), (0, vectorToAngles(self.origin - self lookPos())[1], 0));
        self.car_drive.vehicletype = "defaultvehicle";
       // maps\_vehicle::vehicle_init(self.car_drive);
        self.car_drive makeVehicleUsable();
        self.car_drive startEngineSound();
    } else {
        self.Drivable_Vehicle = undefined;
        self iPrintLn("Drivable Car [^1OFF^7]");
        self.car_drive delete();
    }
}
specNading() {
    if (!isDefined(self.specNading)) {
        self.specNading = true;
        self iPrintln("Spec-Nading [^2ON^7]");
        self thread doSpecTraining();
    } else {
        self.specNading = undefined;
        self iPrintln("Spec-Nading [^1OFF^7]");
        self notify("specTraining_over");
        self setClientDvars("cg_drawgun", 1, "cg_fov", 65, "cg_crosshairAlpha", 1, "ui_hud_hardcore", 0);
        self unlink();
        self show();
        self freezeControls(false);
        self setOrigin(self.specOldPos);
    }
}
doSpecTraining() {
    self endon("disconnect");
    self endon("death");
    self endon("specTraining_over");
    for (;;) {
        self waittill("grenade_fire", nade, name);
        if (isSubStr(name, "granate") || isSubStr(name, "frag")) {
            self.specOldPos = self getOrigin();
            self freezeControls(true);
            self playerLinkTo(nade);
            self hide();
            self setClientDvars("cg_drawgun", 0, "cg_fov", 80, "cg_crosshairAlpha", 0, "ui_hud_hardcore", 1);
            self thread fixNadeVision(nade);
            while (isDefined(nade)) wait .05;
            self setClientDvars("cg_drawgun", 1, "cg_fov", 65, "cg_crosshairAlpha", 1, "ui_hud_hardcore", 0);
            self unlink();
            self show();
            self freezeControls(false);
            self setOrigin(self.specOldPos);
        }
    }
}
fixNadeVision(nade) {
    self endon("disconnect");
    self endon("death");
    self endon("specTraining_over");
    for (;;) {
        self setPlayerAngles(vectorToAngles(nade.origin - self.origin));
        wait .05;
    }
}
wunderWalther() {
    if (!isDefined(self.wunderWalther)) {
        self.wunderWalther = true;
        self iPrintln("WunderWalther DG-4 [^2ON^7]");
        self thread doWunderWalther();
    } else {
        self.wunderWalther = undefined;
        self iPrintln("WunderWalther DG-4 [^1OFF^7]");
        self notify("wunderWalther_over");
    }
}
#using_animtree("generic_human");
doWunderWalther() {
    self endon("death");
    self endon("disconnect");
    self endon("wunderWalther_over");
    self giveWeapon("asp_zm");
    self switchToWeapon("asp_zm");
    for (;;) {
        self waittill("weapon_fired");
        if (self getCurrentWeapon() == "asp_zm") {
            trace = bulletTrace(self getTagOrigin("j_head"), self getTagOrigin("j_head") + anglesToForward(self getPlayerAngles()) * 100000000, true, self);
            tesla = spawnSM(self getTagOrigin("tag_inhand"), "tag_origin");
            playFxOnTag(level._effect["tesla_bolt"], tesla, "tag_origin");
            tesla moveTo(trace["position"], .135);
            ent = trace["entity"];
            if (ent.damageyaw > 135 || ent.damageyaw <= -135) ent.deathanim = % death_explosion_run_B_v2;
            else if (ent.damageyaw > 45 && ent.damageyaw <= 135) ent.deathanim = % death_explosion_run_L_v2;
            else if (ent.damageyaw > -45 || ent.damageyaw <= 45) ent.deathanim = % death_explosion_run_F_v2;
            else if (ent.damageyaw > -45 && ent.damageyaw <= -135) ent.deathanim = % death_explosion_run_R_v2;
            ent animMode("nogravity");
            if (ent.is_zombie) ent doDamage(ent.health + 666, self.origin, undefined, undefined, "pistolbullet");
            wait .135;
            tesla delete();
        }
    }
}
attackUfo() {
    if (!isDefined(self.Attack_UFO)) {
        self.Attack_UFO = true;
        self updateMenu("vip", "Attack Ufo ^2In-Bound");
        self iprintln("Attack Ufo ^2In-Bound");
        self thread attackUfo_True();
    } else {
        self.Attack_UFO = undefined;
        self updateMenu("vip", "Attack Ufo ^1Not In-Bound");
        self iprintln("Attack Ufo ^1Not In-Bound");
        playFx(loadFx("maps/zombie/fx_transporter_beam"), self.Attacking_ufo[0].origin);
        for (m = 0; m < self.Attacking_ufo.size; m++) self.Attacking_ufo[m] delete();
    }
}
attackUfo_True() {
    self.Attacking_ufo = [];
    self.Attacking_ufo[0] = spawnSM(self.origin + (0, 0, 750), "zombie_teleporter_pad");
    self.Attacking_ufo[1] = spawnSM(self.origin + (0, 0, 750), self.Attacking_ufo[0].model, (-180, 0, 0));
    self.Attacking_ufo[2] = spawnSM(self.origin + (0, 0, 750), "tag_origin", (-270, 0, 0));
    self.Attacking_ufo[2] linkTo(self.Attacking_ufo[1]);
    self.Attacking_ufo[1] linkTo(self.Attacking_ufo[0]);
    playFxOnTag(loadFx("maps/zombie/fx_zombie_factory_marker"), self.Attacking_ufo[2], "tag_origin");
    playFxOnTag(level._effect["mp_light_lamp"], self.Attacking_ufo[2], "tag_origin");
    self.Attacking_ufo[0] thread ufoThink();
    self.Attacking_ufo[0] thread ufoMoveTo();
    self.Attacking_ufo[0] thread rotateEntYaw(360, .5);
    if (isDefined(level.isSurvivalMode)) {
        wait 45;
        playFx(loadFx("maps/zombie/fx_transporter_beam"), self.Attacking_ufo[0].origin);
        for (a = 0; a < self.Attacking_ufo.size; a++) self.Attacking_ufo[a] delete();
    }
}
ufoMoveTo() {
    while (isDefined(self)) {
        zom = getAiSpeciesArray("axis", "all");
        self moveTo(zom[randomInt(zom.size)].origin + (0, 0, 1000), 50);
        wait 3;
    }
}
ufoThink() {
    while (isDefined(self)) {
        zom = getClosest(self.origin, getAiSpeciesArray("axis", "all"));
        if (isDefined(zom) && zom damageConeTrace(self.origin, self) > .75) {
            self thread ufoFire(zom.origin);
            wait 2;
        }
        wait .05;
    }
}
ufoFire(target) {
    orb = spawnSM(self.origin, "tag_origin");
    playFxOnTag(loadFx("misc/fx_zombie_powerup_on"), orb, "tag_origin");
    playSoundAtPosition("weap_rgun_fire", self.origin);
    orb moveTo(target, .4);
    wait .4;
    playSoundAtPosition("grenade_explode", target);
    killZombiesWithinDistance(target, 400, "flame");
    doPlayerDamage(target, 200);
    earthquake(.4, 1, target, 400);
    playFx(loadFx("explosions/fx_mortarExp_dirt"), target);
    orb delete();
}
attackHelicopter() {
    if (!isDefined(self.Attack_Helicopter_Real)) {
        self.Attack_Helicopter_Real = true;
        self updateMenu("vip", "Attack Helicopter ^2In-Bound");
        self iprintln("Attack Helicopter ^2In-Bound");
        self thread attackHelicopter_Real();
    } else {
        self.Attack_Helicopter_Real = undefined;
        self updateMenu("vip", "Attack Helicopter ^1Not In-Bound");
        self iprintln("Attack Helicopter ^1Not In-Bound");
        for (a = 0; a < self.apache_Heli.size; a++) self.apache_Heli[a] delete();
    }
}
attackHelicopter_Real() {
    self.apache_Heli = spawnHelicopter(self.origin + (0, 0, 1000));
    self.chopper_Heli = self.apache_Heli[0];
    self.overwatch_Heli = undefined;
    for (t = 0; t < 10; t++) {
        for (;;) {
            zombz = getAiSpeciesArray("axis", "all");
            if (!isDefined(zombz[0])) wait .05;
            randy = randomInt(zombz.size);
            self.overwatch_Heli = zombz[randy];
            if (isDefined(zombz[randy])) break;
            wait .05;
        }
        dest = getAboveBuildingsLocation(self.overwatch_Heli.origin + (0, 0, 1000));
        self.chopper_Heli moveTo(dest, 3, 1, 1);
        self.chopper_Heli rotateTo((self.chopper_Heli.angles[0], vectorToAngles(self.chopper_Heli.origin - dest)[1] - 180, self.chopper_Heli.angles[2]), 3, 1, 1);
        wait 3;
        for (e = 0; e < 30; e++) {
            target = getClosest(self.chopper_Heli.origin, getAiSpeciesArray("axis", "all"));
            magicBullet("zombie_bar_upgraded", self.chopper_Heli getTagOrigin("tag_flash"), target.origin);
            wait .1;
        }
        wait 4;
        for (e = 0; e < 30; e++) {
            target = getClosest(self.chopper_Heli.origin, getAiSpeciesArray("axis", "all"));
            magicBullet("zombie_bar_upgraded", self.chopper_Heli getTagOrigin("tag_flash"), target.origin);
            wait .1;
        }
    }
    if (isDefined(level.isSurvivalMode)) {
        for (a = 0; a < self.apache_Heli.size; a++) self.apache_Heli[a] delete();
    }
}
rpgMode() {
    if (!isDefined(self.rpgMode)) {
        self.rpgMode = true;
        self iPrintln("RPG Mode [^2ON^7]");
        self thread doRpgMode();
    } else {
        self.rpgMode = undefined;
        self iPrintln("RPG Mode [^1OFF^7]");
        self notify("rpgMode_over");
    }
}
doRpgMode(rpg) {
    self endon("death");
    self endon("disconnect");
    self endon("rpgMode_over");
	rpg = "m72_law_zm";
    for (;;) {
        self waittill("weapon_fired");wait .05;
        magicBullet(rpg, self getTagOrigin("tag_weapon_left"), self lookPos(), self);
    }
}
teleport2Ch() {
    if (!isDefined(self.tele2Ch)) {
        self.tele2Ch = true;
        self iPrintln("Teleport To Crosshairs [^2ON^7]");
        self thread doTeleport2Ch();
    } else {
        self.tele2Ch = undefined;
        self iPrintln("Teleport To Crosshairs [^1OFF^7]");
        self notify("tele2Ch_over");
    }
}
doTeleport2Ch() {
    self endon("death");
    self endon("disconnect");
    self endon("tele2Ch_over");
    for (;;) {
        self waittill("weapon_fired");
        self playLocalSound("tesla_happy");
        self setOrigin(self lookPos());
        self iPrintln("^1T^2e^3l^4e^1p^2o^3r^4t^1e^2d ^3t^4o ^1C^2r^3o^4s^1s^2h^3a^4i^1r^2s^3!");
    }
}
DoTracers() {
    if (!isDefined(self.tracerz)) {
        self.tracerz = true;
        self.bulletTracerz = undefined;
        self iPrintln("Bullet Tracers [^2ON^7]");
        self thread doBulletTracersx();
        self notify("bulletTracers_over");
    } else {
        self.tracerz = undefined;
        self iPrintln("Bullet Tracers [^1OFF^7]");
        self notify("Tracers_over");
    }
}
doBulletTracersx() {
    self endon("disconnect");
    self endon("death");
    self endon("Tracers_over");
    setLobbyDvar("cg_tracerSpeed", 100);
    setLobbyDvar("cg_tracerScrewRadius", 0);
    setLobbyDvar("cg_tracerLength", 999);
    setLobbyDvar("cg_tracerWidth", 9);
    for (;;) {
        self waittill("weapon_fired");
        bulletTracer(self getTagOrigin("tag_inhand"), self lookPos(), true);
    }
}
bulletTracers() {
    if (!isDefined(self.bulletTracerz)) {
        self.bulletTracerz = true;
        self.tracerz = undefined;
        self iPrintln("Bullet Tracers v2 [^2ON^7]");
        self thread doBulletTracers();
        self notify("Tracers_over");
    } else {
        self.bulletTracerz = undefined;
        self iPrintln("Bullet Tracers v2 [^1OFF^7]");
        self notify("bulletTracers_over");
    }
}
doBulletTracers() {
    self endon("disconnect");
    self endon("death");
    self endon("bulletTracers_over");
    setLobbyDvar("cg_tracerSpeed", 300);
    setLobbyDvar("cg_tracerScrewRadius", 10);
    setLobbyDvar("cg_tracerLength", 10000000);
    setLobbyDvar("cg_tracerWidth", 10);
    for (;;) {
        self waittill("weapon_fired");
        bulletTracer(self getTagOrigin("tag_inhand"), self lookPos(), true);
    }
}
Spawn_DeathSkull1() {
    self endon("disconnect");
    self endon("death");
    Fx1 = LoadFx("misc/fx_zombie_powerup_on");
    Fx2 = LoadFx("misc/fx_zombie_electric_trap");
    Fx3 = LoadFx("maps/zombie/fx_zombie_wire_spark");
    Fx4 = LoadFx("maps/mp_maps/fx_mp_fire_rubble_small");
    Fx5 = LoadFx("weapon/bouncing_betty/fx_explosion_betty_generic");
    Fx6 = LoadFx("misc/fx_zombie_mini_nuke");
    self iPrintln("^7Death Skull ^2Spawned");
    nZxMikeeeyx = spawn("script_model", self.origin + (0, 0, 40));
    nZxMikeeeyx SetModel("zombie_skull");
    PlayFx(Fx4, nZxMikeeeyx.origin);
    PlayFx(Fx3, nZxMikeeeyx.origin);
    PlayFx(Fx2, nZxMikeeeyx.origin);
    PlayFxOnTag(Fx1, nZxMikeeeyx, "tag_origin");
    for (;;) {
        PlayFx(Fx6, nZxMikeeeyx.origin);
        wait .1;
        PlayFx(Fx5, nZxMikeeeyx.origin);
        wait .1;
        nZxMikeeeyx MoveTo(nZxMikeeeyx.origin + (0, 0, 40), 1);
        nZxMikeeeyx RotateYaw(2880, 2);
        if (Distance(self.origin, nZxMikeeeyx.origin) < 155) {
            Earthquake(1, .4, self.origin, 512);
            self PlaySound("nuke_flash");
            self PlaySound("tesla_happy");
        }
        wait 2;
        nZxMikeeeyx MoveTo(nZxMikeeeyx.origin - (0, 0, 40), .1);
        Enemy = GetAiSpeciesArray("axis", "all");
        for (i = 0; i < Enemy.size; i++) {
            if (Distance(Enemy[i].origin, nZxMikeeeyx.origin) < 200) {
                Enemy[i] DoDamage(Enemy[i].health + 666, Enemy[i].origin);
            }
        }
        wait .2;
    }
}
spawn_deathSkull() {
    self endon("disconnect");
    self endon("death");
    self iPrintLn("Death-Skull v2 ^2Spawned");
    pos = self getOrigin();
    skull = spawnMultipleModels(pos - (20, 20, -40), 2, 2, 1, 40, 40, 0, "zombie_skull");
    link = spawnSM(pos, "tag_origin");
    link playLocalSound("meteor_loop");
    for (m = 0; m < skull.size; m++) {
        skull[m].angles = vectorToAngles(skull[m] getOrigin() - (pos + (0, 0, 40))) + (0, 90, 0);
        playFxOnTag(level._effect["tesla_bolt"], skull[m], "tag_origin");
        playFxOnTag(level._effect["powerup_on"], skull[m], "tag_origin");
        skull[m] linkTo(link);
    }
    fx = spawnSM(pos, "tag_origin", (-90, 0, 0));
    fxTag = strTok("maps/mp_maps/fx_mp_fire_rubble_small maps/zombie/fx_zombie_wire_spark misc/fx_zombie_electric_trap", " ");
    for (m = 0; m < fxTag.size; m++) playFxOnTag(loadFx(fxTag[m]), fx, "tag_origin");
    for (;;) {
        link moveZ(40, 3, 2);
        if (randomInt(100) < 50) link rotateYaw(2880, 3, 2);
        else link rotateYaw(-2880, 3, 2);
        wait 2;
        for (m = 20; m < 40; m++) {
            if (m % 2)
                for (e = 0; e < skull.size; e++) skull[e] hide();
            else
                for (e = 0; e < skull.size; e++) skull[e] show();
            if (m < 15) wait .5;
            else if (m < 25) wait .25;
            else wait .1;
        }
        for (e = 0; e < skull.size; e++) skull[e] show();
        link moveZ(-40, .1);
        wait .1;
        earthquake(3, .4, link getOrigin(), 250);
        for (m = 0; m < getPlayers().size; m++)
            if (distance(getPlayers()[m] getOrigin(), link getOrigin()) < 250) {
                getPlayers()[m] playLocalSound("nuke_flash");
                getPlayers()[m] playLocalSound("tesla_happy");
                getPlayers()[m] playLocalSound("grenade_explode");
            }
        killZombiesWithinDistance(link getOrigin(), 250, "flame");
        playFx(loadFx("misc/fx_zombie_mini_nuke"), link getOrigin());
        playFx(loadFx("weapon/bouncing_betty/fx_explosion_betty_generic"), link getOrigin());
        wait .6;
    }
}
ricochetBullets() {
    if (!isDefined(self.ricochetBullets)) {
        self.ricochetBullets = true;
        self iPrintLn("Ricochet Bullets [^2ON^7]");
        self thread _ricochetBullets();
    } else {
        self.ricochetBullets = undefined;
        self iPrintln("Ricochet Bullets [^1OFF^7]");
        self notify("ricochetBullets_over");
    }
}
_ricochetBullets() {
    self endon("disconnect");
    self endon("death");
    self endon("ricochetBullets_over");
    for (;;) {
        self waittill("weapon_fired");
        gun = self getCurrentWeapon();
        incident = anglesToForward(self getPlayerAngles());
        trace = bulletTrace(self getEye(), self getEye() + incident * 100000, false, self);
        reflection = incident - (2 * trace["normal"] * vectorDot(incident, trace["normal"]));
        magicBullet(gun, trace["position"], trace["position"] + (reflection * 100000), self);
        trace = bulletTrace(trace["position"], trace["position"] + (reflection * 100000), false, self);
        incident = reflection;
        reflection = incident - (2 * trace["normal"] * vectorDot(incident, trace["normal"]));
        magicBullet(gun, trace["position"], trace["position"] + (reflection * 100000), self);
    }
}
burp() {
    self playSound("belch3d");
}
oorahMonkeyBones() {
    self playSound("plr_0_vox_kill_monkey_2");
}
thunderNades()
{
    self endon("death");
    self endon("disconnect");
    if(isDefined(self.has_thunderNades))
        return;
    nades = 4;
    txt = self createText(getFont(), 1, "TOPRIGHT", "TOPRIGHT", -20, 20, 1, 1, nades+" Thunder Nades Left");
    txt thread deleteTextAfterTime(1);
    self giveWeapon("frag_grenade_zm", 4);
    self.has_thunderNades = true;
    for(;;)
    {
        self waittill("grenade_fire", grenade, weapName);
        if((isSubStr(weapName, "granate") || isSubStr(weapName, "frag")) && !isDefined(grenade.thunder_gun))
        {
            grenade.thunder_gun = true;
            nades--;
            string = nades+" Thunder Nades Left";
            if(nades == 1)
                string = nades+" Thunder Nade Left";
            txt = self createText(getFont(), 1, "TOPRIGHT", "TOPRIGHT", -20, 20, 1, 1, string);
            txt thread deleteTextAfterTime(1);
            self thread thunderNade_init(grenade);
            playFxOnTag(level._effect["tesla_bolt"], grenade, "tag_origin");
            if(nades <= 0)
                break;
        }
    }
    self.has_thunderNades = undefined;
}

thunderNade_init(grenade, pos)
{
    rangeSquared = 300*300;
    for(;;)
    {
        grenade resetMissileDetonationTime();
        pos = grenade getOrigin();
        wait .05;
        if(pos == grenade getOrigin())
            break;
    }
    wait 0.6;
    grenade delete();
    playFx(loadFx("explosions/default_explosion"), pos);
    playFx(loadFx("misc/fx_zombie_powerup_grab"), pos);
    playFx(loadFx("misc/fx_zombie_powerup_wave"), pos);
    playSoundAtPosition("bolt", pos);
    playSoundAtPosition("grenade_explode", pos);
    playSoundAtPosition("explo_shockwave_l", pos);
    zom = getAiSpeciesArray("axis", "all");
    for(e = 0; e < zom.size; e++)
    {
        zomi = zom[e];
        if(!isDefined(zomi) || !isAlive(zomi))
            continue;
        testOrigin = zomi.origin+(0, 0, 40);
        testOriginSquared = distanceSquared(pos, testOrigin);
        if(testOriginSquared > rangeSquared)
            continue;
        distMult = (rangeSquared-testOriginSquared)/rangeSquared;
        flingVec = vectorNormalize(testOrigin-pos);
        flingVec = (flingVec[0], flingVec[1], abs(flingVec[2]));
       // flingVec = vectorScale(flingVec, 100+100*distMult);
        zomi flingZombie(self, flingVec);
    }
}

flingZombie(player, flingVec)
{
    if(!isDefined(self) || !isAlive(self))
        return;
    self doDamage(self.health+666, player.origin, player);
    if(self.health <= 0)
    {
        self startRagdoll();
        self launchRagdoll(flingVec);
    }
}

//Verification Menu

verificationOpts(opt, who, input) {
    who = getPlayers()[who];
    name = who getname();
    switch (opt) {
        case "menuLock":
            if (who == self && self.is_host == false)
                return;
            if (who.menuAccessed) {
			if(who.is_host == false)
                who lockMenu();
			if(who.is_host == false)
                who iPrintLn("^1ADMIN: ^7Your Mod Menu Has Been Locked!");
			else who iPrintLN("^1ADMIN: ^2" + self getName() + " ^7Tried to lock your menu!");
			if(who.is_host == false)
                self iPrintLn("^1ADMIN: ^7" + name + "'s Mod Menu Has Been Locked!");
			else
                self iPrintLn("^1^FHOW DARE YOU!?");
				
            }
            break;
        case "menuUnlock":
            if (who == self)
                return;
            if (who.menuAccessed) {
                who unlockMenu();
                who iPrintLn("^1ADMIN: ^7Your Mod Menu Has Been Un-Locked!");
                self iPrintLn("^1ADMIN: ^7" + name + "'s Mod Menu Has Been Un-Locked!");
            }
            break;
        case "freeze":
            if (who == self)
                return;
            if (!isDefined(who.frozen)) {
                who lockMenu();
                who freezeControls(true);
                who iPrintLn("^1ADMIN: ^7You Have Been Frozen!");
                self iPrintLn("^1ADMIN: ^7" + name + " Has Been Frozen!");
                who.frozen = true;
            }
            break;
        case "unFreeze":
            if (who == self)
                return;
            if (isDefined(who.frozen)) {
                who unlockMenu();
                who freezeControls(false);
                who iPrintLn("^1ADMIN: ^7You Have Been Un-Frozen!");
                self iPrintLn("^1ADMIN: ^7" + name + " Has Been Un-Frozen!");
                who.frozen = undefined;
            }
            break;
        case "kill":
            who exitMenu();
            who disableGodMode();
            who enableHealthShield(false);
            who.healthShield = undefined;
            who updateMenu("basic", "God Mode ^1OFF", 2, true);
            who.GodModeIsOn = false;
            who doDamage(1000, who.origin, undefined, undefined, "riflebullet");
            if (who == self)
                self iPrintln("^1ADMIN: ^7You Killed Youself!");
            break;
        case "jail":
            if (who == self)
                return;
            if (!isDefined(who.jailed)) {
                who lockMenu();
                who allowJump(true);
                if (getMap() == "nzp") who setOrigin((-156.993, -460.424, 1.125));
                if (getMap() == "nza") who setOrigin((353.84, 1138.85, 64.125));
                if (getMap() == "nzs") who setOrigin((10160, 1533, -668.33));
                if (getMap() == "nzf") who setOrigin((-126, -3276, -104.875));
                who iPrintLn("^1ADMIN: ^7You Have Been Sent To Jail!");
                self iPrintLn("^1ADMIN: ^7" + name + " Has Been Sent To Jail!");
                who.jailed = true;
                who.prison = undefined;
                who.jailed2 = undefined;
            }
            break;
        case "jail2":
            if (who == self)
                return;
            if (!isDefined(who.jailed2)) {
                who lockMenu();
                who allowJump(true);
                if (getMap() == "nzf") who setOrigin((1514.45, -670.077, 138.125));
                who iPrintLn("^1ADMIN: ^7You Have Been Sent To Other Jail!");
                self iPrintLn("^1ADMIN: ^7" + name + " Has Been Sent To Other Jail!");
                who.jailed2 = true;
                who.prison = undefined;
                who.jailed = undefined;
            }
            break;
        case "prison":
            if (who == self)
                return;
            if (!isDefined(who.prison)) {
                who lockMenu();
                who allowJump(false);
                if (getMap() == "nzf") who setOrigin((69.5267, -904.984, 466.125));
                who iPrintLn("^1ADMIN: ^7You Have Been Sent To Prison!");
                self iPrintLn("^1ADMIN: ^7" + name + " Has Been Sent To Prison!");
                who.prison = true;
                who.jailed2 = undefined;
                who.jailed = undefined;
            }
            break;
        case "unJail":
            if (who == self)
                return;
            if (isDefined(who.jailed)) {
                who returnToSpawn();
                who allowJump(true);
                who iPrintLn("^1ADMIN: ^7You Have Been Set Free From Jail!");
                self iPrintLn("^1ADMIN: ^7" + name + " Has Been Set Free From Jail!");
                who unlockMenu();
                who.jailed = undefined;
            }
            if (who == self)
                return;
            if (isDefined(who.jailed2)) {
                if (getMap() == "nzf") who setOrigin((23, 99, 93.1664));
                who allowJump(true);
                who iPrintLn("^1ADMIN: ^7You Have Been Set Free From Other Jail!");
                self iPrintLn("^1ADMIN: ^7" + name + " Has Been Set Free From Other Jail!");
                who unlockMenu();
                who.jailed2 = undefined;
            }
            if (who == self)
                return;
            if (isDefined(who.prison)) {
                if (getMap() == "nzf") who setOrigin((23, 99, 93.1664));
                who allowJump(true);
                who iPrintLn("^1ADMIN: ^7You Have Been Set Free From Prison!");
                self iPrintLn("^1ADMIN: ^7" + name + " Has Been Set Free From Prison!");
                who unlockMenu();
                who.prison = undefined;
            }
            break;
        case "secretMenu":
            if (who == self)
                return;
            if (isDefined(who.menu["misc"]["menuLocked"])) {
                who unlockMenu();
                who iPrintLn("^1ADMIN: ^7You Have Secretly Been Given a Mod Menu!");
                self iPrintLn("^1ADMIN: ^7" + name + " Has Secretly Been Given a Mod Menu!");
                self thread refreshMenu();
                self thread initializeMenuCurs(true);
            }
            break;
        case "summon":
            if (who == self)
                return;
            who setOrigin(self.origin);
            who iPrintLn("^1ADMIN: ^7You Have Been Summoned!");
            self iPrintLn("^1ADMIN: ^7" + name + " Has Been Summoned!");
            break;
        case "teleportTo":
            if (who == self)
                return;
            self setOrigin(who.origin);
            who iPrintLn("^1ADMIN: ^7Somebody Has Teleported To You!");
            self iPrintLn("^1ADMIN: ^7You Have Teleported To " + name + "!");
            break;
        case "derank":
            who confirm_presteige(0);
            who confirm_rank(0);
            updateGamerProfile();
            if (who == self)
                self iPrintLn("^1ADMIN: ^7You Deranked Yourself!");
            else
                self iPrintLn("^1ADMIN: ^7" + name + " Has Been Deranked!");
            break;
        case "PermaBan":
            if (who == self) {
                self iPrintLn("^1ADMIN: ^7You Cannot Perma-Ban Yourself!");
                return;
            }
            who confirm_presteige(0);
            who confirm_rank(0);
            updateGamerProfile();
            self iPrintLn("^1ADMIN: ^7" + name + " Has Been Perma-Banned!");
            break;
        case "revive":
            if (who == self)
                return;
            if (isDefined(who.revivetrigger)) {
                who thread maps\_laststand::revive_force_revive(self);
                who iPrintLn("^1ADMIN: ^7You Have Been Revived!");
                self iPrintLn("^1ADMIN: ^7" + name + " Has Been Revived!");
            }
            break;
        case "legit":
            if (who == self)
                return;
            if (!isDefined(who.isUnlocking)) {
                who thread setLeaderboards(21000);
                self iPrintLn("^1ADMIN: ^7" + name + " Is Now Setting Legit Stats!");
            } else
                self iPrintLn("^1ADMIN: ^7" + name + " Is Already Unlocking Something!");
            updateGamerProfile();
            break;
        case "moderate":
            if (who == self)
                return;
            if (!isDefined(who.isUnlocking)) {
                who thread setLeaderboards(2147000);
                self iPrintLn("^1ADMIN: ^7" + name + " Is Now Setting Moderate Stats!");
            } else
                self iPrintLn("^1ADMIN: ^7" + name + " Is Already Unlocking Something!");
            updateGamerProfile();
            break;
        case "insane":
            if (who == self)
                return;
            if (!isDefined(who.isUnlocking)) {
                who thread setLeaderboards(2147483647);
                self iPrintLn("^1ADMIN: ^7" + name + " Is Now Setting Insane Stats!");
            } else
                self iPrintLn("^1ADMIN: ^7" + name + " Is Already Unlocking Something!");
            updateGamerProfile();
            break;
        case "attach":
            if (who == self)
                return;
            if (!isDefined(who.isUnlocking)) {
                who thread unlockAttachments();
                self iPrintLn("^1ADMIN: ^7" + name + " Is Now Unlocking Attachments!");
            } else
                self iPrintLn("^1ADMIN: ^7" + name + " Is Already Unlocking Something!");
            break;
        case "achieve":
            if (who == self)
                return;
            if (!isDefined(who.isUnlocking)) {
                who thread unlockAchievements();
                self iPrintLn("^1ADMIN: ^7" + name + " Is Now Unlocking Achievements!");
            } else
                self iPrintLn("^1ADMIN: ^7" + name + " Is Already Unlocking Something!");
            break;
        case "kick":
            if (who == self)
                return;
            ban(who GetEntityNumber());
            self thread newMenu("veri");
            break;
        case "kickS":
            if (who == self)
                return;
            who setClientDvar("activeAction", "startSingleplayer");
            self iPrintLn("Must 'Restart Level' To Kick " + name + " To Singleplayer");
            break;
        case "VapTheme":
            if (who == self)
                return;
            who thread maps\vapp::Vappy_Theme();
            self iPrintLn("Must Theme Given To" + name );
            break;
        case "dash":
            if (who == self)
                return;
            who setClientDvar("activeAction", "quit");
            self iPrintLn("Must 'Restart Level' To Kick " + name + " To Dashboard/XMB");
            break;
        case "giveAll":
            keys = getArrayKeys(level.zombie_weapons);
            tok = strTok("defaultweapon|zombie_melee|walther|colt_dirty_harry", "|");
            for (i = 0; i < keys.size; i++) who giveWeapon(keys[i]);
            for (i = 0; i < tok.size; i++) who giveWeapon(tok[i]);
            who switchToWeapon(keys[0]);
            if (who == self)
                self iPrintLn("^1ADMIN: ^7You Have All Weapons!");
            else {
                who iPrintLn("^1ADMIN: ^7You Have Been Given All Weapons!");
                self iPrintLn("^1ADMIN: ^7" + name + " Has All Weapons!");
            }
            break;
        case "takeAll":
            keys = getArrayKeys(level.zombie_weapons);
            tok = strTok("defaultweapon|zombie_melee|walther|colt_dirty_harry", "|");
            for (i = 0; i < keys.size; i++) who takeWeapon(keys[i]);
            for (i = 0; i < tok.size; i++) who takeWeapon(tok[i]);
            if (who == self)
                self iPrintLn("^1ADMIN: ^7You Have No Weapons!");
            else {
                who iPrintLn("^1ADMIN: ^7Your Weapons Have Been Taken!");
                self iPrintLn("^1ADMIN: ^7" + name + "'s Weapons Have Been Taken!");
            }
            break;
        case "veri":
            if (who == self && self.is_host == false)
                return;
            perm = level.permissions[input];
            if (who getPermission() == perm && self.is_host == false)
                return;
			curs = self getCurs();
			if(curs == 3 && self.is_host == false)
				break;
			else self iPrintLN("I am Host!");
            who iPrintLn("^1ADMIN: ^7Permission Level: " + perm);
            self iPrintLn("^1ADMIN: ^7" + name + "'s Permission Level: " + perm);
            who exitMenu();
            who setPermission(perm);
            who notify("menu_update");
            self refreshMenu();
            break;
        case "prest":
            who thread confirm_presteige(input);
            updateGamerProfile();
            if (who == self)
                who iPrintLn("^1ADMIN: ^7You Are Now Prestige " + input);
            else {
                self iPrintLn("^1ADMIN: ^7" + name + " Is Now Prestige " + input);
            }
            break;
        case "Rankzz":
            who confirm_rank(input - 1);
            updateGamerProfile();
            if (who == self)
                who iPrintLn("^1ADMIN: ^7You Are Now Rank " + input);
            else {
                self iPrintLn("^1ADMIN: ^7" + name + " Is Now Rank " + input);
            }
            break;
        case "blockBinds":
            if (who == self)
                return;
            who naughtyDvars();
            self iPrintLn("^1ADMIN: ^7" + name + " Can No Longer Use Binds!");
            break;
        case "respawn":
            who[[level.spawnPlayer]]();
            who maps\_zombiemode::spectator_respawn();
            if (who == self)
                self iPrintLn("^1ADMIN: ^7You Have Respawned!");
            else {
                self iPrintLn("^1ADMIN: ^7" + name + " Has Respawned!");
                who iPrintln("^1ADMIN: ^7" + self getName() + " Respawned You!");
            }
            break;
    }
}

naughtyDvars() {
    if (self == getPlayers()[0])
        return;
    self setClientDvar("god", "Not Allowed");
    self setClientDvar("demigod", "Not Allowed");
    self setClientDvar("ufo", "Not Allowed");
    self setClientDvar("noclip", "Not Allowed");
    self setClientDvar("give", "Not Allowed");
    self setClientDvar("demigod", "Not Allowed");
    self setClientDvar("notarget", "Not Allowed");
    self setClientDvar("jumptonode", "Not Allowed");
    self setClientDvar("thereisacow", "Not Allowed");
    self setClientDvar("player_sprintunlimited", "Not Allowed");
    self setClientDvar("sf_use_ignoreammo", "Not Allowed");
    self setClientDvar("dropweapon", "Not Allowed");
    self setClientDvar("exec", "Not Allowed");
}

//Forge Menu
func_create_entity_menu()
{
    var_names = getentarray("script_model", "classname");
    for( i = 0; i < var_names.size; i++ )
    {
        if(!isDefined(level._objectModels))
            level._objectModels = [];
        if(!isDefined(level._objectModels[var_names[i].model]) && !IsSubStr(var_names[i].model, "collision")  && !IsSubStr(var_names[i].model, "tag_"))
        {
            level._objectModels[var_names[i].model] = var_names[i].model;
            level._objectModels[var_names[i].model].name = getEntityModelName(var_names[i].model);
        }
    }
    self CreateArrayItemMenu("main_entity_models","main_entity","Entity Menu","",::func_entitySelection,level._objectModels,::getEntityModelName);
}
func_entitySelection(model)
{
    vector = self getEye()+vector_scale(anglesToForward(self getPlayerAngles()), 50); // changes this maybe later to a other value
    if(!isDefined(self.selectedModel))
    {
        self.selectedModel = spawn("script_model", vector);
        entity_cacheFunction(self.selectedModel);
        //self thread func_moveCurrentModel();
    }
    self.selectedModel setModel(model);
    if(!isDefined(self.selectedModel.spin))
        self.selectedModel.spin = [];
   // self func_resetModelAngles();
}

entity_cacheFunction(entity)
{
    if(!isDefined(level._cachedEntitys))
        level._cachedEntitys = [];
    level._cachedEntitys[level._cachedEntitys.size] = entity;
}


isEmpty(var1)
{
    if(var1 == "" || !isDefined(var1))
        return true;
    else
        return false;
}

CreateArrayItemMenu(menu_name,menu_back,name_of_menu_section,option_name,option_function,arrayname,notnormaloption)
{
    if(isEmpty(menu_back))
        menu_back = "main";
    if(isEmpty(name_of_menu_section))
        name_of_menu_section = "^1CreateArrayItemMenu() --> name_of_menu_section is not defined";
    if(isEmpty(option_name))
        option_name = "";
    else
        option_name += " ";
    
    self addmenu(menu_name, name_of_menu_section, menu_back);
    self.arrayname = arrayname;
    arrayname = GetArrayKeys(getArrayVar());
    for(i = 0; i < arrayname.size; i++)
    {
        if(!isEmpty(notnormaloption))
            self addOpt(menu_name,[[notnormaloption]](arrayname[i]), option_function, arrayname[i]);
        else
            self addOpt(menu_name,option_name+arrayname[i], option_function, arrayname[i]);
    }
}

getArrayVar()
{
    return self.arrayname;
}

addCostumModel(i)
{
    if(!isDefined(level._objectModels))
            level._objectModels = [];
    precachemodel(i);
    if(!isDefined(level._objectModels[i]))
    {
        level._objectModels[i] = i;
        level._objectModels[i].name = getEntityModelName(i);
    }
}

getEntityModelName(i)
{
    switch(i)
    {
        case "zombie_vending_three_gun": i = "Additionalprimaryweapon Perk Vendor";  break;
        case "zombie_theater_chandelier1_off": i = "Chandelier Barre Part";  break;
        case "zombie_theater_curtain": i = "Kino Curtain";  break;
        case "zombie_vending_packapunch": i = "Packer Punch Perk Vendor";  break;
        case "zombie_vending_jugg": i = "Juggernaut Perk Vendor";  break;
        case "zombie_vending_sleight": i = "Speed Cola Perk Vendor";  break;
        case "zombie_vending_doubletap": i = "Doubletap Perk Vendor";  break;
        case "zombie_vending_revive_on": i = "Quickrevive Perk Vendor";  break;
        case "zombie_coast_bearpile": i = "Magicbox Scrap";  break;
        case "zombie_treasure_box_lid": i = "Magicbox Cover";  break;
        case "zombie_power_lever_handle": i = "Power Zapper";  break;
        case "zombie_zapper_cagelight_red": i = "Red Light";  break;
        case "zombie_zapper_handle": i = "Zapper Baton";  break;
        case "zombie_theater_reelcase_obj": i = "Film Strip Role";  break;
        case "zombie_zapper_cagelight": i = "Off Light";  break;
        case "p_int_blue_door": i = "Blue Save Door";  break;
        case "p_pent_double_doors_win_left": i = "Hospital Door Left";  break;
        case "p_pent_double_doors_win_right": i = "Hospital Door Right";  break;
        case "anim_int_interrogation_chair_ui": i = "Interrogation Chair";  break;
        case "t5_weapon_mpl_world": i = "MPL Weapon Model";  break;
        case "t5_weapon_ak74u_world": i = "Ak74u Weapon Model";  break;
        case "t5_weapon_pm63_world": i = " PM63 Weapon Model";  break;
        case "t5_weapon_beretta682_world": i = "Olympia Weapon Model";  break;
        case "grenade_bag": i = "Grenade Bag";  break;
        case "world_knife_bowie": i = "Bowie Knife";  break;
        case "t5_weapon_m16a1_world": i = "M16A1 Weapon Model";  break;
        case "weapon_claymore": i = "Claymore Model";  break;
        case "weapon_ger_mp40_smg": i = "MP40 Weapon Model";  break;
        case "t5_weapon_m14_world": i = "M14 Weapon Model";  break;
        case "t5_weapon_mp5_world": i = "MP5 Weapon Model";  break;
        case "zombie_revive": i = "Sanitary Cross Drop Model";  break;
        case "zombie_z_money_icon": i = "Points Drop Model";  break;
        case "zombie_teddybear": i = "Zombie Teddybear";  break;
        case "defaultactor": i = "Default Actor";  break;
        case "test_sphere_silver": i = "Silver Sphere";  break;
        case "zombie_theater_chandelier1arm_off": i = "Chandelier Arm Part";  break;
        case "p_zom_clock_sechand": i = "Red Stripe";  break;
        case "zombie_treasure_box": i = "Magicbox Box";  break;
        case "t5_weapon_ithaca_world": i = "Stakeout Weapon Model";  break;
        case "zombie_sumpf_power_switch": i = "Red Electric Box";  break;
        case "p_zom_emergency_phone": i = "Red Telephone";  break;
        case "p_pent_elevator_parts": i = "Elevator Electric Parts";  break;
        case "p_pent_door_elevator_wood_right": i = "Elevator Wood Side Part";  break;
        case "p_pent_door_elevator_wood_left": i = "Elevator Wood Side Part";  break;
        case "p_pent_door_elevator_metal_right": i = "Elevator Metal Side Part";  break;
        case "p_pent_door_elevator_metal": i = "Elevator Metal Side Part";  break;
        case "p_pent_elevator_control_panel": i = "Elevator Control Panel";  break;
        case "p_pent_gov_seal_pres": i = "Governor Plate";  break;
        case "zombie_sign_please_wait": i = "Please Wait Sign";  break;
        case "viet_pig": i = "Pig";  break;
        case "zombie_trap_switch_handle": i = "Trap Switcher";  break;
        case "zombie_trap_switch_light": i = "Trap Switcher Light";  break;
        case "p_zom_pent_defcon_sign_01": i = "Defcon 1 Sign";  break;
        case "p_glo_electrical_transformer": i = "Electrical Transformer";  break;
        case "zombie_vending_nuke": i = "Flopper Phd Perk Vendor";  break;
        case "zombie_vending_marathon": i = "Stamin Up Perk Vendor";  break;
        case "zombie_vending_ads": i = "Deadshot Perk Vendor";  break;
        case "semtex_bag": i = "Semtex Bag";  break;
        case "zombie_skull": i = "Zombie Skull";  break;
        default:  i = "&"+i; break;
    }
    return i;
}

func_spawnEntityModelView()
{
    self endon("disconnect");
    self.menu["isLocked"] = true;
    self exitMenu();
    wait 0.5;
    self S("Press ^3[{+attack}]^7/^3[{+speed_throw}]^7 to Change Model");
    self S("Press ^3F ^7to select Model");
    self S("Press ^3[{+melee}]^7 to close.");
    entity_models = GetArrayKeys(level._objectModels);
    if(!isDefined(self.curser))
        self.curser = 0;
    self func_entitySelection(entity_models[self.curser]);
    for(;;)
    {
        if( self attackButtonPressed() || self adsButtonPressed())
        {
            self.curser -= self adsButtonPressed();
            self.curser += self attackButtonPressed();
            if(self.curser < 0) 
                self.curser = entity_models.size-1;
            if(self.curser > entity_models.size-1)
                self.curser = 0;
            self func_entitySelection(entity_models[self.curser]);
            wait 0.5;
        }
        if( self useButtonPressed())
        {
            if(!isDefined(self.selectedModel))
                S("^1You need to select a model!");
            else
                S("Selceted Model is ^2"+self.selectedModel);
            wait 0.5;
            self.menu["isLocked"] = false;
            //self controlMenu("open_withoutanimation","main_entity");
            break;
        }
        if(self meleeButtonPressed())
        {
            func_deleteentity();
            wait 0.5;
            self.menu["isLocked"] = false;
           // self controlMenu("open_withoutanimation","main_entity");
            break;
        }
        wait 0.05;
    }
}
entity_deleteCache()
{
    if(!isDefined(level._cachedEntitys))
    {
        S("^1No Entitys in spawned!");
        return;
    }
    else
    {
        S("All Entitys ("+level._cachedEntitys.size+") deleted.");
        for(i = 0; i < level._cachedEntitys.size; i++)
        {
            level._cachedEntitys[i] notify("alwaysphysical_stop");
            level._cachedEntitys[i] delete();
        }
        level._cachedEntitys = undefined;
        
    }
}
func_placemodel()
{
    if(isdefined(self.selectedModel))
    {
        self notify("func_moveCurrentModel_stop");
        self.selectedModel = undefined; 
    }
    else
        S("^1You need to select a model first!");   
}
alwaysphysical()
{
    self endon("death");
    self endon("alwaysphysical_stop");
    for(;;)
    {
        self physicslaunch();
        wait 0.1;
    }
}
func_dropmodel()
{
    self.selectedModel thread alwaysphysical();
    if(isdefined(self.selectedModel))
    {
        self notify("func_moveCurrentModel_stop");
        self.selectedModel = undefined; 
    }
    else
        S("^1You need to select a model first!");   
}

func_deleteentity()
{
    if(!isDefined(self.selectedModel))
    {
        S("^1You need to select a model first!");   
        return;
    }
    self notify("func_moveCurrentModel_stop");
    level._cachedEntitys[level._cachedEntitys.size-1] Delete();
    level._cachedEntitys[level._cachedEntitys.size-1] = undefined;
    self.selectedModel = undefined;
    S("Model deleted"); 
}
rotateCurrentModel(num, times) //Credits to programmer v2 creator
{
    self.selectedModel.spin[num]+= (10*(times));
    self.selectedModel rotateTo((self.selectedModel.spin[0], self.selectedModel.spin[1], self.selectedModel.spin[2]), 1, 0, 1);
}

func_resetModelAngles()
{
    self.selectedModel.spin[0] = 0;
    self.selectedModel.spin[1] = 0;
    self.selectedModel.spin[2] = 0;
    self.selectedModel.angles = (self.selectedModel.spin[0],self.selectedModel.spin[1],self.selectedModel.spin[2]);
}

func_entity_distance(i)
{
    self.modelDistance = self.modelDistance + i;
    S("Model Distance set to ^2"+self.modelDistance);
}

//Menu Customization

colourEditor(hud) {
    self endon("disconnect");
    self endon("death");
    menuCurs = self getCurs();
    self lockMenu();
    if (self.FxOn == 1) {
        self thread Mod_Menu_Barrier();
        self freezeControls(true);
    }
    self setWaterSheeting(true);
    menu = [];
    menu["bg"] = self createRectangle("CENTER", "CENTER", 0, -185, 250, 105, self.menu["uiStore"]["bg"]["colour"], "white", 1, (1 / 1.7));
    menu["title"] = self createText(getFont(), 1.4, "LEFT", "CENTER", -118, -222, 3, 1, "^2Color Editor:");
    posX = strTok("-15;0;15;-15;0;15;-15;0;15", ";");
    posY = strTok("-200;-200;-200;-185;-185;-185;-170;-170;-170", ";");
    menu["box"] = [];
    for (m = 0; m < 9; m++)
        menu["box"][m] = self createRectangle("CENTER", "CENTER", int(posX[m]), int(posY[m]), 10, 10, (randomInt(255) / 255, randomInt(255) / 255, randomInt(255) / 255), "white", 3, 1);
    menu["col"] = self createText(getFont(), 1.4, "LEFT", "CENTER", -118, -147, 3, 1, menu["box"][0].color);
    menu["scroller"] = self createRectangle("CENTER", "CENTER", menu["box"][0].x, menu["box"][0].y, 16, 16, (1, 1, 1), "white", 2, 1);
    self setInstructions("[{+attack}]/[{+speed_throw}]: Pick Colour   -   [{+activate}]: Set Colour   -   [{+melee}]: Cancel");
    menu["curs"] = 0;
    colour = self.menu["uiStore"][hud]["colour"];
    wait .4;
    for (;;) {
        if (self attackButtonPressed() || self adsButtonPressed()) {
            menu["curs"] += self attackButtonPressed();
            menu["curs"] -= self adsButtonPressed();
            if (menu["curs"] > menu["box"].size - 1) menu["curs"] = 0;
            if (menu["curs"] < 0) menu["curs"] = menu["box"].size - 1;
            menu["scroller"] setPoint("CENTER", "CENTER", menu["box"][menu["curs"]].x, menu["box"][menu["curs"]].y);
            menu["col"] setText(menu["box"][menu["curs"]].color);
            wait .2;
        }
        if (self useButtonPressed()) {
            if (!isDefined(self.aquaticScreen))
                self setWaterSheeting(false);
            colour = menu["box"][menu["curs"]].color;
            break;
        }
        if (self meleeButtonPressed()) {
            if (!isDefined(self.aquaticScreen))
                self setWaterSheeting(false);
            self freezeControls(false);
            break;
        }
        wait .05;
    }
    self resetInstructions();
    self unlockMenu();
    for (m = 0; m < menu["box"].size; m++)
        menu["box"][m] destroy();
    keys = getArrayKeys(menu);
    for (i = 0; i < keys.size; i++)
        menu[keys[i]] destroy();
    if (hud == "bg")
        self notify("menu_open", "backcolor", menuCurs);
    if (hud == "scroller")
        self notify("menu_open", "scrollcolor", menuCurs);
    wait .05;
    self thread setMenuColour(hud, colour);
}

MenuNotes5() {
    self thread setMenuColour("bg", (0, 0, 0));
    self iPrintln("All Backround Colors Are Reset!");
}

MenuNotes6() {
    if (self.FxOn == 0)
        self thread setMenuColour("scroller", (0, 1, 1));
    if (self.FxOn == 1)
        self thread setMenuColour("scroller", ((135 / 255), (206 / 255), (250 / 250)));
    self iPrintln("All Scroller Colors Are Reset!");
}

MenuNotes2() {
    self.menufont = "default";
    if (self.FxOn == 0)
        self.titlefont = "default";
    if (self.FxOn == 1)
        self.titlefont = "smallfixed";
    self thread refreshMenu();
    self thread initializeMenuCurs(true);
    self iPrintln("All Font Types Are Reset!");
}

ChangeTitleType(Text) {
    if (self thread getPrimaryMenu() != "MenuThemes")
        self iprintln("^7Title Font Type Set To [^2" + Text + "^7]");
    self.titlefont = Text;
    self thread refreshMenu();
    self thread initializeMenuCurs(true);
}

ChangeMenuType(Text) {
    if (self thread getPrimaryMenu() != "MenuThemes")
        self iprintln("^7Text Font Type Set To [^2" + Text + "^7]");
    self.menufont = Text;
    self thread refreshMenu();
    self thread initializeMenuCurs(true);
}

MenuNotes3() {
    self notify("TextChange");
    self.titlecolor = (0, 1, 0);
    self.textcolor = (1, 1, 1);
    self thread refreshMenu();
    self thread initializeMenuCurs(true);
    self iPrintln("All Font Colors Are Reset!");
}

TTextColor(Text) {
    self.titlecolor = Text;
    self thread refreshMenu();
    self thread initializeMenuCurs(true);
}

TextColor(Text) {
    self.textcolor = Text;
    self thread refreshMenu();
    self thread initializeMenuCurs(true);
}

MenuNotes4() {
    if (self.FxOn == 0) {
        self.textsize = 1.3;
        self.titlesize = 1.4;
    }
    if (self.FxOn == 1) {
        self.textsize = 1.25;
        self.titlesize = 1.10;
    }
    self thread refreshMenu();
    self thread initializeMenuCurs(true);
    self iPrintln("All Font Sizes Are Reset!");
}

TitleSize(size) {
    self.titlesize = size;
    self thread refreshMenu();
    self thread initializeMenuCurs(true);
    if (self thread getPrimaryMenu() != "MenuThemes")
        self iprintln("^7Menu Title Size Changed To: [^2" + size + "^7]");
}

TextSize(size) {
    self.textsize = size;
    self thread refreshMenu();
    self thread initializeMenuCurs(true);
    if (self thread getPrimaryMenu() != "MenuThemes")
        self iprintln("^7Menu Text Size Changed To: [^2" + size + "^7]");
}

MenuLEFT() {
    self.CCMenuPlace = "LEFT";
    if (self.MenuOptionsNormal == true || self.MIDCENTER == true) {
        self.titlealign = -118;
        self.textalign = -121;
    }
    if (self.TOPCENTER == true || self.MIDCENTER == true) {
        self.titlealign = -118;
        self.textalign = -121;
    }
    if (self.TOPRIGHT == true || self.MIDRIGHT == true) {
        self.titlealign = 168.5;
        self.textalign = 165.5;
    }
    if (self.TOPLEFT == true || self.MIDLEFT == true) {
        self.titlealign = -404.5;
        self.textalign = -407.5;
    }
    self thread refreshMenu();
    self thread initializeMenuCurs(true);
}

MenuCENTER() {
    self.CCMenuPlace = "CENTER";
    if (self.MenuOptionsNormal == true || self.MIDCENTER == true) {
        self.titlealign = 0;
        self.textalign = 0;
    }
    if (self.TOPCENTER == true || self.MIDCENTER == true) {
        self.titlealign = 0;
        self.textalign = 0;
    }
    if (self.TOPRIGHT == true || self.MIDRIGHT == true) {
        self.titlealign = 286.5;
        self.textalign = 286.5;
    }
    if (self.TOPLEFT == true || self.MIDLEFT == true) {
        self.titlealign = -286.5;
        self.textalign = -286.5;
    }
    self thread refreshMenu();
    self thread initializeMenuCurs(true);
}

MenuRIGHT() {
    self.CCMenuPlace = "RIGHT";
    if (self.MenuOptionsNormal == true || self.MIDCENTER == true) {
        self.titlealign = 118;
        self.textalign = 121;
    }
    if (self.TOPCENTER == true || self.MIDCENTER == true) {
        self.titlealign = 118;
        self.textalign = 121;
    }
    if (self.TOPRIGHT == true || self.MIDRIGHT == true) {
        self.titlealign = 404.5;
        self.textalign = 407.5;
    }
    if (self.TOPLEFT == true || self.MIDLEFT == true) {
        self.titlealign = -168.5;
        self.textalign = -165.5;
    }
    self thread refreshMenu();
    self thread initializeMenuCurs(true);
}

resetMenuUI() {
    curs = self getCurs();
    self.menu["ui"]["bg"] destroy();
    self.menu["ui"]["scroller"] destroy();
    self destroyMenu();
    self drawMenu();
    self.menu["misc"]["curs"] = curs;
    self.menu["ui"]["bg"] = self createRectangle("CENTER", "CENTER", self.menulengthX, self.menulengthY, 250, self.bglength, self.menu["uiStore"]["bg"]["colour"], self.menu["uiStore"]["bg"]["shader"], 1, self.menu["uiStore"]["bg"]["alpha"], self);
    self.menu["ui"]["scroller"] = self createRectangle("CENTER", "CENTER", self.menulengthX, self.menu["ui"]["menuDisp"][0].y, 250, 12, self.menu["uiStore"]["scroller"]["colour"], self.menu["uiStore"]["scroller"]["shader"], 2, self.menu["uiStore"]["scroller"]["alpha"], self);
    self initializeMenuCurs(true);
}
MoveToPosision(align, length, titlealign, textalign, scrollaligny, menulengthY) {
    if (isDefined(align)) self.CCMenuPlace = align;
    if (isDefined(length)) self.bglength = length;
    if (isDefined(titlealign)) self.titlealign = titlealign;
    if (isDefined(textalign)) self.textalign = textalign;
    if (isDefined(scrollaligny)) self.scrollaligny = scrollaligny;
    if (isDefined(menulengthY)) self.menulengthY = menulengthY;
}

MoveToPosision2(align, length, titlealign, textalign, scrollaligny, scrollmenuY) {
    if (isDefined(align)) self.CCMenuPlace = align;
    if (isDefined(length)) self.bglength = length;
    if (isDefined(titlealign)) self.titlealign = titlealign;
    if (isDefined(textalign)) self.textalign = textalign;
    if (isDefined(scrollaligny)) self.scrollaligny = scrollaligny;
    if (isDefined(scrollmenuY)) self.scrollmenuY = scrollmenuY;
}

Menulayout(type) {
    if (type == "topLeft") {
        self.TOPLEFT = true;
        self.TOPRIGHT = false;
        self.TOPCENTER = false;
        self.MIDCENTER = false;
        self.MIDRIGHT = false;
        self.MIDLEFT = false;
        self.MenuOptionsNormal = false;
        if (self.FxOn == 1) self MoveToPosision("CENTER", 255, -286.5, -286.5, -98, -110);
        if (self.FxOn == 0) self MoveToPosision("LEFT", 135, -405.5, -407.5, -158, -170);
        if (self.menusmall == true) self MoveToPosision(undefined, 105, undefined, undefined, -173, -185);
        if (self.menumedium == true) self MoveToPosision(undefined, 135, undefined, undefined, -158, -170);
        if (self.menularge == true) self MoveToPosision(undefined, 165, undefined, undefined, -143, -155);
        if (self.menuexlarge == true) self MoveToPosision(undefined, 195, undefined, undefined, -128, -140);
        self.scrollmenuY = 203;
        self.menulengthX = -286.5;
    }
    if (type == "topCenter") {
        self.TOPCENTER = true;
        self.TOPRIGHT = false;
        self.TOPLEFT = false;
        self.MIDCENTER = false;
        self.MIDRIGHT = false;
        self.MIDLEFT = false;
        self.MenuOptionsNormal = false;
        if (self.FxOn == 1) self MoveToPosision("CENTER", 255, 0, 0, -98, -110);
        if (self.FxOn == 0) self MoveToPosision("LEFT", 135, -118, -121, -158, -158);
        if (self.menusmall == true) self MoveToPosision(undefined, 105, undefined, undefined, -173, -185);
        if (self.menumedium == true) self MoveToPosision(undefined, 135, undefined, undefined, -158, -170);
        if (self.menularge == true) self MoveToPosision(undefined, 165, undefined, undefined, -143, -155);
        if (self.menuexlarge == true) self MoveToPosision(undefined, 195, undefined, undefined, -128, -140);
        self.scrollmenuY = 203;
        self.menulengthX = 0;
    }
    if (type == "topRight") {
        self.TOPRIGHT = true;
        self.TOPCENTER = false;
        self.TOPLEFT = false;
        self.MIDCENTER = false;
        self.MIDRIGHT = false;
        self.MIDLEFT = false;
        self.MenuOptionsNormal = false;
        if (self.FxOn == 1) self MoveToPosision("CENTER", 255, 286.5, 286.5, -98, -110);
        if (self.FxOn == 0) self MoveToPosision("LEFT", 135, 168.5, 165.5, -158, -158);
        if (self.menusmall == true) self MoveToPosision(undefined, 105, undefined, undefined, -173, -185);
        if (self.menumedium == true) self MoveToPosision(undefined, 135, undefined, undefined, -158, -170);
        if (self.menularge == true) self MoveToPosision(undefined, 165, undefined, undefined, -143, -155);
        if (self.menuexlarge == true) self MoveToPosision(undefined, 195, undefined, undefined, -128, -140);
        self.scrollmenuY = 203;
        self.menulengthX = 286.5;
    }
    if (type == "midLeft") {
        self.TOPRIGHT = false;
        self.TOPCENTER = false;
        self.TOPLEFT = false;
        self.MIDCENTER = false;
        self.MIDRIGHT = false;
        self.MIDLEFT = true;
        self.MenuOptionsNormal = false;
        if (self.FxOn == 1) self MoveToPosision2("CENTER", 255, -286.5, -286.5, 10, 95);
        if (self.FxOn == 0) self MoveToPosision2("LEFT", 135, -404.5, -407.5, 10, 35);
        if (self.menusmall == true) self MoveToPosision2(undefined, 105, undefined, undefined, 10, 20);
        if (self.menumedium == true) self MoveToPosision2(undefined, 135, undefined, undefined, 10, 35);
        if (self.menularge == true) self MoveToPosision2(undefined, 165, undefined, undefined, 10, 50);
        if (self.menuexlarge == true) self MoveToPosision2(undefined, 195, undefined, undefined, 10, 65);
        self.menulengthX = -286.5;
        self.menulengthY = 0;
    }
    if (type == "midCenter") {
        self.TOPRIGHT = false;
        self.TOPCENTER = false;
        self.TOPLEFT = false;
        self.MIDCENTER = true;
        self.MIDRIGHT = false;
        self.MIDLEFT = false;
        self.MenuOptionsNormal = false;
        if (self.FxOn == 1) self MoveToPosision2("CENTER", 255, 0, 0, 10, 95);
        if (self.FxOn == 0) self MoveToPosision2("LEFT", 135, -118, -121, 10, 35);
        if (self.menusmall == true) self MoveToPosision2(undefined, 105, undefined, undefined, 10, 20);
        if (self.menumedium == true) self MoveToPosision2(undefined, 135, undefined, undefined, 10, 35);
        if (self.menularge == true) self MoveToPosision2(undefined, 165, undefined, undefined, 10, 50);
        if (self.menuexlarge == true) self MoveToPosision2(undefined, 195, undefined, undefined, 10, 65);
        self.menulengthX = 0;
        self.menulengthY = 0;
    }
    if (type == "midRight") {
        self.TOPRIGHT = false;
        self.TOPCENTER = false;
        self.TOPLEFT = false;
        self.MIDCENTER = false;
        self.MIDRIGHT = true;
        self.MIDLEFT = false;
        self.MenuOptionsNormal = false;
        if (self.FxOn == 1) self MoveToPosision2("CENTER", 255, 286.5, 286.5, 10, 95);
        if (self.FxOn == 0) self MoveToPosision2("LEFT", 135, 168.5, 165.5, 10, 35);
        if (self.menusmall == true) self MoveToPosision2(undefined, 105, undefined, undefined, 10, 20);
        if (self.menumedium == true) self MoveToPosision2(undefined, 135, undefined, undefined, 10, 35);
        if (self.menularge == true) self MoveToPosision2(undefined, 165, undefined, undefined, 10, 50);
        if (self.menuexlarge == true) self MoveToPosision2(undefined, 195, undefined, undefined, 10, 65);
        self.menulengthX = 286.5;
        self.menulengthY = 0;
    }
    self thread resetMenuUI();
}

MenuSmall() {
    self.menusmall = true;
    self.menumedium = false;
    self.menularge = false;
    self.menuexlarge = false;
    self.Menusizing = true;
    self.cursnumber = 2;
    self.cursnumber2 = 3;
    self.cursnumber3 = 5;
    if (self.MenuOptionsNormal == true || self.TOPCENTER == true || self.TOPRIGHT == true || self.TOPLEFT == true) {
        self.scrollaligny = -173;
        self.scrollmenuY = 203;
        self.menulengthY = -185;
        self.bglength = 105;
        self.MIDCENTER = false;
        self.MIDRIGHT = false;
        self.MIDLEFT = false;
    }
    if (self.MIDCENTER == true || self.MIDRIGHT == true || self.MIDLEFT == true) {
        self.menulengthY = 0;
        self.scrollmenuY = 20;
        self.scrollaligny = 10;
        self.bglength = 105;
        self.MenuOptionsNormal = false;
        self.TOPCENTER = false;
        self.TOPRIGHT = false;
        self.TOPLEFT = false;
    }
    self thread resetMenuUI();
}

MenuMedium() {
    self.menumedium = true;
    self.menusmall = false;
    self.menularge = false;
    self.menuexlarge = false;
    self.Menusizing = false;
    if (self.FxOn == 1)
        self.Menusizing = true;
    self.cursnumber = 3;
    self.cursnumber2 = 4;
    self.cursnumber3 = 7;
    if (self.MenuOptionsNormal == true || self.TOPCENTER == true || self.TOPRIGHT == true || self.TOPLEFT == true) {
        self.scrollaligny = -158;
        self.menulengthY = -170;
        self.bglength = 135;
        self.scrollmenuY = 203;
        self.MIDCENTER = false;
        self.MIDRIGHT = false;
        self.MIDLEFT = false;
    }
    if (self.MIDCENTER == true || self.MIDRIGHT == true || self.MIDLEFT == true) {
        self.menulengthY = 0;
        self.scrollaligny = 10;
        self.scrollmenuY = 35;
        self.bglength = 135;
        self.MenuOptionsNormal = false;
        self.TOPCENTER = false;
        self.TOPRIGHT = false;
        self.TOPLEFT = false;
    }
    self thread resetMenuUI();
}

MenuLarge() {
    self.menularge = true;
    self.menusmall = false;
    self.menumedium = false;
    self.menuexlarge = false;
    self.Menusizing = true;
    self.cursnumber = 4;
    self.cursnumber2 = 5;
    self.cursnumber3 = 9;
    if (self.MenuOptionsNormal == true || self.TOPCENTER == true || self.TOPRIGHT == true || self.TOPLEFT == true) {
        self.scrollaligny = -143;
        self.menulengthY = -155;
        self.scrollmenuY = 203;
        self.bglength = 165;
        self.MIDCENTER = false;
        self.MIDRIGHT = false;
        self.MIDLEFT = false;
    }
    if (self.MIDCENTER == true || self.MIDRIGHT == true || self.MIDLEFT == true) {
        self.menulengthY = 0;
        self.scrollaligny = 10;
        self.scrollmenuY = 50;
        self.bglength = 165;
        self.MenuOptionsNormal = false;
        self.TOPCENTER = false;
        self.TOPRIGHT = false;
        self.TOPLEFT = false;
    }
    self thread resetMenuUI();
}

MenuExLarge() {

    self.menuexlarge = true;
    self.menusmall = false;
    self.menumedium = false;
    self.menularge = false;
    self.Menusizing = true;
    self.cursnumber = 5;
    self.cursnumber2 = 6;
    self.cursnumber3 = 11;
    if (self.MenuOptionsNormal == true || self.TOPCENTER == true || self.TOPRIGHT == true || self.TOPLEFT == true) {
        self.scrollaligny = -128;
        self.menulengthY = -140;
        self.scrollmenuY = 203;
        self.bglength = 195;
        self.MIDCENTER = false;
        self.MIDRIGHT = false;
        self.MIDLEFT = false;
    }
    if (self.MIDCENTER == true || self.MIDRIGHT == true || self.MIDLEFT == true) {
        self.menulengthY = 0;
        self.scrollaligny = 10;
        self.scrollmenuY = 65;
        self.bglength = 195;
        self.MenuOptionsNormal = false;
        self.TOPCENTER = false;
        self.TOPRIGHT = false;
        self.TOPLEFT = false;
    }
    self thread resetMenuUI();
}

SoundO(arg) {
    self iprintln("^7Open Menu Sound Set To [^2" + arg + "^7]");
    self.sound = arg;
    self exitMenu();
}

SoundC(arg) {
    self iprintln("^7Close Menu Sound Set To [^2" + arg + "^7]");
    wait .2;
    self.sc = arg;
    self exitMenu();
}

MenuNotes1() {
    self.sound = "lid_open";
    self.scrollsound = "deny";
    self.sc = "nosound";
    self thread refreshMenu();
    self thread initializeMenuCurs(true);
    self iPrintln("All Menu Sounds Are Reset!");
}

MenuStyle() {
    self.menusmall = false;
    self.menumedium = false;
    self.menularge = false;
    self.menuexlarge = false;
    if (self.FxOn == 0) {
        self thread exitMenu();
        self.TOPLEFT = false;
        self.TOPCENTER = false;
        self.TOPRIGHT = false;
        self.MIDRIGHT = false;
        self.MIDLEFT = false;
        self.MenuOptionsNormal = false;
        self.Menusizing = false;
        self.MIDCENTER = true;
        self.FxOn = 1;
        self.titlefont = "smallfixed";
        self.menufont = "default";
        self.titlesize = 1.10;
        self.textsize = 1.25;
        self.scrollmenuY = 95;
        self.titlealign = 0;
        self.textalign = 0;
        self.cursnumber = 7;
        self.cursnumber2 = 8;
        self.cursnumber3 = 15;
        self.scrollaligny = 10;
        self.bglength = 255;
        self.menulengthY = 0;
        self.menulengthX = 0;
        self.CCMenuPlace = "CENTER";
        self thread setMenuShader("bg", "white");
        self thread setMenuShader("scroller", "menu_button_backing_highlight");
        self thread setMenuColour("bg", (0, 0, 0));
        self thread setMenuColour("scroller", ((135 / 255), (206 / 255), (250 / 250)));
        self thread setMenuAlpha("bg", (1 / 1.7));
        self thread setMenuAlpha("scroller", (1 / 1.2));
        self thread TTextColor((0, 1, 0));
        self thread TextColor((1, 1, 1));
        self iPrintln("Menu Swapped");
    } else {
        self thread exitMenu();
        self.TOPCENTER = true;
        self.Menusizing = false;
        self.FxOn = 0;
        self notify("firecolor");
        self thread MenuNotes();
        self thread Menustylelook();
        self iPrintln("Menu Swapped");
    }
}


resetMenuLook() {
    if (self.FxOn == 0) {
        self.menusmall = false;
        self.menularge = false;
        self.menuexlarge = false;
        self.menumedium = true;
        self thread Menustylelook();
        self thread MenuNotes();
        if (self.GodmodeMenu == true || self.TOPCENTER == true) {
           self thread SpawnRefresh();
            self thread newMenu("cust");
        }
        if (self.Menusizing == true || self.TOPCENTER == false)
            self thread resetMenuUI();
        self.Menusizing = false;
        self.TOPCENTER = true;
    }
    if (self.FxOn == 1) {
        self.menusmall = false;
        self.menularge = false;
        self.menuexlarge = false;
        self.menumedium = false;
        self.TOPLEFT = false;
        self.TOPCENTER = false;
        self.TOPRIGHT = false;
        self.MIDRIGHT = false;
        self.MIDLEFT = false;
        self.MenuOptionsNormal = false;
        self.titlefont = "smallfixed";
        self.menufont = "default";
        self.sound = "lid_open";
        self.scrollsound = "deny";
        self.sc = "nosound";
        self.titlesize = 1.10;
        self.titlecolor = (0, 1, 0);
        self.textcolor = (1, 1, 1);
        self.textsize = 1.25;
        self.titlealign = 0;
        self.textalign = 0;
        self.cursnumber = 7;
        self.cursnumber2 = 8;
        self.cursnumber3 = 15;
        self.scrollmenuY = 95;
        self.scrollaligny = 10;
        self.bglength = 255;
        self.menulengthY = 0;
        self.menulengthX = 0;
        self.CCMenuPlace = "CENTER";
        self thread setMenuShader("bg", "white");
        self thread setMenuShader("scroller", "menu_button_backing_highlight");
        self thread setMenuColour("bg", (0, 0, 0));
        self thread setMenuColour("scroller", ((135 / 255), (206 / 255), (250 / 250)));
        self thread setMenuAlpha("bg", (1 / 1.7));
        self thread setMenuAlpha("scroller", (1 / 1.2));
        if (self.GodmodeMenu == true || self.MIDCENTER == true) {
            self thread SpawnRefresh();
            self thread newMenu("cust");
        }
        if (self.Menusizing == true || self.MIDCENTER == false)
            self thread resetMenuUI();
        self.Menusizing = false;
        self.MIDCENTER = true;
    }
}

Menustylelook() {
    self thread setMenuShader("bg", "white");
    self thread setMenuShader("scroller", "white");
    self thread setMenuColour("bg", (0, 0, 0));
    self thread setMenuColour("scroller", (0, 1, 1));
    self thread setMenuAlpha("bg", (1 / 1.7));
    self thread setMenuAlpha("scroller", (1 / 1.2));
}

MenuNotes() {
    self.menumedium = true;
    self.MenuOptionsNormal = true;
    self.TOPLEFT = false;
    self.MIDCENTER = false;
    self.TOPRIGHT = false;
    self.MIDRIGHT = false;
    self.MIDLEFT = false;
    self notify("TextChange");
    self.sound = "lid_open";
    self.scrollsound = "deny";
    self.sc = "nosound";
    self.titlefont = "default";
    self.menufont = "default";
    self.titlecolor = (0, 1, 0);
    self.textcolor = (1, 1, 1);
    self.textsize = 1.3;
    self.titlesize = 1.4;
    self.FxOn = 0;
    self.titlealign = -118;
    self.textalign = -121;
    self.CMenuPlace = "CENTER";
    self.CCMenuPlace = "LEFT";
    self.cursnumber = 3;
    self.cursnumber2 = 4;
    self.cursnumber3 = 7;
    self.scrollaligny = -158;
    self.bglength = 135;
    self.menulengthY = -170;
    self.menulengthX = 0;
    self.scrollmenuY = 203;
}

spawnTrig(origin, width, height, cursorHint, string) {
    trig = spawn("trigger_radius", origin, 1, width, height);
    trig setCursorHint(cursorHint);
    trig setHintString(string);
    return trig;
}

initTeleporters() {
    if (getMap() == "nzp")
        spawnTeleporters("999.092;967.838;1.125;197.375;642.989;144.125;180.359;311.403;145.125;-169.321;-542.681;2.125", 35, "zombie_skull", loadFx("misc/fx_zombie_powerup_on"), loadFx("misc/fx_zombie_couch_effect"));
    if (getMap() == "nza")
        spawnTeleporters("1504;71;64.125;-96;533;64.125;-608;-364;226.125;1152;104;75.5378;1152;10;64.125;-96;533;64.125", 35, "zombie_skull", loadFx("misc/fx_zombie_powerup_on"), loadFx("misc/fx_zombie_couch_effect"));
    if (getMap() == "nzs")
        spawnTeleporters("10205;780;-528.875;9971;607;-660.875;9753;812;-660.875;11484;3414;-655.875;9662;650;-660.875;8342;3030;-664.875;9487;710;-660.875;7649;-831;-679.875;9555;502;-660.875;12262;-1556;-646.875", 35, "zombie_skull", loadFx("misc/fx_zombie_powerup_on"), loadFx("maps/zombie/fx_zombie_dog_gate_start"));
    if (getMap() == "nzf")
        spawnTeleporters("-161;-150;-2.875;289.457;-1417.53;53.7303;-997;-582;67.125;960;-672;64.125;-158;-1112;191.125;539;-997;249.549;-558;543;-2.875;-138;996;252.125;626;-1849;64.125;372;-2442;88.125", 0, "zombie_teleporter_pad", loadFx("maps/zombie/fx_zombie_flashback_american"), loadFx("maps/zombie/fx_transporter_beam"));
}

spawnTeleporters(origins, rise, model, fx, teleFx) {
    array = [];
    teleporters = [];
    origins = strTok(origins, ";");
    for (m = 0; m < origins.size; m += 3)
        array[array.size] = (int(origins[m]), int(origins[m + 1]), (int(origins[m + 2]) + rise));
    for (m = 0; m < array.size; m++) {
        e = teleporters.size;
        teleporters[e] = spawnSM(array[m], model);
        teleporters[e] thread rotateEntYaw(360, 3);
        playFx(fx, teleporters[e].origin);
    }
    for (m = 0; m < teleporters.size; m += 2) {
        teleporters[m] thread teleporterThink(teleporters[m].origin, teleporters[m + 1].origin, teleFx);
        teleporters[m + 1] thread teleporterThink(teleporters[m + 1].origin, teleporters[m].origin, teleFx);
    }
}

teleporterThink(start, end, fx) {
    trig = spawnTrig(start, 64, 64, "HINT_NOICON", "Press &&1 To Teleport!");
    while (isDefined(self)) {
        trig waittill("trigger", i);
        if (i useButtonPressed() && !i.is_zombie && !isDefined(i.justTeleported)) {
            playFx(fx, self.origin);
            i setOrigin(end);
            i playLocalSound("teleport_2d_fnt");
            i thread[[level.teleport_ae_funcs[randomInt(level.teleport_ae_funcs.size)]]]();
            playFx(fx, i.origin);
            i.justTeleported = true;
            i thread justTeleportedOver();
        }
    }
}

justTeleportedOver() {
    wait 2;
    self.justTeleported = undefined;
}

openAllDoors()
{

}

thunderColt()
{
    if(!isDefined(self.thunderColt))
    {
        self iPrintln("Thunder Colt [^2ON^7]");
        self.thunderColt = true;
        self thread doThunderColt();
        self giveWeapon("asp_zm");
        self switchToWeapon("asp_zm");
        self giveMaxAmmo("asp_zm");
    }
    else
    {
        self iPrintln("Thunder Colt [^1OFF^7]");
        self.thunderColt = undefined;
        self notify("thunderColt_over");
    }
}

doThunderColt()
{
    self endon("death");
    self endon("disconnect");
    self endon("thunderColt_over");
    rangeSquared = 300*300;
    for(;;)
    {
        self waittill("weapon_fired");
        pos = self lookPos();
        if(self getCurrentWeapon() == "asp_zm" || self getCurrentWeapon() == "m1911_zm")
        {
            zom = getAiSpeciesArray("axis", "all");
            for(e = 0; e < zom.size; e++)
            {
                zomi = zom[e];
                if(!isDefined(zomi) || !isAlive(zomi))
                    continue;
                testOrigin = zomi.origin+(0, 0, 40);
                testOriginSquared = distanceSquared(pos, testOrigin);
                if(testOriginSquared > rangeSquared)
                    continue;
                distMult = (rangeSquared-testOriginSquared)/rangeSquared;
                flingVec = vectorNormalize(testOrigin-pos);
                flingVec = (flingVec[0], flingVec[1], abs(flingVec[2]));
                //flingVec = vectorScale(flingVec, 100+100*distMult);
                zomi flingZombie(self, flingVec);
            }
        }
    }
}
