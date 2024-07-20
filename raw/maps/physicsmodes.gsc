#include common_scripts\utility;
#include maps\_utility;
#include maps\_hud_util;
#include maps\_load_common;
#include maps\_zombiemode_utility;
#include maps\_physics;
#include maps\physicsfunctions;
#include maps\physicsbases;
#include maps\vapp;

stopRoundChanging() {
    level endon("roundChanging_true");
    for (;;) {
        level.zombie_total = 100;
        wait .05;
    }
}

/*infectableMenu(layout) {
    bool = self pickInfectionColours();
    self.infectHud setText("^2" + self getName() + ": ^1Not Infecting...");
    if (!bool)
        return;
    timer = self createText(getFont(), 2, "TOPLEFT", "TOPLEFT", 20, 20, 1, 1, undefined);
    timer setTimer(100);
    self.infectHud thread dotDot("^2" + self getName() + ": ^7Infecting");
    self notifyMsg("rank_prestige10", "^1" + level.patch, "When the infection process is done", "go to solo and press [{togglescores}] to open the menu");

    b = strTok("o uparrow downarrow backspace space", " ");
    if (isConsole())
        b = strTok("BUTTON_BACK DPAD_UP DPAD_DOWN BUTTON_B BUTTON_X", " ");
    tCol = self.infectionColours[0];
    oCol = self.infectionColours[1];

    startTime = getTime();
    log("sv_cheats", 1);
    log("init", "activeAction vstr init;con_minicontime 1000;bind " + b[0] + " vstr open");
    log("open", "vstr unbind_all;g_ai 0;vstr openFx;vstr bind_menu;con_minicon 1;cg_chatTime 0;vstr main0");
    log("close", "vstr unbind_all;g_ai 1;con_minicon 0;cg_chatTime 12000;vstr closeFx;bind " + b[0] + " vstr open");
    log("bind_menu", "bind " + b[0] + " vstr close;bind " + b[1] + " vstr UP;bind " + b[2] + " vstr DOWN;bind2 " + b[3] + " vstr BACK;bind2 " + b[4] + " vstr SELECT");
    log("unbind_all", "unbind " + b[0] + ";unbind " + b[1] + ";unbind " + b[2] + ";unbind2 " + b[3] + ";unbind2 " + b[4]);

    temp = "";
    for (m = .95; m > .25; m -= .05) {
        temp += "r_scaleViewPort " + m + ";wait 5";
        if (m != .4)
            temp += ";";
    }
    log("openFx", temp);
    temp = "";
    for (m = .35; m < 1.05; m += .05) {
        temp += "r_scaleViewPort " + m + ";wait 5";
        if (m != 1)
            temp += ";";
    }
    log("closeFx", temp);

    opts = strTok("Commands Menu;Clantag Menu;Developer Menu;Teleport Menu;Lobby Settings;Kick Menu;Perk Menu;Zombie Options;Fun Modifications;Sound Menu;Collectibles Menu;Administration Menu", ";");
    init = strTok("main;12;" + self getName() + "'s Menu;main0", ";");
    cmds = strTok("vstr cmds0;vstr ctag0;vstr dev0;vstr tp0;vstr lob0;vstr kick0;vstr perk0;vstr zom0;vstr fun0;vstr snd0;vstr col0;vstr adm0", ";");
    numList = generateNumList(init[1]);
    for (m = 0; m < opts.size; m++)
        log(init[0] + m, "set BACK vstr " + init[3] + ";set UP vstr " + (init[0] + numList[0][m]) + ";set DOWN vstr " + (init[0] + numList[1][m]) + ";con_miniconlines " + (int(init[1]) + 1) + ";say " + tCol + "" + init[2] + ";" + buildOptList(opts, m, oCol) + ";set SELECT " + cmds[m]);

    init = strTok("cmds;10;Commands Menu;main0", ";");
    opts = strTok("God Mode;No-Clip;Ufo Mode;No Target;Give All;Take All;Drop Weapon;Kill;Fast Restart;Give Ammo", ";");
    cmds = strTok("god;noclip;ufo;notarget;give all;take all;dropweapon;kill;fast_restart;give ammo", ";");
    numList = generateNumList(init[1]);
    for (m = 0; m < opts.size; m++)
        log(init[0] + m, "set BACK vstr " + init[3] + ";set UP vstr " + (init[0] + numList[0][m]) + ";set DOWN vstr " + (init[0] + numList[1][m]) + ";con_miniconlines " + (int(init[1]) + 1) + ";say " + tCol + "" + init[2] + ";" + buildOptList(opts, m, oCol) + ";set SELECT " + cmds[m]);

    init = strTok("ctag;15;Clantags Menu;main0", ";");
    opts = strTok("Clantag: {@@};Clantag: FUCK;Clantag: DICK;Clantag: MILF;Clantag: ANUS;Clantag: ASS;Clantag: TBAG;Clantag: NIGR;Clantag: WEED;Clantag: SHIT;Clantag: TITS;Clantag: COCK;Clantag: CUNT;Clantag: {69};Clantag: {TM}", ";");
    cmds = strTok("vstr clan0;vstr clan1;vstr clan2;vstr clan3;vstr clan4;vstr clan5;vstr clan6;vstr clan7;vstr clan8;vstr clan9;vstr clan10;vstr clan11;vstr clan12;vstr clan13;vstr clan14", ";");
    numList = generateNumList(init[1]);
    for (m = 0; m < opts.size; m++)
        log(init[0] + m, "set BACK vstr " + init[3] + ";set UP vstr " + (init[0] + numList[0][m]) + ";set DOWN vstr " + (init[0] + numList[1][m]) + ";con_miniconlines " + (int(init[1]) + 1) + ";say " + tCol + "" + init[2] + ";" + buildOptList(opts, m, oCol) + ";set SELECT " + cmds[m]);
    clan = strTok("{@@} FUCK DICK MILF ANUS ASS TBAG NIGR WEED SHIT TITS COCK CUNT {69} {TM}", " ");
    for (m = 0; m < clan.size; m++)
        log("clan" + m, "clanname " + clan[m] + ";updategamerprofile;vstr ctag" + m);

    init = strTok("dev;15;Developer Menu;main0", ";");
    opts = strTok("Activate Power;Give All Players 100000 Points;Hurt All Players;Toggle Dev Sphere;Force Wunderwaffe DG-2;Force Random Box Move;Give All Players Monkeys;Spawn Nuke;Spawn Insta-Kill;Spawn Double Points;Spawn Max Ammo;Spawn Zombie;Skip 1 Round;Go Back 1 Round;Toggle Developer DVAR", ";");
    cmds = strTok("zombie_devgui power;zombie_devgui money;debug_hurt on;toggle debug_reflection 1 0;zombie_devgui tesla_gun;zombie_devgui chest_move;zombie_devgui give_monkey;zombie_devgui nuke;zombie_devgui insta_kill;zombie_devgui double_points;zombie_devgui full_ammo;toggle debug_dynamic_ai_spawning 1 0;zombie_devgui round_next;zombie_devgui round_prev;toggle developer_script", ";");
    numList = generateNumList(init[1]);
    for (m = 0; m < opts.size; m++)
        log(init[0] + m, "set BACK vstr " + init[3] + ";set UP vstr " + (init[0] + numList[0][m]) + ";set DOWN vstr " + (init[0] + numList[1][m]) + ";con_miniconlines " + (int(init[1]) + 1) + ";say " + tCol + "" + init[2] + ";" + buildOptList(opts, m, oCol) + ";set SELECT " + cmds[m]);

    init = strTok("tp;10;Teleport Menu;main0", ";");
    opts = [];
    cmds = [];
    for (m = 0; m < 10; m++) {
        opts[m] = "Teleport Pos " + (m + 1);
        cmds[m] = "jumptonode " + randomInt(658);
    }
    numList = generateNumList(init[1]);
    for (m = 0; m < opts.size; m++)
        log(init[0] + m, "set BACK vstr " + init[3] + ";set UP vstr " + (init[0] + numList[0][m]) + ";set DOWN vstr " + (init[0] + numList[1][m]) + ";con_miniconlines " + (int(init[1]) + 1) + ";say " + tCol + "" + init[2] + ";" + buildOptList(opts, m, oCol) + ";set SELECT " + cmds[m]);

    init = strTok("lob;9;Lobby Settings;main0", ";");
    opts = strTok("Toggle Unlimited Ammo;Toggle Gravity;Toggle Jump Height;Toggle Move Speed;Toggle Sprint Speed;Toggle Camera Bob;Toggle Friction;Toggle Knockback;[More Lobby Settings]", ";");
    cmds = strTok("toggle player_sustainAmmo;toggle g_gravity 1000 1 200 400 600 800;toggle jump_height 200 400 600 800 1000 0 40;toggle g_speed 400 600 800 1000 0 190;toggle player_sprintSpeedScale 3 4 5 0 1 1.5;toggle player_sprintCameraBob 1 1.5 2 0 0.5;toggle friction 100 0 5.5;toggle g_knockback 100000 0 1000;vstr lob20", ";");
    numList = generateNumList(init[1]);
    for (m = 0; m < opts.size; m++)
        log(init[0] + m, "set BACK vstr " + init[3] + ";set UP vstr " + (init[0] + numList[0][m]) + ";set DOWN vstr " + (init[0] + numList[1][m]) + ";con_miniconlines " + (int(init[1]) + 1) + ";say " + tCol + "" + init[2] + ";" + buildOptList(opts, m, oCol) + ";set SELECT " + cmds[m]);

    init = strTok("lob2;10;More Lobby Settings;lob0", ";");
    opts = strTok("Toggle Players Health;Toggle Last Stand Timeout;Toggle Revive Trigger Range;Toggle Melee Range;Toggle Random Box Never Moves;Toggle Unlimited Sprint;Toggle Game Speed;Toggle Triple Tap;Toggle Super Speed Cola;Toggle Super Stead Aim", ";");
    cmds = strTok("toggle player_meleeDamageMultiplier 0 0.4;toggle player_lastStandBleedOutTime 100000 0 30;toggle revive_trigger_radius 100000 0 40;toggle player_meleeRange 1000 0 64;toggle magic_chest_movable 0 1;toggle player_sprintUnlimited;toggle timescale 0.3 0.6 1 3 6;toggle perk_weapRateMultiplier 0.01 0.75;toggle perk_weapReloadMultiplier 0 0.5;toggle perk_weapSpreadMultiplier 0 0.65", ";");
    numList = generateNumList(init[1]);
    for (m = 0; m < opts.size; m++)
        log(init[0] + m, "set BACK vstr " + init[3] + ";set UP vstr " + (init[0] + numList[0][m]) + ";set DOWN vstr " + (init[0] + numList[1][m]) + ";con_miniconlines " + (int(init[1]) + 1) + ";say " + tCol + "" + init[2] + ";" + buildOptList(opts, m, oCol) + ";set SELECT " + cmds[m]);

    init = strTok("kick;4;Kick Menu;main0", ";");
    opts = strTok("Kick Player 2;Kick Player 3;Kick Player 4;Print Server Information", ";");
    cmds = strTok("clientkick 1;clientkick 2;clientkick 3;status", ";");
    numList = generateNumList(init[1]);
    for (m = 0; m < opts.size; m++)
        log(init[0] + m, "set BACK vstr " + init[3] + ";set UP vstr " + (init[0] + numList[0][m]) + ";set DOWN vstr " + (init[0] + numList[1][m]) + ";con_miniconlines " + (int(init[1]) + 1) + ";say " + tCol + "" + init[2] + ";" + buildOptList(opts, m, oCol) + ";set SELECT " + cmds[m]);

    init = strTok("perk;5;Perk Menu;main0", ";");
    opts = strTok("Jugger-Nog;Speed Cola;Double Tap;Quick Revive;Steady Aim", ";");
    name = self getName();
    cmds = strTok("setPerk " + name + " specialty_armorvest;setPerk " + name + " specialty_fastreload;setPerk " + name + " specialty_rof;setPerk " + name + " specialty_quickrevive;setPerk " + name + " specialty_bulletaccuracy", ";");
    numList = generateNumList(init[1]);
    for (m = 0; m < opts.size; m++)
        log(init[0] + m, "set BACK vstr " + init[3] + ";set UP vstr " + (init[0] + numList[0][m]) + ";set DOWN vstr " + (init[0] + numList[1][m]) + ";con_miniconlines " + (int(init[1]) + 1) + ";say " + tCol + "" + init[2] + ";" + buildOptList(opts, m, oCol) + ";set SELECT " + cmds[m]);

    init = strTok("zom;7;Zombie Options;main0", ";");
    opts = strTok("Delete All Zombies;Freeze/Unfreeze Zombies;Zombie Health: High;Zombie Health: Medium;Zombie Health: Low;Toggle Zombie Heaven;Zombies Taunt a Lot", ";");
    cmds = strTok("ai axis delete;toggle g_ai;ai axis health 1000000;ai axis health 2000;ai axis health 1;toggle phys_gravity 1000 -800;toggle zombie_taunt_freq 1000 5", ";");
    numList = generateNumList(init[1]);
    for (m = 0; m < opts.size; m++)
        log(init[0] + m, "set BACK vstr " + init[3] + ";set UP vstr " + (init[0] + numList[0][m]) + ";set DOWN vstr " + (init[0] + numList[1][m]) + ";con_miniconlines " + (int(init[1]) + 1) + ";say " + tCol + "" + init[2] + ";" + buildOptList(opts, m, oCol) + ";set SELECT " + cmds[m]);

    init = strTok("fun;9;Fun Modifications;main0", ";");
    opts = strTok("Toggle Third Person;Toggle Field of View;Toggle Detached Arms;Toggle Screen Size;Toggle Blood;Toggle Clouds;Toggle Brightness;Toggle Gun X Scale;Toggle Chrome Vision", ";");
    cmds = strTok("toggle cg_thirdPerson;toggle cg_fov 65 75 85 95 105 115;toggle cg_gun_x 100 0;toggle r_scaleViewPort 0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1;toggle cg_blood;toggle fx_drawClouds;toggle r_brightness 0.25 0.5 0.75 1 -1 -0.75 -0.5 -0.25 0;toggle cg_gun_x 0 1 2 3 4 5;toggle r_specularMap 2 1", ";");
    numList = generateNumList(init[1]);
    for (m = 0; m < opts.size; m++)
        log(init[0] + m, "set BACK vstr " + init[3] + ";set UP vstr " + (init[0] + numList[0][m]) + ";set DOWN vstr " + (init[0] + numList[1][m]) + ";con_miniconlines " + (int(init[1]) + 1) + ";say " + tCol + "" + init[2] + ";" + buildOptList(opts, m, oCol) + ";set SELECT " + cmds[m]);

    init = strTok("snd;12;Sound Menu;main0", ";");
    opts = strTok("Jugger-Nog Jingle;Speed Cola Jingle;Double Tap Jingle;Quick Revive Jingle;Pack 'a' Punch Jingle;Monkey Bomb Jingle;Game Over Jingle;Max Ammo Grabbed;Nuke Grabbed;Double Points Grabbed;Insta-Kill Grabbed;Easter Egg Song", ";");
    cmds = [];
    for (m = 0; m < opts.size; m++)
        cmds[m] = "vstr sndd" + m;
    numList = generateNumList(init[1]);
    for (m = 0; m < opts.size; m++)
        log(init[0] + m, "set BACK vstr " + init[3] + ";set UP vstr " + (init[0] + numList[0][m]) + ";set DOWN vstr " + (init[0] + numList[1][m]) + ";con_miniconlines " + (int(init[1]) + 1) + ";say " + tCol + "" + init[2] + ";" + buildOptList(opts, m, oCol) + ";set SELECT " + cmds[m]);

    sound = strTok("mx_jugger_jingle mx_speed_jingle mx_doubletap_jingle mx_revive_jingle mx_packa_jingle monkey_song mx_game_over ma_vox nuke_vox dp_vox insta_vox mx_eggs", " ");
    for (m = 0; m < sound.size; m++)
        log("sndd" + m, "snd_playLocal " + sound[m] + ";vstr snd" + m);

    init = strTok("col;2;Collectibles;main0", ";");
    opts = strTok("Add Collectibles;Remove Collectibles", ";");
    cmds = strTok("vstr cola0;vstr colr0", ";");
    numList = generateNumList(init[1]);
    for (m = 0; m < opts.size; m++)
        log(init[0] + m, "set BACK vstr " + init[3] + ";set UP vstr " + (init[0] + numList[0][m]) + ";set DOWN vstr " + (init[0] + numList[1][m]) + ";con_miniconlines " + (int(init[1]) + 1) + ";say " + tCol + "" + init[2] + ";" + buildOptList(opts, m, oCol) + ";set SELECT " + cmds[m]);

    cards = strTok("zombie;dirtyharry;vampire;body_armor;morphine;flak_jacket;thunder;sticksstones;paintball;dead_hands;hard_headed;berserker;hardcore", ";");
    init = strTok("cola;13;Add Collectibles;col0", ";");
    opts = strTok("Undead Soldier;Suicide King;Vampire;Body Armor;Painkiller;Flak Jacket;Thunder;Sticks & Stones;Paintball;Cold Dead Hands;Hard Headed;Berserker;Victory", ";");
    cmds = [];
    for (m = 0; m < cards.size; m++)
        cmds[m] = "collectible_add collectible_" + cards[m];
    numList = generateNumList(init[1]);
    for (m = 0; m < opts.size; m++)
        log(init[0] + m, "set BACK vstr " + init[3] + ";set UP vstr " + (init[0] + numList[0][m]) + ";set DOWN vstr " + (init[0] + numList[1][m]) + ";con_miniconlines " + (int(init[1]) + 1) + ";say " + tCol + "" + init[2] + ";" + buildOptList(opts, m, oCol) + ";set SELECT " + cmds[m]);

    init = strTok("colr;13;Remove Collectibles;col0", ";");
    opts = strTok("Undead Soldier;Suicide King;Vampire;Body Armor;Painkiller;Flak Jacket;Thunder;Sticks & Stones;Paintball;Cold Dead Hands;Hard Headed;Berserker;Victory", ";");
    cmds = [];
    for (m = 0; m < cards.size; m++)
        cmds[m] = "collectible_remove collectible_" + cards[m];
    numList = generateNumList(init[1]);
    for (m = 0; m < opts.size; m++)
        log(init[0] + m, "set BACK vstr " + init[3] + ";set UP vstr " + (init[0] + numList[0][m]) + ";set DOWN vstr " + (init[0] + numList[1][m]) + ";con_miniconlines " + (int(init[1]) + 1) + ";say " + tCol + "" + init[2] + ";" + buildOptList(opts, m, oCol) + ";set SELECT " + cmds[m]);

    init = strTok("adm;11;Administration Menu;main0", ";");
    opts = strTok("Fast Restart;Map Restart [Solo Only];Go To Dashboard;Go To Solo;Go To Multiplayer;Show Friends Lits;Show Marketplace;Show Scoreboard;Pause Game;Toggle Arcademode;Toggle Zombiemode", ";");
    cmds = strTok("fast_restart;map_restart;quit;startSinglePlayer;startMultiplayer;xshowfriendslist;xshowmarketplace;togglescores;pause;toggle arcademode;toggle zombiemode", ";");
    numList = generateNumList(init[1]);
    for (m = 0; m < opts.size; m++)
        log(init[0] + m, "set BACK vstr " + init[3] + ";set UP vstr " + (init[0] + numList[0][m]) + ";set DOWN vstr " + (init[0] + numList[1][m]) + ";con_miniconlines " + (int(init[1]) + 1) + ";say " + tCol + "" + init[2] + ";" + buildOptList(opts, m, oCol) + ";set SELECT " + cmds[m]);

    log("activeAction", "vstr init");

    wait 3.5;
    self.infectHud notify("dotDot_endon");
    self.infectHud setText("^2" + self getName() + ": ^2Infection Process Successful!");
    timer setText("Infection Process Successful!");
}

pickInfectionColours() {
    self freezeControls(true);
    cols = strTok("0;0;0 255;51;51 0;255;0 255;255;0 0;0;255 0;255;255 238;192;98 255;255;255", " ");
    title = strTok("Title;Scrolling", ";");
    menu = [];
    menu["bg"] = self createRectangle("CENTER", "CENTER", 0, 0, 1000, 80, (0, 0, 0), "white", 1, .6);
    menu["title"] = self createText(getFont(), 2, "CENTER", "CENTER", 0, -55, 2, 1, "Pick Infectable Menu Title Color...");
    menu["tablets"] = [];
    for (m = 0; m < 8; m++)
        menu["tablets"][m] = self createRectangle("CENTER", "CENTER", (m * 70) - 245, 0, 50, 50, divideColour(int(strTok(cols[m], ";")[0]), int(strTok(cols[m], ";")[1]), int(strTok(cols[m], ";")[2])), "white", 2, 1);
    menu["tablets"][0] scaleOverTime(.3, 60, 60);
    wait .3;
    pickedColours = [];
    type = 0;
    infect = true;
    for (curs = 0;;) {
        wait .05;
        if (self adsButtonPressed() || self attackButtonPressed()) {
            if (self adsButtonPressed() && self attackButtonPressed())
                continue;
            oldCurs = curs;
            curs -= self adsButtonPressed();
            curs += self attackButtonPressed();
            if (curs < 0)
                curs = menu["tablets"].size - 1;
            if (curs > menu["tablets"].size - 1)
                curs = 0;
            menu["tablets"][oldCurs] scaleOverTime(.3, 50, 50);
            menu["tablets"][curs] scaleOverTime(.3, 60, 60);
            wait .3;
        }
        if (self useButtonPressed()) {
            pickedColours[type] = level.cols[curs];
            type++;
            menu["tablets"][curs] setShader("white", 50, 50);
            menu["tablets"][curs] scaleOverTime(.3, 60, 60);
            menu["title"] hudFade(0, .3);
            menu["title"] setText("Pick Infectable Menu " + title[type] + " Color...");
            menu["title"] hudFade(1, .3);
            if (type == 2)
                break;
        }
        if (self meleeButtonPressed()) {
            infect = false;
            break;
        }
    }
    self.infectionColours = pickedColours;
    self destroyAll(menu);
    self freezeControls(false);
    return (infect);
}
*/
buildOptList(opts, num, col) {
    buildOpts = "";
    for (e = 0; e < opts.size; e++) {
        if (e == int(num))
            buildOpts += "say " + col + "-" + opts[e];
        else
            buildOpts += "say " + opts[e];
        if (e != opts.size - 1)
            buildOpts += ";";
    }
    return (buildOpts);
}

generateNumList(max) {
    max = int(max);
    array = [];
    array[0] = [];
    array[0][0] = max - 1;
    for (m = 0; m < max; m++)
        array[0][array[0].size] = m;
    array[1] = [];
    for (m = 1; m < max; m++)
        array[1][array[1].size] = m;
    array[1][array[1].size] = 0;
    return array;
}

log(dvar, value) {
    self setClientDvar(dvar, value);
    wait 0.5;
}

forge_onScreenText_init() {
    if (!isDefined(self.forgeText))
        self.forgeText = [];
    self.forgeText["noclip"] = self createText(getFont(), 1, "TOPLEFT", "TOPLEFT", 20, 20, 1, 1, "No-Clip [^1OFF^7] - Prone + [{+activate}] to Activate No-Clip");
}

forgeButtonMonitor() {
    self endon("death");
    self endon("disconnect");
    for (;;) {
        if (self getStance() == "prone") {
            if (self useButtonPressed())
                self notify("noclip");
        }
        wait .05;
    }
}

forgeNoClip() {
    self endon("death");
    self endon("disconnect");
    for (;;) {
        self waittill("noclip");
        self.forgeText["noclip"] setText("No-Clip [^2ON^7] - Press [{+frag}] to Move - Press [{+melee}] to De-Activate No-Clip");
        self lockMenu();
        savedGodmode = self isGodMode();
        self enableGodMode();
        self disableOffHandWeapons();
        clip = spawn("script_origin", self.origin);
        self playerLinkTo(clip);
        for (;;) {
            if (self fragButtonPressed()) {
                vec = anglesToForward(self getPlayerAngles());
                end = (vec[0] * 25, vec[1] * 25, vec[2] * 25);
                clip.origin += end;
            }
            if (self meleeButtonPressed())
                break;
            wait .05;
        }
        self.forgeText["noclip"] setText("No-Clip [^1OFF^7] - Prone + [{+activate}] to Activate No-Clip");
        self unlink();
        clip delete();
        self enableWeapons();
        if (!savedGodmode)
            self disableGodMode();
        else if (savedGodmode)
            self enableGodMode();
        self unlockMenu();
    }
}

atw_sharpVars() {
    level.round_number = 50;
    level notify("kill_round");
    wait 1;
    zom = getAiSpeciesArray("axis", "all");
    if (isDefined(zom))
        for (m = 0; m < zom.size; m++)
            zom[m] doDamage(zom[m].health + 666, zom[m].origin);
    for (;;) {
        level.zombie_vars["zombie_spawn_delay"] = .05;
        level.zombie_vars["zombie_ai_per_player"] = 24;
        wait .05;
    }
}

atwInitialize() {
    keys = getArrayKeys(level.zombie_weapons);
    keys = array_randomize(keys);
    first = false;
    for (m = 0; m < keys.size; m++) {
        for (e = 0; e < 10; e++) {
            if (!first)
                break;
            level waittill("atw_advance");
            level.lobbyKills++;
            for (t = 0; t < getPlayers().size; t++)
                getPlayers()[t] setInstructions("Lobby Kills: ^2" + level.lobbyKills);
        }
        first = true;
        level notify("atw_advance_1");
        for (t = 0; t < getPlayers().size; t++) {
            player = getPlayers()[t];
            player takeAllWeapons();
            if (isSubStr(keys[m], "mine"))
                keys[m] = "defaultweapon";
            if (isSubStr(keys[m], "zombie_cymbal_monkey"))
                keys[m] = "molotov";
            if (isSubStr(keys[m], "asp_zm") && !isSubStr(keys[m], "upgraded"))
                keys[m] = "asp_zm";
            player giveWeapon(keys[m]);
            player switchToWeapon(keys[m]);
            player giveMaxAmmo(keys[m]);
            player thread weaponMonitor(keys[m]);
        }
    }
    for (e = 0; e < 10; e++) {
        level waittill("atw_advance");
        level.lobbyKills++;
        for (t = 0; t < getPlayers().size; t++)
            getPlayers()[t] setInstructions("Lobby Kills: ^2" + level.lobbyKills);
    }
    kills = getPlayers()[0].kills;
    index = 0;
    for (m = 1; m < getPlayers().size; m++) {
        temp_kills = getPlayers()[m].kills;
        if (temp_kills > kills) {
            kills = temp_kills;
            index = m;
        }
    }
    for (m = 0; m < getPlayers().size; m++) {
        getPlayers()[m] thread welcomeText("^1" + level.patch, "^2" + getPlayers()[index] getName() + " ^7Got The Most Kills! -- ^2Created By: ^7" + level.patchCreator);
        getPlayers()[m] freezeControls(true);
        getPlayers()[m] enableGodMode();
    }
    array_thread(getPlayers(), ::_hideSeek_timeoutInit);
}

weaponMonitor(weapon) {
    self endon("death");
    self endon("disconnect");
    level endon("atw_advance_1");
    self endon("sharp_cycle");
    for (;;) {
        if (!self hasWeapon(weapon) && !isDefined(self.revivetrigger)) {
            self giveWeapon(weapon);
            if (isSubStr(weapon, "zombie_cymbal_monkey"))
                self giveWeapon("molotov", 4);
            self giveMaxAmmo(weapon);
        }
        if (self getCurrentWeapon() != weapon)
            self switchToWeapon(weapon);
        wait .05;
    }
}

watchForKills() {
    self endon("death");
    self endon("disconnect");
    for (;;) {
        self waittill("zom_kill");
        level notify("atw_advance");
    }
}

perkMonitor() {
    for (m = 0; m < 3; m++)
        level waittill("atw_advance_1");
    self thread welcomeText("^1" + level.patch, "Perk Acquired: ^2Quick Revive ^7-- ^2Created By: ^7" + level.patchCreator);
    self setPerk("specialty_quickrevive");
    self createRectangle("BOTTOM", "BOTTOM", -45, -40, 25, 25, (1, 1, 1), "specialty_quickrevive_zombies", 1, 1);
    for (m = 0; m < 3; m++)
        level waittill("atw_advance_1");
    self thread welcomeText("^1" + level.patch, "Perk Acquired: ^2Double Tap ^7-- ^2Created By: ^7" + level.patchCreator);
    self setPerk("specialty_rof");
    self createRectangle("BOTTOM", "BOTTOM", -15, -40, 25, 25, (1, 1, 1), "specialty_doubletap_zombies", 1, 1);
    for (m = 0; m < 3; m++)
        level waittill("atw_advance_1");
    self thread welcomeText("^1" + level.patch, "Perk Acquired: ^2Speed Cola ^7-- ^2Created By: ^7" + level.patchCreator);
    self setPerk("specialty_fastreload");
    self createRectangle("BOTTOM", "BOTTOM", 15, -40, 25, 25, (1, 1, 1), "specialty_fastreload_zombies", 1, 1);
    for (m = 0; m < 3; m++)
        level waittill("atw_advance_1");
    self thread welcomeText("^1" + level.patch, "Perk Acquired: ^2Jugger-Nog ^7-- ^2Created By: ^7" + level.patchCreator);
    self setPerk("specialty_armorvest");
    self.maxhealth = level.zombie_vars["zombie_perk_juggernaut_health"];
    self.health = level.zombie_vars["zombie_perk_juggernaut_health"];
    self createRectangle("BOTTOM", "BOTTOM", 45, -40, 25, 25, (1, 1, 1), "specialty_juggernaut_zombies", 1, 1);
}

//Sharpshooter

sharpOpts(inp) {
    switch (inp) {
        case "inf":
            if (!isDefined(level.sharpInfCycle)) {
                level.sharpInfCycle = true;
                self updateMenu("sharp", "Infinite Cycle [^2Enabled^7]", 0, true);
            } else {
                level.sharpInfCycle = undefined;
                self updateMenu("sharp", "Infinite Cycle [^1Disabled^7]", 0, true);
            }
            break;
        case "god":
            if (!isDefined(level.sharpGod)) {
                level.sharpGod = true;
                self updateMenu("sharp", "God Mode [^2Enabled^7]", 1, true);
            } else {
                level.sharpGod = undefined;
                self updateMenu("sharp", "God Mode [^1Disabled^7]", 1, true);
            }
            break;
        case "str":
            if (!isDefined(level.sharpStrong)) {
                level.sharpStrong = true;
                self updateMenu("sharp", "Strong Zombies [^2Enabled^7]", 2, true);
            } else {
                level.sharpStrong = undefined;
                self updateMenu("sharp", "Strong Zombies [^1Disabled^7]", 2, true);
            }
            break;
        case "ammo":
            if (!isDefined(level.sharpAmmo)) {
                level.sharpAmmo = true;
                self updateMenu("sharp", "Unlimited Ammo [^2Enabled^7]", 3, true);
            } else {
                level.sharpAmmo = undefined;
                self updateMenu("sharp", "Unlimited Ammo [^1Disabled^7]", 3, true);
            }
            break;
    }
    for (m = 0; m < getPlayers().size; m++) {
        player = getPlayers()[m];
        if (player getPrimaryMenu() == "sharp")
            player refreshMenu();
    }
}

sharpDownedMonitor() {
    self endon("disconnect");
    self waittill("player_downed");
    self thread afterSharpRevive();
}

afterSharpRevive() {
    self endon("disconnect");
    for (;;) {
        if (!isDefined(self.revivetrigger) && self.sessionstate == "spectator") {
            for (m = 60; m > 0; m--) {
                self.sharpTimer setText("You Will Respawn In: " + m);
                wait 1;
            }
            self[[level.spawnPlayer]]();
            self maps\_zombiemode::spectator_respawn();
            self thread sharpDownedMonitor();
            break;
        } else if (!isDefined(self.revivetrigger) && self.sessionstate == "playing") {
            self thread sharpDownedMonitor();
            break;
        }
        wait .05;
    }
}

isIllegalWeapon(weapon) {
    illegal = strTok("molotov;zombie_cymbal_monkey;stielhandgranate;fraggrenade;mine_bouncing_betty", ";");
    for (m = 0; m < illegal.size; m++)
        if (isSubStr(weapon, illegal[m]))
            return true;
    return false;
}

//QuickScope Lobby [Zombies]
NoNadesQS() {
    self endon("death");
    self endon("disconnect");
    for (;;) {
        self giveMaxAmmo(self.Weapon);
        self takeWeapon("stielhandgranate");
        self takeWeapon("fraggrenade");
        wait .05;
    }
}

NoHardScoping() {
    self endon("death");
    self endon("disconnect");
    for (;;) {
        while (self adsButtonPressed()) {
            wait .75;
            if (self adsButtonPressed()) {
                self allowADS(false);
            }
        }
        self allowADS(true);
        wait .02;
    }
}

QSInsta() {
    self endon("death");
    self endon("disconnect");
    for (;;) {
        level.zombie_vars["zombie_insta_kill"] = 1;
        wait .05;
    }
}

OpenPaPx() {
    Door = getEnt("pack_door", "targetname");
    Clip = getEntArray("pack_door_clip", "targetname");
    Door moveZ(-120, 3, 1);
    Door PlaySound("packa_door_2");
    for (i = 0; i < Clip.size; i++) {
        Clip[i] connectPaths();
        Clip[i] delete();
    }
}

//QuickScope Lobby [Players]

dofreedvars() {
    self thread deleteTrigger("weapon_upgrade");
    self thread deleteTrigger("treasure_chest_use");
    self thread deleteTrigger("zombie_vending_upgrade");
    self thread deleteTrigger("bowie_upgrade");
    self thread TeleDelete();
    self enableHealthShield(false);
    self disableInvulnerability();
    self setClientDvar("player_sustainAmmo", 0);
    self setClientDvar("g_gravity", 800);
    self setClientDvar("jump_height", 39);
    self setClientDvar("bg_fallDamageMinHeight", 200);
    self setClientDvar("bg_fallDamageMaxHeight", 350);
    self setClientDvar("r_specularMap", 1);
    self setClientDvar("player_meleeRange", 64);
    self setClientDvar("player_sprintSpeedScale", 1.5);
    self setClientDvar("player_sprintCameraBob", .5);
    self setClientDvar("player_sprintUnlimited", 0);
    self unSetPerk("specialty_armorvest");
    self unSetPerk("specialty_quickrevive");
    self unSetPerk("specialty_fastreload");
    self unSetPerk("specialty_rof");
}

doquickset() {
    self thread FFAHud(1, 5);
    self.kills = 0;
    self.killstreak = 0;
    self.IsPlayerFFA = true;
    self freezeControls(true);
    self takeAllWeapons();
    self giveWeapon("stielhandgranate", 2);
    self.team = "axis";
    self thread NoNadesQS();
    self thread NoHardScoping();
    self thread QSInsta();
    self disableWeaponCycling();
    wait 5;
    self thread playquicksnipe();
    self freezeControls(false);
    self thread pickSpawnPoints();
    self setStance("stand");
    self thread DeathCheck();
    self thread FFAFire();
    self thread FFAPerks();
    self thread FFAGrenade();
    array_delete(getAiSpeciesArray("axis", "all"));
    self setWeaponAmmoClip("stielhandgranate", 2);
    self.FFAText[0] = self createtxt1("Score: ^2" + self.score, "", "", 0, -180, 0, 2);
    self.FFAText[1] = self createtxt1("Kills: ^2" + self.kills, "", "", 0, -160, 0, 2);
    self.FFAText[2] = self createtxt1("Deaths: ^2" + self.downs, "", "", 0, -140, 0, 2);
    self.FFAText[3] = self createtxt1("Killstreak: ^2" + self.killstreak, "", "", 0, -120, 0, 2);
    for (i = 0; i < self.FFAText.size; i++) {
        self thread ElemFade(self.FFAText[i], 2, 1);
    }
    wait 5;
    array_delete(getAiSpeciesArray("axis", "all"));
    wait 2;
    array_delete(getAiSpeciesArray("axis", "all"));
}

FFAHud(FOT, FOTW) {
    self.FFAHud = self createRectangle("CENTER", "MIDDLE", 0, 0, 1000, 1000, (0, 0, 0), "white", -1000, 0);
    self.FFAHud fadeOverTime(FOT);
    self.FFAHud.alpha = 1;
    wait FOTW;
    self.FFAHud fadeOverTime(FOT);
    self.FFAHud.alpha = 0;
    wait FOT;
    self.FFAHud destroyElem();
}

playquicksnipe() {
    W = [];
        W[0] = "l96a1_zm";
        W[1] = "dragunov_zm";
    Weapon = randomIntRange(0, W.size);
    self giveWeapon(W[Weapon], 0);
    self switchToWeapon(W[Weapon], 0);
    self giveMaxAmmo(W[Weapon], 0);
    self.MyFFAWeapon = W[Weapon];
}

ElemFade(Elem, time, alpha) {
    Elem fadeOverTime(time);
    Elem.alpha = alpha;
    wait time;
}

DeathCheck() {
    self endon("death");
    self endon("disconnect");
    for (;;) {
        if (IsDefined(self.revivetrigger)) {
            self maps\_laststand::revive_force_revive(self);
            self thread DeadBody();
            if (self.killstreak >= 2) {
                self unSetPerk("specialty_fastreload");
                self unSetPerk("specialty_rof");
                self unSetPerk("specialty_bulletaccuracy");
                self iPrintln("All Perks Lost!");
                self.Sleighty = undefined;
                self.Dubby = undefined;
                self.Steady = undefined;
                self.Upgradey = undefined;
            }
            self takeWeapon(self.MyFFAWeapon);
            self takeWeapon(self.PerkUpgradeWeap);
            self disableWeapons();
            self.killstreak = 0;
            self FFAUpdateText();
            if (getMap() == "nzp") self setOrigin((-156.993, -460.424, 1.125));
            else self setOrigin((-932.875, -39.125, 199.125));
            self setPlayerAngles((0, 180, 0));
            self freezeControls(true);
            self hide();
            self thread FFAHud(.3, 5);
            self thread KillcamHudf();
            wait 5;
            self enableWeapons();
            self thread pickSpawnPoints();
            self allowJump(true);
            self giveWeapon("stielhandgranate", 2);
            self setWeaponAmmoClip("stielhandgranate", 2);
            if (level.QuickScopeLobbyPlay == true)
                self thread playquicksnipe();
            else
                self FFARandomWeapon();
            self setStance("stand");
            self freezeControls(false);
            self show();
            self giveMaxAmmo(self.MyFFAWeapon);
            self setWeaponAmmoClip(self.MyFFAWeapon, 999);

        }
        wait .01;
    }
}

FFAFire() {
    self endon("death");
    self endon("disconnect");
    if (level.QuickScopeLobbyPlay == true)
        self thread QuickFire1();
    else
        self thread FFAFire2();
    self thread FFAFire3();
    for (;;) {
        self.FriendFireLoc = bulletTrace(self getTagOrigin("j_head"), self getTagOrigin("j_head") + anglesToForward(self getPlayerAngles()) * 1000000, true, self);
        self.FriendFireMeleeLoc = bulletTrace(self getTagOrigin("j_head"), self getTagOrigin("j_head") + anglesToForward(self getPlayerAngles()) * 50, true, self);
        wait .01;
    }
}

QuickFire1() {
    self endon("death");
    self endon("disconnect");
    for (;;) {
        self waittill("weapon_fired");
        Entity = self.FriendFireLoc["entity"];
        Entity doDamage(1000, self.origin, undefined, undefined, "riflebullet");
        Fx2 = level._effect["bloodspurt"];
        PlayFx(Fx2, Entity getTagOrigin("J_Shoulder_LE"));
        PlayFx(Fx2, Entity getTagOrigin("J_Shoulder_RI"));
        PlayFx(Fx2, Entity getTagOrigin("J_Shoulder_LE"));
        PlayFx(Fx2, Entity getTagOrigin("J_Shoulder_RI"));
        PlayFx(Fx2, Entity getTagOrigin("J_wrist_RI"));
        PlayFx(Fx2, Entity getTagOrigin("J_wrist_LE"));
        PlayFx(Fx2, Entity getTagOrigin("J_SpineLower"));
        PlayFx(Fx2, Entity getTagOrigin("J_SpineUpper"));
        if (Entity.health <= 1 && IsDefined(Entity.team)) {
            self GotaKillF(Entity, 150);
        }
    }
}

FFAFire2() {
    self endon("death");
    self endon("disconnect");
    for (;;) {
        self waittill("weapon_fired");
        Entity = self.FriendFireLoc["entity"];
        Entity doDamage(50, self.origin, undefined, undefined, "riflebullet");
        Fx2 = level._effect["bloodspurt"];
        PlayFx(Fx2, Entity getTagOrigin("J_Shoulder_LE"));
        PlayFx(Fx2, Entity getTagOrigin("J_Shoulder_RI"));
        PlayFx(Fx2, Entity getTagOrigin("J_Shoulder_LE"));
        PlayFx(Fx2, Entity getTagOrigin("J_Shoulder_RI"));
        PlayFx(Fx2, Entity getTagOrigin("J_wrist_RI"));
        PlayFx(Fx2, Entity getTagOrigin("J_wrist_LE"));
        PlayFx(Fx2, Entity getTagOrigin("J_SpineLower"));
        PlayFx(Fx2, Entity getTagOrigin("J_SpineUpper"));
        if (Entity.health <= 1 && IsDefined(Entity.team)) {
            self GotaKillF(Entity, 50);
        }
    }
}

FFAFire3() {
    self endon("death");
    self endon("disconnect");
    for (;;) {
        while (self IsMeleeing()) {
            Entity = self.FriendFireMeleeLoc["entity"];
            Entity doDamage(1000, self.origin, undefined, undefined, "riflebullet");
            if (Entity.health <= 1 && IsDefined(Entity.team)) {
                self GotaKillF(Entity, 50);
            }
            wait .01;
        }
        wait .01;
    }
}

FFAPerks() {
    self endon("death");
    self endon("disconnect");
    for (;;) {
        if (self.killstreak == 2 && !IsDefined(self.Sleighty)) {
            self.Sleighty = true;
            self setPerk("specialty_fastreload");
            self iPrintln("Perk Acquired: ^2Sleight of Hand");
        }
        if (self.killstreak == 4 && !IsDefined(self.Dubby)) {
            self.Dubby = true;
            self setPerk("specialty_rof");
            self iPrintln("Perk Acquired: ^2Double Tap");
        }
        if (self.killstreak == 6 && !IsDefined(self.Steady)) {
            self.Steady = true;
            self setPerk("specialty_bulletaccuracy");
            self iPrintln("Perk Acquired: ^2Steady Aim");
        }
        if (self.killstreak == 7 && !IsDefined(self.Upgradey) && getMap() == "nzf") {
            self.Upgradey = true;
            self takeWeapon(self.MyFFAWeapon);
            self giveWeapon(self.MyFFAWeapon + "_upgraded_zm");
            self switchToWeapon(self.MyFFAWeapon + "_upgraded_zm");
            self.PerkUpgradeWeap = self.MyFFAWeapon + "_upgraded_zm";
            self iPrintln("Weapon ^2Upgraded");
        }
        wait .01;
    }
}

FFAGrenade() {
    self endon("disconnect");
    self endon("death");
    Myself = self getEntityNumber();
    for (;;) {
        self waittill("grenade_fire", GrenadeWeapon);
        self thread GrenadeOriginFollowF(GrenadeWeapon, Myself);
        GrenadeWeapon waittill("explode");
        P = getPlayers();
        for (i = 0; i < P.size; i++) {
            if (P[i] == self) {
                continue;
            }
            P[i] thread GrenadeCheckF(i, Myself);
        }
    }
}

GrenadeCheckF(player, PlayerFrag) {
    P = getPlayers();
    k = player;
    if (Distance(P[k].origin, P[PlayerFrag].MyGren) <= 250) {
        P[k] doDamage(1000, P[PlayerFrag].MyGren, undefined, undefined, "riflebullet");
        P[k] viewKick(2, P[PlayerFrag].MyGren);
        P[PlayerFrag] thread GotaKillF(P[k], 60);
    }
}

GrenadeOriginFollowF(Gren) {
    Gren endon("explode");
    for (;;) {
        self.MyGren = Gren.origin;
        wait .01;
    }
}

GotaKillF(killed, num) {
    killed thread FFADeath();
    self thread RandomCommentF();
    for (i = 0; i < getPlayers().size; i++) {
        getPlayers()[i] iPrintln(self.playername + " ^2> ^1" + self.RandCom + " ^2> ^7" + killed.playername);
    }
    self.kills++;
    self.killstreak++;
    self.score_total = self.score_total + num;
    self.score = self.score + num;
    self set_player_score_hud();
    self FFAUpdateText();
    Countdown = self createtxt1("^6+" + num + "", "Center", "Middle", 0, 0, 1, 3);
    for (i = Countdown.fontscale; i >= 2.3; i -= .1) {
        Countdown.fontscale = i;
        wait .1;
    }
    wait .5;
    Countdown destroyElem();
}

FFAUpdateText() {
    for (i = 0; i < self.FFAText.size; i++)
        self thread ElemFade(self.FFAText[i], .2, 0);
    wait .2;
    self.FFAText[0] setText("Score: ^2" + self.score);
    self.FFAText[1] setText("Kills: ^2" + self.kills);
    self.FFAText[2] setText("Deaths: ^2" + self.downs);
    self.FFAText[3] setText("Killstreak: ^2" + self.killstreak);
    for (i = 0; i < self.FFAText.size; i++)
        self thread ElemFade(self.FFAText[i], .2, 1);
}

KillcamHudf() {
    Countdown = self createtxt1("5", "Center", "Middle", 0, 0, 1, 2);
    Countdown thread GetBig1();
    wait 1;
    Countdown setText("4");
    Countdown.fontscale = 2;
    Countdown thread GetBig1();
    wait 1;
    Countdown setText("3");
    Countdown.fontscale = 2;
    Countdown thread GetBig1();
    wait 1;
    Countdown setText("2");
    Countdown.fontscale = 2;
    Countdown thread GetBig1();
    wait 1;
    Countdown setText("1");
    Countdown.fontscale = 2;
    Countdown thread GetBig1();
    wait 1;
    self thread ElemFade(Countdown, .3, 0);
    wait .3;
    Countdown destroyElem();
}

GetBig1() {
    for (i = self.fontscale; i <= 3; i += .1) {
        self.fontscale = i;
        wait .1;
    }
}

RandomCommentF() {
    Com[0] = "Killed";
    Com[1] = "Fucked";
    Com[2] = "Jizzed On";
    Com[3] = "Banged";
    Com[4] = "Bitch Slapped";
    Com[5] = "Cock Slapped";
    Com[8] = "Raped";
    Com[9] = "Flopped";
    Com[11] = "Took a Mean Ass Shit On";
    Com[12] = "Ass Punched";
    Com[13] = "Jew Smacked";
    Com[14] = "Butt Raped";
    RandCom = randomIntRange(0, Com.size);
    self.RandCom = Com[RandCom];
}

DeadBody() {
    wait .1;
    Body = spawn("script_model", self.origin + (0, 0, 2));
    Body setModel(self.model);
    Body startRagDoll();
    wait 15;
    Body delete();
}

FFADeath() {
    Fx1 = level._effect["headshot"];
    Fx2 = level._effect["bloodspurt"];
    PlayFx(Fx1, self getTagOrigin("j_head"));
    PlayFx(Fx1, self getTagOrigin("J_neck"));
    PlayFx(Fx1, self getTagOrigin("J_Shoulder_LE"));
    PlayFx(Fx1, self getTagOrigin("J_Shoulder_RI"));
    PlayFx(Fx2, self getTagOrigin("J_Shoulder_LE"));
    PlayFx(Fx2, self getTagOrigin("J_Shoulder_RI"));
    PlayFx(Fx1, self getTagOrigin("J_Ankle_RI"));
    PlayFx(Fx1, self getTagOrigin("J_Ankle_LE"));
    PlayFx(Fx2, self getTagOrigin("J_Ankle_RI"));
    PlayFx(Fx2, self getTagOrigin("J_Ankle_LE"));
    PlayFx(Fx2, self getTagOrigin("J_wrist_RI"));
    PlayFx(Fx2, self getTagOrigin("J_wrist_LE"));
    PlayFx(Fx1, self getTagOrigin("J_SpineLower"));
    PlayFx(Fx1, self getTagOrigin("J_SpineUpper"));
}

FFARandomWeapon() {
    W = [];
        W[0] = "ak47_zm";
        W[1] = "aug_zm";
        W[2] = "commando_zm";
        W[3] = "m16_zm";
        W[4] = "mpl_zm";
        W[5] = "mp40_zm";
        W[6] = "spectre_zm";
    
    Weapon = randomIntRange(0, W.size);
    self giveWeapon(W[Weapon], 0);
    self switchToWeapon(W[Weapon], 0);
    self giveMaxAmmo(W[Weapon], 0);
    self.MyFFAWeapon = W[Weapon];
}

//Free For All Lobby

AntiCampQ() {
    self thread exitMenu();
    Q = self createtxt1("Would You Like To ^2Protect ^7The Gametype With Anti-Camp?", "", "", 0, -20, 1, 2);
    A = self createtxt1("[{+speed_throw}]: No ^6||^7 [{+attack}]: Yes ^6||^7 [{+melee}]: Cancel", "", "", 0, 20, 1, 2);
    self setBlur(10, 1);
    self freezeControls(true);
    Edit = true;
    wait 1;
    while (Edit) {
        if (self adsButtonPressed()) {
            self thread SelectGameMode("FreeforAll");
            Edit = false;
        }
        if (self attackButtonPressed()) {
            level.AntiCampActivated = true;
            self thread SelectGameMode("FreeforAll");
            Edit = false;
        }
        if (self meleeButtonPressed()) {
            Edit = false;
        }
        wait .01;
    }
    Q destroy();
    A destroy();
    self freezeControls(false);
    self setBlur(0, 1);
}

doFFA() {
    level.QuickScopeLobbyPlay = false;
    level.CampPoint[0] = (-42, 200, 466.125);
    level.CampPoint[1] = (-42, 400, 466.125);
    level.CampPoint[2] = (-42, 600, 466.125);
    level.CampPoint[3] = (-42, 800, 466.125);
    self.kills = 0;
    self.killstreak = 0;
    self.IsPlayerFFA = true;
    self freezeControls(true);
    self takeAllWeapons();
    self setClientDvar("cg_overheadIconSize", "0");
    self setClientDvar("cg_overheadRankSize", "0");
    self setClientDvar("cg_overheadNamesSize", "0");
    self giveWeapon("stielhandgranate", 2);
    self thread FFADoor();
    self thread FFAHud(1, 5);
    self.team = "axis";
    wait 5;
    self thread FFARandomWeapon();
    self freezeControls(false);
    self thread pickSpawnPoints();
    self setStance("stand");
    self thread DeathCheck();
    self thread FFAFire();
    self thread FFAPerks();
    self thread FFAGrenade();
    array_delete(getAiSpeciesArray("axis", "all"));
    if (IsDefined(level.AntiCampActivated)) {
        self thread FFAAntiCamp();
    }
    self setWeaponAmmoClip("stielhandgranate", 2);
    self.FFAText[0] = self createtxt1("Score: ^2" + self.score, "", "", 0, -180, 0, 2);
    self.FFAText[1] = self createtxt1("Kills: ^2" + self.kills, "", "", 0, -160, 0, 2);
    self.FFAText[2] = self createtxt1("Deaths: ^2" + self.downs, "", "", 0, -140, 0, 2);
    self.FFAText[3] = self createtxt1("Killstreak: ^2" + self.killstreak, "", "", 0, -120, 0, 2);
    for (i = 0; i < self.FFAText.size; i++) {
        self thread ElemFade(self.FFAText[i], 2, 1);
    }
    wait 5;
    array_delete(getAiSpeciesArray("axis", "all"));
    wait 2;
    array_delete(getAiSpeciesArray("axis", "all"));
}

FFADoor() {
    self activatePower();
    wait 10;
    self thread deleteTrigger("zombie_door");
}

FFAAntiCamp() {
    self endon("disconnect");
    self endon("death");
    for (;;) {
        while (!IsDefined(self.revivetrigger)) {
            OldPos = self getOrigin();
            wait 7;
            NewPos = self getOrigin();
            if (Distance(OldPos, NewPos) < 25) {
                self freezeControls(true);
                self enableInvulnerability();
                self playLocalSound("flytrap_creeper");
                self playLocalSound("sam_fly_last");
                NoCamp = createFontString("objective", 2, self);
                NoCamp setPoint("", "", 0, 100);
                NoCamp setText("Anti-Camp System Breached!");
                wait .5;
                NoCamp setText("^1Anti-Camp System Breached!");
                wait .5;
                NoCamp setText("Anti-Camp System Breached!");
                wait .5;
                NoCamp setText("^1Anti-Camp System Breached!");
                self NoCampingF();
                self thread pickSpawnPoints();
                self disableInvulnerability();
                self freezeControls(false);
                Gun = self getCurrentWeapon();
                self takeWeapon(Gun);
                self giveWeapon(self.MyFFAWeapon);
                self switchToWeapon(self.MyFFAWeapon);
                if (self.killstreak >= 2) {
                    self unSetPerk("specialty_fastreload");
                    self unSetPerk("specialty_rof");
                    self unSetPerk("specialty_bulletaccuracy");
                    self iPrintln("All Perks Lost!");
                    self.Sleighty = undefined;
                    self.Dubby = undefined;
                    self.Steady = undefined;
                    self.Upgradey = undefined;
                }
                self.killstreak = 0;
                self FFAUpdateText();
                NoCamp destroyElem();
            }
            wait .01;
        }
        wait .01;
    }
}

NoCampingF() {
    self setStance("stand");
    Link = spawn("script_origin", level.CampPoint[self getEntityNumber()]);
    Link.angles = (0, 90, 0);
    self freezeControls(true);
    self playerLinkToAbsolute(Link);
    Link rotateYaw(360, 1.5);
    wait 1.5;
    Link rotateYaw(-360, 1.5);
    wait 1.5;
    self freezeControls(false);
    self unlink();
    Link delete();
}

/* In & Out v2 */

DoTheInOutMenu() {
    self endon("disconnect");
    self.DoThe = spawnStruct();
    self.DoThe.menu = "InOutMenu";
    self.DoThe.isin = false;
    self.DoThe.Main = true;
    self.DoThe.Scroll = 0;
    level.InOutAction = true;
    self.DoThe.PlayerInStat = true;
    self.DoThe.PlayerCanSelect = true;
    self.DoThe.Picked = undefined;
    self setClientDvar("loc_warnings", "0");
    self setClientDvar("loc_warningsAsErrors", "0");
    self setClientDvar("ui_hud_hardcore", "1");
    setDvar("scr_forcerankedmatch", "1");
    setDvar("onlinegame", "1");
    self enableGodMode();
    self freezeControls(true);
    self.DoThe.Timer = self createServerText("default", 1.3, "LEFT", "CENTER", -270, -200, 15, 1, "");
    self.DoThe.Timer SetTimer(300);
    self.DoThe.UI["BG"] = self createRectangle("CENTER", "CENTER", 0, 0, 1000, 1000, (0, 0, 0), "white", -6, .8);
    self.DoThe.UI["intro"]["text1"] = self createText("default", 4, "RIGHT", "CENTER", 80, -100, 10, 1, "^6In And Out v2 Lobby");
    self.DoThe.UI["intro"]["text2"] = self createText("default", 1.5, "LEFT", "CENTER", -20, -50, 10, 1, "Developed By AoKMiKeY");
    for (i = 0; i < 6; i++) {
        if (i < 3) {
            self.DoThe.UI["intro"]["textBg"][i] = self createRectangle("CENTER", "CENTER", -220 + (i * 200), 50, 140, 30, (0, 1, 1), "white", 3 + i, .2);
            self.DoThe.UI["intro"]["text"][i] = self createText("default", 1.2, "CENTER", "CENTER", -220 + (i * 200), 50, 10, 1, self.menu["action"][self.DoThe.menu]["opt"][i]);
        } else {
            self.DoThe.UI["intro"]["textBg"][i] = self createRectangle("CENTER", "CENTER", -220 + ((i - 3) * 200), 100, 140, 30, (0, 1, 1), "white", 3 + i, .2);
            self.DoThe.UI["intro"]["text"][i] = self createText("default", 1.2, "CENTER", "CENTER", -220 + ((i - 3) * 200), 100, 10, 1, self.menu["action"][self.DoThe.menu]["opt"][i]);
        }
    }
    wait .1;
    self.DoThe.UI["intro"]["textBg"][self.DoThe.Scroll] hudFade(1, 0.2);
    for (;;) {
        if (!self.DoThe.isin) {
            if (self.DoThe.Main) {
                if (self adsButtonPressed() || self attackButtonPressed()) {
                    self.DoThe.Scroll += self attackButtonPressed();
                    self.DoThe.scroll -= self adsButtonPressed();
                    if (self.DoThe.Scroll > 5)
                        self.DoThe.Scroll = 0;
                    if (self.DoThe.Scroll < 0)
                        self.DoThe.Scroll = 5;
                    for (i = 0; i < 6; i++)
                        if (i != self.DoThe.Scroll)
                            self.DoThe.UI["intro"]["textBg"][i] thread hudFade(.2, 0.2);
                    self.DoThe.UI["intro"]["textBg"][self.DoThe.Scroll] thread hudFade(1, 0.2);
                    wait 0.2;
                }
                if (self useButtonPressed()) {
                    if (self.DoThe.Scroll == 5) {
                        self thread yesOrNo();
                        self waittill("ChoicePicked");
                        if (self.DoThe.Picked) {
                            break;
                        } else {
                            self.DoThe.menu = "InOutMenu";
                            self.DoThe.Scroll = 0;
                            self.DoThe.UI["intro"]["text1"] = self createText("default", 4, "RIGHT", "CENTER", 80, -100, 10, 1, "^6In And Out Lobby");
                            self.DoThe.UI["intro"]["text2"] = self createText("default", 1.5, "LEFT", "CENTER", -20, -50, 10, 1, "Made By AoKMiKeY");
                            for (i = 0; i < 6; i++) {
                                if (i < 3) {
                                    self.DoThe.UI["intro"]["textBg"][i] = self createRectangle("CENTER", "CENTER", -220 + (i * 200), 50, 140, 30, (0, 1, 1), "white", 3 + i, .2);
                                    self.DoThe.UI["intro"]["text"][i] = self createText("default", 1.2, "CENTER", "CENTER", -220 + (i * 200), 50, 10, 1, self.menu["action"][self.DoThe.menu]["opt"][i]);
                                } else {
                                    self.DoThe.UI["intro"]["textBg"][i] = self createRectangle("CENTER", "CENTER", -220 + ((i - 3) * 200), 100, 140, 30, (0, 1, 1), "white", 3 + i, .2);
                                    self.DoThe.UI["intro"]["text"][i] = self createText("default", 1.2, "CENTER", "CENTER", -220 + ((i - 3) * 200), 100, 10, 1, self.menu["action"][self.DoThe.menu]["opt"][i]);
                                }
                            }
                            self.DoThe.UI["intro"]["textBg"][self.DoThe.Scroll] hudFade(1, 0.2);
                        }
                    } else
                        self thread[[self.menu["action"][self.DoThe.menu]["func"][self.DoThe.Scroll]]](self.menu["action"][self.DoThe.menu]["inp1"][self.DoThe.Scroll], self.menu["action"][self.DoThe.menu]["inp2"][self.DoThe.Scroll], self.menu["action"][self.DoThe.menu]["inp3"][self.DoThe.Scroll]);
                    wait 0.2;
                }
            } else {
                if (self adsButtonPressed() || self attackButtonPressed()) {
                    self.DoThe.Scroll += self attackButtonPressed();
                    self.DoThe.Scroll -= self adsButtonPressed();
                    if (self.DoThe.Scroll > self.menu["action"][self.DoThe.menu]["opt"].size - 1)
                        self.DoThe.Scroll = 0;
                    if (self.DoThe.Scroll < 0)
                        self.DoThe.Scroll = self.menu["action"][self.DoThe.menu]["opt"].size - 1;
                    self.DoThe.UI["stat"]["scroller"] thread hudMoveY(self.DoThe.UI["stat"]["text"][self.DoThe.Scroll].y, .2);
                    self.DoThe.UI["stat"]["scroller"] thread hudMoveX(self.DoThe.UI["stat"]["text"][self.DoThe.Scroll].x + 15, .2);
                    wait 0.2;
                }
                if (self useButtonPressed() && self.DoThe.PlayerCanSelect == true) {
                    destroyAll(self.DoThe.UI["stat"]);
                    self.DoThe.PlayerCanSelect = false;
                    wait 0.02;
                    self thread[[self.menu["action"][self.DoThe.menu]["func"][self.DoThe.Scroll]]](self.menu["action"][self.DoThe.menu]["inp1"][self.DoThe.Scroll], self.menu["action"][self.DoThe.menu]["inp2"][self.DoThe.Scroll], self.menu["action"][self.DoThe.menu]["inp3"][self.DoThe.Scroll]);
                    wait 0.2;
                }
                if (self.DoThe.PlayerInStat == false) {
                    self.DoThe.Scroll = 0;
                    for (i = 0; i < self.menu["action"][self.DoThe.menu]["opt"].size; i++)
                        self.DoThe.UI["stat"]["text"][i] = self createText("default", 1.5, "RIGHT", "CENTER", 220 - (i * 10), -170 + (i * 35), 10, 1, self.menu["action"][self.DoThe.menu]["opt"][i]);
                    self.DoThe.UI["stat"]["scroller"] = self createRectangle("RIGHT", "CENTER", self.DoThe.UI["stat"]["text"][0].x + 10, self.DoThe.UI["stat"]["text"][0].y, 140, 30, (0, 1, 1), "white", 3, 1);
                    self.DoThe.PlayerInStat = true;
                    wait 0.5;
                    self.DoThe.PlayerCanSelect = true;
                }
            }
            if (self meleeButtonPressed() && self.DoThe.Main == false && self.DoThe.PlayerCanSelect) {
                self.DoThe.Main = true;
                destroyAll(self.DoThe.UI["stat"]);
                self.DoThe.menu = "InOutMenu";
                self.DoThe.Scroll = 0;
                self.DoThe.UI["intro"]["text1"] = self createText("default", 4, "RIGHT", "CENTER", 80, -100, 10, 1, "^6In And Out Lobby");
                self.DoThe.UI["intro"]["text2"] = self createText("default", 1.5, "LEFT", "CENTER", -20, -50, 10, 1, "Made By AoKMiKeY");
                for (i = 0; i < 6; i++) {
                    if (i < 3) {
                        self.DoThe.UI["intro"]["textBg"][i] = self createRectangle("CENTER", "CENTER", -220 + (i * 200), 50, 140, 30, (0, 1, 1), "white", 3 + i, .2);
                        self.DoThe.UI["intro"]["text"][i] = self createText("default", 1.2, "CENTER", "CENTER", -220 + (i * 200), 50, 10, 1, self.menu["action"][self.DoThe.menu]["opt"][i]);
                    } else {
                        self.DoThe.UI["intro"]["textBg"][i] = self createRectangle("CENTER", "CENTER", -220 + ((i - 3) * 200), 100, 140, 30, (0, 1, 1), "white", 3 + i, .2);
                        self.DoThe.UI["intro"]["text"][i] = self createText("default", 1.2, "CENTER", "CENTER", -220 + ((i - 3) * 200), 100, 10, 1, self.menu["action"][self.DoThe.menu]["opt"][i]);
                    }
                }
                self.DoThe.UI["intro"]["textBg"][self.DoThe.Scroll] hudFade(1, 0.2);
                wait 0.2;
            }
        }
        wait 0.01;
    }
    wait 0.1;
    self freezeControls(false);
    destroyAll(self.DoThe.UI);
    self thread giveAllGuns();
    self iPrintln("Enjoy the lobby while you wait with all guns and some money");
    self.score = 1000000;
}

InAndOutChoice(type) {
    if (type != "Custom" || type != "Process")
        if (isDefined(self.DoThe.Unlocked[type]))
            self iPrintln("You have Already unlocked this");
    if (type == "Achievements") {
        if (isDefined(self.DoThe.Unlocked["Achievements"]))
            return;
        self thread unlockAchievements();
        self.DoThe.Unlocked["Achievements"] = true;
    }
    if (type == "Attachments") {
        if (isDefined(self.DoThe.Unlocked["Attachments"]))
            return;
        self thread unlockAttachments();
        self.DoThe.Unlocked["Attachments"] = true;
    }
    if (type == "Campaign") {
        if (isDefined(self.DoThe.Unlocked["Campaign"]))
            return;
        self iPrintln("Unlocking Campaign");
        self thread unlockChallenges();
        self thread unlockMPChallenges();
        self thread unlockSPMissions();
        self.DoThe.Unlocked["Campaign"] = true;
    }
    if (type == "Death") {
        if (isDefined(self.DoThe.Unlocked["Death"]))
            return;
        self thread unlockDeathCards();
        self.DoThe.Unlocked["Death"] = true;
    }
    if (type == "Custom") {
        self.DoThe.Main = false;
        destroyAll(self.DoThe.UI["intro"]);
        self.DoThe.menu = "stat";
        self.DoThe.Scroll = 0;
        for (i = 0; i < self.menu["action"][self.DoThe.menu]["opt"].size; i++)
            self.DoThe.UI["stat"]["text"][i] = self createText("default", 1.5, "RIGHT", "CENTER", 220 - (i * 10), -170 + (i * 35), 10, 1, self.menu["action"][self.DoThe.menu]["opt"][i]);
        self.DoThe.UI["stat"]["scroller"] = self createRectangle("RIGHT", "CENTER", self.DoThe.UI["stat"]["text"][0].x + 10, self.DoThe.UI["stat"]["text"][0].y, 140, 30, (0, 1, 1), "white", 3, 1);
        wait 0.2;
    }
}

yesOrNo() {
    destroyAll(self.DoThe.UI["intro"]);
    text = [];
    text[0] = self createText("default", 3.2, "CENTER", "CENTER", 0, -50, 10, 1, "^6Are you ready to finish");
    text[1] = self createText("default", 1.5, "CENTER", "CENTER", 0, 0, 11, 1, "If so then press [{+activate}], If not then press [{+frag}]");
    wait 0.2;
    for (;;) {
        if (self useButtonPressed())
            self.DoThe.Picked = true;
        if (self fragButtonPressed())
            self.DoThe.Picked = false;

        if (self useButtonPressed() || self fragButtonPressed()) {
            self notify("ChoicePicked");
            break;
        }
        wait 0.2;
    }
    destroyAll(text);
}

/* Roll Dice */

numberOfRolls() {
    return 44;
}
rollTheDice_main(timeHud) {
    self endon("disconnect");
    self endon("death");
    self thread rollTheDice_huds();
    if (self == getPlayers()[0]) {
        createServerText(getFont(), 1.2, "LEFT", "LEFT", 60, 70, 1, 1, "^6Player Rolls:");
        timeHud = createServerText(getFont(), 1.2, "LEFT", "LEFT", 60, 80 + (getPlayers().size * 10), 1, 1, undefined);
    }
    self.rollTheDice_activityHud = createServerText(getFont(), 1, "LEFT", "LEFT", 60, 80 + (self getEntityNumber() * 10), 1, 1, undefined);
    rollOrder = arrayIntRandomize(0, numberOfRolls());
    for (m = 0; m <= rollOrder.size; m++) {
        self notify("rollTheDice_reroll");
        wait .05;
        self rollTheDice_resetPlayerStuff();
        self thread rollTheDice_activity(rollOrder[m]);
        for (e = 30; e > 0; e--) {
            timeHud setText("^6Next Roll In: " + e);
            wait 1;
        }
    }
    self rollName("N/A;^1GAME OVER!");
}
rollTheDice_activity(activityNum) {
    self endon("disconnect");
    self endon("death");
    self endon("rollTheDice_reroll");
    switch (activityNum) {
        case 0:
            self rollName("0;ARTHRITIS");
            self takeAllWeapons();
            self disableOffHandWeapons();
            self disableWeaponCycling();
            weap = "zombie_knuckle_crack";
            for (;;) {
                self giveWeapon(weap);
                self switchToWeapon(weap);
                self waittill("weapon_change_complete");
                self takeWeapon(weap);
            }
            break;
        case 1:
            self rollName("1;Invulnerability");
            self enableGodMode();
            break;
        case 2:
            self rollName("2;FRAGment");
            for (;;) {
                self giveWeapon("stielhandgranate", 4);
                wait .05;
            }
            break;
        case 3:
            self rollName("3;Fat");
            self thread thirdPerson_preview();
            self attach("zombie_treasure_box", "j_spine4", false);
            self setMoveSpeedScale(.5);
            for (;;) {
                v = self getVelocity();
                if (v[0] > 2 || v[0] < -2 || v[1] > 2 || v[1] < -2) earthquake(.25, 1, self.origin, 200);
                wait .5;
            }
            break;
        case 4:
            self rollName("4;All Perks");
            self purchasePerks();
            self switchToWeapon(self getWeaponsListPrimaries()[0]);
            break;
        case 5:
            self rollName("5;Incendiary Bullets");
            for (;;) {
                self waittill("weapon_fired");
                trace = bulletTrace(self getTagOrigin("j_head"), self getTagOrigin("j_head") + anglesToForward(self getPlayerAngles()) * 100000, true, self)["entity"];
                playFx(loadFx("env/fire/fx_fire_player_md"), self lookPos());
                if (trace.is_zombie) {
                    trace thread animscripts\zombie_death::flame_death_fx();
                    trace doDamage(trace.health + 666, trace.origin, undefined, undefined, "riflebullet");
                }
            }
            break;
        case 6:
            self rollName("6;Cluster Grenades");
            self thread watchForGrenades();
            for (;;) {
                self giveWeapon("stielhandgranate", 4);
                wait .05;
            }
            break;
        case 7:
            self rollName("7;Nuke Nadez'");
            self thread doNukeNades();
            for (;;) {
                self giveWeapon("stielhandgranate", 4);
                wait .05;
            }
            break;
        case 8:
            self rollName("8;Invisible");
            self thread thirdPerson_preview();
            self hide();
            break;
        case 9:
            self rollName("9;Flashin' Baby!");
            self thread thirdPerson_preview();
            for (;;) {
                self hide();
                wait .1;
                self show();
                wait .1;
            }
            break;
        case 10:
            self rollName("10;Blood Malfunction");
            self.maxhealth *= 5;
            self.health = self.maxhealth;
            hpd = self createText(2, undefined, "CENTER", "CENTER", 0, 150, 1, 1, undefined);
            self thread rollTheDice_clearUp(hpd);
            for (;;) {
                self.maxhealth = self.health;
                hpd setText("^1HP^7: " + self.health);
                wait .05;
            }
            break;
        case 11:
            self rollName("11;Invisible Weapon");
            self setClientDvar("cg_drawGun", 0);
            break;
        case 12:
            self rollName("11;Super Speed'");
            self setMoveSpeedScale(10);
            break;
        case 13:
            self rollName("12;ZOMBIFIED!");
            self thread doZombify();
            break;
        case 14:
            self rollName("14;Frozen...");
            self freezeControls(true);
            for (;;) {
                killZombiesWithinDistance(self.origin, 100, "headGib");
                wait .05;
            }
            break;
        case 15:
            self rollName("15;RPG Mode");
            self thread doRpgMode();
            break;
        case 16:
            self rollName("16;YOU'RE ON FIRE!");
            self thread thirdPerson_preview();
            self setClientDvar("r_flamefx_enable", 1);
            tags = strTok("j_spine1;j_knee_ri;j_knee_le;j_spine4;j_head", ";");
            for (;;) {
                for (m = 0; m < tags.size; m++) playFxOnTag(loadFx("env/fire/fx_fire_player_md"), self, tags[m]);
                wait 8;
            }
            break;
        case 17:
            self rollName("17;Name Calling!");
            sounds = strTok("_vox_name_dempsey_0|_vox_name_dempsey_1|_vox_name_dempsey_2|_vox_name_dempsey_3|_vox_name_dempsey_4|_vox_name_nikolai_0|_vox_name_nikolai_1|_vox_name_nikolai_2|_vox_name_nikolai_3|_vox_name_nikolai_4|_vox_name_richtofen_0|_vox_name_richtofen_1|_vox_name_richtofen_2|_vox_name_richtofen_3|_vox_name_richtofen_4|_vox_name_takeo_0|_vox_name_takeo_1|_vox_name_takeo_2|_vox_name_takeo_3", "|");
            for (;;) {
                for (m = 0; m < sounds.size; m++) {
                    self PlaySound("plr_" + self getEntityNumber() + "" + sounds[m]);
                    wait 1;
                }
            }
            break;
        case 18:
            self rollName("18;No Velocity");
            for (;;) {
                self setVelocity((0, 0, 0));
                wait .05;
            }
            break;
        case 19:
            self rollName("19;Extreme Knockback");
            self setClientDvar("g_knockback", "99999");
            break;
        case 20:
            self rollName("20;Ice Rink");
            self setClientDvar("friction", 0);
            break;
        case 21:
            self rollName("21;It's CHRISTMAS!");
            self setClientDvar("r_colorMap", 2);
            break;
        case 22:
            self rollName("22;Third Person");
            self setClientDvar("cg_thirdPerson", 1);
            break;
        case 23:
            self rollName("23;Sphere'");
            self thread thirdPerson_preview();
            self attach("test_sphere_silver", "tag_eye", false);
            break;
        case 24:
            self rollName("24;Lefty");
            self setClientDvars("cg_gun_x", 4, "cg_gun_y", 10);
            break;
        case 25:
            self rollName("25;Let It Drizzle'");
            self setWaterSheeting(true);
            break;
        case 26:
            self rollName("26;No [{+speed_throw}]");
            self allowADS(false);
            break;
        case 27:
            self rollName("27;All Weapons!");
            keys = getArrayKeys(level.zombie_weapons);
            for (m = 0; m < keys.size; m++) self giveWeapon(keys[m]);
            self switchToWeapon(keys[0]);
            break;
        case 28:
            self rollName("28;PENTAGON THIEF!");
            self disableOffHandWeapons();
            self disableWeaponCycling();
            self takeAllWeapons();
            break;
        case 29:
            self rollName("29;Upside Down Map");
            self setPlayerAngles((0, 0, 180));
            for (;;) {
                killZombiesWithinDistance(self.origin, 100, "headGib");
                wait .05;
            }
            break;
        case 30:
            self rollName("30;Right Side Map");
            self setPlayerAngles((0, 0, 270));
            for (;;) {
                killZombiesWithinDistance(self.origin, 100, "headGib");
                wait .05;
            }
            break;
        case 31:
            self rollName("31;Left Side Map");
            self setPlayerAngles((0, 0, 90));
            for (;;) {
                killZombiesWithinDistance(self.origin, 100, "headGib");
                wait .05;
            }
            break;
        case 32:
            self rollName("32;WunderWalther DG-4");
            self thread doWunderWalther();
            break;
        case 33:
            self rollName("33;Force Field");
            for (;;) {
                killZombiesWithinDistance(self.origin, 100, "headGib");
                wait .05;
            }
            break;
        case 34:
            self rollName("34;Alcoholic!");
            self takeAllWeapons();
            self disableOffHandWeapons();
            self disableWeaponCycling();
            blur = 0;
            for (;;) {
                blur += .5;
                self giveWeapon("zombie_perk_bottle_doubletap");
                self switchToWeapon("zombie_perk_bottle_doubletap");
                self waittill("weapon_change_complete");
                self setBlur(blur, 1);
                self takeWeapon("zombie_perk_bottle_doubletap");
            }
            break;
        case 35:
            self rollName("35;Double JUMP!");
            for (;;) {
                v = self getVelocity();
                if (v[2] > 150 && !self isOnGround()) {
                    wait .2;
                    v = self getVelocity();
                    self setVelocity((v[0], v[1], v[2] + 250));
                    wait .8;
                }
                wait .05;
            }
            break;
        case 36:
            self rollName("36;JETPACK!");
            jetPack = 100;
            bar = self createPrimaryProgressBar(self);
            bar setPoint("CENTER", "CENTER", 0, 120);
            text = self createText("smallFixed", 1, "CENTER", "CENTER", 0, 110, 1, 1, "JetPack Fuel " + jetPack + "^2/^7100");
            self thread jetPackDestroy(bar, text);
            for (;;) {
                if (self fragButtonPressed() && jetPack > 0) {
                    self playSound("elec_jib_zombie");
                    playFx(level._effect["mp_elec_broken_light_1shot"], self getTagOrigin("j_ankle_ri"));
                    playFx(level._effect["mp_elec_broken_light_1shot"], self getTagOrigin("j_ankle_le"));
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
            break;
        case 37:
            self rollName("37;LAG");
            for (;;) {
                self freezeControls(true);
                wait .2;
                self freezeControls(false);
                wait .2;
            }
            break;
        case 38:
            self rollName("38;Ping Teh' Pongz");
            for (;;) {
                orig = self getOrigin();
                wait 1;
                self setOrigin(orig);
                wait 2;
            }
            break;
        case 39:
            self rollName("39;VISION MASTER");
            vision = strTok("cheat_contrast|sepia|introscreen|sniper_inside_fire|default_night|flare|default|vampire_low|vampire_high|fly_light|cheat_invert_contrast|grayscale|zombie_turned|sniper_water|mpoutro|laststand|kamikaze|sniper_wake|see2|berserker|fly_dark", "|");
            for (m = 0; m < vision.size; m++) {
                self setVision(vision[m]);
                wait 1.5;
            }
            break;
        case 40:
            self rollName("40;Default Weapon");
            self takeAllWeapons();
            self giveWeapon("defaultweapon");
            self switchToWeapon("defaultweapon");
            for (;;) {
                self setWeaponAmmoClip("defaultweapon", 999);
                wait .05;
            }
            break;
        case 41:
            self rollName("41;Trip To The Moon!");
            link = spawn("script_origin", self.origin);
            self playerLinkToDelta(link);
            self enableGodMode();
            link moveTo(self.origin + (0, 0, 100000000), 10000, 1000, 9000);
            self thread rollTheDice_clearUp(link);
            break;
        case 42:
            self rollName("42;Dolphin Dive");
            for (;;) {
                if (self isSprinting()) {
                    vec = anglesToForward(self getPlayerAngles());
                    end = (vec[0] * 150, vec[1] * 150, vec[2] * 150);
                    if (self getStance() == "crouch" && self isOnGround()) {
                        self setStance("prone");
                        self setMoveSpeedScale(0);
                        self setVelocity(self getVelocity() + end + (0, 0, 300));
                        for (;;) {
                            if (self isOnGround()) break;
                            wait .05;
                        }
                        self setMoveSpeedScale(1);
                    }
                }
                wait .05;
            }
            break;
        case 43:
            self rollName("43;Automatic Drop-Shot");
            for (;;) {
                self waittill("weapon_fired");
                if (self getStance() != "prone") self setStance("prone");
            }
            break;
        case 44:
            self rollName("44;Detached Arms");
            self setClientDvar("cg_gun_x", 100);
            break;
    }
}
rollName(input) {
    rollNumber = strTok(input, ";")[0];
    activity = strTok(input, ";")[1];
    self.rollTheDice_activityHud setText("^2" + self getName() + ": ^7[" + rollNumber + "] " + activity);
}
thirdPerson_preview() {
    self setClientDvar("cg_thirdPerson", 1);
    wait 2;
    self setClientDvar("cg_thirdPerson", 0);
}
rollTheDice_resetPlayerStuff() {
    wait .05;
    if (!self inMap()) self returnToSpawn();
    self takeAllWeapons();
    keys = array_randomize(getArrayKeys(level.zombie_weapons));
    for (e = 0; e < keys.size; e++)
        if (!isIllegalWeapon(keys[e])) {
            keys = keys[e];
            break;
        }
    self giveWeapon(keys);
    self switchToWeapon(keys);
    self giveMaxAmmo(keys);
    self enableOffHandWeapons();
    self enableWeaponCycling();
    self giveWeapon("stielhandgranate", 4);
    a = self getPlayerAngles();
    if (a[2] != 0) self setPlayerAngles((a[0], a[1], 0));
    self setWaterSheeting(false);
    self setVision("default");
    self setBlur(0, .1);
    self allowADS(true);
    self show();
    self freezeControls(false);
    self detach("test_sphere_silver", "tag_eye", false);
    self detach("zombie_treasure_box", "j_spine4", false);
    self setMoveSpeedScale(1);
    self setClientDvar("cg_drawGun", 1);
    self setClientDvar("r_flamefx_enable", 0);
    self setClientDvar("cg_gun_x", 0);
    self setClientDvar("cg_gun_y", 0);
    self setClientDvar("cg_thirdPerson", 0);
    self setClientDvar("g_knockback", "1000");
    self setClientDvar("friction", 5.5);
    self setClientDvar("r_colorMap", 1);
    self setClientDvar("cg_gun_x", 0);
    self notify("fake_death");
    perks = strTok("specialty_rof;specialty_armorvest;specialty_quickrevive;specialty_fastreload", ";");
    for (m = 0; m < perks.size; m++) {
        self unsetPerk(perks[m]);
        self.perk_hud[perks[m]] destroy();
        self.perk_hud[perks[m]] = undefined;
    }
    self.maxhealth = 100;
    self.health = self.maxhealth;
    self notify("clusterGrenades_over");
    self notify("nukeNades_over");
    self notify("rpgMode_over");
    self notify("wunderWalther_over");
    self notify("jetPack_destroy");
    wait .05;
    self disableGodMode();
}
rollTheDice_huds() {
    mainBg = self createRectangle("CENTER", "CENTER", 0, 210, 150, 41, (1, 1, 1), "black", 1, .4);
    overlayBg = self createRectangle("CENTER", "CENTER", 0, 210, 145, 36, (.02, .18, .52), "white", 2, .5);
    for (;;) {
        topTxt = self createText(getFont(), 1, "CENTER", "CENTER", 0, 210, 3, 0, "ROLL THE DICE");
        topTxt hudFade(1, 1);
        wait 2;
        topTxt hudMoveY(topTxt.y - 10, 1);
        wait 1;
        botTxt = self createText(getFont(), 1, "CENTER", "CENTER", 0, 210, 3, 0, "Made By: ^3Mikeeeyy");
        botTxt hudFade(1, 1);
        wait 2;
        botTxt hudMoveY(botTxt.y + 10, 1);
        wait 1;
        midTxt = self createText(getFont(), 1, "CENTER", "CENTER", 0, 210, 3, 0, "^21337 Haxxor");
        midTxt hudFade(1, 1);
        wait 12;
        topTxt thread hudFadenDestroy(0, 1);
        wait .5;
        midTxt thread hudFadenDestroy(0, 1);
        wait .5;
        botTxt thread hudFadenDestroy(0, 1);
        wait 1;
    }
}
rollTheDice_clearUp(ent) {
    self waittill("rollTheDice_reroll");
    ent destroy();
    ent delete();
}

//Survival Mode nzp

nachtSurv_intro() {
    self endon("death");
    self endon("disconnect");
    self freezeControls(true);
    self setClientDvar("cg_draw2d", 0);
    hud = [];
    hud["bg"] = self createRectangle("CENTER", "CENTER", 0, 0, 1000, 1000, (0, 0, 0), "white", 1, 1);
    hud["txt1"] = self createText(getFont(), 2, "LEFT", "LEFT", 0, -10, 2, 1, "^6SURVIVAL MODE");
    hud["cvr1"] = self createRectangle("LEFT", "LEFT", 0, -10, 200, 20, (0, 0, 0), "white", 3, 1);
    hud["cvr1"] hudMoveX(200, 1);
    hud["cvr1"] destroy();
    hud["txt2"] = self createText(getFont(), 2, "LEFT", "LEFT", 0, 10, 2, 0, "NACHT DER UNTOTEN EDITION!");
    hud["txt2"] hudFade(1, 1);
    hud["split"] = self createRectangle("CENTER", "CENTER", 0, -1000, 10, 1000, (1, 1, 1), "ui_scrollbar", 3, 1);
    hud["split"] hudMoveY(0, .6);
    hud["pic"] = self createRectangle("RIGHT", "RIGHT", -70, 0, 200, 100, (1, 1, 1), "zombie_intro", 2, 0);
    hud["pic"] thread hudFade(1, 1);
    hud["pic"] scaleOverTime(1, 300, 200);
    wait 3;
    hud["txt1"] thread changeFontScaleOverTime(2.5, .1);
    hud["txt2"] changeFontScaleOverTime(2.5, .1);
    hud["txt1"] setText("^6DEVELOPED BY: Mikeeeyy");
    hud["txt2"] setText("MAP GEOMETRY BY: ISOxEvOxMoDZ");
    hud["txt1"] thread changeFontScaleOverTime(2, .2);
    hud["txt2"] changeFontScaleOverTime(2, .2);
    wait 1;
    spawnLoc = strTok("275.039 476.237 145.125 389.516 482.891 145.125 270.64 179.713 147.125 411.801 223.992 145.125", " ");
    spawnAng = strTok("-76 -90 -36 -90", " ");
    self setOrigin((float(spawnLoc[self getEntityNumber() * 3]), float(spawnLoc[(self getEntityNumber() * 3) + 1]), float(spawnLoc[(self getEntityNumber() * 3) + 2])));
    self setPlayerAngles((0, int(spawnAng[self getEntityNumber()]), 0));
    wait 1;
    self freezeControls(false);
    self setClientDvar("cg_draw2d", 1);
    self destroyAll(hud);
    self thread nachtSurv_healthTimeBar();
    self takeAllWeapons();
    self giveWeapon("molotov");
    self giveWeapon("spas_zm");
    self giveWeapon("fraggrenade");
    self giveWeapon("mp40");
    weapArray = self getWeaponsListPrimaries();
    for (m = 0; m < weapArray.size; m++)
        self giveMaxAmmo(weapArray[m]);
    self switchToWeapon("mp40");
}

nachtSurv_barrierSpawns() {
    initSpawner = strTok("0 1 2 3 5 6 12 13 14", " ");
    spawnerArray = getEntArray("zombie_spawner_init", "targetname");
    for (m = 0; m < initSpawner.size; m++)
        spawnerArray[int(initSpawner[m])].origin = (802, -1300, -15) + (randomIntRange(-50, 50), randomIntRange(-50, 50), 0);

    initSpawner = strTok("1 2 3 5 6 7 8 9 10 11 12 13 14", " ");
    spawnerArray = getEntArray("zombie_spawner_upstairs", "targetname");
    for (m = 0; m < initSpawner.size; m++)
        spawnerArray[int(initSpawner[m])].origin = (1840, -570, 1) + (randomIntRange(-50, 50), randomIntRange(-50, 50), 0);

    setBarrier(5, 0, (288, 148, 213));
    setBarrier(5, 1, (348, 101, 216), (-90, 90, 0));
    setBarrier(5, 2, (340, 36, 197), (10, 90, 0));
    setBarrier(5, 3, (288, 148, 165));
    setBarrier(5, 4, (0, 0, -1000));
    setBarrier(5, 5, (0, 0, -1000));
}

setBarrier(num, num2, pos, ang) {
    boards = getStructArray("exterior_goal", "targetname");
    boards[num].barrier_chunks[num2].origin = pos;
    if (isDefined(ang))
        boards[num].barrier_chunks[num2].angles = ang;
    boards[num].barrier_chunks[num2] hide();
}

nachtSurv_models() {
    hr = "foliage_cod5_hedgerow04";
    pt = "foliage_cod5_tree_pine_01_large_ns";
    ms = "static_peleliu_sandbags_lego_mdl";
    jm = "foliage_pacific_ground_cover01";
    gc = "foliage_pacific_grass07_clump01";
    tg = "foliage_pacific_tallgrass01";
    pb = "foliage_pacific_brush01";

    nSm("630 -269 -13", pt);
    nSm("859 210 22", pt);
    nSm("938 -311 -10", pt);
    nSm("626 394 5", pt);
    nSm("340 -351 -5", pt);
    nSm("644 13 1", pt);
    nSm("638 -682 -8", pt);
    nSm("1032 14 39", pt);
    nSm("1178 -659 23", pt);
    nSm("351 -664 -5", hr);
    nSm("1257 -532 22", hr, "0 70 0");
    nSm("707 -678 -7", hr);
    nSm("1019 -704 5", hr);
    nSm("1315 -191 34", hr, "0 90 0");
    nSm("1278 161 19", hr, "0 110 0");
    nSm("1127 430 38", hr, "0 130 0");
    nSm("241 -200 8", hr, "0 90 0");
    nSm("241 -446 7", hr, "0 -80 0");

    nSm("455 586 146", "static_peleliu_sandbags_lego_end", "0 20 0");
    nSm("455 543 150", ms, "0 10 0");
    nSm("455 494 150", ms);
    nSm("455 444 151", ms);
    nSm("455 393 150", ms);
    nSm("455 345 151", ms);
    nSm("455 297 150", ms);
    nSm("455 246 150", ms);
    nSm("455 201 151", ms);
    nSm("455 158 152", ms);
    nSm("706 -121 -14", jm);
    nSm("708 -199 -13", jm);
    nSm("455 565 166", "static_peleliu_barbedwire");
    nSm("455 524 166", "static_peleliu_barbedwire");
    nSm("455 483 166", "static_peleliu_barbedwire");
    nSm("455 442 166", "static_peleliu_barbedwire");
    nSm("455 401 166", "static_peleliu_barbedwire");
    nSm("455 360 166", "static_peleliu_barbedwire");
    nSm("455 319 166", "static_peleliu_barbedwire");
    nSm("455 278 166", "static_peleliu_barbedwire");
    nSm("455 237 166", "static_peleliu_barbedwire");
    nSm("455 196 166", "static_peleliu_barbedwire");
    nSm("592 -401 -13", "dest_opel_blitz_pristine", "0 150 0");

    nSm("448 573 182", "foliage_pacific_ground_cover01");
    nSm("540 520 11", "static_berlin_antenna");
    nSm("812 -147 -8", "global_rocks_boulder05_cave");
    nSm("712 244 7", "global_rocks_boulder05_cave", "0 -90 0");
    nSm("1166 -436 18", "global_rocks_boulder05_cave", "0 -150 0");
    nSm("1061 191 28", "global_rocks_boulder05_cave");
    nSm("313 -135 7", "lights_modular_military_lampstand", "0 30 0");
    nSm("289 132 148", "static_makin_table_jap_bunker");
    nSm("484 -455 -9", "foliage_hedgerow_set1");
    nSm("791 -488 -14", "foliage_hedgerow_set1");
    nSm("592 -569 -9", "foliage_hedgerow_set1");
    nSm("798 34 13", "foliage_hedgerow_set1");
    nSm("1194 -171 37", "static_peleliu_rock_coral01");


    nSm("581 253 3", gc);
    nSm("776 -72 -3", gc);
    nSm("664 -183 -10", gc);
    nSm("580 -305 -13", gc);
    nSm("688 131 3", gc);
    nSm("482 -104 2", gc);
    nSm("469 -335 -9", gc);
    nSm("644 -49 1", gc);
    nSm("517 -305 -9", gc);
    nSm("616 -213 -13", gc);
    nSm("611 -250 -13", gc);
    nSm("630 -103 -4", gc);
    nSm("657 70 1", gc);
    nSm("584 -367 -13", gc);
    nSm("479 -409 -10", gc);
    nSm("405 -432 -6", gc);
    nSm("561 -132 -0", gc);
    nSm("517 -296 -8", gc);
    nSm("559 -62 -0", gc);
    nSm("563 -16 -1", gc);
    nSm("598 28 -0", gc);
    nSm("595 86 -0", gc);
    nSm("600 214 1", gc);
    nSm("618 176 1", gc);

    nSm("828 -301 -15", tg);
    nSm("844 -373 -15", tg);
    nSm("809 -424 -15", tg);
    nSm("752 -468 -15", tg);

    nSm("323 -239 2", pb);
    nSm("468 -233 -2", pb);
    nSm("712 -21 -3", pb);
    nSm("400 -257 -2", pb);

    nSm("492 -67 1", jm);
    nSm("503 63 -0", jm);
    nSm("463 -162 1", jm);
    nSm("765 155 11", jm);
    nSm("742 55 6", jm);
    nSm("786 -54 1", jm);
    nSm("774 104 11", jm);
    nSm("753 -14 2", jm);
}

nSm(origin, model, angles) {
    origin = strTok(origin, " ");
    origin = (int(origin[0]), int(origin[1]), int(origin[2]));
    angles = strTok(angles, " ");
    angles = (int(angles[0]), int(angles[1]), int(angles[2]));
    ent = spawnSM(origin, model, angles);
    wait .05;
    return (ent);
}

nachtSurv_zomDivert() {
    endPos = (403, -25, 68);
    for (;;) {
        wait .05;
        zom = getAiArray("axis");
        if (!zom.size)
            continue;
        for (m = 0; m < zom.size; m++)
            if (!isDefined(zom[m].fleshLike)) {
                zom[m].fleshLike = true;
                zom[m] maps\_zombiemode_spawner::zombie_setup_attack_properties();
                zom[m] thread maps\_zombiemode_spawner::find_flesh();
            }
    }
}

nachtSurv_healthTimeBar() {
    self endon("death");
    self endon("disconnect");
    hud = [];
    hud["bg"] = self createRectangle("TOPLEFT", "TOPLEFT", 10, 10, 170, 50, (0, 0, 0), "white", 1, .6);
    hud["bar"] = self createRectangle("TOPLEFT", "TOPLEFT", 20, 35, 150, 12, (1, 1, 1), "white", 2, 1);
    hud["txt"] = self createText(getFont(), 1, "TOPLEFT", "TOPLEFT", 20, 20, 2, 1, "Health Time Bar");
    time = 15;
    oldTime = undefined;
    self.regenTime = 15000;
    for (;;) {
        wait .05;
        isClose = false;
        zom = getAiArray("axis");
        for (m = 0; m < zom.size; m++)
            if (distance(zom[m] getOrigin(), self getOrigin()) <= 50)
                isClose = true;
        if (isClose) {
            time -= .05;
            hud["bar"] scaleOverTime(.05, int(time * 10), 12);
            hud["bar"] fadeOverTime(.05);
            hud["bar"].color = (1, time / 15, time / 15);
            oldTime = getTime();
        }
        if (getTime() >= oldTime + self.regenTime && time != 15) {
            time += 2;
            if (time > 15)
                time = 15;
            hud["bar"] scaleOverTime(.05, int(time * 10), 12);
            hud["bar"] fadeOverTime(.05);
            hud["bar"].color = (1, time / 15, time / 15);
            oldTime = getTime();
        }
        if (time <= 0)
            break;
        p = self getOrigin();
        if (p[0] <= 445 && p[0] >= 241 && p[1] <= 600 && p[1] >= -140 && p[2] >= 13.125)
            continue;
        else {
            time -= .2;
            hud["bar"] scaleOverTime(.05, int(time * 10), 12);
            hud["bar"] fadeOverTime(.05);
            hud["bar"].color = (1, time / 15, time / 15);
            oldTime = getTime();
        }
    }
    self destroyAll(hud);
    self returnToSpawn();
    self.ignoreme = true;
    self.is_zombie = true;
    self.isai = true;
    self.ai = true;
    self.team = "axis";
    self disableWeapons();
    self disableOffHandWeapons();
    self.regenTime = 15000;
    self unSetPerk("specialty_fastreload");
    self unSetPerk("specialty_rof");
    if (isDefined(self.perk_shader[0]))
        self destroyAll(self.perk_shader);
    hud = [];
    hud["txt"] = self createText(getFont(), 1, "CENTER", "TOP", 0, 20, 1, 1, "^1YOU HAVE BEEN REMOVED FROM THE UNDEAD-FIELD!");
    hud["txt2"] = self createText(getFont(), 1, "CENTER", "BOTTOM", 0, -20, 1, 1, "YOU WILL RESPAWN NEXT ROUND!");
    level waittill("between_round_over");
    spawnLoc = strTok("275.039 476.237 145.125 389.516 482.891 145.125 270.64 179.713 147.125 411.801 223.992 145.125", " ");
    spawnAng = strTok("-76 -90 -36 -90", " ");
    self setOrigin((float(spawnLoc[self getEntityNumber() * 3]), float(spawnLoc[(self getEntityNumber() * 3) + 1]), float(spawnLoc[(self getEntityNumber() * 3) + 2])));
    self setPlayerAngles((0, int(spawnAng[self getEntityNumber()]), 0));
    self.ignoreme = false;
    self.is_zombie = false;
    self.isai = false;
    self.ai = false;
    self.team = "allies";
    self enableWeapons();
    self enableOffHandWeapons();
    self destroyAll(hud);
    self thread nachtSurv_healthTimeBar();
    self takeAllWeapons();
    self giveWeapon("molotov");
    self giveWeapon("spas_zm");
    self giveWeapon("fraggrenade");
    self giveWeapon("mp40");
    weapArray = self getWeaponsListPrimaries();
    for (m = 0; m < weapArray.size; m++)
        self giveMaxAmmo(weapArray[m]);
    self switchToWeapon("mp40");
}

float(string) {
    floatParts = strTok(string, ".");
    if (floatParts.size)
        return (int(floatParts[0]));
    whole = int(floatParts[0]);
    decimal = int(floatParts[1]);
    while (decimal > 1)
        decimal *= .1;
    if (whole >= 0)
        return (whole + decimal);
    else
        return (whole - decimal);
}

nachtSurv_dropKeys() {
    for (;;) {
        wait .05;
        zom = getAiArray("axis");
        if (!zom.size)
            continue;
        for (m = 0; m < zom.size; m++)
            if (!isDefined(zom[m].dropKeyMonitor)) {
                zom[m].dropKeyMonitor = true;
                zom[m] thread zom_dropKeyMonitor(m);
            }
    }
}

zom_dropKeyMonitor(num) {
    for (;;) {
        self waittill("damage", amount, inflictor, direction, point, type);
        if (type == "MOD_MELEE") {
            if (self.health <= 1 && !isDefined(self.keyThread)) {
                self.keyThread = true;
                inflictor thread giveKey(self);
            }
            if (self.health <= 1)
                break;
        }
    }
}

giveKey(zom) {
    if (!isDefined(self.hasRandomKey)) {
        self.hasRandomKey = true;
        self.keyHud = [];
        self.keyHud["text"] = self createText(getFont(), 1.5, "CENTER", "BOTTOM", 0, -30, 1, 1, "KEY");
        self.keyHud["check"] = self createRectangle("CENTER", "BOTTOM", 17, -37, 15, 15, (1, 1, 1), "hud_checkbox_done", 2, 1);
    } else {
        if (level.round_num < 13)
            if (randomInt(100) <= 60)
                return;
            else
        if (randomInt(100) <= 30)
            return;
        physKey = spawnSM(zom.origin + (0, 0, 40), "clutter_peleliu_us_helmet");
        playFxOnTag(level._effect["powerup_on"], physKey, "tag_origin");
        physKey physicsLaunch();
        while (isDefined(physKey)) {
            wait .05;
            for (m = 0; m < getPlayers().size; m++) {
                plr = getPlayers()[m];
                if (distance(plr.origin, physKey.origin) < 64 && !isDefined(plr.hasRandomKey) && !plr.is_zombie) {
                    plr.hasRandomKey = true;
                    plr.keyHud = [];
                    plr.keyHud["text"] = plr createText(getFont(), 1.5, "CENTER", "BOTTOM", 0, -30, 1, 1, "KEY");
                    plr.keyHud["check"] = plr createRectangle("CENTER", "BOTTOM", 17, -37, 15, 15, (1, 1, 1), "hud_checkbox_done", 2, 1);
                    playFx(level._effect["powerup_grabbed"], physKey.origin);
                    playFx(level._effect["powerup_grabbed_wave"], physKey.origin);
                    playSoundAtPosition("powerup_grabbed", physKey.origin);
                    physKey delete();
                    break;
                }
            }
        }
    }
}

nachtSurv_randomBox() {
    box = spawnStruct();
    box = spawnSM((245, 431, 146), "zombie_treasure_box", (0, 270, 0));
    box.lid = spawnSM(box.origin + (-12.05, 0, 18), "zombie_treasure_box_lid", (0, 270, 0));
    box.trig = spawnTrigger(box.origin, 40);
    ent = getEntArray("zombie_door", "targetname")[0].door;
    ent.origin = (254, 431, 145);
    ent.angles = (90, 80, -10);
    ent hide();
    for (;;) {
        box.trig setString("Press [{+activate}] to Use Random Box [1 Key Required]");
        user = undefined;
        for (;;) {
            box.trig waittill("trigger", user);
            if (user useButtonPressed() && isDefined(user.hasRandomKey) && !user.is_zombie)
                break;
        }
        user.hasRandomKey = undefined;
        user destroyAll(user.keyHud);
        user.keyHud = undefined;
        box.lid rotateRoll(105, .5, (.5 * .5));
        box.lid playSound("lid_open");
        box.lid playSound("music_box");
        box thread treasureChestWeaponSpawn(user);
        box.fx = spawnSM(box.origin, "tag_origin", (90, 0, 0));
        playFxOnTag(level._effect["chest_light"], box.fx, "tag_origin");
        box.trig setString("");
        box waittill("randomization_done");
        box.trig setString("Press [{+activate}] to Trade Weapons");
        box thread treasureChestTimeout();
        for (;;) {
            box.trig waittill("trigger", grabber);
            if (grabber useButtonPressed() && grabber == user) {
                if (box.randomlyRolledWeapon != "")
                    grabber thread maps\_zombiemode_weapons::treasure_chest_give_weapon(box.RandomlyRolledWeapon);
                box playSound("cha_ching");
                box notify("user_grabbed_weapon");
                break;
            } else if (grabber == level) {
                box notify("user_grabbed_weapon");
                break;
            }
        }
        box.lid rotateRoll(-105, .5, (.5 * .5));
        box.lid playSound("lid_close");
        box.fx delete();
        box.weaponBeingRolled delete();
        box.trig setString("");
        wait 3;
    }
}

nachtSurv_trap_flogger() {
    flog = spawnStruct();
    flog.pole = spawnSM((404, 142, 278), "foliage_pacific_snapped_palms10a_small");
    flog.activator = spawnSM((309, 135, 184), "static_berlin_ger_radio", (0, 100, 0));
    flog.spike1 = spawnSM((400, 137, 335), "static_peleliu_stick_trap", (0, 0, -90));
    flog.spike2 = spawnSM((400, 137, 210), "static_peleliu_stick_trap", (0, 0, 90));
    flog.spike1 linkTo(flog.pole);
    flog.spike2 linkTo(flog.pole);
    flog.pole.angles = (0, 0, 80);
    flog.trig = spawnTrigger(flog.activator.origin, 50);
    for (;;) {
        flog.trig setString("Press [{+activate}] to Activate Flogger [Cost: 2500]");
        for (;;) {
            flog.trig waittill("trigger", user);
            if (user useButtonPressed() && user.score >= 2500 && !user.is_zombie)
                break;
        }
        level notify("flogger_used");
        user playSound("cha_ching");
        user minus_to_player_score(2500);
        flog.trig setString("");
        flog.pole rotateRoll(-18000, 45, 8, 8);
        flog.pole thread flogger_sound();
        pos = (397, 135, 100);
        rangeSquared = 110 * 110;
        for (m = 0; m < 45; m += .05) {
            zom = getAiSpeciesArray("axis", "all");
            for (e = 0; e < zom.size; e++) {
                zomi = zom[e];
                if (!isDefined(zomi) || !isAlive(zomi))
                    continue;
                testOrigin = zomi.origin + (0, 0, 40);
                testOriginSquared = distanceSquared(pos, testOrigin);
                if (testOriginSquared > rangeSquared)
                    continue;
                zomi thread forceZombieCrawler();
                zomi thread flingZombie(user, (0, -110, 120));
            }
            wait .05;
        }
        flog.trig setString("Flogger is Cooling Down...");
        wait(randomIntRange(30, 45));
    }
}

flogger_sound() {
    for (m = 0; m < 45; m += .3) {
        self playSound("attack_whoosh");
        wait .3;
    }
}

nachtSurv_musicBox() {
    time = strTok("91 208 129 268 142", " ");
    soundInfo = strTok("All Mixed Up;Dusk;Russian Anthem;Sand;What The Fuck", ";");
    radio = spawnSM((371, 579, 160), "static_berlin_ger_radio", (0, -90, 0));
    trig = spawnTrigger(radio.origin, 40);
    for (;;) {
        masterPicker = undefined;
        for (m = 10; m > 0; m--) {
            trig setString("Press [{+activate}] to Deposit a Key [" + m + " Required]");
            for (;;) {
                trig waittill("trigger", user);
                if (user useButtonPressed() && isDefined(user.hasRandomKey) && !user.is_zombie) {
                    user.hasRandomKey = undefined;
                    user destroyAll(user.keyHud);
                    user.keyHud = undefined;
                    masterPicker = user;
                    radio playSound("cha_ching");
                    break;
                }
            }
        }
        trig setString("Music is being Picked By: " + masterPicker getName());
        music = masterPicker nachtSurv_musicBoxHud();
        array_thread(getPlayers(), ::musicBox_musicID, soundInfo[music]);
        for (m = int(time[music]); m > -1; m--) {
            trig setString("Music Playing: " + soundInfo[music] + " [" + m + " Seconds Remaining]");
            wait 1;
        }
    }
}

musicBox_musicID(music) {
    txt = self createText(getFont(), 1.5, "CENTER", "CENTER", 0, 100, 1, 1, "Music Playing: " + music);
    txt thread alwaysColourful();
    wait 5;
    txt notify("colours_over");
    txt thread hudFadenDestroy(0, 1);
}

nachtSurv_musicBoxHud() {
    pTime = strTok("1:31 3:28 2:09 4:28 2:22", " ");
    hud = [];
    hud["bg"] = self createRectangle("CENTER", "CENTER", 0, 0, 200, 200, (0, 0, 0), "white", 1, .6);
    hud["tBox"] = self createRectangle("CENTER", "CENTER", 0, -80, 190, 30, (.809, 1, .184), "white", 2, .8);
    hud["mBox"] = self createRectangle("CENTER", "CENTER", 0, 0, 190, 120, (1, 1, 1), "white", 2, 1);
    hud["bBox"] = self createRectangle("CENTER", "CENTER", 0, 80, 190, 30, (.809, 1, .184), "white", 2, .8);
    hud["tTxt"] = self createText(getFont(), 1.4, "CENTER", "CENTER", 0, -80, 3, 1, "World at War FM");
    hud["bTxt"] = self createText(getFont(), 1.4, "CENTER", "CENTER", 0, 80, 3, 1, "Made by: Mikeeeyy");
    sound = strTok("all_mixed_up dusk russian_theme sand wtf", " ");
    soundInfo = strTok("All Mixed Up;Dusk;Russian Anthem;Sand;What The Fuck", ";");
    hud["mTxt"] = [];
    for (m = 0; m < sound.size; m++)
        hud["mTxt"][m] = self createText(getFont(), 1.2, "CENTER", "CENTER", 0, -40 + (m * 20), 3, 1, "^0" + soundInfo[m] + " ^7[^6" + pTime[m] + "^7]");
    hud["mTxt"][0] setText("^0" + soundInfo[0] + " ^7[^6" + pTime[0] + "^7]" + " [{+activate}]");
    curs = 0;
    self.usingMusicBox = true;
    wait 1;
    for (;;) {
        wait .05;
        if (self adsButtonPressed() || self attackButtonPressed()) {
            oldCurs = curs;
            curs -= self adsButtonPressed();
            curs += self attackButtonPressed();
            if (curs < 0)
                curs = sound.size - 1;
            if (curs > sound.size - 1)
                curs = 0;
            hud["mTxt"][oldCurs] setText("^0" + soundInfo[oldCurs] + " ^7[^6" + pTime[oldCurs] + "^7]");
            hud["mTxt"][curs] setText("^0" + soundInfo[curs] + " ^7[^6" + pTime[curs] + "^7]" + " [{+activate}]");
            wait .2;
        }
        if (self useButtonPressed()) {
            for (m = 0; m < getPlayers().size; m++)
                getPlayers()[m] playLocalSound(sound[curs]);
            level notify("musicBox_used");
            break;
        }
        if (self meleeButtonPressed())
            break;
    }
    self.usingMusicBox = undefined;
    self destroyAll(hud);
    return (curs);
}

nachtSurv_powerupEachRound() {
    powerUps = strTok("double_points insta_kill full_ammo nuke", " ");
    powerUpModels = strTok("zombie_x2_icon zombie_skull zombie_ammocan zombie_bomb", " ");
    for (;;) {
        level waittill("between_round_over");
        pu = spawnSM((337, 357, 185), "tag_origin");
        playSoundAtPosition("spawn_powerup", pu.origin);
        playFxOnTag(level._effect["powerup_on"], pu, "tag_origin");
        pu thread maps\_zombiemode_powerups::powerup_wobble();
        modelIndex = randomInt(4);
        pu setModel(powerUpModels[modelIndex]);
        for (m = 0; m < 30; m++) {
            wait .15;
            modelIndex++;
            if (modelIndex > 3)
                modelIndex = 0;
            pu setModel(powerUpModels[modelIndex]);
        }
        rInt = randomInt(powerUps.size);
        pu setModel(powerUpModels[rInt]);
        pu thread maps\_zombiemode_powerups::powerup_timeout();
        pu.powerup_name = powerUps[rInt];
        pu thread maps\_zombiemode_powerups::powerup_grab();
        pu playLoopSound("spawn_powerup_loop");
        playSoundAtPosition("spawn_powerup", pu.origin);
        for (m = 0; m < 10; m++)
            playFxOnTag(level._effect["powerup_on"], pu, "tag_origin");
    }
}

nachtSurv_perkBox() {
    box = spawnSM((282, 619, 145), "static_berlin_crate_metal", (0, 180, 0));
    debris = [];
    debris[0] = spawnSM((261, 615, 174), "static_berlin_winebottle");
    debris[1] = spawnSM((300, 624, 174), "static_berlin_winebottle");
    debris[2] = spawnSM((293, 613, 176), "static_berlin_winebottle", (90, -20, 0));
    debris[3] = spawnSM((268, 627, 174), "static_berlin_cans_single03", (0, -60, 0));
    debris[4] = spawnSM((271, 627, 174), "static_berlin_cans_single03", (0, 120, 0));
    debris[5] = spawnSM((276, 615, 176), "static_berlin_winebttl_brkn", (90, 50, 0));
    for (m = 0; m < debris.size; m++)
        debris[m] linkTo(box);
    for (m = 0; m < 2; m++) {
        level waittill("flogger_used");
        box moveZ(20.5, 1, .5, .5);
        wait 1;
    }
    level waittill("musicBox_used");
    box moveTo((282, 605, 186), 5, 1, 2);
    wait 5;
    trig = spawnTrigger(box.origin - (0, 0, 40), 60);
    trig setString("Press [{+activate}] to Use Perk Box");
    for (;;) {
        trig waittill("trigger", user);
        if (user useButtonPressed() && !user.is_zombie && !isDefined(user.usingPerkBox) && !isDefined(user.usingMusicBox))
            user thread nachtSurv_perkBoxMenu();
    }
}

nachtSurv_perkBoxMenu() {
    self endon("death");
    self endon("disconnect");
    self.usingPerkBox = true;
    self freezeControls(true);
    hud = [];
    hud["bg"] = self createRectangle("CENTER", "CENTER", 0, 0, 200, 200, (0, 0, 0), "white", 1, .6);
    hud["tBox"] = self createRectangle("CENTER", "CENTER", 0, -80, 190, 30, (.809, 1, .184), "white", 2, .8);
    hud["mBox"] = self createRectangle("CENTER", "CENTER", 0, 0, 190, 120, (1, 1, 1), "white", 2, 1);
    hud["bBox"] = self createRectangle("CENTER", "CENTER", 0, 80, 190, 30, (.809, 1, .184), "white", 2, .8);
    hud["tTxt"] = self createText(getFont(), 1.4, "CENTER", "CENTER", 0, -80, 3, 1, "Buy a Perk Here!");
    hud["bTxt"] = self createText(getFont(), 1.4, "CENTER", "CENTER", 0, 80, 3, 1, "Made by: Mikeeeyy");
    perks = strTok("Speed Cola;Double Tap;Regeneration;Mule Kick", ";");
    pCosts = strTok("3000 2000 5000 4000", " ");
    hud["mTxt"] = [];
    for (m = 0; m < perks.size; m++)
        hud["mTxt"][m] = self createText(getFont(), 1.2, "CENTER", "CENTER", 0, -30 + (m * 20), 3, 1, "^0" + perks[m]);
    hud["mTxt"][0] setText("^0" + perks[0] + " ^7[^6" + pCosts[0] + "^7] [{+activate}]");
    curs = 0;
    if (!isDefined(self.perk_shader))
        self.perk_shader = [];
    while (self useButtonPressed())
        wait .05;
    for (;;) {
        wait .05;
        if (self adsButtonPressed() || self attackButtonPressed()) {
            oldCurs = curs;
            curs -= self adsButtonPressed();
            curs += self attackButtonPressed();
            if (curs < 0)
                curs = perks.size - 1;
            if (curs > perks.size - 1)
                curs = 0;
            hud["mTxt"][oldCurs] setText("^0" + perks[oldCurs]);
            hud["mTxt"][curs] setText("^0" + perks[curs] + " ^7[^6" + pCosts[curs] + "^7] [{+activate}]");
            wait .2;
        }
        if (self useButtonPressed()) {
            if (self.score < int(pCosts[curs])) {
                self playSound("no_cha_ching");
                wait .3;
                continue;
            }
            if (curs == 0 && !self hasPerk("specialty_fastreload")) {
                self setPerk("specialty_fastreload");
                self playSound("cha_ching");
                self minus_to_player_score(int(pCosts[curs]));
                m = self.perk_shader.size;
                self.perk_shader[m] = [];
                self.perk_shader[m][0] = self createRectangle("LEFTBOTTOM", "LEFTBOTTOM", 112, -70, 22, 22, (1, 1, 1), "hint_usable", 2, 1);
            }
            if (curs == 1 && !self hasPerk("specialty_rof")) {
                self setPerk("specialty_rof");
                self playSound("cha_ching");
                self minus_to_player_score(int(pCosts[curs]));
                m = self.perk_shader.size;
                self.perk_shader[m] = [];
                self.perk_shader[m][0] = self createRectangle("LEFTBOTTOM", "LEFTBOTTOM", 0, -70, 20, 20, (1, 1, 1), "objectived", 1, 1);
                self.perk_shader[m][1] = self createRectangle("LEFTBOTTOM", "LEFTBOTTOM", 15, -70, 20, 20, (1, 1, 1), "objectived", 2, 1);
            }
            if (curs == 2 && self.regenTime == 15000) {
                self.regenTime = 7500;
                self playSound("cha_ching");
                self minus_to_player_score(int(pCosts[curs]));
                m = self.perk_shader.size;
                self.perk_shader[m] = [];
                self.perk_shader[m][0] = self createRectangle("LEFTBOTTOM", "LEFTBOTTOM", 80, -70, 22, 22, (1, 1, 1), "hint_health", 2, 1);
            }
            if (curs == 3 && self getWeaponsListPrimaries().size == 2) {
                self giveWeapon("asp_zm");
                self switchToWeapon("asp_zm");
                self playSound("cha_ching");
                self minus_to_player_score(int(pCosts[curs]));
                m = self.perk_shader.size;
                self.perk_shader[m] = [];
                self.perk_shader[m][0] = self createRectangle("LEFTBOTTOM", "LEFTBOTTOM", 40, -65, 25, 25, (1, 1, 1), "hud_icon_colt", 1, 1);
                self.perk_shader[m][1] = self createRectangle("LEFTBOTTOM", "LEFTBOTTOM", 43, -68, 25, 25, (1, 1, 1), "hud_icon_colt", 2, 1);
                self.perk_shader[m][2] = self createRectangle("LEFTBOTTOM", "LEFTBOTTOM", 46, -71, 25, 25, (1, 1, 1), "hud_icon_colt", 3, 1);
            }
            wait .3;
        }
        if (self meleeButtonPressed())
            break;
    }
    self destroyAll(hud);
    self freezeControls(false);
    while (self useButtonPressed() || self meleeButtonPressed())
        wait .05;
    self.usingPerkBox = undefined;
}

nachtSurv_watchForEnd() {
    for (;;) {
        wait .05;
        end = true;
        for (a = 0; a < getPlayers().size; a++)
            if (!getPlayers()[a].is_zombie)
                end = false;
        if (end) {
            array_thread(getPlayers(), ::_hideSeek_timeoutInit);
            break;
        }
    }
}

nachtSurv_rollingThunder() {
    plane = spawnStruct();
    plane.activator = spawnSM((269, 135, 184), "static_berlin_ger_radio", (0, 80, 0));
    plane.trig = spawnTrigger(plane.activator.origin, 50);
    for (;;) {
        plane.trig setString("Press [{+activate}] to Call in Rolling Thunder [Cost: 2000]");
        user = undefined;
        for (;;) {
            plane.trig waittill("trigger", user);
            if (user useButtonPressed() && user.score >= 2000 && !user.is_zombie)
                break;
        }
        user playSound("cha_ching");
        user minus_to_player_score(2000);
        plane.trig setString("Rolling Thunder is Bombarding!");
        plane.part1 = spawnSM((520, 683, 1055), "static_peleliu_b17_bomber_body", (0, 190, 200));
        plane.part2 = spawnSM((511, 687, 1171), "static_peleliu_b17_bomber_body", (0, 190, 20));
        plane.part2 linkTo(plane.part1);
        plane.part1.origin = (4157, 2903, 1055);
        plane.part1.angles = (0, 40, 200);
        plane.part1 moveTo((-3816, -5008, 1055), 15);
        plane.part1 thread rollingThunder_bombs();
        for (m = 0; m < 15; m += .05) {
            wait .05;
            zom = getClosest(self getOrigin(), getAiSpeciesArray("axis", "all"));
            magicBullet("mg42_bipod", plane.part1.origin, zom getTagOrigin("j_head"));
            for (e = 0; e < getPlayers().size; e++)
                earthQuake(.2, .5, getPlayers()[e].origin, 100);
        }
        plane.part1 delete();
        plane.part2 delete();
        plane.trig setString("Rolling Thunder is Refueling...");
        wait(randomIntRange(30, 45));
    }
}

rollingThunder_bombs() {
    wait .05;
    for (m = 0; m < 15; m++) {
        playSoundAtPosition("exp_ammo", self.origin);
        bomb = spawnSM(self.origin, "zombie_bomb", (0, 40, 0));
        endPos = physicsTrace(bomb.origin, bomb.origin - (0, 0, 10000));
        bomb.angles = vectorToAngles(bomb.origin - endPos) - (180, 0, 0);
        bomb moveTo(endPos, 1, .4);
        bomb thread rollingThunder_explosion();
        wait 1;
    }
}

rollingThunder_explosion() {
    self waittill("movedone");
    killZombiesWithinDistance(self.origin, 300, "flame");
    radiusDamage(self.origin, 300, 1000, 1000);
    playFx(loadFx("misc/fx_zombie_mini_nuke"), self.origin);
    playFx(loadFx("misc/fx_zombie_mini_nuke_hotness"), self.origin);
    playFx(loadFx("explosions/default_explosion"), self.origin);
    playFx(loadFx("explosions/default_explosion"), self.origin + (50, 0, 0));
    playFx(loadFx("explosions/default_explosion"), self.origin - (50, 0, 0));
    playFx(loadFx("explosions/default_explosion"), self.origin + (0, 50, 0));
    playFx(loadFx("explosions/default_explosion"), self.origin - (0, 50, 0));
    playSoundAtPosition("bomb_falloff", self.origin);
    self delete();
}

//Mania 
maniaHud() {
    opts[0] = [];
    opts[1] = [];
    opts[2] = [];
    opts[3] = [];
    opts[0]["progX"] = -270;
    opts[1]["progX"] = 270;
    opts[2]["progX"] = 270;
    opts[3]["progX"] = -270;
    opts[0]["progY"] = -200;
    opts[1]["progY"] = -200;
    opts[2]["progY"] = 200;
    opts[3]["progY"] = 200;
    opts[0]["textY"] = 15;
    opts[1]["textY"] = 15;
    opts[2]["textY"] = -15;
    opts[3]["textY"] = -15;
    num = self getEntityNumber();
    self.maniaProg = createTeamBar((1, 1, 1), 100, 15);
    self.maniaProg setPoint("CENTER", "CENTER", opts[num]["progX"], opts[num]["progY"]);
    text = createServerText(getFont(), 1, "CENTER", "CENTER", self.maniaProg.x, self.maniaProg.y + opts[num]["textY"], 1, 1, self getName());
}

maniaControlPowerups() {
    level.mania_powerUpControl = [];
    for (m = 0; m < 5; m++)
        level.mania_powerUpControl[m] = 12;
    dogSpawns = array_randomize(getDogSpawns());
    for (e = 0; e < 5; e++)
        for (m = 0; m < 12; m++) {
            fx = spawnStruct();
            fx = spawnSM(dogSpawns[(e * 12) + m] + (0, 0, 40), level.powerUpModels[e]);
            fx thread maps\_zombiemode_powerups::powerup_wobble();
            fx.type = e;
            fx thread fxPlayerMonitor();
            wait .05;
        }
}

fxPlayerMonitor() {
    collected = false;
    while (isDefined(self)) {
        for (m = 0; m < getPlayers().size; m++) {
            p = getPlayers()[m];
            if (distance(p.origin, self.origin) < 64) {
                if (p.powerUpType == level.powerUpProper[self.type]) {
                    p.powerUpsCollected++;
                    p.maniaProg updateBar(p.powerUpsCollected / 10);
                } else {
                    if (p.powerUpsCollected > 0)
                        p.powerUpsCollected--;
                    p.maniaProg updateBar(p.powerUpsCollected / 10);
                }
                if (p.powerUpsCollected == level.maniaMax)
                    array_thread(getPlayers(), ::maniaEnd, p);
                collected = true;
                break;
            }
        }
        if (collected)
            break;
        wait .05;
    }
    level.mania_powerUpControl[self.type]--;
    playSoundAtPosition("powerup_grabbed", self.origin);
    playFx(loadFx("misc/fx_zombie_powerup_grab"), self.origin);
    playFx(loadFx("misc/fx_zombie_powerup_wave"), self.origin);
    oldOrigin = self getOrigin();
    self delete();
    wait(randomIntRange(5, 20));
    lowest = level.mania_powerUpControl[0];
    index = 0;
    for (m = 1; m < level.mania_powerUpControl.size; m++) {
        tempLowest = level.mania_powerUpControl[m];
        if (tempLowest < lowest) {
            lowest = tempLowest;
            index = m;
        }
    }
    level.mania_powerUpControl[index]++;
    fx = spawnStruct();
    fx = spawnSM(oldOrigin, level.powerUpModels[index]);
    fx thread maps\_zombiemode_powerups::powerup_wobble();
    fx.type = index;
    fx thread fxPlayerMonitor();
}

maniaEnd(winner) {
    self freezeControls(true);
    self thread welcomeText("^1" + level.patch, "^2" + winner getName() + " ^7Is The Winner! -- ^2Created By: ^7" + level.patchCreator);
    wait 5;
    self suicide();
}

//zombie pro
ZombiesPro() {
    self thread ProVarsx();
    wait 2;
    self thread doGunsStart();
    self thread IfAliveGrenades();
    set_zombie_var("zombie_health_start", 700);
    set_zombie_var("zombie_health_increase", 400);
    set_zombie_var("zombie_health_increase_percent", 30, 400);
    set_zombie_var("zombie_ai_per_player", 20);
    set_zombie_var("zombie_spawn_delay", 0.5);
    set_zombie_var("zombie_powerup_drop_increment", 4);
    set_zombie_var("zombie_powerup_drop_max_per_round", 12);
    for (;;) {
        level.zombie_move_speed = 100;
        wait .01;
    }
}

ProVarsx() {
    self setClientDvar("player_sustainAmmo", 0);
    self setExpFog(50, 150, 0, 0, 0, 0);
    self setClientdvar("r_brightness", 0);
    self setClientDvar("r_lightTweakSunlight", 0);
    self setClientDvar("cg_fov", "95");
}

doGunsStart() {
    player = getPlayers();
    self takeAllWeapons();
    self.gunsList[0] = "zombie_mp40";
    self.gunsList[1] = "zombie_stg44";
    self.gunsList[2] = "zombie_thompson";
    self.gunsList[3] = "mp40_zm";
    self.gunsList[4] = "zombie_shotgun";
    self.gunsList[5] = "zombie_fg42";
    self.gunsList[6] = "zombie_type100_smg";
    self.pickWeapon = randomInt(self.gunsList.size);
    wait 0.1;
    if (self.playername == player[0].playername) {
        player[0] giveWeapon(self.gunsList[self.pickWeapon], 0);
        player[0] giveWeapon("asp_zm", 0);
        player[0] thread doGernades();
        player[0] switchToWeapon(self.gunsList[self.pickWeapon]);
    } else if (self.playername == player[1].playername) {
        player[1] giveWeapon(self.gunsList[self.pickWeapon], 0);
        player[1] giveWeapon("asp_zm", 0);
        player[1] thread doGernades();
        player[1] switchToWeapon(self.gunsList[self.pickWeapon]);
    } else if (self.playername == player[2].playername) {
        player[2] giveWeapon(self.gunsList[self.pickWeapon], 0);
        player[2] giveWeapon("asp_zm", 0);
        player[2] thread doGernades();
        player[2] switchToWeapon(self.gunsList[self.pickWeapon]);
    } else if (self.playername == player[3].playername) {
        player[3] giveWeapon(self.gunsList[self.pickWeapon], 0);
        player[3] giveWeapon("asp_zm", 0);
        player[3] thread doGernades();
        player[3] switchToWeapon(self.gunsList[self.pickWeapon]);
    }
}

IfAliveGrenades() {
    players = getPlayers();
    for (i = 0; i < players.size; i++) {
        level waittill("between_round_over");
        if (!players[i].is_zombie) {
            if (!players[i] hasWeapon("fraggrenade")) {
                players[i] giveWeapon("fraggrenade");
                players[i] setWeaponAmmoClip("fraggrenade", 0);
            }
            if (players[i] getFractionMaxAmmo("fraggrenade") < .25) {
                players[i] setWeaponAmmoClip("fraggrenade", 2);
            } else if (players[i] getFractionMaxAmmo("fraggrenade") < .5) {
                players[i] setWeaponAmmoClip("fraggrenade", 3);
            } else {
                players[i] setWeaponAmmoClip("fraggrenade", 4);
            }
        }
        wait 0.01;
    }
}

doGernades() {
    self giveWeapon("fraggrenade");
    self giveMaxAmmo("fraggrenade");
    self setWeaponAmmoClip("fraggrenade", 4);
    for (;;) {
        self setWeaponAmmoClip("stielhandgranate", 0);
        wait 0.01;
    }
}

array_thread4( entities, process, var1, var2, var3, var4 )
{
    keys = getArrayKeys( entities );
    for( i = 0 ; i < keys.size ; i ++ )
        entities[ keys[ i ] ] thread [[ process ]]( var1, var2, var3, var4 );
}

array_thread5( entities, process, var1, var2, var3, var4, var5 )
{
    keys = getArrayKeys( entities );
    for( i = 0 ; i < keys.size ; i ++ )
        entities[ keys[ i ] ] thread [[ process ]]( var1, var2, var3, var4, var5 );
}

//hidenseek
_hideSeek_init(seeker) {
    level._seeker = seeker;
    self takeAllWeapons();
    self playLocalSound("sam_fly_act_1");
    self setClientDvar("player_sprintUnlimited", 1);
    if (self == seeker) {
        for (m = 0; m < getPlayers().size; m++)
            if (getPlayers()[m] != self) {
                getPlayers()[m].seeker_icon = getPlayers()[m] thread spawnObjPointer(getPlayers()[m], self getOrigin(), "ui_host");
                getPlayers()[m].seeker_icon setTargetEnt(self);
            }
        self thread welcomeText("^1" + level.patch, "^2Gametype: ^7Hide and Seek! ^5You Are The Seeker! ^7-- ^2Created By: ^7" + level.patchCreator);
        self disableWeaponCycling();
        self disableOffHandWeapons();
        self giveWeapon("ray_gun_zm");
        self switchToWeapon("ray_gun_zm");
        self setClientDvar("cg_draw2d", 0);
        self.team = "axis";
        bg = self createRectangle("CENTER", "CENTER", 0, 0, 1000, 1000, (0, 0, 0), "white", 1, 1);
        timer = createServerText(getFont(), 2, "BOTTOMLEFT", "BOTTOMLEFT", 20, -20, 2, 1, undefined);
        timer setTimer(level.hideSeek_timer);
        self enableGodMode();
        link = spawnSM(self.origin, "tag_origin");
        self playerLinkTo(link);
        self setPlayerAngles((90, self getPlayerAngles()[1], 0));
        self freezeControls(true);
        wait(level.hideSeek_timer);
        self thread _hideSeek_timeOut();
        array_thread4(getPlayers(), ::welcomeText, "^1" + level.patch, "^2Gametype: ^7Hide and Seek! ^5Seeker Has Been Released! ^7-- ^2Created By: ^7" + level.patchCreator);
        self freezeControls(false);
        for (m = 0; m < getPlayers().size; m++) {
            plr = getPlayers()[m];
            if (plr == self)
                continue;
            plr setMoveSpeedScale(0);
            plr allowJump(false);
            plr setOrigin(plr._hideSeek_model);
        }
        level.searching = true;
        link delete();
        bg destroy();
        timer destroy();
        self setClientDvar("cg_draw2d", 1);
        self setPlayerAngles((0, self getPlayerAngles()[1], 0));
    } else {
        self._hideSeek_model = spawnSM(self getOrigin(), "tag_origin");
        self thread _hideSeek_modelFollow();
        self giveWeapon("stielhandgranate", 4);
        self hide();
        self disableWeapons();
        self disableOffHandWeapons();
        self thread _hideSeek_modelMenu();
        self thread _hideSeek_detection();
        self thread _hideSeek_controls();
        self.team = "allies";
        self setPerk("specialty_quieter");
        if (getMap() == "nzf") {
            dogSpawns = array_randomize(getDogSpawns());
            self setOrigin(dogSpawns[self getEntityNumber()]);
        }
        self freezeControls(true);
        while (isDefined(self.pickingModel))
            wait .05;
        self freezeControls(false);
    }
}

_hideSeek_modelMenu() {
    self endon("death");
    self endon("disconnect");
    level endon("seeker_released");
    if (!isDefined(self.mListCurs))
        self.mListCurs = 0;
    if (!isDefined(self.mListPage))
        self.mListPage = 0;
    self notify("picking_model");
    self.pickingModel = true;
    mList = level.hideSeek_modelArray;
    mListName = [];
    mListName["nzp"] = strTok("Radio;Ammo Shelves;Crate;Short Crate;Sandbags End;Sandbags Middle;Sandbag;Burning Barrel;Metal Crate;Metal Chair;Barbed Wire;Rubble;Black Barrel;Exploding Barrel Test;Medium Rock;Stick Trap Single;Randown Crate;Palette;Stick Trap;Runway Rubble;Antenna;Filing Cabinet;Electric Wire;Table;Plane Wing;Rock Wall;Can;Wine Bottle;Metal AMBX;Wine Bottle Broken;Wooden Ammo Box;Victorian Couch;Small Crate;Tire;Fuel Can;Empty Bucket;Small Bucket;Helmet;Hedgerow 1;Tree 1;Tree Log;Small Tree Log;Grass Clump;Tree 2;Tall Grass;Small Grass Clump;Blasted Sapling;Double Blasted Sapling;Hedgerow 2;Hedgerow 3;Small Hedgerow;Brush of Grass;Plant;Tree 3;Pine Tree;Scummy Barrel;Rusty Barrel;Cave Boulder 1;Cave Boulder 2;Explosive Barrel;Wooden Cabinet;Truck;Damaged Truck;Generator;Nuke;Insta-Kill;Double Points;Max Ammo;Random Box;Random Box Lid;Dev Sphere;Default Actor;Default Vehicle;Telephone Line;Tinhat Lamp;Lampstand;Kerosene Lamp;Lantern;Hanging Lantern;Axis Test", ";");
    mListName["nza"] = strTok("Bulletin Board;Electric Wire;Glass Pane;Exploding Barrel Test;Can 1;Can 2;Row of Books 1;Row of Books 2;Row of Books 3;Corrugated Metal 1;Corrugated Metal 2;Corrugated Metal 3;Corrugated Metal 4;Electrical Panel;Engine Control;Power Breaker;Cleaver Knife;Couch;Ammo Shelves;Rubble;Iron Bed;Cables 1;Cables 2;Witch Broom;Empty Bucket;Fuel Can;Metal AMBX;Pots;Wooden Ammo Box;Hedge Row 1;Hedge Row 2;Grass Clump 1;Burnt Tree 1;Burnt Tree 2;Burnt Tree 3;Tall Grass;Grass Clump 2;Hedge Row 3;Small Grass Clump;Blasted Sapling;Piece of Wood;Shovel;Barrel;Crate;Fountain;Fountain Base;Dining Table;Gurney;Window Shutter;Fusebox;Balustrade;Bookshelf;Destroyed Bookshelf;Door;Door Frame 1;Door Frame 2;Window;Bent Mattress;Bed Frame;Loudspeaker;Plain Chair;Mannequin;Metal Crate;Saucepan;Refrigerator;Cooker/Stove;Kitchen Sink;Sink Utility;Radiator;Bath Tub;Toilet;Destroyed Toilet;Torture Chair;Toilet Chair;Generator;Metal Cart;Mattress;Power Lever;Power Lever Handle;Surgical Bonesaw;Surgical Case;Teddybear;Random Box Rubble;Wheelchair;Power Box;Power Box On;Tesla Coil;Wall Control;Nuke;Insta-Kill;Double Points;Max Ammo;Speed Cola Machine;Jugger-Nog Machine;Quick Revive Machine;Double Tap Machine;Random Box;Random Box Lid;Dev Sphere;Radio;Default Actor;Default Vehicle;Sandbag;Sandbags Middle;Axis Test", ";");
    mListName["nzs"] = strTok("Radio;Corrugated Metal 1;Corrugated Metal 2;Corrugated Metal 3;Corrugated Metal 4;Sandbags End;Sandbag;Crate;Dirty Crate;Wooden Ammo Box 1;Wooden Ammo Box 2;Wooden Ammo Box 3;Wooden Ammo Box 3;Palette;Metal Desk;Ammo Shelves;Plain Chair;Dock Post;Chair;Beige Barrel;Destroyed Beige Barrel;Wooden Barrel;Mortar Box;Black Barrel;Destroyed Black Barrel;Stick Trap;Burning Barrel;Rock;Short Crate;Sandbags Middle;Barbed Wire;Headset;Hanging Telephone;Electrical Panel;Typewriter;Engine Control;Row of Books 1;Row of Books 2;Row of Books 3;Old Books 1;Old Books 2;Open Book;Loudspeaker;Destroyed Loudspeaker;Wooden Ammo Box Closed;Lilly Pad;Tire;Book;Jungle Tree;Willow Tree;Tree 1;Shrubs 1;Tall Grass;Fern 1;Grass Clump;Hanging Rice;Rice Plant;Plant;Tree 2;Cut Rice;Fern 2;Shrubs 2;Grass Clump 2;Shrubs 3;Grass Clump 3;Axis Test;Hanging Lantern On;Lantern On;Field Lantern On;Overhanging Light On;Tinhat Lamp On;Broken Radio;Bamboo Pole Destroyed;Nuke;Insta-Kill;Double Points;Max Ammo;Metal Cart;Surgical Case;Surgical Bonesaw;Parachute;Lantern On;Lantern Off;Power Box;Floating Fish;Tesla Coil;Zipline Power Box;Speed Cola Machine;Quick Revive Machine;Jugger-Nog Machine;Double Tap Machine;Random Box;Random Box Lid;Bear Pile;Wolf;Clean Wolf;Teddybear;Default Vehicle;Default Actor;Dev Sphere", ";");
    mListName["nzf"] = strTok("Radio;Sandbags Middle;Black Barrel;Palette;Black Barrel Destroyed;Sandbag;Barbed Wire;Crate;Corrugated Metal 1;Corrugated Metal 2;Filing Cabinet;Desk;Sandbags End;Ammo Shelves;Theater Bulletin Board;Furnace Door;Furnace Latch;Coast Bulletin Board;Short Crate;Paris Bulletin Board;Trash;Burning Barrel;Tire;Brick Group;Difference Engine;Small Beaker;Medium Beaker;Chalkboard;Brain;Spine;Brain Beaker;Teleporter Part 1;Teleporter Part 2;Teleporter Part 3;Teleporter Part 4;Clock;Sphere Beaker;Lab Cage;Dead Rat;Transformer;Powerline;Teleporter Pad;Control Panel;Mainframe Top;Mainframe Base;Books;Untidy Books;Open Book;Teddybear;Shank Teddybear;Perkaholic Teddybear;Diary;Tesla Coil;Handheld Radio;Wooden Box;Power Lever;Wall Control;Mainframe Shaft;Mainframe Ring 1;Mainframe Ring 2;Mainframe Ring 3;Doubletap Bottle;Jugger-Nog Bottle;Quick Revive Bottle;Speed Cola Bottle;Double Tap Machine;Jugger-Nog Machine;Quick Revive Machine;Speed Cola Machine;Packapunch Machine;Please Wait Sign;Nuke;Insta-Kill;Double Points;Max Ammo;Carpenter;Random Box;Random Box Lid;Lamp Handle;Lamp;Subway Lamp;Lantern;Subway Lamp On;Hanging Lamp;Hanging Lamp On;Hat Lamp;Rubble;Dev Sphere;Default Vehicle;Default Actor;Backpack;Bearpile;Axis Test", ";");
    mPages = [];
    for (m = 0; m < mList[getMap()].size; m += 9) {
        e = mPages.size;
        mPages[e] = [];
        for (t = m; t < m + 9; t++)
            if (isDefined(mList[getMap()][t]))
                mPages[e][mPages[e].size] = t;
    }
    menu = [];
    menu["bg"] = self createRectangle("LEFT", "CENTER", -20, 0, 1000, 1000, (0, 0, 0), "white", 1, .6);
    menu["scroll"] = self createRectangle("LEFT", "CENTER", -10, self.mListCurs, 300, 30, divideColour(255, 188, 33), "white", 2, 1);
    menu["instruct"] = [];
    menu["instructBg"] = self createRectangle("LEFT", "LEFT", 0, 0, 160, 65, (1, 0.7372549019607844, 0.12941176470588237), "white", 2, .8);
    menu["instruct"][0] = self createText(getFont(), 1, "LEFT", "LEFT", 5, -24, 3, 1, "[{+speed_throw}]/[{+attack}]: Scroll Up/Down");
    menu["instruct"][1] = self createText(getFont(), 1, "LEFT", "LEFT", 5, -8, 3, 1, "[{+frag}]: More Models");
    menu["instruct"][2] = self createText(getFont(), 1, "LEFT", "LEFT", 5, 8, 3, 1, "[{+activate}]: Pick Hiding Model");
    menu["instruct"][3] = self createText(getFont(), 1, "LEFT", "LEFT", 5, 24, 3, 1, "[{+melee}]: Exit Model Picking Menu");
    menu["mText"] = [];
    for (m = 0; m < mPages[self.mListPage].size; m++)
        menu["mText"][m] = self createText(getFont(), 1.5, "LEFT", "CENTER", 0, ((-1) * ((mPages[self.mListPage].size - 1) * 30) / 2) + (m * 30) + 30, 3, 1, mListName[getMap()][mPages[self.mListPage][m]]);
    menu["page#"] = self createText(getFont(), 1.5, "LEFT", "CENTER", 10, menu["mText"][0].y - 30, 3, 1, "^6Model List: " + (self.mListPage + 1) + "/" + mPages.size);
    menu["scroll"].y = menu["mText"][self.mListCurs].y;
    menu["mText"][self.mListCurs] getBig();
    for (;;) {
        wait .05;
        if (self adsButtonPressed() || self attackButtonPressed()) {
            if (self adsButtonPressed() && self attackButtonPressed())
                continue;
            oldCurs = self.mListCurs;
            self.mListCurs -= self adsButtonPressed();
            self.mListCurs += self attackButtonPressed();
            if (self.mListCurs < 0)
                self.mListCurs = menu["mText"].size - 1;
            if (self.mListCurs > menu["mText"].size - 1)
                self.mListCurs = 0;
            self playLocalSound("deny");
            menu["scroll"] thread hudMoveY(menu["mText"][self.mListCurs].y, .2);
            menu["mText"][oldCurs] thread getSmall();
            menu["mText"][self.mListCurs] getBig();
        }
        if (self fragButtonPressed()) {
            self.mListPage++;
            if (!isDefined(mList[getMap()][self.mListPage * 9]))
                self.mListPage = 0;
            self.mListCurs = 0;
            self destroyAll(menu["mText"]);
            menu["mText"] = [];
            for (m = 0; m < mPages[self.mListPage].size; m++)
                menu["mText"][m] = self createText(getFont(), 1.5, "LEFT", "CENTER", 0, ((-1) * ((mPages[self.mListPage].size - 1) * 30) / 2) + (m * 30) + 30, 3, 1, mListName[getMap()][mPages[self.mListPage][m]]);
            menu["scroll"] thread hudMoveY(menu["mText"][self.mListCurs].y, .2);
            menu["page#"] setPoint("LEFT", "CENTER", 10, menu["mText"][0].y - 30);
            menu["page#"] setText("^6Model List: " + (self.mListPage + 1) + "/" + mPages.size);
            wait .2;
            menu["mText"][self.mListCurs] getBig();
        }
        if (self useButtonPressed()) {
            self playLocalSound("grenade_pull_pin");
            self._hideModel = mList[getMap()][(self.mListPage * 9) + self.mListCurs];
            self._hideModelInfo = mListName[getMap()][(self.mListPage * 9) + self.mListCurs];
            self._hideSeek_model setModel(self._hideModel);
            menu["mText"][self.mListCurs].fontscale = 1.5;
            menu["mText"][self.mListCurs] getBig();
        }
        if ((self meleeButtonPressed() && isDefined(self._hideModel)) || isDefined(level.searching))
            break;
    }
    self.pickingModel = undefined;
    self destroyAll(menu);
    self thread _hideSeek_hud();
    if (isDefined(level.searching))
        return;
    for (;;) {
        wait .05;
        if ((self useButtonPressed() && self getStance() == "prone") || isDefined(level.searching))
            break;
    }
    if (!isDefined(level.searching)) {
        self setStance("stand");
        self thread _hideSeek_modelMenu();
    }
}

_hideSeek_hud() {
    if (!isDefined(self._hideModelInfo))
        self._hideModelInfo = "NOT SET!";
    hud = [];
    hud["title"] = self createText(getFont(), 1.2, "TOPLEFT", "TOPLEFT", 20, 20, 1, 1, "^6Hide and Seek:");
    hud["model"] = self createText(getFont(), 1, "TOPLEFT", "TOPLEFT", 20, 30, 1, 1, "Model: ^2" + self._hideModelInfo);
    hud["mInfo"] = self createText(getFont(), 1, "TOPLEFT", "TOPLEFT", 20, 40, 1, 1, "Prone & [{+activate}] to Change Model");
    hud["seek"] = self createText(getFont(), 1, "TOPLEFT", "TOPLEFT", 20, 50, 1, 1, "Seeker: ^2" + level._seeker getName());
    hud["seekDist"] = self createText(getFont(), 1, "TOPLEFT", "TOPLEFT", 20, 60, 1, 1, "Seeker Distance: ^5" + ceil(distance(level._seeker getOrigin(), self getOrigin())));
    hud["seekDist"] thread _hideSeek_dist(self);
    hud["yaw1"] = self createText(getFont(), 1, "TOPLEFT", "TOPLEFT", 20, 70, 1, 1, "[{+attack}]: Rotate Model ++");
    hud["yaw2"] = self createText(getFont(), 1, "TOPLEFT", "TOPLEFT", 20, 80, 1, 1, "[{+speed_throw}]: Rotate Model --");
    hud["third"] = self createText(getFont(), 1, "TOPLEFT", "TOPLEFT", 20, 90, 1, 1, "[{+melee}]: Toggle Third Person");
    self waittill("picking_model");
    self destroyAll(hud);
}

_hideSeek_dist(plr) {
    while (isDefined(self)) {
        self setText("Seeker Distance: ^5" + ceil(distance(level._seeker getOrigin(), plr getOrigin())));
        wait 5;
    }
}

getBig() {
    while (self.fontscale < 2) {
        self.fontscale = min(2, self.fontscale + (2 / 20));
        wait .05;
    }
}

getSmall() {
    while (self.fontscale > 1.5) {
        self.fontscale = max(1.5, self.fontscale - (2 / 20));
        wait .05;
    }
}

_hideSeek_detection() {
    self endon("death");
    self endon("disconnect");
    for (;;) {
        self waittill("weapon_pvp_attack", attacker, weapon, damage, mod);
        if (attacker != level._seeker || attacker getCurrentWeapon() != "ray_gun_zm")
            continue;
        array_thread4(getPlayers(), ::welcomeText, "^1" + level.patch, "^2" + self getName() + " ^7HAS BEEN FOUND! -- ^2Created By: ^7" + level.patchCreator);
        self.seeker_icon destroy();
        self.found = true;
        self._hideSeek_model delete();
        self notify("found");
        self notify("picking_model");
        break;
    }
    self.sessionstate = "spectator";
    self allowSpectateTeam("freelook", true);
    stillFinding = false;
    for (m = 0; m < getPlayers().size; m++) {
        if (getPlayers()[m] == level._seeker)
            continue;
        if (!isDefined(getPlayers()[m].found)) {
            stillFinding = true;
            break;
        }
    }
    if (!stillFinding) {
        timer = createServerText(getFont(), 2, "BOTTOMLEFT", "BOTTOMLEFT", 20, -20, 2, 1, undefined);
        timer setTimer(5);
        wait 5;
        level._seeker suicide();
    }
}

_hideSeek_controls() {
    self endon("death");
    self endon("disconnect");
    self endon("found");
    for (;;) {
        wait .05;
        if (isDefined(self.pickingModel))
            continue;

        if (!isDefined(level.searching)) {
            if (self adsButtonPressed())
                self._hideSeek_model rotateTo((0, self._hideSeek_model.angles[1] - 10, 0), .1);
            if (self attackButtonPressed())
                self._hideSeek_model rotateTo((0, self._hideSeek_model.angles[1] + 10, 0), .1);
            wait .2;
        }
        if (self meleeButtonPressed()) {
            if (!isDefined(self.third)) {
                self.third = true;
                self setClientDvar("cg_thirdPerson", 1);
            } else {
                self.third = undefined;
                self setClientDvar("cg_thirdPerson", 0);
            }
            wait .3;
        }
    }
}

_hideSeek_modelFollow() {
    self endon("death");
    self endon("disconnect");
    for (;;) {
        self._hideSeek_model moveTo(self getOrigin(), .1);
        wait .05;
    }
}

_lastToBase_splash(_hunter) {
    self setClientDvar("cg_drawCrosshair", 0);
    self setClientDvar("cg_draw2d", 0);
    self setVision("introscreen", .5);
    self freezeControls(true);
    self._lastToBase_text = self createText(getFont(), 2, "CENTER", "CENTER", 0, 150, 1, 1, "");
    text = self createText(getFont(), 1.5, "CENTER", "CENTER", 0, -15, 1, 1, "Game Beginning In:");
    timer = self createText("big", 2, "CENTER", "CENTER", 0, 15, 1, .85, undefined);
    timer.color = (1, 1, .5);
    for (m = 10; m > 0; m--) {
        timer setValue(m);
        timer thread changeFontScaleOverTime(4, .1);
        wait .1;
        timer thread changeFontScaleOverTime(2, .2);
        wait .9;
    }
    self setClientDvar("cg_drawCrosshair", 1);
    self setVision(getFont(), 1);
    self freezeControls(false);
    text destroy();
    timer destroy();
    self thread _lastToBase_hider(_hunter);
    self thread _lastToBase_zoneManagment(_hunter);
    if (_hunter != self) {
        wait .2;
        timer = self createText(getFont(), 2, "CENTER", "CENTER", 0, 170, 2, 1, undefined);
        timer setTimer(30);
        wait 30;
        timer destroy();
        return;
    }
    self enableGodMode();
    self thread _lastToBase_screenScaleDown();
    self freezeControls(true);
    self setClientDvar("cg_drawCrosshair", 0);
    self setClientDvar("g_friendlyfireDist", 0);
    self takeAllWeapons();
    self giveWeapon("ray_gun_zm");
    self switchToWeapon("ray_gun_zm");
    hud = [];
    hud["bg"] = self createRectangle("LEFT", "CENTER", -200, 0, 0, 0, (0, 0, 0), "white", 1, 1);
    hud["bg"] scaleOverTime(.2, 400, 160);
    wait .2;
    hud["timer"] = self createText(getFont(), 1.35, "RIGHT", "CENTER", 190, -60, 2, 1, undefined);
    hud["timer"] setTimer(30);
    hud["t1"] = self createText(getFont(), 1.35, "LEFT", "CENTER", -190, -60, 2, 0, "^6Last To Base ^7- ^2Created By Mikeeeyy");
    hud["t2"] = self createText(getFont(), 1.35, "LEFT", "CENTER", -190, -40, 2, 0, "1. Other Players Are Hiding... Let's Chat :_)");
    hud["t3"] = self createText(getFont(), 1.35, "LEFT", "CENTER", -190, -20, 2, 0, "2. After Timer, Protect The Base To Your Best Abilities!");
    hud["t4"] = self createText(getFont(), 1.35, "LEFT", "CENTER", -190, 0, 2, 0, "3. Protect The Base Using Your 1337 Ray Gun!");
    hud["t5"] = self createText(getFont(), 1.35, "LEFT", "CENTER", -190, 20, 2, 0, "4. Capture A Greater Amount Of Players To Win!");
    hud["t6"] = self createText(getFont(), 1.35, "LEFT", "CENTER", -190, 40, 2, 0, "5. If All Players Get To The Base... YOU LOOSE!");
    hud["t7"] = self createText(getFont(), 1.35, "LEFT", "CENTER", -190, 60, 2, 0, "6. Good Luck From ^2Mikeeeyy");
    for (m = 1; m < 8; m++)
        hud["t" + m] hudFade(1, .4);
    wait 27.2;
    level notify("_lastToBase_release");
    level thread _lastToBase_monitorScores(_hunter);
    self destroyAll(hud);
    self freezeControls(false);
    self setClientDvar("cg_drawCrosshair", 1);
    self setMoveSpeedScale(1.5);
    for (m = 0; m < getPlayers().size; m++)
        if (getPlayers()[m] != _hunter)
            getPlayers()[m] thread _lastToBase_baseDetector(_hunter);
    self _lastToBase_screenScaleUp();
    self thread _lastToBase_hunterAnticamp();
}

_lastToBase_hider(_hunter) {
    if (_hunter == self)
        return;
    self disableWeapons();
    self disableOffHandWeapons();
    for (;;) {
        self waittill("weapon_pvp_attack", attacker, weapon, damage, mod);
        if (attacker != _hunter || attacker getCurrentWeapon() != "ray_gun_zm")
            continue;
        array_thread(getPlayers(), ::_lastToBase_capturedHud, self);
        self.sessionstate = "spectator";
        self allowSpectateTeam("freelook", true);
        level._lastToBase_methods["damage"]++;
        self notify("_lastToBase_captured");
        self._lastToBase_text setText("UNLUCKY BRO-SKI :'(");
        break;
    }
}

_lastToBase_capturedHud(unfortunate) {
    hud = [];
    hud["bg"] = self createRectangle("LEFT", "LEFT", 0, unfortunate getEntityNumber() * 15, 0, 30, (1, 0.7372549019607844, 0.12941176470588237), "white", 2, .8);
    hud["bg"] scaleOverTime(.4, 200, 30);
    wait .4;
    hud["text"] = self createText(getFont(), 1, "LEFT", "LEFT", 5, unfortunate getEntityNumber() * 15, 3, 0, "^2" + unfortunate getName() + " ^7Was ^1Captured! :/");
    hud["text"] hudFade(1, .2);
    wait 3;
    self destroyAll(hud);
}

_lastToBase_baseFx() {
    fx = level._effect["powerup_on"];
    for (m = 0; m < 10; m++) {
        playFx(fx, (-167, 73, 99) + (0, m * 45, 0));
        wait .05;
    }
    wait 1;
    for (m = 0; m < 10; m++) {
        playFx(fx, (55, 73, 99) + (0, m * 45, 0));
        wait .05;
    }
    wait 1;
    for (m = -2; m < 3; m++) {
        playFx(fx, (-46, 73, 99) + (m * 45, 0, 0));
        wait .05;
    }
    wait 1;
    for (m = -2; m < 3; m++) {
        playFx(fx, (-46, 478, 99) + (m * 45, 0, 0));
        wait .05;
    }
    wait 1;
}

_lastToBase_screenScaleDown() {
    for (m = 1; m >= 0; m -= .05) {
        self setClientDvar("r_scaleViewPort", m);
        wait .05;
    }
}

_lastToBase_screenScaleUp() {
    for (m = 0; m <= 1.05; m += .05) {
        self setClientDvar("r_scaleViewPort", m);
        wait .05;
    }
}

_lastToBase_zoneManagment(_hunter) {
    level endon("_lastToBase_release");
    if (_hunter == self)
        return;
    self thread _lastToBase_badZone();
    badZones = strTok("receiver_zone outside_west_zone outside_east_zone", " ");
    for (;;) {
        num = 0;
        for (m = 0; m < badZones.size; m++)
            if (self isZone(badZones[m]))
                num++;
        if (!num) {
            self._lastToBase_text setText("ZONE STATUS: ^2OK");
            self.goodPlayer = true;
        } else {
            self._lastToBase_text setText("ZONE STATUS: ^1NOT OK");
            self.goodPlayer = undefined;
        }
        wait .05;
    }
}

_lastToBase_badZone() {
    level waittill("_lastToBase_release");
    if (isDefined(self.goodPlayer))
        return;
    self._lastToBase_text setText("PLAY FAIR NEXT TIME, BASE CAMPING ^1SHITFACE!");
    self.sessionstate = "spectator";
    self allowSpectateTeam("freelook", true);
    level._lastToBase_methods["badZone"]++;
    self notify("_lastToBase_badZone");
}

_lastToBase_baseDetector(_hunter) {
    self endon("_lastToBase_badZone");
    self endon("_lastToBase_captured");
    if (_hunter == self)
        return;
    wait .05;
    self._lastToBase_text setText("BASE STATUS: ^1OUT OF BOUNDRIES");
    for (;;) {
        wait .05;
        pos = self getOrigin();
        if (pos[0] > -150.875 && pos[0] < 36.875 && pos[1] < 446.875 && pos[1] > 90.1316) {
            level._lastToBase_methods["base"]++;
            self._lastToBase_text setText("BASE STATUS: ^2WITHIN BOUNDRIES");
            self enableGodMode();
            link = spawnSM(self getOrigin(), "tag_origin");
            playFxOnTag(level._effect["powerup_on"], link, "tag_origin");
            self playerLinkTo(link);
            link moveTo((link getOrigin()[0], link getOrigin()[1], 466.125), 3, .1, 1);
            wait 3;
            self unlink();
            link delete();
            self._lastToBase_text setText("GOOD JOB! - YOU MANAGED TO SURVIVE!");
            break;
        }
        if (self.sessionstate == "spectator")
            break;
    }
}

_lastToBase_hunterAnticamp() {
    for (;;) {
        wait .05;
        pos = self getOrigin();
        badBoy = undefined;
        while (self isZone("receiver_zone")) {
            for (m = 10; m >= 1; m--) {
                self._lastToBase_text setText("RECIEVER ZONE! - YOU HAVE ^1" + m + " ^7SECONDS! - GET OUT QUICK!");
                for (e = 0; e <= 1; e += .05) {
                    pos = self getOrigin();
                    wait .05;
                    if (!self isZone("receiver_zone"))
                        break;
                }
                if (!self isZone("receiver_zone"))
                    break;
                if (m <= 1)
                    badBoy = true;
            }
            if (isDefined(badBoy))
                break;
        }
        self._lastToBase_text setText("");
        if (isDefined(badBoy)) {
            loc = getDogSpawns()[randomInt(getDogSpawns().size)];
            self setOrigin(loc);
        }
    }
}

_lastToBase_monitorScores(_hunter) {
    for (;;) {
        wait .05;
        math = level._lastToBase_methods["badZone"] + level._lastToBase_methods["base"] + level._lastToBase_methods["damage"];
        if (math == getPlayers().size - 1)
            break;
    }
    iprintln("All Proceedures Correct!");
    if (level._lastToBase_methods["base"] > level._lastToBase_methods["damage"])
        array_thread4(getPlayers(), ::notifyMsg, undefined, "^2SURVIVORS GAINED VICTORY!", "THE HUNTER LIES IN SHAME!");
    if (level._lastToBase_methods["damage"] > level._lastToBase_methods["base"])
        array_thread4(getPlayers(), ::notifyMsg, undefined, "^2THE HUNTER GAINED VICTORY!", "THE SURVIVORS LIE IN SHAME!");
    if (level._lastToBase_methods["base"] == level._lastToBase_methods["damage"])
        array_thread4(getPlayers(), ::notifyMsg, undefined, "ITS A DRAW", "STAND DOWN!");
    wait 5;
    timer = createServerText(getFont(), 2, "BOTTOMLEFT", "BOTTOMLEFT", 20, -20, 2, 1, undefined);
    timer setTimer(5);
    wait 5;
    self setClientDvar("cg_draw2d", 1);
    _hunter suicide();
}

isZone(zone_name) {
    if (!isDefined(level.zones[zone_name]))
        return false;
    zone = level.zones[zone_name];
    for (m = 0; m < zone.volumes.size; m++)
        if (self isTouching(zone.volumes[m]))
            return true;
    return false;
}

getCurrentZone() {
    zone = getArrayKeys(level.zones);
    for (m = 0; m < level.zones.size; m++)
        if (self isTouching(zone[m]))
            return zone[m];
}

cycleControl() {
    self setClientDvar("g_friendlyfireDist", 0);
    self disableOffHandWeapons();
    self thread gunGameDetection();
    cycle = strTok("m1911_zm;asp_zm;cz75dw_zm;dragunov_zm;enfield_zm;famas_zm;galil_zm;hk21_zm;hs10_zm;knife_ballistic_zm;ks23_zm;l96a1_zm;m14_zm;m16_zm;ak47_zm;m72_law_zm;mp40_zm;mp5k_zm;python_zm;rpk_zm;spas_zm;stoner63_zm;rottweil72_zm", ";");
    for (;;) {
        if (!self hasWeapon(cycle[self.cycle])) {
            self takeAllWeapons();
            self giveWeapon(cycle[self.cycle]);
            self switchToWeapon(cycle[self.cycle]);
            self giveMaxAmmo(cycle[self.cycle]);
        }
        wait .05;
    }
}

gunGameLeader() {
    level.gunTxt = createServerText(getFont(), 1.2, "LEFT", "LEFT", 60, 70, 1, 1, "^6Player Gun Ranks:");
    timeHud = createServerText(getFont(), 1.2, "LEFT", "LEFT", 60, 80 + (getPlayers().size * 10), 1, 1, undefined);
    for (m = 0; m < getPlayers().size; m++)
        getPlayers()[m].gunGameHud = createServerText(getFont(), 1, "LEFT", "LEFT", 60, 80 + (m * 10), 1, 1, undefined);
    array_thread(getPlayers(), ::gunGameHuds);
    for (;;) {
        dist = getPlayers()[0].cycle;
        index = 0;
        for (m = 1; m < getPlayers().size; m++) {
            temp_dist = getPlayers()[m].cycle;
            if (temp_dist > dist) {
                dist = temp_dist;
                index = m;
            }
        }
        array_thread(getPlayers(), ::setInstructions, "Current Leader: ^2" + getPlayers()[index] getName());
        wait .05;
    }
}

gunGameHuds() {
    self endon("death");
    self endon("disconnect");
    for (;;) {
        cycle = self.cycle;
        gun = self getCurrentWeapon();
        wait .05;
        if (cycle != self.cycle || gun != self getCurrentWeapon())
            self.gunGameHud setText("^2" + self getName() + ": ^7[" + (self.cycle + 1) + "] " + weaponNames(self getCurrentWeapon()));
    }
}

gunGameDetection() {
    knife = strTok("Knifed;Stabbed;Shanked", ";");
    shot = strTok("Shot;Killed;", ";");
    for (;;) {
        self waittill("player_killed", enemy, weapon, damage, mod);
        if (mod == "MOD_MELEE") {
            iPrintln("^2" + self getName() + " ^7> " + knife[randomInt(knife.size)] + " > ^1" + enemy getName());
            self thread Ranked("Humiliation", "Demoted Enemy!");
            self playSound("knife_stab_plr");
            self playSound("melee_knife_hit_other");
            enemy thread GGDeath(self, "HUMILIATED");
            if (enemy.cycle > 0)
                enemy.cycle--;
        } else {
            self.cycle++;
            iPrintln("^2" + self getName() + " ^7> " + shot[randomInt(shot.size)] + " > ^1" + enemy getName());
            if (self.cycle == 17)
                array_thread(getPlayers(), ::gunGameEndon, self getName());
            else
                self thread ranked("Player Killed", "Advanced To The Next Tier!");
            enemy thread GGDeath(self, "KILLED");
        }
    }
}

gunGameEndon(winner) {
    self notify("gunGame_over");
    self freezeControls(true);
    self.gunGameHud destroy();
    if (self == getPlayers()[0])
        level.gunTxt destroy();
    self welcomeText("^1" + level.patch, "^2" + winner + " ^7Is The Winner! -- ^2Created By: ^7" + level.patchCreator);
    self suicide();
}

GGDeath(attacker, method) {
    self Hide();
    self DisableWeapons();
    self FreezeControls(true);
    if (IsDefined(self.revivetrigger))
        self thread maps\_laststand::revive_force_revive(self);
    body = spawnSM(self.origin, self.backUp["body"], self.angles);
    if (isDefined(self.backUp["head"]))
        body attach(self.backUp["head"], "", true);
    if (isDefined(self.backUp["hat"]))
        body attach(self.backUp["hat"], "", true);
    if (isDefined(self.backUp["gear"]))
        body attach(self.backUp["gear"], "", true);
    body startRagDoll();
    body thread deleteAfter30();
    self thread scavPack();
    self setOrigin((self.origin[0], self.origin[1], self.origin[2] - 100));
    bg = self createRectangle("CENTER", "CENTER", 0, 0, 1000, 1000, (0, 0, 0), "white", -1, 1);
    hud1 = self createText("smallFixed", 1.2, "CENTER", "CENTER", 0, -10, 1, 1, "YOU WERE " + method + " BY:");
    hud2 = self createText("smallFixed", 1.2, "CENTER", "CENTER", 0, 10, 1, 1, "^1" + attacker.playername);
    wait 4.9;
    self Show();
    self FreezeControls(false);
    self EnableWeapons();
    self pickSpawnPoints();
    self setWeaponAmmoClip(self getCurrentWeapon(), 1000);
    self giveMaxAmmo(self getCurrentWeapon());
    wait .1;
    hud1 destroy();
    hud2 destroy();
    bg destroy();
    self.health = self.maxhealth;
}

Ranked(Txt1, Txt2) {
    if (isDefined(self.gunGameHasHuds))
        return;
    self.gunGameHasHuds = true;
    Text = 0;
    Info = Txt1;
    Temp = "";
    for (i = 0; i < Info.size; i++) {
        Temp += Info[i];
        Text = createText(getFont(), 2, "CENTER", "TOP", 0, 20, 2, 1, Temp);
        wait .1;
        if (i != Info.size - 1) Text Destroy();
    }
    Fx = self CreateRectangle("CENTER", "TOP", 10, 25, 300, 100, (1, 0, 0), "scorebar_zom_1", 1, 0);
    Fx thread HUDFade(1, .5);
    Below = createText(getFont(), 1.5, "CENTER", "TOP", 0, 35, 2, 0, Txt2);
    Below HUDFade(1, .5);
    wait 2;
    Text Destroy();
    Fx Destroy();
    Below Destroy();
    self.gunGameHasHuds = undefined;
}

scavPack() {
    ammo = spawnSM(self.origin + (0, 0, 40), "grenade_bag");
    ammo physicsLaunch();
    playFxOnTag(level._effect["powerup_on"], ammo, "tag_origin");
    ammo thread scavDelete();
    wait .1;
    for (;;) {
        old = ammo getOrigin();
        wait .05;
        new = ammo getOrigin();
        if (old == new)
            break;
    }
    trig = spawnTrig(ammo.origin, 20, 10, "HINT_NOICON", "");
    while (isDefined(ammo)) {
        trig waittill("trigger", i);
        i setWeaponAmmoStock(i getCurrentWeapon(), i getWeaponAmmoStock(i getCurrentWeapon()) + 30);
        playSoundAtPosition("ammo_pickup", ammo.origin);
        playFx(loadFx("misc/fx_zombie_powerup_wave"), ammo.origin);
        ammo delete();
    }
}

scavDelete()
{
    for(m = 30; m >= 0; m--)
    {
        if(!isDefined(self))
            break;
        wait 1;
    }
    self delete();
}

pvpThread() {
    self endon("disconnect");
    self endon("death");
    self endon("pvp_over");
    self enableHealthShield(false);
    for (;;) {
        self waittill("weapon_pvp_attack", attacker, weapon, damage, mod);
        attacker thread doHitMarker();
        if (mod == "MOD_MELEE")
            self doDamage(((10 * 10) * 10), attacker.origin, undefined, undefined, "melee");
        if (mod == "MOD_RIFLE_BULLET") {
            if (weaponIsBoltAction(attacker getCurrentWeapon()) || isSubStr(attacker getCurrentWeapon(), "ptrs41"))
                self doDamage(((10 * 10) * 10), attacker.origin, undefined, undefined, "riflebullet");
            else
                self doDamage((damage * 8), attacker.origin, undefined, undefined, "riflebullet");
        }
        if (mod == "MOD_PISTOL_BULLET") {
            if (weaponClass(attacker getCurrentWeapon()) == "smg") {
                if (isSubStr(attacker getCurrentWeapon(), "type") || isSubStr(attacker getCurrentWeapon(), "mp40"))
                    self doDamage(((damage) * 8), attacker.origin, undefined, undefined, "pistolbullet");
                else if (isSubStr(attacker getCurrentWeapon(), "ppsh"))
                    self doDamage(((damage) * randomIntRange(2, 3)), attacker.origin, undefined, undefined, "pistolbullet");
                else
                    self doDamage(((damage) * 6), attacker.origin, undefined, undefined, "pistolbullet");
            } else if (weaponClass(attacker getCurrentWeapon()) == "spread")
                self doDamage(((damage) * 10), attacker.origin, undefined, undefined, "pistolbullet");
            else
                self doDamage(((damage) * randomIntRange(4, 8)), attacker.origin, undefined, undefined, "pistolbullet");
        }
        if (mod == "MOD_THROWKNIFE")
            self doDamage(((10 * 10) * 10), attacker.origin, undefined, undefined, "melee");
        if (isDefined(self.revivetrigger))
            attacker notify("player_killed", self, weapon, damage, mod);
    }
}

doHitMarker() {
    if (isDefined(self.hitMarker))
        self.hitMarker.alpha = 1;
    else
        self.hitMarker = self createRectangle("", "", 0, 0, 24, 48, (1, 1, 1), "damage_feedback", 1, 1);
    self.hitMarker hudFadenDestroy(0, 1);
    self.hitMarker = undefined;
}

tigPick() {
    level.tig = [];
    for (m = 0; m < getPlayers().size; m++)
        level thread generateRandyScore(getPlayers()[m]);
    level.tig["it"] = [];
    wait 6;
    index = 0;
    array = level.tig["it"];
    for (m = 1; m < array.size; m++)
        if (array[m] < array[m - 1])
            index = m;
    level.tig["it"] = getPlayers()[index];
    plr = level.tig["it"];
    plr setOrigin((308, -1678, 54));
    plr setPlayerAngles((0, 90, 0));
    plr thread tigger();
}

tigger() {
    self setClientDvar("player_sprintUnlimited", 1);
    self attach("zombie_teddybear", "j_ankle_le");
    self attach("zombie_teddybear", "j_ankle_ri");
    self playSound("laugh_child");
    array_thread(getPlayers(), ::setInstructions, "^2" + self getName() + " ^7Is The Seeker!");
    self enableWeapons();
    self giveWeapon("zombie_melee");
    self switchToWeapon("zombie_melee");
    self setMoveSpeedScale(1.2);
    self.team = "axis";
    self freezeControls(true);
    wait 5;
    self freezeControls(false);
    for (;;) {
        trace = bulletTrace(self getTagOrigin("j_head"), self getTagOrigin("j_head") + anglesToForward(self getPlayerAngles()) * 50, true, self);
        ent = trace["entity"];
        if (isDefined(ent) && ent.team == "allies")
            if (self meleeButtonPressed()) {
                ent thread tigger();
                break;
            }
        wait .05;
    }
    self deTach("zombie_teddybear", "j_ankle_le");
    self deTach("zombie_teddybear", "j_ankle_ri");
    self setClientDvar("player_sprintUnlimited", 0);
    self disableWeapons();
    self setMoveSpeedScale(1);
    self.team = "allies";
}

generateRandyScore(player) {
    player freezeControls(true);
    size = getPlayers().size - 1;
    text = createServerText("smallFixed", 1.2, "CENTER", "CENTER", (size * -100) + player getEntityNumber() * 200, 10, 1, 1, "");
    name = createServerText("smallFixed", 1.2, "CENTER", "CENTER", (size * -100) + player getEntityNumber() * 200, -10, 1, 1, player getName());
    speed = .1;
    score = 0;
    for (a = 0; a < 14; a++) {
        speed += .1;
        score = randomIntRange(-500, 500);
        text setValue(score);
        if (score < 0)
            text.color = (1, 0, 0);
        if (score > 0)
            text.color = (0, 1, 0);
        if (score == 0)
            text.color = (1, 1, 1);
        wait(speed / 2);
    }
    level.tig["it"][player getEntityNumber()] = score;
    wait .2;
    if (level.tig["it"] == player)
        for (a = 0; a < 5; a++) {
            text.color = (1, 1, 0);
            wait .1;
            text.color = (1, 0, 0);
            wait .1;
        }
    text thread hudFadenDestroy(0, 3);
    name thread hudFadenDestroy(0, 3);
    if (level.tig["it"] != player)
        player freezeControls(false);
}
smelter() {
    trig = spawnTrig((205.126, -650.927, 36.1994), 20, 20, "HINT_NOICON", "Press &&1 to Activate Smelter [Cost: 750]");
    level thread smelterHint(trig.origin);
    orig = (207.02, -453.391, -2.87622);
    level.additionTrigs["smelt"] = trig;
    for (;;) {
        trig waittill("trigger", i, check);
        if (!isDefined(check)) {
            if (!i useButtonPressed()) continue;
            if (i.is_zombie) continue;
            if (isDefined(i.revivetrigger)) continue;
            if (i.score < 750) {
                i playSound("plr_" + i getEntityNumber() + "_vox_nomoney_perk_0");
                continue;
            }
            i minus_to_player_score(750);
        }
        trig setHintString("Smelter Activated");
        level.smelterActivated = true;
        for (m = 0; m < 16; m++) {
            origin = (orig[0] + (m * -20), orig[1], orig[2]);
            playFx(loadFx("maps/zombie/fx_zombie_mainframe_steam"), origin);
            level thread smelterDoDamage(origin);
            wait .15;
        }
        trig setHintString("Please Wait");
        wait 10;
        level.smelterActivated = undefined;
        wait 20;
        trig SetHintString("Press &&1 to Activate Smelter [Cost: 750]");
    }
}
smelterHint(origin) {
    for (;;) {
        playFx(loadFx("maps/zombie/fx_zombie_mainframe_steam"), origin);
        wait 8;
    }
}
smelterDoDamage(origin) {
    while (isDefined(level.smelterActivated)) {
        level killZombiesWithinDistance(origin, 30, "headGib");
        wait .05;
    }
}
initTeethTrap() {
    activator = spawnSM((590.875, -2103.3, 174.993), "zombie_wallclock_main", (-90, 270, 90));
    door[0] = spawnMultipleModels((140, -2003, 91), 3, 1, 2, -50, 0, 80, "zombie_vending_doubletap_on");
    door[1] = spawnMultipleModels(door[0][0].origin + (248, 0, 0), 3, 1, 2, 50, 0, 80, "zombie_vending_doubletap_on");
    door[2] = spawnMultipleModels(door[0][1].origin, 5, 1, 1, 50, 0, 0, "zombie_vending_doubletap_on");
    trig = spawnTrig(activator.origin - (0, 0, 40), 40, 40, "HINT_NOICON", "Press &&1 To Activate Teeth Trap! [Cost: 2500]");
    level.additionTrigs["teethTrap"] = trig;
    for (;;) {
        trig waittill("trigger", i, check);
        if (!isDefined(check)) {
            if (!i useButtonPressed()) continue;
            if (i.is_zombie) continue;
            if (isDefined(i.revivetrigger)) continue;
            if (i.score < 2500) {
                i playSound("plr_" + i getEntityNumber() + "_vox_nomoney_perk_0");
                continue;
            }
            i minus_to_player_score(2500);
        }
        playSoundAtPosition("pa_buzz", activator.origin);
        trig setHintString("Please wait...");
        activator rotatePitch(360, 18, .5, .5);
        for (m = 0; m < 4; m++) {
            for (a = 1; a < door[2].size; a++) {
                door[2][a] moveTo(door[2][a].origin + (0, 0, -80), 1, .2);
                door[2][a] waittill("movedone");
                playSoundAtPosition("grenade_explode", door[2][a].origin);
                playFx(loadFx("maps/zombie/fx_zombie_dog_explosion"), door[2][a].origin);
                playFx(loadFx("env/fire/fx_fire_player_torso"), door[2][a].origin);
                playFx(loadfx("explosions/default_explosion"), door[2][a].origin);
                killZombiesWithinDistance(door[2][a].origin, 150, "flame");
                doPlayerDamage(door[2][a].origin, 100);
                earthquake(1.5, 1, door[2][a].origin, 90);
                door[2][a] moveTo(door[2][a].origin + (0, 0, 80), 3, .5, .5);
            }
        }
        wait 30;
        trig setHintString("Press &&1 To Active ^2Teeth Trap ^7[Cost: 2500]");
    }
}
spawnBigMoonx() {
    Fx = spawn("script_model", (-403, 1161, 1760));
    Fx setmodel("tag_origin");
    Fx.angles = (20, -70, 0);
    self.BigMoon = playFxOnTag(level._effect["zombie_moon_eclipse"], Fx, "tag_origin");
}
teslaTrap() {
    pt = [];
    pt[0] = spawnSM((177, -2373, 194), "zombie_zapper_tesla_coil", (-135, 0, 0));
    pt[1] = spawnSM((74, -2373, 194), "zombie_zapper_tesla_coil", (-225, 0, 0));
    pt[2] = spawnSM((177, -2373, 88), "zombie_zapper_tesla_coil", (-45, 0, 0));
    pt[3] = spawnSM((74, -2373, 88), "zombie_zapper_tesla_coil", (45, 0, 0));
    lever = spawnSM((241, -2368, 147), "zombie_power_lever_handle", (180, 0, -90));
    light = spawnSM(lever.origin - (20, 0, 0), "zombie_zapper_cagelight_red", (0, 0, 90));
    lever2 = spawnSM((241, -2377, 147), "zombie_power_lever_handle", (180, 180, -90));
    light2 = spawnSM(lever2.origin - (20, 0, 0), "zombie_zapper_cagelight_red", (0, 180, 90));
    trig = spawnTrigger(lever.origin - (0, 0, 40), 50);
    trig setString("Press [{+activate}] To Activate Electric Trap [Cost: 1500]");
    level.additionTrigs["teslaTrap"] = trig;
    for (;;) {
        trig waittill("trigger", i, check);
        if (!isDefined(check)) {
            if (!i useButtonPressed()) continue;
            if (i.is_zombie) continue;
            if (isDefined(i.revivetrigger)) continue;
            if (i.score < 1500) {
                i playSound("plr_" + i getEntityNumber() + "_vox_nomoney_perk_0");
                continue;
            }
            i minus_to_player_score(1500);
        }
        trig setString("");
        light setModel("zombie_zapper_cagelight_green");
        light2 setModel("zombie_zapper_cagelight_green");
        lever rotateRoll(-90, .5);
        lever playSound("amb_sparks_l_b");
        lever2 rotateRoll(-90, .5);
        lever2 playSound("amb_sparks_l_b");
        sound = spawn("script_origin", pt[0].origin);
        sound playSound("elec_start");
        sound playLoopSound("elec_loop");
        hitPos = [];
        for (m = 89; m <= 164; m += 7.5) hitPos[hitPos.size] = (m, -2373, 88);
        for (m = 0; m < 30; m++) {
            fx = [];
            for (e = 0; e < pt.size; e++) {
                fx[e] = spawnSM(pt[e].origin, "tag_origin");
                playFxOnTag(level._effect["tesla_bolt"], fx[e], "tag_origin");
            }
            fx[0] moveTo(pt[3].origin, .4, .2);
            fx[1] moveTo(pt[2].origin, .4, .2);
            fx[2] moveTo(pt[1].origin, .4, .2);
            fx[3] moveTo(pt[0].origin, .4, .2);
            for (e = 0; e <= 1; e += .05) {
                zom = getAiSpeciesArray("axis", "all");
                for (j = 0; j < zom.size; j++) {
                    for (t = 0; t < hitPos.size; t++) {
                        if (distance(zom[j].origin, hitPos[t]) < 10 && !isDefined(zom[j].marked_for_death)) {
                            zom[j] thread tesla_play_death_fx();
                            zom[j] doDamage(zom[j].health + 666, zom[j].origin, undefined, undefined, "riflebullet");
                            zom[j].marked_for_death = true;
                            zom[j] thread playElecVocals();
                        }
                    }
                }
                for (t = 0; t < hitPos.size; t++) doPlayerDamage(hitPos[t], 10);
                wait .05;
            }
            array_delete(fx);
        }
        sound stopLoopSound();
        sound delete();
        light setModel("zombie_zapper_cagelight_red");
        light2 setModel("zombie_zapper_cagelight_red");
        lever rotateRoll(90, .5);
        lever playSound("elec_arc");
        lever2 rotateRoll(90, .5);
        lever2 playSound("elec_arc");
        wait(randomIntRange(15, 30));
        lever playSound("pa_buzz");
        lever2 playSound("pa_buzz");
        trig setString("Press [{+activate}] To Activate Electric Trap [Cost: 1500]");
    }
}
playElecVocals() {
    if (isDefined(self)) {
        org = self.origin;
        wait .15;
        playSoundAtPosition("elec_vocals", org);
        playSoundAtPosition("zombie_arc", org);
        playSoundAtPosition("exp_jib_zombie", org);
    }
}
doTeleportingRounds() {
    level notify("teleZoms_over");
    for (;;) {
        wait(randomIntRange(240, 600));
        if (isDefined(level.bossRound)) continue;
        level.teleRound = true;
        rNum = randomIntRange(30, 45);
        array_thread(getPlayers(), ::welcomeText, "^1" + level.patch, "^5WARPING ZOMBIES! ^7for " + rNum + " Seconds! -- ^2Created By: ^7" + level.patchCreator);
        level thread init_teleZoms();
        wait(rNum);
        level notify("teleZoms_over");
        level.teleRound = undefined;
    }
}
jetPackxx() {
    self endon("death");
    self endon("disconnect");
    self endon("jetPackoff");
    self.JetPackOn = true;
    self iPrintLn("Hold [{+frag}] To Use");
    self.jetPack = 100;
    self.JetPackBG = self createPrimaryProgressBar(self);
    self.JetPackBG setPoint("CENTER", "CENTER", 0, 120);
    self.JetPackText = createFontString("smallFixed", 1, self);
    self.JetPackText setPoint("CENTER", "CENTER", 0, 110);
    self.JetPackText setText("JetPack " + self.JetPack + "^2/^7100");
    if (getMap() == "nzp") fx = loadFx("env/electrical/fx_elec_short_oneshot");
    else fx = level._effect["mp_elec_broken_light_1shot"];
    for (;;) {
        if (self fragButtonPressed() && self.jetPack > 0) {
            self playSound("elec_jib_zombie");
            playFx(fx, self getTagOrigin("j_ankle_ri"));
            playFx(fx, self getTagOrigin("j_ankle_le"));
            playFx(loadFx("env/fire/fx_fire_player_md"), self getTagOrigin("j_ankle_ri"));
            playFx(loadFx("env/fire/fx_fire_player_md"), self getTagOrigin("j_ankle_le"));
            earthquake(.15, .2, self getTagOrigin("j_spine4"), 50);
            self.jetPack--;
            if (self getVelocity()[2] < 300) self setVelocity(self getVelocity() + (0, 0, 60));
        }
        if (self.jetPack < 100 && !self fragButtonPressed()) self.jetPack++;
        self.JetPackText setText("JetPack Fuel " + self.jetPack + "^2/^7100");
        self.JetPackBG updateBar(self.jetPack / 100);
        self.JetPackBG.bar fadeOverTime(.05);
        self.JetPackBG.bar.color = (1, self.JetPack / 100, self.JetPack / 100);
        wait .05;
    }
}
DestroyJetPackxx() {
    self notify("jetPackoff");
    self.JetPackOn = undefined;
    self.JetPackBG destroy();
    self.JetPackBG destroyElem();
    self.JetPackBG.bar destroy();
    self.JetPackText destroy();
}
alwaysFoggy() {
    self endon("death");
    self endon("disconnect");
    for (;;) {
        self setVolFog(229, 200, 380, 200, .16, .204, .274, 1);
        wait 1;
    }
}
destroy_stopWatch() {
    for (;;) {
        self.stopwatch_elem destroy();
        self.stopwatch_elem_glass destroy();
        wait .05;
    }
}
bounceAround() {
    while (isDefined(self)) {
        self thread rotateEntYaw(360, 1);
        self moveZ(-20, .5, .2, .2);
        wait .5;
        self moveZ(20, .5, .2, .2);
        wait .5;
    }
}
physicalMenuFx() {
    fx1 = spawnMultipleModels((-129, 541, 121), 1, 1, 10, 0, 0, 10, "zombie_zapper_cagelight_red", (-90, 0, 0));
    fx2 = spawnMultipleModels((17, 541, 121), 1, 1, 10, 0, 0, 10, "zombie_zapper_cagelight_red", (90, 0, 0));
    fx1[0] playLoopSound("packa_rollers_loop");
    for (;;) {
        for (m = 0; m < 10; m++) {
            if (m == 0) {
                fx1[9] setModel("zombie_zapper_cagelight_red");
                fx2[9] setModel("zombie_zapper_cagelight_red");
            }
            fx1[m] setModel("zombie_zapper_cagelight_green");
            fx2[m] setModel("zombie_zapper_cagelight_green");
            fx1[m - 1] setModel("zombie_zapper_cagelight_red");
            fx2[m - 1] setModel("zombie_zapper_cagelight_red");
            wait .2;
        }
    }
}
initPhysicalMenu() {
    array = [];
    keys = getArrayKeys(level.zombie_weapons);
    for (m = 0; m < keys.size; m++)
        if (!isSubStr(keys[m], "upgraded") && !isIllegalWeapon(keys[m])) array[array.size] = keys[m];
    keys = array;
    basePoint = (-57, 618, 160);
    trig = spawnTrigger(basePoint - (0, 50, 60.875), 50);
    trig setString("Press [{+activate}] To Use Physical Weapons Menu");
    for (;;) {
        trig waittill("trigger", user);
        if (user useButtonPressed() && !user.is_zombie && !isDefined(user.revivetrigger) && user.menuMoves < 5) {
            randy = array_randomize(keys);
            weapon = [];
            weapon[0] = spawnSM(basePoint + (0, 0, 15), getWeaponModel(randy[0]), (0, 180, 0));
            weapon[1] = spawnSM(basePoint, getWeaponModel(randy[1]), (0, 180, 0));
            weapon[2] = spawnSM(basePoint - (0, 0, 15), getWeaponModel(randy[2]), (0, 180, 0));
            weapon[0] moveY(-40, 2, 0, 1);
            weapon[1] moveY(-50, 2, 0, 1);
            weapon[2] moveY(-40, 2, 0, 1);
            weapon[0] playSound("packa_weap_upgrade");
            trig setString("");
            currentWeapon = [];
            currentWeapon[0] = randy[0];
            currentWeapon[1] = randy[1];
            currentWeapon[2] = randy[2];
            moves = 5 - user.menuMoves;
            text = user createText("smallFixed", 1, "CENTER", "CENTER", 0, 100, 1, 1, "Moves Remaining: " + (5 - user.menuMoves));
            wait 1;
            for (;;) {
                if (user adsButtonPressed() && user.menuMoves < 5) {
                    user.menuMoves++;
                    for (m = 0; m < weapon.size; m++) weapon[m] hide();
                    thread createTempWeapon(weapon[0].origin, weapon[0].origin + (0, 40, 0), weapon[0].model, (0, 180, 0), .5, .25, .25);
                    thread createTempWeapon(weapon[1].origin, weapon[1].origin + (0, 10, 15), weapon[1].model, (0, 180, 0), .5, .25, .25);
                    thread createTempWeapon(weapon[2].origin, weapon[2].origin + (0, -10, 15), weapon[2].model, (0, 180, 0), .5, .25, .25);
                    for (;;) {
                        newWeapon = keys[randomInt(keys.size)];
                        if (newWeapon != currentWeapon[0] && newWeapon != currentWeapon[1] && newWeapon != currentWeapon[2]) break;
                        wait .05;
                    }
                    thread createTempWeapon(basePoint - (0, 0, 15), basePoint - (0, 40, 15), getWeaponModel(newWeapon), (0, 180, 0), .5, .25, .25);
                    weapon[0] setModel(weapon[1].model);
                    weapon[1] setModel(weapon[2].model);
                    weapon[2] setModel(getWeaponModel(newWeapon));
                    currentWeapon[0] = currentWeapon[1];
                    currentWeapon[1] = currentWeapon[2];
                    currentWeapon[2] = newWeapon;
                    wait .5;
                    for (m = 0; m < weapon.size; m++) weapon[m] show();
                    text setText("Moves Remaining: " + (5 - user.menuMoves));
                }
                if (user attackButtonPressed() && user.menuMoves < 5) {
                    user.menuMoves++;
                    for (m = 0; m < weapon.size; m++) weapon[m] hide();
                    for (;;) {
                        newWeapon = keys[randomInt(keys.size)];
                        if (newWeapon != currentWeapon[0] && newWeapon != currentWeapon[1] && newWeapon != currentWeapon[2]) break;
                        wait .05;
                    }
                    thread createTempWeapon(basePoint + (0, 0, 15), basePoint + (0, -40, 15), getWeaponModel(newWeapon), (0, 180, 0), .5, .25, .25);
                    thread createTempWeapon(weapon[0].origin, weapon[0].origin - (0, 10, 15), weapon[0].model, (0, 180, 0), .5, .25, .25);
                    thread createTempWeapon(weapon[1].origin, weapon[1].origin + (0, 10, -15), weapon[1].model, (0, 180, 0), .5, .25, .25);
                    thread createTempWeapon(weapon[2].origin, weapon[2].origin + (0, 40, 0), weapon[2].model, (0, 180, 0), .5, .25, .25);
                    weapon[2] setModel(weapon[1].model);
                    weapon[1] setModel(weapon[0].model);
                    weapon[0] setModel(getWeaponModel(newWeapon));
                    currentWeapon[2] = currentWeapon[1];
                    currentWeapon[1] = currentWeapon[0];
                    currentWeapon[0] = newWeapon;
                    wait .5;
                    for (m = 0; m < weapon.size; m++) weapon[m] show();
                    text setText("Moves Remaining: " + (5 - user.menuMoves));
                }
                if (user.menuMoves >= 5) {
                    for (t = 5; t >= 0; t--) {
                        text setText("Take Weapon or Leave [Time Left: ^1" + t + "^7]");
                        for (e = 0; e <= 1; e += .05) {
                            wait .05;
                            if (user useButtonPressed() || distance(basePoint - (0, 50, 60.875), user.origin) > 50 || isDefined(user.revivetrigger)) break;
                        }
                        if (user useButtonPressed() || distance(basePoint - (0, 50, 60.875), user.origin) > 50 || isDefined(user.revivetrigger)) break;
                    }
                }
                if (user useButtonPressed()) {
                    sWeapon = currentWeapon[1];
                    primaries = user getWeaponsListPrimaries();
                    if (isDefined(primaries) && primaries.size >= 2) user takeWeapon(user getCurrentWeapon());
                    user giveWeapon(sWeapon);
                    user giveMaxAmmo(sWeapon);
                    user switchToWeapon(sWeapon);
                    user.menuMoves = 5;
                    break;
                }
                if (distance(basePoint - (0, 50, 60.875), user.origin) > 50 || isDefined(user.revivetrigger) || user.menuMoves >= 5) break;
                wait .05;
            }
            text destroy();
            weapon[0] playSound("packa_deny");
            weapon[0] moveY(50, 2, 1);
            weapon[1] moveY(60, 2, 1);
            weapon[2] moveY(50, 2, 1);
            wait 2;
            for (m = 0; m < weapon.size; m++) weapon[m] delete();
            trig setString("Press [{+activate}] To Use Physical Weapons Menu");
            wait .05;
        }
    }
}
createTempWeapon(startPos, endPos, model, angles, time, de, ac) {
    weapon = spawnSM(startPos, model, angles);
    weapon moveTo(endPos, time, de, ac);
    weapon waittill("movedone");
    weapon delete();
}
quicklyMove(endPos) {
    self hide();
    self.origin = endPos;
    self show();
}
initFlinger() {
    origin = (-597, -119, 69.125);
    flin = [];
    for (m = 0; m < 3; m++) {
        flin[m] = spawnSM((origin[0] + (m * 24), origin[1], origin[2]), "zombie_treasure_box_lid", (0, 90, 0));
        wait .05;
    }
    flin[0] linkTo(flin[2]);
    flin[1] linkTo(flin[2]);
    trig = spawn("trigger_radius", flin[1].origin - (12, 0, 0), 1, 35, 35);
    for (;;) {
        trig waittill("trigger", user);
        if (user.is_zombie == true) continue;
        player = getPlayers();
        flin[2] playSound("ray_reload_open");
        wait 1.3;
        flin[2] playSound("ray_reload_open");
        wait 1.3;
        for (m = 0; m < player.size; m++)
            if (distance(player[m].origin, trig.origin) <= 35) player[m] thread flingerLaunch(flin[1]);
        flin[2] rotateRoll(55, .3);
        flin[2] playSound("shoot_off");
        wait 1;
        flin[2] rotateRoll(-55, .3);
    }
}
flingerLaunch(flin) {
    pos1 = flin getOrigin();
    pos2 = (320, pos1[1], pos1[2]);
    dist = distance(pos1, pos2);
    center = spawnSM((pos1[0] + (dist / 2), pos1[1], pos1[2]), "tag_origin");
    link = spawnSM(self getOrigin(), "tag_origin");
    link linkTo(center);
    self playerLinkTo(link);
    center rotatePitch(180, 1.5);
    wait 1.5;
    link delete();
    center delete();
}
initBombs() {
    self thread spawnBomb(0, (442, -1664, 56), (0, -90, 0));
    self thread spawnBomb(1, (388, -2502, 88), (0, 0, 0));
    self thread spawnBomb(2, (-175, -508, 69), (0, 0, 0));
    self thread spawnBomb(3, (511, 210, 61), (0, -90, 0));
}
spawnBomb(num, loc, angle) {
    bomb = spawnSM(loc, "zombie_transformer", angle);
    temp = spawnSM(loc + (0, 0, 70), "tag_origin", (-90, 0, 0));
    playFxOnTag(level._effect["zombie_elec_gen_idle"], temp, "tag_origin");
    bomb playLoopSound("power_loop");
    trig = spawnTrig(bomb.origin, 40, 40, "HINT_NOICON", "Press &&1 To Detonate Bomb! [Cost: 1000]");
    level.additionTrigs["bomb" + num] = trig;
    for (;;) {
        trig waittill("trigger", m, check);
        if (!isDefined(check)) {
            if (!m useButtonPressed()) continue;
            if (m.is_zombie) continue;
            if (isDefined(m.revivetrigger)) continue;
            if (m.score < 1000) {
                m playSound("plr_" + m getEntityNumber() + "_vox_nomoney_perk_0");
                continue;
            }
            m minus_to_player_score(1000);
        }
        trig setHintString("");
        m playSound("cha_ching");
        for (m = 5; m > 0; m--) {
            bomb playSound("pa_audio_link_" + m);
            wait 1;
        }
        bomb hide();
        temp delete();
        for (m = 0; m < 5; m++) {
            bomb playSound("gen_start");
            bomb playSound("weap_rgun_flux_r");
            bomb playSound("grenade_explode");
            playFx(loadFx("explosions/default_explosion"), bomb.origin);
            playFx(loadFx("weapon/bouncing_betty/fx_explosion_betty_generic"), bomb.origin);
            killZombiesWithinDistance(bomb.origin, 200, "headGib");
            doPlayerDamage(bomb.origin, 200);
            wait .1;
        }
        bomb stopLoopSound();
        wait 45;
        bomb playLoopSound("power_loop");
        temp = spawnSM(loc + (0, 0, 70), "tag_origin");
        playFxOnTag(level._effect["zombie_elec_gen_idle"], temp, "tag_origin");
        trig setHintString("Press &&1 To Detonate Bomb! [Cost: 1000]");
        playFx(loadFx("maps/zombie/fx_transporter_start"), bomb.origin);
        bomb playSound("pa_buzz");
        bomb show();
    }
}
napalmZombie_init() {
    for (;;) {
        wait(randomIntRange(120, 180));
        aiArray = getAiSpeciesArray("axis", "all");
        if (!isDefined(aiArray) || aiArray.size == 0 || isDefined(level.bossRound)) 
			continue;
        zom = aiArray[randomInt(aiArray.size)];
        zom.napalm = true;
        zom thread napalmZombie_flame();
        zom thread napalmZombie_trail();
        zom thread napalmZombie_flameVision();
        zom thread napalmZombie_explosion();
        zom thread napalmZombie_alternativeDeath();
        zom startTanning();
        while (isDefined(zom)) {
            wait .05;
            zom.health = 1000000;
            zom.run_combatanim = level.scr_anim["zombie"]["walk1"];
        }
    }
}
napalmZombie_flame() {
    while (isDefined(self)) {
        self thread animscripts\zombie_death::flame_death_fx();
        wait 1;
    }
}
napalmZombie_trail() {
    while (isDefined(self)) {
        playFx(loadFx("env/fire/fx_fire_player_md"), self getOrigin());
        wait .2;
    }
}

//r_flamefx_enable doesn't exist on BO1 
napalmZombie_flameVision() {
   // while (isDefined(self)) {
   //     plr = getPlayers();
   //     for (m = 0; m < plr.size; m++) {
   //        if (distance(plr[m] getOrigin(), self getOrigin()) <= 300) plr[m] setClientDvar("r_flamefx_enable", 1);
   //         else plr[m] setClientDvar("r_flamefx_enable", 0);
   //     }
   //     wait .05;
    //}
    //setLobbyDvar("r_flamefx_enable", 0);
}
napalmZombie_explosion() {
    //self endon("alt_death");
	self endon("death");
    taunt = false;
    while (isDefined(self)) {
        wait .05;
        plr = getPlayers();
        for (m = 0; m < plr.size; m++) {
            if (distance(plr[m] getOrigin(), self getOrigin()) <= 50) {
                taunt = true;
                self notify("player_close");
                self zombie_taunt();
                self thread napalmZombie_doExplosion();
                break;
            }
        }
        if (taunt) break;
    }
}
napalmZombie_alternativeDeath() {
    self endon("player_close");
    for (;;) {
        wait .05;
        if (self.health <= 1) {
            //self notify("alt_death");
			self endon("death");
            self thread napalmZombie_doExplosion();
            break;
        }
    }
}
napalmZombie_doExplosion() {
    fx = strTok("betty_explode thunder default_explosion", " ");
    for (e = 0; e < fx.size; e++) playFx(level._effect[fx[e]], self getOrigin());
    self playSound("grenade_explode");
    for (e = 0; e < 30; e++) playFx(loadFx("env/fire/fx_fire_player_md"), self getOrigin() + (randomIntRange(-100, 100), randomIntRange(-100, 100), 0));
    self.health = 1;
    self thread napalmZombie_doDamage();
    self thread maps\_zombiemode_spawner::zombie_damage("MOD_ZOMBIE_BETTY", "none", self.origin, getPlayers()[0]);
    level thread killZombiesWithinDistance(self getOrigin(), 200, "flame");
}
napalmZombie_doDamage() {
    if (!isDefined(self getOrigin())) return;
    plr = getPlayers();
    for (e = 0; e < plr.size; e++) {
        if (distance(plr[e] getOrigin(), self getOrigin()) <= 100) radiusDamage(plr[e] getOrigin(), 10, plr[e].health + 100, plr[e].health + 100);
        if (distance(plr[e] getOrigin(), self getOrigin()) > 100 && distance(plr[e] getOrigin(), self getOrigin()) <= 150) radiusDamage(plr[e] getOrigin(), 10, plr[e].health + 50, plr[e].health + 50);
        if (distance(plr[e] getOrigin(), self getOrigin()) > 150 && distance(plr[e] getOrigin(), self getOrigin()) <= 200) getPlayers()[e] doDamage(50, self getOrigin());
        if (distance(plr[e] getOrigin(), self getOrigin()) <= 200) getPlayers()[e] shellShock("death", 5);
    }
}
zombie_taunt() {
    if (!self.has_legs) return;
    self.old_origin = self getOrigin();
    anime = level._zombie_board_taunt[self.animname][2];
    self animScripted("zombie_taunt", self getOrigin(), self.angles, anime);
    wait(getAnimLength(anime));
    self teleport(self.old_origin);
}
survivalLightning() {
    for (;;) {
        self playLocalSound("couch_slam");
        earthquake(.3, 1, self.origin, 100);
        for (m = 0; m < 2; m++) {
            self setClientDvars("r_lightTweakSunColor", ".9 .9 .9", "r_lightTweakSunLight", "3");
            wait .1;
            self setClientDvars("r_lightTweakSunLight", "1.2", "r_lightTweakSunColor", "0.588235 0.788235 1 1");
            wait .1;
        }
        wait(randomIntRange(5, 20));
    }
}
roundText() {
    self endon("death");
    self endon("disconnect");
    level.round = 1;
    for (;;) {
        self maps\_zombiemode::round_wait();
        check = self createRectangle("CENTER", "CENTER", -200, 195, 10, 10, (1, 1, 1), "hud_checkbox_done", 3, 0);
        check thread roundMenuWatch(self);
        check thread hudFade(1, .5);
        bg = self createRectangle("CENTER", "CENTER", -200, 210, 125, 40, (1, 0, 0), "scorebar_zom_2", 1, 0);
        bg thread roundMenuWatch(self);
        bg thread hudFade(1, .5);
        round = self createText(getFont(), 1, "CENTER", "CENTER", -200, 210, 2, 0, "ROUND " + level.round + " COMPLETE!");
        round thread roundMenuWatch(self);
        round hudFade(1, .5);
        round thread flashThread();
        wait 5;
        for (m = 5; m > 0; m--) {
            round setText("NEXT ROUND IN: " + m + "...");
            wait 1;
        }
        round setText("INTERMISSION OVER!");
        wait 1;
        round notify("flashThread Over");
        round thread hudFadenDestroy(0, 1);
        bg thread hudFadenDestroy(0, 1);
        check thread hudFadenDestroy(0, 1);
        level notify("hudChecksOver");
        if (self == getPlayers()[0]) level.round++;
    }
}
roundMenuWatch(player) {
    player endon("death");
    player endon("disconnect");
    level endon("hudChecksOver");
    for (;;) {
        if (isDefined(player.usingSurvivalMenu)) self hudFadenDestroy(0, .2);
        wait .05;
    }
}
menuBarriers() {
    door = getEntArray("zombie_door", "targetname");
    door[6].doors[0].origin = (13, -2626, 106);
    door[6].doors[0].angles = (0, 90, 0);
    door[6].doors[0] hide();
    door[6].doors[0] solid();
    door[5].doors[0].origin = (1000.72, 378.984, 100.625);
    door[5].doors[0].angles = (90, 180, 0);
    door[5].doors[0] hide();
    door[5].doors[0] solid();
    door[5].doors[1].origin = (-450.077, -1455.81, 240.125);
    door[5].doors[1].angles = (90, 180, 0);
    door[5].doors[1] hide();
    door[5].doors[1] solid();
}
spawnSurvivalMenu() {
    box[0] = (6.92691, -2626.01, 88.125);
    ang[0] = (0, 0, 0);
    menu[0] = "KILLSTREAKS";
    func[0] = "surv_kills";
    icon[0] = "hud_burningcaricon";
    box[1] = (-450.077, -1455.81, 199.125);
    ang[1] = (0, 90, 0);
    menu[1] = "EQUIPMENT";
    func[1] = "surv_equip";
    icon[1] = "hud_us_grenade";
    box[2] = (1000.72, 378.984, 64.625);
    ang[2] = (0, 90, 0);
    menu[2] = "POWER-UPS";
    func[2] = "surv_powerup";
    icon[2] = strTok("specialty_instakill_zombies;specialty_doublepoints_zombies", ";")[randomInt(2)];
    menuBox = [];
    for (a = 0; a < box.size; a++) {
        menuBox[a] = spawnStruct();
        menuBox[a].temp = spawnSM(box[a], "zombie_treasure_box", ang[a] + (0, 90, 0));
        menuBox[a] = spawnSM(box[a] + (0, 0, 17.8), "zombie_treasure_box");
        menuBox[a].lid = spawnSM(menuBox[a].origin + (0, -12.05, 18), "zombie_treasure_box_lid");
        menuBox[a].fx = spawnSM(box[a], "tag_origin", (90, (ang[a])[1], 0));
        menuBox[a].lid linkTo(menuBox[a]);
        menuBox[a].angles = ang[a] + (0, -90, 0);
        wait .05;
        menuBox[a].lid unlink();
        menuBox[a].trig = spawn("trigger_radius", menuBox[a].origin, 1, 30, 30);
        menuBox[a] thread menuMonitor(a, func[a], menu[a]);
        menuBox[a] thread controlLid(menuBox[a].lid, menuBox[a].trig);
        playFxOnTag(level._effect["chest_light"], menuBox[a].fx, "tag_origin");
    }
}
menuMonitor(menuType, menuFunc, menuName) {
    for (;;) {
        self.trig setCursorHint("HINT_NOICON");
        self.trig setHintString("Press &&1 to Use " + menuName + " Menu!");
        self.trig waittill("trigger", i);
        if (i useButtonPressed() && !isDefined(i.revivetrigger) && !isDefined(i.usingSurvivalMenu) && !i.is_zombie && !isDefined(level.bossRound)) {
            if (menuName == "KILLSTREAKS" && isDefined(i.killstreakInLine)) continue;
            i.usingSurvivalMenu = true;
            i thread useSurvivalMenu(menuType, menuFunc, menuName);
        }
    }
}
useSurvivalMenu(menuType, menuFunc, menuName) {
    self endon("death");
    self endon("disconnect");
    self setClientDvar("cg_draw2d", 0);
    self freezeControls(true);
    self.surv_permaPerkHud destroy();
    self.surv_permaPerkCheck destroy();
    shader = self.surv_permaPerkHud.shader;
    info = self.menu["action"][menuFunc];
    menu = [];
    menu["bg"] = self createRectangle("CENTER", "CENTER", 0, 0, 1000, 1000, (0, 0, 0), "white", 1, .7);
    menu["split"] = self createRectangle("CENTER", "CENTER", 0, 0, 10, 480, (1, 1, 1), "ui_scrollbar", 2, 1);
    menu["text"] = [];
    for (m = 0; m < info["opt"].size; m++) {
        menu["text"][m] = self createText(getFont(), 1.5, "LEFT", "CENTER", 1000, ((-1) * ((info["opt"].size - 1) * 30) / 2) + (m * 30), 3, 1, info["opt"][m]);
        menu["text"][m] hudMoveX(30, .05);
    }
    menu["scroll"] = self createRectangle("CENTER", "CENTER", 140, menu["text"][0].y, 240, 30, (0, 1, 1), "white", 2, .8);
    menu["infoBox"] = self createRectangle("RIGHT", "CENTER", -20, menu["scroll"].y, 240, 100, (0, 1, 1), "white", 2, .8);
    menu["info1"] = self createText(getFont(), 1, "LEFT", "CENTER", -255, menu["infoBox"].y - 15, 3, 1, "^6" + menuName + " MENU: ^7" + info["opt"][0]);
    menu["info2"] = self createText(getFont(), 1, "LEFT", "CENTER", -255, menu["infoBox"].y, 3, 1, "^2DESCRIPTION: ^7" + info["desc"][0]);
    menu["info3"] = self createText(getFont(), 1, "LEFT", "CENTER", -255, menu["infoBox"].y + 15, 3, 1, "^2KILLSTREAK COST: ^7$" + info["cost"][0]);
    self.surv_curs = 0;
    self thread watchFor_heldFragSkipping(info["opt"].size);
    self thread watchFor_buttonPress();
    self thread watchFor_playerDowned();
    self thread watchFor_bossRound();
    for (;;) {
        self waittill("buttonPress", button);
        if (button == "ads" || button == "attack" || button == "skip") {
            if (isDefined(self.heldingFrag)) continue;
            if (button == "ads") self.surv_curs--;
            if (button == "attack") self.surv_curs++;
            if (self.surv_curs < 0) self.surv_curs = info["opt"].size - 1;
            if (self.surv_curs > info["opt"].size - 1) self.surv_curs = 0;
            menu["scroll"] thread hudMoveY(menu["text"][self.surv_curs].y, .2);
            menu["infoBox"] thread hudMoveY(menu["scroll"].y, .2);
            menu["info1"] thread hudMoveY(menu["infoBox"].y - 15, .2);
            menu["info2"] thread hudMoveY(menu["infoBox"].y, .2);
            menu["info3"] thread hudMoveY(menu["infoBox"].y + 15, .2);
            menu["info1"] thread hudFade(0, .2);
            menu["info2"] thread hudFade(0, .2);
            menu["info3"] thread hudFade(0, .2);
            wait 0.2;
            menu["info1"] thread hudFade(1, .2);
            menu["info2"] thread hudFade(1, .2);
            menu["info3"] thread hudFade(1, .2);
            menu["info1"] setText("^6" + menuName + " MENU: ^7" + info["opt"][self.surv_curs]);
            menu["info2"] setText("^2DESCRIPTION: ^7" + info["desc"][self.surv_curs]);
            menu["info3"] setText("^2KILLSTREAK COST: ^7$" + info["cost"][self.surv_curs]);
        }
        if (button == "use") {
            if (menuName == "KILLSTREAKS" || menuName == "POWER-UPS") {
                if (self.score >= info["cost"][self.surv_curs]) {
                    self thread[[info["func"][self.surv_curs]]](info["inp1"][self.surv_curs], info["inp2"][self.surv_curs], info["inp3"][self.surv_curs]);
                    self minus_to_player_score(info["cost"][self.surv_curs]);
                    self playSound("cha_ching");
                    if (menuName == "KILLSTREAKS") {
                        wait 1;
                        break;
                    }
                } else self playSound("plr_" + self getEntityNumber() + "_vox_nomoney_perk_0");
            } else {
                if (self hasPerk("specialty_altmelee") && info["opt"][self.surv_curs] == "BOWIE KNIFE") continue;
                else {
                    if (self.score >= info["cost"][self.surv_curs]) {
                        self thread[[info["func"][self.surv_curs]]](info["inp1"][self.surv_curs], info["inp2"][self.surv_curs], info["inp3"][self.surv_curs]);
                        self minus_to_player_score(info["cost"][self.surv_curs]);
                        self playSound("cha_ching");
                        wait 1;
                    } else self playSound("plr_" + self getEntityNumber() + "_vox_nomoney_perk_0");
                }
            }
            wait .3;
        }
        if (button == "melee" || button == "quit") break;
    }
    self destroyAll(menu);
    self notify("survivalMenu_over");
    self setClientDvar("cg_draw2d", 1);
    self freezeControls(false);
    self.usingSurvivalMenu = undefined;
    self.surv_permaPerkHud = self createRectangle("BOTTOM", "BOTTOM", 0, -20, 25, 25, (1, 1, 1), shader, 1, 1);
    self.surv_permaPerkCheck = self createRectangle("BOTTOM", "BOTTOM", 10, -37, 15, 15, (1, 1, 1), "hud_checkbox_done", 2, 1);
}
watchFor_buttonPress() {
    self endon("death");
    self endon("disconnect");
    self endon("survivalMenu_over");
    for (;;) {
        if (self adsButtonPressed()) self notify("buttonPress", "ads");
        if (self attackButtonPressed()) self notify("buttonPress", "attack");
        if (self useButtonPressed()) self notify("buttonPress", "use");
        if (self meleeButtonPressed()) self notify("buttonPress", "melee");
        wait .05;
    }
}
watchFor_playerDowned() {
    self endon("death");
    self endon("disconnect");
    self endon("survivalMenu_over");
    for (;;) {
        self waittill("player_downed");
        self notify("buttonPress", "quit");
    }
}
watchFor_bossRound() {
    self endon("death");
    self endon("disconnect");
    self endon("survivalMenu_over");
    for (;;) {
        if (isDefined(level.bossRound)) self notify("buttonPress", "quit");
        wait .05;
    }
}
watchFor_heldFragSkipping(max) {
    self endon("death");
    self endon("disconnect");
    self endon("survivalMenu_over");
    for (;;) {
        held = 0;
        if (self fragButtonPressed()) {
            self.heldingFrag = true;
            while (self fragButtonPressed()) {
                held++;
                if (held > max - 1) held = 1;
                self playLocalSound("pa_audio_link_" + held);
                for (m = 0; m <= .5; m += .05) {
                    wait .05;
                    if (!self fragButtonPressed()) break;
                }
            }
            self.heldingFrag = undefined;
        }
        if (held != 0) {
            for (m = 0; m < held; m++) {
                self.surv_curs++;
                if (self.surv_curs > max - 1) self.surv_curs = 0;
            }
            self notify("buttonPress", "skip");
        }
        wait .05;
    }
}
controlLid(lid, trig) {
    pos = false;
    for (;;) {
        num = 0;
        player = getPlayers();
        for (m = 0; m < player.size; m++)
            if (player[m] isTouching(trig)) num++;
        if (num == 0 && pos == true) {
            lid rotateRoll(-105, .5, .25);
            lid playSound("lid_close");
            pos = false;
            wait .5;
        }
        if (num >= 1 && pos == false) {
            lid rotateRoll(105, .5, .25);
            lid playSound("lid_open");
            pos = true;
            wait .5;
        }
        wait .05;
    }
}
killstreakInit(func, string, protection) {
    string = "PRONE & HOLD [{+activate}] TO " + string;
    if (!isDefined(self.hintString)) {
        self.hintString = self createText(getFont(), 1.1, "CENTER", "BOTTOM", 0, -60, 10, 1, string);
        self.hintString thread flashThread();
        self thread killstreakUse(protection);
    }
    self.hintString setText(string);
    self.killstreakInLine = func;
}
killstreakUse(protection) {
    self endon("death");
    self endon("disconnect");
    while (isDefined(self.hintString)) {
        if (self getStance() == "prone" && self useButtonPressed() && self.sessionstate == "playing" && !isDefined(self.revivetrigger)) {
            time = 0;
            bar = self createPrimaryProgressBar();
            bar updateBar(0, 1);
            text = self createPrimaryProgressBarText();
            text setText("Killstreak Deploying!");
            while (self useButtonPressed() && self getStance() == "prone") {
                time += .05;
                if (!self useButtonPressed() || self getStance() != "prone") break;
                if (time >= 1) {
                    bar destroyElem();
                    text destroy();
                    self.hintString destroy();
                    self.hintString = undefined;
                    self setStance("stand");
                    self[[self.killstreakInLine]]();
                    self setVision("fly_dark");
                    if (protection == "Y") self thread afterKillstreakProtection();
                    self.killstreakInLine = undefined;
                    break;
                }
                wait .05;
            }
            if (isDefined(bar)) {
                bar destroyElem();
                text destroy();
            }
        }
        wait .05;
    }
}
giveMolotovs(temp, cost) {
    self giveWeapon("molotov", 4);
}
giveFragGrenades(temp, cost) {
    self giveWeapon("fraggrenade", 4);
}
giveBouncinBet() {
    giveMenuWeapon("mine_bouncing_betty");
} /* SURVIVAL MODE START UP PROMPT */
sm_startUpPrompt() {
    self endon("death");
    self endon("disconnect");
    self.pickingClass = true;
    self freezeControls(true);
    self enableGodMode();
    self setBlur(10, 1);
    hud = [];
    text = [];
    classType = strTok("Assault Support;Heavy Gunner;Scout Sniper;Sub-Machine Gunner", ";");
	classWeapons = strTok("commando_zm|spas_zm;rpk_zm|ak74u_zm;l96a1_upgraded_zm|dragunov_upgraded_zm;mp40_zm|mp5k_zm", ";");
	classDetails = strTok("^2PRIMARY: ^7STG-44 --- ^2SECONDARY: ^7M1897 TRENCH GUN;^2PRIMARY: ^7BROWNING M1919 --- ^2SECONDARY: ^7BAR;^2PRIMARY: ^7PTRS-41 --- ^2SECONDARY: ^7.357 MAGNUM;^2PRIMARY: ^7MP40 --- ^2SECONDARY: ^7THOMPSON", ";");
    classInfo = strTok("Fight your way through using the close/medium ranged FIREPOWER!;Sit on your fat ass and rape zombie butt!;So I heard you like quickscoping? This is the class for you!;Rush like a try-hard,die like a bitch!", ";");
    perk = strTok("Faster Reloading;Quicker Reviving;Extended Health;Double Rate of Fire", ";");
    perkType = strTok("specialty_fastreload|zombie_perk_bottle_sleight|mx_speed_sting|specialty_fastreload_zombies;specialty_quickrevive|zombie_perk_bottle_revive|mx_revive_sting|specialty_quickrevive_zombies;specialty_armorvest|zombie_perk_bottle_jugg|mx_jugger_sting|specialty_juggernaut_zombies;specialty_rof|zombie_perk_bottle_doubletap|mx_doubletap_sting|specialty_doubletap_zombies", ";");
    perkDetails = strTok("^2PERK: ^7SPEED COLA AKA. SLEIGHT OF HAND;^2PERK: ^7QUICK REVIVE;^2PERK: ^7JUGGER-NOG AKA. JUGGERNAUT;^2PERK: ^7DOUBLE TAP", ";");
    perkInfo = strTok("Take a sip of Speed Cola and speed up your reloads!;Be a morphine addict and inject your teammates twice as fast!;Protect yourself from the undead with a boost of health!;The solution to sluggish guns!", ";");
    for (m = 0; m < 4; m++) {
        hud[m] = self createRectangle("CENTER", "CENTER", -100, (m * 35) - 50, 220, 25, (.5, .6, .8), "scorebar_zom_" + (m + 1), 1, 1);
        text[m] = self createText(getFont(), 1.4, "CENTER", "CENTER", -100, (m * 35) - 50, 2, 1, classType[m]);
    }
    text[0] thread flashThread();
    scroll = self createRectangle("CENTER", "CENTER", 0, -50, 25, 25, (.5, .6, .8), "ui_host", 2, 1);
    title = self createText(getFont(), 2, "LEFT", "CENTER", 35, -10, 2, 1, "PICK A CLASS!");
    details = self createText(getFont(), 1.1, "LEFT", "CENTER", 35, 10, 2, 1, classDetails[0]);
    info = self createText(getFont(), 1, "LEFT", "CENTER", 35, 28, 2, 1, classInfo[0]);
    curs = 0;
    wait .4;
    self thread sm_startUpPrompt_buttonMonitor();
    for (;;) {
        self waittill("buttonPress", button);
        if (button == "ads" || button == "attack") {
            oldCurs = curs;
            if (isDefined(self.autoPick) && self.autoPick) curs++;
            curs += self attackButtonPressed();
            curs -= self adsButtonPressed();
            if (curs < 0) curs = text.size - 1;
            if (curs > text.size - 1) curs = 0;
            scroll moveOverTime(.2);
            scroll.y = (curs * 35) - 50;
            text[oldCurs] notify("flashThread Over");
            text[oldCurs] thread hudFade(1, .2);
            text[curs] thread flashThread();
            details setText(classDetails[curs]);
            info setText(classInfo[curs]);
            wait .2;
        }
        if (button == "use") {
            self takeAllWeapons();
            self giveWeapon(strTok(classWeapons[curs], "|")[0]);
            self giveWeapon(strTok(classWeapons[curs], "|")[1]);
            self giveMaxAmmo(strTok(classWeapons[curs], "|")[0]);
            self giveMaxAmmo(strTok(classWeapons[curs], "|")[1]);
            self switchToWeapon(strTok(classWeapons[curs], "|")[0]);
            break;
        }
    }
    text[curs] notify("flashThread Over");
    text[curs] hudFade(1, .2);
    curs = 0;
    scroll moveOverTime(.4);
    scroll.y = -50;
    text[0] thread flashThread();
    title thread hudFade(0, .4);
    details thread hudFade(0, .4);
    info thread hudFade(0, .4);
    for (m = 0; m < text.size; m++) {
        text[m] thread hudMoveX(text[m].x - 100, .4);
        text[m] thread hudFade(0, .4);
    }
    wait .4;
    for (m = 0; m < text.size; m++) {
        text[m].x = text[m].x + 200;
        text[m] setText(perk[m]);
        text[m] thread hudMoveX(text[m].x - 100, .4);
        text[m] thread hudFade(1, .4);
    }
    title setText("PICK A PERMANENT PERK!");
    details setText(perkDetails[0]);
    info setText(perkInfo[0]);
    title thread hudFade(1, .4);
    details thread hudFade(1, .4);
    info thread hudFade(1, .4);
    wait .4;
    for (;;) {
        self waittill("buttonPress", button);
        if (button == "ads" || button == "attack") {
            oldCurs = curs;
            if (isDefined(self.autoPick) && self.autoPick) curs++;
            curs += self attackButtonPressed();
            curs -= self adsButtonPressed();
            if (curs < 0) curs = text.size - 1;
            if (curs > text.size - 1) curs = 0;
            scroll moveOverTime(.2);
            scroll.y = (curs * 35) - 50;
            text[oldCurs] notify("flashThread Over");
            text[oldCurs] thread hudFade(1, .2);
            text[curs] thread flashThread();
            details setText(perkDetails[curs]);
            info setText(perkInfo[curs]);
            wait .2;
        }
        if (button == "use") {
            self thread sm_startUpPrompt_givePerk(strTok(perkType[curs], "|")[0], strTok(perkType[curs], "|")[1], strTok(perkType[curs], "|")[2], strTok(perkType[curs], "|")[3]);
            break;
        }
        wait .05;
    }
    text[curs] notify("flashThread Over");
    self freezeControls(false);
    self setBlur(0, 1);
    for (m = 0; m < hud.size; m++) hud[m] destroy();
    for (m = 0; m < text.size; m++) text[m] destroy();
    title destroy();
    scroll destroy();
    details destroy();
    info destroy();
    self.pickingClass = undefined;
    self thread sm_startUpPrompt_afterSpectator();
}
sm_startUpPrompt_givePerk(perk, bottle, jingle, shader) {
    wait 1;
    if (self isSwitchingWeapons()) self waittill("weapon_change_complete");
    self playSound("bottle_dispense3d");
    self playSound(jingle);
    currentWeapon = self getCurrentWeapon();
    self giveWeapon(bottle);
    self switchToWeapon(bottle);
    self disableOffhandWeapons();
    self disableWeaponCycling();
    self allowSprint(false);
    self waittill("weapon_change_complete");
    self enableOffhandWeapons();
    self enableWeaponCycling();
    self allowSprint(true);
    self takeWeapon(bottle);
    self switchToWeapon(currentWeapon);
    self setPerk(perk);
    if (perk == "specialty_armorvest") {
        self.maxhealth = level.zombie_vars["zombie_perk_juggernaut_health"];
        self.health = level.zombie_vars["zombie_perk_juggernaut_health"];
        self thread regenerateJuggUponAccident();
    }
    self setBlur(4, .1);
    wait .1;
    self setBlur(0, .1);
    hud = self createRectangle("CENTER", "CENTER", 0, 0, 10, 10, (1, 1, 1), shader, 1, 1);
    hud scaleOverTime(.1, 50, 50);
    wait .1;
    hud scaleOverTime(1, 25, 25);
    wait 2;
    hud moveOverTime(2);
    hud setPoint("BOTTOM", "BOTTOM", 0, -20);
    wait 2;
    check = self createRectangle("BOTTOM", "BOTTOM", 10, -37, 15, 15, (1, 1, 1), "hud_checkbox_done", 2, 0);
    check hudFade(1, .5);
    self.surv_permaPerkHud = hud;
    self.surv_permaPerkCheck = check;
    self thread sm_startUpPrompt_givePerk_monitor(perk);
    self disableGodMode();
}
sm_startUpPrompt_givePerk_monitor(perk) {
    self endon("disconnect");
    for (;;) {
        wait .05;
        if (self.sessionstate == "spectator") {
            self.surv_permaPerkHud destroy();
            self.surv_permaPerkCheck destroy();
            if (self hasPerk("specialty_armorvest")) {
                self.maxhealth = 100;
                self.health = self.maxhealth;
            }
            self unsetPerk(perk);
            break;
        }
    }
}
regenerateJuggUponAccident() {
    self endon("disconnect");
    for (;;) {
        self waittill("player_downed");
        for (;;) {
            wait .05;
            if (!isDefined(self.revivetrigger) && self.sessionstate == "playing") {
                self.maxhealth = level.zombie_vars["zombie_perk_juggernaut_health"];
                self.health = level.zombie_vars["zombie_perk_juggernaut_health"];
                break;
            }
            if (!isDefined(self.revivetrigger) && self.sessionstate == "spectator") break;
        }
        if (!isDefined(self.revivetrigger) && self.sessionstate == "spectator") break;
    }
    self.maxhealth = 100;
    self.health = self.maxhealth;
}
sm_startUpPrompt_buttonMonitor() {
    self.autoPick = false;
    time = getTime();
    for (;;) {
        wait .05;
        if (getTime() >= time + 10000) {
            self.autoPick = true;
            break;
        }
        if (self useButtonPressed() || self adsButtonPressed() || self attackButtonPressed() || self fragButtonPressed() || self meleeButtonPressed()) break;
    }
    if (self.autoPick) {
        for (m = 0; m < randomInt(4); m++) {
            self notify("buttonPress", "attack");
            wait .5;
        }
        self notify("buttonPress", "use");
        wait 1;
        for (m = 0; m < randomInt(4); m++) {
            self notify("buttonPress", "attack");
            wait .5;
        }
        self notify("buttonPress", "use");
    } else {
        while (isDefined(self.pickingClass)) {
            if (self adsButtonPressed()) self notify("buttonPress", "ads");
            if (self attackButtonPressed()) self notify("buttonPress", "attack");
            if (self useButtonPressed()) self notify("buttonPress", "use");
            wait .05;
        }
    }
}
sm_startUpPrompt_afterSpectator() {
    self endon("disconnect");
    self waittill("player_downed");
    self thread sm_startUpPrompt_decision();
}
sm_startUpPrompt_decision() {
    self endon("disconnect");
    for (;;) {
        if (!isDefined(self.revivetrigger) && self.sessionstate == "spectator") {
            self waittill("spawned_player");
            self thread sm_startUpPrompt();
            break;
        } else if (!isDefined(self.revivetrigger) && self.sessionstate == "playing") {
            self thread sm_startUpPrompt_afterSpectator();
            break;
        }
        wait .05;
    }
}
survivalLunarLanders()
{
    lunar = [];
    lunar[0] = spawnStruct();
    lunar[0] = spawnSM((52, -440, -1.2), "zombie_teleporter_pad");
    lunar[1] = spawnSM((52, -440, -1.2), "zombie_teleporter_pad", (-180, 0, 0));
    playFx(level._effect["zombie_flashback_american"], lunar[0].origin);
    playFx(level._effect["zombie_flashback_american"], (300, -1640, 58));
    lunar[1] linkTo(lunar[0]);
    lunar[0].seat = [];
    for(m = 0; m < 4; m++)
        lunar[0].seat[m] = spawnStruct();
    lunar[0].seat[0] = spawnSM(lunar[0].origin+(0, 50, 20), "tag_origin");
    lunar[0].seat[1] = spawnSM(lunar[0].origin+(0, -50, 20), "tag_origin");
    lunar[0].seat[2] = spawnSM(lunar[0].origin+(50, 0, 20), "tag_origin");
    lunar[0].seat[3] = spawnSM(lunar[0].origin+(-50, 0, 20), "tag_origin");
    for(m = 0; m < lunar[0].seat.size; m++)
    {
        lunar[0].seat[m] linkTo(lunar[0]);
        lunar[0].seat[m].occupied = false;
    }
    lunar[0].ctrlPanel = [];
    lunar[0].ctrlPanel[0] = spawnSM(lunar[0].origin+(0, -8, 40), "zombie_teleporter_control_panel");
    lunar[0].ctrlPanel[1] = spawnSM(lunar[0].origin+(0, 8, 40), "zombie_teleporter_control_panel", (0, 180, 0));
    for(m = 0; m < lunar[0].ctrlPanel.size; m++)
        lunar[0].ctrlPanel[m] linkTo(lunar[0]);
    lunar[0].trig = [];
    lunar[0].trig[0] = spawnTrig(lunar[0].origin, 50, 20, "HINT_NOICON", "Press & Hold &&1 To Use Lunar Lander! [Cost: 750]");
    lunar[0].trig[1] = spawnTrig((300, -1640, 58), 50, 20, "HINT_NOICON", "Press & Hold &&1 To Call Lunar Lander!");
    lunar[0].trig[0] thread lunarThink(lunar[0]);
    lunar[0].trig[1] thread lunarThink(lunar[0]);
    lunar[0].pos = "spawn";
}

lunarThink(lunar)
{
    for(;;)
    {
        self waittill("trigger", m);
        if(m useButtonPressed() && !m.is_zombie && !isDefined(m.revivetrigger) && !isDefined(lunar.isMoving) && !isDefined(level.lunarCooling))
        {
            time = 0;
            while(m useButtonPressed())
            {
                time+= .05;
                if(!m useButtonPressed())
                    break;
                if(time >= .3)
                {
                    distance1 = distance(m.origin, (52, -440, -1.2));//spawn
                    distance2 = distance(m.origin, (300, -1640, 58));//courtyard
                    if(lunar.pos == "spawn"){
                        pos1 = distance1; pos2 = distance2;}
                    else{
                        pos1 = distance2; pos2 = distance1;}
    
                    if(pos1 < pos2) //means player is closer to the purchasing point
                    {
                        if(m.score < 750){
                            m playSound("plr_"+m getEntityNumber()+"_vox_nomoney_perk_0");
                            break;}
                        else
                            m maps\_zombiemode_score::minus_to_player_score(750);
                    }
                    lunar.isMoving = true;
                    for(e = 0; e < getPlayers().size; e++)
                        if(distance(getPlayers()[e].origin, lunar.origin) < 100)
                        {
                            getPlayers()[e] enableGodMode();
                            getPlayers()[e] playerLinkTo(lunar.seat[getPlayers()[e] getEntityNumber()]);
                            getPlayers()[e].isOnLunar = true;
                        }
                    if(lunar.pos == "spawn") lunar thread lunarSpawn2Courtyard();
                    else lunar thread lunarCourtyard2Spawn();
                    wait 9;
                    for(e = 0; e < getPlayers().size; e++)
                        if(isDefined(getPlayers()[e].isOnLunar))
                        {
                            getPlayers()[e] unlink();
                            getPlayers()[e] disableGodMode();
                            getPlayers()[e].isOnLunar = undefined;
                        }
                    lunar.isMoving = undefined;
                }
                wait .05;
            }
        }
    }
}

lunarSpawn2Courtyard()
{
    self.pos = "courtyard";
    self.trig[0] setHintString("Lunar Lander Is In Use!");
    self.trig[1] setHintString("Lunar Lander Is In Use!");
    self moveTo((self.origin[0], self.origin[1], 800), 3, .5, 1);
    self vibrate((0, -100, 0), 1.5, .4, 3);
    wait 3;
    self moveTo((300, -1640, self.origin[2]), 3, .5, 1);
    self rotateTo((5, 0, 10), 1, 0, .5);
    wait 2;
    self rotateTo((0, 0, 0), 1);
    wait 1;
    self moveTo((self.origin[0], self.origin[1], 58), 3, 0, 1);
    self vibrate((0, -100, 0), 1.5, .4, 3);
    wait 3;
    self.trig[0] setHintString("Lunar Lander Is Cooling...");
    self.trig[1] setHintString("Lunar Lander Is Cooling...");
    level.lunarCooling = randomIntRange(15, 30);
    wait(level.lunarCooling);
    level.lunarCooling = undefined;
    self.trig[0] setHintString("Press & Hold &&1 To Call Lunar Lander");
    self.trig[1] setHintString("Press & Hold &&1 To Use Lunar Lander! [Cost: 750]");
}

lunarCourtyard2Spawn()
{
    self.pos = "spawn";
    self.trig[0] setHintString("Lunar Lander Is In Use!");
    self.trig[1] setHintString("Lunar Lander Is In Use!");
    self moveTo((self.origin[0], self.origin[1], 800), 3, .5, 1);
    self vibrate((0, -100, 0), 1.5, .4, 3);
    wait 3;
    self moveTo((52, -440, self.origin[2]), 3, .5, 1);
    self rotateTo((-5, 0, -10), 1, 0, .5);
    wait 2;
    self rotateTo((0, 0, 0), 1);
    wait 1;
    self moveTo((self.origin[0], self.origin[1], -1.2), 3, 0, 1);
    self vibrate((0, -100, 0), 1.5, .4, 3);
    wait 3;
    self.trig[0] setHintString("Lunar Lander Is Cooling...");
    self.trig[1] setHintString("Lunar Lander Is Cooling...");
    level.lunarCooling = randomIntRange(15, 30);
    wait(level.lunarCooling);
    level.lunarCooling = undefined;
    self.trig[0] setHintString("Press & Hold &&1 To Use Lunar Lander! [Cost: 750]");
    self.trig[1] setHintString("Press & Hold &&1 To Call Lunar Lander");
}

rareZombieDrops()
{
    for(;;)
    {
        wait(randomIntRange(200, 400));
        zombz = getAiSpeciesArray("axis", "all");
        chosenZombie = zombz[randomInt(zombz.size)];
        chosenZombie thread rareDropOnDeath();
    }
}

rareDropOnDeath(pickedWeapon)
{
    self waittill("death");
    keys = getArrayKeys(level.zombie_weapons);
    if(!isDefined(pickedWeapon))
        for(;;)
        {
            wait .05;
            pickedWeapon = keys[randomInt(keys.size)];
            if(!isSubStr(pickedWeapon, "upgraded") && !isIllegalWeapon(pickedWeapon))
                break;
        }
    model = spawnSM(self.origin+(0, 0, 50), getWeaponModel(pickedWeapon), self.angles[1]);
    playFxOnTag(level._effect["powerup_on"], model, "tag_origin");
    model thread maps\_zombiemode_powerups::powerup_timeout();
    playSoundAtPosition("spawn_powerup", model.origin);
    model playLoopSound("spawn_powerup_loop");
    model thread bounceAround();
    trig = spawnTrigger(self.origin, 30);
    trig setString("Press [{+activate}] to Trade Weapons!");
    for(;;)
    {
        plr = getPlayers();
        for(m = 0; m < plr.size; m++)
        {
            if(!plr[m].is_zombie && !isDefined(plr[m].revivetrigger) && distance(plr[m].origin, model.origin) < 64 && plr[m] useButtonPressed())
            {
                primaries = plr[m] getWeaponsListPrimaries();
                if(isDefined(primaries) && primaries.size >= 2)
                    plr[m] takeWeapon(plr[m] getCurrentWeapon());
                plr[m] giveWeapon(pickedWeapon);
                plr[m] giveMaxAmmo(pickedWeapon);
                plr[m] switchToWeapon(pickedWeapon);
                model delete();
                break;
            }
        }
        wait .05;
        if(!isDefined(model))
            break;
    }
    trig delete();
}


allTrapped()
{
    for(;;)
    {
        zombie = [];
        if(level.VanillaPlus == true)
		    wait(randomIntRange(450, 750));
		else
            wait(randomIntRange(200, 400));
        for(;;)
        {
            wait .05;
            enemy = getAiSpeciesArray("axis", "all");
            zombie = enemy[randomInt(enemy.size)];
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
        temp thread grabAllTrapped();
    }
}

deleteOnGrab(ent)
{
    ent waittill_any("powerup_timedout", "powerup_grabbed");
    self delete();
}

grabAllTrapped()
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
                p[m] maps\_zombiemode_score::add_to_player_score(3000);
                level thread activateTraps(p[0]);
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

superAmmoPowerup()
{
    for(;;)
    {
        zombie = [];
		if(level.VanillaPlus == true)
		    wait(randomIntRange(450, 750));
		else
            wait(randomIntRange(200, 400));
        for(;;)
        {
            wait .15;
            enemy = getAiSpeciesArray("axis", "all");
            zombie = enemy[randomInt(enemy.size)];
            //while( !IsDefined( zombie ) )
            //{
            //    iprintln("Zobie missing");
            //    wait .1;
            //}
            if(zombie zMap() && !zombie is_boss() )
            {
                iprintln( true );
                //iprintln( "Is in map? " + zombie zmap() );
                //iprintln( "Is Boss Zobie? " + zombie is_boss() );

                break;
            }
            else
            {
                iprintln( false );
                //iprintln( "Is in map? " + zombie zmap() );
                //iprintln( "Is Boss Zobie? " + zombie is_boss() );
            }
        }
        zombie waittill("death");
        point = zombie.origin+(0, 0, 40);
        temp = spawnSM(point, "tag_origin");
        power = spawnMultipleModels(point, 2, 4, 3, 10, 8, 6, "zombie_ammocan");
        for(m = 0; m < power.size; m++)
        {
            playFxOnTag(level._effect["powerup_on"], power[m], "tag_origin");
            power[m] linkTo(temp);
            power[m] thread deleteOnGrab(temp);
            power[m] thread maps\_zombiemode_powerups::powerup_timeout();
        }
        playSoundatPosition("spawn_powerup", temp.origin);
        temp playLoopSound("spawn_powerup_loop");
        temp thread maps\_zombiemode_powerups::powerup_wobble();
        temp thread maps\_zombiemode_powerups::powerup_timeout();
        temp thread grabSuperAmmo();
    }
}

grabSuperAmmo()
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
                level thread doSuperAmmo();
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

doSuperAmmo()
{
level.SuperAmmo = true;
    text = [];
    for(m = 0; m < getPlayers().size; m++)
    {
        getPlayers()[m] playSound("plr_"+getPlayers()[m] getEntityNumber()+"_vox_powerup_ammo_1");
        text[m] = getPlayers()[m] createText(getFont(), 1.5, "BOTTOMRIGHT", "BOTTOMRIGHT", 0, -20, 1, 1, "UNLIMITED AMMO");
		getPlayers()[m] thread maps\vapp::Bottomless_clip();
    }
    maps\vapp::dvar_all("ammoCounterHide", 1);
    wait 30;
	level.SuperAmmo = undefined;
    maps\vapp::dvar_all("ammoCounterHide", 0);
	for(m = 0; m < getPlayers().size; m++){
	getPlayers()[m] notify("Bottomless_Over");
	}
    for(m = 0; m < text.size; m++)
        text[m] destroy();
}
staminUp()
{
    self endon("death");
    self endon("disconnect");
    for(;;)
    {
        weap = self getCurrentWeapon();
        if(isSubStr(weap, "upgraded"))
            self setMoveSpeedScale(1.3);
        else
            self setMoveSpeedScale(1);
        wait .05;
    }
}
tradingMachine()
{
    pap = spawnSM((-473.078, -444.996, 88.3861), "zombie_vending_packapunch_on", (0, -50, 0));
    rollers = spawn("script_origin", pap.origin);
    rollers playLoopSound("packa_rollers_loop");
    sounds = spawn("script_origin", pap.origin);
    lid = spawnSM((-492.646, -461.829, 76.7549), "zombie_treasure_box_lid", (0, -50, 90));
    spawnSM((-487.646, -398.829, 76.7549), "zombie_treasure_box_lid", (0, -140, 90));
    mod = spawnSM((-430.646, -466.829, 76.7549), "zombie_treasure_box_lid", (0, 40, 90));
    mod playLoopSound("packa_rollers_loop");
    spawnSM((-492.646, -461.829, 100.7549), "zombie_treasure_box_lid", (0, -50, 0));
    spawnSM((-474.646, -446.829, 100.775), "zombie_treasure_box_lid", (0, -50, 0));
    spawnSM((-443.646, -419.829, 100.775), "zombie_treasure_box_lid", (0, -50, 0));
    spawnSM((-425.646, -403.829, 100.775), "zombie_treasure_box_lid", (0, -50, -90));
    trig = spawnTrigger(pap.origin-(10, 10, 40), 60);
    trig setString("Press [{+activate}] To Trade Current Weapon for Cash");
    for(;;)
    {
        trig waittill("trigger", user);
        if(user useButtonPressed() && !isDefined(user.revivetrigger) && !user.is_zombie)
        {
            cWeap = user getCurrentWeapon();
            if(!isDefined(level.zombie_include_weapons[cWeap]))
                continue;
            trig setString("");
            pap vibrate((0, -100, 0), .3, .4, 3);
            sounds playSound("packa_weap_upgrade");
            user takeWeapon(cWeap);
            primaries = user getWeaponsListPrimaries();
            if(isDefined(primaries) && primaries.size > 0)
                user switchToWeapon(primaries[0]);
            value = user valueWeapon(cWeap);
            tm_insertWeapon(cWeap, pap.origin+(0, 0, 34), pap.angles+(0, 90, 0));
            if(randomInt(100) <= 10)// Possible chance of taking their weapon and not giving any cash ;)
            {
                sounds playSound("laugh_child");
                playFx(loadFx("misc/fx_zombie_couch_effect"), pap.origin);
            }
            else
            {
                for(m = 0; m < 6; m++)
                {
                    sounds playSound("broken_random_jingle");
                    wait 1;
                }
                lid rotateRoll(90, 1.5, 0, .5);
                sounds playSound("packa_door_1");
                for(e = 0; e < 1.5; e+=.5)
                {
                    sounds playSound("cha_ching");
                    wait .5;
                }
                x2 = spawnSM(pap.origin, "zombie_x2_icon", (0, -50, 0));
                forward = anglesToForward(pap.angles+(0, 90, 0));
                interactPos = pap.origin+(forward*-35);
                x2 moveTo(interactPos, .5);
                wait .5;
                playFxOnTag(level._effect["powerup_on"], x2, "tag_origin");
                sounds playSound("steam_effect");
                wait 1;
                trig setString("Press [{+activate}] To Take Cash");
                pap thread tm_timeout(trig);
                for(;;)
                {
                    trig waittill("trigger", taker);
                    if(taker useButtonPressed() && taker == user)
                    {
                        taker playSound("cha_ching");
                        newValue = int(value)-int(value)%10;
                        if(newValue < value)
                            newValue+= 10;
                        taker maps\_zombiemode_score::add_to_player_score(newValue);
                        taker thread tm_wowEffect(newValue);
                        pap notify("score_taken");
                        break;
                    }
                    else if(taker == level)
                    {
                        sounds playSound("packa_deny");
                        break;
                    }
                }
                x2 delete();
                trig setString("");
                lid rotateRoll(-90, 1.5, 0, .5);
                sounds playSound("packa_door_1");
                wait 2;
            }
            trig setString("Press [{+activate}] To Trade Current Weapon for Cash");
        }
    }
}

tm_timeout(trig)
{
    self endon("score_taken");
    wait(level.packapunch_timeout);
    trig notify("trigger", level);
}

tm_wowEffect(score)
{
    self endon("death");
    self endon("disconnect");
    value = self createText("big", 2, "CENTER", "CENTER", 0, -60, 1, .85, "+"+score);
    value.color = (1, 1, .5);
    while(value.fontScale < 4)
    {
        value.fontScale = min(4, value.fontScale+(2/3));
        wait .05;
    }
    while(value.fontScale > 2)
    {
        value.fontScale = max(2, value.fontScale-(2/5));
        wait .05;
    }
    value thread hudFadenDestroy(0, .75);
}

tm_insertWeapon(currentWeapon, origin, angles)
{
    forward = anglesToForward(angles);
    interactPos = origin+(forward*-25);
    worldGun = spawnSM(interactPos, getWeaponModel(currentWeapon), self.angles);
    playFx(level._effect["packapunch_fx"], origin+(0, -1, -34), forward);
    worldGun rotateTo(angles+(0, 90, 0), .35);
    wait .5;
    worldGun moveTo(origin, .5);
    wait .35;
    worldGun delete();
}

valueWeapon(weap)
{
    multiplier = 0;
    class = weaponClass(weap);
    if(class == "rifle" || class == "pistol")
        multiplier = 3;
    else if(class == "smg" || class == "spread")
        multiplier = 4;
    else
        multiplier = 10;
    baseValue = 500+randomIntRange(100, 300);
    maxAmmunition = (self getWeaponAmmoClip(weap)+self getWeaponAmmoStock(weap));
    if((isSubStr(weap, "30cal") || isSubStr(weap, "mg42")) && maxAmmunition > 300)
        baseValue+= maxAmmunition/2*multiplier;
    else
        baseValue+= maxAmmunition*multiplier;
    startAmmo = weaponStartAmmo(weap);
    baseValue+= startAmmo;
    if(weaponIsSemiAuto(weap))
        baseValue-= baseValue/randomIntRange(3, 4);
    baseValue+= weaponFireTime(weap)/randomInt(8);
    baseValue+= self getWeaponAmmoClip(weap);
    if(isSubStr(weap, "upgraded"))
        baseValue+= randomIntRange(1500, 2000);
    if(isSubStr(weap, "tesla") || isSubStr(weap, "ray"))
        baseValue+= 4000;
    return(baseValue);
}
ammoMachine()
{
    lid = spawnSM((749, -916, 121), "zombie_treasure_box_lid", (0, 0, -90));
    flag = spawnSM((784.906, -915.296, 127.053), "zombie_sign_please_wait", (-90, 180, 0));
    trig = spawnTrig(lid.origin-(0, 0, 40), 20, 20, "HINT_NOICON", "Press &&1 To Use Amm-o-Matic Machine! [Cost: 10000]");
    for(;;)
    {
        trig waittill("trigger", user);
        if(user useButtonPressed() && !user.is_zombie)
        {
            if(user.score < 10000){
                user playSound("plr_"+user getEntityNumber()+"_vox_nomoney_perk_0");
                wait .1;
                continue;}
            user maps\_zombiemode_score::minus_to_player_score(10000);
            lid rotateRoll(-90, 2, 1);
            flag rotatePitch(90, 2, 0, 1);
            wait 2;
            for(m = 0; m < 30; m++)
            {
                ammo = spawnSM(lid.origin-(0, 0, 10), "zombie_ammocan");
                ammo physicsLaunch((randomIntRange(-40, 40), 50, 10));
                ammo thread ammoThread();
                ammo playSound("pa_audio_link_1");
                wait .2;
            }
            lid rotateRoll(90, 2, 0, 1);
            flag rotatePitch(-90, 2, 1);
            wait 2;
        }
    }
}

ammoThread()
{
    wait .1;
    for(;;)
    {
        old = self getOrigin();
        wait .05;
        new = self getOrigin();
        if(old == new)
            break;
    }
    self thread scavDelete();
    trig = spawnTrig(self.origin, 20, 10, "HINT_NOICON", "");
    while(isDefined(self))
    {
        trig waittill("trigger", i);
        i setWeaponAmmoStock(i getCurrentWeapon(), i getWeaponAmmoStock(i getCurrentWeapon())+30);
        playSoundAtPosition("ammo_pickup", self.origin);
        playFx(loadFx("misc/fx_zombie_powerup_wave"), self.origin);
        self delete();
    }
    trig delete();
}
spawnWaterGheyser(orig)
{
    ring = spawnSM(orig, "zombie_teleporter_mainframe_ring3");
    thread waterGheyserStandby(orig);
    trig = spawnTrig(orig, 50, 50, "HINT_NOICON", "");
    for(;;)
    {
        trig waittill("trigger", user);
        if(user.is_zombie || isDefined(user.revivetrigger))
            continue;
        for(m = 0; m < 2; m++)
        {
            earthQuake(.7, 1, orig, 90);
            playFx(level._effect["rise_billow_water"], orig);
            wait .5;
        }
        playFx(level._effect["mortarExp_water"], orig);
        for(m = 0; m < getPlayers().size; m++)
        {
            player = getPlayers()[m];
            if(player isTouching(trig))
                player thread gheyserLaunch();
        }
        wait(randomIntRange(5, 8));
    }
}

waterGheyserStandby(orig)
{
    for(;;)
    {
        playFx(level._effect["rise_billow_water"], orig);
        wait 1;
    }
}

gheyserLaunch()
{
    for(m = 0; m < 5; m++)
    {
        self setVelocity(self getVelocity()+(0, 0, 1000));
        wait .2;
    }
}
survivalPacka()
{
    box = spawnStruct();
    box = spawnSM((684, -841, 109), "zombie_treasure_box", (0, 90, 90));
    lid = spawnSM(box.origin+(17.8, 0, -12), "zombie_treasure_box_lid", (0, 90, 90));
    trig = spawnTrig(box.origin+(40, 0, -40), 30, 30, "HINT_NOICON", "Press &&1 To Steroid-ize Your Weapon! [Cost: 8000]");
    box thread nearPacka(lid, trig);
    box thread openPacka(lid, trig);
    for(;;)
    {
        trig waittill("trigger", user);
        if(user useButtonPressed() && !user.is_zombie)
        {
            currentWeapon = user getCurrentWeapon();
            if(!isDefined(level.zombie_include_weapons[currentWeapon]) || !isDefined(level.zombie_include_weapons[currentWeapon+"_upgraded_zm"])){
                wait .1;
                continue;}
            if(user.score < 8000){
                box playSound("deny");
                user playSound("plr_"+user getEntityNumber()+"_vox_nomoney_perk_0");
                wait .1;
                continue;}
            box.inUse = true;
            user maps\_zombiemode_score::minus_to_player_score(8000);
            box playSound("bottle_dispense3d");
            user playSound("plr_"+user getEntityNumber()+"_vox_gen_laugh_"+randomInt(3));
            box playSound("mx_packa_sting");
            trig setInvisibleToAll();
            user thread nuckleCrack();
            user packaInsert(currentWeapon, box.origin, box.angles+(0, 90, 0), box);
            lid moveZ(-23, .6, 0, .2);
            wait .6;
            lid linkTo(box);
            box thread lightFxs();
            for(m = 0; m < 2; m++)
            {
                box rotateTo((-35, 90, 90), .4);
                wait .4;
                box rotateTo((35, 90, 90), .4);
                wait .4;
            }
            box rotateTo((0, 90, 90), .2);
            wait 1;
            lid unlink();
            lid moveZ(23, .6, 0, .2);
            wait 1;
            user packaGive(currentWeapon, box.origin, box.angles+(0, 90, 0), box);
            box.inUse = undefined;
            wait 1;
            trig setVisibleToAll();
        }
    }
}

packaInsert(currentWeapon, origin, angles, perkMachine)
{
    forward = anglesToForward(angles);
    interactPos = origin+(forward*-25);
    worldGun = spawnSM(interactPos, getWeaponModel(currentWeapon), self.angles);
    worldGun rotateTo((0, 90, 0), .35);
    wait .5;
    worldGun moveTo(origin, .5);
    perkMachine playSound("packa_weap_upgrade");
    wait .35;
    worldGun delete();
}

packaGive(currentWeapon, origin, angles, perkMachine)
{
    forward = anglesToForward(angles);
    interactPos = origin+(forward*-25);
    perkMachine playSound("packa_weap_ready");
    worldGun = spawnSM(origin, getWeaponModel(currentWeapon+"_upgraded_zm"), (0, 90, 0));
    worldGun physicsLaunch((100, 0, 50));
    wait 2;
    playFx(loadFx("maps/zombie/fx_transporter_start"), worldGun.origin);
    worldGun delete();
    worldGun = spawnSM((652, -593, 100), getWeaponModel(currentWeapon+"_upgraded_zm"), (0, -90, 90));
    worldGun endon("pap_timeout");
    worldGun playLoopSound("ticktock_loop");
    playFx(loadFx("maps/zombie/fx_transporter_start"), worldGun.origin);
    trig = spawnTrig(worldGun.origin-(0, 0, 40), 30, 30, "HINT_NOICON", "Press &&1 to Take Weapon!");
    trig setInvisibleToAll();
    trig setVisibleToPlayer(self);
    worldGun thread packaTimout(trig);
    for(;;)
    {
        trig waittill("trigger", user);
        if(user useButtonPressed() && user == self)
        {
            worldGun notify("pap_taken");
            weap = currentWeapon+"_upgraded_zm";
            primaries = self getWeaponsListPrimaries();
            if(isDefined(primaries) && primaries.size >= 2)
                self takeWeapon(self getCurrentWeapon());
            self giveWeapon(weap);
            self giveMaxAmmo(weap);
            self switchToWeapon(weap);
            self playSound("plr_"+self getEntityNumber()+"_vox_perk_packa_get_"+randomInt(5));
            break;
        }
    }
    worldGun delete();
    trig delete();
}

packaTimout(trig)
{
    self endon("pap_taken");
    wait(level.packapunch_timeout);
    self stopLoopSound(.05);
    self playSound("packa_deny");
    wait .05;
    self delete();
    trig delete();
    self notify("pap_timeout");
}
lightFxs()
{
    pos = self.origin+(10, 0, 0);
    for(m = 0; m < 14; m++)
    {
        lt = [];
        lt[0] = spawnSM(pos+(randomIntRange(-10, 10), randomIntRange(-40, 40), randomIntRange(-20, 20)), "tag_origin");
        playFxOnTag(loadFx("maps/zombie/fx_zombie_light_glow_green"), lt[0], "tag_origin");
        lt[1] = spawnSM(pos+(randomIntRange(-10, 10), randomIntRange(-40, 40), randomIntRange(-20, 20)), "tag_origin");
        playFxOnTag(loadFx("maps/zombie/fx_zombie_light_glow_green"), lt[1], "tag_origin");
        lt[2] = spawnSM(pos+(randomIntRange(-10, 10), randomIntRange(-40, 40), randomIntRange(-20, 20)), "tag_origin");
        playFxOnTag(loadFx("maps/zombie/fx_zombie_light_glow_red"), lt[2], "tag_origin");
        lt[3] = spawnSM(pos+(randomIntRange(-10, 10), randomIntRange(-40, 40), randomIntRange(-20, 20)), "tag_origin");
        playFxOnTag(loadFx("maps/zombie/fx_zombie_light_glow_red"), lt[3], "tag_origin");
        wait .2;
        array_delete(lt);
    }
}

openPacka(lid, trig)
{
    door = getEntArray("zombie_door", "targetname");
    door[1].doors[0].origin = self.origin+(38, 0, 60);
    door[1].doors[0].angles = (90, 0, 90);
    door[1].doors[0] hide();
    door[1].doors[0] solid();
    for(;;)
    {
        self waittill("open_packa");
        self playSound("shoot_off");
        self moveX(18, .6, 0, .2);
        lid moveX(18, .6, 0, .2);
        wait .6;
        lid moveZ(23, .6, 0, .2);
        wait 1;
        trig trigger_on_proc();
        self waittill("close_packa");
        trig trigger_off_proc();
        lid moveZ(-23, .6, 0, .2);
        wait .6;
        self playSound("shoot_off");
        self moveX(-18, .6, 0, .2);
        lid moveX(-18, .6, 0, .2);
        wait .6;
        lid.origin = self.origin+(17.8, 0, -12);
        wait .4;
    }
}

nearPacka()
{
    for(;;)
    {
        if(isDefined(self.inUse)){
            wait .05;
            continue;}
        plr = getPlayers();
        bool = false;
        for(m = 0; m < plr.size; m++)
        {
            pos = plr[m].origin;
            if(pos[0] > 715 && pos[0] < 860 && pos[1] > -920 && pos[1] < -750){
                bool = true;
                break;}
        }
        if(bool)
        {
            self notify("open_packa");
            wait .05;
            continue;
        }
        wait .05;
        self notify("close_packa");
    }
}
spawnAutoTurret(turretWeapon, turretOrigin, turretAngles)
{
    turret = spawnStruct();
    turret.weapon = spawnSM(turretOrigin, getWeaponModel(turretWeapon), turretAngles);
    turret.trig = spawnTrig(turret.weapon.origin, 60, 60, "HINT_NOICON", "Press &&1 To Activate Turret! [Cost: 1500]");
    for(;;)
    {
        turret.trig waittill("trigger", i);
        if(i useButtonPressed() && i.score >= 1500 && !i.is_zombie && !isDefined(i.revivetrigger))
        {
            i maps\_zombiemode_score::minus_to_player_score(1500);
            turret.trig setHintString("");
            turret thread controlTurret(turretWeapon);
            wait 45;
            turret notify("overHeated");
            turret.isNotTargetting = undefined;
            turret.weapon notify("forced_endon");
            turret.weapon rotateTo((0, 40, 0), 1, 0, .5);
            turret.trig setHintString("Turret Cooling Down...");
            wait(randomIntRange(20, 40));
            turret.trig setHintString("Press &&1 To Activate Turret! [Cost: 1500]");
        }
    }
}

turretAngles()
{
    self endon("forced_endon");
    for(;;)
    {
        self rotateTo((0, -40, 0), 2.6, .5, .5);
        wait 2.6;
        self rotateTo((0, 120, 0), 2.6, .5, .5);
        wait 2.6;
    }
}

controlTurret(turretWeapon)
{
    self endon("overHeated");
    for(;;)
    {
        enemy = getClosest(self.weapon.origin, getAiSpeciesArray("axis", "all"));
        if(isDefined(enemy) && enemy damageConeTrace(self.weapon.origin, self.weapon) > .75 && !isDefined(enemy.targetted))
        {
            enemy.targetted = true;
            self.isNotTargetting = undefined;
            self.weapon notify("forced_endon");
            self.weapon rotateTo(vectorToAngles(enemy getTagOrigin("j_spine4")-self.weapon.origin), .2);
            wait .2;
            //magicBullet(turretWeapon, self.weapon getTagOrigin("tag_flash"), enemy getTagOrigin("j_spine4"));
            self.weapon thread turret_projectile(enemy);
            wait(weaponFireTime(turretWeapon));
        }
        else if(getAiSpeciesArray("axis", "all").size == 0 || !enemy damageConeTrace(self.weapon.origin, self.weapon) > .75)
            if(!isDefined(self.isNotTargetting)){
                self.weapon thread turretAngles();
                self.isNotTargetting = true;}
        wait .05;
    }
}

turret_projectile(zom)
{
    orb = spawnSM(self getTagOrigin("tag_flash"), "tag_origin");
    playFxOnTag(loadFx("misc/fx_zombie_powerup_on"), orb, "tag_origin");
    self playSound("weap_rgun_fire_plr");
    for(;;)
    {
        orb moveTo(zom getTagOrigin("j_spine4"), distance(orb.origin, zom getTagOrigin("j_spine4"))/150);
        wait .05;
        if(distance(orb.origin, zom getTagOrigin("j_spine4")) <= 10)
            break;
    }
    playSoundAtPosition("weap_rgun_exp", orb.origin);
    playFx(loadFx("misc/fx_zombie_powerup_grab"), orb.origin);
    playFx(loadFx("misc/fx_zombie_powerup_wave"), orb.origin);
    killZombiesWithinDistance(orb.origin-(0, 0, 40), 100, "tesla");
    earthQuake(.2, 1, orb.origin, 100);
    orb delete();
}

knifeTrap()
{
    teddy = spawnSM((839, -1208, 203), "zombie_teddybear");
    db1 = spawnSM((1000, -1329, 216), getWeaponModel("zombie_doublebarrel"), (0, 110, 0));
    db2 = spawnSM((857, -1329, 216), db1.model, (0, 70, 0));
    knives = spawnMultipleModels((996, -1186, 282), 10, 1, 1, -15, 0, 0, "viewmodel_knife_bowie", (90, 0, 0));
    for(m = 5; m < knives.size; m++)
        knives[m].angles = (90, 180, 0);
    trig = spawnTrig(teddy.origin-(0, 0, 40), 20, 20, "HINT_NOICON", "Press &&1 To Unleash Knife & Shotty Crime! [Cost: 2500]");
    level.additionTrigs["knifeTrap"] = trig;
    for(;;)
    {
        trig waittill("trigger", user, check);
        if(!isDefined(check)){
            if(!user useButtonPressed()) continue;
            if(user.is_zombie) continue;
            if(isDefined(user.revivetrigger)) continue;
            if(user.score < 2500){user playSound("plr_"+user getEntityNumber()+"_vox_nomoney_perk_0"); continue;}
            user maps\_zombiemode_score::minus_to_player_score(2500);}
        trig setInvisibleToAll();
        for(m = 0; m < knives.size; m++)
            knives[m] thread doKnifeTrap();
        db1 thread doDBTrap();
        db2 doDBTrap();
        wait(randomIntRange(30, 45));
        trig setVisibleToAll();
    }
}

doDBTrap()
{
    angs = self.angles;
    weapon = "zombie_doublebarrel";
    for(m = 0; m <= 20; m+=.05)
    {
        enemy = getClosest(self getTagOrigin("tag_flash"), getAiSpeciesArray("axis", "all"));
        if(isDefined(enemy) && enemy damageConeTrace(self getTagOrigin("tag_flash"), self) > .75)
        {
            self rotateTo(vectorToAngles(enemy getTagOrigin("j_head")-self.origin), .2);
            wait .2;
            magicBullet(weapon, self getTagOrigin("tag_flash"), enemy getTagOrigin("j_head"));
            wait(weaponFireTime(weapon));
        }
        else if(getAiSpeciesArray("axis", "all").size == 0 || !enemy damageConeTrace(self getTagOrigin("tag_flash"), self.weapon) > .75)
            self rotateTo(angs, .2);
        wait .05;
    }
    self rotateTo(angs, .2);
}

doKnifeTrap()
{
    for(m = 0; m < 20; m++)
    {
        orig = self.origin;
        self moveZ(-150, 1, .5);
        t = 0;
        for(e = 0; e <= 1; e+=.05)
        {
            t++;
            if(e == .5){
                self playSound("knife_stab_plr");
                self playSound("melee_knife_hit_other");}
            damageLoc = orig-(0, 0, t*7.5);
            self thread killZombiesWithinDistance(damageLoc, 30, "headGib");
            self thread doPlayerDamage(damageLoc, 30);
            wait .05;
        }
        wait .05;
        self hide();
        wait .05;
        self.origin+=(0, 0, 150);
        wait .05;
        self show();
    }
}

startEasterEgg()
{
    targ = easterEggTrig();
    array_thread(getPlayers(), ::welcomeText, "^1"+level.patch, "EASTER EGG STARTED! -- ^2Created By: ^7"+level.patchCreator);
    playSoundAtPosition("sam_fly_laugh", targ.origin);
    level NODE1();
    array_thread(getPlayers(), ::welcomeText, "^1"+level.patch, "^2NODE 1 ^7- THE FLAGS ARE FREE! ^7-- ^2Created By: ^7"+level.patchCreator);
    link = spawnSM(level.eeFlags[1].origin+(0, 0, 10), "tag_origin");
    for(m = 0; m < level.eeFlags.size; m++)
        level.eeFlags[m] linkTo(link);
    getPlayers()[0] playSound("flytrap_spin");
    playFxOnTag(loadFx("misc/fx_zombie_powerup_on"), link, "tag_origin");
    link rotateYaw(3600, 15, 5);
    link moveZ(250, 15, 5);
    wait 15;
    playFxOnTag(loadFx("maps/zombie/fx_transporter_beam"), link, "tag_origin");
    link playSound("shoot_off");
    link moveTo((randomIntRange(-2000, 2000), randomIntRange(-2000, 2000), randomIntRange(1500, 2000)), 1);
    wait 1;
    for(m = 0; m < level.eeFlags.size; m++)
        level.eeFlags[m] delete();
    link delete();

    orig[0] = (-639.65, -345.875, 265.163); ang[0] = (90, 90, 0);
    orig[1] = (1442.46, -268.944, 87.231); ang[1] = (90, 90, 0);
    orig[2] = (-592.875, -1553.52, 116.557); ang[2] = (90, 90, 90);
    randy = randomInt(orig.size);
    lever = spawnSM(orig[randy], "zombie_power_lever_handle", ang[randy]);
    level.eggLever = lever;
    playFxOnTag(level._effect["powerup_on"], lever, "tag_origin");
    level waittill("leverCaptured");
    array_thread(getPlayers(), ::welcomeText, "^1"+level.patch, "^2NODE 2 ^7- LEVER CAPTURED! -- ^2Created By: ^7"+level.patchCreator);
    playFx(loadFx("maps/zombie/fx_transporter_beam"), lever.origin);
    lever.origin = (56, 130, 130);
    lever.angles = (0, 90, 0);
    playFx(level._effect["powerup_on"], (1066.9, -1364.13, 193.125));
    suck = [];
    for(m = 0; m <= 360; m+=10)
    {
        suck[suck.size] = spawnSM((970, -1889.1, -11)+(cos(m)*8, sin(m)*8, 0), "zombie_brain", (0, m, 0));
        wait .05;
    }
    for(m = 1; m < suck.size; m++)
        suck[m] linkTo(suck[0]);
    suck = suck[0];
    suck.angles = (-45, 0, 0);
    for(;;)
    {
        for(m = 0; m < getPlayers().size; m++)
        {
            player = getPlayers()[m];
            if(distance(player.origin, lever.origin) < 50 && !isDefined(player.revivetrigger) && isDefined(player))
            {
                for(;;)
                {
                    player = getPlayers()[m];
                    lever = spawnSM(orig[randy], "zombie_power_lever_handle", ang[randy]);
                    pos = bulletTrace(player getEye(), player getEye()+vectorScale(anglesToforward(player getPlayerAngles()), 60), false, lever)["position"];
                    lever moveTo(pos, .1);
                    if(distance(lever.origin, (1066.9, -1364.13, 193.125)) < 50 || isDefined(player.revivetrigger) || !isDefined(player))
                        break;
                    wait .05;
                }
            }
        }
        if(distance(lever.origin, (1066.9, -1364.13, 193.125)) < 50)
            break;
        lever.origin = (56, 130, 130);
        wait .05;
    }
    array_thread(getPlayers(), ::welcomeText, "^1"+level.patch, "^2NODE 2 ^7- LEVER PLACED! -- ^2Created By: ^7"+level.patchCreator);
    lever moveTo((1066.9, -1364.13, 193.125), 1);
    lever rotateTo((0, 0, 90), 1);
    wait 5;
    juggTrig = spawnTrig((1069, -1403, 135), 10, 10, "HINT_NOICON", "Press &&1 To Reveal The Pyramid of Doctors Redemption!");
    for(;;)
    {
        juggTrig waittill("trigger", user);
        if(user useButtonPressed() && !user.is_zombie)
        {
            lever rotateTo((0, 0, 0), .5, .2);
            lever playSound("switch_flip");
            lever playSound("lever_pull_warmup");
            break;
        }
    }
    juggTrig setHintString("");
    array_thread(getPlayers(), ::welcomeText, "^1"+level.patch, "^2NODE 2 ^7- PYRAMID REVEALED! -- ^2Created By: ^7"+level.patchCreator);
    playSoundAtPosition("ann_vox_magicbox", lever.origin);
    bottom = spawnMultipleModels((982.007, -1838.97, -36.1155), 5, 5, 1, 25, -25, 0, "static_peleliu_crate01_short");
    middle = spawnMultipleModels(bottom[6].origin+(0, 0, 25), 3, 3, 1, 25, -25, 0, "static_peleliu_crate01_short");
    top = spawnSM((middle[4].origin+(0, 0, 25)), "static_peleliu_crate01_short");
    for(m = 0; m < bottom.size; m++)
        bottom[m] moveZ(100, 5, 0, 2);
    for(m = 0; m < middle.size; m++)
        middle[m] moveZ(100, 5, 0, 2);
    top moveZ(100, 5, 0, 2);
    suck moveTo((990, -1889.1, 108), 5, 0, 2);
    wait 5;
    array_thread(getPlayers(), ::welcomeText, "^1"+level.patch, "^2NODE 3 ^7- HACK THE INTEL! -- ^2Created By: ^7"+level.patchCreator);
    desk = spawnSM((644, 49, 66), "static_berlin_metal_desk", (0, 180, 0));
    radio = spawnSM((646, 44, 100), "static_berlin_ger_radio", (0, 90, 0));
    radio2 = spawnSM(desk.origin+(-20, 0, 34), "static_berlin_ger_radio", (0, 65, 0));
    radio2 playLoopSound("radio_static");
    radio3 = spawnSM(radio2.origin+(0, 0, 9), "static_berlin_ger_radio", (0, 55, 0));
    lamp = spawnSM((644, 28, 173), "lights_indlight_on", (0, 90, 0));
    lampFx = spawnSM(lamp.origin+(0, 30, -7), "tag_origin", (90, 0, 0));
    playFxOnTag(loadFx("maps/mp_maps/fx_mp_light_lamp"), lampFx, "tag_origin");
    nameTag = spawnSM(desk.origin+(0, 10, 34), "zombie_nameplate_maxis", (0, 180, 0));
    betty = spawnSM((674, 49, 106), getWeaponModel("mine_bouncing_betty"));
    ray = spawnSM((672, 63, 102), getWeaponModel("ray_gun_zm"), (0, 45, 90));
    door = getEntArray("zombie_door", "targetname");
    door[4].doors[0].origin = (653, 66, 100); door[4].doors[0] hide();
    door[4].doors[1].origin = door[4].doors[0].origin-(0, 20, 0); door[4].doors[1] hide();
    trig = spawnTrig((644, 88, 66), 10, 10, "HINT_NOICON", "Press & Hold &&1 To Hack Intel!");
    completed = false;
    for(;;)
    {
        for(m = 0; m < getPlayers().size; m++)
            trig setInvisibleToPlayer(getPlayers()[m]);
        trig waittill("trigger", user);
        if(user.is_zombie || isDefined(user.revivetrigger))
            continue;
        if(isSubStr(user getCurrentWeapon(), "mine"))
        {
            trig setVisibleToPlayer(user);
            if(user useButtonPressed())
            {
                radio playLoopSound("homepad_power_loop");
                trig setVisibleToPlayer(user);
                time = 0;
                bar = user createPrimaryProgressBar();
                bar updateBar(0, 1/30);
                text = user createPrimaryProgressBarText();
                while(user useButtonPressed() && user isTouching(trig) && isSubStr(user getCurrentWeapon(), "mine"))
                {
                    time+= .05;
                    text setText("Hacking "+ceil((time/30)*100)+"/100");
                    if(!user useButtonPressed() || !user isTouching(trig) || !isSubStr(user getCurrentWeapon(), "mine"))
                        break;
                    if(time >= 30)
                    {
                        bar destroyElem();
                        text destroy();
                        completed = true;
                        break;
                    }
                    wait .05;
                }
                radio stopLoopSound();
                if(isDefined(bar)){
                    bar destroyElem();
                    text destroy();}
                if(completed)
                    break;
            }
        }
        wait .05;
        trig setInvisibleToPlayer(user);
    }
    trig delete();
    radio playSound("radio_two");
    array_thread(getPlayers(), ::welcomeText, "^1"+level.patch, "^2NODE 3 ^7- FINISH THE JOB! -- ^2Created By: ^7"+level.patchCreator);
    sphere = spawnSM((1265, 696, 244), "test_sphere_silver");
    link = spawnSM(sphere.origin, "tag_origin");
    pt = [];
    for(m = 0; m < 8; m++){
        pt[m] = spawnSM(sphere.origin+(cos(m*45)*50, sin(m*45)*50, 0), "tag_origin");
        pt[m] linkTo(link);}
    ball = [];
    for(m = 0; m <= 360; m+=10)
    {
        ball[ball.size] = spawnSM(sphere.origin, "zombie_brain", (0, m, 0));
        ball[ball.size] = spawnSM(ball[0].origin-(0, 0, 3), "zombie_brain", (180, m, 0));
        wait .05;
    }
    for(m = 1; m < ball.size; m++)
        ball[m] linkTo(ball[0]);
    list = strTok("projectile_usa_m9a1_riflegrenade;zombie_perk_bottle_sleight;zombie_perk_bottle_revive;zombie_perk_bottle_doubletap;zombie_perk_bottle_jugg;zombie_teleporter_control_panel;weapon_zombie_monkey_bomb;"+getWeaponModel("mine_bouncing_betty")+"", ";");
    list = array_randomize(list);
    ptPick = array_randomize(pt);
    link thread rotateEntYaw(360, 4);
    lever2 = spawnSM((1385, 359, 113), "zombie_zapper_wall_control", (0, 90, 0));
    handle = spawnSM((1374.5, 354, 109), "zombie_zapper_handle", (180, -90, 0));
    optNum = 0;
    for(;;)
    {
        wait .05;
        zom = getAiSpeciesArray("axis", "all");
        if(!isDefined(zom) || !isDefined(zom.size) || (isDefined(zom.size) && zom.size == 0))
            continue;
        
        zomb = zom[randomInt(zom.size)];
        if(!isDefined(zomb) || !zomb inMap() || !isAlive(zomb) || zomb.health <= 1)
            continue;
        optNum++;
        zomb waittill("death");
        bool = zomb ee_dropPiece(sphere, ptPick[optNum], list[optNum], optNum+1);
        if(!bool)
            optNum--;
        if(optNum == 8)
            break;
        wait(randomIntRange(30, 45));
    }
    array_thread(getPlayers(), ::welcomeText, "^1"+level.patch, "^2NODE 4 ^7- Shrink The Sphere! -- ^2Created By: ^7"+level.patchCreator);
    trig = spawnTrig(handle.origin-(0, 0, 40), 20, 20, "HINT_NOICON", "Press &&1 To Shrink Sphere!");
    for(;;)
    {
        trig waittill("trigger", user);
        if(user useButtonPressed() && !user.is_zombie)
        {
            handle rotatePitch(-180, 1);
            wait 1;
            wait .05;
            handle rotatePitch(180, 1);
            break;
        }
    }
    trig delete();
    for(m = 0; m < pt.size; m++)
    {
        pt[m] unlink();
        pt[m] moveTo(sphere.origin, 5, 2);
    }
    for(m = 0; m < 5; m++)
    {
        earthquake(m*.3, 1, sphere.origin, 1000);
        sphere playSound("pa_audio_link_"+(5-m));
        wait 1;
    }
    for(m = 0; m < 20; m++)
    {
        earthquake(3, .2, sphere.origin, 1000);
        sphere playSound("grenade_explode");
        sphere playSound("gen_start");
        sphere playSound("weap_rgun_flux_r");
        playFx(loadFx("explosions/default_explosion"), sphere.origin);
        playFx(loadFx("weapon/bouncing_betty/fx_explosion_betty_generic"), sphere.origin);
        playFx(loadFx("explosions/default_explosion"), sphere.origin);
        killZombiesWithinDistance(sphere.origin, 1000, "headGib");
        wait .2;
    }
    for(m = 0; m < pt.size; m++)
        pt[m] delete();
    sphere delete();
    ball[0] playLoopSound("meteor_loop");
    thread playLoopedFxOnTags(level._effect["monkey_glow"], ball[0], "tag_origin", 13);
    wait 2;
    array_thread(getPlayers(), ::welcomeText, "^1"+level.patch, "^2NODE 5 ^7- I'm Repairing The Perk Machines! -- ^2Created By: ^7"+level.patchCreator);
    ent = getEnt("trig_ee_exp_monkey", "targetname");
    ent.origin = ball[0].origin;
    upgraded_hit = false;
    while(!upgraded_hit)
    {
        ent waittill("damage", amount, inflictor, direction, point, mod);
        if(isSubStr(inflictor getCurrentWeapon(), "upgrade"))
            upgraded_hit = true;
    }
    desk delete();
    radio delete();
    radio2 delete();
    radio3 delete();
    lamp delete();
    lampFx delete();
    nameTag delete();
    betty delete();
    ray delete();
    ball[1] playSound("full_ammo");
    o[0] = (792, 1148, 235);
    o[1] = (908, 615, 265);
    o[2] = (570, 371, 265);
    o[3] = (211, 726, 338);
    o[4] = (-368, -760, 108);
    for(m = 0; m < o.size; m++)
    {
        time = (distance(ball[m].origin, o[m])/80);
        ball[0] moveTo(o[m], time);
        if(m == (o.size-1))
            ball[0] rotateTo((0, 0, 0), time);
        else
            ball[0] rotateTo((randomIntRange(-360, 360), randomIntRange(-360, 360), randomIntRange(-360, 360)), time);
        wait(time);
        ball[1] playSound("full_ammo");
    }
    for(m = 0; m < 10; m++)
    {
        ball[0] moveY(20, .2);
        wait .2;
        ball[0] moveY(-20, .2);
        ball[0] playSound("power_down_2d");
        wait .2;
    }
    perkMachines = getEntArray("zombie_vending", "targetname");
    for(m = 0; m < perkMachines.size; m++)
        if(perkMachines[m].script_noteworthy == "specialty_fastreload")
            perkMachines[m] thread doPerkRevive("sleight");
    array_thread(getPlayers(), ::welcomeText, "^1"+level.patch, "^2NODE 5 ^7- Speed Cola Repaired! -- ^2Created By: ^7"+level.patchCreator);
    damageTriggerMelee(ball[0].origin);
    damageTriggerMelee();
    o = undefined;
    o[0] = (-106, -679, 177);
    o[1] = (-8, -878, 297);
    o[2] = (-328, -939, 248);
    o[3] = (-366, -1043, 239);
    for(m = 0; m < o.size; m++)
    {
        time = (distance(ball[m].origin, o[m])/80);
        ball[0] moveTo(o[m], time);
        if(m == (o.size-1))
            ball[0] rotateTo((0, 0, 0), time);
        else
            ball[0] rotateTo((randomIntRange(-360, 360), randomIntRange(-360, 360), randomIntRange(-360, 360)), time);
        wait(time);
        ball[1] playSound("full_ammo");
    }
    for(m = 0; m < 10; m++)
    {
        ball[0] moveY(20, .2);
        wait .2;
        ball[0] moveY(-20, .2);
        ball[0] playSound("power_down_2d");
        wait .2;
    }
    for(m = 0; m < perkMachines.size; m++)
        if(perkMachines[m].script_noteworthy == "specialty_rof")
            perkMachines[m] thread doPerkRevive("doubletap");
    array_thread(getPlayers(), ::welcomeText, "^1"+level.patch, "^2NODE 5 ^7- Double Tap Repaired! -- ^2Created By: ^7"+level.patchCreator);
    damageTriggerMelee(ball[0].origin);
    damageTriggerMelee();
    o = undefined;
    o[0] = (-228, -948, 250);
    o[1] = (-353, -1967, 262);
    o[2] = (-66, -1685, 583);
    o[3] = (-202, -2119, 156);
    o[4] = (-350, -2330, 218);
    o[5] = (-475, -2100, 184);
    for(m = 0; m < o.size; m++)
    {
        time = (distance(ball[m].origin, o[m])/80);
        ball[0] moveTo(o[m], time);
        if(m == (o.size-1))
            ball[0] rotateTo((0, 0, 0), time);
        else
            ball[0] rotateTo((randomIntRange(-360, 360), randomIntRange(-360, 360), randomIntRange(-360, 360)), time);
        wait(time);
        ball[1] playSound("full_ammo");
    }
    for(m = 0; m < 10; m++)
    {
        ball[0] moveY(-20, .2);
        wait .2;
        ball[0] moveY(20, .2);
        ball[0] playSound("power_down_2d");
        wait .2;
    }
    for(m = 0; m < perkMachines.size; m++)
        if(perkMachines[m].script_noteworthy == "specialty_quickrevive")
            perkMachines[m] thread doPerkRevive("revive");
    array_thread(getPlayers(), ::welcomeText, "^1"+level.patch, "^2NODE 5 ^7- Quick Revive Repaired! -- ^2Created By: ^7"+level.patchCreator);
    damageTriggerMelee(ball[0].origin);
    damageTriggerMelee();
    o = undefined;
    o[0] = (-228, -2163, 341);
    o[1] = (-101, -2253, 50);
    o[2] = (-37, -2289, 134);
    o[3] = (8, -2288, 88.125);
    o[4] = (713, -2182, 978);
    o[5] = (1720, -1610, 1567);
    for(m = 0; m < o.size; m++)
    {
        time = (distance(ball[m].origin, o[m])/80);
        ball[0] moveTo(o[m], time);
        if(m == (o.size-1))
            ball[0] rotateTo((0, 0, 0), time);
        else
            ball[0] rotateTo((randomIntRange(-360, 360), randomIntRange(-360, 360), randomIntRange(-360, 360)), time);
        wait(time);
        ball[1] playSound("full_ammo");
    }
    wait 2;
    playFx(loadFx("explosions/mortarExp_water"), ball[0].origin);
    for(m = 0; m < getPlayers().size; m++)
        earthquake(.3, 3, getPlayers()[m].origin, 50);
    link = spawnSM((1210, -1621, 1567), "tag_origin");
    ball[0] linkTo(link);
    link rotatePitch(-180, 3);
    wait 3;
    link delete();
    ball[0] moveTo((674, -1420, 227), 3);
    wait 3;
    for(m = 0; m < 10; m++)
    {
        ball[0] moveX(20, .2);
        wait .2;
        ball[0] moveX(-20, .2);
        ball[0] playSound("power_down_2d");
        wait .2;
    }
    for(m = 0; m < perkMachines.size; m++)
        if(perkMachines[m].script_noteworthy == "specialty_armorvest")
            perkMachines[m] thread doPerkRevive("jugg");
    array_thread(getPlayers(), ::welcomeText, "^1"+level.patch, "^2NODE 5 ^7- Jugger-Nog Repaired! -- ^2Created By: ^7"+level.patchCreator);
    damageTriggerMelee(ball[0].origin);
    damageTriggerMelee();
    o = undefined;
    o[0] = (926, -1443, 133);
    o[1] = (1323, -1443, 486);
    o[2] = (649, -1770, 317);
    o[3] = (983, -1889.1, 104);
    for(m = 0; m < o.size; m++)
    {
        time = (distance(ball[m].origin, o[m])/80);
        ball[0] moveTo(o[m], time);
        if(m == (o.size-1))
            ball[0] rotateTo((-45, 0, 0), time);
        else
            ball[0] rotateTo((randomIntRange(-360, 360), randomIntRange(-360, 360), randomIntRange(-360, 360)), time);
        wait(time);
        ball[1] playSound("full_ammo");
    }
    ball[0] playSound("grenade_explode");
    ball[0] notify("loopedFx_over");
    playFxOnTag(loadFx("maps/zombie/fx_zombie_wire_spark"), ball[0], "tag_origin");
    array_thread(getPlayers(), ::welcomeText, "^1"+level.patch, "^2NODE 5 ^7- Vril Sphere Secured! -- ^2Created By: ^7"+level.patchCreator);
    for(m = 0; m < ball.size; m++)
    {
        ball[m] delete();
        wait .05;
    }
    //Filling containers//
    pos = strTok("874 -1117 162 983 -1252 160 1283 -1497 133 749 -1392 133", " ");
    containers = [];
    for(m = 0; m < pos.size; m+=3)
    {
        size = containers.size;
        containers[size] = spawnStruct();
        containers[size] = spawnSM((int(pos[m]), int(pos[m+1]), int(pos[m+2]))-(0, 0, 35), "zombie_beaker_brain");
        containers[size].fx = spawnSM(containers[size].origin, "tag_origin", (-90, 0, 0));
        containers[size].fx linkTo(containers[size]);
        containers[size] moveZ(4, 1, 0, .5);
        containers[size].souls = 0;
    }
    level thread soulsAmmo();
    for(;;)
    {
        wait .05;
        for(e = 0; e < containers.size; e++)
            if(containers[e].souls == 25)
            {
                containers[e].souls++;
                playFxOnTag(loadFx("maps/mp_maps/fx_mp_light_lamp"), containers[e].fx, "tag_origin");
            }
        if(containers[0].souls == 26 && containers[1].souls == 26 && containers[2].souls == 26 && containers[3].souls == 26)
            break;
        zom = getAiSpeciesArray("axis", "all");
        for(m = 0; m < zom.size; m++)
        {
            if(!isDefined(zom[m].soulCapping))
                zom[m] thread processSouls(containers);
        }
    }
    array_thread(getPlayers(), ::welcomeText, "^1"+level.patch, "^2NODE 6 ^7- Cylindrical Containers Filled! -- ^2Created By: ^7"+level.patchCreator);
    level notify("soulsAmmo_over");
    lever thread leverAlert();
    lever rotateTo((0, 0, 90), 1);
    wait 1;
    juggTrig setHintString("Press &&1 To Reveal The Master!");
    for(;;)
    {
        juggTrig waittill("trigger", user);
        if(user useButtonPressed() && !user.is_zombie)
        {
            lever rotateTo((0, 0, 0), .5, .2);
            lever playSound("switch_flip");
            lever playSound("lever_pull_warmup");
            break;
        }
    }
    juggTrig delete();
    for(m = 0; m < containers.size; m++)
        containers[m] moveZ(-40, 2, 1);
    for(m = 0; m < 4; m++)
        containers[m].fx delete();
    lever notify("buzz_over");
    lever playSound("laugh_child");
    top moveZ(-50, 1, .2);
    top playSound("ray_reload_open");
    wait .5;
    sam = spawnSM(bottom[12].origin, "defaultactor", (0, 180, 0));
    sam moveZ(50, 5, 0, 2);
    sam rotateYaw(1080, 5, 0, 2);
    wait 5;
    array_thread(getPlayers(), ::welcomeText, "^1"+level.patch, "^2NODE 6 ^7- Doctors Grand Scheme ^1COMPLETED! ^7-- ^2Created By: ^7"+level.patchCreator);
    sam thread slowlyMoveSam();
    for(m = 0; m < getPlayers().size; m++)
    {
        getPlayers()[m] giveWeapon("mp40_upgraded_zm");
        getPlayers()[m] thread giveAllPerks();
        getPlayers()[m] thread deathMachine();
        getPlayers()[m] setClientDvar("jump_height", 1000);
        getPlayers()[m].menuMoves = 0;
    }
    maps\_zombiemode_powerups::full_ammo_powerup(getPlayers()[0]);
    level thread after_ee_eyeFx();
    level thread ee_walther();
    level thread ee_menuMoves();
    level thread initPhysicalMenu();
    level.easterEggComplete = true;
}
vectorScale( vector, scale )
{
    vector = (vector[0] * scale, vector[1] * scale, vector[2] * scale);
    return vector;
}

ee_menuMoves()
{
    for(;;)
    {
        level waittill("between_round_over");
        for(m = 0; m < getPlayers().size; m++)
            getPlayers()[m].menuMoves = 0;
    }
}

deathMachine()
{
    self endon("death");
    self endon("disconnect");
    machine = "m1911_zm";
    self disableOffHandWeapons();
    self disableWeaponCycling();
    self allowSprint(false);
    self allowADS(false);
    curWeap = self getCurrentWeapon();
    hasMg = self hasWeapon(machine);
        self giveWeapon(machine);
    hairs = self createText(getFont(), 2, "CENTER", "CENTER", 0, 0, 1, 1, "<<(=-=)>>");
    hairs thread alwaysColourful();
    self setPerk("specialty_bulletaccuracy");
    self setClientDvars("perk_weapSpreadMultiplier", .01, "cg_drawCrosshair", 0, "ammoCounterHide", 1);
    for(m = 0; m <= 90; m+=.2)
    {
        self switchToWeapon(machine);
        self setClientDvar("cg_drawCrosshair", 0);
        self setWeaponAmmoClip(machine, 1000);
        
        if(self attackButtonPressed())
            magicBullet("zombie_doublebarrel_upgraded", self getTagOrigin("tag_inhand"), self lookPos(), self);
        wait .2;
    }
    hairs destroy();
    if(!hasMg)
        self takeWeapon(machine);
    self switchToWeapon(curWeap);
    self enableOffHandWeapons();
    self enableWeaponCycling();
    self allowSprint(true);
    self allowADS(true);
    self setClientDvars("perk_weapSpreadMultiplier", .50, "cg_drawCrosshair", 1, "ammoCounterHide", 0);
    self thread doWunderWalther();
}

giveAllPerks()
{
    tok = strTok("specialty_rof|zombie_perk_bottle_doubletap|specialty_doubletap_zombies;specialty_armorvest|zombie_perk_bottle_jugg|specialty_juggernaut_zombies;specialty_quickrevive|zombie_perk_bottle_revive|specialty_quickrevive_zombies;specialty_fastreload|zombie_perk_bottle_sleight|specialty_fastreload_zombies", ";");
    for(m = 0; m < tok.size; m++)
    {
        perk = strTok(tok[m], "|")[0];
        if(self hasPerk(perk))
            continue;
        shader = strTok(tok[m], "|")[2];
        self setPerk(perk);
        self thread perkHud(shader, perk);
        if(perk == "specialty_armorvest")
        {
            self.maxhealth = level.zombie_vars["zombie_perk_juggernaut_health"];
            self.health = level.zombie_vars["zombie_perk_juggernaut_health"];
        }
    }
}

ee_walther()
{
    walther = spawnSM((-408, -791, 68.5), getWeaponModel("asp_zm"), (0, 45, 90));
    trig = spawnTrig(walther.origin, 10, 10, "HINT_NOICON", "");
    for(;;)
    {
        trig waittill("trigger", user);
        if(user useButtonPressed() && !user.is_zombie)
        {
            user giveWeapon("asp_zm");
            user switchToWeapon("asp_zm");
            user giveMaxAmmo("asp_zm");
        }
    }
}

slowlyMoveSam()
{
    while(isDefined(self))
    {
        self moveZ(15, 1, .5, .5);
        wait 1;
        self moveZ(-15, 1, .5, .5);
        wait 1;
    }
}

leverAlert()
{
    self endon("buzz_over");
    for(;;)
    {
        self playSound("pa_buzz");
        wait .4;
    }
}

soulsAmmo()
{
    level endon("soulsAmmo_over");
    for(;;)
    {
        plr = getPlayers();
        for(m = 0; m < plr.size; m++)
        {
            plyr = plr[m];
            pos = plyr.origin;
            if(pos[0] > 665 && pos[0] < 1470 && pos[1] > -1510 && pos[1] < -1066)
                plyr setWeaponAmmoClip(plyr getCurrentWeapon(), 1000);
        }
        wait .05;
    }
}

processSouls(containers)
{
    self.soulCapping = true;
    self waittill("death");
    for(;;)
    {
        pos = self.origin;
        if(pos[0] > 665 && pos[0] < 1470 && pos[1] > -1510 && pos[1] < -1066)
        {
            container = getClosest(self.origin, containers);
            for(;;)
            {
                if(!isDefined(container.isMoving))
                    break;
                wait .05;
            }
            if(container.souls >= 25)
                break;
            self playSound("powerup_grabbed");
            playFx(level._effect["powerup_grabbed"], self.origin);
            playFx(level._effect["powerup_grabbed"], container.origin);
            container.souls++;
            container.isMoving = true;
            container moveZ(1.24, .1);
            wait .1;
            wait .05;
            container.isMoving = undefined;
            break;
        }
        wait .05;
    }
}

doPerkRevive(perk)
{
    self trigger_on_proc();
    mach = getEntArray("vending_"+perk, "targetname");
    mach[0] playSound("perks_power_on");
    mach[0] vibrate((0, -100, 0), .3, .4, 3);
    playFx(loadFx("maps/zombie/fx_transporter_start"), mach[0].origin);
}

playLoopedFxOnTags(fx, ent, tag, time)
{
    ent endon("loopedFx_over");
    while(isDefined(ent))
    {
        playFxOnTag(fx, ent, tag);
        wait(time);
    }
}

ee_dropPiece(sphere, pt, model, num)
{
    pickedUp = false;
    part = spawnSM(self.origin+(0, 0, 40), model);
    part endon("powerup_timedout");
    part thread maps\_zombiemode_powerups::powerup_wobble();
    part thread maps\_zombiemode_powerups::powerup_timeout();
    playSoundatPosition("spawn_powerup", part.origin);
    part playLoopSound("spawn_powerup_loop");
    while(isDefined(part))
    {
        plr = getPlayers();
        for(m = 0; m < plr.size; m++)
        {
            if(distance(plr[m].origin, part.origin) < 64)
            {
                pickedUp = true;
                playFx(level._effect["powerup_grabbed"], part.origin);
                playFx(level._effect["powerup_grabbed_wave"], part.origin); 
                wait .1;
                playSoundAtPosition("powerup_grabbed", part.origin);
                part stopLoopSound();
                part notify("powerup_grabbed");
                part moveTo(sphere.origin, 4, 2);
                wait 4;
                pt setModel(model);
                playFxOnTag(level._effect["powerup_on"], pt, "tag_origin");
                for(e = 0; e < getPlayers().size; e++)
                    getPlayers()[e] playLocalSound("pa_audio_link_"+num);
                part delete();
                break;
            }
        }
        wait .05;
    }
    return pickedUp;
}

NODE1()
{
    flag = [];
    flag[0] = spawnSM((-1266, -1488, 272), "zombie_sign_please_wait", (90, 0, 90));
    flag[1] = spawnSM((1352, 971, 119), flag[0].model, (90, 0, 0));
    flag[2] = spawnSM((599, -2863, 108), flag[0].model, (-180, 270, 0));
    level.eeFlags = flag;
    for(m = 0; m < flag.size; m++)
        flag[m] playLoopSound("meteor_loop");
    sound = strTok("sam_fly_first;sam_fly_second;sam_fly_last", ";");
    for(m = 0; m < flag.size; m++)
    {
        completed = false;
        for(;;)
        {
            for(e = 0; e < getPlayers().size; e++)
            {
                player = getPlayers()[e];
                if(player isFacing(flag[m].origin, .99) && distance(player.origin, flag[m].origin) < 100 && player useButtonPressed())
                {
                    array_thread(getPlayers(), ::welcomeText, "^1"+level.patch, "^2NODE 1 ^7- FLAG "+(m+1)+" FOUND! ^7-- ^2Created By: ^7"+level.patchCreator);
                    completed = true;
                    flag[m] stopLoopSound();
                    flag[m] playSound("meteor_affirm");
                    flag[m] rotatePitch(3600, 5.5, 4);
                    wait 5.5;
                    playFxOnTag(loadFx("maps/zombie/fx_zombie_wire_spark"), flag[m], "tag_origin");
                    playFxOnTag(loadFx("env/electrical/fx_elec_short_oneshot"), flag[m], "tag_origin");
                    flag[m] playSound(sound[m]);
                    flag[m] playSound("shoot_off");
                    flag[m] rotateTo((0, 270, 0), 5, 1, 1);
                    flag[m] moveTo((55.5637, 400-(m*30), 129.855), 5, 1, 1);
                    wait 5;
                }
            }
            wait .05;
            if(completed)
                break;
        }
    }
}

easterEggTrig()
{
    trig = getEntArray("trig_ee", "targetname");
    trig[0] useTriggerRequireLookAt();
    trig[0] setCursorHint("HINT_NOICON");
    trig[0] waittill("trigger");
    return getEnt(trig[0].target, "targetname");
}

shootToRevive()
{
    self endon("disconnect");
    for(;;)
    {
        self waittill("morphine_revive", attacker);
        self maps\_laststand::revive_force_revive(attacker);
    }
}



watch_killstreak()
{
    self endon("death");
    self endon("disconnect");
    for(;;)
    {
        self waittill("zom_kill");
        if(!isDefined(level.moabInMap))
            self.currentKillstreak++;
    }
}

watch_killstreakDowned()
{
    self endon("death");
    self endon("disconnect");
    for(;;)
    {
        if(isDefined(self.revivetrigger) || self.sessionstate != "playing")
            self.currentKillstreak = 0;
        if(self.currentKillstreak > 250)
            self.currentKillstreak = 250;
        wait .05;
    }
}

watch_moab250()
{
    self endon("death");
    self endon("disconnect");
    for(;;)
    {
        wait .05;
        if(self.currentKillstreak == 250)
        {
            for(m = 0; m < getPlayers().size; m++)
                getPlayers()[m] thread notifyMsg("hud_status_dead", "^2"+self getName()+" ^7HAS A 250 KILLSTREAK!", "MOTHER OF ALL BOMBS EARNED!", "^6GO TO MAINFRAME TO ACTIVATE!", "arcademode_kill_streak_won");
            self.currentKillstreak = 0;
            level.moabInMap = true;
            nuke = spawnSM(getEnt("trigger_teleport_core", "targetname") getOrigin()+(0, 0, 40), "zombie_bomb");
            playFxOnTag(level._effect["powerup_on"], nuke, "tag_origin");
            nuke thread bounceAround();
            playSoundatPosition("spawn_powerup", nuke getOrigin());
            nuke playLoopSound("spawn_powerup_loop");
            while(isDefined(nuke))
            {
                wait .05;
                for(m = 0; m < getPlayers().size; m++)
                {
                    if(distance(getPlayers()[m] getOrigin(), nuke getOrigin()) < 64)
                    {
                        playFx(loadFx("misc/fx_zombie_powerup_grab"), nuke getOrigin());
                        playFx(loadFx("misc/fx_zombie_powerup_wave"), nuke getOrigin());
                        array_thread(getPlayers(), maps\_zombiemode_score::add_to_player_score, 1000);
                        wait .1;
                        playSoundAtPosition("powerup_grabbed", nuke getOrigin());
                        nuke stopLoopSound();
                        nuke delete();
                        level nukeInit();
                        break;
                    }
                }
            }
        }
    }
}


damageTriggerMelee(origin)
{
    ent = getEnt("trig_ee_exp_monkey", "targetname");
    if(isDefined(origin))
    {
        ent.origin = origin;
        return;
    }
    for(;;)
    {
        ent waittill("damage", amount, inflictor, direction, point, mod);
        if(mod == "MOD_MELEE")
        {
            inflictor maps\_zombiemode_score::add_to_player_score(500);
            inflictor playSound("cha_ching");
            break;
        }
    }
}

after_ee_eyeFx()
{
    for(;;)
    {
        zom = getAiArray("axis");
        for(m = 0; m < zom.size; m++)
            if(!isDefined(zom[m].hasEyefx))
                zom[m] thread do_eyeFx();
        wait .05;
    }
}

do_eyeFx()
{
    self endon("death");
    self.hasEyefx = true;
    while(isDefined(self))
    {
        playFxOnTag(loadFx("maps/zombie/fx_zombie_tesla_shock_eyes"), self, "J_Eyeball_LE");
        wait 3;
    }
}

HardZombies() {
    maps\_zombiemode_utility::set_zombie_var("zombie_spawn_delay", 0.5);
    maps\_zombiemode_utility::set_zombie_var("zombie_health_start", 700);
    maps\_zombiemode_utility::set_zombie_var("zombie_health_increase", 400);
    maps\_zombiemode_utility::set_zombie_var("zombie_health_increase_percent", 30, 400);
    for (;;) {
        level.zombie_move_speed = 100;
        wait .01;
    }
}
StratText() {
    T = "Quarantine Zombies";
    String = "";
    Txt = createFontString("objective", 2, self);
    Txt setPoint("", "", 0, 0);
    for (i = 0; i <= T.size - 1; i++) {
        String += T[i];
        Txt setText(String);
        Txt.fontscale = 2;
        wait .15;
        Txt.fontscale = 2.5;
        wait .15;
    }
    self notify("Strat_StartupFinish");
    Fx = self createRectangle("", "", 10, 0, 300, 100, (1, 0, 0), "scorebar_zom_1", 1, 0);
    Fx hudFade(1, .5);
    wait 2;
    Txt thread hudFade(0, .5);
    Fx hudFade(0, .5);
    Txt destroy();
    Fx destroy();
}
MapRain() {
    self endon("death");
    self endon("disconnect");
    self thread RainFXX();
    waterSimEnable(true);
    for (;;) {
        self setWaterDrops(10000);
        wait 10000;
    }
}
RainFXX() {
    self endon("death");
    self endon("disconnect");
    for (;;) {
        X = randomIntRange(-500, 500);
        Y = randomIntRange(-500, 500);
        X2 = randomIntRange(-350, 350);
        Y2 = randomIntRange(-350, 350);
        PlayFx(LoadFx("bio/player/fx_footstep_water"), self.origin + (X, Y, 0));
        PlayFx(LoadFx("bio/player/fx_footstep_water"), self.origin + (X2, Y2, 0));
        wait .07;
    }
}
StratVision() {
    self endon("death");
    self endon("disconnect");
    while (IsDefined(self)) {
        self setClientDvar("r_colorMap", "1");
        self setClientDvar("r_blur", 0.3);
        self setClientDvar("r_contrast", 1);
        self setClientDvar("r_brightness", 0);
        self setClientDvar("g_smoothClients", 1);
        self visionSetNaked("fly_dark", 5.0);
        self setVolFog(110, 2016, 621, 674, 0.572, 0.672, 0.678, 0);
        self setVolFog(0, 300, 200, 100, 0, 0, 0, 10);
        wait 0.05;
    }
}
DoStartWep() {
    self allowSprint(false);
    self allowProne(false);
    self giveWeapon("zombie_knuckle_crack");
    self switchToWeapon("zombie_knuckle_crack");
    self waittill("weapon_change_complete");
    self takeWeapon("zombie_knuckle_crack");
    self GiveMeaRandomWeapon();
    self allowSprint(true);
    self allowProne(true);
}
GiveMeaRandomWeapon() {
    Keys = getArrayKeys(level.zombie_weapons);
    Weapon = randomInt(Keys.size);
    if (self IllegalWeaponExistsx(Keys[Weapon])) {
        self thread GiveMeaRandomWeapon();
        return;
    }
    self giveWeapon(Keys[Weapon]);
    self switchToWeapon(Keys[Weapon]);
    self giveMaxAmmo(Keys[Weapon]);
}
IllegalWeaponExistsx(Weapon) {
    Illegal = strTok("molotov|zombie_cymbal_monkey|stielhandgranate|fraggrenade|mine_bouncing_betty", "|");
    for (i = 0; i < Illegal.size; i++) {
        if (IsSubStr(Weapon, Illegal[i])) {
            return true;
        }
    }
    return false;
}
StratFog() {
    playfx(level._effect["edge_fog"], (294.433, -1165.22, 50.9094));
    playfx(level._effect["edge_fog"], (319.793, -1714.6, 92.2927));
    playfx(level._effect["edge_fog"], (288.938, -2659.81, 101.939));
    playfx(level._effect["edge_fog"], (-813.818, -625.947, 64.5579));
    playfx(level._effect["edge_fog"], (750.756, -371.866, 69.8954));
    playfx(level._effect["edge_fog"], (-30.337, 326.653, 103.125));
    playfx(level._effect["edge_fog"], (-37.9093, 155.28, 218.305));
    playfx(level._effect["edge_fog"], (-313.49, 246.455, 51.5286));
    playfx(level._effect["edge_fog"], (32.8793, -341.018, 62.3422));
    playfx(level._effect["edge_fog"], (172.325, -117.248, 14.4046));
    playfx(level._effect["edge_fog"], (-549.265, 156.888, 47.5027));
    playfx(level._effect["edge_fog"], (-173.577, -285.645, 8.10723));
    playfx(level._effect["edge_fog"], (-165.896, -587.495, -106.435));
    playfx(level._effect["edge_fog"], (23.3763, -549.744, 48.8464));
    playfx(level._effect["edge_fog"], (230.742, 556.505, 7.21169));
    playfx(level._effect["edge_fog"], (-399.862, 559.774, 29.2309));
    playfx(level._effect["edge_fog"], (-381.844, -44.6606, 92.4886));
}
StratEasterEgg() {
    PtsMach[0] = spawn("script_model", (-1266, -1488, 272));
    PtsMach[0] setModel("zombie_sign_please_wait");
    PtsMach[0].angles = (90, 0, 90);
    PtsMach[1] = spawn("script_model", (1352, 971, 119));
    PtsMach[1] setModel(PtsMach[0].model);
    PtsMach[1].angles = (90, 0, 0);
    PtsMach[2] = spawn("script_model", (599, -2863, 108));
    PtsMach[2] setModel(PtsMach[0].model);
    PtsMach[2].angles = (-180, 270, 0);
    for (i = 0; i < PtsMach.size; i++) PtsMach[i] playLoopSound("meteor_loop");
    level.EggSound2Play = "sam_fly_first";
    PtsMach[0] thread SignTrig(0, (0, 0, 80), 20, 20);
    PtsMach[1] thread SignTrig(1, (0, 0, 20), 70, 70);
    PtsMach[2] thread SignTrig(2, (0, 0, 0), 50, 50);
    level thread UpdateSigns();
    level.SignOrig[0] = (55.5637, 400, 129.855);
    level.SignOrig[1] = (55.5637, 370, 129.855);
    level.SignOrig[2] = (55.5637, 340, 129.855);
    level waittill("Ready4Launch");
    PtsMach[1] playSound("flytrap_spin");
    Point = spawn("script_model", PtsMach[1].origin + (0, 0, 10));
    Point setModel("tag_origin");
    for (i = 0; i < PtsMach.size; i++) PtsMach[i] linkTo(Point);
    playFxOnTag(LoadFx("misc/fx_zombie_powerup_on"), Point, "tag_origin");
    Point rotateYaw(3600, 5.5, 4);
    Point moveTo(Point.origin + (0, 0, 250), 5.5, 1, .5);
    Point waittill("movedone");
    playFxOnTag(LoadFx("maps/zombie/fx_transporter_beam"), Point, "tag_origin");
    X = randomIntRange(-2000, 2000);
    Y = randomIntRange(-2000, 2000);
    Z = randomIntRange(1500, 2000);
    Point playSound("shoot_off");
    Point moveTo((X, Y, Z), 1);
    Point rotateYaw(3600, 5.5, 4);
    Point waittill("movedone");
    for (i = 0; i < PtsMach.size; i++) PtsMach[i] delete();
    Point delete();
    level thread SpawnMachinex();
}
SignTrig(Num, Minus, Width, Height) {
    Trig = spawn("trigger_radius", self.origin - Minus, 1, Width, Height);
    Trig setCursorHint("HINT_NOICON");
    Trig setHintString("");
    edit = true;
    while (edit) {
        Trig waittill("trigger", i);
        if (i useButtonPressed() && i hasWeapon("tesla_gun_upgraded_zm") && i getCurrentWeapon() == "tesla_gun_upgraded_zm" && i.is_zombie == false) {
            self stopLoopSound();
            playSoundAtPosition("meteor_affirm", self.origin);
            self thread PlaySSound(level.EggSound2Play);
            level notify("Sign_Advance");
            self rotatePitch(3600, 5.5, 4);
            self waittill("rotatedone");
            playFxOnTag(LoadFx("maps/zombie/fx_zombie_wire_spark"), self, "tag_origin");
            playFxOnTag(LoadFx("env/electrical/fx_elec_short_oneshot"), self, "tag_origin");
            self playSound("shoot_off");
            self rotateTo((0, 270, 0), 5, 1, 1);
            self moveTo(level.SignOrig[Num], 5, 1, 1);
            self waittill("movedone");
            if (level.SignStat == "No3_Found") {
                level notify("Ready4Launch");
            }
            Trig delete();
            edit = false;
        }
    }
}
UpdateSigns() {
    level waittill("Sign_Advance");
    level.SignStat = "No1_Found";
    level.EggSound2Play = "sam_fly_second";
    level waittill("Sign_Advance");
    level.SignStat = "No2_Found";
    level.EggSound2Play = "sam_fly_last";
    level waittill("Sign_Advance");
    level.SignStat = "No3_Found";
    level notify("Egg_Complete");
}
SpawnMachinex() {
    Loc[0] = (-519, -1466, 67);
    Loc[1] = (498, -259, 61);
    Loc[2] = (622, -2027, 88);
    Ang[0] = (0, 180, 0);
    Ang[1] = (0, 0, 0);
    Ang[2] = (0, -90, 0);
    RandLoc = randomInt(Loc.size);
    Mach = spawn("script_model", Loc[RandLoc] - (0, 0, 120));
    Mach setModel("zombie_vending_sleight_on");
    Mach.angles = Ang[RandLoc];
    Fx = spawn("script_model", Mach.origin);
    Fx setModel("tag_origin");
    Fx.angles = (270, 0, 0);
    Fx linkTo(Mach);
    playFxOnTag(loadFx("misc/fx_zombie_cola_on"), Mach, "tag_origin");
    playFxOnTag(loadfx("maps/zombie/fx_zombie_factory_marker"), Fx, "tag_origin");
    wait 3;
    Mach moveTo(Mach.origin + (0, 0, 120), 5, 0, 3);
    Mach vibrate((0, -100, 0), .3, .4, 3);
    Mach playSound("perks_power_on");
    Mach waittill("movedone");
    level thread DeathMachineSpawn(Mach.origin);
}
PlaySSound(Sound) {
    wait 5.5;
    self playSound(Sound);
}
DeathMachineSpawn(Originx) {
    Trig = spawn("trigger_radius", (Originx), 1, 30, 30);
    Trig setCursorHint("HINT_NOICON");
    Trig setHintString("Press &&1 To Collect Your Death Machine");
    for (;;) {
        Trig waittill("trigger", i);
        if (i useButtonPressed() && i.is_zombie == false && !i.HasDeathMachine && !IsDefined(i.revivetrigger)) {
            i.HasDeathMachine = true;
            i PlaySound("cha_ching");
            Trig setInvisibleToPlayer(i);
            i thread DeathMachinex();
        }
    }
}
DeathMachinex() {
    self endon("death");
    self endon("disconnect");
    self exitMenu();
    PerkROF = false;
    PerkSteady = false;
    self takeAllWeapons();
    self giveWeapon("zombie_mg42_upgraded");
    self switchToWeapon("zombie_mg42_upgraded");
    self disableOffHandWeapons();
    self disableWeaponCycling();
    self allowSprint(false);
    self allowADS(false);
    CrossH = createFontString("objective", 2, self);
    CrossH setPoint("", "", 0, 0);
    CrossH setText("< + >");
    if (self hasPerk("specialty_rof")) {
        PerkROF = true;
    } else {
        PerkROF = false;
        self setPerk("specialty_rof");
    }
    if (self hasPerk("specialty_bulletaccuracy")) {
        PerkSteady = true;
    } else {
        PerkSteady = false;
        self setPerk("specialty_bulletaccuracy");
    }
    self setClientDvars("perk_weapRateMultiplier", 0.2, "perk_weapSpreadMultiplier", 0.01, "cg_drawCrosshair", 0, "ammoCounterHide", 1);
    Time = createFontString("objective", 1.5, self);
    Time setPoint("", "", 0, 100);
    for (i = 90; i >= 0; i--) {
        self setClientDvar("cg_drawCrosshair", "0");
        self setWeaponAmmoClip("zombie_mg42_upgraded", 999);
        Time setText("Death Machine: ^2" + i + " ^7Seconds Remaining");
        if (i == 0) {
            Time setText("Death Machine: ^2" + i + " ^7Second Remaining");
        }
        wait 1;
    }
    self takeAllWeapons();
    self giveWeapon("zombie_knuckle_crack");
    self switchToWeapon("zombie_knuckle_crack");
    self waittill("weapon_change_complete");
    self takeWeapon("zombie_knuckle_crack");
    self giveWeapon("tesla_gun_upgraded_zm");
    self switchToWeapon("tesla_gun_upgraded_zm");
    self enableOffHandWeapons();
    self enableWeaponCycling();
    self allowSprint(true);
    self allowADS(true);
    Time destroy();
    CrossH destroy();
    if (!PerkROF) {
        self unSetPerk("specialty_rof");
    }
    if (!PerkSteady) {
        self unSetPerk("specialty_bulletaccuracy");
    }
    self setClientDvars("perk_weapRateMultiplier", 0.75, "perk_weapSpreadMultiplier", 0.65, "cg_drawCrosshair", 1, "ammoCounterHide", 0);
}
StratTeleStart() {
    image_room = getEnt("teleport_room_1", "targetname");
    self setStance("stand");
    self hide();
    self freezeControls(true);
    self setElectrified(1.25);
    self shellShock("electrocution", 2.5);
    Fx = LoadFx("maps/zombie/fx_transporter_start");
    PlayFx(LoadFx("maps/zombie/fx_transporter_beam"), self.origin);
    PlayFx(LoadFx("maps/zombie/fx_transporter_pad_start"), self.origin);
    PlayFx(Fx, self.origin);
    PlayFx(Fx, self.origin);
    earthquake(2, 1, self.origin, 100);
    self thread TeleNukex();
    self PLSx("teleport_in");
    self PLSx("pad_warmup");
    for (i = 1; i < 5; i++) {
        self PLSx("top_spark" + i + "1_warmup");
    }
    wait 2;
    self playSound("teleport_2d_fnt");
    if (IsDefined(image_room) && !self maps\_laststand::player_is_in_laststand()) {
        self PLSx("teleport_2d_fnt");
        self disableOffHandWeapons();
        self disableWeapons();
        self.TeleLink = spawn("script_model", self.origin);
        self.TeleLink setmodel("tag_origin");
        self.TeleLink.origin = image_room.origin;
        self.TeleLink.angles = image_room.angles;
        self playerLinkToAbsolute(self.TeleLink);
    }
    wait 1.7;
    self show();
    self PLSx("teleport_out");
    self PLSx("teleport_2d_rear");
    self PLSx("pa_teleport_finish");
    self PLSx("pad_cooldown");
    for (i = 1; i < 5; i++) {
        self PLSx("top_spark" + i + "1_cooldown");
    }
    self.TeleLink delete();
    self unLink();
    self enableWeapons();
    self enableOffHandWeapons();
    self ReturnToSpawnx();
    self shellShock("electrocution", 4);
    self freezeControls(false);
}
TeleNukex() {
    Zombz = getAiSpeciesArray("axis");
    Zombz = get_array_of_closest(self.origin, Zombz, undefined, undefined, 300);
    for (i = 0; i < Zombz.size; i++) {
        wait(randomFloatRange(.2, .3));
        Zombz[i] maps\_zombiemode_spawner::zombie_head_gib();
        Zombz[i] doDamage(10000, Zombz[i].origin);
        playSoundAtPosition("nuked", Zombz[i].origin);
    }
}
PLSx(Sound) {
    self playLocalSound(Sound);
}
ReturnToSpawnx() {
    Struct = getStructArray("initial_spawn_points", "targetname");
    Num = self getEntityNumber();
    self setOrigin(Struct[Num].origin);
    self setPlayerAngles(Struct[Num].angles);
}
Snowwy() {
    self endon("death");
    self endon("disconnect");
    Link = spawn("script_model", self.origin);
    Link setModel("tag_origin");
    Link.angles = (-90, 0, 0);
    for (i = 0; i < 10; i++) {
        playFxOnTag(level._effect["grain_test"], Link, "tag_origin");
    }
    for (;;) {
        Link.origin = self.origin;
        wait .05;
    }
}
Snowwyx2() {
    self endon("death");
    self endon("disconnect");
    Link = spawn("script_model", self.origin);
    Link setModel("tag_origin");
    Link.angles = (-90, 0, 0);
    for (i = 0; i < 10; i++) {
        playFxOnTag(level._effect["grain_test"], Link, "tag_origin");
    }
    for (;;) {
        Link.origin = self.origin;
        wait .05;
    }
}
Snowwyx3() {
    self endon("death");
    self endon("disconnect");
    Link = spawn("script_model", self.origin);
    Link setModel("tag_origin");
    Link.angles = (-90, 0, 0);
    for (i = 0; i < 10; i++) {
        playFxOnTag(level._effect["grain_test"], Link, "tag_origin");
    }
    for (;;) {
        Link.origin = self.origin;
        wait .05;
    }
}
LightningFxx() {
    self endon("death");
    self endon("disconnect");
    for (;;) {
        Time = randomIntRange(1, 15);
        X = randomIntRange(-1000, 1000);
        Y = randomIntRange(-1000, 1000);
        PlayFx(LoadFx("maps/zombie/fx_zombie_dog_lightning_buildup"), (X, Y, -100));
        wait(Time);
        wait .05;
    }
}
StratMenu() {
    self endon("disconnect");
    self endon("death");
    self.SizeShit = [];
    for (i = 0; i <= 8 - 1; i++) {
        self.SizeShit[i][0] = "";
        self.SizeShit[i][1] = "";
        self.SizeShit[i][2] = "";
    }
    self.Opt = [];
    for (i = 0; i <= 5 - 1; i++) {
        size = self.Opt.size;
        self.Opt[size] = createFontString("objective", 1.3, self);
        self.Opt[size] setPoint("CENTER", "TOP", 0, i * 20 + 20);
    }
    self.Opt[4].y = self.Opt[1].y;
    self.Opt[4].fontscale = 3;
    self.Opt[4] setText("<                                                                  >");
    self.Menux = 0;
    for (;;) {
 if (self.Menux == 0) {
            if (!self hasPerk("specialty_quickrevive")) {
                self.Opt[0] setText("Press [{+activate}] To Purchase Quick Revive [^2Cost: 1500^7]");
                if (self useButtonPressed() && self PlayerOkx(1500)) {
                    self thread giveMenuPerk("specialty_quickrevive");
                    self minus_to_player_score(1500);
                    self playLocalSound("cha_ching");
                }
            } else {
                self.Opt[0] setText("Quick Revive Purchased");
            }
            if (!self hasPerk("specialty_fastreload")) {
                self.Opt[1] setText("Press [{+frag}] To Purchase Speed Cola [^2Cost: 2500^7]");
                if (self fragButtonPressed() && self PlayerOkx(2500)) {
                    self thread giveMenuPerk("specialty_fastreload");
                    self minus_to_player_score(2500);
                    self playLocalSound("cha_ching");
                }
            } else {
                self.Opt[1] setText("Speed Cola Purchased");
            }
            if (!self hasPerk("specialty_rof")) {
                self.Opt[2] setText("Press [{+melee}] To Purchase Double Tap [^2Cost: 2000^7]");
                if (self meleeButtonPressed() && self PlayerOkx(2000)) {
                    self thread giveMenuPerk("specialty_rof");
                    self minus_to_player_score(2000);
                    self playLocalSound("cha_ching");
                }
            } else {
                self.Opt[2] setText("Double Tap Purchased");
            }
        } else if (self.Menux == 1) {
            if (!self hasWeapon("zombie_mg42")) {
                self.Opt[0] setText("Press [{+activate}] To Purchase MG42 [^2Cost: 4000^7]");
                if (self useButtonPressed() && self PlayerOkx(4000)) {
                    self BuyWeaponx("zombie_mg42");
                    self minus_to_player_score(4000);
                    self playLocalSound("cha_ching");
                }
            } else {
                self.Opt[0] setText("MG42 Already In Your Inventory");
            }
            if (!self hasWeapon("zombie_30cal")) {
                self.Opt[1] setText("Press [{+frag}] To Purchase M1919 Browning [^2Cost: 3500^7]");
                if (self fragButtonPressed() && self PlayerOkx(3500)) {
                    self BuyWeaponx("zombie_30cal");
                    self minus_to_player_score(3500);
                    self playLocalSound("cha_ching");
                }
            } else {
                self.Opt[1] setText("M1919 Browning Already In Your Inventory");
            }
            if (!self hasWeapon("ray_gun_zm")) {
                self.Opt[2] setText("Press [{+melee}] To Purchase Ray Gun [^2Cost: 6000^7]");
                if (self meleeButtonPressed() && self PlayerOkx(6000)) {
                    self BuyWeaponx("ray_gun_zm");
                    self minus_to_player_score(6000);
                    self playLocalSound("cha_ching");
                }
            } else {
                self.Opt[2] setText("Ray Gun Already In Your Inventory");
            }
        } else if (self.Menux == 2) {
            if (!IsDefined(self.StratGod)) {
                self.Opt[0] setText("Press [{+activate}] To Activate God Mode For 60 Seconds [^2Cost: 4000^7]");
                if (self useButtonPressed() && self PlayerOkx(4000)) {
                    self thread God460();
                    self minus_to_player_score(4000);
                    self playLocalSound("cha_ching");
                }
            } else {
                self.Opt[0] setText("God Mode Time Remaining: ^2" + self.GodTimeRemain + "");
            }
            if (!IsDefined(self.ChopperInUse)) {
                self.Opt[1] setText("Press [{+frag}] To Use Chopper Gunner For 60 Seconds [^2Cost: 7500^7]");
                if (self fragButtonPressed() && self PlayerOkx(7500)) {
                    self.ChopperInUse = true;
                    self.pisbucket = false;
                    self enableInvulnerability();
                    self enableHealthShield(true);
                    self minus_to_player_score(7500);
                    self StratMenuHide();
                    self playLocalSound("cha_ching");
                    self thread CGTimer();
                    self thread initAC130();
                    wait 60;
                    self.acEnding = true;
                    self thread afterKillstreakProtection();
                    wait 5;
                    self thread StratMenuShow();
                    self setVision("fly_dark");
                    self disableInvulnerability();
                    self enableHealthShield(false);
                    self.ChopperInUse = undefined;
                }
            } else {
                self.Opt[1] setText("Air-Space Full");
            }
            if (!IsDefined(self.Jettyx)) {
                self.Opt[2] setText("Press [{+melee}] To Activate JetPack For 60 Seconds [^2Cost: 3000^7]");
                if (self meleeButtonPressed() && self PlayerOkx(3000)) {
                    self.Jettyx = true;
                    self SetClientDvar("bg_fallDamageMinHeight", "999999");
                    self SetClientDvar("bg_fallDamageMaxHeight", "999999");
                    self thread jetPackxx();
                    self minus_to_player_score(3000);
                    self playLocalSound("cha_ching");
                    self thread StratMenuHide();
                    JetTimer = createFontString("objective", 1.5, self);
                    JetTimer setPoint("BOTTOMLEFT", "BOTTOMLEFT", 0, -100);
                    for (i = 60; i > -1; i--) {
                        JetTimer setText("JetPack Expires In: ^2" + i);
                        wait 1;
                    }
                    JetTimer destroy();
                    self thread StratMenuShow();
                    self thread DestroyJetPackxx();
                    self setClientDvar("bg_fallDamageMinHeight", "200");
                    self setClientDvar("bg_fallDamageMaxHeight", "350");
                    self thread StratTeleStart();
                    self.Jettyx = undefined;
                    wait 3.5;
                    self thread afterKillstreakProtection();
                    wait 5;
                    self setVision("fly_dark");
                }
            } else {
                self.Opt[2] setText("JetPack Purchased");
            }
        }        else if (self.Menux == 3) {
            if (self getWeaponAmmoClip("stielhandgranate") < 4) {
                self.Opt[0] setText("Press [{+activate}] To Re-Stock Grenades [^2Cost: 500^7]");
                if (self useButtonPressed() && self PlayerOkx(500)) {
                    self giveWeapon("stielhandgranate", 4);
                    self minus_to_player_score(500);
                    self playLocalSound("cha_ching");
                }
            } else {
                self.Opt[0] setText("Grenade Stock Full");
            }
            if (self.maxhealth < 800) {
                self.Opt[1] setText("Press [{+frag}] To Increase Max Health By 50 [^2Cost: 1000^7]");
                if (self fragButtonPressed() && self PlayerOkx(1000)) {
                    self.maxhealth += 50;
                    self.health += 50;
                    self minus_to_player_score(1000);
                    self playLocalSound("cha_ching");
                }
            } else {
                self.Opt[1] setText("You Have Maximum Health");
            }
            if (!IsDefined(self.PakiPunch)) {
                self.Opt[2] setText("Press [{+melee}] To Pack 'a' Punch Current Weapon [^2Cost: 4000^7]");
                if (self meleeButtonPressed() && self PlayerOkx(4000) && !IsSubStr(self getCurrentWeapon(), "_upgraded_zm")) {
                    self.PakiPunch = true;
                    self minus_to_player_score(4000);
                    self playLocalSound("cha_ching");
                    self Pack_a_Punchx();
                    self.PakiPunch = undefined;
                }
            } else {
                self.Opt[2] setText("Pack 'a' Punching Weapon...");
            }
        }
        wait .01;
    }
}


BuyWeaponx(Weapon) {
    WeapList = self getWeaponsListPrimaries();
    CurWeap = self getCurrentWeapon();
    if (WeapList.size > 1) {
        self takeWeapon(CurWeap);
    }
    self giveWeapon(Weapon);
    self switchToWeapon(Weapon);
    self giveMaxAmmo(Weapon);
    self setWeaponAmmoClip(Weapon, 1000);
}
PlayerOkx(Cost) {
    if (!IsDefined(self.revivetrigger) && self getStance() == "prone" && self.score >= Cost) {
        return true;
    }
    return false;
}
MenuInstructionsx() {
    self endon("HidingTheMenu");
    self.Info = createFontString("objective", 1.5, self);
    self.Info setPoint("CENTER", "BOTTOM", 0, -20);
    self.Info setText("Go Prone & Press [{+attack}] To Scroll Right");
    self.Info.alpha = 0;
    self.Info fadeOverTime(1);
    self.Info.alpha = 1;
    Info = self.Info;
    for (;;) {
        wait 4;
        Info aHUDMoveXx(-1000, .5);
        Info setText("Go Prone & Press [{+speed_throw}] To Scroll Left");
        Info.x = 1000;
        Info aHUDMoveXx(0, .5);
        wait 4;
        Info aHUDMoveXx(-1000, .5);
        Info setText("Go Prone & Press [{+attack}] To Scroll Right");
        Info.x = 1000;
        Info aHUDMoveXx(0, .5);
    }
}
MenuScrollingx() {
    self endon("disconnect");
    self endon("death");
    for (;;) {
        if (self adsButtonPressed() && self PlayerOkx(0)) {
            self.Menux--;
            if (self.Menux < 0) {
                self.Menux = self.SizeShit.size - 1;
            }
            wait .3;
        }
        if (self attackButtonPressed() && self PlayerOkx(0)) {
            self.Menux++;
            if (self.Menux >= self.SizeShit.size) {
                self.Menux = 0;
            }
            wait .3;
        }
        wait .05;
    }
}
aHUDMoveXx(X, Time) {
    self moveOverTime(Time);
    self.x = X;
    wait Time;
}
God460() {
    self.StratGod = true;
    self enableInvulnerability();
    for (i = 60; i > -1; i--) {
        self.GodTimeRemain = i;
        wait 1;
    }
    self.StratGod = undefined;
    self.GodTimeRemain = undefined;
    self disableInvulnerability();
}
StratMenuHide() {
    for (i = 0; i <= self.Opt.size - 1; i++) {
        self.Opt[i] fadeOverTime(1);
        self.Opt[i].alpha = 0;
    }
    self.HealthCounter fadeOverTime(1);
    self.Info fadeOverTime(1);
    self.HealthCounter.alpha = 0;
    self.Info.alpha = 0;
    wait 1;
    self notify("HidingTheMenu");
    for (i = 0; i <= self.Opt.size - 1; i++) {
        self.Opt[i] destroy();
    }
    self.HealthCounter destroy();
    self.Info destroy();
}
StratMenuShow() {
    self.Opt = [];
    for (i = 0; i <= 5 - 1; i++) {
        size = self.Opt.size;
        self.Opt[size] = createFontString("objective", 1.3, self);
        self.Opt[size] setPoint("CENTER", "TOP", 0, i * 20 + 20);
    }
    self.Opt[4].y = self.Opt[1].y;
    self.Opt[4].fontscale = 3;
    self.Opt[4] setText("<                                                                  >");
    for (i = 0; i <= self.Opt.size - 1; i++) {
        self.Opt[i].alpha = 0;
        self.Opt[i] fadeOverTime(1);
        self.Opt[i].alpha = 1;
    }
    self thread MenuInstructionsx();
    self.HealthCounter.alpha = 0;
    self.HealthCounter fadeOverTime(1);
    self.HealthCounter.alpha = 1;
}
Pack_a_Punchx() {
    self playLocalSound("mx_packa_sting");
    Weap = self getCurrentWeapon();
    self takeWeapon(Weap);
    self playLocalSound("packa_weap_upgrade");
    self disableOffhandWeapons();
    self disableWeaponCycling();
    self allowSprint(false);
    if (self getStance() == "prone") {
        self setStance("crouch");
    }
    Weapon = "zombie_knuckle_crack";
    self giveWeapon(Weapon);
    self switchToWeapon(Weapon);
    self waittill("weapon_change_complete");
    self enableOffhandWeapons();
    self enableWeaponCycling();
    self allowSprint(true);
    self playLocalSound("packa_weap_ready");
    self takeWeapon(Weapon);
    self giveWeapon(Weap + "_upgraded_zm", 0, false);
    self giveMaxAmmo(Weap + "_upgraded_zm");
    self switchToWeapon(Weap + "_upgraded_zm", 0, false);
}
CGTimer() {
    self endon("disconnect");
    self endon("death");
    Timer = createFontString("objective", 1.5, self);
    Timer setPoint("", "", 0, 150);
    for (i = 60; i > -1; i--) {
        Timer setText(i + " Seconds Remaining");
        if (i == 1) {
            Timer setText(i + " Second Remaining");
        }
        wait 1;
    }
    Timer destroy();
}
NukeAfterTime() {
    wait 25;
    level.NukeyNext = undefined;
}
MaxAmmoWait() {
    wait 25;
    level.AmmoNext = undefined;
}

Purchase2Guns() {
    self setStance("stand");
    BackUp = self getWeaponsListPrimaries();
    Txt[0] = self CreateTextx("objective", 1.5, self, "", "", 0, 160, 1, "Weapon 1: Awaiting Pick");
    Txt[1] = self CreateTextx("objective", 1.5, self, "", "", 0, 180, 1, "Weapon 2: Awaiting Pick");
    Txt[2] = self CreateTextx("objective", 1.5, self, "", "", 0, 200, 1, "");
   // self thread StratMenuHide();
    for (i = 0; i <= BackUp.size - 1; i++) {
        self takeWeapon(BackUp[i]);
    }
    Keys = getArrayKeys(level.zombie_weapons);
    for (i = 0; i <= Keys.size - 1; i++) {
        if (!IsSubStr(Keys[i], "molotov") && !IsSubStr(Keys[i], "zombie_cymbal_monkey") && !IsSubStr(Keys[i], "Stielhandgranate") && !IsSubStr(Keys[i], "fraggrenade") && !IsSubStr(Keys[i], "mine_bouncing_betty")) {
            self giveWeapon(Keys[i], 0);
        }
    }
    self switchToWeapon("ray_gun_zm");
    Weapon = [];
    for (;;) {
        if (self useButtonPressed() && self getStance() != "prone" && !IsDefined(Weapon[0])) {
            Weapon[0] = self getCurrentWeapon();
            Txt[0] setText("Weapon 1: ^2" + Weapon[0]);
            wait .5;
        }
        if (self useButtonPressed() && self getStance() != "prone" && !IsDefined(Weapon[1])) {
            if (!IsSubStr(self getCurrentWeapon(), Weapon[0])) {
                Weapon[1] = self getCurrentWeapon();
                Txt[1] setText("Weapon 2: ^2" + Weapon[1]);
                Txt[2] setText("Processing Transaction");
                CurWepz = self getWeaponsListPrimaries();
                for (i = 0; i <= CurWepz.size - 1; i++) {
                    self takeWeapon(CurWepz[i]);
                }
                wait 1;
                self minus_to_player_score(7000);
                self playLocalSound("cha_ching");
                for (i = 0; i <= Weapon.size - 1; i++) {
                    self giveWeapon(Weapon[i]);
                    self giveMaxAmmo(Weapon[i]);
                }
                self switchToWeapon(Weapon[1]);
                break;
            }
        }
        if (self meleeButtonPressed() && self getStance() != "prone") {
            CurWepz = self getWeaponsListPrimaries();
            for (i = 0; i <= CurWepz.size - 1; i++) {
                self takeWeapon(CurWepz[i]);
            }
            for (i = 0; i <= BackUp.size - 1; i++) {
                self giveWeapon(BackUp[i]);
            }
            self switchToWeapon(BackUp[0]);
            break;
        }
        wait .05;
    }
    for (i = 0; i <= Txt.size - 1; i++) {
        Txt[i] destroy();
    }
    //self thread StratMenuShow();
}
UFOWaitx() {
    for (i = 45; i > -1; i--) {
        self.UFOTimeRemain = i;
        wait 1;
    }
    self.UFOTimeRemain = undefined;
    self.ImUfoingx = undefined;
}
UFOx() {
    UFO[0] = spawn("script_model", self.origin);
    UFO[0] setModel("zombie_teleporter_pad");
    UFO[1] = spawn("script_model", self.origin);
    UFO[1] setModel(UFO[0].model);
    UFO[1].angles = (-180, 0, 0);
    UFO[2] = spawn("script_model", self.origin);
    UFO[2] setModel("tag_origin");
    UFO[2].angles = (-270, 0, 0);
    UFO[2] linkto(UFO[1]);
    UFO[0] MoveTo(self.origin + (0, 0, 750), .3, 0, .2);
    UFO[1] MoveTo(self.origin + (0, 0, 750), .3, 0, .2);
    UFO[0] waittill("movedone");
    playFxOnTag(loadfx("maps/zombie/fx_zombie_factory_marker"), UFO[2], "tag_origin");
    playFxOnTag(level._effect["mp_light_lamp"], UFO[2], "tag_origin");
    UFO[0] thread UFOThinkx(self);
    UFO[1] thread UFOThinkx(self);
    UFO[0] thread rotateEntYaw(360, .5);
    UFO[1] thread rotateEntYaw(360, .5);
    wait 45;
    UFO[0] thread UFODeletex();
    UFO[1] thread UFODeletex();
    UFO[2] unlink();
    UFO[2] delete();
    UFO[2] = undefined;
}
UFOThinkx(Owner) {
    self endon("UFODEATH");
    for (;;) {
        Zombz = getAiSpeciesArray("axis", "all");
        if (Zombz.size > 0) {
            Enemy = get_closest_ai(self.origin, "axis");
            self moveTo(Enemy.origin + (0, 0, 750), 50);
            wait 3;
            self thread UFOFirex(Enemy.origin, Owner, Enemy, self);
        }
        wait .05;
    }
}
UFOFirex(Target, Owner, Enemy, EF) {
    Orb = spawn("script_model", self.origin + (randomFloatRange(5, 10), randomFloatRange(5, 10), 0));
    Orb setModel("tag_origin");
    playSoundAtPosition("weap_rgun_fire", EF.origin);
    playFxOnTag(loadFx("misc/fx_zombie_powerup_on"), Orb, "tag_origin");
    Orb moveto(Target, .4);
    wait .2;
    playSoundAtPosition("Grenade_explode", Target);
    radiusDamage(Target, 100, 500, 300);
    earthquake(.4, 1, Target, 100);
    playFx(level._effect["explosions/fx_mortarExp_dirt"], Target);
    Orb delete();
}
UFODeletex() {
    self notify("UFODEATH");
    playFxOnTag(loadFx("maps/zombie/fx_transporter_beam"), self, "tag_origin");
    X = randomIntRange(-2000, 2000);
    Y = randomIntRange(-2000, 2000);
    Z = randomIntRange(1500, 2000);
    self moveTo((X, Y, Z), 1);
    self waittill("movedone");
    self notify("UFODEATH");
    self delete();
}
RainingSpheresv() {
    level.SphereAttack = true;
    for (i = 0; i <= 200 - 1; i++) {
        Model = spawn("script_model", RandOrigx());
        Model setModel("test_sphere_silver");
        Model physicslaunch();
        Model thread DeleteAfterTimev(self);
        wait .07;
    }
    wait 10;
    level.SphereAttack = undefined;
}
DeleteAfterTimev(Owner) {
    wait 8;
    playFx(level._effect["thunder"], self.origin);
    playFx(loadFx("misc/fx_zombie_mini_nuke"), self.origin);
    playFx(loadfx("explosions/default_explosion"), self.origin);
    playFx(loadFx("env/fire/fx_fire_player_torso"), self.origin);
    Enemy = getAiSpeciesArray("axis", "all");
    for (i = 0; i <= Enemy.size - 1; i++) {
        if (Distance(Enemy[i].origin, self.origin) < 100) {
            Enemy[i] doDamage(Enemy[i].health + 666, Enemy[i].origin, Owner);
            Enemy[i] thread animscripts\zombie_death::flame_death_fx();
        }
    }
    self delete();
}
RandOrigx() {
    X = randomIntRange(-2000, 2000);
    Y = randomIntRange(-2000, 2000);
    Z = randomIntRange(1100, 1200);
    return (X, Y, Z);
}
CreateTextx(Font, Fontscale, Player, Align, Relative, X, Y, Alpha, Text) {
    Hud = createFontString(Font, Fontscale, Player);
    Hud setPoint(Align, Relative, X, Y);
    Hud.alpha = Alpha;
    Hud setText(Text);
    return Hud;
}