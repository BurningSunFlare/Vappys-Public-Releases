#include common_scripts\utility;
#include maps\_utility;
#include maps\_hud_util;
#include maps\_load_common;
#include maps\_zombiemode_utility;
#include maps\physicsfunctions;
#include maps\physicsmodes;
#include maps\_physics;

/* Spawnables */

//Merry-Go-Round

merryGoRound() {
    if (!isDefined(level.merryGoRound) && level.BigBoy == false && level.Small == false && level.MerryR != true) {
        if (level.rainstarter == true) {
            if (isDefined(level.entitySpace)) return;
            level.entitySpace = true;
            level.BigBoy = true;
            level.merryGoRound = true;
            level thread spawnMerry();
            self thread createProgressBar(6, "Merry-Go-Round Spawning", 1, "Merry-Go-Round Spawned!");
            self thread SpawnRefresh();
        }
    }
    if (!isDefined(level.merryGoRound) && level.BigBoy == false && level.Small == false && level.MerryR != true) {
        if (level.Raindeletetime == true) {
            getPlayers()[0] notify("rain_sphere");
            level.BigBoy = true;
            if (isDefined(level.entitySpace)) return;
            level.entitySpace = true;
            level.merryGoRound = true;
            self thread SpawnRefresh();
            self iPrintln("^1Deleting ^7Raining Models!");
            wait 7;
            self thread createProgressBar(6.5, "Merry-Go-Round Spawning", 1, "Merry-Go-Round Spawned!");
            level thread spawnMerry();
        }
    }
    if (!isDefined(level.merryGoRound) && level.MerryR != true) {
        if (level.Small == true || level.BigBoy == true) {
            self playlocalsound("deny");
            self iPrintln("^1Error ^7Entity Limit Reached!");
        }
    } else {
        if (isDefined(level.MerryConstructing)) return;
        if (!isDefined(level.merryGoRound) && level.MerryR == true) {
            self thread createProgressBar_Delete(8.5, "Merry-Go-Round Deleting", 1, "Merry-Go-Round Deleted!");
            level thread deleteMerry();
            level.merryGoRound = true;
            level.MerryR = false;
            self thread SpawnRefresh();
        }
    }
}
deleteMerry() {
    level.MerryConstructing = true;
    level notify("Early Destroy");
    for (m = level.MerryArray.size - 1; m > -1; m--) {
        level.MerryArray[m] Delete();
        wait .05;
    }
    level.merryGoRound = undefined;
    level.MerryConstructing = undefined;
    level.merryArray = undefined;
    level.entitySpace = undefined;
    level.Raindeletetime = false;
    level.rainstarter = true;
    level.BigBoy = false;
    self thread SpawnRefresh();
}
spawnMerry() {
    level endon("Early Destroy");
    level.MerryConstructing = true;
    level.MerryR = true;
    Spacing = StrTok("24|13", "|");
    Center = (67, -381, -7.875);
    Crates = [];
    Fx = [];
    for (Up = 0; Up < 200; Up += 190) {
        Num = 0;
        for (Rad = 50; Rad < 130; Rad += 71) {
            for (Yaw = 0; Yaw < 360; Yaw += Int(Spacing[Num])) {
                i = Crates.size;
                Crates[i] = spawn("script_model", Center + (Cos(Yaw) * Rad, Sin(Yaw) * Rad, Up));
                Crates[i] SetModel("static_berlin_metal_desk");
                Crates[i] MerryArray();
                Vector = VectorToAngles(Crates[i].origin - (Center[0], Center[1], Center[2] + Up));
                if (Up == 190) {
                    Crates[i].angles = (Vector[0], Vector[1], 180);
                    C = Fx.size;
                    Fx[C] = spawnSM(Crates[i].origin - (0, 0, 30), "zombie_zapper_cagelight_red");
                    Fx[C] MerryArray();
                    Fx[C] thread MerryFx();
                    Fx[C] LinkTo(Crates[i]);
                } else Crates[i].angles = (Vector[0], Vector[1], 0);
                wait .05;
            }
            Num++;
        }
    }
    Spinner = spawnSM(Center, "tag_origin");
    Spinner MerryArray();
    for (i = 0; i < Crates.size; i++) Crates[i] LinkTo(Spinner);
    Pole = [];
    for (Up = 60; Up < 140; Up += 72) {
        for (Yaw = 0; Yaw < 360; Yaw += 30) {
            i = Pole.size;
            Pole[i] = spawnSM(Center + (0, 0, Up), "static_berlin_metal_desk", (90, Yaw, 0));
            Pole[i] MerryArray();
            wait .05;
        }
    }
    Seats = [];
    i = Seats.size;
    Seats[i] = spawnSM(Center + (-22, 70, 50), "static_seelow_blackbarrel", (90, 0, 0));
    Seats[i + 1] = spawnSM(Center + (-22, -70, 50), Seats[i].model, (90, 0, 0));
    Seats[i + 2] = spawnSM(Center + (-70, -22, 50), Seats[i].model, (90, 90, 0));
    Seats[i + 3] = spawnSM(Center + (70, -22, 50), Seats[i].model, (90, 90, 0));
    Seats[i + 4] = spawnSM(Center + (-92, 70, 50), Seats[i].model, (90, 45, 0));
    Seats[i + 5] = spawnSM(Center + (92, -70, 50), Seats[i].model, (90, -135, 0));
    Seats[i + 6] = spawnSM(Center + (-70, -92, 50), Seats[i].model, (90, 135, 0));
    Seats[i + 7] = spawnSM(Center + (70, 92, 50), Seats[i].model, (90, -45, 0));
    for (i = 0; i < Seats.size; i++) Seats[i] MerryArray();
    Spinner thread MonitorPlayers(Seats);
    Spinner thread MerryProtection();
    SeatTag = [];
    for (i = 0; i < 8; i++) {
        SeatTag[i] = spawnSM(Center + (0, 0, 50), "tag_origin");
        SeatTag[i] thread MoveObj();
        SeatTag[i] thread RotateEntYaw(360, 3);
        SeatTag[i] MerryArray();
        Seats[i] LinkTo(SeatTag[i]);
        wait .05;
    }
    Spinner thread RotateEntYaw(360, 3);
    level.MerryConstructing = undefined;
    level.merryGoRound = undefined;
    self thread SpawnRefresh();
}
merryArray() {
    if (!IsDefined(level.merryArray)) level.merryArray = [];
    level.merryArray[level.merryArray.size] = self;
}
MerryFx() {
    while (IsDefined(self)) {
        self SetModel("zombie_zapper_cagelight_green");
        wait .2;
        self SetModel("zombie_zapper_cagelight_red");
        wait .2;
    }
}
MerryProtection() {
    Trig = spawn("trigger_radius", self.origin, 1, 150, 150);
    while (IsDefined(self)) {
        Trig waittill("trigger", i);
        if (i.is_zombie) i DoDamage(i.health + 666, i.origin);
    }
    Trig Delete();
}
MonitorPlayers(Array) {
    Trig = spawnTrig(self.origin, 150, 150, "HINT_NOICON", "Press &&1 To Spare a Place On The Merry Go Round!");
    Trig MerryArray();
    while (IsDefined(self)) {
        Trig waittill("trigger", i);
        if (!i.IsMerrying && !i.is_zombie) {
            Closest = GetClosest(i.origin, Array);
            if (!Closest.Occupied) {
                i SetStance("crouch");
                i.IsMerrying = true;
                i PlayerLinkTo(Closest);
                i thread PlayerExitMerry(Closest);
                Closest.Occupied = true;
            }
        }
    }
}
PlayerExitMerry(Seat) {
    self endon("death");
    self endon("disconnect");
    while (IsDefined(Seat)) {
        if (self UseButtonPressed()) break;
        wait .05;
    }
    self.IsMerrying = false;
    Seat.Occupied = false;
    self Unlink();
    self ReturnToSpawn();
    self SetStance("stand");
}
MoveObj() {
    while (IsDefined(self)) {
        Move = RandomFloatRange(1, 2);
        self MoveZ(40, Move, .4, .4);
        wait Move;
        Move = RandomFloatRange(1, 2);
        self MoveZ(-40, Move, .4, .4);
        wait Move;
    }
}

//Skybase

skybase() {
    if (!isDefined(level.skybase) && level.BigBoy == false && level.Small == false && level.OGBase != true) {
        if (level.rainstarter == true) {
            if (isDefined(level.entitySpace)) return;
            level.entitySpace = true;
            level.BigBoy = true;
            level.skybase = true;
            level thread initSkybase();
            self thread createProgressBar(12.4, "Skybase Spawning!", 1, "Skybase Spawned!");
            self thread SpawnRefresh();
        }
    }
    if (!isDefined(level.skybase) && level.BigBoy == false && level.Small == false && level.OGBase != true) {
        if (level.Raindeletetime == true) {
            getPlayers()[0] notify("rain_sphere");
            level.BigBoy = true;
            if (isDefined(level.entitySpace)) return;
            level.entitySpace = true;
            level.BigBoy = true;
            level.skybase = true;
            self thread SpawnRefresh();
            self iPrintln("^1Deleting ^7Raining Models!");
            wait 7;
            self thread createProgressBar(12.4, "Skybase Spawning!", 1, "Skybase Spawned!");
            level thread initSkybase();
        }
    }
    if (!isDefined(level.skybase) && level.OGBase != true) {
        if (level.Small == true || level.BigBoy == true) {
            self playlocalsound("deny");
            self iPrintln("^1Error ^7Entity Limit Reached!");
        }
    } else {
        if (level.skybaseUsage != 0 || isDefined(level.skybaseMoving) || isDefined(level.skybaseIsBuilding)) return;
        if (!isDefined(level.skybase) && level.OGBase == true) {
            self thread createProgressBar_Delete(10, "Skybase Deleting!", 1, "Skybase Deleted!");
            level thread skybaseDelete();
            level.skybase = true;
            level.OGBase = false;
            self thread SpawnRefresh();
        }
    }
}
skybaseDelete() {
    level.skybaseIsBuilding = true;
    level notify("skybase_entranceover");
    for (m = 0; m < level.skybaseArray2.size; m++) level.skybaseArray2[m] delete();
    level.skybaseArray2 = undefined;
    for (m = 0; m < getPlayers().size; m++) {
        player = getPlayers()[m];
        if (isDefined(player.isInSkybase)) {
            player returnToSpawn();
            player allowJump(true);
            player.isInSkybase = undefined;
            if (!player.skybaseGod || !isDefined(player.menu["misc"]["godMode"])) player disableGodMode();
            else if (player.skybaseGod || isDefined(player.menu["misc"]["godMode"])) player enableGodMode();
            player thread afterKillstreakProtection();
        }
    }
    for (m = 0; m < level.skybaseArray.size; m++) {
        if (isDefined(level.skybaseArray[m].script_vector)) level.skybaseArray[m] notSolid();
        else level.skybaseArray[m] delete();
        wait .05;
    }
    level.skybase = undefined;
    level.skybaseIsBuilding = undefined;
    level.skybaseArray = undefined;
    level.entitySpace = undefined;
    level.Raindeletetime = false;
    level.rainstarter = true;
    level.BigBoy = false;
    self thread SpawnRefresh();
}
initSkybase() {
    level.skybaseIsBuilding = true;
    level.OGBase = true;
    level.skybaseUsage = 0;
    level thread survivalDoors();
    array = [];
    array[0] = spawnMultipleModels((-30, -370, 431), 4, 8, 1, 72, -36, 0, "static_berlin_metal_desk");
    array[1] = spawnMultipleModels((-30, -370, 604), 4, 8, 1, 72, -36, 0, "static_berlin_metal_desk", (0, 0, -180));
    array[2] = spawnMultipleModels((234, -397, 465), 1, 3, 6, -312, -90, 17.6, "zombie_treasure_box", (0, -90, 0));
    array[3] = spawnMultipleModels((-78, -397, 465), 1, 3, 6, -312, -90, 17.6, "zombie_treasure_box", (0, 90, 0));
    array[4] = spawnMultipleModels((-57, -340, 465), 4, 1, 6, 90, 0, 17.6, "zombie_treasure_box");
    array[5] = spawnMultipleModels((-57, -634, 465), 4, 1, 6, 90, 0, 17.6, "zombie_treasure_box", (0, 180, 0));
    array[6] = spawnMultipleModels((33, -328, 483), 2, 1, 1, 90, 0, 0, "zombie_treasure_box_lid", (0, 0, 180));
    array[7] = spawnMultipleModels((33, -352, 553.2), 2, 1, 1, 90, 0, 0, "zombie_treasure_box_lid");
    array[8] = spawnMultipleModels(array[4][7].origin + (0, 0, 24), 2, 1, 3, 90, 0, 24, "zombie_treasure_box_lid", (0, 0, -90));
    window = strTok("7 8 9 10 13 14 15 16", " ");
    for (m = 0; m < window.size; m++) array[4][int(window[m])] hide();
    for (m = 0; m < array.size; m++)
        for (e = 0; e < array[m].size; e++) array[m][e] skybaseArray();
    door = getEntArray("zombie_door", "targetname");
    door[0].doors[0].origin = (80, -336, 431);
    door[0].doors[0] hide();
    door[0].doors[0].angles = (90, 0, 180);
    door[3].doors[0].origin = (239, -484, 493);
    door[3].doors[0] hide();
    door[3].doors[0].angles = (0, 0, 90);
    door[2].doors[0].origin = (-78, -482, 465);
    door[2].doors[0] hide();
    door[2].doors[0].angles = (0, 0, 90);
    door[8].doors[0].origin = (25, -636, 465);
    door[8].doors[0] hide();
    door[8].doors[0].angles = (0, 135, 0);
    door[1].doors[0].origin = (162, -636, 465);
    door[1].doors[0] hide();
    door[5].doors[0].origin = (112, -603, 516);
    door[5].doors[0] hide();
    door[5].doors[1].origin = (-35, -486, 516);
    door[5].doors[1] hide();
    door[5].doors[1].angles = (0, 90, 0);
    door[7].doors[0].origin = (196, -462, 487);
    door[7].doors[0] hide();
    door[7].doors[1].origin = (196, -510, 487);
    door[7].doors[1] hide();
    tok = strTok("0 3 2 8 1 5 7", " ");
    for (m = 0; m < tok.size; m++) {
        door[int(tok[m])].doors[0] skybaseArray();
        door[int(tok[m])].doors[0] solid();
        door[int(tok[m])].doors[0].door_moving = true;
    }
    door[5].doors[1] skybaseArray();
    door[5].doors[1] solid();
    door[7].doors[1] skybaseArray();
    door[7].doors[1] solid();
    func = funcToArray(::skybaseWindow, ::skybasePackaPunch, ::skybaseRandomBox, ::skybaseExit, ::skybaseRandyScorePurchase, ::skybaseAllPerks, ::skybaseMovement, ::skybaseZombify, ::skybaseCallUfo);
    inp[0] = array[8];
    inp[6] = array;
    inp[8] = array;
    for (m = 0; m < func.size; m++) {
        level thread[[func[m]]](inp[m]);
        wait .5;
    }
    level.skybaseIsBuilding = undefined;
    level.skybase = undefined;
    self thread SpawnRefresh();
}
skybaseCallUfo(array) {
    level endon("skybase_entranceover");
    pos = (-443, -17, 112);
    head = spawnSM(pos, "char_ger_ansel_head_zomb", (-90, 0, 0));
    head skybaseArray2();
    hat = spawnSM(pos + (0, 2, 12), "char_ger_waffen_officercap1_zomb", (-90, 0, 0));
    hat skybaseArray2();
    hat linkTo(head);
    trig = spawnTrigger(pos - (0, 0, 50), 40);
    trig skybaseArray2();
    head thread stareAtPlayers();
    for (;;) {
        trig setString("Press [{+activate}] To Call In Relocating Elevator!");
        for (;;) {
            trig waittill("trigger", user);
            if (user useButtonPressed() && !user.is_zombie && !isDefined(level.skybaseIsBuilding) && !isDefined(level.skybase)) break;
        }
        head playSound("plr_3_vox_perk_packa_wait_1");
        trig setString("");
        pos = (30, -183, -30);
        zb = "zombie_treasure_box";
        zl = zb + "_lid";
        box = [];
        box[0] = spawnSM(pos + (0, 57, 0), zb);
        box[1] = spawnSM(pos + (57, 0, 0), zb, (0, -90, 0));
        box[2] = spawnSM(pos - (0, 57, 0), zb, (0, -180, 0));
        box[3] = spawnSM(pos - (57, 0, 0), zb, (0, 90, 0));
        array_thread(box, ::skybaseArray2);
        box[0] playSound("bridge_lower");
        lid = [];
        lid[0] = spawnSM(box[0].origin + (0, -12, 17.8), zl, (0, 180, 180));
        lid[1] = spawnSM(box[1].origin + (-12, 0, 17.8), zl, (0, 90, 180));
        lid[2] = spawnSM(box[2].origin + (0, 12, 17.8), zl, (0, 0, 180));
        lid[3] = spawnSM(box[3].origin + (12, 0, 17.8), zl, (0, -90, 180));
        array_thread(lid, ::skybaseArray2);
        floor = spawnMultipleModels(pos - (0, 49, 0), 1, 4, 1, 0, 24, 0, zl, (180, 0, 0));
        array_thread(floor, ::skybaseArray2);
        tBox = [];
        for (m = 0; m < box.size; m++) tBox[m] = spawnSM(box[m].origin, zb, box[m].angles);
        array_thread(tBox, ::skybaseArray2);
        tLid = [];
        for (m = 0; m < lid.size; m++) tLid[m] = spawnSM(lid[m].origin, zl, lid[m].angles);
        array_thread(tLid, ::skybaseArray2);
        tFloor = spawnMultipleModels(floor[0].origin, 1, 4, 1, 0, 24, 0, zl, (180, 0, 0));
        array_thread(tFloor, ::skybaseArray2);
        for (m = 0; m < lid.size; m++) lid[m] linkTo(box[m]);
        for (m = 0; m < floor.size; m++) floor[m] linkTo(box[0]);
        for (m = 0; m < box.size; m++) box[m] moveZ(27.125, 4, 0, 1);
        wait 4;
        trig2 = spawnTrigger(pos, 40);
        trig2 setString("Press [{+activate}] To Activate!");
        trig2 skybaseArray2();
        for (;;) {
            trig2 waittill("trigger", i);
            if (i useButtonPressed() && !isDefined(level.skybaseMoving) && !i.is_zombie && !isDefined(level.skybase)) break;
        }
        level.skybaseUsage++;
        seat = [];
        for (m = 0; m < getPlayers().size; m++) {
            player = getPlayers()[m];
            if (player.origin[0] > -1.28267 && player.origin[0] < 61.2508 && player.origin[1] < -151.04 && player.origin[1] > -214.949 && player.origin[2] > -3 && player.origin[2] < 0) {
                seat[seat.size] = spawnSM(player.origin, "tag_origin");
                player.skybaseGod = player isGodMode();
                player enableGodMode();
                player playerLinkTo(seat[seat.size - 1]);
                player allowJump(false);
                player.isInSkybase = true;
                seat[seat.size - 1] linkTo(box[0]);
            }
        }
        playSoundAtPosition("pa_buzz", pos + (0, 0, 30));
        trig2 delete();
        cor = [];
        cor[0] = spawnSM((84, -124, -60), "static_peleliu_filecabinet_metal", (0, 180, 0));
        cor[1] = spawnSM((-24, -124, -60), "static_peleliu_filecabinet_metal", (0, 180, 0));
        cor[2] = spawnSM((84, -242, -60), "static_peleliu_filecabinet_metal");
        cor[3] = spawnSM((-24, -242, -60), "static_peleliu_filecabinet_metal");
        for (m = 0; m < cor.size; m++) cor[m] moveZ(76, 2, 0, .5);
        cor[0] playSound("packa_door_2");
        newLids = [];
        for (m = 0; m < lid.size; m++) {
            newLids[m] = spawnSM(lid[m].origin, lid[m].model, lid[m].angles);
            newLids[m] rotateRoll(-90, 2, 0, .5);
        }
        wait 2;
        link = spawnSM(pos, "tag_origin");
        for (m = 0; m < tBox.size; m++) tBox[m] linkTo(link);
        for (m = 0; m < tLid.size; m++) tLid[m] linkTo(link);
        for (m = 0; m < tFloor.size; m++) tFloor[m] linkTo(link);
        link.angles = (0, 0, 180);
        link.origin = link.origin + (0, 0, 1500);
        link moveTo((pos[0], pos[1], 98), 2, 1);
        link rotateYaw(360, 2, 1);
        for (m = 0; m < 3; m++) {
            playSoundAtPosition("pad_warmup", pos + (0, 0, 30));
            wait .3;
        }
        wait 1.1;
        link playSound("grenade_explode");
        link playSound("door_bang");
        playFx(loadFx("env/dirt/fx_dust_ceiling_impact_lg_mdbrown"), link.origin - (0, 0, 60));
        wait 1;
        link playSound("bridge_hit");
        wait 1;
        for (m = 5; m > 0; m--) {
            floor[1] playSound("pa_audio_link_" + m);
            earthquake(.5, 1, pos + (0, 0, 27.125), 100);
            wait 1;
        }
        for (m = 0; m < box.size; m++) box[m] linkTo(link);
        for (m = 0; m < lid.size; m++) lid[m] linkTo(link);
        for (m = 0; m < floor.size; m++) floor[m] linkTo(link);
        for (m = 0; m < newLids.size; m++) newLids[m] linkTo(link);
        for (m = 0; m < cor.size; m++) cor[m] linkTo(link);
        for (m = 0; m < seat.size; m++) seat[m] linkTo(link);
        playFx(loadFx("explosions/mortarExp_water"), pos + (0, 0, 27.125));
        earthquake(2, 1, pos + (0, 0, 27.125), 100);
        link moveTo((pos[0], pos[1], 2000), 3, 0, 1);
        link rotateYaw(360, 3, 0, 1);
        wait 3;
        link moveTo(array[1][11].origin + (36, -18, 150), 4, 1, 2);
        wait 4;
        for (m = 10; m <= 13; m++) array[1][m] moveX(-72, 2, 1, 1);
        for (m = 18; m <= 21; m++) array[1][m] moveX(72, 2, 1, 1);
        array[1][10] playSound("packa_door_2");
        link moveTo(array[1][11].origin + (36, -18, -37), 5, 2, 2);
        link vibrate((0, -100, 0), 1.5, .5, 4.5);
        wait 5;
        for (m = 10; m <= 13; m++) array[1][m] moveX(72, 2, 1, 1);
        for (m = 18; m <= 21; m++) array[1][m] moveX(-72, 2, 1, 1);
        array[1][10] playSound("packa_door_2");
        wait 1;
        playFx(loadFx("maps/zombie/fx_transporter_beam"), link.origin - (0, 0, 100));
        multipleArrayDelete(box, lid, floor, newLids, cor, seat, tBox, tLid, tFloor);
        link delete();
        wait 1;
        level.skybaseUsage--;
    }
}
stareAtPlayers() {
    while (isDefined(self)) {
        closest = getClosest(self.origin, getPlayers());
        angle = vectorToAngles(self.origin - (closest.origin + (0, 0, 40)));
        self rotateTo((-90, angle[1] + 90, angle[2]), .1);
        wait .05;
    }
}
multipleArrayDelete(a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12) {
    if (isDefined(a1)) array_delete(a1);
    if (isDefined(a2)) array_delete(a2);
    if (isDefined(a3)) array_delete(a3);
    if (isDefined(a4)) array_delete(a4);
    if (isDefined(a5)) array_delete(a5);
    if (isDefined(a6)) array_delete(a6);
    if (isDefined(a7)) array_delete(a7);
    if (isDefined(a8)) array_delete(a8);
    if (isDefined(a9)) array_delete(a9);
    if (isDefined(a10)) array_delete(a10);
    if (isDefined(a11)) array_delete(a11);
    if (isDefined(a12)) array_delete(a12);
}
skybaseIllegalEntrance() {
    for (;;) {}
}
skybaseWindow(array) {
    lever = spawnSM((-40, -353, 518), "zombie_power_lever_handle", (0, 0, 90));
    lever skybaseArray();
    light = spawnSM(lever.origin + (15, 0, 0), "zombie_zapper_cagelight_red", (0, 0, 270));
    light skybaseArray();
    trig = spawnTrigger(lever.origin - (0, 0, 50), 30);
    trig skybaseArray();
    trig setString("Press [{+activate}] To ^2Open ^7Window");
    pos = "closed";
    for (;;) {
        trig waittill("trigger", i);
        if (i useButtonPressed() && !isDefined(level.skybaseMoving)) {
            level.skybaseUsage++;
            trig setHintString("");
            if (pos == "closed") {
                level.skybaseWindowInUse = true;
                light setModel("zombie_zapper_cagelight_green");
                lever thread rotateHandle();
                for (m = 0; m < (array.size / 2); m++) array[m] moveX(-90, 2, .5, .5);
                for (m = 3; m < array.size; m++) array[m] moveX(90, 2, .5, .5);
                wait 2;
                trig setString("Press [{+activate}] To ^1Close ^7Window");
                pos = "open";
                level.skybaseWindowInUse = undefined;
            } else {
                level.skybaseWindowInUse = true;
                light setModel("zombie_zapper_cagelight_red");
                lever thread rotateHandle();
                for (m = 0; m < (array.size / 2); m++) array[m] moveX(90, 2, .5, .5);
                for (m = 3; m < array.size; m++) array[m] moveX(-90, 2, .5, .5);
                wait 2;
                trig setString("Press [{+activate}] To ^2Open ^7Window");
                pos = "closed";
                level.skybaseWindowInUse = undefined;
            }
            level.skybaseUsage--;
        }
    }
}
rotateHandle() {
    self playSound("packa_door_1");
    self rotateTo((0, 0, 0), 1, 0, .5);
    wait 1;
    self rotateTo((0, 0, 90), 1, 0, .5);
}
skybasePackaPunch() {
    pap = spawnStruct();
    pap = spawnSM((-51, -487, 465), "zombie_vending_packapunch_on", (0, 90, 0));
    pap skybaseArray();
    pap.rollers = spawn("script_origin", pap.origin);
    pap.rollers skybaseArray();
    pap.timer = spawn("script_origin", pap.origin);
    pap.timer skybaseArray();
    pap.music = spawn("script_origin", pap.origin);
    pap.music skybaseArray();
    pap.music thread randomMusicPlayers();
    pap.rollers playLoopSound("packa_rollers_loop");
    pap.trig = spawnTrigger(pap.origin + (5, 0, 0), 45, "");
    pap.trig skybaseArray();
    cost = 500;
    for (;;) {
        wait .05;
        pap.trig setString("Press [{+activate}] To Buy Pack 'a' Punch Upgrade [Cost: " + cost + "]");
        for (;;) {
            pap.trig waittill("trigger", user);
            if (user useButtonPressed() && !isDefined(level.skybaseMoving)) {
                currentWeapon = user getCurrentWeapon();
                if (!isDefined(level.zombie_include_weapons[currentWeapon]) || !isDefined(level.zombie_include_weapons[currentWeapon + "_upgraded_zm"])) {
                    wait .1;
                    continue;
                }
                if (user.score < cost) {
                    pap playSound("deny");
                    user playSound("plr_" + user getEntityNumber() + "_vox_nomoney_perk_0");
                    wait .1;
                    continue;
                } else break;
            }
        }
        level.skybaseUsage++;
        user minus_to_player_score(cost);
        pap playSound("bottle_dispense3d");
        user playSound("plr_" + user getEntityNumber() + "_vox_perk_packa_wait_" + randomInt(5));
        if (!isDefined(pap.music.playingMusic)) pap PlaySound("mx_packa_sting");
        pap.trig setString("");
        user thread nuckleCrack();
        weaponModel = user thirdPersonWeaponUpgrade(currentWeapon, pap.origin + (0, -1, 34), pap.angles + (0, 90, 0), pap);
        pap.trig setString("Press [{+activate}] To Take Your Upgraded Weapon");
        pap thread waitForPlayerToTake(user, currentWeapon, pap.timer);
        pap thread waitForTimeout(pap.timer);
        pap waittill_either("pap_timeout", "pap_taken");
        pap.trig setString("");
        weaponModel delete();
        wait 1;
        pap.trig setString("Press [{+activate}] To Buy Pack 'a' Punch Upgrade [Cost: " + cost + "]");
        level.skybaseUsage--;
    }
}
randomMusicPlayers() {
    while (isDefined(self)) {
        self playSound("mx_packa_jingle");
        self.playingMusic = true;
        wait 45;
        self.playingMusic = undefined;
        wait(randomIntRange(45, 60));
    }
}
setInvisibleToAll() {
    for (m = 0; m < get_players().size; m++) self setInvisibleToPlayer(get_players()[m]);
}
waitForPlayerToTake(player, weapon, packaTimer) {
    self endon("pap_timeout");
    for (;;) {
        packaTimer playLoopSound("ticktock_loop");
        self.trig waittill("trigger", grabber);
        if (!grabber useButtonPressed()) continue;
        packaTimer stopLoopSound(.05);
        if (grabber == player) {
            self notify("pap_taken");
            primaries = player getWeaponsListPrimaries();
            if (isDefined(primaries) && primaries.size >= 2) player takeWeapon(player getCurrentWeapon());
            player giveWeapon(weapon + "_upgraded_zm");
            player giveMaxAmmo(weapon + "_upgraded_zm");
            player switchToWeapon(weapon + "_upgraded_zm");
            packaTimer stopLoopSound(.05);
            player playSound("plr_" + player getEntityNumber() + "_vox_perk_packa_get_" + randomInt(5));
            return;
        }
        wait .05;
    }
}
waitForTimeout(packaTimer) {
    self endon("pap_taken");
    wait(level.packapunch_timeout);
    self notify("pap_timeout");
    packaTimer stopLoopSound(.05);
    packaTimer playSound("packa_deny");
}
nuckleCrack() {
    weap = self getCurrentWeapon();
    crack = "zombie_knuckle_crack";
    primaries = self getWeaponsListPrimaries();
    if (weap != "none" && weap != "mine_bouncing_betty") self takeWeapon(weap);
    self giveWeapon(crack);
    self switchToWeapon(crack);
    self waittill("weapon_change_complete");
    self TakeWeapon(crack);
    if (primaries.size <= 1) self giveWeapon("m1911_zm");
    primaries = self getWeaponsListPrimaries();
    if (isDefined(primaries) && primaries.size > 0) self switchToWeapon(primaries[0]);
    else self switchToWeapon("m1911_zm");
}
thirdPersonWeaponUpgrade(currentWeapon, origin, angles, perkMachine) {
    forward = anglesToForward(angles);
    interactPos = origin + (forward * -25);
    worldGun = spawnSM(interactPos, getWeaponModel(currentWeapon), self.angles);
    playFx(level._effect["packapunch_fx"], origin + (0, 1, -34), forward);
    worldGun rotateTo(angles + (0, 90, 0), .35);
    wait .5;
    worldGun moveTo(origin, .5);
    perkMachine playSound("packa_weap_upgrade");
    wait .35;
    worldGun delete();
    wait 3;
    perkMachine playSound("packa_weap_ready");
    worldGun = spawnSM(origin, getWeaponModel(currentWeapon + "_upgraded_zm"), angles + (0, 90, 0));
    worldGun moveTo(interactPos, .5);
    wait .5;
    worldGun moveTo(origin, level.packapunch_timeout);
    return worldGun;
}
skybaseRandomBox() {
    base = spawnSM((206, -487, 466.125), "zombie_treasure_box", (0, 90, 0));
    base skybaseArray();
    box = spawnStruct();
    box = spawnSM(base.origin + (0, 0, 17.8), "zombie_treasure_box", (0, 90, 0));
    box skybaseArray();
    box.lid = spawnSM((218, -487, 501.925), "zombie_treasure_box_lid", (0, 90, 0));
    box.lid skybaseArray();
    box.trig = spawnTrigger(box.origin, 40);
    box.trig skybaseArray();
    cost = 250;
    for (;;) {
        box.trig setString("Press [{+activate}] For a Random Weapon [Cost: " + cost + "]");
        user = undefined;
        for (;;) {
            box.trig waittill("trigger", user);
            if (user useButtonPressed() && !isDefined(level.skybaseMoving)) {
                if (user.score < cost) {
                    user playSound("plr_" + user getEntityNumber() + "_vox_nomoney_perk_0");
                    wait .1;
                    continue;
                } else break;
            }
        }
        level.skybaseUsage++;
        user minus_to_player_score(cost);
        box.lid rotateRoll(105, .5, (.5 * .5));
        box.lid playSound("lid_open");
        box.lid playSound("music_box");
        box thread treasureChestWeaponSpawn(user);
        box.fx = spawnSM(box.origin, "tag_origin", (90, 0, 0));
        playFxOnTag(level._effect["chest_light"], box.fx, "tag_origin");
        box.trig setString("");
        box waittill("randomization_done");
        box.trig setString("Press [{+activate}] To Trade Weapons");
        box thread treasureChestTimeout();
        for (;;) {
            box.trig waittill("trigger", grabber);
            if (grabber useButtonPressed() && grabber == user) {
                if (box.randomlyRolledWeapon != "") grabber thread maps\_zombiemode_weapons::treasure_chest_give_weapon(box.RandomlyRolledWeapon);
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
        level.skybaseUsage--;
    }
}
treasureChestTimeout() {
    self endon("user_grabbed_weapon");
    self.weaponBeingRolled moveTo(self.weaponBeingRolled.origin - (0, 0, 40), 12, (12 * .5));
    wait 12;
    self.trig notify("trigger", level);
}
treasureChestWeaponSpawn(player) {
    self.weaponBeingRolled = spawnSM(self.origin, "tag_origin", (0, 90, 0));
    self.weaponBeingRolled moveTo(self.weaponBeingRolled.origin + (0, 0, 40), 3, 2, .9);
    keys = getArrayKeys(level.zombie_weapons);
    array = [];
    for (m = 0; m < keys.size; m++) {
        if (isSubStr(keys[m], "zombie_cymbal_monkey")) continue;
        if (!isSubStr(keys[m], "mine_bouncing_betty") && !isSubStr(keys[m], "_upgraded_zm") && !player hasWeapon(keys[m])) array[array.size] = keys[m];
    }
    randy = 0;
    for (m = 0; m < 40; m++) {
        if (m < 20) wait .05;
        else if (m < 30) wait .1;
        else if (m < 35) wait .2;
        else if (m < 38) wait .3;
        randy = array[randomInt(array.size)];
        self.weaponBeingRolled setModel(getWeaponModel(randy));
    }
    self.randomlyRolledWeapon = randy;
    self notify("randomization_done");
}
skybaseRandyScorePurchase() {
    mach = spawnSM((123, -608, 466.125), "zombie_vending_sleight_on", (0, 180, 0));
    mach skybaseArray();
    playFxOnTag(level._effect["sleight_light"], mach, "tag_origin");
    trig = spawnTrigger(mach.origin, 40);
    trig skybaseArray();
    trig setString("Press [{+activate}] To Determine Your Scores Luck! [Cost: 150]");
    for (;;) {
        trig waittill("trigger", i);
        if (i useButtonPressed() && !isDefined(i.isRandyScoring) && !isDefined(level.skybaseMoving)) {
            if (i.score < 150) {
                i playSound("plr_" + i getEntityNumber() + "_vox_nomoney_perk_0");
                continue;
            }
            i.isRandyScoring = true;
            i minus_to_player_score(150);
            i playSound("cha_ching");
            i thread randyScoreMachine();
        }
    }
}
randyScoreMachine() {
    text = self createText(getFont(), 2, "CENTER", "CENTER", 0, 0, 1, 1, "");
    speed = .1;
    score = 0;
    for (m = 0; m < 14; m++) {
        speed += .1;
        score = randomIntRange(-500, 500);
        text setValue(score);
        if (score < 0) text.color = (1, 0, 0);
        if (score > 0) text.color = (0, 1, 0);
        if (score == 0) text.color = (1, 1, 1);
        wait(speed / 2);
    }
    if (score > 0) {
        self add_to_player_score(score);
        self playSound("cha_ching");
    }
    if (score < 0) {
        self minus_to_player_score((score - score) + (-1) * score);
        self playSound("packa_deny");
    }
    wait 1;
    text hudFadenDestroy(0, 1);
    self.isRandyScoring = undefined;
}
skybaseAllPerks() {
    pos = (202, -599, 466.125);
    perk[0] = spawnSM(pos + (0, 0, 62), "tag_origin");
    perk[1] = spawnSM(perk[0].origin + (-5, 0, 0), "zombie_perk_bottle_jugg");
    perk[2] = spawnSM(perk[0].origin + (5, 0, 0), "zombie_perk_bottle_revive");
    perk[3] = spawnSM(perk[0].origin + (0, -5, 0), "zombie_perk_bottle_doubletap");
    perk[4] = spawnSM(perk[0].origin + (0, 5, 0), "zombie_perk_bottle_sleight");
    perk[5] = spawnSM(pos, "tag_origin", (-90, 0, 0));
    playFxOnTag(loadFx("misc/fx_zombie_electric_trap"), perk[5], "tag_origin");
    perk[0] skybaseArray();
    perk[5] skybaseArray();
    for (m = 1; m < 5; m++) {
        perk[m] linkTo(perk[0]);
        perk[m] skyBaseArray();
    }
    perk[0] thread rotateEntYaw(360, 2);
    perk[0] thread perkMovement(perk);
    trig = spawnTrigger(pos, 40);
    trig skybaseArray();
    trig setString("Press [{+activate}] To Purchase All Perks! [Cost: 250]");
    for (;;) {
        trig waittill("trigger", i);
        if (i useButtonPressed() && !isDefined(level.skybaseMoving) && !isDefined(i.skybasePerking) && !IsDefined(i.perks_bought)) {
            if (i.score < 250) {
                i playSound("plr_" + i getEntityNumber() + "_vox_nomoney_perk_0");
                continue;
            }
            if (i hasPerk("specialty_rof") && i hasPerk("specialty_armorvest") && i hasPerk("specialty_quickrevive") && i hasPerk("specialty_fastreload")) continue;
            i.skybasePerking = true;
            i.perks_bought = true;
            i playSound("cha_ching");
            i minus_to_player_score(250);
            i thread purchasePerks();
        }
    }
}
perkMovement(perk) {
    self.origin = perk[5].origin + (0, 0, 62);
    for (;;) {
        self moveZ(-38, 3, .5, .5);
        for (m = 0; m <= 3; m += .05) {
            if (isDefined(level.skybaseMoving)) break;
            wait .05;
        }
        self moveZ(38, 3, .5, .5);
        for (m = 0; m <= 3; m += .05) {
            if (isDefined(level.skybaseMoving)) break;
            wait .05;
        }
        if (isDefined(level.skybaseMoving)) break;
    }
    for (m = 0; m <= 3; m += .05) {
        if (!isDefined(level.skybaseMoving)) break;
        wait .05;
    }
    for (m = 1; m < 5; m++) perk[m] linkTo(perk[0]);
    self thread perkMovement(perk);
}
skybaseMovement(array) {
    door = getEntArray("zombie_door", "targetname");
    panel = spawnSM((190, -353, 504), "zombie_teleporter_control_panel");
    panel skybaseArray();
    light = spawnSM(panel.origin + (20, 0, 14), "zombie_zapper_cagelight_red", (0, 0, 270));
    light skybaseArray();
    light thread initiateLights();
    trig = spawnTrigger(panel.origin - (0, 0, 50), 40);
    trig skybaseArray();
    trig setString("Press [{+activate}] To Move Skybase To Next Location!");
    loc = [];
    loc[0] = (-770, -1145, 1140.13);
    loc[1] = (250, -2200, 466.125);
    loc[2] = (-1680, -2083, 466.125);
    loc[3] = (78, -496, 466.125);
    pos = 3;
    for (;;) {
        trig waittill("trigger", user);
        if (user useButtonPressed() && level.skybaseUsage == 0 && ((isDefined(user getPermission()) && user getPermission() == level.permissions[2]) || user == getPlayers()[0])) {
            level.skybaseMoving = true;
            trig setString("Arriving At Destination Soon!");
            panel playSound("amb_sparks_l_b");
            pos++;
            if (pos > 3) pos = 0;
            link = spawnSM(array[0][11].origin + (36, -18, 35.125), "tag_origin");
            for (m = 0; m < level.skybaseArray.size; m++) level.skybaseArray[m] linkTo(link);
            temp = [];
            for (m = 0; m < getPlayers().size; m++)
                if (isDefined(getPlayers()[m].isInSkybase)) {
                    temp[temp.size] = spawnSM(getPlayers()[m].origin, "tag_origin");
                    getPlayers()[m] linkTo(temp[temp.size - 1]);
                    temp[temp.size - 1] linkTo(link);
                }
            link moveTo((link.origin[0], link.origin[1], 1400), 3, 0, 1);
            link vibrate((0, -100, 0), 1.5, .5, 2.5);
            wait 3;
            link moveTo((loc[pos][0], loc[pos][1], 1400), 4, 0, 2);
            link rotateYaw(360, 4, 0, 2);
            wait 4;
            link moveTo(loc[pos], 3, 0, 1);
            link vibrate((0, 100, 0), 1.5, .5, 2.5);
            wait 3;
            playFx(loadFx("maps/zombie/fx_zombie_mainframe_steam"), trig.origin);
            for (m = 0; m < level.skybaseArray.size; m++) {
                level.skybaseArray[m] unlink();
                level.skybaseArray[m] notify("skybase_tempUnlink");
            }
            array_delete(temp);
            for (m = 0; m < getPlayers().size; m++)
                if (isDefined(getPlayers()[m].isInSkybase)) getPlayers()[m] setOrigin(getPlayers()[m].origin + (0, 0, 1.125));
            link delete();
            wait .05;
            trig setString("Skybase Engines ^1Cooling Down!");
            level.skybaseMoving = undefined;
            level.skybaseCooling = true;
            wait(randomIntRange(15, 30));
            level.skybaseCooling = undefined;
            trig setString("Press [{+activate}] To Move Skybase To Next Location!");
        } else if (user useButtonPressed()) panel playSound("packa_deny");
        wait .05;
    }
}
initiateLights() {
    while (isDefined(self)) {
        if (isDefined(level.skybaseCooling) || level.skybaseUsage != 0 || isDefined(level.skybaseMoving)) self setModel("zombie_zapper_cagelight_red");
        else self setModel("zombie_zapper_cagelight_green");
        wait .05;
    }
}
skybaseExit() {
    model = [];
    for (m = 0; m < 4; m++) {
        model[m] = spawnSM((-43, -595, 480 + (m * 20)), "zombie_sign_please_wait");
        model[m] skybaseArray();
        model[m] thread randyWobble();
    }
    fx = spawnSM((-43, -595, 466.125), "tag_origin", (-90, 0, 0));
    fx skybaseArray();
    playFxOnTag(loadFx("misc/fx_zombie_electric_trap"), fx, "tag_origin");
    trig = spawnTrigger((-43, -595, 460), 40);
    trig skybaseArray();
    trig setString("Press [{+activate}] To Leave Skybase!");
    for (;;) {
        trig waittill("trigger", i);
        if (i useButtonPressed() && !isDefined(level.skybaseMoving)) {
            playFx(loadFx("maps/zombie/fx_transporter_beam"), i.origin);
            i returnToSpawn();
            i allowJump(true);
            i playLocalSound("teleport_2d_fnt");
            i thread[[level.teleport_ae_funcs[randomInt(level.teleport_ae_funcs.size)]]]();
            playFx(loadFx("maps/zombie/fx_transporter_beam"), i.origin);
            i.isInSkybase = undefined;
            wait .05;
            if (!i.skybaseGod || !isDefined(i.menu["misc"]["godMode"])) i disableGodMode();
            else if (i.skybaseGod || isDefined(i.menu["misc"]["godMode"])) i enableGodMode();
            i thread afterKillstreakProtection();
        }
    }
}
randyWobble() {
    while (isDefined(self)) {
        waittime = randomFloatRange(2.5, 5);
        yaw = randomInt(360);
        if (yaw > 300) yaw = 300;
        else if (yaw < 60) yaw = 60;
        yaw = self.angles[1] + yaw;
        self rotateTo((-60 + randomInt(120), yaw, -45 + randomInt(90)), waitTime, waitTime * .5, waitTime * .5);
        wait(randomFloat(waitTime - .1));
    }
}
#using_animtree("generic_human");
skybaseZombify() {
    zom = spawnSM((30, -600, 466.125), "char_ger_honorgd_bodyz2_1", (0, 90, 0));
    zom skybaseArray();
    zom.headModel = "char_ger_honorgd_zombiehead2_3";
    zom attach(zom.headModel, "", true);
    zom.hatModel = "char_ger_waffen_officercap1_zomb";
    zom attach(zom.hatModel);
    zom useAnimTree(#animtree);
    zom setAnim( % ai_zombie_walk_v1);
    zom thread playZombieGroans();
    trig = spawnTrigger(zom.origin, 40);
    trig skybaseArray();
    trig setString("Press [{+activate}] To Zombify Yourself for 30 Seconds! [Cost: 50]");
    for (;;) {
        trig waittill("trigger", user);
        if (user useButtonPressed() && !isDefined(user.zombified)) {
            if (user.score < 50) {
                user playSound("plr_" + user getEntityNumber() + "_vox_nomoney_perk_0");
                continue;
            }
            user thread doZombify();
            user minus_to_player_score(50);
        }
    }
}
playZombieGroans() {
    while (isDefined(self)) {
        self playSound("zombie_groan_monkey");
        wait(randomFloatRange(5, 10));
    }
}
doZombify() {
    self.zombified = true;
    self.groundRefEnt = spawnSM((0, 0, 0));
    self.playerSpeed = 50;
    self playerSetGroundReferenceEnt(self.groundRefEnt);
    lastWeapon = self getCurrentWeapon();
    self giveWeapon("zombie_melee", 0);
    self switchToWeapon("zombie_melee");
    self disableWeaponCycling();
    self disableOffhandWeapons();
    self allowProne(false);
    self allowCrouch(false);
    self allowSprint(false);
    self allowJump(false);
    self setMoveSpeedScale(.3);
    self setVision("zombie_turned");
    self maps\_utility::setClientSysState("zombify", 1, self);
    zom = getAiArray("axis")[randomInt(getAiArray("axis").size)];
    self thread zombieLimp();
    wait 30;
    self notify("zombify_over");
    self.groundRefEnt delete();
    self playerSetGroundReferenceEnt(undefined);
    self takeWeapon("zombie_melee", 0);
    self switchToWeapon(lastWeapon);
    self enableWeaponCycling();
    self enableOffhandWeapons();
    self allowProne(true);
    self allowCrouch(true);
    self allowSprint(true);
    if (!isDefined(self.isInSkybase)) self allowJump(true);
    self setMoveSpeedScale(1);
    self setVision("default");
    self maps\_utility::setClientSysState("zombify", 0, self);
    self.zombified = undefined;
}
zombieLimp() {
    self endon("death");
    self endon("disconnect");
    self endon("zombify_over");
    stumble = 0;
    alt = 0;
    for (;;) {
        velocity = self getVelocity();
        playerSpeed = abs(velocity[0]) + abs(velocity[1]);
        if (playerSpeed < 10) {
            wait .05;
            continue;
        }
        speedMultiplier = playerSpeed / self.playerSpeed;
        p = randomFloatRange(3, 5);
        if (randomInt(100) < 20) p *= 3;
        r = randomFloatRange(3, 7);
        y = randomFloatRange(-8, -2);
        stumbleAngles = (p, y, r);
        stumbleAngles = vector_multiply(stumbleAngles, speedMultiplier);
        stumbleTime = randomFloatRange(.35, .45);
        recoverTime = randomFloatRange(.65, .8);
        stumble++;
        if (speedMultiplier > 1.3) stumble++;
        self thread stumble(stumbleAngles, stumbleTime, recoverTime);
        self waittill("recovered");
    }
}
stumble(stumbleAngles, stumbleTime, recoverTime) {
    stumbleAngles = self adjustAnglesToPlayer(stumbleAngles);
    self.groundRefEnt rotateTo(stumbleAngles, stumbleTime, (stumbleTime / 4 * 3), (stumbleTime / 4));
    self.groundRefEnt waittill("rotatedone");
    baseAngles = (randomFloat(4) - 4, randomFloat(5), 0);
    baseAngles = self adjustAnglesToPlayer(baseAngles);
    self.groundRefEnt rotateTo(baseAngles, recoverTime, 0, (recoverTime / 2));
    self.groundRefEnt waittill("rotatedone");
    self notify("recovered");
}
adjustAnglesToPlayer(stumbleAngles) {
    pa = stumbleAngles[0];
    ra = stumbleAngles[2];
    rv = anglesToRight(self.angles);
    fv = anglesToForward(self.angles);
    rva = (rv[0], 0, rv[1] * -1);
    fva = (fv[0], 0, fv[1] * -1);
    angles = vector_multiply(rva, pa);
    angles = angles + vector_multiply(fva, ra);
    return (angles + (0, stumbleAngles[1], 0));
}
skybaseArray(follow, offset) {
    if (!isDefined(level.skybaseArray)) level.skybaseArray = [];
    m = level.skybaseArray.size;
    if (isDefined(follow)) {
        level.skybaseArray[m] = spawnStruct();
        level.skybaseArray[m] = self;
        level.skybaseArray[m].follow = follow;
        level.skybaseArray[m].offset = offset;
    } else level.skybaseArray[m] = self;
}
skybaseArray2() {
    if (!isDefined(level.skybaseArray2)) level.skybaseArray2 = [];
    m = level.skybaseArray2.size;
    level.skybaseArray2[m] = self;
}
funcToArray(f1, f2, f3, f4, f5, f6, f7, f8, f9, f10, f11, f12, f13) {
    array = [];
    array[0] = f1;
    array[1] = f2;
    array[2] = f3;
    array[3] = f4;
    array[4] = f5;
    array[5] = f6;
    array[6] = f7;
    array[7] = f8;
    array[8] = f9;
    array[9] = f10;
    array[10] = f11;
    array[11] = f12;
    array[12] = f13;
    return array;
}
spawnTrigger(origin, dist) {
    trig = spawnSM(origin, "tag_origin");
    trig thread triggerThink(dist);
    return trig;
}
triggerThink(dist) {
    authentication = randyId();
    plr = getPlayers();
    for (m = 0; m < plr.size; m++)
        if (!isDefined(plr[m].trigger_init)) plr[m].trigger_init = [];
    while (isDefined(self)) {
        plr = getPlayers();
        for (m = 0; m < plr.size; m++) {
            if (distance(plr[m].origin, self.origin) < dist) {
                if (!isDefined(plr[m].trigger_init[authentication])) plr[m].trigger_init[authentication] = plr[m] createText(getFont(), 1.25, "CENTER", "CENTER", 0, 70, 1, 1, undefined);
                plr[m].trigger_init[authentication] setText(self.hintString);
                self notify("trigger", plr[m]);
            } else if (isDefined(plr[m].trigger_init[authentication])) plr[m].trigger_init[authentication] destroy();
            wait .05;
        }
        wait .05;
    }
    plr = getPlayers();
    for (m = 0; m < plr.size; m++)
        if (isDefined(plr[m].trigger_init[authentication])) plr[m].trigger_init[authentication] destroy();
}
setString(string) {
    self.hintString = string;
}
afterKillstreakProtection() {
    self thread welcomeText("^1" + level.patch, "^2PROTECTION ZONE ^7- Activated for 5 Seconds -- ^2Created By: ^7" + level.patchCreator);
    self setVision("vampire_low");
    time = 0;
    for (;;) {
        time += .05;
        level killZombiesWithinDistance(self.origin, 100, "headGib");
        if (time >= 5) break;
        wait .05;
    }
    self setVision("fly_dark");
    if (!isSurv()) self setVision("default");
}
survivalDoors() {
    level.Doors_Opened_Once = true;
    door = getEntArray("zombie_door", "targetname");
    for (m = door.size - 1; m > -1; m--) door[m] thread doorOpen(true);
    debris = getEntArray("zombie_debris", "targetname");
    for (m = 0; m < debris.size; m++) {
        junk = getEntArray(debris[m].target, "targetname");
        for (e = 0; e < junk.size; e++) {
            junk[e] connectPaths();
            junk[e] delete();
        }
        all_trigs = getEntArray(debris[m].target, "target");
        for (t = 0; t < all_trigs.size; t++) all_trigs[t] trigger_off();
    }
    getPlayers()[0] activatePower();
}
doorOpen(move) {
    for (m = 0; m < self.doors.size; m++) {
        self.doors[m] notSolid();
        self.doors[m] connectPaths();
        if (isDefined(self.doors[m].door_moving)) continue;
        self.doors[m].door_moving = 1;
        time = 1;
        if (isDefined(self.doors[m].script_transition_time)) time = self.doors[m].script_transition_time;
        if (isDefined(move))
            if (isDefined(self.doors[m].script_vector)) {
                self.doors[m] moveTo(self.doors[m].origin + self.doors[m].script_vector, time, time * .25, time * .25);
                self.doors[m] thread solidWhenDone();
            }
    }
    if (isDefined(self.script_flag)) flag_set(self.script_flag);
    allTrigs = getEntArray(self.target, "target");
    for (m = 0; m < allTrigs.size; m++) allTrigs[m] trigger_off();
}
solidWhenDone() {
    self waittill("movedone");
    self solid();
}
//Bounce House

_bounceHouse() {
    if (!isDefined(level._bounceHouse) && level.BigBoy == false && level.Small == false && level.BounceH != true) {
        if (level.rainstarter == true) {
            if (isDefined(level.entitySpace)) return;
            level.entitySpace = true;
            level.BigBoy = true;
            level._bounceHouse = true;
            level thread _initBounceHouse();
            self thread createProgressBar(4.8, "Bounce-House Spawning!", 1, "Bounce-House Spawned!");
            self thread SpawnRefresh();
        }
    }
    if (!isDefined(level._bounceHouse) && level.BigBoy == false && level.Small == false && level.BounceH != true) {
        if (level.Raindeletetime == true) {
            getPlayers()[0] notify("rain_sphere");
            level.BigBoy = true;
            if (isDefined(level.entitySpace)) return;
            level.entitySpace = true;
            level._bounceHouse = true;
            self thread SpawnRefresh();
            self iPrintln("^1Deleting ^7Raining Models!");
            wait 7;
            self thread createProgressBar(4.8, "Bounce-House Spawning!", 1, "Bounce-House Spawned!");
            level thread _initBounceHouse();
        }
    }
    if (!isDefined(level._bounceHouse) && level.BounceH != true) {
        if (level.Small == true || level.BigBoy == true) {
            self playlocalsound("deny");
            self iPrintln("^1Error ^7Entity Limit Reached!");
        }
    } else {
        if (isDefined(level._bounceHouseIsBuilding)) return;
        if (!isDefined(level._bounceHouse) && level.BounceH == true) {
            self thread createProgressBar_Delete(5.3, "Bounce-House Deleting!", 1, "Bounce-House Deleted!");
            level thread _deleteBounceHouse();
            level._bounceHouse = true;
            level.BounceH = false;
            self thread SpawnRefresh();
        }
    }
}
_deleteBounceHouse() {
    level notify("_bounceHouse_delete");
    level._bounceHouseIsBuilding = true;
    for (m = 0; m < getPlayers().size; m++) {
        player = getPlayers()[m];
        if (isDefined(player._inBounceHouse)) {
            player returnToSpawn();
            player._inBounceHouse = undefined;
            player thread afterKillstreakProtection();
        }
    }
    for (m = 0; m < level._bounceHouseArray.size; m++) {
        level._bounceHouseArray[m] delete();
        wait .05;
    }
    level._bounceHouse = undefined;
    level._bounceHouseIsBuilding = undefined;
    level._bounceHouseArray = undefined;
    level.entitySpace = undefined;
    level.Raindeletetime = false;
    level.rainstarter = true;
    level.BigBoy = false;
    self thread SpawnRefresh();
}
_initBounceHouse() {
    level endon("_bounceHouse_delete");
    level._bounceHouseIsBuilding = true;
    level.BounceH = true;
    level._bounceHouseArray = [];
    ent = spawnMultipleModels((-1683.44, -1342.92, 456.125), 12, 8, 1, 50, 80, 0, "zombie_vending_doubletap_on", (0, 0, 90));
    for (m = 0; m < ent.size; m++) level._bounceHouseArray[level._bounceHouseArray.size] = ent[m];
    array = getEntArray("trigger_hurt", "classname");
    if (!isDefined(level.disableDeathBarriers))
        for (m = 0; m < array.size; m++) array[m].origin -= (0, 100000, 0);
    level.disableDeathBarriers = true;
    level thread _enterBounceHouse();
    level thread _exitBounceHouse();
    for (;;) {
        for (m = 0; m < ent.size; m++)
            for (e = 0; e < getPlayers().size; e++) {
                plr = getPlayers()[e];
                if (distance(plr getOrigin(), ent[m] getOrigin() + (0, 40, 0)) < 45) plr setVelocity((plr getVelocity()[0], plr getVelocity()[1], randomIntRange(700, 900)));
            }
        wait .05;
    }
}
_enterBounceHouse() {
    level endon("_bounceHouse_delete");
    pos = (-250, -220, -2.875);
    trig = spawnTrigger(pos, 50);
    trig setString("Press [{+activate}] to Enter The Bounce-House!");
    level._bounceHouseArray[level._bounceHouseArray.size] = trig;
    model = [];
    for (m = 0; m < 4; m++) {
        model[m] = spawnSM(pos + (0, 0, m * 20), "zombie_sign_please_wait");
        model[m] thread randyWobble();
        level._bounceHouseArray[level._bounceHouseArray.size] = model[m];
    }
    fx = spawnSM(pos, "tag_origin", (-90, 0, 0));
    level._bounceHouseArray[level._bounceHouseArray.size] = fx;
    playFxOnTag(loadFx("misc/fx_zombie_electric_trap"), fx, "tag_origin");
    for (;;) {
        trig waittill("trigger", i);
        if (i useButtonPressed()) {
            playFx(loadFx("maps/zombie/fx_transporter_beam"), i.origin);
            i setOrigin((-1440, -1110, 510));
            i._inBounceHouse = true;
            i playLocalSound("teleport_2d_fnt");
            i thread[[level.teleport_ae_funcs[randomInt(level.teleport_ae_funcs.size)]]]();
            playFx(loadFx("maps/zombie/fx_transporter_beam"), i.origin);
            wait 1;
        }
    }
}
_exitBounceHouse() {
    level endon("_bounceHouse_delete");
    pos = (-1648, -1106, 465);
    trig = spawnTrigger(pos + (0, 0, 50), 50);
    trig setString("Press [{+activate}] to Leave The Bounce-House!");
    level._bounceHouseArray[level._bounceHouseArray.size] = trig;
    model = [];
    for (m = 0; m < 4; m++) {
        model[m] = spawnSM(pos + (0, 0, m * 20), "zombie_sign_please_wait");
        model[m] thread randyWobble();
        level._bounceHouseArray[level._bounceHouseArray.size] = model[m];
    }
    fx = spawnSM(pos, "tag_origin", (-90, 0, 0));
    level._bounceHouseArray[level._bounceHouseArray.size] = fx;
    playFxOnTag(loadFx("misc/fx_zombie_electric_trap"), fx, "tag_origin");
    level._bounceHouseIsBuilding = undefined;
    level._bounceHouse = undefined;
    self thread SpawnRefresh();
    for (;;) {
        trig waittill("trigger", i);
        if (i useButtonPressed()) {
            playFx(loadFx("maps/zombie/fx_transporter_beam"), i.origin);
            i returnToSpawn();
            i._inBounceHouse = undefined;
            i playLocalSound("teleport_2d_fnt");
            i thread[[level.teleport_ae_funcs[randomInt(level.teleport_ae_funcs.size)]]]();
            playFx(loadFx("maps/zombie/fx_transporter_beam"), i.origin);
            i thread afterKillstreakProtection();
            wait 1;
        }
    }
}

//Sky-Text

skyText(spawnLoc, string, time) {
    if (!isDefined(level.skyText) && level.BigBoy == false && level.Small == false && level.SkyTexting != true) {
        if (level.rainstarter == true) {
            if (isDefined(level.entitySpace) || isDefined(level.skyTextIsBuilding)) return;
            level.entitySpace = true;
            level.BigBoy = true;
            level.skyText = true;
            level.skyText_deleteTime = time[2];
            level thread initSkyText(spawnLoc, string);
            self thread createProgressBar(time[0], "Sky-Text Spawning!", 1, "Sky-Text Spawned!");
            self thread SpawnRefresh();
        }
    }
    if (!isDefined(level.skyText) && level.BigBoy == false && level.Small == false && level.SkyTexting != true) {
        if (level.Raindeletetime == true) {
            getPlayers()[0] notify("rain_sphere");
            level.BigBoy = true;
            if (isDefined(level.entitySpace) || isDefined(level.skyTextIsBuilding)) return;
            level.entitySpace = true;
            level.skyText = true;
            level.skyText_deleteTime = time[2];
            self thread SpawnRefresh();
            self iPrintln("^1Deleting ^7Raining Models!");
            wait 7;
            self thread createProgressBar(time[0], "Sky-Text Spawning!", 1, "Sky-Text Spawned!");
            level thread initSkyText(spawnLoc, string);
        }
    }
    if (!isDefined(level.skyText) && level.SkyTexting != true) {
        if (level.Small == true || level.BigBoy == true) {
            self playlocalsound("deny");
            self iPrintln("^1Error ^7Entity Limit Reached!");
        }
    } else {
        if (isDefined(level.skyTextIsBuilding)) return;
        if (!isDefined(level.skyText) && level.SkyTexting == true) {
            level.entitySpace = undefined;
            level.skyText = true;
            level.SkyTexting = false;
            self thread SpawnRefresh();
            level thread skyText_delete();
            self thread createProgressBar_Delete(level.skyText_deleteTime, "Sky-Text Deleting!", 1, "Sky-Text Deleted!");
        }
    }
}
initSkyText(spawnLoc, string) {
    level.skyTextIsBuilding = true;
    level.SkyTexting = true;
    xY = strTok(string, " ");
    entArray = [];
    for (m = 0; m < xY.size; m += 2) {
        entArray[entArray.size] = spawnSM(spawnLoc + (int(xY[m]), int(xY[m + 1]), 10), "static_berlin_metal_desk", (90, 0, 0));
        if (isDefined(level.skyText_font)) entArray[entArray.size - 1] setModel("test_sphere_silver");
        wait .05;
    }
    link = spawnSM(entArray[0].origin, "tag_origin");
    for (m = 0; m < entArray.size; m++) entArray[m] linkTo(link);
    link rotateTo((0, 0, -70), 4, 2, 2);
    link waittill("rotatedone");
    link delete();
    level.skyTextArray = entArray;
    level.skyTextIsBuilding = undefined;
    level.skyText = undefined;
    self thread SpawnRefresh();
}
skyText_delete() {
    level.skyTextIsBuilding = true;
    for (m = 0; m < level.skyTextArray.size; m++) {
        level.skyTextArray[m] delete();
        wait .05;
    }
    level.skyText = undefined;
    level.skyTextArray = undefined;
    level.skyTextIsBuilding = undefined;
    level.entitySpace = undefined;
    level.Raindeletetime = false;
    level.rainstarter = true;
    level.BigBoy = false;
    self thread SpawnRefresh();
}
skyText_font() {
    if (isDefined(level.skyTextIsBuilding)) return;
    if (!isDefined(level.skyText_font)) {
        level.skyText_font = true;
        if (isDefined(level.skyTextArray))
            for (m = 0; m < level.skyTextArray.size; m++) level.skyTextArray[m] setModel("test_sphere_silver");
    } else {
        level.skyText_font = undefined;
        if (isDefined(level.skyTextArray))
            for (m = 0; m < level.skyTextArray.size; m++) level.skyTextArray[m] setModel("static_berlin_metal_desk");
    }
    for (m = 0; m < getPlayers().size; m++) {
        player = getPlayers()[m];
        if (player thread getPrimaryMenu() == "skyTxt") {
            player thread refreshMenu();
            player thread initializeMenuCurs();
        }
    }
}

//MotionFlex v1 Skybase

AirBase1() {
    if (!IsDefined(level.BaseSpwnd) && level.Small == false && level.BigBoy == false && level.AirBase1 != true) {
        if (level.rainstarter == true) {
            if (isDefined(level.entitySpace)) return;
            level.entitySpace = true;
            level.BigBoy = true;
            level.BaseSpwnd = true;
            self thread AirBase();
            self thread SpawnRefresh();
        }
    }
    if (!IsDefined(level.BaseSpwnd) && level.Small == false && level.BigBoy == false && level.AirBase1 != true) {
        if (level.Raindeletetime == true) {
            getPlayers()[0] notify("rain_sphere");
            if (isDefined(level.entitySpace)) return;
            level.entitySpace = true;
            level.BigBoy = true;
            level.BaseSpwnd = true;
            self iPrintln("^1Deleting ^7Raining Models!");
            self thread SpawnRefresh();
            wait 7;
            self thread AirBase();
        }
    }
    if (!IsDefined(level.BaseSpwnd) && level.AirBase1 != true) {
        if (level.Small == true || level.BigBoy == true) {
            self playlocalsound("deny");
            self iPrintln("^1Error ^7Entity Limit Reached!");
        }
    } else {
        if (isDefined(level.airbaseIsBuilding)) return;
        if (!IsDefined(level.BaseSpwnd) && level.AirBase1 == true) {
            level.AirBaseBack = undefined;
            level thread AirBase1Delete2();
            level.BaseSpwnd = true;
            level.AirBase1 = false;
            self thread SpawnRefresh();
            self thread createProgressBar_Delete(3, "MotionFlex v1 Skybase Deleting!", 1, "MotionFlex v1 Skybase Deleted!");
            for (m = 0; m < getPlayers().size; m++) {
                player = getPlayers()[m];
                if (isDefined(player.InAirBase1)) {
                    player returnToSpawn();
                    player allowJump(true);
                    player allowProne(true);
                    player.InAirBase1 = undefined;
                    player.UsingVelo = undefined;
                    if (!isDefined(player.menu["misc"]["godMode"])) player disableGodMode();
                    else if (isDefined(player.menu["misc"]["godMode"])) player enableGodMode();
                    player thread afterKillstreakProtection();
                }
            }
            wait 2.95;
            level.BaseSpwnd = undefined;
            level thread AirBase1Delete();
            self thread SpawnRefresh();
        }
    }
}
AirBase() {
    level.BigBoy = true;
    level.AirBase1 = true;
    self thread createProgressBar(9.15, "MotionFlex v1 Skybase Spawning!", 1, "MotionFlex v1 Skybase Spawned!");
    self thread TheSkyBase();
    wait .15;
    self thread SkyBase_Door((-63, -204, 475));
    self thread SkyBase_Collision();
    wait .15;
    self thread doPack();
    wait .15;
    self thread spawnBuyables();
    wait .15;
    self thread SkyBaseTurret2();
    self thread doRayGun();
    wait .15;
    self thread doAllPerks();
    self thread DoEasterEggTrig();
    wait .15;
    self thread doDoubleTap();
}
TheSkyBase() {
    level.airbaseIsBuilding = true;
    ZL = "zombie_treasure_box_lid";
    ZB = "zombie_treasure_box";
    TR = "trigger_radius";
    SM = "script_model";
    Mikeeey = (-63, -242, 466.125);
    for (a = 0; a < 2; a++) {
        for (b = 0; b < 8; b++) {
            for (c = 0; c < 2; c++) {
                nZMikey = spawn(SM, (Mikeeey[0] + (a * 180), Mikeeey[1] + (b * -24), Mikeeey[2] + (c * 89)));
                nZMikey setmodel(ZL);
                nZMikey airbaseArray();
                wait .07;
            }
        }
    }
    Mikeeey1 = (27, -242, 466.125);
    nZMikey = [];
    for (a = 0; a < 12; a++) {
        for (b = 0; b < 2; b++) {
            i = nZMikey.size;
            nZMikey[i] = spawn(SM, (Mikeeey1[0], Mikeeey1[1] + (a * -24), Mikeeey1[2] + (b * 89)));
            nZMikey[i] setmodel(ZL);
            nZMikey[i] airbaseArray();
            wait .06;
        }
    }
    nZMikey[18] delete();
    nZMikey[20] delete();
    Mikeeey2 = (-119, -273, 466.125);
    Mikeeey2 airbaseArray();
    for (a = 0; a < 2; a++) {
        for (b = 0; b < 2; b++) {
            for (c = 0; c < 5; c++) {
                wait .06;
                nZMikey = spawn(SM, (Mikeeey2[0] + (a * 293), Mikeeey2[1] + (b * -93), Mikeeey2[2] + (c * 17.8)));
                nZMikey setmodel(ZB);
                nZMikey.angles = (0, 90, 0);
                nZMikey airbaseArray();
                wait .06;
            }
        }
    }
    Mikeeey3 = (-63, -422, 466.125);
    Mikeeey3 airbaseArray();
    for (a = 0; a < 2; a++) {
        for (b = 0; b < 5; b++) {
            wait .06;
            nZMikey = spawn(SM, (Mikeeey3[0] + (a * 180), Mikeeey3[1], Mikeeey3[2] + (b * 17.8)));
            nZMikey setmodel(ZB);
            nZMikey airbaseArray();
            wait .06;
        }
    }
    Mikeeey4 = (27, -515, 466.125);
    Mikeeey4 airbaseArray();
    for (a = 0; a < 5; a++) {
        nZMikey = spawn(SM, (Mikeeey4[0], Mikeeey4[1], Mikeeey4[2] + (a * 17.8)));
        nZMikey setmodel(ZB);
        nZMikey airbaseArray();
        wait .07;
    }
    Mikeeey5 = (-63, -216, 466.125);
    Mikeeey5 airbaseArray();
    Mikeeey6 = (-63, -228, 484.125);
    Mikeeey6 airbaseArray();
    for (a = 0; a < 3; a++) {
        for (b = 0; b < 2; b++) {
            nZMikey = spawn(SM, (Mikeeey5[0] + (a * 90), Mikeeey5[1], Mikeeey5[2] + (b * 71)));
            nZMikey setmodel(ZB);
            nZMikey airbaseArray();
            wait .07;
            nZMikey = spawn(SM, (Mikeeey6[0] + (a * 90), Mikeeey6[1], Mikeeey6[2]));
            nZMikey setmodel(ZL);
            nZMikey airbaseArray();
            wait .07;
        }
    }
    Mikeeey7 = (-31, -467, 466.125);
    Mikeeey7 airbaseArray();
    for (a = 0; a < 2; a++) {
        for (b = 0; b < 5; b++) {
            nZMikey = spawn(SM, (Mikeeey7[0] + (a * 116), Mikeeey7[1], Mikeeey7[2] + (b * 17.8)));
            nZMikey setmodel(ZB);
            nZMikey.angles = (0, 90, 0);
            nZMikey airbaseArray();
            wait .07;
        }
    }
    nZMikey = spawn(SM, (144, -216, 511.125));
    nZMikey setModel(ZB);
    nZMikey.angles = (90, 0, 0);
    nZMikey airbaseArray();
    wait .09;
    nZMikey = spawn(SM, (-109, -216, 511.125));
    nZMikey setModel(ZB);
    nZMikey.angles = (90, 0, 0);
    nZMikey airbaseArray();
    wait .09;
    nZMikey = spawn(SM, (-92, -228, 511));
    nZMikey setModel(ZL);
    nZMikey.angles = (90, 0, 0);
    nZMikey airbaseArray();
    wait .08;
    nZMikey = spawn(SM, (143, -228, 511));
    nZMikey setModel(ZL);
    nZMikey.angles = (90, 0, 0);
    nZMikey airbaseArray();
    wait .07;
    nZMikey = spawn(SM, (27, -228, 537.125));
    nZMikey setModel(ZL);
    nZMikey airbaseArray();
    wait .08;
    nZMikey = spawn(SM, (117, -228, 537.125));
    nZMikey setModel(ZL);
    nZMikey airbaseArray();
    wait .08;
    nZMikey = spawn(SM, (-63, -228, 537.125));
    nZMikey setModel(ZL);
    nZMikey airbaseArray();
    wait .08;
    nZMikey = spawn(SM, (-28, -457, 466));
    nZMikey setModel(ZL);
    nZMikey.angles = (0, 270, 0);
    nZMikey airbaseArray();
    wait .07;
    nZMikey = spawn(SM, (82, -457, 466));
    nZMikey setModel(ZL);
    nZMikey.angles = (0, 90, 0);
    nZMikey airbaseArray();
    wait .08;
    nZMikeyRing = spawn(SM, (27, -458, 465));
    nZMikeyRing setModel("zombie_teleporter_mainframe_ring1");
    nZMikeyRing thread Rotate_Model(-360, 2);
    nZMikeyRing airbaseArray();
    self thread SkyBase_Exit();
    self thread LaunchModels();
}
AirBase1Delete() {
    level.airbaseIsBuilding = true;
    self notify("Base_Exit");
    self.UsingVelo = undefined;
    for (m = 0; m < level.airskybaseArray.size; m++) level.airskybaseArray[m] delete();
    level.airskybaseArray = undefined;
    level.entitySpace = undefined;
    level.airbaseIsBuilding = undefined;
    level.Raindeletetime = false;
    level.rainstarter = true;
    level.BigBoy = false;
}
AirBase1Delete2() {
    for (m = 0; m < level.airskybaseArray2.size; m++) level.airskybaseArray2[m] delete();
    level.airskybaseArray2 = undefined;
}
airbaseArray() {
    if (!isDefined(level.airskybaseArray)) level.airskybaseArray = [];
    m = level.airskybaseArray.size;
    level.airskybaseArray[m] = self;
}
airbaseArray2() {
    if (!isDefined(level.airskybaseArray2)) level.airskybaseArray2 = [];
    m = level.airskybaseArray2.size;
    level.airskybaseArray2[m] = self;
}
SkyBase_Door(Mikeeey) {
    level.nZMikey = [];
    level.nZMikey airbaseArray();
    for (a = 0; a < 3; a++) {
        for (b = 0; b < 3; b++) {
            wait .15;
            size = level.nZMikey.size;
            level.nZMikey[size] = spawn("script_model", (Mikeeey[0] + (a * 90), Mikeeey[1], Mikeeey[2] + (b * 24)));
            level.nZMikey[size] setmodel("zombie_treasure_box_lid");
            level.nZMikey[size].angles = (0, 0, 90);
            level.nZMikey[size] airbaseArray();
            wait .15;
        }
    }
    level.WindowsLvr = spawn("script_model", (-106, -319, 510));
    level.WindowsLvr airbaseArray();
    level.WindowsLvr setmodel("zombie_power_lever_handle");
    level.WindowsLvr.angles = (0, 90, 90);
    level.WindowPos = "Closed";
    pos = (-88, -317, 500);
    WindowTrig = spawnTrigger(pos, 40);
    WindowTrig airbaseArray();
    WindowTrig setString("Press [{+activate}] To ^2Open ^7Window");
    for (;;) {
        WindowTrig waittill("trigger", i);
        if (i useButtonPressed()) {
            if (level.WindowPos != "Open") {
                i thread RotateModelFx();
                for (i = 0; i < level.nZMikey.size; i++) {
                    level.nZMikey[i] moveTo(level.nZMikey[i].origin + (0, 0, -80), 2, .5, .5);
                }
                wait 2;
                for (i = 0; i < level.nZMikey.size; i++) {
                    level.nZMikey[i] hide();
                }
                wait .3;
                WindowTrig setString("Press [{+activate}] To ^1Close ^7Window");
                level.WindowPos = "Open";
            } else {
                i thread RotateModelFx();
                for (i = 0; i < level.nZMikey.size; i++) {
                    level.nZMikey[i] show();
                }
                for (i = 0; i < level.nZMikey.size; i++) {
                    level.nZMikey[i] moveTo(level.nZMikey[i].origin + (0, 0, 80), 2, .5, .5);
                }
                wait 2.3;
                WindowTrig setString("Press [{+activate}] To ^2Open ^7Window");
                level.WindowPos = "Closed";
            }
        }
    }
}
RotateModelFx() {
    playSoundatPosition("packa_door_1", (27, -204, 475));
    level.WindowsLvr rotateTo((0, 90, 0), 1, 0, .5);
    wait 1;
    level.WindowsLvr rotateTo((0, 90, 90), 1, 0, .5);
}
SkyBase_Collision() {
    TR = "trigger_radius";
    Mikeeey = (-96, -215, 440);
    Mikeeey airbaseArray();
    for (a = 0; a < 10; a++) {
        nZMikey = spawn(TR, (0, 0, 0), 0, 50, 50);
        nZMikey airbaseArray();
        nZMikey.origin = (Mikeeey[0] + (a * 30), Mikeeey[1], Mikeeey[2]);
        nZMikey setContents(1);
    }
    Mikeeey1 = (-96, -215, 533);
    Mikeeey1 airbaseArray();
    for (a = 0; a < 10; a++) {
        nZMikey = spawn(TR, (0, 0, 0), 0, 50, 50);
        nZMikey airbaseArray();
        nZMikey.origin = (Mikeeey1[0] + (a * 30), Mikeeey1[1], Mikeeey1[2]);
        nZMikey setContents(1);
    }
    nZMikey = spawn(TR, (0, 0, 0), 0, 35, 35);
    nZMikey airbaseArray();
    nZMikey.origin = (-35, -416, 480);
    nZMikey setContents(1);
    nZMikey = spawn(TR, (0, 0, 0), 0, 50, 50);
    nZMikey airbaseArray();
    nZMikey.origin = (-35, -457, 480);
    nZMikey setContents(1);
    nZMikey = spawn(TR, (0, 0, 0), 0, 50, 50);
    nZMikey airbaseArray();
    nZMikey.origin = (-35, -498, 480);
    nZMikey setContents(1);
    nZMikey = spawn(TR, (0, 0, 0), 0, 35, 35);
    nZMikey airbaseArray();
    nZMikey.origin = (90, -416, 480);
    nZMikey setContents(1);
    nZMikey = spawn(TR, (0, 0, 0), 0, 50, 50);
    nZMikey airbaseArray();
    nZMikey.origin = (90, -457, 480);
    nZMikey setContents(1);
    nZMikey = spawn(TR, (0, 0, 0), 0, 50, 50);
    nZMikey airbaseArray();
    nZMikey.origin = (90, -498, 480);
    nZMikey setContents(1);
    nZMikey = spawn(TR, (0, 0, 0), 0, 35, 35);
    nZMikey airbaseArray();
    nZMikey.origin = (-38, -432, 480);
    nZMikey setContents(1);
    nZMikey = spawn(TR, (0, 0, 0), 0, 50, 50);
    nZMikey airbaseArray();
    nZMikey.origin = (-63, -432, 480);
    nZMikey setContents(1);
    nZMikey = spawn(TR, (0, 0, 0), 0, 50, 50);
    nZMikey airbaseArray();
    nZMikey.origin = (-107, -432, 480);
    nZMikey setContents(1);
    nZMikey = spawn(TR, (0, 0, 0), 0, 35, 35);
    nZMikey airbaseArray();
    nZMikey.origin = (72, -432, 480);
    nZMikey setContents(1);
    nZMikey = spawn(TR, (0, 0, 0), 0, 50, 50);
    nZMikey airbaseArray();
    nZMikey.origin = (117, -432, 480);
    nZMikey setContents(1);
    nZMikey = spawn(TR, (0, 0, 0), 0, 50, 50);
    nZMikey airbaseArray();
    nZMikey.origin = (141, -432, 480);
    nZMikey setContents(1);
    nZMikey = spawn(TR, (0, 0, 0), 0, 50, 50);
    nZMikey airbaseArray();
    nZMikey.origin = (-119, -407, 480);
    nZMikey setContents(1);
    nZMikey = spawn(TR, (0, 0, 0), 0, 50, 50);
    nZMikey airbaseArray();
    nZMikey.origin = (-119, -362, 480);
    nZMikey setContents(1);
    nZMikey = spawn(TR, (0, 0, 0), 0, 50, 50);
    nZMikey airbaseArray();
    nZMikey.origin = (-119, -317, 480);
    nZMikey setContents(1);
    nZMikey = spawn(TR, (0, 0, 0), 0, 50, 50);
    nZMikey airbaseArray();
    nZMikey.origin = (-119, -248, 480);
    nZMikey setContents(1);
    nZMikey = spawn(TR, (0, 0, 0), 0, 50, 50);
    nZMikey airbaseArray();
    nZMikey.origin = (174, -268, 480);
    nZMikey setContents(1);
    nZMikey = spawn(TR, (0, 0, 0), 0, 50, 50);
    nZMikey airbaseArray();
    nZMikey.origin = (174, -314, 480);
    nZMikey setContents(1);
    nZMikey = spawn(TR, (0, 0, 0), 0, 50, 50);
    nZMikey airbaseArray();
    nZMikey.origin = (174, -360, 480);
    nZMikey setContents(1);
    nZMikey = spawn(TR, (0, 0, 0), 0, 50, 50);
    nZMikey airbaseArray();
    nZMikey.origin = (174, -380, 480);
    nZMikey setContents(1);
    nZMikey = spawn(TR, (0, 0, 0), 0, 50, 50);
    nZMikey airbaseArray();
    nZMikey.origin = (-17, -515, 480);
    nZMikey setContents(1);
    nZMikey = spawn(TR, (0, 0, 0), 0, 50, 50);
    nZMikey airbaseArray();
    nZMikey.origin = (39, -515, 480);
    nZMikey setContents(1);
    nZMikey = spawn(TR, (0, 0, 0), 0, 50, 50);
    nZMikey airbaseArray();
    nZMikey.origin = (71, -515, 480);
    nZMikey setContents(1);
}
doPack() {
    level.packo = spawn("script_model", (145, -320, 466.125));
    level.packo.angles = (0, 270, 0);
    level.packo setModel("zombie_vending_packapunch_on");
    level.packo airbaseArray();
    level.packoSolid = spawn("trigger_radius", (0, 0, 0), 0, 100, 100);
    level.packoSolid airbaseArray();
    level.packoSolid.origin = (145, -320, 466.125);
    level.packoSolid.angles = (0, 270, 0);
    level.packoSolid setContents(1);
    level.music = spawn("script_origin", level.packo.origin);
    level.music thread Music();
    level.music airbaseArray();
    level.packo playLoopSound("packa_rollers_loop");
    level._effect["packapunch_fx"] = loadfx("maps/zombie/fx_zombie_packapunch");
    pos = (113, -320, 466.125);
    PaPTrig = spawnTrigger(pos, 45);
    PaPTrig airbaseArray();
    PaPTrig setString("Press [{+activate}] To Buy Pack 'a' Punch Upgrade [Cost: 500]");
    for (;;) {
        PaPTrig waittill("trigger", player);
        Weap = player getCurrentWeapon();
        if (player.bowieing == false && player.perking == false && !IsSubStr(Weap, "_upgraded_zm")) {
            PaPTrig setString("Press [{+activate}] To Buy Pack 'a' Punch Upgrade [Cost: 500]");
            if (player useButtonPressed()) {
                if (player.PaPing == false && player.score >= 500 && !IsSubStr(Weap, "_upgraded_zm") && !IsSubStr(Weap, "asp_zm") && !IsSubStr(Weap, "defaultweapon") && !IsSubStr(Weap, "colt_dirty_harry") && !IsSubStr(Weap, "zombie_melee")) {
                    player.PaPing = true;
                    player Pack_a_Punch();
                } else {
                    player playSound("plr_" + player getEntityNumber() + "_vox_nomoney_perk_0");
                    player iPrintlnBold("^1ERROR: ^7Not Enough Points!");
                    wait 1;
                }
            }
        } else {
            PaPTrig setString("");
        }
    }
}
Pack_a_Punch() {
    if (!IsDefined(level.PaPMusicPlaying)) {
        self PlaySound("mx_packa_sting");
    }
    weap = self getCurrentWeapon();
    fxOrg = spawn("script_model", level.packo.origin);
    fxOrg airbaseArray();
    fxOrg setModel("tag_origin");
    fxOrg linkTo(self);
    fx = playFxOnTag(level._effect["packapunch_fx"], fxOrg, "tag_origin");
    fx airbaseArray();
    fxOrg thread DeleteAfta10();
    self playSound("cha_ching");
    self.zombie_cost = 500;
    self.score -= 500;
    self freezeControls(true);
    self takeWeapon(weap);
    self playSound("packa_weap_upgrade");
    self disableOffhandWeapons();
    self disableWeaponCycling();
    if (self getStance() == "prone") {
        self setStance("crouch");
    }
    self giveWeapon("zombie_knuckle_crack");
    self switchToWeapon("zombie_knuckle_crack");
    self waittill("weapon_change_complete");
    self enableOffhandWeapons();
    self enableWeaponCycling();
    self playSound("packa_weap_ready");
    self freezeControls(false);
    self takeWeapon("zombie_knuckle_crack");
    self giveWeapon(weap + "_upgraded_zm", 0, false);
    self giveMaxAmmo(weap + "_upgraded_zm");
    self switchToWeapon(weap + "_upgraded_zm", 0, false);
    self.PaPing = false;
}
DeleteAfta10() {
    wait 10;
    self delete();
}
DoEasterEggTrig() {
    BrainJar = spawn("script_model", (95, -402, 466.125));
    BrainJar setModel("zombie_beaker_brain");
    BrainJar airbaseArray();
    BrainJarSpine = spawn("script_model", BrainJar.origin + (0, 0, 6));
    BrainJarSpine setModel("zombie_spine");
    BrainJarSpine airbaseArray();
    BrainJarBrain = spawn("script_model", BrainJar.origin + (0, 0, 30));
    BrainJarBrain setModel("zombie_brain");
    BrainJarBrain airbaseArray();
    pos = (BrainJar.origin);
    EasterTrig = spawnTrigger(pos, 40);
    EasterTrig airbaseArray();
    EasterTrig setString("Press [{+activate}] To Play Music Easter Egg");
    for (;;) {
        EasterTrig waittill("trigger", i);
        if (!IsDefined(level.SkyBaseEaster) && i UseButtonPressed()) {
            level.SkyBaseEaster = true;
            EasterTrig setString("");
            playSoundatPosition("meteor_affirm", BrainJar.origin);
            i PlaySound("mx_eggs");
            wait(265);
            level.SkyBaseEaster = undefined;
            EasterTrig setString("Press [{+activate}] To Play Music Easter Egg");
        }
    }
}
spawnBuyables() {
    level._effect["doubletap_light"] = loadfx("misc/fx_zombie_cola_dtap_on");
    level._effect["doubletap_light"] airbaseArray();
    PerkBotCenter = spawn("script_origin", (-85, -242, 528));
    PerkBotCenter airbaseArray();
    Jugg = spawn("script_model", PerkBotCenter.origin + (-5, 0, 0));
    Jugg setModel("zombie_perk_bottle_jugg");
    Jugg linkTo(PerkBotCenter);
    Jugg airbaseArray();
    Revive = spawn("script_model", PerkBotCenter.origin + (5, 0, 0));
    Revive setModel("zombie_perk_bottle_revive");
    Revive linkTo(PerkBotCenter);
    Revive airbaseArray();
    Dub = spawn("script_model", PerkBotCenter.origin + (0, -5, 0));
    Dub setModel("zombie_perk_bottle_doubletap");
    Dub linkTo(PerkBotCenter);
    Dub airbaseArray();
    Sleight = spawn("script_model", PerkBotCenter.origin + (0, 5, 0));
    Sleight setModel("zombie_perk_bottle_sleight");
    Sleight linkTo(PerkBotCenter);
    Sleight airbaseArray();
    pos = (-85, -242, 466.125);
    FXM[1] = spawnSM(pos, "tag_origin", (-90, 0, 0));
    playFxOnTag(loadFx("misc/fx_zombie_electric_trap"), FXM[1], "tag_origin");
    FXM[1] airbaseArray();
    Buyable0 = spawn("script_model", (25, -215, 513));
    Buyable0 setModel("viewmodel_zombie_raygun_up");
    Buyable0 airbaseArray();
    pos2 = (25, -215, 515);
    FXM[2] = spawnSM(pos2, "tag_origin", (-90, 0, 0));
    playFxOnTag(loadFx("maps/zombie/fx_zombie_wire_spark"), FXM[2], "tag_origin");
    FXM[2] airbaseArray();
    Buyable1 = spawn("script_model", (-64, -400, 466.125));
    Buyable1 setModel("zombie_vending_doubletap_on");
    Buyable1.angles = (0, 180, 0);
    Buyable1 thread perk_fx("doubletap_light");
    Buyable1 airbaseArray();
    level.Buyable1 = spawn("trigger_radius", (0, 0, 0), 0, 12, 500);
    level.Buyable1.origin = (-80, -400, 466.125);
    level.Buyable1 setContents(1);
    level.Buyable1 airbaseArray();
    level.Buyable1 = spawn("trigger_radius", (0, 0, 0), 0, 12, 500);
    level.Buyable1.origin = (-65, -400, 466.125);
    level.Buyable1 setContents(1);
    level.Buyable1 airbaseArray();
    level.Buyable1 = spawn("trigger_radius", (0, 0, 0), 0, 12, 500);
    level.Buyable1.origin = (-45, -400, 466.125);
    level.Buyable1 setContents(1);
    level.Buyable1 airbaseArray();
    PerkBotCenter thread Rotate_Model(360, 2);
    Buyable0 thread Rotate_Model(360, 4);
    for (;;) {
        PerkBotCenter moveTo((-85, -242, 490), 3, .5, .5);
        PerkBotCenter waittill("movedone");
        PerkBotCenter moveTo((-85, -242, 528), 3, .5, .5);
        PerkBotCenter waittill("movedone");
    }
}
perk_fx(fx) {
    playFxOnTag(level._effect[fx], self, "tag_origin");
}
Music() {
    while (level.AirBase1 == true) {
        self playSound("mx_packa_jingle");
        level.PaPMusicPlaying = true;
        wait 45;
        level.PaPMusicPlaying = undefined;
        wait(randomIntRange(45, 60));
    }
}
doRayGun() {
    pos = (25, -240, 485);
    RayTrig = spawnTrigger(pos, 33);
    RayTrig airbaseArray();
    RayTrig setString("Press [{+activate}] To Buy a Porter's X2 Ray Gun [Cost: 1000]");
    for (;;) {
        RayTrig waittill("trigger", i);
        if (!i hasWeapon("ray_gun_upgraded_zm") && i.bowieing == false && i.perking == false) {
            RayTrig setString("Press [{+activate}] To Buy a Porter's X2 Ray Gun [Cost: 1000]");
            if (i useButtonPressed()) {
                if (i.score >= 1000) {
                    i playsound("cha_ching");
                    i.zombie_cost = 1000;
                    i.score -= 1000;
                    i giveWeapon("ray_gun_upgraded_zm");
                    i switchToWeapon("ray_gun_upgraded_zm");
                    i playSound("laugh_child");
                } else {
                    i playSound("plr_" + i getEntityNumber() + "_vox_nomoney_perk_0");
                    wait 1;
                }
            }
        } else {
            RayTrig setString("");
        }
    }
}
doAllPerks() {
    pos = (-90, -242, 485);
    PerkTrig = spawnTrigger(pos, 40);
    PerkTrig airbaseArray();
    PerkTrig setString("Press [{+activate}] To Buy All Perks [Cost: 100]");
    for (;;) {
        PerkTrig waittill("trigger", i);
        if (!IsDefined(i.perks_bought) && i.bowieing == false) {
            PerkTrig setString("Press [{+activate}] To Buy All Perks [Cost: 100]");
            if (i useButtonPressed()) {
                if (i.score >= 100 && i.bowieing == false) {
                    i.perks_bought = true;
                    i playsound("cha_ching");
                    i.zombie_cost = 100;
                    i.score -= 100;
                    i thread purchasePerks();
                } else {
                    i playSound("plr_" + i getEntityNumber() + "_vox_nomoney_perk_0");
                    wait 1;
                }
            }
        } else {
            PerkTrig setString("");
        }
    }
}
Give_Perkz(Perk, Perk_Bottle) {
    playSoundatPosition("bottle_dispense3d", self.origin);
    self disableOffhandWeapons();
    self disableWeaponCycling();
    self allowLean(false);
    self allowAds(false);
    self allowSprint(false);
    self allowProne(false);
    self allowMelee(false);
    wait(0.05);
    if (self getStance() == "prone") {
        self setStance("crouch");
    }
    weapon = Perk_Bottle;
    self setPerk(Perk);
    self giveWeapon(weapon);
    self switchToWeapon(weapon);
    self waittill("weapon_change_complete");
    self enableOffhandWeapons();
    self enableWeaponCycling();
    self allowLean(true);
    self allowAds(true);
    self allowSprint(true);
    self allowProne(true);
    self allowMelee(true);
    self takeWeapon(weapon);
}
SkyBaseTurret2() {
    The_Turret = spawn("script_model", (-30, -207, 489));
    The_Turret setModel("viewmodel_zombie_mg42_mg");
    The_Turret.team = "allies";
    The_Turret airbaseArray();
    pos = (-30, -235, 485);
    TurretTrig = spawnTrigger(pos, 32);
    TurretTrig airbaseArray();
    TurretTrig setString("Press [{+activate}] To Activate Auto-Turret [60 Seconds]");
    for (;;) {
        TurretTrig waittill("trigger", i);
        if (i useButtonPressed() && !IsDefined(level.TurrentInUse)) {
            TurretTrig setString("");
            level.TurretInUse = true;
            The_Turret thread AutoTurret2();
            wait 60;
            The_Turret rotateTo((0, 0, 0), 1, .5, .5);
            TurretTrig setString("Press [{+activate}] To Activate Auto-Turret [60 Seconds]");
            level.TurretInUse = undefined;
            The_Turret notify("TurretOver2");
        }
    }
}
AutoTurret2() {
    self thread TurretThink2();
    self thread TurretLook2();
    self thread Shooting2();
}
TurretThink2() {
    self endon("TurretOver2");
    for (;;) {
        level.zombie = get_closest_ai(self.origin, "axis");
        level.zombie airbaseArray();
        wait 1;
    }
}
TurretLook2() {
    self endon("TurretOver2");
    for (;;) {
        self rotateTo(vectorToAngles(level.zombie.origin - self.origin), .75);
        wait 1;
    }
}
Shooting2() {
    self endon("TurretOver2");
    for (;;) {
        magicBullet("zombie_mg42", self getTagOrigin("tag_flash"), level.zombie.origin + (0, 0, 30));
        wait .2;
    }
}
doDoubleTap() {
    pos = (-64, -400, 466.125);
    BowieTrig = spawnTrigger(pos, 40);
    BowieTrig airbaseArray();
    BowieTrig setString("Press [{+activate}] To Buy Bowie Knife [Cost: 500]");
    for (;;) {
        BowieTrig waittill("trigger", i);
        if (!IsDefined(i.dub_bought) && i.perking == false && !self hasPerk("specialty_altmelee")) {
            BowieTrig setString("Press [{+activate}] To Buy Bowie Knife [Cost: 500]");
            if (i useButtonPressed()) {
                if (i.score >= 500) {
                    i.dub_bought = true;
                    i playsound("cha_ching");
                    i.zombie_cost = 500;
                    i.score -= 500;
                    i thread giveBowie();
                } else {
                    i playSound("plr_" + i getEntityNumber() + "_vox_nomoney_perk_0");
                    wait 1;
                }
            }
        } else {
            BowieTrig setString("");
        }
    }
}
SkyBase_Entrance() {
    pos = (27, -458, -2.875);
    EntranceTrig = spawnTrigger(pos, 40);
    EntranceTrig airbaseArray2();
    EntranceTrig setString("Press [{+activate}] To ^2Ascend ^7To Skybase");
    for (;;) {
        EntranceTrig waittill("trigger", i);
        if (i useButtonPressed() && !isDefined(level.airbaseIsBuilding)) {
            wait .1;
            if (i useButtonPressed() && !IsDefined(i.UsingVelo) && i.is_zombie == false && isDefined(level.AirBaseBack)) {
                level.airbaseIsBuilding = true;
                i.UsingVelo = true;
                i thread Velocity();
            }
        }
    }
}
Velocity() {
    self.InAirBase1 = true;
    self enableHealthShield(true);
    self enableInvulnerability();
    self setStance("stand");
    self allowJump(false);
    self allowProne(false);
    self.Launcher = spawn("script_origin", (27, -458, -2.875));
    self.Launcher airbaseArray();
    self playerLinkTo(self.Launcher);
    self.Launcher moveZ((470), 2, 1, 1);
    self thread sounds();
    self.Launcher waittill("movedone");
    self thread welcomeText("^1" + level.patch, "Welcome To The ^2SkyBase ^3Created By: Mikeeeyy");
    self unlink();
    self.Launcher delete();
    self.UsingVelo = undefined;
    level.airbaseIsBuilding = undefined;
}
sounds() {
    self playLocalSound("arcademode_checkpoint");
    wait 1;
    self playLocalSound("arcademode_checkpoint");
}
SkyBase_Exit() {
    pos = (27, -458, 466.125);
    ExitTrig = spawnTrigger(pos, 40);
    ExitTrig airbaseArray();
    ExitTrig setString("Press [{+activate}] To ^1Descend ^7To Ground");
    for (;;) {
        ExitTrig waittill("trigger", i);
        if (i useButtonPressed() && !IsDefined(i.UsingVelo)) {
            i.UsingVelo = true;
            i thread Velocity2();
        }
    }
}
Velocity2() {
    self.InAirBase1 = undefined;
    if (!isDefined(self.menu["misc"]["godMode"])) self disableGodMode();
    else if (isDefined(self.menu["misc"]["godMode"])) self enableGodMode();
    self setStance("stand");
    self.Launcher2 = spawn("script_origin", (27, -458, 466.125));
    self.Launcher2 airbaseArray();
    self playerLinkTo(self.Launcher2);
    self.Launcher2 moveZ((-470), 2, 1, 1);
    self thread sounds();
    self.Launcher2 waittill("movedone");
    self thread welcomeText("^1" + level.patch, "Thank you For Visiting The ^2SkyBase ^5Come Back Soon");
    self unlink();
    self.Launcher2 delete();
    self notify("Base_Exit");
    self allowJump(true);
    self allowProne(true);
    self.UsingVelo = undefined;
}
LaunchModels() {
    self thread Insta_Spin();
    RI = "zombie_teleporter_mainframe_ring1";
    RI airbaseArray();
    RI3 = "zombie_teleporter_mainframe_ring3";
    RI3 airbaseArray();
    SM = "script_model";
    SM airbaseArray();
    wait .12;
    Ring = spawn(SM, (27, -458, 425));
    Ring airbaseArray();
    Ring setModel(RI3);
    Ring thread Rotate_Model(360, 2);
    wait .12;
    Ring = spawn(SM, (27, -458, 385));
    Ring airbaseArray();
    Ring setModel(RI);
    Ring thread Rotate_Model(-360, 2);
    wait .12;
    Ring = spawn(SM, (27, -458, 345));
    Ring airbaseArray();
    Ring setModel(RI3);
    Ring thread Rotate_Model(360, 2);
    wait .12;
    Ring = spawn(SM, (27, -458, 305));
    Ring airbaseArray();
    Ring setModel(RI);
    Ring thread Rotate_Model(-360, 2);
    wait .12;
    Ring = spawn(SM, (27, -458, 265));
    Ring airbaseArray();
    Ring setModel(RI3);
    Ring thread Rotate_Model(360, 2);
    wait .15;
    Ring = spawn(SM, (27, -458, 225));
    Ring airbaseArray();
    Ring setModel(RI);
    Ring thread Rotate_Model(-360, 2);
    wait .12;
    Ring = spawn(SM, (27, -458, 185));
    Ring airbaseArray();
    Ring setModel(RI3);
    Ring thread Rotate_Model(360, 2);
    wait .12;
    Ring = spawn(SM, (27, -458, 145));
    Ring airbaseArray();
    Ring setModel(RI);
    Ring thread Rotate_Model(-360, 2);
    wait .12;
    Ring = spawn(SM, (27, -458, 105));
    Ring airbaseArray();
    Ring setModel(RI3);
    Ring thread Rotate_Model(360, 2);
    wait .12;
    Ring = spawn(SM, (27, -458, 65));
    Ring airbaseArray();
    Ring setModel(RI);
    Ring thread Rotate_Model(-360, 2);
    wait .12;
    Ring = spawn(SM, (27, -458, 25));
    Ring airbaseArray();
    Ring setModel(RI3);
    Ring thread Rotate_Model(360, 2);
    Ring airbaseArray();
    self thread SkyBase_Entrance();
    level.AirBaseBack = true;
    level.airbaseIsBuilding = undefined;
    level.BaseSpwnd = undefined;
    self thread SpawnRefresh();
}
Insta_Spin() {
    Skull = spawn("script_model", (27, -458, 525));
    Skull setModel("zombie_teddybear_shanks");
    Skull airbaseArray();
    playFxOnTag(level._effect["powerup_on"], Skull, "tag_origin");
    Skull thread Rotate_Model(360, 2);
    for (;;) {
        Skull moveZ((-510), 6);
        Skull waittill("movedone");
        Skull moveZ((510), 6);
        Skull waittill("movedone");
    }
    wait .15;
}
//Interrupteur Principal Skybase

PrinBase() {
    if (!IsDefined(level.interBaseSpwnd) && level.Small == false && level.BigBoy == false && level.PrinBase != true) {
        if (level.rainstarter == true) {
            if (isDefined(level.entitySpace)) return;
            level.entitySpace = true;
            level.interBaseSpwnd = true;
            self thread PinceSkyB();
            self thread SpawnRefresh();
        }
    }
    if (!IsDefined(level.interBaseSpwnd) && level.Small == false && level.BigBoy == false && level.PrinBase != true) {
        if (level.Raindeletetime == true) {
            getPlayers()[0] notify("rain_sphere");
            if (isDefined(level.entitySpace)) return;
            level.entitySpace = true;
            level.BigBoy = true;
            level.interBaseSpwnd = true;
            self iPrintln("^1Deleting ^7Raining Models!");
            self thread SpawnRefresh();
            wait 7;
            self thread PinceSkyB();
        }
    }
    if (!IsDefined(level.interBaseSpwnd) && level.PrinBase != true) {
        if (level.Small == true || level.BigBoy == true) {
            self playlocalsound("deny");
            self iPrintln("^1Error ^7Entity Limit Reached!");
        }
    } else {
        if (isDefined(level.PrinBaseIsBuilding)) return;
        if (!IsDefined(level.interBaseSpwnd) && level.PrinBase == true) {
            level.interBaseBack = undefined;
            level thread PrinBaseDelete2();
            level.interBaseSpwnd = true;
            level.PrinBase = false;
            self thread SpawnRefresh();
            self thread createProgressBar_Delete(3, "Interrupteur Principal Skybase Deleting!", 1, "Interrupteur Principal Skybase Deleted!");
            for (m = 0; m < getPlayers().size; m++) {
                player = getPlayers()[m];
                if (isDefined(player.InPrinBase1)) {
                    player returnToSpawn();
                    player allowJump(true);
                    player allowProne(true);
                    player.InPrinBase1 = undefined;
                    if (!isDefined(player.menu["misc"]["godMode"])) player disableGodMode();
                    else if (isDefined(player.menu["misc"]["godMode"])) player enableGodMode();
                    player thread afterKillstreakProtection();
                }
            }
            wait 2.95;
            level.interBaseSpwnd = undefined;
            level thread PrinBase1Delete();
            self thread SpawnRefresh();
        }
    }
}
PinceSkyB() {
    level.BigBoy = true;
    level.PrinBase = true;
    level.PrinBaseIsBuilding = true;
    self thread createProgressBar(9.6, "Interrupteur Principal Skybase Building!", 1, "Interrupteur Principal Skybase Built!");
    TL = "zombie_treasure_box_lid";
    TL PBArray();
    TB = "zombie_treasure_box";
    TB PBArray();
    TR = "trigger_radius";
    TR PBArray();
    SM = "script_model";
    SM PBArray();
    Floor = (90, -439, 466);
    Floor PBArray();
    level.Floor = [];
    level.Floor PBArray();
    for (a = 0; a < 2; a++) {
        for (d = 0; d < 3; d++) {
            for (g = 0; g < 10; g++) {
                x = level.Floor.size;
                level.Floor[x] = spawn(SM, (Floor[0] + (d * 89), Floor[1] + (g * -24), Floor[2] + (a * 105)));
                level.Floor[x] setmodel(TL);
                level.Floor[x] PBArray();
                wait .07;
            }
        }
    }
    BackWall = (261, -539, 466);
    BackWall PBArray();
    BackBlock = (261, -539, 466);
    BackBlock PBArray();
    level.BackWall = [];
    level.BackBlock = [];
    for (b = 0; b < 4; b++) {
        wait .08;
        level.BackBlock = spawn(TR, (0, 0, 0), 0, 100, 100);
        level.BackBlock.origin = (BackBlock[0] + (b * -82), BackBlock[1] - 160, BackBlock[2] + 5);
        level.BackBlock setContents(1);
        level.BackBlock PBArray();
        for (a = 0; a < 6; a++) {
            level.BackWall = spawn(SM, (BackWall[0] + (b * -82), BackWall[1] - 120, BackWall[2] + (a * 17.8)));
            level.BackWall setmodel(TB);
            level.BackWall PBArray();
            wait .07;
        }
    }
    RightWall = (306, -615, 466);
    RightWall PBArray();
    RightBlock = (306, -615, 466);
    RightBlock PBArray();
    level.RightWall = [];
    level.RightBlock = [];
    for (b = 0; b < 3; b++) {
        wait .07;
        level.RightBlock = spawn(TR, (0, 0, 0), 0, 100, 100);
        level.RightBlock.origin = (RightBlock[0] + 40, RightBlock[1] + (b * 75), RightBlock[2]);
        level.RightBlock setContents(1);
        level.RightBlock PBArray();
        for (a = 0; a < 6; a++) {
            level.RightWall = spawn(SM, (RightWall[0], RightWall[1] + (b * 75), RightWall[2] + (a * 17.8)));
            level.RightWall setmodel(TB);
            level.RightWall.angles = (0, 90, 0);
            level.RightWall PBArray();
            wait .07;
        }
    }
    LeftWall = (-37, -596, 466);
    LeftWall PBArray();
    level.LeftWall = [];
    level.LeftBlock = spawn(TR, (0, 0, 0), 0, 100, 100);
    level.LeftBlock.origin = ((-37, -596, 466) + (-40, 0, 0));
    level.LeftBlock setContents(1);
    level.LeftBlock PBArray();
    wait .07;
    level.LeftBlock1 = spawn(TR, (0, 0, 0), 0, 100, 100);
    level.LeftBlock1.origin = ((-37, -596, 466) + (-40, -30, 0));
    level.LeftBlock1 setContents(1);
    level.LeftBlock1 PBArray();
    for (a = 0; a < 6; a++) {
        level.LeftWall = spawn(SM, (LeftWall[0], LeftWall[1], LeftWall[2] + (a * 17.8)));
        level.LeftWall setmodel(TB);
        level.LeftWall.angles = (0, 90, 0);
        level.LeftWall PBArray();
        wait .08;
    }
    CenterWall = (7, -414, 466);
    CenterWall PBArray();
    level.CenterWall = [];
    level.CenterBlock = spawn(TR, (0, 0, 0), 0, 100, 100);
    level.CenterBlock.origin = (CenterWall + (0, -90, 5));
    level.CenterBlock setContents(1);
    level.CenterBlock PBArray();
    for (a = 0; a < 6; a++) {
        level.CenterWall = spawn(SM, (CenterWall[0], CenterWall[1] - 120, CenterWall[2] + (a * 17.8)));
        level.CenterWall setmodel(TB);
        level.CenterWall PBArray();
        wait .07;
    }
    WallUnderWindow = (92, -419, 466);
    WallUnderWindow PBArray();
    level.WallUnderWindow = [];
    level.WallUnderWindowLid = spawn(SM, (92, -419, 466) + (0, -11, 35));
    level.WallUnderWindowLid setModel(TL);
    level.WallUnderWindowLid.angles = (0, 0, 0);
    level.WallUnderWindowLid PBArray();
    wait .08;
    level.WallUnderWindowLid1 = spawn(SM, (92, -419, 466) + (85, -11, 35));
    level.WallUnderWindowLid1 setModel(TL);
    level.WallUnderWindowLid1.angles = (0, 0, 0);
    level.WallUnderWindowLid1 PBArray();
    wait .07;
    level.WallUnderWindowLid2 = spawn(SM, (92, -419, 466) + (170, -11, 35));
    level.WallUnderWindowLid2 setModel(TL);
    level.WallUnderWindowLid2.angles = (0, 0, 0);
    level.WallUnderWindowLid2 PBArray();
    wait .07;
    for (b = 0; b < 3; b++) {
        for (a = 0; a < 2; a++) {
            level.WallUnderWindow = spawn(SM, (WallUnderWindow[0] + (b * 85), WallUnderWindow[1], WallUnderWindow[2] + (a * 17.8)));
            level.WallUnderWindow setmodel(TB);
            level.WallUnderWindow PBArray();
            wait .07;
        }
    }
    WallOntopWindow = (92, -419, 551);
    WallOntopWindow PBArray();
    level.WallOntopWindow = [];
    level.FrontTopWindowLid = spawn(SM, (92, -419, 551) + (0, -11, 0));
    level.FrontTopWindowLid PBArray();
    level.FrontTopWindowLid setModel(TL);
    level.FrontTopWindowLid.angles = (180, 0, 0);
    wait .07;
    level.FrontTopWindowLid1 = spawn(SM, (92, -419, 551) + (85, -11, 0));
    level.FrontTopWindowLid1 setModel(TL);
    level.FrontTopWindowLid1.angles = (180, 0, 0);
    level.FrontTopWindowLid1 PBArray();
    wait .07;
    level.FrontTopWindowLid2 = spawn(SM, (92, -419, 551) + (170, -11, 0));
    level.FrontTopWindowLid2 setModel(TL);
    level.FrontTopWindowLid2.angles = (180, 0, 0);
    level.FrontTopWindowLid2 PBArray();
    wait .07;
    for (b = 0; b < 3; b++) {
        level.WallOntopWindow = spawn(SM, (WallOntopWindow[0] + (b * 85), WallOntopWindow[1], WallOntopWindow[2]));
        level.WallOntopWindow setmodel(TB);
        level.WallOntopWindow PBArray();
        wait .07;
    }
    LeftWallWindow = (47, -476, 466);
    LeftWallWindow PBArray();
    level.LeftWallWindow = [];
    level.LeftWindowLid = spawn(SM, LeftWallWindow + (11, 0, 35));
    level.LeftWindowLid setModel(TL);
    level.LeftWindowLid.angles = (0, 90, 0);
    level.LeftWindowLid PBArray();
    wait .07;
    level.LeftWindow = spawn(SM, LeftWallWindow + (0, 0, 85));
    level.LeftWindow setModel(TB);
    level.LeftWindow.angles = (0, 90, 0);
    level.LeftWindow PBArray();
    wait .07;
    level.LeftWindow1 = spawn(SM, LeftWallWindow + (11, 0, 85));
    level.LeftWindow1 setModel(TL);
    level.LeftWindow1.angles = (180, 90, 0);
    level.LeftWindow1 PBArray();
    wait .07;
    for (a = 0; a < 2; a++) {
        level.LeftWallWindow = spawn(SM, (LeftWallWindow[0], LeftWallWindow[1], LeftWallWindow[2] + (a * 17.8)));
        level.LeftWallWindow setmodel(TB);
        level.LeftWallWindow.angles = (0, 90, 0);
        level.LeftWallWindow PBArray();
        wait .07;
    }
    TeleRoof = (7, -549, 466);
    TeleRoof PBArray();
    level.TeleRoof = [];
    for (g = 0; g < 5; g++) {
        level.TeleRoof = spawn(SM, (TeleRoof[0], TeleRoof[1] + (g * -24), TeleRoof[2] + 105));
        level.TeleRoof setmodel(TL);
        level.TeleRoof PBArray();
    }
    BlockLeftWindow = (33, -527, 481);
    BlockLeftWindow PBArray();
    level.BlockLeftWindow = [];
    for (b = 0; b < 2; b++) {
        for (g = 0; g < 7; g++) {
            level.BlockLeftWindow = spawn(TR, (0, 0, 0), 0, 30, 30);
            level.BlockLeftWindow.origin = (BlockLeftWindow[0] + 10, BlockLeftWindow[1] + (g * 20), BlockLeftWindow[2] + (b * 70));
            level.BlockLeftWindow setContents(1);
            level.BlockLeftWindow PBArray();
        }
    }
    BlockFrontWindow = (50, -417, 481);
    BlockFrontWindow PBArray();
    level.BlockFrontWindow = [];
    for (b = 0; b < 2; b++) {
        for (g = 0; g < 12; g++) {
            level.BlockFrontWindow = spawn(TR, (0, 0, 0), 0, 30, 30);
            level.BlockFrontWindow.origin = (BlockFrontWindow[0] + (g * 20), BlockFrontWindow[1] - 2, BlockFrontWindow[2] + (b * 70));
            level.BlockFrontWindow setContents(1);
            level.BlockFrontWindow PBArray();
        }
    }
    self thread interBaseWindows();
    self thread BollardRight((47.6226, -423.591, 466.125));
    wait .15;
    self thread doPackI();
    self thread PerkTrigI();
    wait .15;
    self thread Enter_Exit((7.658, -539.665, 466.125));
    self thread SkyBase_ExitIN();
    wait .15;
    self thread PerkSpawnI();
    self thread rotatePerkspawn();
    wait .15;
    self thread PerkSpawnBob();
    self thread spwnbuyablesI();
    self thread LaunchIModels();
}
PrinBase1Delete() {
    level.PrinBaseIsBuilding = true;
    for (m = 0; m < level.PrinBaseArray.size; m++) level.PrinBaseArray[m] delete();
    level.PrinBaseArray = undefined;
    level.entitySpace = undefined;
    level.PrinBaseIsBuilding = undefined;
    level.Raindeletetime = false;
    level.rainstarter = true;
    level.BigBoy = false;
}
PrinBaseDelete2() {
    for (m = 0; m < level.PrinBaseArray2.size; m++) level.PrinBaseArray2[m] delete();
    level.PrinBaseArray2 = undefined;
}
PBArray() {
    if (!isDefined(level.PrinBaseArray)) level.PrinBaseArray = [];
    m = level.PrinBaseArray.size;
    level.PrinBaseArray[m] = self;
}
PBArray2() {
    if (!isDefined(level.PrinBaseArray2)) level.PrinBaseArray2 = [];
    m = level.PrinBaseArray2.size;
    level.PrinBaseArray2[m] = self;
}
LaunchIModels() {
    MR = "zombie_teleporter_mainframe_ring1";
    MR PBArray();
    SM = "script_model";
    SM PBArray();
    Ring = spawn(SM, (14, -596, 464));
    Ring setModel(MR);
    Ring PBArray();
    wait .15;
    Ring1 = spawn(SM, (14, -596, 420));
    Ring1 setModel(MR);
    Ring1 PBArray();
    wait .15;
    Ring2 = spawn(SM, (14, -596, 380));
    Ring2 setModel(MR);
    Ring2 PBArray();
    wait .15;
    Ring3 = spawn(SM, (14, -596, 340));
    Ring3 setModel(MR);
    Ring3 PBArray();
    wait .15;
    Ring4 = spawn(SM, (14, -596, 300));
    Ring4 setModel(MR);
    Ring4 PBArray();
    wait .15;
    Ring5 = spawn(SM, (14, -596, 260));
    Ring5 setModel(MR);
    Ring5 PBArray();
    wait .15;
    Ring6 = spawn(SM, (14, -596, 220));
    Ring6 setModel(MR);
    Ring6 PBArray();
    wait .15;
    Ring7 = spawn(SM, (14, -596, 180));
    Ring7 setModel(MR);
    Ring7 PBArray();
    wait .15;
    Ring8 = spawn(SM, (14, -596, 140));
    Ring8 setModel(MR);
    Ring8 PBArray();
    wait .15;
    Ring9 = spawn(SM, (14, -596, 100));
    Ring9 setModel(MR);
    Ring9 PBArray();
    self thread SkyBase_EntranceIN();
    self thread SpinIring1(Ring1);
    self thread SpinINRing(Ring2);
    self thread SpinIring1(Ring3);
    self thread SpinINRing(Ring4);
    self thread SpinIring1(Ring5);
    self thread SpinINRing(Ring6);
    self thread SpinIring1(Ring7);
    self thread SpinINRing(Ring8);
    self thread SpinIring1(Ring9);
    level.interBaseBack = true;
    level.PrinBaseIsBuilding = undefined;
    level.interBaseSpwnd = undefined;
    self thread SpawnRefresh();
}
SpinIring1(DG) {
    for (;;) {
        DG rotateyaw(-360, 1.5);
        wait 1.5;
    }
}
SpinINRing(DG) {
    for (;;) {
        DG rotateyaw(360, 1.5);
        wait 1.5;
    }
}
interBaseWindows() {
    level.secretRoomOpen = false;
    level.trig1_use = false;
    level.trig_use = false;
    self thread Skyinter_1();
    self.AllWeapons = false;
    a = "zombie_treasure_box_lid";
    SM = "script_model";
    level.Kieran = spawn(SM, (92.5239, -419.396, 496.125));
    level.Kieran setModel(a);
    level.Kieran.angles = (0, 0, 90);
    level.Kieran PBArray();
    wait .15;
    level.Kieran0 = spawn(SM, (92.5239, -419.396, 516.125));
    level.Kieran0 setModel(a);
    level.Kieran0.angles = (0, 0, 90);
    level.Kieran0 PBArray();
    wait .15;
    level.Kieran1 = spawn(SM, (92.5239, -419.396, 536.125));
    level.Kieran1 setModel(a);
    level.Kieran1.angles = (0, 0, 90);
    level.Kieran1 PBArray();
    wait .15;
    level.Kieran11 = spawn(SM, (177.658, -419.396, 496.125));
    level.Kieran11 setModel(a);
    level.Kieran11.angles = (0, 0, 90);
    level.Kieran11 PBArray();
    wait .15;
    level.Kieran12 = spawn(SM, (177.658, -419.396, 516.125));
    level.Kieran12 setModel(a);
    level.Kieran12.angles = (0, 0, 90);
    level.Kieran12 PBArray();
    wait .15;
    level.Kieran13 = spawn(SM, (177.658, -419.396, 536.125));
    level.Kieran13 setModel(a);
    level.Kieran13.angles = (0, 0, 90);
    level.Kieran13 PBArray();
    wait .15;
    level.Kieran21 = spawn(SM, (261.658, -419.396, 496.125));
    level.Kieran21 setModel(a);
    level.Kieran21.angles = (0, 0, 90);
    level.Kieran21 PBArray();
    wait .15;
    level.Kieran22 = spawn(SM, (261.658, -419.396, 516.125));
    level.Kieran22 setModel(a);
    level.Kieran22.angles = (0, 0, 90);
    level.Kieran22 PBArray();
    wait .15;
    level.Kieran23 = spawn(SM, (261.658, -419.396, 536.125));
    level.Kieran23 setModel(a);
    level.Kieran23.angles = (0, 0, 90);
    level.Kieran23 PBArray();
    wait .15;
    level.Kieran27 = spawn(SM, (47.7769, -476.617, 496.125));
    level.Kieran27 setModel(a);
    level.Kieran27.angles = (0, 90, 90);
    level.Kieran27 PBArray();
    wait .15;
    level.Kieran28 = spawn(SM, (47.7769, -476.617, 516.125));
    level.Kieran28 setModel(a);
    level.Kieran28.angles = (0, 90, 90);
    level.Kieran28 PBArray();
    wait .15;
    level.Kieran29 = spawn(SM, (47.7769, -476.617, 536.125));
    level.Kieran29 setModel(a);
    level.Kieran29.angles = (0, 90, 90);
    level.Kieran29 PBArray();
    wait .15;
    level.Kieran6 = spawn(SM, (135.734, -645.858, 505.125));
    level.Kieran6 setModel("zombie_power_lever_handle");
    level.Kieran6.angles = (0, 0, 0);
    level.Kieran6 PBArray();
    wait .15;
    pos3 = (135.734, -645.858, 505.125);
    FXM[3] = spawnSM(pos3, "tag_origin", (-90, 0, 0));
    playFxOnTag(loadFx("misc/fx_zombie_powerup_on"), FXM[3], "tag_origin");
    FXM[3] PBArray();
    pos = (116.486, 2156.03, 3174.04);
    FXM[0] = spawnSM(pos, "tag_origin", (-90, 0, 0));
    playFxOnTag(loadFx("maps/zombie/fx_zombie_moon_eclipse"), FXM[0], "tag_origin");
    FXM[0] PBArray();
}
Skyinter_1() {
    pos = (135.734, -640, 470);
    trig = spawnTrigger(pos, 20);
    trig PBArray();
    trig setString("Press [{+activate}] To ^2Open^7/^1Close ^7The Window");
    for (;;) {
        trig waittill("trigger", i);
        if (i useButtonPressed() && level.secretRoomOpen == false && level.trig1_use == false) {
            level.trig_use = true;
            level.secretRoomOpen = true;
            level.Kieran6 rotateroll(-180, .7);
            level.Kieran moveTo(level.Kieran.origin + (0, 0, -80), 1.5);
            level.Kieran0 moveTo(level.Kieran0.origin + (0, 0, -80), 1.5);
            level.Kieran1 moveTo(level.Kieran1.origin + (0, 0, -80), 1.5);
            level.Kieran11 moveTo(level.Kieran11.origin + (0, 0, -80), 1.5);
            level.Kieran12 moveTo(level.Kieran12.origin + (0, 0, -80), 1.5);
            level.Kieran13 moveTo(level.Kieran13.origin + (0, 0, -80), 1.5);
            level.Kieran21 moveTo(level.Kieran21.origin + (0, 0, -80), 1.5);
            level.Kieran22 moveTo(level.Kieran22.origin + (0, 0, -80), 1.5);
            level.Kieran23 moveTo(level.Kieran23.origin + (0, 0, -80), 1.5);
            level.Kieran27 moveTo(level.Kieran27.origin + (0, 0, -80), 1.5);
            level.Kieran28 moveTo(level.Kieran28.origin + (0, 0, -80), 1.5);
            level.Kieran29 moveTo(level.Kieran29.origin + (0, 0, -80), 1.5);
            i playsound("door_slide_open");
            wait 1.8;
            level.Kieran hide();
            level.Kieran0 hide();
            level.Kieran1 hide();
            level.Kieran11 hide();
            level.Kieran12 hide();
            level.Kieran13 hide();
            level.Kieran21 hide();
            level.Kieran22 hide();
            level.Kieran23 hide();
            level.Kieran27 hide();
            level.Kieran28 hide();
            level.Kieran29 hide();
            level.Kieran6 rotateroll(180, .7);
            wait .9;
            level.trig_use = false;
        }
        if (i useButtonPressed() && level.secretRoomOpen == true && level.trig1_use == false) {
            level.trig_use = true;
            level.secretRoomOpen = false;
            level.Kieran show();
            level.Kieran0 show();
            level.Kieran1 show();
            level.Kieran11 show();
            level.Kieran12 show();
            level.Kieran13 show();
            level.Kieran21 show();
            level.Kieran22 show();
            level.Kieran23 show();
            level.Kieran27 show();
            level.Kieran28 show();
            level.Kieran29 show();
            level.Kieran6 rotateroll(-180, .7);
            level.Kieran moveTo(level.Kieran.origin + (0, 0, 80), 1.5);
            level.Kieran0 moveTo(level.Kieran0.origin + (0, 0, 80), 1.5);
            level.Kieran1 moveTo(level.Kieran1.origin + (0, 0, 80), 1.5);
            level.Kieran11 moveTo(level.Kieran11.origin + (0, 0, 80), 1.5);
            level.Kieran12 moveTo(level.Kieran12.origin + (0, 0, 80), 1.5);
            level.Kieran13 moveTo(level.Kieran13.origin + (0, 0, 80), 1.5);
            level.Kieran21 moveTo(level.Kieran21.origin + (0, 0, 80), 1.5);
            level.Kieran22 moveTo(level.Kieran22.origin + (0, 0, 80), 1.5);
            level.Kieran23 moveTo(level.Kieran23.origin + (0, 0, 80), 1.5);
            level.Kieran27 moveTo(level.Kieran27.origin + (0, 0, 80), 1.5);
            level.Kieran28 moveTo(level.Kieran28.origin + (0, 0, 80), 1.5);
            level.Kieran29 moveTo(level.Kieran29.origin + (0, 0, 80), 1.5);
            i playsound("door_slide_open");
            wait 2;
            level.Kieran6 rotateroll(180, .7);
            wait .9;
            level.trig_use = false;
        }
    }
}
Enter_Exit(IELIITEMODZX) {
    b = "zombie_treasure_box_lid";
    b PBArray();
    PlusRep = 40;
    Rise = (0, -30, 0);
    rise1 = (0, -108, 0);
    rise2 = (-18, -55, -1);
    rise3 = (55, -55, -1);
    DGHackz = spawn("script_model", IELIITEMODZX + Rise);
    DGHackz setModel(b);
    DGHackz PBArray();
    wait .15;
    DGHackz1 = spawn("script_model", IELIITEMODZX + Rise1);
    DGHackz1 setModel(b);
    DGHackz1 PBArray();
    wait .15;
    DGHackz2 = spawn("script_model", IELIITEMODZX + Rise2);
    DGHackz2 setModel(b);
    DGHackz2.angles = (0, 90, 0);
    DGHackz2 PBArray();
    wait .15;
    DGHackz3 = spawn("script_model", IELIITEMODZX + Rise3);
    DGHackz3 setModel(b);
    DGHackz3.angles = (0, 90, 0);
    DGHackz3 PBArray();
}
BollardRight(IELIITEMODZX) {
    PlusRep = 40;
    Rise = (-10, 0, 60);
    Rise1 = (10, -11, 60);
    DGHackz = spawn("script_model", IELIITEMODZX + Rise);
    DGHackz setModel("zombie_treasure_box");
    DGHackz.angles = (90, 0, 0);
    DGHackz PBArray();
    wait .15;
    DGHackz1 = spawn("script_model", IELIITEMODZX + Rise1);
    DGHackz1 setModel("zombie_treasure_box_lid");
    DGHackz1.angles = (90, 0, 0);
    DGHackz1 PBArray();
}
SkyBase_EntranceIN() {
    pos = (14, -596, 10);
    trig = spawnTrigger(pos, 36);
    trig PBArray2();
    trig setString("Press [{+activate}] To Enter The Skybase");
    for (;;) {
        trig waittill("trigger", i);
        if (i useButtonPressed() && !isDefined(level.PrinBaseIsBuilding)) {
            wait .1;
            if (i useButtonPressed() && i.is_zombie == false && i.SuckerInUse == 1 && isDefined(level.interBaseBack)) {
                level.PrinBaseIsBuilding = true;
                i thread InterVelocity();
                wait 1;
            }
        }
    }
}
SkyBase_ExitIN() {
    pos = (14, -596, 466);
    trig = spawnTrigger(pos, 36);
    trig PBArray();
    trig setString("Press [{+activate}] To Exit The Skybase");
    for (;;) {
        trig waittill("trigger", i);
        if (i useButtonPressed() && i.is_zombie == false && i.SuckerInUse == 1) {
            i thread InterVelocity2();
            wait 1;
        }
    }
}
InterVelocity2() {
    self.InPrinBase1 = undefined;
    self.SuckerInUse = 0;
    self setStance("stand");
    self.Launcher2 = spawn("script_origin", (14, -596, 466));
    self playerLinkTo(self.Launcher2);
    self.Launcher2 moveto((14, -596, 11), 2.5, .7, .7);
    self playLocalSound("arcademode_checkpoint");
    wait 1.1;
    self playLocalSound("arcademode_checkpoint");
    self.Launcher2 waittill("movedone");
    self.Launcher2 delete();
    self unlink();
    self allowJump(true);
    self allowProne(true);
    self enableHealthShield(true);
    self enableInvulnerability();
    self.SuckerInUse = 1;
}
InterVelocity() {
    self.InPrinBase1 = true;
    self.SuckerInUse = 0;
    self enableHealthShield(true);
    self enableInvulnerability();
    self setStance("stand");
    self.Launcher = spawn("script_origin", (14, -596, 10));
    self playerLinkTo(self.Launcher);
    self.Launcher moveto((14, -596, 467), 2.5, 1, 1);
    self playLocalSound("arcademode_checkpoint");
    wait 1.1;
    self playLocalSound("arcademode_checkpoint");
    self.Launcher waittill("movedone");
    self.Launcher delete();
    self unlink();
    self allowJump(false);
    self allowProne(false);
    self.SuckerInUse = 1;
    level.PrinBaseIsBuilding = undefined;
}
doPackI() {
    level.packo = spawn("script_model", (288, -575, 466) + (-10, 0, 0));
    level.packo.angles = (0, -90, 0);
    level.packo setModel("zombie_vending_packapunch_on");
    level.packo PBArray();
    level.packoSolid = spawn("trigger_radius", (0, 0, 0), 0, 90, 90);
    level.packoSolid.origin = ((288, -575, 466) + (10, 0, 0));
    level.packoSolid.angles = (0, -90, 0);
    level.packoSolid setContents(1);
    level.packoSolid PBArray();
    playsoundatposition("mx_packa_jingle", (288, -575, 466));
    level.packo playloopsound("packa_rollers_loop");
    level._effect["packapunch_fx"] = loadfx("maps/zombie/fx_zombie_packapunch");
    level._effect["packapunch_fx"] PBArray();
    pos = (260, -575, 466);
    trig = spawnTrigger(pos, 45);
    trig PBArray();
    trig setString("Press & Hold [{+activate}] To Buy Pack 'a' Punch Upgrade [Cost: 1500]");
    for (;;) {
        trig waittill("trigger", player);
        Weap = player getCurrentWeapon();
        if (player useButtonPressed()) {
            weap = player getCurrentWeapon();
            weapon = "zombie_knuckle_crack";
            if (player.upw[weap] != 1) {
                if (player.score >= 1500) {
                    player playsound("cha_ching");
                    player.zombie_cost = 1500;
                    player.score -= 1500;
                    player takeWeapon(player getCurrentWeapon());
                    player freezeControls(true);
                    player giveWeapon(weapon);
                    player switchToWeapon(weapon);
                    player playsound("packa_weap_upgrade");
                    fxOrg = Spawn("script_model", level.packo.origin);
                    fxOrg setModel("tag_origin");
                    fx = playFxOnTag(level._effect["packapunch_fx"], fxOrg, "tag_origin");
                    wait 3;
                    player playsound("packa_weap_ready");
                    player freezeControls(false);
                    player.upw[weap] = 1;
                    player giveWeapon(weap, 0, false);
                    player switchToWeapon(weap);
                    player thread updFTW(weap);
                } else {
                    player playsound("packa_deny");
                    player iPrintln("^1ERROR: ^7Not Enough Points!");
                    wait 2;
                }
            } else {
                player iPrintln("^1ERROR: ^7Weapon Is Already Upgraded!");
                wait 2;
            }
        }
    }
    wait .05;
}
updFTW(gun) {
    for (;;) {
        self waittill("weapon_fired");
        weap = self getCurrentWeapon();
        if (weap == gun) {
            forward = self getTagOrigin("tag_eye");
            end = self thread vector_scal(anglesToForward(self getPlayerAngles()), 1000000);
            location = bulletTrace(forward, end, 0, self)["position"];
            magicBullet("panzerschrek_zombie", forward, location, self);
        }
    }
}
PerkTrigI() {
    pos = (70, -494, 460);
    PerkTrig = spawnTrigger(pos, 17);
    PerkTrig PBArray();
    PerkTrig setString("Press & Hold [{+activate}] To Buy All Perks [Cost: 500]");
    for (;;) {
        PerkTrig waittill("trigger", i);
        if (!IsDefined(i.perks_bought) && i.bowieing == false) {
            PerkTrig setString("Press & Hold [{+activate}] To Buy All Perks [Cost: 500]");
            if (i useButtonPressed()) {
                if (i.score >= 500 && i.bowieing == false) {
                    i.perks_bought = true;
                    i playsound("cha_ching");
                    i.zombie_cost = 500;
                    i.score -= 500;
                    i thread purchasePerks();
                } else {
                    i playSound("plr_" + i getEntityNumber() + "_vox_nomoney_perk_0");
                    wait 1;
                }
            }
        } else {
            PerkTrig setString("");
        }
    }
}
PerkSpawnI() {
    pos = (46, -494.501, 481.893);
    FXM[1] = spawnSM(pos, "tag_origin", (-90, 0, 0));
    playFxOnTag(loadFx("misc/fx_zombie_electric_trap"), FXM[1], "tag_origin");
    FXM[1] PBArray();
    level.PerkLinkered = spawn("script_origin", (46, -494.501, 512.893));
    level.PerkLinkered PBArray();
    Jugg = spawn("script_model", level.PerkLinkered.origin + (-5, 0, 0));
    Jugg setModel("zombie_perk_bottle_jugg");
    Jugg linkto(level.PerkLinkered);
    Jugg PBArray();
    Revive = spawn("script_model", level.PerkLinkered.origin + (5, 0, 0));
    Revive setModel("zombie_perk_bottle_revive");
    Revive linkto(level.PerkLinkered);
    Revive PBArray();
    Dub = spawn("script_model", level.PerkLinkered.origin + (0, -5, 0));
    Dub setModel("zombie_perk_bottle_doubletap");
    Dub linkto(level.PerkLinkered);
    Dub PBArray();
    Sleight = spawn("script_model", level.PerkLinkered.origin + (0, 5, 0));
    Sleight setModel("zombie_perk_bottle_sleight");
    Sleight linkto(level.PerkLinkered);
    Sleight PBArray();
}
rotatePerkspawn() {
    for (;;) {
        level.PerkLinkered rotateYaw(360, 2);
        wait .1;
    }
}
PerkSpawnBob() {
    for (;;) {
        level.PerkLinkered moveTo((46, -494.501, 512.893), 3, .5, .5);
        level.PerkLinkered waittill("movedone");
        level.PerkLinkered moveTo((46, -494.501, 533.893), 3, .5, .5);
        level.PerkLinkered waittill("movedone");
        wait .1;
    }
}
spwnbuyablesI() {
    pos = (46, -462.453, 481.893);
    FXM[1] = spawnSM(pos, "tag_origin", (-90, 0, 0));
    playFxOnTag(loadFx("misc/fx_zombie_electric_trap"), FXM[1], "tag_origin");
    FXM[1] PBArray();
    pos2 = (46, -462.453, 520.893);
    FXM[2] = spawnSM(pos2, "tag_origin", (-90, 0, 0));
    playFxOnTag(loadFx("misc/fx_zombie_powerup_on"), FXM[2], "tag_origin");
    FXM[2] PBArray();
    self.BuyableMon = spawn("script_model", (46, -462.453, 512.893));
    self.BuyableMon setModel("weapon_zombie_monkey_bomb");
    self.BuyableMon PBArray();
    self thread MonkeyBombI();
    for (;;) {
        self.BuyableMon rotateYaw(360, 1.5);
        wait .1;
    }
}
MonkeyBombI() {
    pos = (70, -462, 460);
    MonTrig = spawnTrigger(pos, 17);
    MonTrig PBArray();
    MonTrig setString("Press & Hold [{+activate}] To Buy ''The Wunder Weapons'' [Cost: 1000]");
    for (;;) {
        MonTrig waittill("trigger", i);
        if (i useButtonPressed()) {
            cost = 1000;
            if (i.score >= cost) {
                i.zombie_cost = 1000;
                i.score -= 1000;
                i takeAllWeapons();
                i giveWeapon("stielhandgranate", 4);
                i giveWeapon("ray_gun_upgraded_zm");
                i giveWeapon("tesla_gun_upgraded_zm");
                i switchToWeapon("tesla_gun_upgraded_zm");
                i playSound("sam_furnace_1");
                wait 2.5;
                i playSound("sam_furnace_2");
                wait 1;
            } else {
                i playSound("plr_" + i getEntityNumber() + "_vox_nomoney_perk_0");
                wait 1;
            }
        }
    }
}
//vHaackz Skybase


BuildredSkybase() {
    if (!IsDefined(level.redbullBaseSpwnd) && level.Small == false && level.BigBoy == false && level.redbullBase != true) {
        if (level.rainstarter == true) {
            if (isDefined(level.entitySpace)) return;
            level.entitySpace = true;
            level.redbullBaseSpwnd = true;
            self thread BuildredSkybase1();
            self thread SpawnRefresh();
        }
    }
    if (!IsDefined(level.redbullBaseSpwnd) && level.Small == false && level.BigBoy == false && level.redbullBase != true) {
        if (level.Raindeletetime == true) {
            getPlayers()[0] notify("rain_sphere");
            if (isDefined(level.entitySpace)) return;
            level.entitySpace = true;
            level.BigBoy = true;
            level.redbullBaseSpwnd = true;
            self iPrintln("^1Deleting ^7Raining Models!");
            self thread SpawnRefresh();
            wait 7;
            self thread BuildredSkybase1();
        }
    }
    if (!IsDefined(level.redbullBaseSpwnd) && level.redbullBase != true) {
        if (level.Small == true || level.BigBoy == true) {
            self playlocalsound("deny");
            self iPrintln("^1Error ^7Entity Limit Reached!");
        }
    } else {
        if (isDefined(level.redbullIsBuilding)) return;
        if (!IsDefined(level.redbullBaseSpwnd) && level.redbullBase == true) {
            level.redbullBack = undefined;
            level thread redbullDelete2();
            level.redbullBaseSpwnd = true;
            level.redbullBase = false;
            self thread SpawnRefresh();
            self thread createProgressBar_Delete(3, "vHaackz Skybase Deleting!", 1, "vHaackz Skybase Deleted!");
            for (m = 0; m < getPlayers().size; m++) {
                player = getPlayers()[m];
                if (isDefined(player.InredbullBase)) {
                    player returnToSpawn();
                    player allowJump(true);
                    player allowProne(true);
                    player.InredbullBase = undefined;
                    if (!isDefined(player.menu["misc"]["godMode"])) player disableGodMode();
                    else if (isDefined(player.menu["misc"]["godMode"])) player enableGodMode();
                    player thread afterKillstreakProtection();
                }
            }
            wait 2.95;
            level thread redbullDelete();
            if (!isDefined(level.redbullDelete3)) level thread redbullDelete3();
            level.redbullBaseSpwnd = undefined;
            level.redbullDelete3 = undefined;
            self thread SpawnRefresh();
        }
    }
}
BuildredSkybase1() {
    level.BigBoy = true;
    level.redbullBase = true;
    self thread createProgressBar(8.51, "vHaackz Skybase Spawning!", 1, "vHaackz Skybase Spawned!");
    level.Music = "NotPlayed";
    wait .02;
    level.Skybasered = "Notdestroyed";
    level.inSkybaseplay0 = false;
    level.inSkybaseplay1 = false;
    level.inSkybaseplay2 = false;
    level.inSkybaseplay3 = false;
    self thread build();
    wait .02;
    self thread Perksmod();
    self thread Teleporter2red();
    wait .02;
    self thread BuildSomeThing();
    self thread Perktrig();
    wait .02;
    self thread EasterEggPlayered();
    self thread DestroyMyBase();
    wait .02;
    self thread rotateTehModel();
    self thread Models();
    wait .02;
    self thread PerkBob();
}
Build() {
    level.redbullIsBuilding = true;
    for (r = -520; r < -232; r += 24) {
        Mikey = spawn("script_model", (-40, r, 466.125));
        Mikey setModel("zombie_treasure_box_lid");
        Mikey thread alwaysphysicalx();
        Mikey BullA();
        wait .02;
        Mikey = spawn("script_model", (-40, r, 534.125));
        Mikey setModel("zombie_treasure_box_lid");
        Mikey thread alwaysphysicalx();
        Mikey BullA();
        wait .02;
        Mikey = spawn("script_model", (50, r, 466.125));
        Mikey setModel("zombie_treasure_box_lid");
        Mikey thread alwaysphysicalx();
        Mikey BullA();
        wait .02;
        Mikey = spawn("script_model", (50, r, 534.125));
        Mikey setModel("zombie_treasure_box_lid");
        Mikey thread alwaysphysicalx();
        Mikey BullA();
        wait .02;
        Mikey = spawn("script_model", (140, r, 466.125));
        Mikey setModel("zombie_treasure_box_lid");
        Mikey thread alwaysphysicalx();
        Mikey BullA();
        wait .02;
        Mikey = spawn("script_model", (140, r, 534.125));
        Mikey setModel("zombie_treasure_box_lid");
        Mikey thread alwaysphysicalx();
        Mikey BullA();
        wait .02;
    }
    Mikey = spawn("script_model", (50, -256, 483.125));
    Mikey setModel("zombie_treasure_box_lid");
    Mikey thread alwaysphysicalx();
    Mikey BullA();
    wait .02;
    Mikey = spawn("script_model", (50, -526, 483.125));
    Mikey setModel("zombie_treasure_box_lid");
    Mikey thread alwaysphysicalx();
    Mikey BullA();
    wait .02;
    Mikey = spawn("script_model", (-62, -367.5, 483.125));
    Mikey setModel("zombie_treasure_box_lid");
    Mikey.angles = (0, 90, 0);
    Mikey thread alwaysphysicalx();
    Mikey BullA();
    wait .02;
    Mikey = spawn("script_model", (186, -367.5, 483.125));
    Mikey setModel("zombie_treasure_box_lid");
    Mikey.angles = (0, 90, 0);
    Mikey thread alwaysphysicalx();
    Mikey BullA();
    wait .02;
    Mikey = spawn("script_model", (50, -256, 517.125));
    Mikey setModel("zombie_treasure_box_lid");
    Mikey thread alwaysphysicalx();
    Mikey BullA();
    wait .02;
    Mikey = spawn("script_model", (50, -526, 517.125));
    Mikey setModel("zombie_treasure_box_lid");
    Mikey thread alwaysphysicalx();
    Mikey BullA();
    wait .02;
    Mikey = spawn("script_model", (-62, -367.5, 517.125));
    Mikey setModel("zombie_treasure_box_lid");
    Mikey.angles = (0, 90, 0);
    Mikey thread alwaysphysicalx();
    Mikey BullA();
    wait .02;
    Mikey = spawn("script_model", (186, -367.5, 517.125));
    Mikey setModel("zombie_treasure_box_lid");
    Mikey.angles = (0, 90, 0);
    Mikey thread alwaysphysicalx();
    Mikey BullA();
    wait .02;
    for (w = 466.125; w < 534.125; w += 17) {
        Mikey = spawn("script_model", (-40, -244, w));
        Mikey setModel("zombie_treasure_box");
        Mikey thread alwaysphysicalx();
        Mikey BullA();
        wait .02;
        Mikey = spawn("script_model", (-40, -514, w));
        Mikey setModel("zombie_treasure_box");
        Mikey thread alwaysphysicalx();
        Mikey BullA();
        wait .02;
        Mikey = spawn("script_model", (140, -244, w));
        Mikey setModel("zombie_treasure_box");
        Mikey thread alwaysphysicalx();
        Mikey BullA();
        wait .02;
        Mikey = spawn("script_model", (140, -514, w));
        Mikey setModel("zombie_treasure_box");
        Mikey thread alwaysphysicalx();
        Mikey BullA();
        wait .02;
        Mikey = spawn("script_model", (-74, -277.5, w));
        Mikey setModel("zombie_treasure_box");
        Mikey.angles = (0, 90, 0);
        Mikey thread alwaysphysicalx();
        Mikey BullA();
        wait .02;
        Mikey = spawn("script_model", (-74, -457.5, w));
        Mikey setModel("zombie_treasure_box");
        Mikey.angles = (0, 90, 0);
        Mikey thread alwaysphysicalx();
        Mikey BullA();
        wait .02;
        Mikey = spawn("script_model", (174, -277.5, w));
        Mikey setModel("zombie_treasure_box");
        Mikey.angles = (0, 90, 0);
        Mikey thread alwaysphysicalx();
        Mikey BullA();
        wait .02;
        Mikey = spawn("script_model", (174, -457.5, w));
        Mikey setModel("zombie_treasure_box");
        Mikey.angles = (0, 90, 0);
        Mikey thread alwaysphysicalx();
        Mikey BullA();
        wait .02;
    }
    Mikey = spawn("script_model", (50, -244, 466.125));
    Mikey setModel("zombie_treasure_box");
    Mikey thread alwaysphysicalx();
    Mikey BullA();
    wait .02;
    Mikey = spawn("script_model", (50, -244, 517.125));
    Mikey setModel("zombie_treasure_box");
    Mikey thread alwaysphysicalx();
    Mikey BullA();
    wait .02;
    Mikey = spawn("script_model", (50, -514, 466.125));
    Mikey setModel("zombie_treasure_box");
    Mikey thread alwaysphysicalx();
    Mikey BullA();
    wait .02;
    Mikey = spawn("script_model", (50, -514, 517.125));
    Mikey setModel("zombie_treasure_box");
    Mikey thread alwaysphysicalx();
    Mikey BullA();
    wait .02;
    Mikey = spawn("script_model", (-74, -367.5, 466.125));
    Mikey setModel("zombie_treasure_box");
    Mikey.angles = (0, 90, 0);
    Mikey thread alwaysphysicalx();
    Mikey BullA();
    wait .02;
    Mikey = spawn("script_model", (-74, -367.5, 517.125));
    Mikey setModel("zombie_treasure_box");
    Mikey.angles = (0, 90, 0);
    Mikey thread alwaysphysicalx();
    Mikey BullA();
    wait .02;
    Mikey = spawn("script_model", (174, -367.5, 466.125));
    Mikey setModel("zombie_treasure_box");
    Mikey.angles = (0, 90, 0);
    Mikey thread alwaysphysicalx();
    Mikey BullA();
    wait .02;
    Mikey = spawn("script_model", (174, -367.5, 517.125));
    Mikey setModel("zombie_treasure_box");
    Mikey.angles = (0, 90, 0);
    Mikey thread alwaysphysicalx();
    Mikey BullA();
    wait .02;
    self.Switch = spawn("script_model", (140, -496, 486.125));
    self.Switch setModel("zombie_zapper_wall_control");
    self.Switch.angles = (0, 90, 0);
    self.Switch thread alwaysphysicalx();
    self.Switch BullA();
    wait .02;
    self.Switch = spawn("script_model", (129, -501, 499.125));
    self.Switch setModel("zombie_zapper_handle");
    self.Switch.angles = (180, -90, 0);
    self.Switch thread alwaysphysicalx();
    self.Switch BullA();
    wait .02;
    self.Switch1 = spawn("script_model", (-31, -265, 486.125));
    self.Switch1 setModel("zombie_zapper_wall_control");
    self.Switch1.angles = (0, 270, 0);
    self.Switch1 thread alwaysphysicalx();
    self.Switch1 BullA();
    wait .02;
    self.Switch1 = spawn("script_model", (-20, -260, 499.125));
    self.Switch1 setModel("zombie_zapper_handle");
    self.Switch1.angles = (180, 270, 0);
    self.Switch1 thread alwaysphysicalx();
    self.Switch1 BullA();
    wait .02;
    level.base = spawn("trigger_radius", (50, -372, 537.125), 0, 600, 1000);
    level.base setContents(1);
    level.base BullASP();
    wait .02;
    for (s = -66; s < 174; s += 24) {
        level.base = spawn("trigger_radius", (s, -244, 466.125), 0, 24, 200);
        level.base setContents(1);
        level.base BullASP();
        wait .02;
        level.base = spawn("trigger_radius", (s, -520, 466.125), 0, 24, 200);
        level.base setContents(1);
        level.base BullASP();
        wait .02;
    }
    for (s = -520; s < -244; s += 24) {
        level.base = spawn("trigger_radius", (174, s, 466.125), 0, 24, 200);
        level.base setContents(1);
        level.base BullASP();
        wait .02;
        level.base = spawn("trigger_radius", (-74, s, 466.125), 0, 24, 200);
        level.base setContents(1);
        level.base BullASP();
        wait .02;
    }
    self thread Redbull();
    self thread RedBullModels();
    level.redbullBack = true;
    level.redbullBaseSpwnd = undefined;
    level.redbullIsBuilding = undefined;
    self thread SpawnRefresh();
}
redbullDelete() {
    level.redbullIsBuilding = true;
    for (m = 0; m < level.redbullBaseArray.size; m++) level.redbullBaseArray[m] delete();
    level.redbullBaseArray = undefined;
    level.entitySpace = undefined;
    level.redbullIsBuilding = undefined;
    level.Raindeletetime = false;
    level.rainstarter = true;
    level.BigBoy = false;
}
redbullDelete2() {
    for (m = 0; m < level.redbullBaseArray2.size; m++) level.redbullBaseArray2[m] delete();
    level.redbullBaseArray2 = undefined;
}
redbullDelete3() {
    level.redbullDelete3 = true;
    for (m = 0; m < level.redbullBaseArray3.size; m++) level.redbullBaseArray3[m] delete();
    level.redbullBaseArray3 = undefined;
}
BullA() {
    if (!isDefined(level.redbullBaseArray)) level.redbullBaseArray = [];
    m = level.redbullBaseArray.size;
    level.redbullBaseArray[m] = self;
}
BullA2() {
    if (!isDefined(level.redbullBaseArray2)) level.redbullBaseArray2 = [];
    m = level.redbullBaseArray2.size;
    level.redbullBaseArray2[m] = self;
}
BullASP() {
    if (!isDefined(level.redbullBaseArray3)) level.redbullBaseArray3 = [];
    m = level.redbullBaseArray3.size;
    level.redbullBaseArray3[m] = self;
}
RedBullModels() {
    RedbullMachine = spawn("script_model", (-89.8745, -476.018, -2.35358));
    RedbullMachine.angles = (0, 90, 0);
    RedbullMachine setModel("zombie_vending_sleight_on");
    RedbullMachine BullA();
    RedbullMachine alwaysphysicalx1();
}
EasterEggPlayered() {
    pos = (-31, -265, 486.125);
    trig = spawnTrigger(pos, 40);
    trig BullASP();
    trig setString("Press & Hold [{+activate}] To Play 'Beauty of Annihilation'");
    for (;;) {
        trig waittill("trigger", player);
        if (level.Music == "NotPlayed") {
            trig setString("Press & Hold [{+activate}] To Play 'Beauty of Annihilation'");
            if (player useButtonPressed()) {
                self.Switch1 rotatePitch(180, 1);
                wait 1;
                self playsound("mx_eggs");
                level.Music = "Played";
            }
        } else {
            trig setString("");
        }
    }
}
Teleporter2red() {
    level.Teleporter = spawn("script_model", (-46, -486, 483.125));
    level.Teleporter setModel("zombie_teddybear_perkaholic");
    level.Teleporter thread alwaysphysicalx();
    level.Teleporter BullA();
    pos = (-46, -491, 493.125);
    FXM[1] = spawnSM(pos, "tag_origin", (-90, 0, 0));
    playFxOnTag(loadFx("misc/fx_zombie_powerup_on"), FXM[1], "tag_origin");
    FXM[1] BullASP();
    self thread Teleporterred();
}
Teleporterred() {
    pos = (-46, -491, 483.125);
    trig = spawnTrigger(pos, 40);
    trig BullASP();
    trig setString("Press & Hold [{+activate}] To Exit Skybase");
    for (;;) {
        trig waittill("trigger", player);
        if (player useButtonPressed() && getPlayers()[0] useButtonPressed()) {
            level.inSkybaseplay0 = false;
            player redskybullbase();
        } else if (player useButtonPressed() && getPlayers()[1] useButtonPressed()) {
            level.inSkybaseplay1 = false;
            player redskybullbase();
        } else if (player useButtonPressed() && getPlayers()[2] useButtonPressed()) {
            level.inSkybaseplay2 = false;
            player redskybullbase();
        } else if (player useButtonPressed() && getPlayers()[3] useButtonPressed()) {
            level.inSkybaseplay3 = false;
            player redskybullbase();
        }
    }
}
redskybullbase() {
    self.InredbullBase = undefined;
    Tele = spawn("script_model", (2368, -320, 56));
    self setStance("stand");
    self playsound("teleport_2d_fnt");
    self setClientDvar("cg_drawGun", "0");
    self setClientDvar("cg_crosshairAlpha", "0");
    self playerLinkTo(Tele);
    self setPlayerAngles((0, 90, 0));
    self freezeControls(true);
    wait 2;
    self unlink();
    self freezeControls(false);
    self allowJump(true);
    self setPlayerAngles((0, 180, 0));
    self setOrigin((-60, 320, 120.125));
    playfx(level._effect["zombie_mainframe_link_all"], (-60, 320, 120.125));
    self setClientDvar("cg_drawGun", "1");
    self setClientDvar("cg_crosshairAlpha", "1");
    self shellshock("electrocution", 2);
}
alwaysphysicalx() {
    level waittill("DestroySkybase");
    for (;;) {
        self physicslaunch();
        wait 0.1;
    }
}
alwaysphysicalx1() {
    level waittill("DestroySkybase");
    for (;;) {
        self unLink();
        self physicslaunch();
        wait 0.1;
    }
}
BuildSomeThing() {
    Mikeeeyy = spawn("script_model", (120, -260, 483.125));
    Mikeeeyy setModel("zombie_teleporter_control_panel");
    Mikeeeyy thread alwaysphysicalx();
    Mikeeeyy BullA();
    self thread OrbitalMainFrame();
    Mikeeeyy = spawn("script_model", (-62, -367.5, 483.125));
    Mikeeeyy setModel("zombie_teleporter_control_panel");
    Mikeeeyy.angles = (0, 90, 0);
    Mikeeeyy thread alwaysphysicalx();
    Mikeeeyy BullA();
    self thread BigRedButton();
    level.WWTurret = spawn("script_model", (50, -236, 490.125));
    level.WWTurret setModel(getWeaponModel("tesla_gun_zm"));
    level.WWTurret.angles = (0, 90, 0);
    level.WWTurret.team = "allies";
    level.WWTurret thread alwaysphysicalx();
    level.WWTurret BullA();
    self thread EpicWin();
}
BigRedButton() {
    pos = (-62, -367.5, 483.125);
    trig = spawnTrigger(pos, 40);
    trig BullASP();
    trig setString("Press & Hold [{+activate}] For a Tactical Nuke");
    for (;;) {
        trig waittill("trigger", player);
        if (player useButtonPressed()) {
            trig setString("Tactical Nuke Inbound!");
            array_thread(getPlayers(), ::lockMenu_All);
            player thread nukeInitx();
            wait 3;
            level.Skybasered = "Destroyed";
            wait 7;
            if (!isDefined(level.redbullDelete3)) level thread redbullDelete3();
            level notify("DestroySkybase");
            array_thread(getPlayers(), ::PlayerFall);
        }
    }
}
OrbitalMainFrame() {
    pos = (120, -260, 483.125);
    trig = spawnTrigger(pos, 40);
    trig BullASP();
    trig setString("Press & Hold [{+activate}] To Orbital Strike The Mainframe");
    for (;;) {
        trig waittill("trigger", player);
        if (player useButtonPressed()) {
            radiusDamage((-60, 320, 103.125), 600, 1000, 500, self);
            earthquake(3, 2, (-60, 320, 103.125), 90);
            playfx(level._effect["zombie_mainframe_link_all"], (-60, 320, 103.125));
        }
    }
}
EpicWin() {
    pos = (50, -263, 490);
    TurretTrig = spawnTrigger(pos, 40);
    TurretTrig BullASP();
    TurretTrig setString("Press [{+activate}] To Activate Auto-Turret [60 Seconds]");
    for (;;) {
        TurretTrig waittill("trigger", i);
        if (i useButtonPressed() && !IsDefined(level.TurrentInUse)) {
            TurretTrig setString("");
            level.TurretInUse = true;
            i thread AutoTurretred();
            wait 60;
            i.WWTurret rotateTo((0, 0, 0), 1, .5, .5);
            TurretTrig setString("Press [{+activate}] To Activate Auto-Turret [60 Seconds]");
            level.TurretInUse = undefined;
            i notify("TurretOver");
            i.WWTurret notify("TurretOver");
        }
    }
}
AutoTurretred() {
    level.WWTurret thread TurretThinkred(self);
    level.WWTurret thread TurretLookred(self);
    level.WWTurret thread Shootingred(self);
}
TurretThinkred(controller) {
    self endon("TurretOver");
    controller endon("TurretOver");
    for (;;) {
        level.zombie = get_closest_ai(self.origin, "axis");
        wait 1;
    }
}
TurretLookred(controller) {
    self endon("TurretOver");
    controller endon("TurretOver");
    for (;;) {
        self rotateTo(vectorToAngles(level.zombie.origin - self.origin), .75);
        wait 1;
    }
}
Shootingred(controller) {
    self endon("TurretOver");
    controller endon("TurretOver");
    for (;;) {
        magicBullet("zombie_30cal", self getTagOrigin("tag_flash"), level.zombie.origin + (0, 0, 30));
        wait .1;
    }
}
PerkTrig() {
    pos = (75, -490, 486.125);
    PerkTrig = spawnTrigger(pos, 32);
    PerkTrig BullASP();
    PerkTrig setString("Press & Hold [{+activate}] For All Perks");
    for (;;) {
        PerkTrig waittill("trigger", i);
        if (!IsDefined(i.perks_bought) && i.bowieing == false) {
            PerkTrig setString("Press & Hold [{+activate}] For All Perks");
            if (i useButtonPressed()) {
                if (i.bowieing == false) {
                    i.perks_bought = true;
                    i playsound("cha_ching");
                    i thread purchasePerks();
                } else {
                    wait .1;
                }
            }
        } else {
            PerkTrig setString("");
        }
    }
}
Perksmod() {
    pos = (75, -515, 486.125);
    FXM[1] = spawnSM(pos, "tag_origin", (-90, 0, 0));
    playFxOnTag(loadFx("misc/fx_zombie_electric_trap"), FXM[1], "tag_origin");
    FXM[1] BullASP();
    level.PerkLinker = spawn("script_origin", (75, -515, 488.125));
    level.PerkLinker BullA();
    Jugg = spawn("script_model", level.PerkLinker.origin + (-5, 0, 0));
    Jugg setModel("zombie_perk_bottle_jugg");
    Jugg linkto(level.PerkLinker);
    Jugg thread alwaysphysicalx1();
    Jugg BullA();
    Revive = spawn("script_model", level.PerkLinker.origin + (5, 0, 0));
    Revive setModel("zombie_perk_bottle_revive");
    Revive linkto(level.PerkLinker);
    Revive thread alwaysphysicalx1();
    Revive BullA();
    Dub = spawn("script_model", level.PerkLinker.origin + (0, -5, 0));
    Dub setModel("zombie_perk_bottle_doubletap");
    Dub linkto(level.PerkLinker);
    Dub thread alwaysphysicalx1();
    Dub BullA();
    Sleight = spawn("script_model", level.PerkLinker.origin + (0, 5, 0));
    Sleight setModel("zombie_perk_bottle_sleight");
    Sleight linkto(level.PerkLinker);
    Sleight thread alwaysphysicalx1();
    Sleight BullA();
}
rotateTehModel() {
    for (;;) {
        level.Teleporter rotateYaw(360, 2);
        level.PerkLinker rotateYaw(360, 2);
        level.spinnerA rotateYaw(360, 2);
        level.spinnerB rotateYaw(360, 2);
        wait .1;
    }
}
PerkBob() {
    for (;;) {
        level.PerkLinker moveTo((75, -515, 490.125), 3, .5, .5);
        level.PerkLinker waittill("movedone");
        level.PerkLinker moveTo((75, -515, 505.125), 3, .5, .5);
        level.PerkLinker waittill("movedone");
        wait .1;
    }
}
Models() {
    level.spinnerA = spawn("script_origin", (172, -367.5, 501.125));
    Waffe = spawn("script_model", (172, -367.5, 501.125));
    pos = (172, -367.5, 486.125);
    FXM[1] = spawnSM(pos, "tag_origin", (-90, 0, 0));
    playFxOnTag(loadFx("misc/fx_zombie_electric_trap"), FXM[1], "tag_origin");
    FXM[1] BullASP();
    Waffe linkto(level.spinnerA);
    Waffe thread alwaysphysicalx1();
    Waffe SetModel(getWeaponModel("tesla_gun_zm"));
    Waffe BullA();
    self thread Wunderwaffered();
    pos2 = (20, -515, 486.125);
    FXM[2] = spawnSM(pos2, "tag_origin", (-90, 0, 0));
    playFxOnTag(loadFx("misc/fx_zombie_electric_trap"), FXM[2], "tag_origin");
    FXM[2] BullASP();
    self.Buyable4 = spawn("script_model", (20, -515, 488.125));
    self.Buyable4 thread alwaysphysicalx1();
    self.Buyable4 setModel("weapon_zombie_monkey_bomb");
    self.Buyable4 BullA();
    self thread MonkeyBombred();
    for (;;) {
        self.Buyable4 rotateYaw(360, 1.5);
        wait .1;
    }
}
DestroyMyBase() {
    pos = (140, -496, 486.125);
    trig = spawnTrigger(pos, 40);
    trig BullASP();
    trig setString("Press & Hold [{+activate}] To Destroy The Base");
    for (;;) {
        trig waittill("trigger", player);
        if (player useButtonPressed()) {
            trig setString("Destroying Base!");
            self.Switch rotatePitch(-180, 1);
            level.Skybasered = "Destroyed";
            wait 1;
            player thread DoDestroyBText();
            wait 3;
            if (!isDefined(level.redbullDelete3)) level thread redbullDelete3();
            level.DestroyBaseDone = "Over";
            level notify("DestroySkybase");
            array_thread(getPlayers(), ::PlayerFall);
        }
    }
}
DoDestroyBText() {
    for (m = 3; m > 0; m--) {
        self setText("Time: " + m);
        array_thread(getPlayers(), ::playSingleSound, "pa_audio_link_" + m);
        wait 1;
    }
}
PlayerFall() {
    if (self == getPlayers()[0] && level.inSkybaseplay0 == true) {
        level.inSkybaseplay0 = false;
        self.InredbullBase = undefined;
        Wings = spawn("script_origin", self.origin + (0, 0, 0));
        self playerLinkToDelta(Wings);
        Wings moveto(self.origin + (0, 0, -200), .7);
        wait .8;
        self unlink();
        self allowJump(true);
        Wings delete();
        wait 1;
    } else if (self == getPlayers()[1] && level.inSkybaseplay1 == true) {
        level.inSkybaseplay1 = false;
        self.InredbullBase = undefined;
        Wings = spawn("script_origin", self.origin + (0, 0, 0));
        self playerLinkToDelta(Wings);
        Wings moveto(self.origin + (0, 0, -200), .7);
        wait .8;
        self unlink();
        self allowJump(true);
        Wings delete();
        wait 1;
    } else if (self == getPlayers()[2] && level.inSkybaseplay2 == true) {
        level.inSkybaseplay2 = false;
        self.InredbullBase = undefined;
        Wings = spawn("script_origin", self.origin + (0, 0, 0));
        self playerLinkToDelta(Wings);
        Wings moveto(self.origin + (0, 0, -200), .7);
        wait .8;
        self unlink();
        self allowJump(true);
        Wings delete();
        wait 1;
    } else if (self == getPlayers()[3] && level.inSkybaseplay3 == true) {
        level.inSkybaseplay3 = false;
        self.InredbullBase = undefined;
        Wings = spawn("script_origin", self.origin + (0, 0, 0));
        self playerLinkToDelta(Wings);
        Wings moveto(self.origin + (0, 0, -200), .7);
        wait .8;
        self unlink();
        self allowJump(true);
        Wings delete();
        wait 1;
    }
}
Redbull() {
    pos = (-89.8745, -476.018, -2.35358);
    trig = spawnTrigger(pos, 40);
    trig BullA2();
    trig BullASP();
    trig setString("Press & Hold [{+activate}] For a Redbull");
    for (;;) {
        trig waittill("trigger", i);
        if (i useButtonPressed()) {
            wait .1;
            if (i useButtonPressed() && getPlayers()[0] useButtonPressed() && level.Skybasered == "Notdestroyed" && isDefined(level.redbullBack)) {
                level.redbullIsBuilding = true;
                level.inSkybaseplay0 = true;
                i redbullFlying();
            } else if (i useButtonPressed() && getPlayers()[1] useButtonPressed() && level.Skybasered == "Notdestroyed" && isDefined(level.redbullBack)) {
                level.redbullIsBuilding = true;
                level.inSkybaseplay1 = true;
                i redbullFlying();
            } else if (i useButtonPressed() && getPlayers()[2] useButtonPressed() && level.Skybasered == "Notdestroyed" && isDefined(level.redbullBack)) {
                level.redbullIsBuilding = true;
                level.inSkybaseplay2 = true;
                i redbullFlying();
            } else if (i useButtonPressed() && getPlayers()[3] useButtonPressed() && level.Skybasered == "Notdestroyed" && isDefined(level.redbullBack)) {
                level.redbullIsBuilding = true;
                level.inSkybaseplay3 = true;
                i redbullFlying();
            }
        }
    }
}
redbullFlying() {
    self.InredbullBase = true;
    playsoundatposition("bottle_dispense3d", self.origin);
    weap = self getCurrentWeapon();
    self disableOffhandWeapons();
    self disableWeaponCycling();
    self allowLean(false);
    self allowAds(false);
    self allowSprint(false);
    self allowProne(false);
    self allowMelee(false);
    wait 0.05;
    if (self getStance() == "prone") {
        self setStance("stand");
    }
    weapon = "zombie_perk_bottle_revive";
    self giveWeapon(weapon);
    self switchToWeapon(weapon);
    self waittill("weapon_change_complete");
    self enableOffhandWeapons();
    self enableWeaponCycling();
    self allowLean(true);
    self allowAds(true);
    self allowSprint(true);
    self allowProne(true);
    self allowMelee(true);
    self takeWeapon(weapon);
    self switchToweapon(weap);
    Wings = spawn("script_origin", self.origin + (0, 0, 0));
    self playerLinkToDelta(Wings);
    self freezeControls(true);
    Wings moveTo((-35, -481.409, 466.160), 2);
    wait .2;
    self allowJump(false);
    self visionSetNaked("cheat_contrast", 1.5);
    wait 2;
    self setVision("default");
    self unlink();
    self freezeControls(false);
    Wings delete();
    level.redbullIsBuilding = undefined;
}
Wunderwaffered() {
    pos = (152, -367.5, 483.125);
    trig = spawnTrigger(pos, 35);
    trig BullASP();
    trig setString("Press & Hold [{+activate}] For All Weapons");
    for (;;) {
        trig waittill("trigger", i);
        if (i useButtonPressed()) {
            i.allweaps = "Give All";
            i playsound("cha_ching");
            i thread giveAllGuns();
            i switchToWeapon("tesla_gun_zm");
            wait 1;
        }
    }
}
MonkeyBombred() {
    pos = (20, -490, 486.125);
    Montrig = spawnTrigger(pos, 32);
    Montrig BullASP();
    Montrig setString("Press & Hold [{+activate}] For Wunder Weapons");
    for (;;) {
        Montrig waittill("trigger", i);
        if (i useButtonPressed()) {
            i playsound("cha_ching");
            i takeAllWeapons();
            i giveWeapon("stielhandgranate", 4);
            i giveWeapon("ray_gun_zm");
            i giveWeapon("ray_gun_upgraded_zm");
            i giveWeapon("tesla_gun_zm");
            i giveWeapon("tesla_gun_upgraded_zm");
            i switchToWeapon("tesla_gun_upgraded_zm");
            wait 1;
        }
    }
}

//iRateed's Skybase

SkyBaserate() {
    if (!IsDefined(level.RateSpwnd) && level.Small == false && level.BigBoy == false && level.iRateBase != true) {
        if (level.rainstarter == true) {
            if (isDefined(level.entitySpace)) return;
            level.entitySpace = true;
            level.RateSpwnd = true;
            level thread survivalDoors();
            self thread SpawnFullSkyBasex();
            self thread SpawnRefresh();
        }
    }
    if (!IsDefined(level.RateSpwnd) && level.Small == false && level.BigBoy == false && level.iRateBase != true) {
        if (level.Raindeletetime == true) {
            getPlayers()[0] notify("rain_sphere");
            if (isDefined(level.entitySpace)) return;
            level.entitySpace = true;
            level.BigBoy = true;
            level.RateSpwnd = true;
            self iPrintln("^1Deleting ^7Raining Models!");
            self thread SpawnRefresh();
            wait 7;
            level thread survivalDoors();
            self thread SpawnFullSkyBasex();
        }
    }
    if (!IsDefined(level.RateSpwnd) && level.iRateBase != true) {
        if (level.Small == true || level.BigBoy == true) {
            self playlocalsound("deny");
            self iPrintln("^1Error ^7Entity Limit Reached!");
        }
    } else {
        if (isDefined(level.iRateIsBuilding)) return;
        if (!IsDefined(level.RateSpwnd) && level.iRateBase == true) {
            level.RateSpwndBack = undefined;
            level thread iRateDelete2();
            level.RateSpwnd = true;
            level.iRateBase = false;
            self thread SpawnRefresh();
            self thread createProgressBar_Delete(3, "iRateed's Skybase Deleting!", 1, "iRateed's Skybase Deleted!");
            for (a = 0; a < getPlayers().size; a++) {
                player = getPlayers()[a];
                if (isDefined(player.InRateBase)) {
                    player returnToSpawn();
                    player allowJump(true);
                    player allowProne(true);
                    player.InRateBase = undefined;
                    if (!isDefined(player.menu["misc"]["godMode"])) player disableGodMode();
                    else if (isDefined(player.menu["misc"]["godMode"])) player enableGodMode();
                    player thread afterKillstreakProtection();
                }
            }
            wait 2.95;
            level.RateSpwnd = undefined;
            level thread iRateDelete();
            level thread openAllDoors();
            self thread SpawnRefresh();
        }
    }
}
SpawnFullSkyBasex() {
    level.BigBoy = true;
    level.iRateBase = true;
    level.iRateIsBuilding = true;
    self thread createProgressBar(10.44, "iRateed's Skybase Building!", 1, "iRateed's Skybase Built!");
    origin = (133, -2000, 466.125);
    origin iRateA();
    self thread spawnBuyablesb();
    for (a = 0; a < 4; a++) {
        for (b = 0; b < 13; b++) {
            AG = spawnSM((origin[0] + 3 + (a * 90), origin[1] + 23 + (b * -23), origin[2]), "zombie_treasure_box_lid", (0, 0, 180));
            AG iRateA();
            wait .03;
            AG = spawnSM((origin[0] + 3 + (a * 90), origin[1] + (b * -23), origin[2] + 90.125), "zombie_treasure_box_lid");
            AG iRateA();
            wait .03;
        }
        AG = spawnSM((origin[0] + (a * 90), origin[1] + 13, origin[2]), "zombie_treasure_box");
        AG iRateA();
        wait .03;
        AG = spawnSM((origin[0] + (a * 90), origin[1] + 23, origin[2] + 18), "zombie_treasure_box_lid", (0, 0, 180));
        AG iRateA();
        wait .03;
        AG = spawnSM((origin[0] + (a * 90), origin[1] + 13, origin[2] + 73), "zombie_treasure_box");
        AG iRateA();
        wait .03;
        for (b = 0; b < 5; b++) {
            AG = spawnSM((origin[0] + (a * 90), origin[1] - 264, origin[2] + (b * 17.5)), "zombie_treasure_box");
            AG iRateA();
            wait .03;
        }
        AG = spawnSM((origin[0] + (a * 90), origin[1], origin[2] + 73), "zombie_treasure_box_lid");
        AG iRateA();
        wait .03;
    }
    for (a = 0; a < 3; a++) {
        for (b = 0; b < 2; b++) {
            for (c = 0; c < 2; c++) {
                AG = spawnSM((origin[0] - 35 + (c * 342), origin[1] - 20 - (b * 184), origin[2] + 17.5 + (a * 17.5)), "zombie_treasure_box", (0, 90, 0));
                AG iRateA();
                wait .03;
                AG = spawnSM((origin[0] - 46 + (b * 341), origin[1] - 111, origin[2] + 17.5), "zombie_treasure_box_lid", (0, 90, 180));
                AG iRateA();
                wait .03;
                AG = spawnSM((origin[0] - 24 + (b * 342), origin[1] - 111, origin[2] + 70), "zombie_treasure_box_lid", (0, 90, 0));
                AG iRateA();
                wait .03;
                AG = spawnSM((origin[0] - 35, origin[1] - 20 - (a * 92), origin[2] + (b * 70)), "zombie_treasure_box", (0, 90, 0));
                AG iRateA();
                wait .03;
                AG = spawnSM((origin[0] + 307, origin[1] - 20 - (a * 92), origin[2] + (b * 70)), "zombie_treasure_box", (0, 90, 0));
                AG iRateA();
                wait .04;
            }
        }
    }
    self thread SkyBaseSolidsx();
    wait .15;
    self thread Ringstelex();
    wait .15;
    self thread Ringstelex2();
    wait .15;
    self thread Packapunchb();
    self thread TeddyTrap4();
    self thread TeddyTrig3();
    self thread SkyBaseTurret1();
    level.RateSpwndBack = true;
    level.iRateIsBuilding = undefined;
    level.RateSpwnd = undefined;
    self thread SpawnRefresh();
}
iRateDelete() {
    level.iRateIsBuilding = true;
    self thread delWall();
    for (m = 0; m < level.iRateArray.size; m++) level.iRateArray[m] delete();
    level.iRateArray = undefined;
    level.entitySpace = undefined;
    level.iRateIsBuilding = undefined;
    level.Raindeletetime = false;
    level.rainstarter = true;
    level.BigBoy = false;
}
iRateDelete2() {
    for (m = 0; m < level.iRateArray2.size; m++) level.iRateArray2[m] delete();
    level.iRateArray2 = undefined;
}
iRateA() {
    if (!isDefined(level.iRateArray)) level.iRateArray = [];
    m = level.iRateArray.size;
    level.iRateArray[m] = self;
}
iRateA2() {
    if (!isDefined(level.iRateArray2)) level.iRateArray2 = [];
    m = level.iRateArray2.size;
    level.iRateArray2[m] = self;
}
Ringstelex() {
    pos = (120, -2236, 466);
    FXM[1] = spawnSM(pos, "tag_origin", (-90, 0, 0));
    playFxOnTag(loadFx("misc/fx_zombie_electric_trap"), FXM[1], "tag_origin");
    FXM[1] iRateA();
    PerkBotCenter = spawn("script_origin", (120, -2236, 510));
    PerkBotCenter iRateA();
    Jugg = spawn("script_model", PerkBotCenter.origin + (-5, 0, 0));
    Jugg setModel("zombie_perk_bottle_jugg");
    Jugg linkTo(PerkBotCenter);
    Jugg iRateA();
    Revive = spawn("script_model", PerkBotCenter.origin + (5, 0, 0));
    Revive setModel("zombie_perk_bottle_revive");
    Revive linkTo(PerkBotCenter);
    Revive iRateA();
    Dub = spawn("script_model", PerkBotCenter.origin + (0, -5, 0));
    Dub setModel("zombie_perk_bottle_doubletap");
    Dub linkTo(PerkBotCenter);
    Dub iRateA();
    Sleight = spawn("script_model", PerkBotCenter.origin + (0, 5, 0));
    Sleight setModel("zombie_perk_bottle_sleight");
    Sleight linkTo(PerkBotCenter);
    Sleight iRateA();
    PerkBotCenter thread Rotate_Model(360, 2);
    for (;;) {
        PerkBotCenter moveTo((120, -2236, 523), 3, .5, .5);
        PerkBotCenter waittill("movedone");
        PerkBotCenter moveTo((120, -2236, 493), 3, .5, .5);
        PerkBotCenter waittill("movedone");
    }
}
Ringstelex2() {
    pos = (414, -2236, 466);
    FXM[1] = spawnSM(pos, "tag_origin", (-90, 0, 0));
    playFxOnTag(loadFx("misc/fx_zombie_electric_trap"), FXM[1], "tag_origin");
    FXM[1] iRateA();
    PerkBotCenter = spawn("script_origin", (414, -2236, 510));
    PerkBotCenter iRateA();
    Jugg = spawn("script_model", PerkBotCenter.origin + (-5, 0, 0));
    Jugg setModel("zombie_perk_bottle_jugg");
    Jugg linkTo(PerkBotCenter);
    Jugg iRateA();
    Revive = spawn("script_model", PerkBotCenter.origin + (5, 0, 0));
    Revive setModel("zombie_perk_bottle_revive");
    Revive linkTo(PerkBotCenter);
    Revive iRateA();
    Dub = spawn("script_model", PerkBotCenter.origin + (0, -5, 0));
    Dub setModel("zombie_perk_bottle_doubletap");
    Dub linkTo(PerkBotCenter);
    Dub iRateA();
    Sleight = spawn("script_model", PerkBotCenter.origin + (0, 5, 0));
    Sleight setModel("zombie_perk_bottle_sleight");
    Sleight linkTo(PerkBotCenter);
    Sleight iRateA();
    PerkBotCenter thread Rotate_Model(360, 2);
    for (;;) {
        PerkBotCenter moveTo((414, -2236, 523), 3, .5, .5);
        PerkBotCenter waittill("movedone");
        PerkBotCenter moveTo((414, -2236, 493), 3, .5, .5);
        PerkBotCenter waittill("movedone");
    }
}
spawnBuyablesb() {
    pos = (140, -1990, 504);
    FXM[1] = spawnSM(pos, "tag_origin", (-90, 0, 0));
    playFxOnTag(loadFx("misc/fx_zombie_powerup_on"), FXM[1], "tag_origin");
    FXM[1] iRateA();
    wait .15;
    pos2 = (109, -2113.165 - 10, 512);
    FXM[2] = spawnSM(pos2, "tag_origin", (-90, 0, 0));
    playFxOnTag(loadFx("misc/fx_zombie_powerup_on"), FXM[2], "tag_origin");
    FXM[2] iRateA();
    wait .15;
    pos3 = (109, -2113.165 + 10, 512);
    FXM[3] = spawnSM(pos3, "tag_origin", (-90, 0, 0));
    playFxOnTag(loadFx("misc/fx_zombie_powerup_on"), FXM[3], "tag_origin");
    FXM[3] iRateA();
    wait .15;
    pos4 = (440, -2095.33, 513);
    FXM[4] = spawnSM(pos4, "tag_origin", (-90, 0, 0));
    playFxOnTag(loadFx("misc/fx_zombie_powerup_on"), FXM[4], "tag_origin");
    FXM[4] iRateA();
    wait .15;
    pos5 = (440, -2131, 513);
    FXM[5] = spawnSM(pos5, "tag_origin", (-90, 0, 0));
    playFxOnTag(loadFx("misc/fx_zombie_powerup_on"), FXM[5], "tag_origin");
    FXM[5] iRateA();
    wait .15;
    pos6 = (409, -1990, 512);
    FXM[6] = spawnSM(pos6, "tag_origin", (-90, 0, 0));
    playFxOnTag(loadFx("misc/fx_zombie_powerup_on"), FXM[6], "tag_origin");
    FXM[6] iRateA();
    wait .15;
    Buyable = spawn("script_model", (-103.11 + 275.9 - 39 + 47, -200.443 - 2050 + 20, 500));
    Buyable setModel("zombie_teddybear_perkaholic");
    Buyable iRateA();
    self thread BuyAllPerksb();
    wait .15;
    Buyable1 = spawn("script_model", (71.7471 + 275.9 - 39 + 47, -200.443 - 2050 + 20, 500));
    Buyable1 setModel("zombie_teddybear_shanks");
    Buyable1 iRateA();
    self thread BuyBowieKnife3();
    wait .15;
    Buyable2 = spawn("script_model", (440, -2109.33 + 20, 513));
    Buyable2.angles = (0, 90, 0);
    Buyable2 setModel("weapon_usa_ray_gun");
    Buyable2 iRateA();
    RayLink = spawn("script_origin", (440, -2095.33, 513));
    Buyable2 linkTo(RayLink);
    self thread RayGunk();
    wait .15;
    Buyable4 = spawn("script_model", (440, -2131, 513));
    Buyable4 setModel("viewmodel_zombie_ppsh_smg_up");
    Buyable4 iRateA();
    self thread MonkeyBomb3();
    wait .15;
    Buyable5 = spawn("script_model", (140, -1990, 504));
    Buyable5 setModel("zombie_ammocan");
    Buyable5 thread maps\_zombiemode_powerups::PowerUp_Wobble();
    Buyable5 iRateA();
    self thread MaxAmmo3();
    wait .15;
    Waffe = spawn("script_model", (109, -2113.165, 512));
    Waffe setModel(getWeaponModel("tesla_gun_zm"));
    Waffe iRateA();
    self thread Wunderwaffe3();
    Waffe.angles = (0, 270, 0);
    WaffeLink = spawn("script_origin", (109, -2113.165, 512));
    WaffeLink iRateA();
    Waffe linkTo(WaffeLink);
    self thread SpawnTehPowerUpsb();
    Buyable1.angles = (0, 90, 0);
    wait .15;
    trig = spawn("trigger_radius", (0, 0, 0), 0, 25, 200);
    trig.origin = Buyable.origin;
    trig setContents(1);
    trig iRateA();
    trig = spawn("trigger_radius", (0, 0, 0), 0, 25, 200);
    trig.origin = Buyable1.origin;
    trig setContents(1);
    trig iRateA();
    pos7 = (Waffe.origin);
    FXM[7] = spawnSM(pos7, "tag_origin", (-90, 0, 0));
    playFxOnTag(loadFx("misc/fx_zombie_powerup_on"), FXM[7], "tag_origin");
    FXM[7] iRateA();
    for (;;) {
        Buyable rotateYaw(360, 2);
        Buyable1 rotateYaw(360, 2);
        RayLink rotateYaw(360, 4);
        Buyable4 rotateYaw(360, 4);
        Buyable5 rotateYaw(360, 4);
        WaffeLink rotateYaw(360, 4);
        wait 2;
    }
}
SpawnTehPowerUpsb() {
    Uberh4x = spawn("script_model", (409, -1990, 512));
    Uberh4x setmodel("zombie_carpenter");
    Uberh4x thread maps\_zombiemode_powerups::PowerUp_Wobble();
    self thread RandomPowerup3();
    Uberh4x iRateA();
    wait .3;
    for (;;) {
        Uberh4x setmodel("zombie_bomb");
        wait .3;
        Uberh4x setmodel("zombie_x2_icon");
        wait .3;
        Uberh4x setmodel("zombie_ammocan");
        wait .3;
        Uberh4x setmodel("zombie_skull");
        wait .3;
        Uberh4x setmodel("zombie_carpenter");
        wait .3;
    }
}
Packapunchb() {
    level.pack = spawn("script_model", (-15.8226 + 275.9 - 39 + 47, -180 - 2050, 466.125));
    level.pack.angles = (0, 180, 0);
    level.pack setModel("zombie_vending_packapunch_on");
    level.pack thread PackaSong();
    level.pack iRateA();
    level.packSolid = spawn("trigger_radius", (0, 0, 0), 0, 100, 100);
    level.packSolid.origin = (-15.8226 + 275.9 - 39 + 47, -180 - 2050, 466.125);
    level.packSolid.angles = (0, 180, 0);
    level.packSolid setContents(1);
    level.packSolid iRateA();
    pos = (-15.8226 + 275.9 - 39 + 47, -2193, 466.125);
    level.packo = spawnTrigger(pos, 45);
    level.packo iRateA();
    level.packo setString("Press & Hold [{+activate}] To Buy Pack 'a' Punch Upgrade [Cost: 500]");
    for (;;) {
        level.packo waittill("trigger", i);
        weap = i getCurrentWeapon();
        current_weapon = i getCurrentWeapon();
        if (i useButtonPressed()) {
            if (!IsDefined(level.zombie_include_weapons[current_weapon]) || !IsDefined(level.zombie_include_weapons[current_weapon + "_upgraded_zm"])) {
                wait 1;
            } else {
                if (i.score >= 500) {
                    i playSound("cha_ching");
                    i.zombie_cost = 500;
                    i.score -= 500;
                    i takeWeapon(i getCurrentWeapon());
                    i giveWeapon(weap + "_upgraded_zm");
                    i freezeControls(true);
                    i playSound("packa_weap_upgrade");
                    i disableOffhandWeapons();
                    i disableWeaponCycling();
                    i allowLean(false);
                    i allowAds(false);
                    i allowSprint(false);
                    i allowProne(false);
                    i allowMelee(false);
                    fxOrg = spawn("script_model", level.pack.origin);
                    fxOrg setModel("tag_origin");
                    fxOrg.angles = (0, 270, 0);
                    fxOrg linkTo(self);
                    fx = playFxOnTag(level._effect["packapunch_fx"], fxOrg, "tag_origin");
                    fxOrg thread DeleteAfta10x();
                    if (i getStance() == "prone") {
                        i setStance("crouch");
                    }
                    i giveWeapon("zombie_knuckle_crack");
                    i switchToWeapon("zombie_knuckle_crack");
                    wait 3;
                    i enableOffhandWeapons();
                    i enableWeaponCycling();
                    i allowLean(true);
                    i allowAds(true);
                    i allowSprint(true);
                    i allowProne(true);
                    i allowMelee(true);
                    i playSound("packa_weap_ready");
                    i freezeControls(false);
                    i takeWeapon("zombie_knuckle_crack");
                    i switchToWeapon(weap + "_upgraded_zm");
                } else {
                    i playSound("plr_" + i getEntityNumber() + "_vox_nomoney_perk_0");
                    wait 1;
                }
            }
        }
    }
    wait 0.05;
}
PackaSong() {
    for (;;) {
        self playSound("mx_packa_jingle");
        wait 60;
    }
}
BuyAllPerksb() {
    pos = (-103.11 + 275.9 - 39 + 47, -2211, 466);
    trig = spawnTrigger(pos, 36);
    trig iRateA();
    trig setString("Press & Hold [{+activate}] To Buy All Perks [Cost: 100]");
    for (;;) {
        trig waittill("trigger", i);
        if (i useButtonPressed() && i.perks_bought == false) {
            cost = 100;
            if (i.score >= cost) {
                i.perks_bought = true;
                i playSound("cha_ching");
                i.zombie_cost = 100;
                i.score -= 100;
                i thread purchasePerks();
                wait 1;
            } else {
                i playSound("plr_" + i getEntityNumber() + "_vox_nomoney_perk_0");
                wait 1;
            }
        }
        if (i useButtonPressed() && i.perks_bought == true) {
            wait 1;
        }
    }
}
DeleteAfta10x() {
    wait 10;
    self delete();
}
BuyBowieKnife3() {
    pos = (71.7471 + 275.9 - 39 + 47, -2211, 466);
    trig = spawnTrigger(pos, 36);
    trig iRateA();
    trig setString("Press & Hold [{+activate}] To Buy Bowie Knife [Cost: 500]");
    for (;;) {
        trig waittill("trigger", i);
        if (i useButtonPressed() && i.dub_bought == false) {
            cost = 500;
            if (i.score >= cost) {
                i.dub_bought = true;
                i playSound("cha_ching");
                i.zombie_cost = 500;
                i.score -= 500;
                i thread giveBowie();
                wait 1;
            } else {
                i playSound("plr_" + i getEntityNumber() + "_vox_nomoney_perk_0");
                wait 1;
            }
        }
        if (i useButtonPressed() && i.dub_bought == true) {
            wait 1;
        }
    }
}
RayGunk() {
    pos = (412, -2115.33 + 20, 466);
    trig = spawnTrigger(pos, 17);
    trig iRateA();
    trig setString("Press & Hold [{+activate}] To Buy Ray Gun [Cost: 1000]");
    for (;;) {
        trig waittill("trigger", i);
        if (!i hasWeapon("ray_gun_zm")) {
            trig setString("Press & Hold [{+activate}] To Buy Ray Gun [Cost: 1000]");
            if (i useButtonPressed()) {
                cost = 1000;
                if (i.score >= cost) {
                    i playSound("cha_ching");
                    i.zombie_cost = 1000;
                    i.score -= 1000;
                    i giveWeapon("ray_gun_zm");
                    i switchToWeapon("ray_gun_zm");
                } else {
                    i playSound("plr_" + i getEntityNumber() + "_vox_nomoney_perk_0");
                    wait 1;
                }
            }
        } else {
            trig setString("");
        }
    }
}
Wunderwaffe3() {
    pos = (112, -2113.165, 466);
    trig = spawnTrigger(pos, 35);
    trig iRateA();
    trig setString("Press & Hold [{+activate}] To Buy Wunderwaffe DG-2 [Cost: 1000]");
    for (;;) {
        trig waittill("trigger", i);
        if (!i hasWeapon("tesla_gun_zm")) {
            trig setString("Press & Hold [{+activate}] To Buy Wunderwaffe DG-2 [Cost: 1000]");
            if (i useButtonPressed()) {
                cost = 1000;
                if (i.score >= cost) {
                    i playSound("cha_ching");
                    i.zombie_cost = 1000;
                    i.score -= 1000;
                    i giveWeapon("tesla_gun_zm");
                    i switchToWeapon("tesla_gun_zm");
                } else {
                    i playSound("plr_" + i getEntityNumber() + "_vox_nomoney_perk_0");
                    wait 1;
                }
            }
        } else {
            trig setString("");
        }
    }
}
MonkeyBomb3() {
    pos = (412, -2151 + 20, 466);
    trig = spawnTrigger(pos, 17);
    trig iRateA();
    trig setString("Press & Hold [{+activate}] To Buy ''The Reaper'' [Cost: 1000]");
    for (;;) {
        trig waittill("trigger", i);
        if (i useButtonPressed()) {
            cost = 1000;
            if (i.score >= cost) {
                i playSound("cha_ching");
                i.zombie_cost = 1000;
                i.score -= 1000;
                i giveWeapon("mp40_upgraded_zm");
                i switchToWeapon("mp40_upgraded_zm");
            } else {
                i playSound("plr_" + i getEntityNumber() + "_vox_nomoney_perk_0");
                wait 1;
            }
        }
    }
}
MaxAmmo3() {
    pos = (140, -2000, 466);
    trig = spawnTrigger(pos, 35);
    trig iRateA();
    trig setString("Press & Hold [{+activate}] To Buy Max Ammo [Cost: 1000]");
    for (;;) {
        trig waittill("trigger", i);
        if (i useButtonPressed()) {
            cost = 1000;
            if (i.score >= cost) {
                i playSound("cha_ching");
                i.zombie_cost = 1000;
                i.score -= 1000;
                primaryWeapons = self getWeaponsListPrimaries();
                for (x = 0; x < primaryWeapons.size; x++) {
                    self giveMaxAmmo(primaryWeapons[x]);
                    wait 0.05;
                }
                wait 1;
            } else {
                i playSound("plr_" + i getEntityNumber() + "_vox_nomoney_perk_0");
                wait 1;
            }
        }
    }
}
RandomPowerup3() {
 /*   pos = (409, -2000, 466);
    trig = spawnTrigger(pos, 35);
    trig iRateA();
    trig setString("Press & hold [{+activate}] to buy Random Power-Up [Cost: 1000]");
    for (;;) {
        trig waittill("trigger", i);
        if (i useButtonPressed()) {
            cost = 1000;
            if (i.score >= cost) {
                i playSound("cha_ching");
                i.zombie_cost = 1000;
                i.score -= 1000;
                Func[0] = maps\_zombiemode_powerups::nuke_powerup;
                Func[1] = maps\_zombiemode_powerups::double_points_powerup;
                Func[2] = maps\_zombiemode_powerups::full_ammo_powerup;
                Func[3] = maps\_zombiemode_powerups::insta_kill_powerup;
                Func[4] = maps\_zombiemode_powerups:start_carpenter;
                Funky = randomInt(Func.size);
                i thread[[Func[Funky]]](i);
                wait 1;
            } else {
                i playSound("plr_" + i getEntityNumber() + "_vox_nomoney_perk_0");
                wait 1;
            }
        }
    }*/
}
TeddyTrig3() {
    Teddy = spawn("script_model", (52.7608, -407.372, 35));
    Teddy setModel("zombie_teddybear");
    Teddy iRateA();
    playFxOnTag(LoadFx("misc/fx_zombie_powerup_on"), Teddy, "tag_origin");
    for (;;) {
        Teddy rotateYaw(360, 1, .5, .5);
        Teddy moveZ(30, 1, .5, .5);
        wait 1;
        Teddy rotateYaw(360, 1, .5, .5);
        Teddy moveZ(-30, 1, .5, .5);
        wait 1;
    }
}
TeddyTrap4() {
    pos = (52, -407, 10);
    Trig = spawnTrigger(pos, 40);
    Trig iRateA2();
    Trig setString("Press & Hold [{+activate}] To Use Teddy Trap");
    for (;;) {
        Trig waittill("trigger", i);
        if (i useButtonPressed()) {
            wait .1;
            if (i useButtonPressed() && i.is_zombie == false && isDefined(level.RateSpwndBack)) {
                level.iRateIsBuilding = true;
                i TeddyTrapSpawn3(Trig);
            }
        }
    }
}
TeddyTrapSpawn3(Trigger) {
    self.InRateBase = true;
    self enableInvulnerability();
    self enableHealthShield(true);
    Trigger setString("Teddy Trap ^1In Use");
    Tele[0] = self spawnSM((52, -407, 10), "tag_origin");
    Tele[0] thread RotateEnt3(360, 2);
    Tele[1] = self spawnSM(Tele[0].origin + (0, -40, 35), "zombie_teddybear");
    Tele[2] = self spawnSM(Tele[0].origin + (0, 40, 35), Tele[1].model);
    Tele[3] = self spawnSM(Tele[0].origin + (-40, 0, 35), Tele[1].model);
    Tele[4] = self spawnSM(Tele[0].origin + (40, 0, 35), Tele[1].model);
    for (i = 1; i <= Tele.size - 1; i++) {
        Tele[i] linkTo(Tele[0]);
        playFxOnTag(LoadFx("misc/fx_zombie_powerup_on"), Tele[i], "tag_origin");
    }
    self allowProne(false);
    self playerlinkTo(Tele[0]);
    Tele[0] moveZ(650, 3, 1, 1);
    self playSound("flytrap_spin");
    self playSound("flytrap_hit");
    self playSound("sam_fly_laugh");
    wait 3;
    Tele[0] moveTo((270, -2105, 466.125), 3, 1, 1);
    self playSound("shoot_off");
    wait 2.2;
    self allowStand(false);
    self allowSprint(false);
    self setStance("crouch");
    wait .8;
    self unlink();
    self allowStand(true);
    self allowSprint(true);
    self setStance("stand");
    self thread TeleportAfterTimeb();
    self allowJump(false);
    self allowProne(false);
    Tele[0] moveZ(100, 3, 1, 1);
    wait 3;
    for (i = 0; i <= 4; i++) {
        Tele[i] unlink();
        Tele[i] delete();
    }
    Trigger setString("Press & Hold [{+activate}] To Use Teddy Trap");
    level.iRateIsBuilding = undefined;
}
RotateEnt3(Yaw, Time) {
    for (;;) {
        self rotateYaw(Yaw, Time);
        wait Time;
    }
}
TeleportAfterTimeb() {
    if (!isDefined(self.InRateBase)) return;
    wait 5;
    if (!isDefined(self.InRateBase)) return;
    wait 5;
    if (!isDefined(self.InRateBase)) return;
    wait 5;
    if (!isDefined(self.InRateBase)) return;
    wait 5;
    if (!isDefined(self.InRateBase)) return;
    wait 5;
    if (!isDefined(self.InRateBase)) return;
    wait 5;
    if (!isDefined(self.InRateBase)) return;
    wait 5;
    if (!isDefined(self.InRateBase)) return;
    if (isDefined(self.InRateBase)) {
        Sound = StrTok("pa_audio_link_5|pa_audio_link_4|pa_audio_link_3|pa_audio_link_2|pa_audio_link_1", "|");
        for (i = 0; i <= Sound.size - 1; i++) {
            self playLocalSound(Sound[i]);
            wait 1;
        }
        self thread doTeleBackb();
    }
}
doTeleBackb() {
    self.InRateBase = undefined;
    self setElectrified(1.25);
    self shellShock("electrocution", 2.5);
    PlayFx(LoadFx("maps/zombie/fx_transporter_beam"), self.origin);
    PlayFx(LoadFx("maps/zombie/fx_transporter_pad_start"), self.origin);
    PlayFx(LoadFx("maps/zombie/fx_transporter_start"), self.origin);
    earthquake(2, 1, self.origin, 100);
    wait 2;
    self playSound("teleport_2d_fnt");
    TeleLink = [];
    image_room = getEnt("teleport_room_1", "targetname");
    if (IsDefined(image_room) && !IsDefined(self.revivetrigger)) {
        self setStance("stand");
        self disableOffHandWeapons();
        self disableWeapons();
        TeleLink = spawn("script_model", image_room.origin);
        TeleLink setModel("tag_origin");
        TeleLink.angles = image_room.angles;
        self playerlinkToAbsolute(TeleLink);
        self freezeControls(true);
    }
    wait 2;
    TeleLink delete();
    self unlink();
    self enableWeapons();
    self enableOffHandWeapons();
    self setOrigin((-65.2447, 315.793, 103.125));
    self setPlayerAngles((0, 270, 0));
    self shellShock("electrocution", 4);
    self allowJump(true);
    self allowProne(true);
    self freezeControls(false);
}
SkyBaseSolidsx() {
    Door = getEntArray("zombie_door", "targetname");
    Door[0].doors[0].origin = (443, -2085, 590);
    Door[0].doors[0] hide();
    Door[0].doors[0].angles = (0, 90, 0);
    Door[0].doors[1].origin = (443, -2180, 590);
    Door[0].doors[1] hide();
    Door[0].doors[1].angles = (0, 90, 0);
    Door[3].doors[0].origin = (95.5, -2045, 558.93);
    Door[3].doors[0] hide();
    Door[2].doors[0].origin = (100, -2195, 558.93);
    Door[2].doors[0] hide();
    Door[2].doors[0].angles = (0, -180, 0);
    Door[1].doors[0].origin = (150, -1982, 445);
    Door[1].doors[0] hide();
    Door[6].doors[0].origin = (150, -1985, 445);
    Door[6].doors[0] hide();
    Door[4].doors[0].origin = (135, -2255, 490);
    Door[4].doors[0] hide();
    Door[4].doors[1].origin = (410, -2255, 490);
    Door[4].doors[1] hide();
    Door[5].doors[0].origin = (210, -2255, 520);
    Door[5].doors[0] hide();
    Door[5].doors[1].origin = (335, -2255, 520);
    Door[5].doors[1] hide();
    Door[8].doors[0].origin = (350, -2270, 500);
    Door[8].doors[0] hide();
    Door[8].doors[0].angles = (0, 135, 0);
    Door[7].doors[0].origin = (426, -2190, 500);
    Door[7].doors[0] hide();
    Door[7].doors[0].angles = (0, 0, 90);
    Door[7].doors[1].origin = (426, -2255, 500);
    Door[7].doors[1] hide();
    Door[7].doors[1].angles = (0, 0, 90);
    tok = strTok("0 3 2 1 6 4 5 8 7", " ");
    for (m = 0; m < tok.size; m++) {
        Door[int(tok[m])].doors[0] connectPaths();
        Door[int(tok[m])].doors[0] solid();
    }
}
SkyBaseTurret1() {
    level.Turret = spawn("script_model", (268, -1990, 495));
    level.Turret.angles = (0, 90, 0);
    level.Turret setModel(getWeaponModel("zombie_30cal"));
    level.Turret.team = "allies";
    level.Turret iRateA();
    pos = (level.Turret.origin - (0, 20, 20));
    TurretTrig = spawnTrigger(pos, 25);
    TurretTrig iRateA();
    TurretTrig setString("Press [{+activate}] To Activate Auto-Turret [60 Seconds]");
    for (;;) {
        TurretTrig waittill("trigger", i);
        if (i useButtonPressed() && !IsDefined(level.TurrentInUse)) {
            TurretTrig setString("");
            level.TurretInUse = true;
            i thread AutoTurret1();
            wait(60);
            i.Turret rotateTo((0, 0, 0), 1, .5, .5);
            TurretTrig setString("Press [{+activate}] To Activate Auto-Turret [60 Seconds]");
            level.TurretInUse = undefined;
            i notify("TurretOver1");
            i.Turret notify("TurretOver1");
        }
    }
}
AutoTurret1() {
    level.Turret thread TurretThink1(self);
    level.Turret thread TurretLook1(self);
    level.Turret thread Shooting1(self);
}
TurretThink1(controller) {
    self endon("TurretOver1");
    controller endon("TurretOver1");
    for (;;) {
        level.zombie = get_closest_ai(self.origin, "axis");
        wait 1;
    }
}
TurretLook1(controller) {
    self endon("TurretOver1");
    controller endon("TurretOver1");
    for (;;) {
        self rotateTo(vectorToAngles(level.zombie.origin - self.origin), .75);
        wait 1;
    }
}
Shooting1(controller) {
    self endon("TurretOver1");
    controller endon("TurretOver1");
    for (;;) {
        magicBullet("zombie_30cal", self getTagOrigin("tag_flash"), level.zombie.origin + (0, 0, 30));
        wait(WeaponFireTime("zombie_30cal"));
    }
}
delWall() {
    brush_models = getEntArray("script_brushmodel", "classname");
    for (i = 0; i < brush_models.size; i++) {
        brush_models[i] notsolid();
    }
}
//BlueBerry's Skybase

BerrysBasex() {
    if (!IsDefined(level.BerryBaseSpwnd) && level.Small == false && level.BigBoy == false && level.BerryBase != true) {
        if (level.rainstarter == true) {
            if (isDefined(level.entitySpace)) return;
            level.entitySpace = true;
            level.BerryBaseSpwnd = true;
            self thread BerrysBasex1();
            self thread SpawnRefresh();
        }
    }
    if (!IsDefined(level.BerryBaseSpwnd) && level.Small == false && level.BigBoy == false && level.BerryBase != true) {
        if (level.Raindeletetime == true) {
            getPlayers()[0] notify("rain_sphere");
            if (isDefined(level.entitySpace)) return;
            level.entitySpace = true;
            level.BigBoy = true;
            level.BerryBaseSpwnd = true;
            self thread SpawnRefresh();
            self iPrintln("^1Deleting ^7Raining Models!");
            wait 7;
            self thread BerrysBasex1();
        }
    }
    if (!IsDefined(level.BerryBaseSpwnd) && level.BerryBase != true) {
        if (level.Small == true || level.BigBoy == true) {
            self playlocalsound("deny");
            self iPrintln("^1Error ^7Entity Limit Reached!");
        }
    } else {
        if (isDefined(level.BerryIsBuilding)) return;
        if (!IsDefined(level.BerryBaseSpwnd) && level.BerryBase == true) {
            level.BerryBaseBack = undefined;
            level thread BerryDelete2();
            level.BerryBaseSpwnd = true;
            level.BerryBase = false;
            self thread SpawnRefresh();
            self thread createProgressBar_Delete(3, "BlueBerry's Skybase Deleting!", 1, "BlueBerry's Skybase Deleted!");
            for (m = 0; m < getPlayers().size; m++) {
                player = getPlayers()[m];
                if (isDefined(player.InBerryBase)) {
                    player returnToSpawn();
                    player allowJump(true);
                    player allowProne(true);
                    player.InBerryBase = undefined;
                    if (!isDefined(player.menu["misc"]["godMode"])) player disableGodMode();
                    else if (isDefined(player.menu["misc"]["godMode"])) player enableGodMode();
                    player thread afterKillstreakProtection();
                }
            }
            wait 2.95;
            level.BerryBaseSpwnd = undefined;
            level thread BerryDelete();
            self thread SpawnRefresh();
        }
    }
}
BerrysBasex1() {
    level.BigBoy = true;
    level.BerryBase = true;
    level.BerryIsBuilding = true;
    self thread createProgressBar(10.19, "BlueBerry's Skybase Building!", 1, "BlueBerry's Skybase Built!");
    self thread BerryBaseEverything();
    wait .15;
    self thread SkybaseEntranceTriggerx();
    wait .15;
    self thread SkybaseExitTrigger();
    wait .15;
    self thread PackaPunchberry((0, 0, 40), (155, -470, 482));
    wait .15;
    self thread SkybaseWindowTriggerx();
    wait .15;
    self thread RandomBoxxber();
    wait .15;
    self thread PerkMachinexber();
}
BerryBaseEverything() {
    self thread SkybaseRingx((-236.375, -906.043, 200.693));
    wait .15;
    self thread SkybaseRingx((-236.375, -906.043, 280.693));
    wait .15;
    self thread SkybaseRingx((-236.375, -906.043, 360.693));
    wait .15;
    self thread SkybaseRingx((-236.375, -906.043, 440.693));
    wait .15;
    self thread SkybaseRingx((-236.375, -906.043, 520.693));
    wait .15;
    self thread SkybaseRingx((-236.375, -906.043, 600.693));
    wait .15;
    self thread SkybaseRing1x((-236.375, -906.043, 680.693));
    wait .15;
    self thread SkybaseRing2x((-236.375, -826.043, 680.693));
    wait .15;
    self thread SkybaseRing2x((-236.375, -746.043, 680.693));
    wait .15;
    self thread SkybaseRing2x((-236.375, -666.043, 680.693));
    wait .15;
    self thread SkybaseRing2x((-236.375, -586.043, 680.693));
    wait .15;
    self thread SkybaseRing2x((-236.375, -506.043, 680.693));
    wait .15;
    self thread SkybaseRing3x((-236.375, -466.043, 680.693));
    wait .15;
    self thread SkybaseRingx((-236.375, -466.043, 480.693));
    wait .15;
    self thread SkybaseRingx((-236.375, -466.043, 560.693));
    wait .15;
    self thread SkybaseRingx((-236.375, -466.043, 640.693));
    wait .15;
    level.secretRoomOpen = false;
    level.trig1_use = false;
    level.trig_use = false;
    a = "zombie_treasure_box";
    a BerryA();
    SM = "script_model";
    SM BerryA();
    level.Berry = spawn(SM, (45, -346, 480));
    level.Berry setModel(a);
    level.Berry BerryA();
    wait .15;
    level.Berry.angles = (0, 0, 0);
    level.Berry0 = spawn(SM, (45, -346, 496));
    level.Berry0 setModel(a);
    level.Berry0 BerryA();
    wait .15;
    level.Berry0.angles = (0, 0, 0);
    level.Berry1 = spawn(SM, (45, -346, 512));
    level.Berry1 setModel(a);
    level.Berry1 BerryA();
    wait .15;
    level.Berry1.angles = (0, 0, 0);
    level.Berry2 = spawn(SM, (45, -346, 523.125));
    level.Berry2 setModel(a);
    level.Berry2 BerryA();
    wait .15;
    level.Berry2.angles = (0, 0, 0);
    level.Berry = spawn("script_model", (-62, -554, 480));
    level.Berry setModel("zombie_vending_sleight_on");
    level.Berry.angles = (0, 90, 0);
    level.Berry BerryA();
    wait .15;
    level.Berry6 = spawn(SM, (105.734, -360, 520.125));
    level.Berry6 setModel("zombie_power_lever_handle");
    level.Berry6.angles = (0, 0, 0);
    level.Berry6 BerryA();
    level.Berry = spawn("trigger_radius", (0, 0, 0), 0, 50, 25);
    level.Berry.origin = ((27, -340, 460));
    level.Berry setContents(1);
    level.Berry BerryA();
    level.Berry = spawn("trigger_radius", (0, 0, 0), 0, 50, 25);
    level.Berry.origin = ((57, -340, 460));
    level.Berry setContents(1);
    level.Berry BerryA();
    level.Berry = spawn("trigger_radius", (0, 0, 0), 0, 50, 25);
    level.Berry.origin = ((87, -340, 460));
    level.Berry setContents(1);
    level.Berry BerryA();
    level.Berry = spawn("trigger_radius", (0, 0, 0), 0, 50, 25);
    level.Berry.origin = ((117, -340, 460));
    level.Berry setContents(1);
    level.Berry BerryA();
    level.Berry = spawn("trigger_radius", (0, 0, 0), 0, 50, 25);
    level.Berry.origin = ((27, -340, 510));
    level.Berry setContents(1);
    level.Berry BerryA();
    level.Berry = spawn("trigger_radius", (0, 0, 0), 0, 50, 25);
    level.Berry.origin = ((57, -340, 510));
    level.Berry setContents(1);
    level.Berry BerryA();
    level.Berry = spawn("trigger_radius", (0, 0, 0), 0, 50, 25);
    level.Berry.origin = ((87, -340, 510));
    level.Berry setContents(1);
    level.Berry BerryA();
    level.Berry = spawn("trigger_radius", (0, 0, 0), 0, 50, 25);
    level.Berry.origin = ((117, -340, 510));
    level.Berry setContents(1);
    level.Berry BerryA();
    level.Berry = spawn("trigger_radius", (0, 0, 0), 0, 50, 55);
    level.Berry.origin = ((-270, -470, 480));
    level.Berry setContents(1);
    level.Berry BerryA();
    level.Berry = spawn("trigger_radius", (0, 0, 0), 0, 50, 55);
    level.Berry.origin = ((-90, -530, 460));
    level.Berry setContents(1);
    level.Berry BerryA();
    level.Berry = spawn("trigger_radius", (0, 0, 0), 0, 50, 55);
    level.Berry.origin = ((-120, -530, 460));
    level.Berry setContents(1);
    level.Berry BerryA();
    level.Berry = spawn("trigger_radius", (0, 0, 0), 0, 50, 55);
    level.Berry.origin = ((-150, -530, 460));
    level.Berry setContents(1);
    level.Berry BerryA();
    level.Berry = spawn("trigger_radius", (0, 0, 0), 0, 50, 55);
    level.Berry.origin = ((-180, -530, 460));
    level.Berry setContents(1);
    level.Berry BerryA();
    level.Berry = spawn("trigger_radius", (0, 0, 0), 0, 50, 55);
    level.Berry.origin = ((-210, -530, 460));
    level.Berry setContents(1);
    level.Berry BerryA();
    level.Berry = spawn("trigger_radius", (0, 0, 0), 0, 50, 55);
    level.Berry.origin = ((-240, -530, 460));
    level.Berry setContents(1);
    level.Berry BerryA();
    level.Berry = spawn("trigger_radius", (0, 0, 0), 0, 50, 55);
    level.Berry.origin = ((-88, -427, 460));
    level.Berry setContents(1);
    level.Berry BerryA();
    level.Berry = spawn("trigger_radius", (0, 0, 0), 0, 50, 55);
    level.Berry.origin = ((-88, -427, 490));
    level.Berry setContents(1);
    level.Berry BerryA();
    level.Berry = spawn("trigger_radius", (0, 0, 0), 0, 50, 55);
    level.Berry.origin = ((-90, -530, 490));
    level.Berry setContents(1);
    level.Berry BerryA();
    level.Berry = spawn("trigger_radius", (0, 0, 0), 0, 50, 55);
    level.Berry.origin = ((-120, -530, 490));
    level.Berry setContents(1);
    level.Berry BerryA();
    level.Berry = spawn("trigger_radius", (0, 0, 0), 0, 50, 55);
    level.Berry.origin = ((-150, -530, 490));
    level.Berry setContents(1);
    level.Berry BerryA();
    level.Berry = spawn("trigger_radius", (0, 0, 0), 0, 50, 55);
    level.Berry.origin = ((-180, -530, 490));
    level.Berry setContents(1);
    level.Berry BerryA();
    level.Berry = spawn("trigger_radius", (0, 0, 0), 0, 50, 55);
    level.Berry.origin = ((-210, -530, 490));
    level.Berry setContents(1);
    level.Berry BerryA();
    level.Berry = spawn("trigger_radius", (0, 0, 0), 0, 50, 55);
    level.Berry.origin = ((-240, -530, 490));
    level.Berry setContents(1);
    level.Berry BerryA();
    pos = (105.734, -360, 520.125);
    FXM[1] = spawnSM(pos, "tag_origin", (-90, 0, 0));
    playFxOnTag(loadFx("misc/fx_zombie_powerup_on"), FXM[1], "tag_origin");
    FXM[1] BerryA();
    self thread SkybaseFloorx((-69, -380, 480));
    wait .15;
    self thread SkybaseFloorMiddlex((-237, -470, 480));
    wait .15;
    self thread SkybaseFloorx((-69, -560, 480));
    wait .15;
    self thread SkybaseFloorx((-69, -380, 592));
    wait .15;
    self thread SkybaseFloorx((-69, -470, 592));
    wait .15;
    self thread SkybaseFloorx((-69, -560, 592));
    Solid = spawn("trigger_radius", (0, 0, 0), 0, 50, 55);
    Solid BerryA();
    Solid.origin = ((-47, -600, 480));
    Solid setContents(1);
    Solid = spawn("trigger_radius", (0, 0, 0), 0, 50, 55);
    Solid.origin = ((-17, -600, 480));
    Solid setContents(1);
    Solid BerryA();
    Solid = spawn("trigger_radius", (0, 0, 0), 0, 50, 55);
    Solid.origin = ((27, -600, 480));
    Solid setContents(1);
    Solid BerryA();
    Solid = spawn("trigger_radius", (0, 0, 0), 0, 50, 55);
    Solid.origin = ((57, -600, 480));
    Solid setContents(1);
    Solid BerryA();
    Solid = spawn("trigger_radius", (0, 0, 0), 0, 50, 55);
    Solid.origin = ((87, -600, 480));
    Solid setContents(1);
    Solid BerryA();
    Solid = spawn("trigger_radius", (0, 0, 0), 0, 50, 55);
    Solid.origin = ((117, -600, 480));
    Solid setContents(1);
    Solid BerryA();
    Solid = spawn("trigger_radius", (0, 0, 0), 0, 50, 55);
    Solid.origin = ((147, -600, 480));
    Solid setContents(1);
    Solid BerryA();
    Solid = spawn("trigger_radius", (0, 0, 0), 0, 50, 55);
    Solid.origin = ((177, -600, 480));
    Solid setContents(1);
    Solid BerryA();
    Solid = spawn("trigger_radius", (0, 0, 0), 0, 50, 55);
    Solid.origin = ((182, -590, 480));
    Solid setContents(1);
    Solid BerryA();
    Solid = spawn("trigger_radius", (0, 0, 0), 0, 50, 55);
    Solid.origin = ((182, -560, 480));
    Solid setContents(1);
    Solid BerryA();
    Solid = spawn("trigger_radius", (0, 0, 0), 0, 50, 55);
    Solid.origin = ((182, -530, 480));
    Solid setContents(1);
    Solid BerryA();
    Solid = spawn("trigger_radius", (0, 0, 0), 0, 50, 55);
    Solid.origin = ((182, -500, 480));
    Solid setContents(1);
    Solid BerryA();
    Solid = spawn("trigger_radius", (0, 0, 0), 0, 50, 55);
    Solid.origin = ((182, -470, 480));
    Solid setContents(1);
    Solid BerryA();
    Solid = spawn("trigger_radius", (0, 0, 0), 0, 50, 55);
    Solid.origin = ((182, -440, 480));
    Solid setContents(1);
    Solid BerryA();
    Solid = spawn("trigger_radius", (0, 0, 0), 0, 50, 55);
    Solid.origin = ((182, -410, 480));
    Solid setContents(1);
    Solid BerryA();
    Solid = spawn("trigger_radius", (0, 0, 0), 0, 50, 55);
    Solid.origin = ((182, -380, 480));
    Solid setContents(1);
    Solid BerryA();
    Solid = spawn("trigger_radius", (0, 0, 0), 0, 50, 55);
    Solid.origin = ((-47, -340, 480));
    Solid setContents(1);
    Solid BerryA();
    Solid = spawn("trigger_radius", (0, 0, 0), 0, 50, 55);
    Solid.origin = ((-17, -340, 480));
    Solid setContents(1);
    Solid BerryA();
    Solid = spawn("trigger_radius", (0, 0, 0), 0, 50, 55);
    Solid.origin = ((147, -340, 480));
    Solid setContents(1);
    Solid BerryA();
    Solid = spawn("trigger_radius", (0, 0, 0), 0, 50, 55);
    Solid.origin = ((177, -340, 480));
    Solid setContents(1);
    Solid BerryA();
    Solid = spawn("trigger_radius", (0, 90, 0), 0, 50, 55);
    Solid.origin = ((-82, -380, 480));
    Solid setContents(1);
    Solid BerryA();
    Solid = spawn("trigger_radius", (0, 90, 0), 0, 50, 55);
    Solid.origin = ((-82, -470, 540));
    Solid setContents(1);
    Solid BerryA();
    Solid = spawn("trigger_radius", (0, 0, 0), 0, 50, 55);
    Solid.origin = ((-62, -554, 480));
    Solid setContents(1);
    Solid BerryA();
    self thread SkybaseWallx((-47, -594, 480));
    wait .15;
    self thread SkybaseWallx((-47, -594, 496));
    wait .15;
    self thread SkybaseWallx((-47, -594, 512));
    wait .15;
    self thread SkybaseWallx((-47, -594, 528));
    wait .15;
    self thread SkybaseWallx((-47, -594, 544));
    wait .15;
    self thread SkybaseWallx((-47, -594, 560));
    wait .15;
    self thread SkybaseWallx((-47, -594, 576));
    wait .15;
    self thread SkybaseWall2x((45, -346, 576));
    wait .15;
    self thread SkybaseWall2x((45, -346, 560));
    wait .15;
    self thread SkybaseWall2x((45, -346, 544));
    wait .15;
    self thread SkybaseWall2x((45, -346, 536));
    wait .15;
    self thread SkybaseWall1x((-47, -346, 480));
    wait .15;
    self thread SkybaseWall1x((-47, -346, 496));
    wait .15;
    self thread SkybaseWall1x((-47, -346, 512));
    wait .15;
    self thread SkybaseWall1x((-47, -346, 528));
    wait .15;
    self thread SkybaseWall1x((-47, -346, 544));
    wait .15;
    self thread SkybaseWall1x((-47, -346, 560));
    wait .15;
    self thread SkybaseWall1x((-47, -346, 576));
    wait .15;
    self thread SkybaseSideWallBack1x((-82, -380, 480));
    wait .15;
    self thread SkybaseSideWallBack1x((-82, -380, 496));
    wait .15;
    self thread SkybaseSideWallBack1x((-82, -380, 512));
    wait .15;
    self thread SkybaseSideWallBack1x((-82, -380, 528));
    wait .15;
    self thread SkybaseSideWallBack1x((-82, -380, 544));
    wait .15;
    self thread SkybaseSideWallBack1x((-82, -380, 560));
    wait .15;
    self thread SkybaseSideWallBack1x((-82, -380, 576));
    wait .15;
    self thread SkybaseSideWallFrontx((182, -470, 480));
    wait .15;
    self thread SkybaseSideWallFrontx((182, -470, 496));
    wait .15;
    self thread SkybaseSideWallFrontx((182, -470, 512));
    wait .15;
    self thread SkybaseSideWallFrontx((182, -470, 528));
    wait .15;
    self thread SkybaseSideWallFrontx((182, -470, 544));
    wait .15;
    self thread SkybaseSideWallFrontx((182, -470, 560));
    wait .15;
    self thread SkybaseSideWallFrontx((182, -470, 576));
    wait .15;
    self thread SkybaseSideWallFrontx((-82, -470, 528));
    wait .15;
    self thread SkybaseSideWallFrontx((-82, -470, 544));
    wait .15;
    self thread SkybaseSideWallFrontx((-82, -470, 560));
    wait .15;
    self thread SkybaseSideWallFrontx((-82, -470, 576));
    wait .15;
    self thread SkybaseSideWallBack1x((-82, -560, 480));
    wait .15;
    self thread SkybaseSideWallBack1x((-82, -560, 496));
    wait .15;
    self thread SkybaseSideWallBack1x((-82, -560, 512));
    wait .15;
    self thread SkybaseSideWallBack1x((-82, -560, 528));
    wait .15;
    self thread SkybaseSideWallBack1x((-82, -560, 544));
    wait .15;
    self thread SkybaseSideWallBack1x((-82, -560, 560));
    wait .15;
    self thread SkybaseSideWallBack1x((-82, -560, 576));
    self thread SkybaseBoxy((34, -470, 480));
    self thread SkybaseBoxLidy((46, -470, 498));
    self thread TeleBaseber();
    level.BerryBaseBack = true;
    level.BerryIsBuilding = undefined;
    level.BerryBaseSpwnd = undefined;
    self thread SpawnRefresh();
}
BerryDelete() {
    level.BerryIsBuilding = true;
    for (m = 0; m < level.BerryArray.size; m++) level.BerryArray[m] delete();
    level.BerryArray = undefined;
    level.entitySpace = undefined;
    level.BerryIsBuilding = undefined;
    level.Raindeletetime = false;
    level.rainstarter = true;
    level.BigBoy = false;
}
BerryDelete2() {
    for (m = 0; m < level.BerryArray2.size; m++) level.BerryArray2[m] delete();
    level.BerryArray2 = undefined;
}
BerryA() {
    if (!isDefined(level.BerryArray)) level.BerryArray = [];
    m = level.BerryArray.size;
    level.BerryArray[m] = self;
}
BerryA2() {
    if (!isDefined(level.BerryArray2)) level.BerryArray2 = [];
    m = level.BerryArray2.size;
    level.BerryArray2[m] = self;
}
TeleBaseber() {
    pos = (-165, 299.313, 110);
    ligtTrig = spawnTrigger(pos, 35);
    ligtTrig BerryA();
    ligtTrig setString("Press & Hold [{+activate}] To Teleport To BlueBerry's Skybase Entrance");
    pos = (-175.854, 299.313, 141.114);
    FXM[1] = spawnSM(pos, "tag_origin", (-90, 0, 0));
    playFxOnTag(loadFx("misc/fx_zombie_powerup_on"), FXM[1], "tag_origin");
    FXM[1] BerryA2();
    for (;;) {
        ligtTrig waittill("trigger", i);
        if (i useButtonPressed()) {
            wait .1;
            if (i useButtonPressed() && isDefined(level.BerryBaseBack)) {
                i berrytelep();
                wait 1;
            }
        }
        wait 0.05;
    }
}
berrytelep() {
    self setElectrified(1.25);
    self shellShock("electrocution", 2.5);
    playFx(LoadFx("maps/zombie/fx_transporter_beam"), self.origin);
    playFx(LoadFx("maps/zombie/fx_transporter_pad_start"), self.origin);
    playFx(LoadFx("maps/zombie/fx_transporter_start"), self.origin);
    earthquake(2, 1, self.origin, 100);
    wait 2;
    self playSound("teleport_2d_fnt");
    TeleLink = [];
    image_room = getEnt("teleport_room_1", "targetname");
    if (IsDefined(image_room) && !IsDefined(self.revivetrigger)) {
        self setStance("stand");
        self disableOffHandWeapons();
        self disableWeapons();
        TeleLink = spawn("script_model", image_room.origin);
        TeleLink setModel("tag_origin");
        TeleLink.angles = image_room.angles;
        self playerlinkToAbsolute(TeleLink);
        self freezeControls(true);
    }
    wait 2;
    TeleLink delete();
    self unlink();
    self enableWeapons();
    self enableOffHandWeapons();
    self setOrigin((-357.757, -909.63, 199.125));
    self setPlayerAngles((0, 270, 0));
    self shellShock("electrocution", 2);
    self allowJump(true);
    self allowProne(true);
    if (self.GodModeIsOn == false) {
        self disableInvulnerability();
        self enableHealthShield(false);
    } else {
        self enableInvulnerability();
        self enableHealthShield(true);
    }
    self freezeControls(false);
}
PerkMachinexber() {
    pos = (-40, -554, 480);
    level.perk = spawnTrigger(pos, 40);
    level.perk BerryA();
    level.perk setString("Press [{+activate}] For All Perks & Bowie Knife [Cost: 500]");
    for (;;) {
        level.perk waittill("trigger", i);
        if (i useButtonPressed()) {
            if (!IsDefined(i.perks_red)) {
                if (i.score >= 500) {
                    i.perks_bought = true;
                    i.perks_red = true;
                    i.score -= 500;
                    gun = self getCurrentWeapon();
                    weapon = "zombie_perk_bottle_revive";
                    i takeweapon(gun);
                    i giveweapon(weapon);
                    i switchtoweapon(weapon);
                    wait 2.5;
                    i setClientDvar("perk_weapSpreadMultiplier", "0.001");
                    if (!i hasPerk("specialty_armorvest")) {
                        i setPerk("specialty_armorvest");
                        i thread perkHud("specialty_juggernaut_zombies", "specialty_armorvest");
                    }
                    if (!i hasPerk("specialty_fastreload")) {
                        i setPerk("specialty_fastreload");
                        i thread perkHud("specialty_fastreload_zombies", "specialty_fastreload");
                    }
                    if (!i hasPerk("specialty_rof")) {
                        i setPerk("specialty_rof");
                        i thread perkHud("specialty_doubletap_zombies", "specialty_rof");
                    }
                    if (!i hasPerk("specialty_quickrevive")) {
                        i setPerk("specialty_quickrevive");
                        i thread perkHud("specialty_quickrevive_zombies", "specialty_quickrevive");
                    }
                    i setPerk("specialty_flak_jacket");
                    i setPerk("specialty_quieter");
                    i setPerk("specialty_holdbreath");
                    i setPerk("specialty_bulletpenetration");
                    i setPerk("specialty_longersprint");
                    i setPerk("specialty_altmelee");
                    i setPerk("specialty_bulletdamage");
                    i setPerk("specialty_detectexplosive");
                    i thread Revivesber();
                    i thread StaminUpber();
                    i takeweapon(weapon);
                    i giveweapon(gun);
                    i switchtoweapon(gun);
                } else {
                    i playSound("plr_" + i getEntityNumber() + "_vox_nomoney_perk_0");
                }
            } else {
                i iPrintln("You already Have all Perks");
                wait 1;
            }
        }
    }
}
Revivesber() {
    while (true) {
        players = getPlayers();
        for (j = 0; j < players.size; j++) {
            if (players[j] hasPerk("specialty_quieter")) {
                players[j] waittill_any("player_downed", "second_chance");
                players[j] giveWeapon("m1911lh_upgraded_zm");
                players[j] switchToWeapon("m1911lh_upgraded_zm");
                players[j] iprintlnbold("You Have A Second Chance");
                wait 10;
                players[j] maps\_laststand::revive_force_revive(self);
                players[j] iprintlnbold("Now Run");
            }
        }
        wait(0.1);
    }
}
StaminUpber() {
    while (true) {
        players = getPlayers();
        for (j = 0; j < players.size; j++) {
            if (players[j] hasPerk("specialty_longersprint")) {
                players[j] setMoveSpeedScale(1.3);
            }
        }
        wait(2);
    }
}
PackaPunchberry(Rise, Origin) {
    current_weapon = self getCurrentWeapon();
    pos = (Origin - (30, 0, 0));
    level.Ass = spawnTrigger(pos, 45);
    level.Ass BerryA();
    level.Ass setString("Press & Hold [{+activate}] To Buy Pack 'a' Punch Upgrade [Cost: 1000]");
    Odd = spawn("trigger_radius", (0, 0, 0), 1, 40, 100);
    Odd.origin = Origin;
    Odd setContents(1);
    Odd BerryA();
    Packz = spawn("script_model", Origin);
    Packz setModel("zombie_vending_packapunch_on");
    Packz.angles = (0, -90, 0);
    Packz BerryA();
    weapon = "zombie_knuckle_crack";
    for (;;) {
        level.Ass waittill("trigger", i);
        Weap = i getCurrentWeapon();
        if (i.bowieing == false && i.perking == false && !IsSubStr(Weap, "_upgraded_zm") && !i hasWeapon("zombie_knuckle_crack")) {
            level.Ass setString("Press & Hold [{+activate}] To Buy Pack 'a' Punch Upgrade [Cost: 1000]");
            if (i useButtonPressed()) {
                if (i.PaPingB == false && i.score >= 1000 && !IsSubStr(Weap, "_upgraded_zm") && !IsSubStr(Weap, "asp_zm") && !IsSubStr(Weap, "defaultweapon") && !IsSubStr(Weap, "colt_dirty_harry") && !IsSubStr(Weap, "zombie_melee")) {
                    i.PaPingB = true;
                    i freezeControls(true);
                    i.score -= 1000;
                    gun = i getCurrentWeapon();
                    forward = anglesToForward(i.angles);
                    interact_pos = i.origin + Rise;
                    worldgun = spawn("script_model", interact_pos);
                    worldgun.angles = self.angles;
                    worldgun setModel(getWeaponModel(gun));
                    i takeweapon(gun);
                    i giveweapon(weapon);
                    i switchtoweapon(weapon);
                    PlayFx(level._effect["packapunch_fx"], Packz.origin, (0, 0, 0));
                    worldgun rotateto(i.angles + (0, 0, 0), 0.35, 0, 0);
                    wait(0.5);
                    worldgun moveto(Packz.origin + Rise, 1, 0, 0);
                    Packz playsound("packa_weap_upgrade");
                    wait(0.35);
                    worldgun delete();
                    wait(3);
                    Packz playsound("packa_weap_ready");
                    worldgun = spawn("script_model", packz.origin + Rise);
                    worldgun.angles = i.angles + (0, 0, 0);
                    worldgun setModel(getWeaponModel(gun + "_upgraded_zm"));
                    worldgun moveto(interact_pos, 1, 0, 0);
                    i takeweapon(weapon);
                    i freezeControls(false);
                    wait(1.5);
                    worldgun delete();
                    i giveweapon(gun + "_upgraded_zm");
                    i switchtoweapon(gun + "_upgraded_zm");
                    i.PaPingB = false;
                    wait .1;
                } else {
                    i playSound("plr_" + i getEntityNumber() + "_vox_nomoney_perk_0");
                }
            }
        } else {
            level.Ass setString("");
        }
    }
}
RandomBoxxber() {
    pos = (27, -468, 482);
    level.box = spawnTrigger(pos, 42);
    level.box BerryA();
    level.box setString("Press [{+activate}] For a Random Weapon [Cost: 500]");
    for (;;) {
        level.box waittill("trigger", i);
        if (i useButtonPressed()) {
            if (i.score >= 500) {
                i.score -= 500;
                i.gunList = getArrayKeys(level.zombie_weapons);
                i playLocalSound("lid_open");
                i playLocalSound("music_box");
                i giveWeapon("zombie_knuckle_crack");
                i switchToWeapon("zombie_knuckle_crack");
                wait 3.5;
                i takeWeapon("zombie_knuckle_crack");
                i.PickedWeapon = randomInt(i.gunList.size);
                i giveWeapon(i.gunList[i.PickedWeapon], 0);
                i switchToWeapon(i.gunList[i.PickedWeapon]);
                i playLocalSound("lid_close");
            } else {
                i playSound("plr_" + i getEntityNumber() + "_vox_nomoney_perk_0");
            }
        }
        wait .1;
    }
}
Boxranxx() {
    self.gunList = getArrayKeys(level.zombie_weapons);
    self playLocalSound("lid_open");
    self playLocalSound("music_box");
    wait 5;
    self.PickedWeapon = randomInt(self.gunList.size);
    self giveWeapon(self.gunList[self.PickedWeapon], 0);
    self switchToWeapon(self.gunList[self.PickedWeapon]);
    self playLocalSound("lid_close");
}
SkybaseWindowTriggerx() {
    pos = (105.734, -370, 490);
    level.trig = spawnTrigger(pos, 29);
    level.trig BerryA();
    level.trig setString("Press [{+activate}] To ^2Open^7/^1Close ^7The Window");
    for (;;) {
        level.trig waittill("trigger", i);
        if (i useButtonPressed() && level.secretRoomOpen == false && level.trig1_use == false) {
            level.trig_use = true;
            level.secretRoomOpen = true;
            level.Berry6 rotateroll(180, .7);
            level.Berry moveTo(level.Berry.origin + (0, 0, 55), 1.5);
            level.Berry0 moveTo(level.Berry0.origin + (0, 0, 55), 1.5);
            level.Berry1 moveTo(level.Berry1.origin + (0, 0, 55), 1.5);
            level.Berry2 moveTo(level.Berry2.origin + (0, 0, 55), 1.5);
            i playsound("door_slide_open");
            wait 2;
            level.trig_use = false;
        }
        if (i useButtonPressed() && level.secretRoomOpen == true && level.trig1_use == false) {
            level.trig_use = true;
            level.secretRoomOpen = false;
            level.Berry6 rotateroll(-180, .7);
            level.Berry moveTo(level.Berry.origin + (0, 0, -55), 1.5);
            level.Berry0 moveTo(level.Berry0.origin + (0, 0, -55), 1.5);
            level.Berry1 moveTo(level.Berry1.origin + (0, 0, -55), 1.5);
            level.Berry2 moveTo(level.Berry2.origin + (0, 0, -55), 1.5);
            i playsound("door_slide_open");
            wait 2;
            level.trig_use = false;
        }
    }
}
SkybaseEntranceTriggerx() {
    pos = (-236.375, -906.043, 220);
    level.ent = spawnTrigger(pos, 40);
    level.ent BerryA2();
    level.ent setString("Press [{+activate}] To Enter The Skybase");
    for (;;) {
        level.ent waittill("trigger", i);
        if (i useButtonPressed() && !isDefined(level.BerryIsBuilding)) {
            wait .1;
            if (i useButtonPressed() && i.is_zombie == false && i.AlreadyBeingUsed == 1 && isDefined(level.BerryBaseBack)) {
                level.BerryIsBuilding = true;
                i thread EnterTheBasex();
                wait 1;
            }
        }
    }
}
SkybaseExitTrigger() {
    pos = (-236.375, -466.043, 490);
    level.exit = spawnTrigger(pos, 40);
    level.exit BerryA();
    level.exit setString("Press [{+activate}] To Exit The Skybase");
    for (;;) {
        level.exit waittill("trigger", i);
        if (i useButtonPressed() && !isDefined(level.BerryIsBuilding)) {
            wait .1;
            if (i useButtonPressed() && i.is_zombie == false && i.AlreadyBeingUsed == 1 && isDefined(level.BerryBaseBack)) {
                level.BerryIsBuilding = true;
                i thread ExitTheBasex();
                wait 1;
            }
        }
    }
}
EnterTheBasex() {
    self.InBerryBase = true;
    self.AlreadyBeingUsed = 0;
    self enableHealthShield(true);
    self allowJump(false);
    self allowProne(false);
    self enableInvulnerability();
    self setStance("stand");
    self.Launcher = spawn("script_origin", (-236.375, -906.043, 230.693));
    self playerlinkto(self.Launcher);
    self.Launcher moveto((-236.375, -906.043, 630.693), 2.5, 1, 1);
    wait 2.5;
    self.Launcher moveto((-236.375, -466.043, 630.693), 2.5, 1, 1);
    self.Launcher waittill("movedone");
    self.Launcher delete();
    self unlink();
    self.AlreadyBeingUsed = 1;
    level.BerryIsBuilding = undefined;
}
ExitTheBasex() {
    self.InBerryBase = undefined;
    self.AlreadyBeingUsed = 0;
    self setStance("stand");
    self allowJump(true);
    self allowProne(true);
    self.Launcher = spawn("script_origin", (-236.375, -466.043, 520.693));
    self playerlinkto(self.Launcher);
    self.Launcher moveto((-236.375, -466.043, 630.693), 2.5, 1, 1);
    self.Launcher waittill("movedone");
    self.Launcher moveto((-236.375, -906.043, 630.693), 2.5, 1, 1);
    self.Launcher waittill("movedone");
    self.Launcher moveto((-236.375, -906.043, 240.693), 2.5, 1, 1);
    self.Launcher waittill("movedone");
    self.Launcher delete();
    self unlink();
    self enableHealthShield(true);
    self enableInvulnerability();
    self.AlreadyBeingUsed = 1;
    level.BerryIsBuilding = undefined;
}
SkybaseRingx(origin) {
    for (i = 0; i < 1; i++) {
        wait .15;
        Berry = spawn("script_model", (origin[0] + (i * 87), origin[1], origin[2]));
        Berry BerryA();
        Berry.angles = (0, 0, 0);
        Berry setmodel("zombie_teleporter_mainframe_ring1");
        self thread RotateThatx(Berry);
        Berry BerryA();
    }
}
SkybaseRing1x(origin) {
    for (i = 0; i < 1; i++) {
        wait .15;
        Berry = spawn("script_model", (origin[0] + (i * 87), origin[1], origin[2]));
        Berry.angles = (45, -90, 0);
        Berry setmodel("zombie_teleporter_mainframe_ring1");
        Berry BerryA();
    }
}
SkybaseRing2x(origin) {
    for (i = 0; i < 1; i++) {
        wait .15;
        Berry = spawn("script_model", (origin[0] + (i * 40), origin[1], origin[2]));
        Berry.angles = (90, 90, 0);
        Berry setmodel("zombie_teleporter_mainframe_ring1");
        Berry BerryA();
    }
}
SkybaseRing3x(origin) {
    for (i = 0; i < 1; i++) {
        wait .15;
        Berry = spawn("script_model", (origin[0] + (i * 87), origin[1], origin[2]));
        Berry.angles = (-45, -90, 0);
        Berry setmodel("zombie_teleporter_mainframe_ring1");
        Berry BerryA();
    }
}
SkybaseFloorMiddlex(origin) {
    for (i = 0; i < 19; i++) {
        wait .15;
        model = spawn("script_model", (origin[0] + (i * 24), origin[1], origin[2]));
        model.angles = (0, 90, 0);
        model setmodel("zombie_treasure_box_lid");
        model BerryA();
    }
}
SkybaseFloorx(origin) {
    for (i = 0; i < 12; i++) {
        wait .15;
        model = spawn("script_model", (origin[0] + (i * 24), origin[1], origin[2]));
        model.angles = (0, 90, 0);
        model setmodel("zombie_treasure_box_lid");
        model BerryA();
    }
}
SkybaseWallx(origin) {
    for (i = 0; i < 3; i++) {
        wait .15;
        model = spawn("script_model", (origin[0] + (i * 87), origin[1], origin[2]));
        model.angles = (0, 0, 0);
        model setmodel("zombie_treasure_box");
        model BerryA();
    }
}
SkybaseWall2x(origin) {
    for (i = 0; i < 1; i++) {
        wait .15;
        model = spawn("script_model", (origin[0], origin[1], origin[2] + (i * 16)));
        model.angles = (0, 0, 0);
        model setmodel("zombie_treasure_box");
        model BerryA();
    }
}
SkybaseWall1x(origin) {
    for (i = 0; i < 2; i++) {
        wait .15;
        model = spawn("script_model", (origin[0] + (i * 185), origin[1], origin[2]));
        model.angles = (0, 0, 0);
        model setmodel("zombie_treasure_box");
        model BerryA();
    }
}
SkybaseSideWallBack1x(origin) {
    for (i = 0; i < 2; i++) {
        wait .15;
        model = spawn("script_model", (origin[0] + (i * 265), origin[1], origin[2]));
        model.angles = (0, 90, 0);
        model setmodel("zombie_treasure_box");
        model BerryA();
    }
}
SkybaseSideWallFrontx(origin) {
    for (i = 0; i < 1; i++) {
        wait .15;
        model = spawn("script_model", (origin[0] + (i * 265), origin[1], origin[2]));
        model.angles = (0, 90, 0);
        model setmodel("zombie_treasure_box");
        model BerryA();
    }
}
SkybaseBoxy(origin) {
    for (i = 0; i < 1; i++) {
        wait .15;
        model = spawn("script_model", (origin[0] + (i * 265), origin[1], origin[2]));
        model.angles = (0, 90, 0);
        model setmodel("zombie_treasure_box");
        model BerryA();
    }
}
SkybaseBoxLidy(origin) {
    for (i = 0; i < 1; i++) {
        wait .15;
        model = spawn("script_model", (origin[0], origin[1], origin[2]));
        model.angles = (0, 90, 0);
        model setmodel("zombie_treasure_box_lid");
        model BerryA();
    }
}
RotateThatx(Berry) {
    for (;;) {
        Berry rotateYaw(360, 1.5);
        Berry BerryA();
        wait 1.5;
    }
}

//The Armory

theArmory() {
    if (!IsDefined(level.ArmorySpwnd) && level.Small == false && level.BigBoy == false && level.ArmoryBase != true) {
        if (level.rainstarter == true) {
            if (isDefined(level.entitySpace)) return;
            level.entitySpace = true;
            level.ArmorySpwnd = true;
            self thread theArmory1();
            self thread SpawnRefresh();
        }
    }
    if (!IsDefined(level.ArmorySpwnd) && level.Small == false && level.BigBoy == false && level.ArmoryBase != true) {
        if (level.Raindeletetime == true) {
            getPlayers()[0] notify("rain_sphere");
            if (isDefined(level.entitySpace)) return;
            level.entitySpace = true;
            level.BigBoy = true;
            level.ArmorySpwnd = true;
            self thread SpawnRefresh();
            self iPrintln("^1Deleting ^7Raining Models!");
            wait 7;
            self thread theArmory1();
        }
    }
    if (!IsDefined(level.ArmorySpwnd) && level.ArmoryBase != true) {
        if (level.Small == true || level.BigBoy == true) {
            self playlocalsound("deny");
            self iPrintln("^1Error ^7Entity Limit Reached!");
        }
    } else {
        if (isDefined(level.ArmoryIsBuilding)) return;
        if (!IsDefined(level.ArmorySpwnd) && level.ArmoryBase == true) {
            level.ArmoryBaseBack = undefined;
            level thread ArmoryDelete2();
            level.ArmorySpwnd = true;
            level.ArmoryBase = false;
            self thread SpawnRefresh();
            self thread createProgressBar_Delete(3, "The Armory Deleting!", 1, "The Armory Deleted!");
            for (m = 0; m < getPlayers().size; m++) {
                player = getPlayers()[m];
                if (isDefined(player.InArmoryBase)) {
                    player returnToSpawn();
                    player allowJump(true);
                    player allowProne(true);
                    player.InArmoryBase = undefined;
                    if (!isDefined(player.menu["misc"]["godMode"])) player disableGodMode();
                    else if (isDefined(player.menu["misc"]["godMode"])) player enableGodMode();
                    player thread afterKillstreakProtection();
                }
            }
            wait 2.95;
            level.ArmorySpwnd = undefined;
            level thread ArmoryDelete();
            self thread SpawnRefresh();
        }
    }
}
theArmory1() {
    level.BigBoy = true;
    level.ArmoryBase = true;
    level.ArmoryIsBuilding = true;
    self thread createProgressBar(8.12, "The Armory Spawning!", 1, "The Armory Spawned!");
    self thread BuildSkybase();
    self thread NukeMainframe();
    self thread OrbitalStrike1();
    self thread MaxAmmo();
    self thread doLights();
    self thread doPerk(level.jugg, "zombie_perk_bottle_jugg", "Juggernog", 2500, (80, -510, 488.125), "specialty_armorvest");
    self thread doPerk(level.slieght, "zombie_perk_bottle_sleight", "Speed Cola", 3000, (60, -510, 488.125), "specialty_fastreload");
    self thread doPerk(level.quick, "zombie_perk_bottle_revive", "Quick Revive Soda", 1500, (40, -510, 488.125), "specialty_quickrevive");
    self thread doPerk(level.dTap, "zombie_perk_bottle_doubletap", "Double Tap Root Beer", 2000, (20, -510, 488.125), "specialty_rof");
    self thread spinModels();
}
SpinModels() {
    for (;;) {
        level.Ammo rotateYaw(360, 2);
        level.Teleporter rotateYaw(360, 2);
        level.Teleporter2 rotateYaw(360, 2);
        wait .001;
    }
}
buildTeleporters() {
    level.Teleporter = spawn("script_model", (50, -400, 10));
    level.Teleporter setModel("zombie_teddybear_perkaholic");
    level.Teleporter ArmoryA();
    pos = (50, -400, 20);
    FXM[1] = spawnSM(pos, "tag_origin", (-90, 0, 0));
    playFxOnTag(loadFx("misc/fx_zombie_powerup_on"), FXM[1], "tag_origin");
    FXM[1] ArmoryA();
    self thread Teleporter();
    level.Teleporter2 = spawn("script_model", (-46, -486, 483.125));
    level.Teleporter2 setModel("zombie_teddybear_perkaholic");
    level.Teleporter2 ArmoryA();
    pos2 = (-46, -491, 493.125);
    FXM[2] = spawnSM(pos2, "tag_origin", (-90, 0, 0));
    playFxOnTag(loadFx("misc/fx_zombie_powerup_on"), FXM[2], "tag_origin");
    FXM[2] ArmoryA();
    self thread Teleporter2();
}
Teleporter() {
    pos = (50, -400, 10);
    trig = spawnTrigger(pos, 40);
    trig ArmoryA2();
    trig setString("Press & Hold [{+activate}] To Enter 'The Armory'");
    Tele = spawn("script_model", (2368, -320, 56));
    Tele.angles = (0, 90, 0);
    for (;;) {
        trig waittill("trigger", player);
        if (player useButtonPressed() && !isDefined(level.ArmoryIsBuilding)) {
            wait .1;
            if (player useButtonPressed() && player.is_zombie == false && isDefined(level.ArmoryBaseBack)) {
                level.ArmoryIsBuilding = true;
                player.InArmoryBase = true;
                player setStance("stand");
                player playSound("teleport_2d_fnt");
                player setClientDvar("cg_drawGun", "0");
                player setClientDvar("cg_crosshairAlpha", "0");
                player playerLinkTo(Tele);
                player setPlayerAngles((0, 90, 0));
                player freezeControls(true);
                wait 2;
                player unlink();
                player setOrigin((-35, -481.409, 466.125));
                player setClientDvar("cg_drawGun", "1");
                player setClientDvar("cg_crosshairAlpha", "1");
                player allowJump(false);
                player freezeControls(false);
                player shellshock("electrocution", 2);
                level.ArmoryIsBuilding = undefined;
            }
        }
    }
}
Teleporter2() {
    pos = (-46, -491, 483.125);
    trig = spawnTrigger(pos, 40);
    trig ArmoryA();
    trig setString("Press & Hold [{+activate}] To Exit 'The Armory'");
    Tele = spawn("script_model", (2368, -320, 56));
    for (;;) {
        trig waittill("trigger", player);
        if (player useButtonPressed()) {
            player.InArmoryBase = undefined;
            player setStance("stand");
            player playSound("teleport_2d_fnt");
            player setClientDvar("cg_drawGun", "0");
            player setClientDvar("cg_crosshairAlpha", "0");
            player playerLinkTo(tele);
            player setPlayerAngles((0, 90, 0));
            player freezeControls(true);
            wait 2;
            player unlink();
            player freezeControls(false);
            player allowJump(true);
            player setOrigin((50, -400, -2.875));
            player setClientDvar("cg_drawGun", "1");
            player setClientDvar("cg_crosshairAlpha", "1");
            player shellshock("electrocution", 2);
        }
    }
}
BuildSkybase() {
    for (r = -520; r < -232; r += 24) {
        Mikey = spawn("script_model", (-40, r, 466.125));
        Mikey setModel("zombie_treasure_box_lid");
        Mikey ArmoryA();
        wait .1;
        Mikey = spawn("script_model", (-40, r, 534.125));
        Mikey setModel("zombie_treasure_box_lid");
        Mikey ArmoryA();
        Mikey = spawn("script_model", (50, r, 466.125));
        Mikey setModel("zombie_treasure_box_lid");
        Mikey ArmoryA();
        wait .1;
        Mikey = spawn("script_model", (50, r, 534.125));
        Mikey setModel("zombie_treasure_box_lid");
        Mikey ArmoryA();
        wait .1;
        Mikey = spawn("script_model", (140, r, 466.125));
        Mikey setModel("zombie_treasure_box_lid");
        Mikey ArmoryA();
        Mikey = spawn("script_model", (140, r, 534.125));
        Mikey setModel("zombie_treasure_box_lid");
        Mikey ArmoryA();
        wait .1;
    }
    Mikey = spawn("script_model", (50, -256, 483.125));
    Mikey setModel("zombie_treasure_box_lid");
    Mikey ArmoryA();
    Mikey = spawn("script_model", (50, -526, 483.125));
    Mikey setModel("zombie_treasure_box_lid");
    Mikey ArmoryA();
    wait .1;
    Mikey = spawn("script_model", (-62, -367.5, 483.125));
    Mikey setModel("zombie_treasure_box_lid");
    Mikey.angles = (0, 90, 0);
    Mikey ArmoryA();
    Mikey = spawn("script_model", (186, -367.5, 483.125));
    Mikey setModel("zombie_treasure_box_lid");
    Mikey.angles = (0, 90, 0);
    Mikey ArmoryA();
    wait .1;
    Mikey = spawn("script_model", (50, -256, 517.125));
    Mikey setModel("zombie_treasure_box_lid");
    Mikey ArmoryA();
    Mikey = spawn("script_model", (50, -526, 517.125));
    Mikey setModel("zombie_treasure_box_lid");
    Mikey ArmoryA();
    Mikey = spawn("script_model", (-62, -367.5, 517.125));
    Mikey setModel("zombie_treasure_box_lid");
    Mikey.angles = (0, 90, 0);
    Mikey ArmoryA();
    wait .2;
    Mikey = spawn("script_model", (186, -367.5, 517.125));
    Mikey setModel("zombie_treasure_box_lid");
    Mikey.angles = (0, 90, 0);
    Mikey ArmoryA();
    Mikey = spawn("script_model", (50, -256, 483.125));
    Mikey setModel("zombie_teleporter_control_panel");
    Mikey ArmoryA();
    wait .1;
    Mikey = spawn("script_model", (-62, -367.5, 483.125));
    Mikey setModel("zombie_teleporter_control_panel");
    Mikey.angles = (0, 90, 0);
    Mikey ArmoryA();
    for (w = 466.125; w < 534.125; w += 17) {
        Mikey = spawn("script_model", (-40, -244, w));
        Mikey setModel("zombie_treasure_box");
        Mikey ArmoryA();
        wait .1;
        Mikey = spawn("script_model", (-40, -514, w));
        Mikey setModel("zombie_treasure_box");
        Mikey ArmoryA();
        Mikey = spawn("script_model", (140, -244, w));
        Mikey setModel("zombie_treasure_box");
        Mikey ArmoryA();
        wait .1;
        Mikey = spawn("script_model", (140, -514, w));
        Mikey setModel("zombie_treasure_box");
        Mikey ArmoryA();
        Mikey = spawn("script_model", (-74, -277.5, w));
        Mikey setModel("zombie_treasure_box");
        Mikey.angles = (0, 90, 0);
        Mikey ArmoryA();
        wait .1;
        Mikey = spawn("script_model", (-74, -457.5, w));
        Mikey setModel("zombie_treasure_box");
        Mikey.angles = (0, 90, 0);
        Mikey ArmoryA();
        wait .1;
        Mikey = spawn("script_model", (174, -277.5, w));
        Mikey setModel("zombie_treasure_box");
        Mikey.angles = (0, 90, 0);
        Mikey ArmoryA();
        Mikey = spawn("script_model", (174, -457.5, w));
        Mikey setModel("zombie_treasure_box");
        Mikey.angles = (0, 90, 0);
        Mikey ArmoryA();
    }
    wait .1;
    Mikey = spawn("script_model", (50, -244, 466.125));
    Mikey setModel("zombie_treasure_box");
    Mikey ArmoryA();
    Mikey = spawn("script_model", (50, -244, 517.125));
    Mikey setModel("zombie_treasure_box");
    Mikey ArmoryA();
    wait .1;
    Mikey = spawn("script_model", (50, -514, 466.125));
    Mikey setModel("zombie_treasure_box");
    Mikey ArmoryA();
    wait .1;
    Mikey = spawn("script_model", (50, -514, 517.125));
    Mikey setModel("zombie_treasure_box");
    Mikey ArmoryA();
    wait .2;
    Mikey = spawn("script_model", (-74, -367.5, 466.125));
    Mikey setModel("zombie_treasure_box");
    Mikey.angles = (0, 90, 0);
    Mikey ArmoryA();
    Mikey = spawn("script_model", (-74, -367.5, 517.125));
    Mikey setModel("zombie_treasure_box");
    Mikey.angles = (0, 90, 0);
    Mikey ArmoryA();
    wait .1;
    Mikey = spawn("script_model", (174, -367.5, 466.125));
    Mikey setModel("zombie_treasure_box");
    Mikey.angles = (0, 90, 0);
    Mikey ArmoryA();
    wait .1;
    Mikey = spawn("script_model", (174, -367.5, 517.125));
    Mikey setModel("zombie_treasure_box");
    Mikey.angles = (0, 90, 0);
    Mikey ArmoryA();
    Mikey = spawn("script_model", (20, -245, 516.125));
    Mikey setModel("zombie_zapper_cagelight_green");
    Mikey ArmoryA();
    wait .1;
    Mikey = spawn("script_model", (80, -245, 516.125));
    Mikey setModel("zombie_zapper_cagelight_green");
    Mikey ArmoryA();
    Mikey = spawn("script_model", (20, -515, 516.125));
    Mikey setModel("zombie_zapper_cagelight_green");
    Mikey ArmoryA();
    wait .1;
    Mikey = spawn("script_model", (80, -515, 516.125));
    Mikey setModel("zombie_zapper_cagelight_green");
    Mikey ArmoryA();
    Mikey = spawn("script_model", (173, -400, 516.125));
    Mikey setModel("zombie_zapper_cagelight_green");
    Mikey ArmoryA();
    wait .1;
    Mikey = spawn("script_model", (173, -340, 516.125));
    Mikey setModel("zombie_zapper_cagelight_green");
    Mikey ArmoryA();
    Mikey = spawn("script_model", (-73, -400, 516.125));
    Mikey setModel("zombie_zapper_cagelight_green");
    Mikey ArmoryA();
    wait .1;
    Mikey = spawn("script_model", (-73, -340, 516.125));
    Mikey setModel("zombie_zapper_cagelight_green");
    Mikey ArmoryA();
    self.lightSwitch = spawn("script_model", (140, -496, 486.125));
    self.lightSwitch setModel("zombie_zapper_wall_control");
    self.lightSwitch.angles = (0, 90, 0);
    self.lightSwitch ArmoryA();
    self.lightSwitch = spawn("script_model", (129, -501, 499.125));
    self.lightSwitch setModel("zombie_zapper_handle");
    self.lightSwitch.angles = (180, -90, 0);
    self.lightSwitch ArmoryA();
    level.base = spawn("trigger_radius", (50, -372, 537.125), 0, 600, 1000);
    level.base setContents(1);
    level.base ArmoryA();
    for (s = -66; s < 174; s += 24) {
        level.base = spawn("trigger_radius", (s, -244, 466.125), 0, 24, 200);
        level.base setContents(1);
        level.base ArmoryA();
        level.base = spawn("trigger_radius", (s, -520, 466.125), 0, 24, 200);
        level.base setContents(1);
        level.base ArmoryA();
    }
    for (s = -520; s < -244; s += 24) {
        level.base = spawn("trigger_radius", (174, s, 466.125), 0, 24, 200);
        level.base setContents(1);
        level.base ArmoryA();
        level.base = spawn("trigger_radius", (-74, s, 466.125), 0, 24, 200);
        level.base setContents(1);
        level.base ArmoryA();
    }
    RayGun = spawn("script_model", (-20, -260, 501.125));
    RayGun setModel("weapon_usa_ray_gun");
    RayGun ArmoryA();
    self thread doWeapon("Press & Hold [{+activate}] To Buy a Ray Gun [Cost: 10000]", (-20, -260, 483.125), 10000, "ray_gun_zm");
    wait .1;
    MG42 = spawn("script_model", (140, -260, 501.125));
    MG42.angles = (0, 180, 0);
    MG42 setModel("viewmodel_zombie_mg42_mg");
    MG42 ArmoryA();
    self thread doWeapon("Press & Hold [{+activate}] To Buy a MG42 [Cost: 7000]", (140, -260, 483.125), 7000, "zombie_mg42");
    TeslaGun = spawn("script_model", (160, -310, 501.125));
    TeslaGun.angles = (0, 90, 0);
    TeslaGun setModel("viewmodel_usa_tesla_gun");
    TeslaGun ArmoryA();
    self thread doWeapon("Press & Hold [{+activate}] To Buy a Wunderwaffe DG-2 [Cost: 10000]", (160, -310, 483.125), 10000, "tesla_gun_zm");
    self thread buildTeleporters();
    level.ArmoryBaseBack = true;
    level.ArmoryIsBuilding = undefined;
    level.ArmorySpwnd = undefined;
    self thread SpawnRefresh();
}
ArmoryDelete() {
    level.ArmoryIsBuilding = true;
    for (m = 0; m < level.ArmoryArray.size; m++) level.ArmoryArray[m] delete();
    level.ArmoryArray = undefined;
    level.entitySpace = undefined;
    level.ArmoryIsBuilding = undefined;
    level.Raindeletetime = false;
    level.rainstarter = true;
    level.BigBoy = false;
}
ArmoryDelete2() {
    for (m = 0; m < level.ArmoryArray2.size; m++) level.ArmoryArray2[m] delete();
    level.ArmoryArray2 = undefined;
}
ArmoryA() {
    if (!isDefined(level.ArmoryArray)) level.ArmoryArray = [];
    m = level.ArmoryArray.size;
    level.ArmoryArray[m] = self;
}
ArmoryA2() {
    if (!isDefined(level.ArmoryArray2)) level.ArmoryArray2 = [];
    m = level.ArmoryArray2.size;
    level.ArmoryArray2[m] = self;
}
DoWeapon(string, origin, cost, weapon) {
    pos = (origin);
    trig = spawnTrigger(pos, 35);
    trig ArmoryA();
    trig setString(string);
    for (;;) {
        trig waittill("trigger", player);
        if (!player hasWeapon(weapon)) {
            trig setString(string);
            if (player useButtonPressed()) {
                if (player.score >= cost) {
                    a = player getWeaponsListPrimaries();
                    player playSound("cha_ching");
                    player minus_to_player_score(cost);
                    playerCurrent = player getCurrentWeapon();
                    if (a.size > 1) player takeWeapon(playerCurrent);
                    player giveWeapon(weapon);
                    player switchToWeapon(weapon);
                } else {
                    player playSound("plr_" + player getEntityNumber() + "_vox_nomoney_perk_0");
                }
            }
        } else {
            trig setString("");
        }
    }
}
NukeMainframe() {
    pos = (50, -256, 483.125);
    trig = spawnTrigger(pos, 40);
    trig ArmoryA();
    trig setString("Press & Hold [{+activate}] To Nuke The Mainframe [Cost: 1500]");
    for (;;) {
        cost = 1500;
        trig waittill("trigger", player);
        if (player useButtonPressed()) {
            if (player.score >= cost) {
                player playSound("cha_ching");
                player minus_to_player_score(cost);
                missile = spawn("script_model", (-60, 320, 5000));
                missile setModel("zombie_bomb");
                missile.angles = (90, 0, 0);
                missile moveTo((-60, 320, 103.125), 5);
                wait 5;
                earthquake(2.5, 2, (-60, 320, 103.125), 300);
                playFx(loadFx("explosions/deafult_explosion"), (-60, 320, 120.125));
                playFx(loadFx("misc/fx_zombie_mini_nuke"), (-60, 320, 120.125));
                radiusDamage((-60, 320, 103.125), 500, 1000, 300, self);
                missile delete();
            } else {
                player playSound("plr_" + player getEntityNumber() + "_vox_nomoney_perk_0");
            }
        }
    }
}
MaxAmmo() {
    pos = (172, -367.5, 501.125);
    level.Ammo = spawn("script_model", pos);
    level.Ammo setModel("zombie_ammocan");
    level.Ammo ArmoryA();
    FXM[1] = spawnSM(pos, "tag_origin", (-90, 0, 0));
    playFxOnTag(loadFx("misc/fx_zombie_powerup_on"), FXM[1], "tag_origin");
    FXM[1] ArmoryA();
    pos = (152, -367.5, 483.125);
    trig = spawnTrigger(pos, 35);
    trig ArmoryA();
    trig setString("Press & Hold [{+activate}] To Refill Ammo [Cost: 3500]");
    for (;;) {
        cost = 3500;
        trig waittill("trigger", player);
        if (player useButtonPressed()) {
            if (player.score >= cost) {
                player playSound("cha_ching");
                player minus_to_player_score(cost);
                playerCurrent = player getCurrentWeapon();
                player giveMaxAmmo(playerCurrent);
                wait 5;
            } else {
                player playSound("plr_" + player getEntityNumber() + "_vox_nomoney_perk_0");
            }
        }
    }
}
doPerk(var, model, perkname, cost, origin, perk) {
    var = spawn("script_model", origin);
    var setModel(model);
    var.angles = (0, 180, 0);
    var ArmoryA();
    pos = (origin + (0, 30, -25));
    trig = spawnTrigger(pos, 10);
    trig ArmoryA();
    trig setString("Press & Hold [{+activate}] To Buy " + perkname + " [Cost: " + cost + "]");
    for (;;) {
        trig waittill("trigger", player);
        if (player useButtonPressed()) {
            if (perk == ("specialty_armorvest")) {
                if (player.score >= cost &&
                    var == false && !self hasPerk("specialty_armorvest") && player.drinking != true) {
                    player.drinking = true;
                    player playSound("cha_ching");
                    player minus_to_player_score(cost);
                    player thread giveMenuPerk(perk);
                    var = true;
                    trig setString("");
                    wait 1;
                } else if (player.score < cost &&
                    var == false && !self hasPerk("specialty_armorvest")) player playSound("plr_" + player getEntityNumber() + "_vox_nomoney_perk_0");
                else if (self hasPerk("specialty_armorvest")) trig setString("");
            }
            if (perk == ("specialty_fastreload")) {
                if (player.score >= cost &&
                    var == false && !self hasPerk("specialty_fastreload") && player.drinking != true) {
                    player.drinking = true;
                    player playSound("cha_ching");
                    player minus_to_player_score(cost);
                    player thread giveMenuPerk(perk);
                    var = true;
                    trig setString("");
                    wait 1;
                } else if (player.score < cost &&
                    var == false && !self hasPerk("specialty_fastreload")) player playSound("plr_" + player getEntityNumber() + "_vox_nomoney_perk_0");
                else if (self hasPerk("specialty_fastreload")) trig setString("");
            }
            if (perk == ("specialty_quickrevive")) {
                if (player.score >= cost &&
                    var == false && !self hasPerk("specialty_quickrevive") && player.drinking != true) {
                    player.drinking = true;
                    player playSound("cha_ching");
                    player minus_to_player_score(cost);
                    player thread giveMenuPerk(perk);
                    var = true;
                    trig setString("");
                    wait 1;
                } else if (player.score < cost &&
                    var == false && !self hasPerk("specialty_quickrevive")) player playSound("plr_" + player getEntityNumber() + "_vox_nomoney_perk_0");
                else if (self hasPerk("specialty_quickrevive")) trig setString("");
            }
            if (perk == ("specialty_rof")) {
                if (player.score >= cost &&
                    var == false && !self hasPerk("specialty_rof") && player.drinking != true) {
                    player.drinking = true;
                    player playSound("cha_ching");
                    player minus_to_player_score(cost);
                    player thread giveMenuPerk(perk);
                    var = true;
                    trig setString("");
                    wait 1;
                } else if (player.score < cost &&
                    var == false && !self hasPerk("specialty_rof")) player playSound("plr_" + player getEntityNumber() + "_vox_nomoney_perk_0");
                else if (self hasPerk("specialty_rof")) trig setString("");
            }
        }
    }
}
doLights() {
    pos = (140, -496, 486.125);
    trig = spawnTrigger(pos, 40);
    trig ArmoryA();
    trig setString("Press & Hold [{+activate}] To Turn Lights On/Off");
    lightSwitch = 0;
    for (;;) {
        trig waittill("trigger", player);
        if (player useButtonPressed() && lightSwitch == 0) {
            lightSwitch = 1;
            self.lightSwitch rotatePitch(-180, 1);
            self.light1 = spawn("script_model", (15.5, -245, 512.625));
            self.light1 setModel("tag_origin");
            self.light1 ArmoryA();
            self.light2 = spawn("script_model", (75.5, -245, 512.625));
            self.light2 setModel("tag_origin");
            self.light2 ArmoryA();
            self.light3 = spawn("script_model", (15.5, -515, 512.625));
            self.light3 setModel("tag_origin");
            self.light3 ArmoryA();
            self.light4 = spawn("script_model", (75.5, -515, 512.625));
            self.light4 setModel("tag_origin");
            self.light4 ArmoryA();
            self.light5 = spawn("script_model", (168.5, -400, 512.625));
            self.light5 setModel("tag_origin");
            self.light5 ArmoryA();
            self.light6 = spawn("script_model", (168.5, -340, 512.625));
            self.light6 setModel("tag_origin");
            self.light6 ArmoryA();
            self.light7 = spawn("script_model", (-78.5, -400, 512.625));
            self.light7 setModel("tag_origin");
            self.light7 ArmoryA();
            self.light8 = spawn("script_model", (-78.5, -340, 512.625));
            self.light8 setModel("tag_origin");
            self.light8 ArmoryA();
            wait 1;
            self.light1.fx = playFxOnTag(loadFx("maps/zombie/fx_zombie_light_glow_green"), self.light1, "tag_origin");
            self.light2.fx = playFxOnTag(loadFx("maps/zombie/fx_zombie_light_glow_green"), self.light2, "tag_origin");
            self.light3.fx = playFxOnTag(loadFx("maps/zombie/fx_zombie_light_glow_green"), self.light3, "tag_origin");
            self.light4.fx = playFxOnTag(loadFx("maps/zombie/fx_zombie_light_glow_green"), self.light4, "tag_origin");
            self.light5.fx = playFxOnTag(loadFx("maps/zombie/fx_zombie_light_glow_green"), self.light5, "tag_origin");
            self.light6.fx = playFxOnTag(loadFx("maps/zombie/fx_zombie_light_glow_green"), self.light6, "tag_origin");
            self.light7.fx = playFxOnTag(loadFx("maps/zombie/fx_zombie_light_glow_green"), self.light7, "tag_origin");
            self.light8.fx = playFxOnTag(loadFx("maps/zombie/fx_zombie_light_glow_green"), self.light8, "tag_origin");
        } else if (player useButtonPressed() && lightSwitch == 1) {
            lightSwitch = 0;
            self.lightSwitch rotatePitch(180, 1);
            wait 1;
            self.light1 delete();
            self.light2 delete();
            self.light3 delete();
            self.light4 delete();
            self.light5 delete();
            self.light6 delete();
            self.light7 delete();
            self.light8 delete();
        }
    }
}
OrbitalStrike1() {
    pos = (-62, -367.5, 483.125);
    trig = spawnTrigger(pos, 40);
    trig ArmoryA();
    trig setString("Press & Hold [{+activate}] For Orbital Strike [Cost: 1500]");
    for (;;) {
        cost = 1500;
        trig waittill("trigger", player);
        if (player useButtonPressed()) {
            if (player.score >= cost) {
                player playSound("cha_ching");
                player minus_to_player_score(cost);
                for (i = 0; i < 10; i++) {
                    radiusDamage((-551, -162, 69), 600, 1000, 500, self);
                    earthquake(3, 2, (-551, -162, 69), 90);
                    playFx(level._effect["zombie_mainframe_link_all"], (-551, -162, 69));
                }
                wait 5;
            } else {
                player playSound("plr_" + player getEntityNumber() + "_vox_nomoney_perk_0");
            }
        }
    }
}
//The Bunker

Bunker() {
    if (!IsDefined(level.BunkerSpwnd) && level.Small == false && level.BigBoy == false && level.Bunkerz != true) {
        if (level.rainstarter == true) {
            if (isDefined(level.entitySpace)) return;
            level.entitySpace = true;
            level.BunkerSpwnd = true;
            self thread Bunker1();
            self thread SpawnRefresh();
        }
    }
    if (!IsDefined(level.BunkerSpwnd) && level.Small == false && level.BigBoy == false && level.Bunkerz != true) {
        if (level.Raindeletetime == true) {
            getPlayers()[0] notify("rain_sphere");
            if (isDefined(level.entitySpace)) return;
            level.entitySpace = true;
            level.BigBoy = true;
            level.BunkerSpwnd = true;
            self thread SpawnRefresh();
            self iPrintln("^1Deleting ^7Raining Models!");
            wait 7;
            self thread Bunker1();
        }
    }
    if (!IsDefined(level.BunkerSpwnd) && level.Bunkerz != true) {
        if (level.Small == true || level.BigBoy == true) {
            self playlocalsound("deny");
            self iPrintln("^1Error ^7Entity Limit Reached!");
        }
    } else {
        if (isDefined(level.BunkerIsBuilding)) return;
        if (!IsDefined(level.BaseSpwnd) && level.Bunkerz == true) {
            level.BunkerSpwnd = true;
            level.Bunkerz = false;
            self thread SpawnRefresh();
            self thread createProgressBar_Delete(3, "The Bunker Deleting!", 1, "The Bunker Deleted!");
            wait 2.95;
            level.BunkerSpwnd = undefined;
            level thread BunkerDelete();
            self thread SpawnRefresh();
        }
    }
}
Bunker1() {
    level.BigBoy = true;
    level.Bunkerz = true;
    level.BunkerIsBuilding = true;
    self thread createProgressBar(6.35, "The Bunker Spawning!", 1, "The Bunker Spawned!");
    self thread Roof();
    wait .01;
    self thread Right_Wall();
    wait .01;
    self thread Left_Wall();
    wait .01;
    self thread Back_Wall();
    wait .01;
    self thread Buyables2();
    wait .01;
    self thread Front_Wall();
    self thread RayWaffPPs_Vendor();
    wait .01;
    self thread MGThomp_Vendor();
    wait .01;
    self thread ColtCarb_Vendor();
    self thread Pssd_Vendor();
    self thread Insta_Vendor();
    self thread AllWeaps_Vendor();
    self thread Door5();
    self thread Anti_Zombie_BarrierStore();
}
Front_Wall() {
    Mikey = (-41.8644, -317.268, -2.875);
    for (a = 0; a < 9; a++) {
        for (b = 0; b < 2; b++) {
            Front_Wall = spawn("script_model", (Mikey[0] + (b * 180), Mikey[1], Mikey[2] + (a * 17)));
            wait .1;
            Front_Wall setModel("zombie_treasure_box");
            Front_Wall bunkA();
            wait .1;
        }
    }
    Mikey2 = (49, -317.268, 82.125);
    for (a = 0; a < 4; a++) {
        Front_Wall = spawn("script_model", (Mikey2[0], Mikey2[1], Mikey2[2] + (a * 17)));
        wait .1;
        Front_Wall setModel("zombie_treasure_box");
        Front_Wall bunkA();
        wait .1;
    }
    Mikey = spawn("script_model", (49, -329.268, 82.125));
    wait .1;
    Mikey setModel("zombie_treasure_box_lid");
    Mikey bunkA();
    wait .1;
}
Roof() {
    Mikey = (-41.8644, -329.268, 151.5);
    for (a = 0; a < 13; a++) {
        for (b = 0; b < 3; b++) {
            Roof = spawn("script_model", (Mikey[0] + (b * 90), Mikey[1] + (a * -24), Mikey[2]));
            Roof setModel("zombie_treasure_box_lid");
            Roof bunkA();
            wait .1;
        }
    }
}
Right_Wall() {
    Mikey = (197.781, -319.724, -2.875);
    for (a = 0; a < 16; a++) {
        for (b = 0; b < 2; b++) {
            Right_Wall = spawn("script_model", (Mikey[0], Mikey[1] + (a * -20), Mikey[2] + (b * 80)));
            wait .1;
            Right_Wall setModel("zombie_vending_jugg_on");
            Right_Wall bunkA();
            wait .1;
        }
    }
    level.BunkerIsBuilding = undefined;
    level.BunkerSpwnd = undefined;
    self thread SpawnRefresh();
}
Left_Wall() {
    Mikey = (-89.875, -313.062, -2.875);
    for (a = 0; a < 16; a++) {
        for (b = 0; b < 2; b++) {
            Right_Wall = spawn("script_model", (Mikey[0], Mikey[1] + (a * -20), Mikey[2] + (b * 80)));
            wait .1;
            Right_Wall setModel("zombie_vending_jugg_on");
            Right_Wall bunkA();
            wait .1;
        }
    }
}
Back_Wall() {
    Mikey = (-41.8644, -617.268, -2.875);
    for (a = 0; a < 9; a++) {
        for (b = 0; b < 3; b++) {
            Right_Wall = spawn("script_model", (Mikey[0] + (b * 90), Mikey[1], Mikey[2] + (a * 17)));
            wait .1;
            Right_Wall setModel("zombie_treasure_box");
            Right_Wall bunkA();
            wait .1;
        }
    }
}
BunkerDelete() {
    level.BunkerIsBuilding = true;
    for (m = 0; m < level.BunkerArray.size; m++) level.BunkerArray[m] delete();
    level.BunkerArray = undefined;
    level.entitySpace = undefined;
    level.BunkerIsBuilding = undefined;
    level.Raindeletetime = false;
    level.rainstarter = true;
    level.BigBoy = false;
}
bunkA() {
    if (!isDefined(level.BunkerArray)) level.BunkerArray = [];
    m = level.BunkerArray.size;
    level.BunkerArray[m] = self;
}
Buyables2() {
    Mikey = (3.1356, -550.992, -2.875);
    for (a = 0; a < 2; a++) {
        for (b = 0; b < 2; b++) {
            Buyables = spawn("script_model", (Mikey[0] + (b * 90), Mikey[1], Mikey[2] + (a * 17)));
            Buyables setModel("zombie_treasure_box");
            Buyables bunkA();
            wait .01;
        }
    }
    Mikey = spawn("script_model", (93.1356, -550.992, 31.125));
    wait .1;
    Mikey setModel("zombie_treasure_box");
    Mikey bunkA();
    wait .1;
    Mikey = spawn("script_model", (93.1356, -562.992, 49.5));
    Mikey setModel("zombie_treasure_box_lid");
    Mikey bunkA();
    wait .1;
    Mikey = spawn("script_model", (3.1356, -562.992, 32.5));
    Mikey setModel("zombie_treasure_box_lid");
    Mikey bunkA();
}
RayWaffPPs_Vendor() {
    Ammo = spawn("script_model", (-27.1356, -556, 47.548));
    Ammo setModel("zombie_ammocan");
    Ammo bunkA();
    pos = (Ammo.origin);
    FXM[1] = spawnSM(pos, "tag_origin", (-90, 0, 0));
    playFxOnTag(loadFx("misc/fx_zombie_powerup_on"), FXM[1], "tag_origin");
    FXM[1] bunkA();
    pos = (Ammo.origin + (0, 15, -55));
    RayTrig = spawnTrigger(pos, 18);
    RayTrig bunkA();
    RayTrig setString("Press [{+activate}] To Purchase Wonder Weapons [Cost: 5000]");
    for (;;) {
        RayTrig waittill("trigger", player);
        if (player.is_zombie == false && player useButtonPressed() && !player maps\_laststand::player_is_in_laststand()) {
            if (player.score >= 5000) {
                player playsound("cha_ching");
                player.zombie_cost = 5000;
                player.score -= 5000;
                player takeAllWeapons();
                player giveWeapon("ray_gun_zm");
                player giveWeapon("ray_gun_upgraded_zm");
                player giveWeapon("tesla_gun_zm");
                player giveWeapon("tesla_gun_upgraded_zm");
                player giveWeapon("mp40_upgraded_zm");
                player switchToWeapon("tesla_gun_upgraded_zm");
                wait 1;
            } else {
                player playSound("plr_" + player getEntityNumber() + "_vox_nomoney_perk_0");
                wait 1;
            }
        }
    }
}
MGThomp_Vendor() {
    Ammo = spawn("script_model", (3.1356, -556, 47.548));
    Ammo setModel("zombie_ammocan");
    Ammo bunkA();
    pos = (Ammo.origin);
    FXM[1] = spawnSM(pos, "tag_origin", (-90, 0, 0));
    playFxOnTag(loadFx("misc/fx_zombie_powerup_on"), FXM[1], "tag_origin");
    FXM[1] bunkA();
    pos = (Ammo.origin + (0, 15, -55));
    MGTrig = spawnTrigger(pos, 18);
    MGTrig bunkA();
    MGTrig setString("Press [{+activate}] To Purchase Rifle Package [Cost: 2500]");
    for (;;) {
        MGTrig waittill("trigger", player);
        if (player.is_zombie == false && player useButtonPressed() && !player maps\_laststand::player_is_in_laststand()) {
            if (player.score >= 2500) {
                player playsound("cha_ching");
                player.zombie_cost = 2500;
                player.score -= 2500;
                player takeAllWeapons();
                player giveWeapon("m16_zm");
                player giveWeapon("m16_upgraded_zm");
                player giveWeapon("m14_zm");
                player giveWeapon("m14_upgraded_zm");
                player giveWeapon("famas_zm");
                player giveWeapon("famas_upgraded_zm");
                player giveWeapon("galil_zm");
                player giveWeapon("galil_upgraded_zm");
                player giveWeapon("aug_zm");
                player giveWeapon("aug_upgraded_zm");
                player giveWeapon("fnfal_zm");
                player giveWeapon("fnfal_upgraded_zm");
                player giveWeapon("commando_zm");
                player giveWeapon("commando_upgraded_zm");
                player giveWeapon("g11_zm");
                player giveWeapon("g11_lps_upgraded_zm");
                player switchToWeapon("m16_zm");
                wait 1;
            } else {
                player playSound("plr_" + player getEntityNumber() + "_vox_nomoney_perk_0");
                wait 1;
            }
        }
    }
}
ColtCarb_Vendor() {
    Ammo = spawn("script_model", (33.1356, -556, 47.548));
    Ammo setModel("zombie_ammocan");
    Ammo bunkA();
    pos = (Ammo.origin);
    FXM[1] = spawnSM(pos, "tag_origin", (-90, 0, 0));
    playFxOnTag(loadFx("misc/fx_zombie_powerup_on"), FXM[1], "tag_origin");
    FXM[1] bunkA();
    pos = (Ammo.origin + (0, 15, -55));
    ColtTrig = spawnTrigger(pos, 18);
    ColtTrig bunkA();
    ColtTrig setString("Press [{+activate}] To Purchase SMG Package [Cost: 2500]");
    for (;;) {
        ColtTrig waittill("trigger", player);
        if (player.is_zombie == false && player useButtonPressed() && !player maps\_laststand::player_is_in_laststand()) {
            if (player.score >= 2500) {
                player playsound("cha_ching");
                player.zombie_cost = 2500;
                player.score -= 2500;
                player takeAllWeapons();
                player giveWeapon("mp5k_zm");
                player giveWeapon("mp5k_upgraded_zm");
                player giveWeapon("ak74u_zm");
                player giveWeapon("ak74u_upgraded_zm");
                player giveWeapon("pm63_zm");
                player giveWeapon("pm63_upgraded_zm");
                player giveWeapon("mpl_zm");
                player giveWeapon("mpl_upgraded_zm");
                player switchToWeapon("mp5k_zm");
                wait 1;
            } else {
                player playSound("plr_" + player getEntityNumber() + "_vox_nomoney_perk_0");
                wait 1;
            }
        }
    }
}
Pssd_Vendor() {
    Jugg = spawn("script_model", (124.9, -347.7, -2.875));
    Jugg setModel("zombie_vending_jugg_on");
    Jugg bunkA();
    pos = (Jugg.origin + (0, -15, 0));
    JuggTrig = spawnTrigger(pos, 30);
    JuggTrig bunkA();
    JuggTrig setString("Press [{+activate}] To Get 10 Second 1337 H4X [Cost: 100]");
    for (;;) {
        JuggTrig waittill("trigger", player);
        if (player.is_zombie == false && player useButtonPressed() && !player maps\_laststand::player_is_in_laststand()) {
            if (player.Drunk == false) {
                if (player.score >= 100) {
                    player playsound("cha_ching");
                    player.zombie_cost = 100;
                    player.score -= 100;
                    player thread Pissed();
                    wait 1;
                } else {
                    player playSound("plr_" + player getEntityNumber() + "_vox_nomoney_perk_0");
                    wait 1;
                }
            } else {
                self iPrintln("^7LOL YOU LEECH!");
                wait 1;
            }
        }
    }
}
Pissed() {
    self endon("Pissed_off");
    self.Drunk = true;
    self iPrintln("1^63^33^67 ^34^6A^3X^6X^3O^6R^3Z");
    for (a = 60; a >= 0; a--) {
        self thread Blur(a);
        self thread timezz();
        wait 10;
        self iPrintln("Please Wait 5 More ^2Seconds!");
        wait 5;
        self.Drunk = false;
        self thread Blur(0);
        self notify("Pissed_off");
    }
    if (a <= 60) {
        self iPrintln("^7I GOT THE 1337 ^5HAXXORz");
        self.Drunk = false;
    }
}
timezz() {
    for (m = 10; m > 0; m--) {
        self setText("Time: " + m);
        array_thread(getPlayers(), ::playSingleSound, "pa_audio_link_" + m);
        wait 1;
    }
}
Blur(input) {
    self setBlur(input, 0);
}
Insta_Vendor() {
    Skull = spawn("script_model", (-37.6, -345, 58.875));
    Skull setModel("zombie_skull");
    Skull bunkA();
    Skull thread Rotate_Model(360, 2);
    pos = (Skull.origin);
    FXM[1] = spawnSM(pos, "tag_origin", (-90, 0, 0));
    playFxOnTag(loadFx("misc/fx_zombie_powerup_on"), FXM[1], "tag_origin");
    FXM[1] bunkA();
    pos2 = (Skull.origin);
    FXM[2] = spawnSM(pos2, "tag_origin", (-90, 0, 0));
    playFxOnTag(loadFx("maps/zombie/fx_zombie_wire_spark"), FXM[2], "tag_origin");
    FXM[2] bunkA();
    pos = (Skull.origin + (0, -15, -55));
    InstaTrig = spawnTrigger(pos, 30);
    InstaTrig bunkA();
    InstaTrig setString("Press [{+activate}] To Purchase 60 Second Insta-Kill [Cost: 100]");
    for (;;) {
        InstaTrig waittill("trigger", player);
        if (player.is_zombie == false && player useButtonPressed() && !player maps\_laststand::player_is_in_laststand() && player.insta_on == false) {
            if (player.score >= 100) {
                player.score -= 100;
                player.zombie_cost = 100;
                player playsound("cha_ching");
                player thread Insta_Kill5();
                player iprintln("^7Insta Kill ^2Active");
                wait 1;
            } else {
                player playSound("plr_" + player getEntityNumber() + "_vox_nomoney_perk_0");
                wait 1;
            }
        }
    }
}
Insta_Kill5() {
    self.insta_on = true;
    self thread Insta2();
    wait 60;
    self.insta_on = false;
    self notify("insta_off");
    self playlocalsound("packa_weap_ready");
}
Insta2() {
    self endon("insta_off");
    for (;;) {
        while (self isFiring()) {
            Trace = bulletTrace(self getTagOrigin("j_head"), self getTagOrigin("j_head") + anglesToForward(self getPlayerAngles()) * 1000000, true, self);
            while (self isFiring()) {
                Trace["entity"] doDamage(999999, self.origin, undefined, undefined, "riflebullet");
                wait .01;
            }
        }
        wait .01;
    }
}
AllWeaps_Vendor() {
    Ammo = spawn("script_model", (93.1356, -556, 60));
    Ammo setModel("zombie_ammocan");
    Ammo bunkA();
    pos = (Ammo.origin);
    FXM[1] = spawnSM(pos, "tag_origin", (-90, 0, 0));
    playFxOnTag(loadFx("misc/fx_zombie_powerup_on"), FXM[1], "tag_origin");
    FXM[1] bunkA();
    pos2 = (Ammo.origin);
    FXM[2] = spawnSM(pos, "tag_origin", (-90, 0, 0));
    playFxOnTag(loadFx("maps/zombie/fx_zombie_wire_spark"), FXM[2], "tag_origin");
    FXM[2] bunkA();
    pos = (Ammo.origin + (0, 15, -55));
    WeapsTrig = spawnTrigger(pos, 30);
    WeapsTrig bunkA();
    WeapsTrig setString("Press [{+activate}] To Purchase All Weapons [Cost: 10000]");
    for (;;) {
        WeapsTrig waittill("trigger", player);
        if (player.is_zombie == false && player useButtonPressed() && !player maps\_laststand::player_is_in_laststand()) {
            if (player.score >= 10000) {
                player playsound("cha_ching");
                player.zombie_cost = 10000;
                player.score -= 10000;
                player playsound("laugh_child");
                player takeAllWeapons();
                player giveWeapon("ray_gun_upgraded_zm");
                player switchToWeapon("ray_gun_upgraded_zm");
                player thread giveAllGuns();
                wait 1;
            } else {
                player playSound("plr_" + player getEntityNumber() + "_vox_nomoney_perk_0");
                wait 1;
            }
        }
    }
}
Door5() {
    Mikeeey = (-41.8644, -317.268, -2.875);
    DoorOrig = (46.2872, -420.755, -2.875);
    nZMikey = spawn("script_model", DoorOrig + (-60, 110, 0));
    nZMikey setModel("p7_zm_vending_jugg");
    nZMikey bunkA();
    nZMikey1 = spawn("script_model", DoorOrig + (-90, 110, 0));
    nZMikey1 setModel("p7_zm_vending_jugg");
    nZMikey1 bunkA();
    nZMikey2 = spawn("script_model", DoorOrig + (-120, 110, 0));
    nZMikey2 setModel("p7_zm_vending_jugg");
    nZMikey2 bunkA();
    nZMikey3 = spawn("script_model", DoorOrig + (-150, 110, 0));
    nZMikey3 setModel("p7_zm_vending_jugg");
    nZMikey3 bunkA();
    CageLight = spawn("script_model", (46.2872, -420.755, -2.875));
    CageLight setModel("zombie_zapper_cagelight_red");
    CageLight bunkA();
    CageLight.angles = (180, 0, 0);
    pos = (CageLight.origin);
    DoorTrig = spawnTrigger(pos, 30);
    DoorTrig bunkA();
    DoorTrig setString("Press [{+activate}] To ^2Open^7/^1Close ^7Door");
    for (;;) {
        DoorTrig waittill("trigger", player);
        if (player.is_zombie == false && !player maps\_laststand::player_is_in_laststand()) {
            if (player useButtonPressed() && level.door_closed == false) {
                level.door_closed = true;
                nZMikey moveTo(nZMikey.origin + (105, 0, 0), 2, .5, .5);
                nZMikey1 moveTo(nZMikey1.origin + (105, 0, 0), 2, .5, .5);
                nZMikey2 moveTo(nZMikey2.origin + (105, 0, 0), 2, .5, .5);
                nZMikey3 moveTo(nZMikey3.origin + (105, 0, 0), 2, .5, .5);
                CageLight setModel("zombie_zapper_cagelight_green");
                playsoundatposition("door_slide_open", Mikeeey);
                wait 3;
            }
            if (player useButtonPressed() && level.door_closed == true) {
                level.door_closed = false;
                nZMikey moveTo(nZMikey.origin + (-105, 0, 0), 2, .5, .5);
                nZMikey1 moveTo(nZMikey1.origin + (-105, 0, 0), 2, .5, .5);
                nZMikey2 moveTo(nZMikey2.origin + (-105, 0, 0), 2, .5, .5);
                nZMikey3 moveTo(nZMikey3.origin + (-105, 0, 0), 2, .5, .5);
                CageLight setModel("zombie_zapper_cagelight_red");
                playsoundatposition("door_slide_open", Mikeeey);
                wait 3;
            }
        }
    }
}
Anti_Zombie_BarrierStore() {
    nZMikey = (46.2872, -420.755, -2.875);
    for (;;) {
        if (level.Bunkerz == false) break;
        Enemy = getAiSpeciesArray("axis", "all");
        for (i = 0; i < Enemy.size; i++)
            if (distance(Enemy[i].origin, nZMikey) < 200) {
                Enemy[i] doDamage(Enemy[i].health + 666, Enemy[i].origin);
            }
        wait .1;
    }
}

//Sniper Skybase

StartBase() {
    if (!IsDefined(level.SniperBaseSpwnd) && level.Small == false && level.BigBoy == false && level.SnipeBase != true) {
        if (level.rainstarter == true) {
            if (isDefined(level.entitySpace)) return;
            level.entitySpace = true;
            level.SniperBaseSpwnd = true;
            self thread StartBase1();
            self thread SpawnRefresh();
        }
    }
    if (!IsDefined(level.SniperBaseSpwnd) && level.Small == false && level.BigBoy == false && level.SnipeBase != true) {
        if (level.Raindeletetime == true) {
            getPlayers()[0] notify("rain_sphere");
            if (isDefined(level.entitySpace)) return;
            level.entitySpace = true;
            level.BigBoy = true;
            level.SniperBaseSpwnd = true;
            self thread SpawnRefresh();
            self iPrintln("^1Deleting ^7Raining Models!");
            wait 7;
            self thread StartBase1();
        }
    }
    if (!IsDefined(level.SniperBaseSpwnd) && level.SnipeBase != true) {
        if (level.Small == true || level.BigBoy == true) {
            self playlocalsound("deny");
            self iPrintln("^1Error ^7Entity Limit Reached!");
        }
    } else {
        if (isDefined(level.SnipeIsBuilding)) return;
        if (!IsDefined(level.SniperBaseSpwnd) && level.SnipeBase == true) {
            level.SnipeBaseBack = undefined;
            level thread SnipeDelete2();
            level.SniperBaseSpwnd = true;
            level.SnipeBase = false;
            self thread SpawnRefresh();
            self thread createProgressBar_Delete(3, "Sniper Skybase Deleting!", 1, "Sniper Skybase Deleted!");
            for (m = 0; m < getPlayers().size; m++) {
                player = getPlayers()[m];
                if (isDefined(player.InSnipeBase1)) {
                    player returnToSpawn();
                    player allowJump(true);
                    player allowProne(true);
                    player.InSnipeBase1 = undefined;
                    if (!isDefined(player.menu["misc"]["godMode"])) player disableGodMode();
                    else if (isDefined(player.menu["misc"]["godMode"])) player enableGodMode();
                    player thread afterKillstreakProtection();
                }
            }
            wait 2.95;
            level.SniperBaseSpwnd = undefined;
            level thread SnipeDelete();
            self thread SpawnRefresh();
        }
    }
}
StartBase1() {
    level.BigBoy = true;
    level.SnipeBase = true;
    level.SnipeIsBuilding = true;
    self thread createProgressBar(6.11, "Sniper Skybase Spawning!", 1, "Sniper Skybase Spawned!");
    self endon("death");
    self endon("disconnect");
    level.SniperBaseSpwnd = true;
    self thread SpawnSniperBase();
    self thread teleportbearsx();
    self thread teleportingbers2();
}
teleportbears() {
    pos = (52.3535, -468.596, 15.875);
    FXM[1] = spawnSM(pos, "tag_origin", (-90, 0, 0));
    playFxOnTag(loadFx("misc/fx_zombie_electric_trap"), FXM[1], "tag_origin");
    FXM[1] SnipeArray();
    pos2 = (52.3535, -468.596, 15.875);
    FXM[2] = spawnSM(pos2, "tag_origin", (-90, 0, 0));
    playFxOnTag(loadFx("maps/zombie/fx_zombie_wire_spark"), FXM[2], "tag_origin");
    FXM[2] SnipeArray();
    level.bear = spawn("script_model", (53.2659, -467.96, 33.9964));
    level.bear.angles = (0, 20, 0);
    level.bear setModel("zombie_teddybear_shanks");
    level.bear SnipeArray();
    level.bear thread Rotate_Model(360, 2);
    for (;;) {
        level.bear moveTo((52.3535, -468.596, 74.875), 3, .5, .5);
        level.bear waittill("movedone");
        level.bear moveTo((52.3535, -468.596, 29.875), 3, .5, .5);
        level.bear waittill("movedone");
    }
}
teleportbearsx() {
    pos = (-1034.98, -856.611, 2156.75);
    FXM[1] = spawnSM(pos, "tag_origin", (-90, 0, 0));
    playFxOnTag(loadFx("misc/fx_zombie_electric_trap"), FXM[1], "tag_origin");
    FXM[1] SnipeArray();
    pos2 = (-1034.98, -856.611, 2156.75);
    FXM[2] = spawnSM(pos2, "tag_origin", (-90, 0, 0));
    playFxOnTag(loadFx("maps/zombie/fx_zombie_wire_spark"), FXM[2], "tag_origin");
    FXM[2] SnipeArray();
    level.bear1 = spawn("script_model", (-1040.82, -855.367, 2199.29));
    level.bear1.angles = (0, 20, 0);
    level.bear1 setModel("zombie_teddybear_shanks");
    level.bear1 SnipeArray();
    level.bear1 thread Rotate_Model(360, 2);
    for (;;) {
        level.bear1 moveTo((-1034.98, -856.611, 2215.75), 3, .5, .5);
        level.bear1 waittill("movedone");
        level.bear1 moveTo((-1034.98, -856.611, 2170.75), 3, .5, .5);
        level.bear1 waittill("movedone");
    }
}
teleportingbers1() {
    pos = (53.2659, -467.96, 3);
    BearTrig = spawnTrigger(pos, 45);
    BearTrig SnipeArray2();
    BearTrig setString("Press [{+activate}] To Teleport To Sniper Base");
    for (;;) {
        BearTrig waittill("trigger", i);
        if (i useButtonPressed() && !isDefined(level.SnipeIsBuilding)) {
            wait .1;
            if (i useButtonPressed() && isDefined(level.SnipeBaseBack)) {
                level.SnipeIsBuilding = true;
                i berrytelepx();
                wait 1;
                i thread RocketSniper("ptrs41_zombie", "panzerschrek_zombie");
            }
        }
    }
}
teleportingbers2() {
    pos = (-1040.82, -855.367, 2165);
    BearTrig2 = spawnTrigger(pos, 45);
    BearTrig2 SnipeArray();
    BearTrig2 setString("Press [{+activate}] To Teleport To Mainframe");
    for (;;) {
        BearTrig2 waittill("trigger", i);
        if (i useButtonPressed()) {
            i berrytelepx2();
        }
    }
}
berrytelepx() {
    self.InSnipeBase1 = true;
    self setElectrified(1.25);
    self shellShock("electrocution", 2.5);
    playFx(LoadFx("maps/zombie/fx_transporter_beam"), self.origin);
    playFx(LoadFx("maps/zombie/fx_transporter_pad_start"), self.origin);
    playFx(LoadFx("maps/zombie/fx_transporter_start"), self.origin);
    earthquake(2, 1, self.origin, 100);
    wait 2;
    self playSound("teleport_2d_fnt");
    TeleLink = [];
    image_room = getEnt("teleport_room_1", "targetname");
    if (IsDefined(image_room) && !IsDefined(self.revivetrigger)) {
        self setStance("stand");
        self disableOffHandWeapons();
        self disableWeapons();
        TeleLink = spawn("script_model", image_room.origin);
        TeleLink setModel("tag_origin");
        TeleLink.angles = image_room.angles;
        self playerlinkToAbsolute(TeleLink);
        self freezeControls(true);
    }
    wait 2;
    TeleLink delete();
    self unlink();
    self enableWeapons();
    self enableOffHandWeapons();
    self setOrigin((-1034.98, -854.611, 2156.75));
    self setPlayerAngles((0, 270, 0));
    self shellShock("electrocution", 2);
    self allowJump(true);
    self allowProne(true);
    self freezeControls(false);
    level.SnipeIsBuilding = undefined;
}
berrytelepx2() {
    self.InSnipeBase1 = undefined;
    self setElectrified(1.25);
    self shellShock("electrocution", 2.5);
    playFx(LoadFx("maps/zombie/fx_transporter_beam"), self.origin);
    playFx(LoadFx("maps/zombie/fx_transporter_pad_start"), self.origin);
    playFx(LoadFx("maps/zombie/fx_transporter_start"), self.origin);
    earthquake(2, 1, self.origin, 100);
    wait 2;
    self playSound("teleport_2d_fnt");
    TeleLink = [];
    image_room = getEnt("teleport_room_1", "targetname");
    if (IsDefined(image_room) && !IsDefined(self.revivetrigger)) {
        self setStance("stand");
        self disableOffHandWeapons();
        self disableWeapons();
        TeleLink = spawn("script_model", image_room.origin);
        TeleLink setModel("tag_origin");
        TeleLink.angles = image_room.angles;
        self playerlinkToAbsolute(TeleLink);
        self freezeControls(true);
    }
    wait 2;
    TeleLink delete();
    self unlink();
    self enableWeapons();
    self enableOffHandWeapons();
    self setOrigin((-52.826, 305.118, 103.125));
    self setPlayerAngles((0, 270, 0));
    self shellShock("electrocution", 2);
    self allowJump(true);
    self allowProne(true);
    self freezeControls(false);
}
SnipeDelete() {
    level.SnipeIsBuilding = true;
    for (m = 0; m < level.SniperArray.size; m++) level.SniperArray[m] delete();
    level.SniperArray = undefined;
    level.entitySpace = undefined;
    level.SnipeIsBuilding = undefined;
    level.Raindeletetime = false;
    level.rainstarter = true;
    level.BigBoy = false;
}
SnipeArray() {
    if (!isDefined(level.SniperArray)) level.SniperArray = [];
    m = level.SniperArray.size;
    level.SniperArray[m] = self;
}
SnipeDelete2() {
    for (m = 0; m < level.SniperArray2.size; m++) level.SniperArray2[m] delete();
    level.SniperArray2 = undefined;
}
SnipeArray2() {
    if (!isDefined(level.SniperArray2)) level.SniperArray2 = [];
    m = level.SniperArray2.size;
    level.SniperArray2[m] = self;
}
SpawnSniperBase() {
    ab = -885.375;
    bb = -870.375;
    cb = -855.375;
    db = -840.375;
    eb = -825.375;
    fb = -810.375;
    gb = 2137.57;
    hb = -1034.5;
    ib = -1004.5;
    jb = -974.5;
    kb = -944.5;
    lb = -914.5;
    mb = -884.5;
    nb = -854.5;
    ob = 2113.50;
    pb = -1065.5;
    qb = -825.5;
    yb = (0, 180, 0);
    zb = "zombie_treasure_box_lid";
    zb SnipeArray();
    wait .1;
    level thread sb((hb, ab, gb), yb, zb, (hb, ab, ob));
    level thread sb((ib, ab, gb), yb, zb, (ib, ab, ob));
    level thread sb((jb, ab, gb), yb, zb, (jb, ab, ob));
    level thread sb((kb, ab, gb), yb, zb, (kb, ab, ob));
    level thread sb((lb, ab, gb), yb, zb, (lb, ab, ob));
    level thread sb((mb, ab, gb), yb, zb, (mb, ab, ob));
    level thread sb((nb, ab, gb), yb, zb, (nb, ab, ob));
    wait 1;
    level thread sb((hb, bb, gb), yb, zb, (hb, bb, ob));
    level thread sb((ib, bb, gb), yb, zb, (ib, bb, ob));
    level thread sb((jb, bb, gb), yb, zb, (jb, bb, ob));
    level thread sb((kb, bb, gb), yb, zb, (kb, bb, ob));
    level thread sb((lb, bb, gb), yb, zb, (lb, bb, ob));
    level thread sb((mb, bb, gb), yb, zb, (mb, bb, ob));
    level thread sb((nb, bb, gb), yb, zb, (nb, bb, ob));
    wait 1;
    level thread sb((hb, cb, gb), yb, zb, (hb, cb, ob));
    level thread sb((ib, cb, gb), yb, zb, (ib, cb, ob));
    level thread sb((jb, cb, gb), yb, zb, (jb, cb, ob));
    level thread sb((kb, cb, gb), yb, zb, (kb, cb, ob));
    level thread sb((lb, cb, gb), yb, zb, (lb, cb, ob));
    level thread sb((mb, cb, gb), yb, zb, (mb, cb, ob));
    level thread sb((nb, cb, gb), yb, zb, (nb, cb, ob));
    wait 1;
    level thread sb((hb, db, gb), yb, zb, (hb, db, ob));
    level thread sb((ib, db, gb), yb, zb, (ib, db, ob));
    level thread sb((jb, db, gb), yb, zb, (jb, db, ob));
    level thread sb((kb, db, gb), yb, zb, (kb, db, ob));
    level thread sb((lb, db, gb), yb, zb, (lb, db, ob));
    level thread sb((mb, db, gb), yb, zb, (mb, db, ob));
    level thread sb((nb, db, gb), yb, zb, (nb, db, ob));
    wait 1;
    level thread sb((hb, eb, gb), yb, zb, (hb, eb, ob));
    level thread sb((ib, eb, gb), yb, zb, (ib, eb, ob));
    level thread sb((jb, eb, gb), yb, zb, (jb, eb, ob));
    level thread sb((kb, eb, gb), yb, zb, (kb, eb, ob));
    level thread sb((lb, eb, gb), yb, zb, (lb, eb, ob));
    level thread sb((mb, eb, gb), yb, zb, (mb, eb, ob));
    level thread sb((nb, eb, gb), yb, zb, (nb, eb, ob));
    wait 1;
    level thread sb((hb, fb, gb), yb, zb, (hb, fb, ob));
    level thread sb((ib, fb, gb), yb, zb, (ib, fb, ob));
    level thread sb((jb, fb, gb), yb, zb, (jb, fb, ob));
    level thread sb((kb, fb, gb), yb, zb, (kb, fb, ob));
    level thread sb((lb, fb, gb), yb, zb, (lb, fb, ob));
    level thread sb((mb, fb, gb), yb, zb, (mb, fb, ob));
    level thread sb((nb, fb, gb), yb, zb, (nb, fb, ob));
    wait 1;
    level thread sb((pb, ab, ob), yb, "", (pb, ab, ob));
    level thread sb((qb, ab, ob), yb, "", (qb, ab, ob));
    level thread sb((pb, bb, ob), yb, "", (pb, bb, ob));
    level thread sb((qb, bb, ob), yb, "", (qb, bb, ob));
    level thread sb((pb, cb, ob), yb, "", (pb, cb, ob));
    level thread sb((qb, cb, ob), yb, "", (qb, cb, ob));
    level thread sb((pb, db, ob), yb, "", (pb, db, ob));
    level thread sb((qb, db, ob), yb, "", (qb, db, ob));
    level thread sb((pb, eb, ob), yb, "", (pb, eb, ob));
    level thread sb((qb, eb, ob), yb, "", (qb, eb, ob));
    level thread sb((pb, fb, ob), yb, "", (pb, fb, ob));
    level thread sb((qb, fb, ob), yb, "", (qb, fb, ob));
    self thread teleportbears();
    self thread teleportingbers1();
    level.SnipeBaseBack = true;
    level.SnipeIsBuilding = undefined;
    level.SniperBaseSpwnd = undefined;
    self thread SpawnRefresh();
}
sb(xb, yb, zb, xc) {
    Se7en = spawn("script_model", xb);
    Se7en setModel(zb);
    Se7en.angles = yb;
    Se7en SnipeArray();
    level.base = spawn("trigger_radius", (0, 0, 0), 0, 65, 30);
    level.base.origin = xc;
    level.base.height = (1);
    level.base setContents(1);
    level.base SnipeArray();
}
RocketSniper(gun, shot) {
    self iPrintlnbold("Rocket Sniper Equiped");
    wait .1;
    self giveWeapon(gun, 4, true);
    wait .1;
    self switchToWeapon(gun, 4, true);
    for (;;) {
        self waittill("weapon_fired");
        if (self getCurrentWeapon() == gun) {
            forward = self getTagOrigin("tag_eye");
            end = self thread vector_scal(anglesToForward(self getPlayerAngles()), 1000000);
            location = bulletTrace(forward, end, 0, self)["position"];
            magicBullet(shot, forward, location, self);
        }
    }
}
//Secret Room

SecretRoom() {
    if (!IsDefined(level.SecretRoomSpwnd) && level.Small == false && level.BigBoy == false && level.Secretz != true) {
        if (level.rainstarter == true) {
            if (isDefined(level.entitySpace)) return;
            level.entitySpace = true;
            level.SecretRoomSpwnd = true;
            self thread SecretRoom1();
            self thread SpawnRefresh();
        }
    }
    if (!IsDefined(level.SecretRoomSpwnd) && level.Small == false && level.BigBoy == false && level.Secretz != true) {
        if (level.Raindeletetime == true) {
            getPlayers()[0] notify("rain_sphere");
            if (isDefined(level.entitySpace)) return;
            level.entitySpace = true;
            level.BigBoy = true;
            level.SecretRoomSpwnd = true;
            self thread SpawnRefresh();
            self iPrintln("^1Deleting ^7Raining Models!");
            wait 7;
            self thread SecretRoom1();
        }
    }
    if (!IsDefined(level.SecretRoomSpwnd) && level.Secretz != true) {
        if (level.Small == true || level.BigBoy == true) {
            self playlocalsound("deny");
            self iPrintln("^1Error ^7Entity Limit Reached!");
        }
    } else {
        if (isDefined(level.SecretRoomBuilding)) return;
        if (!IsDefined(level.SecretRoomSpwnd) && level.Secretz == true) {
            level.SecretRoomSpwnd = true;
            level.Secretz = false;
            self thread SpawnRefresh();
            self thread Secret2Delete();
            self thread createProgressBar_Delete(2, "Secret Room Deleting!", 1, "Secret Room Deleted!");
            wait 1.95;
            level.SecretRoomSpwnd = undefined;
            self.GotPoints = undefined;
            level notify("LightSwitchUsed");
            self notify("Zombie_Secret_Over");
            level thread SecretDelete();
            self thread SpawnRefresh();
        }
    }
}
SecretDelete() {
    level.SecretRoomBuilding = true;
    for (a = 0; a < level.SecretArray.size; a++) level.SecretArray[a] delete();
    level.SecretArray = undefined;
    level.entitySpace = undefined;
    level.SecretRoomBuilding = undefined;
    level.Raindeletetime = false;
    level.rainstarter = true;
    level.BigBoy = false;
}
SecretAr() {
    if (!isDefined(level.SecretArray)) level.SecretArray = [];
    a = level.SecretArray.size;
    level.SecretArray[a] = self;
}
Secret2Delete() {
    for (a = 0; a < level.SecretArray2.size; a++) level.SecretArray2[a] delete();
    level.SecretArray2 = undefined;
}
SecretAr2() {
    if (!isDefined(level.SecretArray2)) level.SecretArray2 = [];
    a = level.SecretArray2.size;
    level.SecretArray2[a] = self;
}
SecretRoom1() {
    level.BigBoy = true;
    level.Secretz = true;
    level.SecretRoomBuilding = true;
    self thread createProgressBar(3, "Secret Room Creating!", 1, "Secret Room Created!");
    self thread StairCaseModels();
    self thread SteadyAimMachine();
    self thread doCompleteSecretRoom();
    self thread CreatePointsMach();
    self thread Lights();
    self thread Anti_Zombie_BarrierSecret();
    wait 3;
    self thread StairCaseRide((-176, -623, 73.6892), (-309, -499, 199.227));
    self thread StairCaseRideBack((-309, -499, 199.227), (-176, -623, 73.6892));
}
StaminUpMachine(StaminMach) {
    pos = (StaminMach.origin - (-25, 0, 0));
    StaminTrig = spawnTrigger(pos, 30);
    StaminTrig SecretAr();
    if (!isDefined(self.HasStamin)) StaminTrig setString("Press [{+activate}] To Buy Stamin-Up [Cost: 1500]");
    if (isDefined(self.HasStamin)) StaminTrig setString("");
    for (;;) {
        StaminTrig waittill("trigger", i);
        if (!isDefined(i.HasStamin)) {
            StaminTrig setString("Press [{+activate}] To Buy Stamin-Up [Cost: 1500]");
            if (i useButtonPressed() && i.score >= 1500) {
                i minus_to_player_score(1500);
                Weap = i getCurrentWeapon();
                i Give_Perkz("specialty_longersprint", "zombie_perk_bottle_revive");
                i setMoveSpeedScale(1.3);
                i switchToWeapon(Weap);
                wait .5;
                i.HasStamin = true;
                StaminTrig setString("");
            } else if (i useButtonPressed() && i.score < 1500) i playSound("plr_" + i getEntityNumber() + "_vox_nomoney_perk_0");
        }
    }
}
Lights() {
    self thread LightSwitch();
    ReviveMach = spawn("script_model", (-936, -222, 199.125));
    ReviveMach setModel("zombie_vending_revive_on");
    ReviveMach.angles = (0, 90, 0);
    ReviveMach SecretAr();
    self thread StaminUpMachine(ReviveMach);
    level._effect["revive_light"] = loadfx("misc/fx_zombie_cola_revive_on");
    playFxOnTag(level._effect["revive_light"], ReviveMach, "tag_origin");
    ReviveMachC = (-936, -239, 199.125);
    for (a = 0; a < 3; a++) {
        for (b = 0; b < 3; b++) {
            nZMikey = spawn("trigger_radius", (0, -90, 0), 0, 65, 30);
            nZMikey.origin = (ReviveMachC[0], ReviveMachC[1] + (a * 17), ReviveMachC[2] + (b * 51));
            nZMikey setContents(1);
            nZMikey SecretAr();
            wait .05;
        }
    }
    level.LightSwitch = spawn("script_model", (-644.125, -248, 266));
    level.LightSwitch setModel("lights_cagelight_red_off");
    level.LightSwitch.angles = (90, 0, 0);
    level.LightSwitch SecretAr();
    self thread LightSwitchTrigger(level.LightSwitch.origin);
}
LightSwitch() {
    OutdoorLight = spawn("script_model", (-635, -310, 313));
    OutdoorLight setModel("lights_indlight_on");
    OutdoorLight SecretAr();
    IndoorLight = spawn("script_model", OutdoorLight.origin + (-10, 0, 0));
    IndoorLight setModel(OutdoorLight.model);
    IndoorLight.angles = (0, 180, 0);
    IndoorLight SecretAr();
    Light1 = spawn("script_model", (-783.875, -322, 352));
    Light1 setModel("lights_indlight_on");
    Light1 SecretAr();
    Light2 = spawn("script_model", Light1.origin + (0, 62, 0));
    Light2 setModel(Light1.model);
    Light2 SecretAr();
    Light3 = spawn("script_model", Light2.origin + (0, 62, 0));
    Light3 setModel(Light1.model);
    Light3 SecretAr();
    level.LS1O = Light1.origin;
    level.LS2O = Light2.origin;
    level.LS3O = Light3.origin;
    level.LSODO = OutdoorLight.origin;
    level.LSIDO = IndoorLight.origin;
}
SpawnLight(a, b) {
    Light = spawn("script_model", a + b);
    Light setModel("tag_origin");
    Light.angles = (90, 0, 0);
    playFxOnTag(level._effect["mp_light_lamp"], Light, "tag_origin");
    playFxOnTag(level._effect["mp_light_lamp"], Light, "tag_origin");
    return Light;
}
LightsOn() {
    Light[0] = self SpawnLight(level.LS1O, (30, 0, -7));
    Light[1] = self SpawnLight(level.LS2O, (30, 0, -7));
    Light[2] = self SpawnLight(level.LS3O, (30, 0, -7));
    Light[3] = self SpawnLight(level.LSODO, (30, 0, -7));
    Light[4] = self SpawnLight(level.LSIDO, (-30, 0, -7));
    for (i = 0; i < Light.size; i++) {
        Light[i] thread DeleteonTrigger();
    }
}
DeleteonTrigger() {
    level waittill("LightSwitchUsed");
    self Delete();
}
LightSwitchTrigger(origin) {
    pos = (origin - (20, 0, 60));
    LightSwitchTrig = spawnTrigger(pos, 20);
    LightSwitchTrig SecretAr();
    LightSwitchTrig setString("Press [{+activate}] To Turn The Lights ^2On");
    LightStatus = "Off";
    level.LightSwitch setModel("zombie_zapper_cagelight_red");
    for (;;) {
        LightSwitchTrig waittill("trigger", i);
        if (i UseButtonPressed()) {
            if (LightStatus != "On") {
                LightStatus = "On";
                LightSwitchTrig setString("Press [{+activate}] To Turn The Lights ^1Off");
                level.LightSwitch setModel("zombie_zapper_cagelight_green");
                playSoundAtPosition("pa_buzz", origin);
                level thread LightsOn();
                wait 1;
            } else {
                LightStatus = "Off";
                level notify("LightSwitchUsed");
                LightSwitchTrig setString("Press [{+activate}] To Turn The Lights ^2On");
                level.LightSwitch setModel("zombie_zapper_cagelight_red");
                playSoundAtPosition("pa_buzz", origin);
                wait 1;
            }
        }
    }
}
Anti_Zombie_BarrierSecret() {
    self endon("Zombie_Secret_Over");
    nZMikey = (-790, -194, 199.125);
    for (;;) {
        Enemy = getAiSpeciesArray("axis", "all");
        for (i = 0; i < Enemy.size; i++)
            if (distance(Enemy[i].origin, nZMikey) < 200) {
                Enemy[i] doDamage(Enemy[i].health + 666, Enemy[i].origin);
            }
        wait .1;
    }
}
StairCaseModels() {
    Mikeeey = (-283, -501, 176);
    Mikeeey2 = (-271, -501, 194);
    Mikeeey3 = (-271, -501, 176);
    Mikeeey4 = (-187, -501, 122.6);
    Mikeeey5 = (-175, -501, 140.6);
    Mikeeey6 = (-175, -501, 122.6);
    Mikeeey7 = (-175, -559, 104.8);
    Mikeeey8 = (-175, -571, 122.8);
    Mikeeey9 = (-175, -571, 104.8);
    SM = "script_model";
    SM SecretAr();
    ZB = "zombie_treasure_box";
    ZB SecretAr();
    ZL = "zombie_treasure_box_lid";
    ZL SecretAr();
    for (a = 0; a < 4; a++) {
        nZMikey = spawn(SM, (Mikeeey[0] + (a * 24), Mikeeey[1], Mikeeey[2] + (a * -17.8)));
        nZMikey setModel(ZB);
        nZMikey.angles = (0, 90, 0);
        nZMikey SecretAr();
        wait .05;
    }
    for (a = 0; a < 4; a++) {
        nZMikey = spawn(SM, (Mikeeey2[0] + (a * 24), Mikeeey2[1], Mikeeey2[2] + (a * -17.8)));
        nZMikey setModel(ZL);
        nZMikey.angles = (0, 90, 0);
        nZMikey SecretAr();
        wait .05;
    }
    for (a = 0; a < 4; a++) {
        nZMikey = spawn(SM, (Mikeeey3[0] + (a * 24), Mikeeey3[1], Mikeeey3[2] + (a * -17.8)));
        nZMikey setModel(ZL);
        nZMikey.angles = (0, 90, 0);
        nZMikey SecretAr();
        wait .05;
    }
    for (a = 0; a < 3; a++) {
        nZMikey = spawn(SM, (Mikeeey4[0] + (a * 24), Mikeeey4[1], Mikeeey4[2]));
        nZMikey setModel(ZB);
        nZMikey.angles = (0, 90, 0);
        nZMikey SecretAr();
        wait .05;
    }
    for (a = 0; a < 3; a++) {
        nZMikey2 = spawn(SM, (Mikeeey5[0] + (a * 24), Mikeeey5[1], Mikeeey5[2]));
        nZMikey2 setModel(ZL);
        nZMikey2.angles = (0, 90, 0);
        nZMikey2 SecretAr();
        wait .05;
    }
    for (a = 0; a < 3; a++) {
        nZMikey3 = spawn(SM, (Mikeeey6[0] + (a * 24), Mikeeey6[1], Mikeeey6[2]));
        nZMikey3 setModel(ZL);
        nZMikey3.angles = (0, 90, 0);
        nZMikey3 SecretAr();
        wait .05;
    }
    for (a = 0; a < 3; a++) {
        nZMikey = spawn(SM, (Mikeeey7[0], Mikeeey7[1] + (a * -24), Mikeeey7[2] + (a * -17.8)));
        nZMikey setModel(ZB);
        nZMikey SecretAr();
        wait .05;
    }
    for (a = 0; a < 3; a++) {
        nZMikey2 = spawn(SM, (Mikeeey8[0], Mikeeey8[1] + (a * -24), Mikeeey8[2] + (a * -17.8)));
        nZMikey2 setModel(ZL);
        nZMikey2 SecretAr();
        wait .05;
    }
    for (a = 0; a < 3; a++) {
        nZMikey3 = spawn(SM, (Mikeeey9[0], Mikeeey9[1] + (a * -24), Mikeeey9[2] + (a * -17.8)));
        nZMikey3 setModel(ZL);
        nZMikey3 SecretAr();
        wait .05;
    }
}
StairCaseRide(start, end) {
    level.StairTrig = spawn("trigger_radius", start, 1, 10, 10);
    level.StairTrig setCursorHint("HINT_NOICON");
    level.StairTrig setHintString("");
    level.StairTrig SecretAr2();
    for (;;) {
        level.StairTrig waittill("trigger", i);
        if (!IsDefined(level.StairInUse)) {
            level.SecretRoomBuilding = true;
            level.StairInUse = true;
            level.StairTrig setHintString("StairCase In Use");
            level.StairTrig2 setHintString("StairCase In Use");
            nZMikey = spawn("script_origin", start);
            nZMikey SecretAr2();
            i playerLinkTo(nZMikey);
            i MoveEnt(nZMikey, (-176, -540, 140.37), 1, .3, .3);
            i MoveEnt(nZMikey, (-176, -499, 140.37), 1, .3, .3);
            i MoveEnt(nZMikey, (-210, -499, 140.37), 1, .3, .3);
            i MoveEnt(nZMikey, (-280, -499, 199.821), 1, .3, .3);
            i MoveEnt(nZMikey, end + (-46, 0, 0), 1, .3, .3);
            i unlink();
            nZMikey delete();
            level.StairInUse = undefined;
            level.SecretRoomBuilding = undefined;
            level.StairTrig setHintString("");
            level.StairTrig2 setHintString("");
        }
    }
}
StairCaseRideBack(start, end) {
    level.StairTrig2 = spawn("trigger_radius", start, 1, 10, 10);
    level.StairTrig2 setCursorHint("HINT_NOICON");
    level.StairTrig2 setHintString("");
    level.StairTrig2 SecretAr2();
    for (;;) {
        level.StairTrig2 waittill("trigger", i);
        if (!IsDefined(level.StairInUse)) {
            level.SecretRoomBuilding = true;
            level.StairInUse = true;
            level.StairTrig setHintString("StairCase In Use");
            level.StairTrig2 setHintString("StairCase In Use");
            nZMikey = spawn("script_origin", start);
            nZMikey SecretAr2();
            i playerLinkTo(nZMikey);
            i MoveEnt(nZMikey, (-210, -499, 140.37), 1, .3, .3);
            i MoveEnt(nZMikey, (-176, -499, 140.37), 1, .3, .3);
            i MoveEnt(nZMikey, (-176, -540, 140.37), 1, .3, .3);
            i MoveEnt(nZMikey, end + (0, -46, 0), 1, .3, .3);
            i unlink();
            nZMikey delete();
            level.StairInUse = undefined;
            level.SecretRoomBuilding = undefined;
            level.StairTrig setHintString("");
            level.StairTrig2 setHintString("");
        }
    }
}
MoveEnt(ent, origin, time, increase, decrease) {
    ent moveto(origin, time, increase, decrease);
    ent waittill("movedone");
}
SteadyAimMachine() {
    Steady = spawn("script_model", (-794, -37, 199.125));
    Steady setModel("zombie_vending_sleight_on");
    Steady SecretAr();
    level._effect["sleight_light"] = loadfx("misc/fx_zombie_cola_on");
    playFxOnTag(level._effect["sleight_light"], Steady, "tag_origin");
    SteadyC = (-819, -37, 199.125);
    for (a = 0; a < 3; a++) {
        for (b = 0; b < 3; b++) {
            nZMikey = spawn("trigger_radius", (0, -90, 0), 0, 65, 30);
            nZMikey.origin = (SteadyC[0] + (a * 25), SteadyC[1], SteadyC[2] + (b * 51));
            nZMikey setContents(1);
            nZMikey SecretAr();
            wait .05;
        }
    }
    pos = (Steady.origin - (0, 20, 0));
    SteadyTrig = spawnTrigger(pos, 30);
    SteadyTrig SecretAr();
    if (isDefined(self.HasSteady)) SteadyTrig setString("Press [{+activate}] To Buy Steady Aim Pro [Cost: 2000]");
    if (!isDefined(self.HasSteady)) SteadyTrig setString("Press [{+activate}] To Buy Steady Aim [Cost: 1500]");
    if (isDefined(self.HasSteadyPro)) SteadyTrig setString("");
    for (;;) {
        SteadyTrig waittill("trigger", i);
        if (!isDefined(i.HasSteady)) {
            SteadyTrig setString("Press [{+activate}] To Buy Steady Aim [Cost: 1500]");
            if (i useButtonPressed() && i.score >= 1500) {
                i minus_to_player_score(1500);
                Weap = i getCurrentWeapon();
                i setClientDvar("perk_weapSpreadMultiplier", ".65");
                i Give_Perkz("specialty_bulletaccuracy", "zombie_perk_bottle_sleight");
                i switchToWeapon(Weap);
                wait .5;
                i.HasSteady = true;
                SteadyTrig setString("Press [{+activate}] To Buy Steady Aim Pro [Cost: 2000]");
            } else if (i useButtonPressed() && i.score < 1500) i playSound("plr_" + i getEntityNumber() + "_vox_nomoney_perk_0");
        } else {
            if (i useButtonPressed() && !IsDefined(i.HasSteadyPro) && IsDefined(i.HasSteady) && i.score >= 2000) {
                i minus_to_player_score(2000);
                Weap = i getCurrentWeapon();
                i.HasSteadyPro = true;
                i Give_Perkz("", "zombie_perk_bottle_sleight");
                i setClientDvar("perk_weapSpreadMultiplier", ".01");
                i switchToWeapon(Weap);
                SteadyTrig setString("");
            } else if (i useButtonPressed() && i.score < 2000) i playSound("plr_" + i getEntityNumber() + "_vox_nomoney_perk_0");
        }
    }
}
CreatePointsMach() {
    Jugg = spawn("script_model", (-660, -180.991, 199.125));
    Jugg setModel("zombie_vending_jugg_on");
    Jugg.angles = (0, -90, 0);
    Jugg SecretAr();
    level._effect["jugger_light"] = loadfx("misc/fx_zombie_cola_jugg_on");
    playFxOnTag(level._effect["jugger_light"], Jugg, "tag_origin");
    for (a = 0; a < 3; a++) {
        nZMikey = spawn("trigger_radius", (0, -90, 0), 0, 65, 30);
        nZMikey.origin = (Jugg.origin[0], Jugg.origin[1], Jugg.origin[2] + (a * 51));
        nZMikey setContents(1);
        nZMikey SecretAr();
        wait .05;
    }
    pos = (Jugg.origin - (20, 0, 0));
    JuggTrig = spawnTrigger(pos, 30);
    JuggTrig SecretAr();
    JuggTrig setString("Press [{+activate}] To Use The Points Gamble Machine[Cost: 2000][One Use Only]");
    for (;;) {
        JuggTrig waittill("trigger", i);
        if (i UseButtonPressed() && !IsDefined(i.GotPoints) && i.score >= 2000) {
            RandScore = randomIntRange(0, 10000);
            i.GotPoints = true;
            i minus_to_player_score(2000);
            i add_to_player_score(RandScore);
            i playSound("cha_ching");
            i iPrintln("^3You Won: " + RandScore);
            JuggTrig setString("");
        } else if (i useButtonPressed() && i.score < 2000 && !isDefined(i.GotPoints)) i playSound("plr_" + i getEntityNumber() + "_vox_nomoney_perk_0");
    }
}
doCompleteSecretRoom() {
    level.secretRoomOpen = false;
    level.trig1_use = false;
    level.trig_use = false;
    self thread Trigger_1();
    self thread Trigger_2();
    level.Mikey = spawn("script_model", (-640, -308, 199.125));
    level.Mikey setModel("zombie_treasure_box_lid");
    level.Mikey.angles = (0, 90, 90);
    level.Mikey SecretAr();
    level.Mikey0 = spawn("script_model", (-640, -308, 223));
    level.Mikey0 setModel("zombie_treasure_box_lid");
    level.Mikey0.angles = (0, 90, 90);
    level.Mikey0 SecretAr();
    level.Mikey1 = spawn("script_model", (-640, -308, 247));
    level.Mikey1 setModel("zombie_treasure_box_lid");
    level.Mikey1.angles = (0, 90, 90);
    level.Mikey1 SecretAr();
    level.Mikey2 = spawn("script_model", (-640, -308, 271));
    level.Mikey2 setModel("zombie_treasure_box_lid");
    level.Mikey2.angles = (0, 90, 90);
    level.Mikey2 SecretAr();
    level.Mikey5 = spawn("script_model", (-610, -359, 250));
    level.Mikey5 setModel("zombie_power_lever_handle");
    level.Mikey5.angles = (0, 180, 90);
    level.Mikey5 SecretAr();
    level.Mikey6 = spawn("script_model", (-670, -359, 250));
    level.Mikey6 setModel("zombie_power_lever_handle");
    level.Mikey6.angles = (0, 180, 90);
    level.Mikey6 SecretAr();
    level.Solid = spawn("trigger_radius", (0, 0, 0), 0, 15, 15);
    level.Solid.origin = (-640, -315, 199.125);
    level.Solid setContents(1);
    level.Solid SecretAr();
    level.Solid0 = spawn("trigger_radius", (0, 0, 0), 0, 15, 15);
    level.Solid0.origin = (-640, -315, 223);
    level.Solid0 setContents(1);
    level.Solid0 SecretAr();
    level.Solid1 = spawn("trigger_radius", (0, 0, 0), 0, 15, 15);
    level.Solid1.origin = (-640, -315, 247);
    level.Solid1 setContents(1);
    level.Solid1 SecretAr();
    level.Solid2 = spawn("trigger_radius", (0, 0, 0), 0, 15, 15);
    level.Solid2.origin = (-640, -315, 271);
    level.Solid2 setContents(1);
    level.Solid2 SecretAr();
    level.Solid3 = spawn("trigger_radius", (0, 0, 0), 0, 15, 15);
    level.Solid3.origin = (-640, -300, 199.125);
    level.Solid3 setContents(1);
    level.Solid3 SecretAr();
    level.Solid4 = spawn("trigger_radius", (0, 0, 0), 0, 15, 15);
    level.Solid4.origin = (-640, -300, 223);
    level.Solid4 setContents(1);
    level.Solid4 SecretAr();
    level.Solid5 = spawn("trigger_radius", (0, 0, 0), 0, 15, 15);
    level.Solid5.origin = (-640, -300, 247);
    level.Solid5 setContents(1);
    level.Solid5 SecretAr();
    level.Solid6 = spawn("trigger_radius", (0, 0, 0), 0, 15, 15);
    level.Solid6.origin = (-640, -300, 271);
    level.Solid6 setContents(1);
    level.Solid6 SecretAr();
    wait 3;
    level.SecretRoomBuilding = undefined;
    level.SecretRoomSpwnd = undefined;
    self thread SpawnRefresh();
}
Trigger_1() {
    pos = (-610, -345, 220);
    level.DoorTrig = spawnTrigger(pos, 30);
    level.DoorTrig SecretAr();
    level.DoorTrig setString("Press [{+activate}] To ^2Open ^7Door");
    for (;;) {
        level.DoorTrig waittill("trigger", i);
        if (i UseButtonPressed() && level.secretRoomOpen == false && level.trig1_use == false && i.is_zombie == false) {
            level.Mikey5 thread RotateModelFx2();
            level.DoorTrig setString("");
            level.DoorTrig2 setString("");
            level.trig_use = true;
            level.secretRoomOpen = true;
            level.Mikey moveTo(level.Mikey.origin + (0, -85, 0), 2, .5, .5);
            level.Mikey0 moveTo(level.Mikey0.origin + (0, -85, 0), 2, .5, .5);
            level.Mikey1 moveTo(level.Mikey1.origin + (0, -85, 0), 2, .5, .5);
            level.Mikey2 moveTo(level.Mikey2.origin + (0, -85, 0), 2, .5, .5);
            level.Solid delete();
            level.Solid SecretAr();
            level.Solid0 delete();
            level.Solid0 SecretAr();
            level.Solid1 delete();
            level.Solid1 SecretAr();
            level.Solid2 delete();
            level.Solid2 SecretAr();
            level.Solid3 delete();
            level.Solid3 SecretAr();
            level.Solid4 delete();
            level.Solid4 SecretAr();
            level.Solid5 delete();
            level.Solid5 SecretAr();
            level.Solid6 delete();
            level.Solid6 SecretAr();
            i playSound("door_slide_open");
            wait 3;
            level.DoorTrig setString("Press [{+activate}] To ^1Close ^7Door");
            level.DoorTrig2 setString("Press [{+activate}] To ^1Close ^7Door");
            level.trig_use = false;
        }
        if (i UseButtonPressed() && level.secretRoomOpen == true && level.trig1_use == false && i.is_zombie == false) {
            level.Mikey5 thread RotateModelFx2();
            level.DoorTrig setString("");
            level.DoorTrig2 setString("");
            level.trig_use = true;
            level.secretRoomOpen = false;
            level.Mikey moveTo(level.Mikey.origin + (0, 85, 0), 2, .5, .5);
            level.Mikey0 moveTo(level.Mikey0.origin + (0, 85, 0), 2, .5, .5);
            level.Mikey1 moveTo(level.Mikey1.origin + (0, 85, 0), 2, .5, .5);
            level.Mikey2 moveTo(level.Mikey2.origin + (0, 85, 0), 2, .5, .5);
            level.Solid = spawn("trigger_radius", (0, 0, 0), 0, 15, 15);
            level.Solid.origin = (-640, -315, 199.125);
            level.Solid setContents(1);
            level.Solid SecretAr();
            level.Solid0 = spawn("trigger_radius", (0, 0, 0), 0, 15, 15);
            level.Solid0.origin = (-640, -315, 223);
            level.Solid0 setContents(1);
            level.Solid0 SecretAr();
            level.Solid1 = spawn("trigger_radius", (0, 0, 0), 0, 15, 15);
            level.Solid1.origin = (-640, -315, 247);
            level.Solid1 setContents(1);
            level.Solid1 SecretAr();
            level.Solid2 = spawn("trigger_radius", (0, 0, 0), 0, 15, 15);
            level.Solid2.origin = (-640, -315, 271);
            level.Solid2 setContents(1);
            level.Solid2 SecretAr();
            level.Solid3 = spawn("trigger_radius", (0, 0, 0), 0, 15, 15);
            level.Solid3.origin = (-640, -300, 199.125);
            level.Solid3 setContents(1);
            level.Solid3 SecretAr();
            level.Solid4 = spawn("trigger_radius", (0, 0, 0), 0, 15, 15);
            level.Solid4.origin = (-640, -300, 223);
            level.Solid4 setContents(1);
            level.Solid4 SecretAr();
            level.Solid5 = spawn("trigger_radius", (0, 0, 0), 0, 15, 15);
            level.Solid5.origin = (-640, -300, 247);
            level.Solid5 setContents(1);
            level.Solid5 SecretAr();
            level.Solid6 = spawn("trigger_radius", (0, 0, 0), 0, 15, 15);
            level.Solid6.origin = (-640, -300, 271);
            level.Solid6 setContents(1);
            level.Solid6 SecretAr();
            i playSound("door_slide_open");
            wait 3;
            level.DoorTrig setString("Press [{+activate}] To ^2Open ^7Door");
            level.DoorTrig2 setString("Press [{+activate}] To ^2Open ^7Door");
            level.trig_use = false;
        }
    }
}
Trigger_2() {
    pos = (-670, -345, 220);
    level.DoorTrig2 = spawnTrigger(pos, 30);
    level.DoorTrig2 SecretAr();
    level.DoorTrig2 setString("Press [{+activate}] To ^2Open ^7Door");
    for (;;) {
        level.DoorTrig2 waittill("trigger", i);
        if (i UseButtonPressed() && level.secretRoomOpen == false && level.trig_use == false && i.is_zombie == false) {
            level.Mikey6 thread RotateModelFx2();
            level.DoorTrig setString("");
            level.DoorTrig2 setString("");
            level.trig1_use = true;
            level.secretRoomOpen = true;
            level.Mikey moveTo(level.Mikey.origin + (0, -85, 0), 2, .5, .5);
            level.Mikey0 moveTo(level.Mikey0.origin + (0, -85, 0), 2, .5, .5);
            level.Mikey1 moveTo(level.Mikey1.origin + (0, -85, 0), 2, .5, .5);
            level.Mikey2 moveTo(level.Mikey2.origin + (0, -85, 0), 2, .5, .5);
            level.Solid delete();
            level.Solid SecretAr();
            level.Solid0 delete();
            level.Solid0 SecretAr();
            level.Solid1 delete();
            level.Solid1 SecretAr();
            level.Solid2 delete();
            level.Solid2 SecretAr();
            level.Solid3 delete();
            level.Solid3 SecretAr();
            level.Solid4 delete();
            level.Solid4 SecretAr();
            level.Solid5 delete();
            level.Solid5 SecretAr();
            level.Solid6 delete();
            level.Solid6 SecretAr();
            i playsound("door_slide_open");
            wait 3;
            level.DoorTrig setString("Press [{+activate}] To ^1Close ^7Door");
            level.DoorTrig2 setString("Press [{+activate}] To ^1Close ^7Door");
            level.trig1_use = false;
        }
        if (i UseButtonPressed() && level.secretRoomOpen == true && level.trig_use == false && i.is_zombie == false) {
            level.Mikey6 thread RotateModelFx2();
            level.DoorTrig setString("");
            level.DoorTrig2 setString("");
            level.trig1_use = true;
            level.secretRoomOpen = false;
            level.Mikey moveTo(level.Mikey.origin + (0, 85, 0), 2, .5, .5);
            level.Mikey0 moveTo(level.Mikey0.origin + (0, 85, 0), 2, .5, .5);
            level.Mikey1 moveTo(level.Mikey1.origin + (0, 85, 0), 2, .5, .5);
            level.Mikey2 moveTo(level.Mikey2.origin + (0, 85, 0), 2, .5, .5);
            level.Solid = spawn("trigger_radius", (0, 0, 0), 0, 15, 15);
            level.Solid.origin = (-640, -315, 199.125);
            level.Solid setContents(1);
            level.Solid SecretAr();
            level.Solid0 = spawn("trigger_radius", (0, 0, 0), 0, 15, 15);
            level.Solid0.origin = (-640, -315, 223);
            level.Solid0 setContents(1);
            level.Solid0 SecretAr();
            level.Solid1 = spawn("trigger_radius", (0, 0, 0), 0, 15, 15);
            level.Solid1.origin = (-640, -315, 247);
            level.Solid1 setContents(1);
            level.Solid1 SecretAr();
            level.Solid2 = spawn("trigger_radius", (0, 0, 0), 0, 15, 15);
            level.Solid2.origin = (-640, -315, 271);
            level.Solid2 setContents(1);
            level.Solid2 SecretAr();
            level.Solid3 = spawn("trigger_radius", (0, 0, 0), 0, 15, 15);
            level.Solid3.origin = (-640, -300, 199.125);
            level.Solid3 setContents(1);
            level.Solid3 SecretAr();
            level.Solid4 = spawn("trigger_radius", (0, 0, 0), 0, 15, 15);
            level.Solid4.origin = (-640, -300, 223);
            level.Solid4 setContents(1);
            level.Solid4 SecretAr();
            level.Solid5 = spawn("trigger_radius", (0, 0, 0), 0, 15, 15);
            level.Solid5.origin = (-640, -300, 247);
            level.Solid5 setContents(1);
            level.Solid5 SecretAr();
            level.Solid6 = spawn("trigger_radius", (0, 0, 0), 0, 15, 15);
            level.Solid6.origin = (-640, -300, 271);
            level.Solid6 setContents(1);
            level.Solid6 SecretAr();
            i playsound("door_slide_open");
            wait 3;
            level.DoorTrig setString("Press [{+activate}] To ^2Open ^7Door");
            level.DoorTrig2 setString("Press [{+activate}] To ^2Open ^7Door");
            level.trig1_use = false;
        }
    }
}
RotateModelFx2() {
    self rotateTo((0, 180, 0), 1, 0, .5);
    wait 1;
    self rotateTo((0, 180, 90), 1, 0, .5);
}
//Teleport Station

doTeleStation() {
    if (!IsDefined(level.TelestationSpwnd) && level.Small == false && level.BigBoy == false && level.TStationBase != true) {
        if (level.rainstarter == true) {
            if (isDefined(level.entitySpace)) return;
            level.entitySpace = true;
            level.TelestationSpwnd = true;
            self thread doTeleStation1();
            self thread SpawnRefresh();
        }
    }
    if (!IsDefined(level.TelestationSpwnd) && level.Small == false && level.BigBoy == false && level.TStationBase != true) {
        if (level.Raindeletetime == true) {
            getPlayers()[0] notify("rain_sphere");
            if (isDefined(level.entitySpace)) return;
            level.BigBoy = true;
            level.TelestationSpwnd = true;
            self thread SpawnRefresh();
            self iPrintln("^1Deleting ^7Raining Models!");
            wait 7;
            self thread doTeleStation1();
        }
    }
    if (!IsDefined(level.TelestationSpwnd) && level.TStationBase != true) {
        if (level.Small == true || level.BigBoy == true) {
            self playlocalsound("deny");
            self iPrintln("^1Error ^7Entity Limit Reached!");
        }
    } else {
        if (isDefined(level.TeleStationBuilding)) return;
        if (!IsDefined(level.TelestationSpwnd) && level.TStationBase == true) {
            level.StationBaseBack = undefined;
            level thread TStationDelete2();
            level.TelestationSpwnd = true;
            level.TStationBase = false;
            self thread SpawnRefresh();
            self thread createProgressBar_Delete(3, "Teleport Station Deleting!", 1, "Teleport Station Deleted!");
            for (a = 0; a < getPlayers().size; a++) {
                player = getPlayers()[a];
                if (isDefined(player.InStationBase)) {
                    player returnToSpawn();
                    player allowJump(true);
                    player allowProne(true);
                    player.InStationBase = undefined;
                    if (self.GodModeIsOn == false) player disableGodMode();
                    else player enableGodMode();
                    player thread afterKillstreakProtection();
                }
            }
            wait 2.95;
            level.TelestationSpwnd = undefined;
            level thread TStationDelete();
            self thread SpawnRefresh();
        }
    }
}
TStationDelete() {
    level.TeleStationBuilding = true;
    for (a = 0; a < level.TStatArray.size; a++) level.TStatArray[a] delete();
    level.TStatArray = undefined;
    level.entitySpace = undefined;
    level.TeleStationBuilding = undefined;
    level.Raindeletetime = false;
    level.rainstarter = true;
    level.BigBoy = false;
}
TSArray() {
    if (!isDefined(level.TStatArray)) level.TStatArray = [];
    a = level.TStatArray.size;
    level.TStatArray[a] = self;
}
TStationDelete2() {
    for (a = 0; a < level.TStatArray2.size; a++) level.TStatArray2[a] delete();
    level.TStatArray2 = undefined;
}
TSArray2() {
    if (!isDefined(level.TStatArray2)) level.TStatArray2 = [];
    a = level.TStatArray2.size;
    level.TStatArray2[a] = self;
}
doTeleStation1() {
    level.BigBoy = true;
    level.TStationBase = true;
    level.TeleStationBuilding = true;
    self thread createProgressBar(5, "Teleport Station Spawning!", 1, "Teleport Station Spawned!");
    for (a = 0; a < 10; a++) {
        for (b = 0; b < 10; b++) {
            nZMikey = spawn("script_model", ((-325, -250, 431)[0] + (a * 72), (-325, -250, 431)[1] + (b * 36), (-325, -250, 431)[2]));
            nZMikey setmodel("static_berlin_metal_desk");
            nZMikey TSArray();
            wait .05;
        }
    }
    level thread do2TeleStation();
    level thread Full_Teleporters((-277, -189, 466), (544, 1803, 61.4408), (0, 135, 0), "Press & Hold [{+activate}] To Use Teleporter [Destination: Fly Trap]");
    level thread Full_Teleporters((-277, 8, 466), (300, -3201, 189.125), (0, 48, 0), "Press & Hold [{+activate}] To Use Teleporter [Destination: STG-44 Teleporter]");
    level thread Full_Teleporters((296, 8, 466), (76, -2425, 272.125), (0, 315, 0), "Press & Hold [{+activate}] To Use Teleporter [Destination: STG-44 Cat Walk]");
    level thread Full_Teleporters((296, -189, 466), (300, -1690, 52.8241), (0, 225, 0), "Press & Hold [{+activate}] To Use Teleporter [Destination: Courtyard]");
    level thread Full_Teleporters((0, 8, 466), (1265, 1285, 200.125), (0, 360, 0), "Press & Hold [{+activate}] To Use Teleporter [Destination: MP40 Teleporter]");
    level thread Full_Teleporters((0, -189, 466), (-1790, -1106, 231.125), (0, 180, 0), "Press & Hold [{+activate}] To Use Teleporter [Destination: Type 100 Teleporter]");
    TeleFx = spawn("script_model", (-56, 173, 150));
    TeleFx setModel("viewmodel_zombie_cymbal_monkey");
    TeleFx TSArray();
    TeleFx thread maps\_zombiemode_powerups::PowerUp_Wobble("disconnect");
    pos = (TeleFx.origin + (0, 0, 7));
    FXM[1] = spawnSM(pos, "tag_origin", (-90, 0, 0));
    playFxOnTag(loadFx("misc/fx_zombie_powerup_on"), FXM[1], "tag_origin");
    FXM[1] TSArray();
    level.StationBaseBack = true;
    level.TeleStationBuilding = undefined;
    level.TelestationSpwnd = undefined;
    self thread SpawnRefresh();
}
do2TeleStation() {
    pos = (-56, 173, 115);
    TeleTrig = spawnTrigger(pos, 30);
    TeleTrig TSArray2();
    TeleTrig setString("Press [{+activate}] To Use Teleporter [Destination: Teleport Station]");
    prone_offset = (0, 0, 49);
    crouch_offset = (0, 0, 20);
    stand_offset = (0, 0, 0);
    image_room = getEnt("teleport_room_1", "targetname");
    for (;;) {
        TeleTrig waittill("trigger", player);
        if (player.is_zombie == false && player useButtonPressed() && !player maps\_laststand::player_is_in_laststand() && isDefined(level.StationBaseBack)) {
            level.TeleStationBuilding = true;
            player.InStationBase = true;
            player freezeControls(true);
            player setelectrified(1.25);
            player shellshock("electrocution", 2.5);
            playfx(loadfx("maps/zombie/fx_transporter_beam"), player.origin);
            playfx(loadfx("maps/zombie/fx_transporter_pad_start"), player.origin);
            playfx(loadfx("maps/zombie/fx_transporter_start"), player.origin);
            playfx(loadfx("maps/zombie/fx_transporter_start"), player.origin);
            earthquake(2, 1, player.origin, 100);
            wait 2;
            player playSound("teleport_2d_fnt");
            if (IsDefined(image_room) && !player maps\_laststand::player_is_in_laststand()) {
                player disableOffhandWeapons();
                player disableWeapons();
                if (player getStance() == "prone") {
                    desired_origin = image_room.origin + prone_offset;
                } else if (player getStance() == "crouch") {
                    desired_origin = image_room.origin + crouch_offset;
                } else {
                    desired_origin = image_room.origin + stand_offset;
                }
                player.telelink = spawn("script_model", player.origin);
                player.telelink setmodel("tag_origin");
                player.telelink.origin = desired_origin;
                player.telelink.angles = image_room.angles;
                player playerLinkToAbsolute(player.telelink);
                player freezeControls(true);
            }
            wait 1.7;
            player.telelink delete();
            player unlink();
            player enableWeapons();
            player enableOffHandWeapons();
            player enableInvulnerability();
            player setOrigin((0, -88, 466.125));
            player shellshock("electrocution", 4);
            player freezeControls(false);
            level.TeleStationBuilding = undefined;
        }
    }
}
Full_Teleporters(Mikey, XIT, Angz, trigger) {
    Tele = spawn("script_model", Mikey);
    Tele setModel("zombie_teleporter");
    Tele.angles = Angz;
    Tele TSArray();
    Tele_B = spawn("script_model", Mikey + (0, 0, 147));
    Tele_B setModel("zombie_teleporter_b");
    Tele_B.angles = Angz;
    Tele_B TSArray();
    Tele_C = spawn("script_model", Mikey + (0, 0, 242));
    Tele_C setModel("zombie_teleporter_c");
    Tele_C.angles = Angz;
    Tele_C TSArray();
    Tele_D = spawn("script_model", Mikey + (0, 0, 342));
    Tele_D setModel("zombie_teleporter_d");
    Tele_D.angles = Angz;
    Tele_D TSArray();
    Tele_E = spawn("script_model", Mikey + (0, 0, 47));
    Tele_E setModel("zombie_teleporter_e");
    Tele_E.angles = Angz;
    Tele_E TSArray();
    pos = (Mikey);
    TeleTrig = spawnTrigger(pos, 25);
    TeleTrig TSArray();
    TeleTrig setString(trigger);
    prone_offset = (0, 0, 49);
    crouch_offset = (0, 0, 20);
    stand_offset = (0, 0, 0);
    image_room = getEnt("teleport_room_1", "targetname");
    for (;;) {
        TeleTrig waittill("trigger", player);
        if (player.is_zombie == false && player useButtonPressed() && !player maps\_laststand::player_is_in_laststand()) {
            if (Mikey == (-277, -189, 466)) {
                level.TeleStationBuilding = true;
                player.InStationBase = true;
            } else {
                level.TeleStationBuilding = undefined;
                player.InStationBase = undefined;
            }
            player freezeControls(true);
            player setelectrified(1.25);
            player shellshock("electrocution", 2.5);
            playfx(loadfx("maps/zombie/fx_transporter_beam"), player.origin);
            playfx(loadfx("maps/zombie/fx_transporter_pad_start"), player.origin);
            playfx(loadfx("maps/zombie/fx_transporter_start"), player.origin);
            playfx(loadfx("maps/zombie/fx_transporter_start"), player.origin);
            Earthquake(2, 1, player.origin, 100);
            wait 2;
            player playSound("teleport_2d_fnt");
            if (isdefined(image_room) && !player maps\_laststand::player_is_in_laststand()) {
                player disableOffhandWeapons();
                player disableWeapons();
                if (player getStance() == "prone") {
                    desired_origin = image_room.origin + prone_offset;
                } else if (player getStance() == "crouch") {
                    desired_origin = image_room.origin + crouch_offset;
                } else {
                    desired_origin = image_room.origin + stand_offset;
                }
                player.telelink = spawn("script_model", player.origin);
                player.telelink setmodel("tag_origin");
                player.telelink.origin = desired_origin;
                player.telelink.angles = image_room.angles;
                player playerLinkToAbsolute(player.telelink);
                player freezeControls(true);
            }
            wait 1.7;
            player.telelink delete();
            player unlink();
            player enableWeapons();
            player enableOffhandWeapons();
            player setOrigin(XIT);
            player setPlayerAngles((0, 0, 0));
            player shellshock("electrocution", 4);
            player freezeControls(false);
            level.TeleStationBuilding = undefined;
        }
    }
}
//Trampoline

doTrampoline() {
    if (!IsDefined(level.TrampoSpwnd) && level.Small == false && level.BigBoy == false && level.iTrampBase != true) {
        if (level.rainstarter == true) {
            if (isDefined(level.entitySpace)) return;
            level.entitySpace = true;
            level.TrampoSpwnd = true;
            self thread Trampoline();
            self thread SpawnRefresh();
        }
    }
    if (!IsDefined(level.TrampoSpwnd) && level.Small == false && level.BigBoy == false && level.iTrampBase != true) {
        if (level.Raindeletetime == true) {
            getPlayers()[0] notify("rain_sphere");
            if (isDefined(level.entitySpace)) return;
            level.entitySpace = true;
            level.BigBoy = true;
            level.TrampoSpwnd = true;
            self thread SpawnRefresh();
            self iPrintln("^1Deleting ^7Raining Models!");
            wait 7;
            self thread Trampoline();
        }
    }
    if (!IsDefined(level.TrampoSpwnd) && level.iTrampBase != true) {
        if (level.Small == true || level.BigBoy == true) {
            self playlocalsound("deny");
            self iPrintln("^1Error ^7Entity Limit Reached!");
        }
    } else {
        if (isDefined(level.TrampIsBuilding)) return;
        if (!IsDefined(level.TrampoSpwnd) && level.iTrampBase == true) {
            level.TrampTimer destroy();
            level notify("Tramp_Delete");
            self notify("Flips_Off");
            level.TrampSpwndBack = undefined;
            level thread TrampDelete2();
            level.TrampoSpwnd = true;
            level.iTrampBase = false;
            self thread SpawnRefresh();
            self thread createProgressBar_Delete(3, "Trampoline Deleting!", 1, "Trampoline Deleted!");
            for (a = 0; a < getPlayers().size; a++) {
                player = getPlayers()[a];
                if (isDefined(player.InTrampBase)) {
                    player returnToSpawn();
                    player allowJump(true);
                    player allowProne(true);
                    player allowLean(true);
                    player allowAds(true);
                    player allowSprint(true);
                    player allowCrouch(true);
                    player allowMelee(true);
                    player notify("Flips_Off");
                    player.InTrampBase = undefined;
                    if (self.GodModeIsOn == false) player disableGodMode();
                    else player enableGodMode();
                    player thread afterKillstreakProtection();
                }
            }
            wait 2.95;
            level.TrampoSpwnd = undefined;
            level thread TrampDelete();
            self thread SpawnRefresh();
        }
    }
}
Trampoline() {
    level.BigBoy = true;
    level.iTrampBase = true;
    level.TrampIsBuilding = true;
    self thread createProgressBar(3.2, "Trampoline Spawning!", 1, "Trampoline Spawned!");
    self thread Tramp_Tele();
    FloorO = (702, -2060, 85);
    level.Tramp = [];
    for (a = 0; a < 7; a++) {
        for (b = 0; b < 4; b++) {
            i = level.Tramp.size;
            level.Tramp[i] = spawn("script_model", (FloorO[0] + (a * 50), FloorO[1] + (b * 80), FloorO[2] - 10));
            level.Tramp[i] setModel("zombie_vending_doubletap_on");
            level.Tramp[i].angles = (0, 0, 90);
            level.Tramp[i] TrampA();
            wait .05;
        }
    }
    BigWallO = (702, -1817.13, 83);
    CollisionOriginLeft = (687, -1817.13, 83);
    CollisionOriginRight = (717, -1817.13, 83);
    level.Barrier = [];
    level.Collision = [];
    for (a = 0; a < 7; a++) {
        for (b = 0; b < 3; b++) {
            i = level.Barrier.size;
            i = level.Collision.size;
            level.Barrier[i] = spawn("script_model", (BigWallO[0] + (a * 50), BigWallO[1], BigWallO[2] + (b * 80)));
            level.Barrier[i] setModel("zombie_vending_doubletap_on");
            level.Barrier[i].angles = (0, 180, 0);
            level.Barrier[i] TrampA();
            level.Collision[i] = spawn("trigger_radius", (0, 0, 0), 0, 12, 500);
            level.Collision[i].origin = (BigWallO[0] + (a * 50), BigWallO[1], BigWallO[2] + (b * 80));
            level.Collision[i] setContents(1);
            level.Collision[i] TrampA();
            level.Collision[i] = spawn("trigger_radius", (0, 0, 0), 0, 12, 500);
            level.Collision[i].origin = (CollisionOriginLeft[0] + (a * 50), CollisionOriginLeft[1], CollisionOriginLeft[2] + (b * 80));
            level.Collision[i] setContents(1);
            level.Collision[i] TrampA();
            level.Collision[i] = spawn("trigger_radius", (0, 0, 0), 0, 12, 500);
            level.Collision[i].origin = (CollisionOriginRight[0] + (a * 50), CollisionOriginRight[1], CollisionOriginRight[2] + (b * 80));
            level.Collision[i] setContents(1);
            level.Collision[i] TrampA();
            wait .05;
        }
    }
    SmallWallO = (1036, -2050, 83);
    CollisionOriginLeft2 = (1036, -2035, 83);
    CollisionOriginRight2 = (1036, -2065, 83);
    level.Barrier2 = [];
    level.Collision2 = [];
    for (a = 0; a < 5; a++) {
        for (b = 0; b < 3; b++) {
            i = level.Barrier2.size;
            level.Barrier2[i] = spawn("script_model", (SmallWallO[0], SmallWallO[1] + (a * 50), SmallWallO[2] + (b * 80)));
            level.Barrier2[i] setModel("zombie_vending_doubletap_on");
            level.Barrier2[i].angles = (0, 90, 0);
            level.Barrier2[i] TrampA();
            level.Collision2[i] = spawn("trigger_radius", (0, 0, 0), 0, 12, 500);
            level.Collision2[i].origin = (SmallWallO[0], SmallWallO[1] + (a * 50), SmallWallO[2] + (b * 80));
            level.Collision2[i] setContents(1);
            level.Collision2[i] TrampA();
            level.Collision2[i] = spawn("trigger_radius", (0, 0, 0), 0, 12, 500);
            level.Collision2[i].origin = (CollisionOriginLeft2[0], CollisionOriginLeft2[1] + (a * 50), CollisionOriginLeft2[2] + (b * 80));
            level.Collision2[i] setContents(1);
            level.Collision2[i] TrampA();
            level.Collision2[i] = spawn("trigger_radius", (0, 0, 0), 0, 12, 500);
            level.Collision2[i].origin = (CollisionOriginRight2[0], CollisionOriginRight2[1] + (a * 50), CollisionOriginRight2[2] + (b * 80));
            level.Collision2[i] setContents(1);
            level.Collision2[i] TrampA();
            wait .05;
        }
    }
    JumpC = (647, -1917, 253);
    level.JumpCollision = [];
    level.JumpCollision TrampA();
    for (a = 0; a < 5; a++) {
        for (b = 0; b < 1; b++) {
            i = level.JumpCollision.size;
            level.JumpCollision[i] = spawn("trigger_radius", (0, 0, 0), 0, 20, 500);
            level.JumpCollision[i].origin = (JumpC[0], JumpC[1] + (a * 50), JumpC[2] + (b * 30));
            level.JumpCollision[i] setContents(1);
            level.JumpCollision[i] TrampA();
        }
    }
    for (i = 0; i < getPlayers().size; i++) {
        getPlayers()[i] thread Watch4Jump(level.Tramp);
    }
    level.TrampSpwndBack = true;
    level.TrampIsBuilding = undefined;
    level.TrampoSpwnd = undefined;
    self thread SpawnRefresh();
}
TrampDelete() {
    level.TrampIsBuilding = true;
    for (a = 0; a < level.iTrampArray.size; a++) level.iTrampArray[a] delete();
    level.iTrampArray = undefined;
    level.entitySpace = undefined;
    level.TrampIsBuilding = undefined;
    level.Raindeletetime = false;
    level.rainstarter = true;
    level.BigBoy = false;
}
TrampDelete2() {
    for (a = 0; a < level.iTrampArray2.size; a++) level.iTrampArray2[a] delete();
    level.iTrampArray2 = undefined;
}
TrampA() {
    if (!isDefined(level.iTrampArray)) level.iTrampArray = [];
    a = level.iTrampArray.size;
    level.iTrampArray[a] = self;
}
TrampA2() {
    if (!isDefined(level.iTrampArray2)) level.iTrampArray2 = [];
    a = level.iTrampArray2.size;
    level.iTrampArray2[a] = self;
}
Watch4Jump(Tramp) {
    level endon("Tramp_Delete");
    for (;;) {
        for (i = 0; i <= Tramp.size - 1; i++) {
            if (distance(self.origin, Tramp[i].origin) < 45) {
                v = self getVelocity();
                z = randomIntRange(9000, 10000);
                self setVelocity((v[0], v[1], z));
                Tramp[i] setModel("zombie_vending_sleight_on");
                Tramp[i] TrampA();
                wait .3;
                Tramp[i] setModel("zombie_vending_doubletap_on");
                Tramp[i] TrampA();
            }
        }
        wait .05;
    }
}
Tramp_Tele() {
    self thread TeleporterFx();
    WobbleLink = spawn("script_origin", (448, -1824, 132));
    Tele[0] = spawn("script_model", (454, -1834, 59.5));
    Tele[0] setModel("static_peleliu_filecabinet_metal");
    Tele[0] TrampA();
    Tele[1] = spawn("script_model", Tele[0].origin + (0, 0, 64));
    Tele[1] setModel(Tele[0].model);
    Tele[1] TrampA();
    Tele[2] = spawn("script_model", (451, -1834, 195.5));
    Tele[2] setModel(Tele[0].model);
    Tele[2] TrampA();
    Tele[2].angles = (90, 180, 0);
    Tele[3] = spawn("script_model", Tele[2].origin + (-2, 0, 0));
    Tele[3] setModel(Tele[0].model);
    Tele[3] TrampA();
    Tele[3].angles = (-90, 180, 0);
    for (i = 0; i <= Tele.size - 1; i++) {
        Tele[i] linkTo(WobbleLink);
    }
    WobbleLink thread maps\_zombiemode_powerups::PowerUp_Wobble("disconnect");
    pos = (438, -1827, 59);
    TrampTrig = spawnTrigger(pos, 30);
    TrampTrig TrampA2();
    TrampTrig setString("Press & Hold [{+activate}] To Get on Trampoline[^230 Seconds^7]");
    for (;;) {
        TrampTrig waittill("trigger", i);
        if (i useButtonPressed() && i.is_zombie == false && isDefined(level.TrampSpwndBack)) {
            level.TrampIsBuilding = true;
            i.InTrampBase = true;
            i thread ToTramp();
            wait 1;
        }
    }
}
TeleporterFx() {
    level endon("Tramp_Delete");
    for (;;) {
        playFx(loadFx("maps/zombie/fx_transporter_beam"), (448, -1824, 65));
        RandWait = randomInt(5);
        wait(RandWait);
    }
}
ToTramp() {
    self.OnTramp = 1;
    self thread exitMenu();
    self.ToTramp = spawn("script_origin", (438, -1827, 59));
    self playerlinkto(self.ToTramp);
    self.ToTramp moveZ((280), 2, .5, .5);
    self.ToTramp waittill("movedone");
    self.ToTramp moveTo((888, -1920, 306), 2, .5, .5);
    self.ToTramp waittill("movedone");
    self unlink();
    self.ToTramp delete();
    self thread Tramp_Timer();
    self thread Tramp_Flips();
    self thread Tramp_OnscreenText();
    self allowLean(false);
    self allowAds(false);
    self allowSprint(false);
    self allowProne(false);
    self allowCrouch(false);
    self allowMelee(false);
    level.TrampIsBuilding = undefined;
    if (!isDefined(self.InTrampBase)) return;
    wait 5;
    if (!isDefined(self.InTrampBase)) return;
    wait 5;
    if (!isDefined(self.InTrampBase)) return;
    wait 5;
    if (!isDefined(self.InTrampBase)) return;
    wait 5;
    if (!isDefined(self.InTrampBase)) return;
    wait 5;
    if (!isDefined(self.InTrampBase)) return;
    wait 5;
    if (!isDefined(self.InTrampBase)) return;
    if (isDefined(self.InTrampBase)) {
        level.TrampIsBuilding = true;
        self setPlayerAngles((0, 90, 0));
        self allowLean(true);
        self allowAds(true);
        self allowSprint(true);
        self allowProne(true);
        self allowCrouch(true);
        self allowMelee(true);
        self notify("Flips_Off");
        self.FromTramp = spawn("script_origin", self.origin);
        self playerLinkTo(self.FromTramp);
        self.FromTramp moveTo((309, -1738, 52.0161), 2, .5, .5);
        self.FromTramp waittill("movedone");
        self unlink();
        self.FromTramp delete();
        self.OnTramp = 0;
        self.InTrampBase = undefined;
        level.TrampIsBuilding = undefined;
    }
}
Tramp_Timer() {
    level.TrampTimer = createFontString("objective", 1.5, self);
    level.TrampTimer setPoint("CENTER", "CENTER", 0, 100);
    for (i = 30; i > -1; i--) {
        level.TrampTimer setText("Time Remaining On Trampoline: " + i + " Seconds");
        if (i == 1) {
            level.TrampTimer setText("Time Remaining On Trampoline: " + i + " Second");
        }
        if (i == 0) {
            level.TrampTimer destroy();
        }
        wait 1;
    }
}
Tramp_Flips() {
    level endon("Tramp_Delete");
    self endon("Flips_Off");
    self.currentFlip = false;
    for (;;) {
        wait .05;
        if (self meleeButtonPressed() && self.currentFlip == false) {
            self.currentFlip = true;
            for (i = 0; i <= 360; i += 8) {
                self setPlayerAngles(self.angles + (0, 0, i));
                wait(0.000000001);
            }
            self.currentFlip = false;
        }
        if (self fragButtonPressed() && self.currentFlip == false) {
            self.currentFlip = true;
            for (i = 0; i >= -360; i -= 8) {
                self setPlayerAngles(self.angles + (0, 0, i));
                wait(0.000000001);
            }
            self.currentFlip = false;
        }
    }
}
Tramp_OnscreenText() {
    level.TrampT1 = self createtxt1("Press [{+melee}] To Do a Right Flip", "CENTER", "MIDDLE", 300, -40, 1, 1.3);
    level.TrampT2 = self createtxt1("Press [{+frag}] To Do a Left Flip", "CENTER", "MIDDLE", 300, -20, 1, 1.3);
    level.TrampT1 TrampA();
    level.TrampT2 TrampA();
    self waittill("Flips_Off");
    level.TrampT1 destroy();
    level.TrampT2 destroy();
}

//Ziplines

Ziplinesx() {
    if (!IsDefined(level.zipline) && level.BigBoy == false) {
        level.zipline = true;
        level.Small = true;
        self thread SpawnRefresh();
        self thread Zipline();
        self thread Zipline2();
        self iPrintln("Ziplines ^2Spawned");
    }
    if (!IsDefined(level.zipline) && level.BigBoy == true) {
        self playlocalsound("deny");
        self iPrintln("^1Error ^7Entity Limit Reached!");
    }
}
Zipline() {
    level thread add_zombie_hint("Zipline", "Press &&1 To Use Zipline [Cost: 500]");
    trig = spawn("trigger_radius", (545.127, -2231.86, 276.125), 1, 50, 100);
    mod = spawn("script_model", (545.127, -2231.86, 450.125));
    mod.angles = (180, 0, 0);
    mod setModel("zombie_zapper_tesla_coil");
    playFx(loadfx("misc/fx_zombie_electric_trap"), (545.127, -2231.86, 324.125));
    trig setCursorHint("HINT_NOICON");
    trig useTriggerRequireLookAt();
    trig set_hint_string(trig, "Zipline");
    for (;;) {
        trig waittill("trigger", who);
        if (who useButtonPressed() && who.score >= 500) {
            who thread Zippin();
            wait 1;
        }
        wait 0.1;
    }
}

Zipline2() {
    level thread add_zombie_hint("Zipline", "Press &&1 To Use Zipline [Cost: 500]");
    trig = spawn("trigger_radius", (844.294, 915.127, 168.127), 1, 50, 100);
    mod = spawn("script_model", (844.294, 915.127, 292.127));
    mod.angles = (180, 0, 0);
    mod setModel("zombie_zapper_tesla_coil");
    playFx(loadfx("misc/fx_zombie_electric_trap"), (844.294, 915.127, 168.127));
    trig setCursorHint("HINT_NOICON");
    trig useTriggerRequireLookAt();
    trig set_hint_string(trig, "Zipline");
    for (;;) {
        trig waittill("trigger", who);
        if (who useButtonPressed() && who.score >= 500) {
            who thread Zippinz();
            wait 1;
        }
        wait 0.1;
    }
}

Zippinz() {
    self.score_total = self.score_total - 500;
    self.score = self.score - 500;
    Ziplinez = spawn("script_origin", self.origin + (0, 0, 30));
    self playerLinkToDelta(Ziplinez);
    wait .1;
    Ziplinez moveTo((-100.041, 101.437, 93.125), 2.5);
    self disableOffhandWeapons();
    self disableWeaponCycling();
    gun = self getCurrentWeapon();
    weapon = "zombie_knuckle_crack";
    self giveWeapon(weapon);
    self switchToWeapon(weapon);
    wait 2.5;
    self enableOffhandWeapons();
    self enableWeaponCycling();
    self takeWeapon(weapon);
    self giveWeapon(gun);
    self switchToWeapon(gun);
    self unlink();
    wait 12;
    Ziplinez delete();
}

Zippin() {
    self.score_total = self.score_total - 500;
    self.score = self.score - 500;
    Zipline = spawn("script_origin", self.origin + (0, 0, 30));
    self playerLinkToDelta(Zipline);
    wait .1;
    Zipline moveTo((38.3925, -1425.88, 191.125), 2.5);
    self disableOffhandWeapons();
    self disableWeaponCycling();
    gun = self getCurrentWeapon();
    weapon = "zombie_knuckle_crack";
    self giveWeapon(weapon);
    self switchToWeapon(weapon);
    wait 2.5;
    self enableOffhandWeapons();
    self enableWeaponCycling();
    self takeWeapon(weapon);
    self giveWeapon(gun);
    self switchToWeapon(gun);
    self unlink();
    wait 12;
    Zipline delete();
}

//Teeth Trap

TeethTrap() {
    if (!IsDefined(level.Trap) && level.BigBoy == false) {
        level.Trap = true;
        level.Small = true;
        self iPrintln("Teeth Trap Is ^2Spawned");
        self thread SpawnRefresh();
       // self thread initTeethTrap();
    }
    if (!IsDefined(level.Trap) && level.BigBoy == true) {
        self playlocalsound("deny");
        self iPrintln("^1Error ^7Entity Limit Reached!");
    }
}

//LunarLanders

LunarLanders() {
    if (!IsDefined(level.Lander) && level.BigBoy == false) {
        level.Lander = true;
        level.Small = true;
        //self thread survivalLunarLanders();
        self iPrintln("Lunar Landers ^2Spawned");
        self thread SpawnRefresh();
    }
    if (!IsDefined(level.Lander) && level.BigBoy == true) {
        {
            self playlocalsound("deny");
            self iPrintln("^1Error ^7Entity Limit Reached!");
        }
    }
}


//Flinger

Flinger() {
    if (!IsDefined(level.flinger) && level.BigBoy == false) {
        level.flinger = true;
        level.Small = true;
        self thread build_flinger();
        self thread SpawnRefresh();
        self iPrintln("Flinger ^2Spawned");
    }
    if (!IsDefined(level.flinger) && level.BigBoy == true) {
        self playlocalsound("deny");
        self iPrintln("^1Error ^7Entity Limit Reached!");
    }
}

build_flinger() {
    level.BaBaBaseline[0] = spawn("script_model", (-61, 138, 94));
    level.BaBaBaseline[0] setModel("zombie_treasure_box_lid");
    for (b = 1; b <= 10; b++) {
        k = b - 1;
        level.BaBaBaseline[b] = spawn("script_model", level.BaBaBaseline[k].origin + (0, 6, 0));
        level.BaBaBaseline[b] setModel("zombie_treasure_box_lid");
        level.BaBaBaseline[b] linkTo(level.BaBaBaseline[k]);
    }
    self thread Flinger_Control();
}

Flinger_Control() {
    level thread add_zombie_hint("Flinger", "Press &&1 To Use The Flinger");
    trig = spawn("trigger_radius", level.BaBaBaseline[5].origin, 1, 15, 15);
    trig setCursorHint("HINT_NOICON");
    trig useTriggerRequireLookAt();
    trig set_hint_string(trig, "Flinger");
    for (;;) {
        trig waittill("trigger", i);
        if (i UseButtonPressed()) {
            i thread Fling();
            wait 1;
        }
    }
}

Fling() {
    self.fling = spawn("script_model", level.BaBaBaseline[5].origin);
    self enableHealthShield(true);
    self enableInvulnerability();
    self playerLinkTo(self.fling);
    self.fling moveTo((300, -1720, 720), 1.5);
    level.BaBaBaseline[0] rotateroll(45, .9);
    self.fling waittill("movedone");
    self.fling moveto((300, -1740, 57), .9);
    self.fling waittill("movedone");
    self.fling delete();
    if (self.GodModeIsOn == false) {
        self enableHealthShield(false);
        self disableInvulnerability();
    }
    self unlink();
    level.BaBaBaseline[0] rotateroll(-45, .9);
}

//Smelter

smelter1() {
    if (!IsDefined(level.Smelter) && level.BigBoy == false) {
        level.Smelter = true;
        level.Small = true;
        self iPrintln("smelter ^2Spawned");
        self thread SpawnRefresh();
       // self thread smelter();
    }
    if (!IsDefined(level.Smelter) && level.BigBoy == true) {
        self playlocalsound("deny");
        self iPrintln("^1Error ^7Entity Limit Reached!");
    }
}

//Fog

SpawnFog() {
    if (!IsDefined(level.Fog) && level.BigBoy == false) {
        level.Fog = true;
        level.Small = true;
        self thread SpawnRefresh();
        self iPrintln("Fog ^2Created");
        playfx(level._effect["edge_fog"], (311.925, -2292.73, 90.146));
        wait .05;
        playfx(level._effect["edge_fog"], (278.564, -1442.75, 90.135));
        wait .05;
        playfx(level._effect["edge_fog"], (290.189, -992.774, 90.135));
        wait .05;
        playfx(level._effect["edge_fog"], (-130.33, -1171.21, 180.135));
        wait .05;
        playfx(level._effect["edge_fog"], (107.529, -694.124, 90.135));
        wait .05;
        playfx(level._effect["edge_fog"], (-23.0436, -186.554, 90.135));
        wait .05;
        playfx(level._effect["edge_fog"], (-425.562, 486.842, 90.135));
        wait .05;
        playfx(level._effect["edge_fog"], (650.001, 602.915, 90.135));
        wait .05;
        playfx(level._effect["edge_fog"], (200.819, 541.238, 90.009));
        wait .05;
        playfx(level._effect["edge_fog"], (-778.52, -709.506, 90.562));
        wait .05;
        playfx(level._effect["edge_fog"], (-1084.24, 108.086, 44.2132));
    }
    if (!IsDefined(level.Fog) && level.BigBoy == true) {
        self playlocalsound("deny");
        self iPrintln("^1Error ^7Entity Limit Reached!");
    }
}

//Big Moon

spawnBigMoon() {
    if (!IsDefined(level.MoonSpawned) && level.BigBoy == false) {
        level.MoonSpawned = true;
        level.Small = true;
        self iPrintln("Big Moon ^2Spawned");
        self thread SpawnRefresh();
        bigMoon = spawnSM((-403, 1161, 1760), "tag_origin", (20, -70, 0));
        playFxOnTag(level._effect["zombie_moon_eclipse"], bigMoon, "tag_origin");
    }
    if (!IsDefined(level.MoonSpawned) && level.BigBoy == true) {
        self playlocalsound("deny");
        self iPrintln("^1Error ^7Entity Limit Reached!");
    }
}

MapLights() {
    if (!IsDefined(level.lightsSpawned) && level.BigBoy == false) {
        self iPrintln("Map Lights ^2Spawned");
        level.lightsSpawned = true;
        level.Small = true;
        self thread SpawnRefresh();
        self thread newMenu("spawn");
        self thread MapLights_true();
    }
    if (!IsDefined(level.lightsSpawned) && level.BigBoy == true) {
        self playlocalsound("deny");
        self iPrintln("^1Error ^7Entity Limit Reached!");
    }
}

MapLights_true() {
    L[0] = (191, -2392, 88);
    L[1] = (58, -2392, 88);
    L[2] = (191, -2347, 88);
    L[3] = (58, -2347, 88);
    L[4] = (197, -2871, 87);
    L[5] = (392, -2871, 87);
    L[6] = (379, -2016, 89);
    L[7] = (142, -2016, 89);
    L[8] = (400, -1931, 64);
    L[9] = (159, -1931, 90);
    L[10] = (456, -1071, 66);
    L[11] = (456, -1209, 67);
    L[12] = (108, -1039, 191);
    L[13] = (108, -1170, 192);
    L[14] = (-876, -344, 67);
    L[15] = (-699, -344, 67);
    L[16] = (-620, -101, 69);
    L[17] = (-620, -284, 69);
    L[18] = (832, 373, 64);
    L[19] = (679, 373, 64);
    L[20] = (-309, -23, 69);
    L[21] = (-309, -164, 69);
    L[22] = (-148, 90, 93);
    L[23] = (36, 90, 93);
    L[24] = (-110, -280, -2);
    L[25] = (-227, -280, -2);
    L[26] = (-569, -811, 67);
    L[27] = (-569, -910, 67);
    L[28] = (-403, -1279, 199);
    L[29] = (-403, -1156, 199);
    L[30] = (500, -1066, 249);
    L[31] = (500, -960, 253);
    L[32] = (582, -2712, 93);
    L[33] = (582, -2679, 118);
    L[34] = (582, -2630, 155);
    L[35] = (582, -2574, 197);
    L[36] = (582, -2520, 238);
    L[37] = (582, -2471, 272);
    L[38] = (496, -2712, 93);
    L[39] = (496, -2679, 118);
    L[40] = (496, -2630, 155);
    L[41] = (496, -2574, 197);
    L[42] = (496, -2520, 238);
    L[43] = (496, -2471, 272);
    L[44] = (145, -1188, 207);
    L[45] = (219, -1188, 214);
    L[46] = (303, -1188, 223);
    L[47] = (388, -1188, 234);
    L[48] = (472, -1188, 247);
    L[49] = (145, -1317, 207);
    L[50] = (219, -1317, 214);
    L[51] = (303, -1317, 223);
    L[52] = (388, -1317, 234);
    L[53] = (472, -1317, 247);
    L[54] = (-867, -1143, 199);
    L[55] = (-867, -1264, 199);
    L[56] = (-1139, -1270, 199);
    L[57] = (-1139, -1138, 199);
    L[58] = (-1379, -767, 199);
    L[59] = (-1246, -767, 199);
    L[60] = (-1299, -1464, 199);
    L[61] = (-1432, -1464, 199);
    L[62] = (-1306, -1503, 191);
    L[63] = (-1428, -1503, 191);
    L[64] = (-1310, -1169, 199);
    L[65] = (-1343, -1169, 199);
    L[66] = (-1384, -1169, 199);
    L[67] = (-1428, -1169, 199);
    L[68] = (-1310, -1077, 199);
    L[69] = (-1343, -1077, 199);
    L[70] = (-1384, -1077, 199);
    L[71] = (-1428, -1077, 199);
    L[72] = (-505, -814, 105);
    L[73] = (-456, -814, 133);
    L[74] = (-505, -910, 105);
    L[75] = (-456, -910, 133);
    L[76] = (-454, -964, 167);
    L[77] = (-454, -1013, 199);
    L[78] = (682, 322, 64);
    L[79] = (820, 322, 64);
    L[80] = (792, -60, 66);
    L[81] = (792, -212, 64);
    L[82] = (1066, 367, 64);
    L[83] = (1067, 321, 64);
    L[84] = (1211, 321, 65);
    L[85] = (1039, 650, 70);
    L[86] = (1039, 710, 114);
    L[87] = (1039, 760, 152);
    L[88] = (1039, 794, 166);
    L[89] = (1039, 912, 167);
    L[90] = (933, 650, 70);
    L[91] = (933, 710, 114);
    L[92] = (933, 760, 152);
    L[93] = (933, 794, 166);
    L[94] = (933, 912, 167);
    L[95] = (933, 833, 167);
    L[96] = (933, 880, 167);
    L[97] = (1479, 650, 71);
    L[98] = (1479, 709, 111);
    L[99] = (1479, 760, 148);
    L[100] = (1479, 795, 164);
    L[101] = (1479, 890, 164);
    L[102] = (1479, 920, 164);
    L[103] = (1584, 650, 71);
    L[104] = (1584, 709, 111);
    L[105] = (1584, 760, 148);
    L[106] = (1584, 795, 164);
    L[107] = (1584, 890, 164);
    L[108] = (1584, 920, 164);
    L[109] = (326, 368, 64);
    L[110] = (326, 227, 63);
    L[111] = (-364, -1156, 191);
    L[112] = (-364, -1282, 191);
    for (i = 0; i <= L.size - 1; i++) {
        PlayFx(level._effect["mp_light_lamp"], L[i]);
        wait .05;
    }
}

/* More GameTypes */

initStructures() {
    pos = [];
    pos[0] = (-1570, -1123, 199.125);
    pos[1] = (1364, 1040, 168.125);
    pos[2] = (449, -3034, 156.125);
    pos[3] = (-471, 549, -2.875);
    ang = [];
    ang[0] = (0, 0, 0);
    ang[1] = (0, -180, 0);
    ang[2] = (0, -180, 0);
    ang[3] = (0, 0, 0);
    hud = [];
    hud[0] = "-26 -26";
    hud[1] = "50 37";
    hud[2] = "-78 8";
    hud[3] = "42 -12";
    rInt = arrayIntRandomize(0, 3);
    for (m = 0; m < getPlayers().size; m++) {
        sPos = pos[rInt[m]];
        spawnObjPointer(getPlayers()[m], sPos + (0, 0, 100), "offscreen_icon_us");
        spawnSM(sPos + (50, 50, 0), "static_peleliu_filecabinet_metal", (0, -90, 0));
        spawnSM(sPos + (-50, 50, 0), "static_peleliu_filecabinet_metal", (0, 90, 0));
        spawnSM(sPos + (50, -50, 0), "static_peleliu_filecabinet_metal", (0, -90, 0));
        spawnSM(sPos - (50, 50, 0), "static_peleliu_filecabinet_metal", (0, 90, 0));
        spawnSM(sPos + (50, 50, 0), "static_peleliu_filecabinet_metal");
        spawnSM(sPos + (-50, 50, 0), "static_peleliu_filecabinet_metal");
        spawnSM(sPos + (50, -50, 0), "static_peleliu_filecabinet_metal", (0, 180, 0));
        spawnSM(sPos - (50, 50, 0), "static_peleliu_filecabinet_metal", (0, 180, 0));
        level thread doStructureFx(sPos);
        level thread doStructureFx2(sPos + (-50, -50, 30));
        plr = getPlayers()[m];
        plr.invenSkulls = 0;
        plr.depoSkulls = 0;
        plr.withdrawnSkulls = 0;
        plr setInstructions("Inventory Skulls: ^2" + plr.invenSkulls + "   ^7-   Deposited Skulls: ^2" + plr.depoSkulls + "   ^7-   Withdrawn Skulls: ^2" + plr.withdrawnSkulls);
        plr thread showMyStation(hud[rInt[m]], rInt[m]);
        plr thread stationWatch(sPos);
        plr thread skullExplosion();
        plr thread scoreBoard();
        plr thread skullDisplay();
        plr.homeBase = [];
        plr.homeBase["origin"] = sPos;
        plr.homeBase["angles"] = ang[rInt[m]];
    }
}

doStructureFx(pos) {
    light = [];
    randy = randomInt(360);
    for (m = randy; m <= randy + 360; m += 30) {
        light[light.size] = spawnSM(pos + (cos(m) * 20, sin(m) * 20, 0), "zombie_zapper_cagelight_green", (180, 0, 0));
        wait .05;
    }
    for (;;) {
        randy = randomInt(light.size);
        for (m = randy; m < light.size; m++) {
            light[m] setModel("zombie_zapper_cagelight_red");
            wait .05;
        }
        for (m = 0; m < randy; m++) {
            light[m] setModel("zombie_zapper_cagelight_red");
            wait .05;
        }
        randy = randomInt(light.size);
        for (m = randy; m < light.size; m++) {
            light[m] setModel("zombie_zapper_cagelight_green");
            wait .05;
        }
        for (m = 0; m < randy; m++) {
            light[m] setModel("zombie_zapper_cagelight_green");
            wait .05;
        }
    }
}

doStructureFx2(pos) {
    fx = spawnSM(pos, "tag_origin");
    playFxOnTag(level._effect["tesla_bolt"], fx, "tag_origin");
    for (;;) {
        fx moveX(100, .4);
        wait .4;
        fx moveY(100, .4);
        wait .4;
        fx moveX(-100, .4);
        wait .4;
        fx moveY(-100, .4);
        wait .4;
    }
}

initSkullZombies() {
    for (;;) {
        zom = getAiSpeciesArray("axis", "all");
        for (m = 0; m < zom.size; m++)
            if (!isDefined(zom[m].skullInit) && zom[m] inMap() && isDefined(zom[m]))
                zom[m] thread skullZomInit();
        wait .05;
    }
}

skullZomInit() {
    self.skullInit = true;
    self waittill("death");
    skull = spawnSM(self.origin + (0, 0, 40), "zombie_skull");
    skull endon("powerup_timedout");
    skull thread maps\_zombiemode_powerups::powerup_timeout();
    skull physicsLaunch((randomIntRange(-200, 200), randomIntRange(-200, 200), 200));
    playFxOnTag(level._effect["powerup_on"], skull, "tag_origin");
    playSoundatPosition("pa_buzz", skull.origin);
    while (isDefined(skull)) {
        plr = getPlayers();
        for (m = 0; m < plr.size; m++) {
            if (distance(plr[m].origin, skull.origin) < 64 && !isDefined(plr[m].revivetrigger)) {
                playFx(level._effect["powerup_grabbed"], skull.origin);
                playFx(level._effect["powerup_grabbed_wave"], skull.origin);
                wait .1;
                playSoundAtPosition("powerup_grabbed", skull.origin);
                skull notify("powerup_grabbed");
                plr[m] notify("skull_picked");
                skull delete();
                break;
            }
        }
        wait .05;
    }
}

skullDisplay() {
    self endon("disconnect");
    self endon("death");
    link = spawnSM(self.origin + (0, 0, 100), "tag_origin");
    skull = [];
    for (m = 0; m < 360; m += 45) {
        skull[skull.size] = spawnSM(link.origin + (cos(m) * 30, sin(m) * 30, 0), "tag_origin", (0, m, 0));
        skull[skull.size - 1] linkTo(link);
    }
    self.scavSkulls = skull;
    link thread sSkullFollowPlayer(self);
    for (;;) {
        self waittill("skull_picked");
        if (self.invenSkulls == 8) {
            self iPrintln("^1ERROR: ^7Your Inventory Is Full!");
            self iPrintln("^2INFO: ^7Please Deposit Your Skulls!");
            continue;
        }
        randy = undefined;
        for (;;) {
            wait .05;
            randy = randomInt(skull.size);
            if (skull[randy].model == "tag_origin")
                break;
        }
        skull[randy] setModel("zombie_skull");
        self.invenSkulls++;
        self setInstructions("Inventory Skulls: ^2" + self.invenSkulls + "   ^7-   Deposited Skulls: ^2" + self.depoSkulls + "   ^7-   Withdrawn Skulls: ^2" + self.withdrawnSkulls);
    }
}

sSkullFollowPlayer(plr) {
    plr endon("death");
    plr endon("disconnect");
    for (;;) {
        self moveTo(plr.origin + (0, 0, 100), .1);
        self rotateYaw(-18, .1);
        wait .05;
    }
}

showMyStation(coords, num) {
    self endon("disconnect");
    self endon("death");
    abc = "abcd";
    coords = strTok(coords, " ");
    menu = self createRectangle("CENTER", "CENTER", 0, 0, 0, 0, (1, 1, 1), "menu_map_nazi_zombie_factory", 1, 1);
    menu scaleOverTime(.6, 200, 100);
    wait .6;
    obj = self createRectangle("CENTER", "CENTER", 0, 0, 0, 0, (1, 1, 1), "objective" + abc[num], 2, 1);
    obj scaleOverTime(.6, 15, 15);
    wait .6;
    obj moveOverTime(1);
    obj setPoint("CENTER", "CENTER", int(coords[0]), int(coords[1]));
    wait 1;
    self setOrigin(self.homeBase["origin"]);
    self setPlayerAngles(self.homeBase["angles"]);
    wait 1;
    obj moveOverTime(1);
    menu moveOverTime(1);
    obj setPoint("CENTER", "CENTER", obj.x - 200, obj.y + 160);
    menu setPoint("CENTER", "CENTER", menu.x - 200, menu.y + 160);
    wait 1;
    for (;;) {
        fx = self createRectangle("CENTER", "CENTER", obj.x, obj.y, 100, 100, (1, 1, 1), "hud_checkbox_active", 3, 1);
        fx scaleOverTime(.4, 17, 17);
        wait .4;
        fx hudFadenDestroy(0, .4);
        wait(randomIntRange(5, 10));
    }
}

stationWatch(ctr) {
    self endon("disconnect");
    self endon("death");
    self.stationTrig = spawn("trigger_radius", ctr, 1, 50, 50);
    trig = self.stationTrig;
    trig thread bootTehHackers(self);
    for (;;) {
        trig waittill("trigger", user);
        if (user useButtonPressed() && !user.is_zombie) {
            if (user == self) {
                if (self.invenSkulls <= 0) {
                    self playSound("packa_deny");
                    wait .2;
                } else if (self.invenSkulls > 0) {
                    time = 0;
                    bar = self createPrimaryProgressBar();
                    bar updateBar(0, 1);
                    text = self createPrimaryProgressBarText();
                    text setText("Skull Depositing!");
                    for (;;) {
                        time += .05;
                        if (!self useButtonPressed() || !self isTouching(trig))
                            break;
                        if (time >= 1) {
                            bar destroyElem();
                            text destroy();
                            randy = undefined;
                            for (e = 0; e < 10000; e++) {
                                randy = randomInt(self.scavSkulls.size);
                                if (self.scavSkulls[randy].model == "zombie_skull")
                                    break;
                            }
                            self.scavSkulls[randy] setModel("tag_origin");
                            self.invenSkulls--;
                            self.depoSkulls++;
                            self setInstructions("Inventory Skulls: ^2" + self.invenSkulls + "   ^7-   Deposited Skulls: ^2" + self.depoSkulls + "   ^7-   Withdrawn Skulls: ^2" + self.withdrawnSkulls);
                            self playSound("cha_ching");
                            if (self.depoSkulls == 40)
                                array_thread(getPlayers(), ::depoSkullsWon, self);
                            break;
                        }
                        wait .05;
                    }
                    if (isDefined(bar)) {
                        bar destroyElem();
                        text destroy();
                    }
                }
            }
            if (user != self) {
                if (self.depoSkulls <= 0) {
                    user playSound("packa_deny");
                    wait .2;
                }
                if (self.depoSkulls > 0) {
                    time = 0;
                    bar = user createPrimaryProgressBar();
                    bar updateBar(0, 1 / 5);
                    text = user createPrimaryProgressBarText();
                    text setText("Skull Withdrawing!");
                    user.isWithdrawing = true;
                    for (;;) {
                        time += .05;
                        if (!user useButtonPressed() || !user isTouching(trig))
                            break;
                        if (time >= 5) {
                            bar destroyElem();
                            text destroy();
                            self.depoSkulls--;
                            user.withdrawnSkulls++;
                            self setInstructions("Inventory Skulls: ^2" + self.invenSkulls + "   ^7-   Deposited Skulls: ^2" + self.depoSkulls + "   ^7-   Withdrawn Skulls: ^2" + self.withdrawnSkulls);
                            user setInstructions("Inventory Skulls: ^2" + user.invenSkulls + "   ^7-   Deposited Skulls: ^2" + user.depoSkulls + "   ^7-   Withdrawn Skulls: ^2" + user.withdrawnSkulls);
                            self playLocalSound("laugh_child");
                            user playSound("plr_" + user getEntityNumber() + "_vox_gen_laugh_" + randomInt(4));
                            break;
                        }
                        wait .05;
                    }
                    user.isWithdrawing = undefined;
                    if (isDefined(bar)) {
                        bar destroyElem();
                        text destroy();
                    }
                }
            }
        }
    }
}

bootTehHackers(user) {
    self endon("disconnect");
    self endon("death");
    for (;;) {
        plr = getPlayers();
        for (m = 0; m < plr.size; m++) {
            if (user isTouching(self) && plr[m] isTouching(self) && isDefined(plr[m].isWithdrawing)) {
                plr[m] setOrigin(plr[m].homeBase["origin"]);
                plr[m] setPlayerAngles(plr[m].homeBase["angles"]);
            }
        }
        wait .05;
    }
}

depoSkullsWon(winner) {
    self thread welcomeText("^1" + level.patch, "^2" + winner getName() + ": ^7Has Deposited 40 Skulls - ^6Therefore He Is The Winner! ^7-- ^2: ^7" + level.patchCreator);
    array_delete(getAiSpeciesArray("axis", "all"));
    self setClientDvar("g_ai", 0);
    self freezeControls(true);
    wait 5;
    self suicide();
}

skullExplosion() {
    self endon("disconnect");
    self endon("death");
    for (;;) {
        self waittill("player_downed");
        self playLocalSound("laugh_child");
        if (self.invenSkulls == 0)
            continue;
        temp = [];
        for (m = 0; m < self.scavSkulls.size; m++) {
            if (self.scavSkulls[m].model == "tag_origin")
                continue;
            temp[temp.size] = spawnSM(self.scavSkulls[m].origin, self.scavSkulls[m].model, self.scavSkulls[m].angles);
            self.scavSkulls[m] setModel("tag_origin");
            self.invenSkulls--;
        }
        for (m = 0; m < temp.size; m++)
            temp[m] thread skullv2();
        self setInstructions("Inventory Skulls: ^2" + self.invenSkulls + "   ^7-   Deposited Skulls: ^2" + self.depoSkulls + "   ^7-   Withdrawn Skulls: ^2" + self.withdrawnSkulls);
    }
}

skullv2() {
    self endon("powerup_timedout");
    self thread maps\_zombiemode_powerups::powerup_timeout();
    self physicsLaunch(self.origin, (randomIntRange(-200, 200), randomIntRange(-200, 200), 200));
    playFxOnTag(level._effect["powerup_on"], self, "tag_origin");
    playSoundatPosition("pa_buzz", self.origin);
    while (isDefined(self)) {
        plr = getPlayers();
        for (m = 0; m < plr.size; m++) {
            if (distance(plr[m].origin, self.origin) < 64 && !isDefined(plr[m].revivetrigger)) {
                playFx(level._effect["powerup_grabbed"], self.origin);
                playFx(level._effect["powerup_grabbed_wave"], self.origin);
                wait .1;
                playSoundAtPosition("powerup_grabbed", self.origin);
                self notify("powerup_grabbed");
                plr[m] notify("skull_picked");
                self delete();
                break;
            }
        }
        wait .05;
    }
}

skullsRevive() {
    for (;;) {
        player = getPlayers();
        for (m = 0; m < player.size; m++)
            if (isDefined(player[m].revivetrigger))
                player[m] thread doRevivee();
        wait .05;
    }
}

doRevivee() {
    self endon("death");
    self endon("disconnect");
    if (isDefined(self.doingRevive))
        return;
    self.doingRevive = true;
   // self.revivetrigger trigger_off_proc();
    self thread createProgressBar(3, "Reviving", 2, "Revived!");
    wait 3;
    self thread maps\_laststand::revive_force_revive();
    wait .05;
    self setOrigin(self.homeBase["origin"]);
    self setPlayerAngles(self.homeBase["angles"]);
    self.doingRevive = undefined;
}

scoreBoard() {
    self endon("disconnect");
    self endon("death");
    if (self == getPlayers()[0])
        createServerText(getFont(), 1.2, "TOPLEFT", "TOPLEFT", 20, 20, 1, 1, "^6Scoreboard:");
    txt = createServerText(getFont(), 1, "TOPLEFT", "TOPLEFT", 20, 30 + (self getEntityNumber() * 10), 1, 1, self getName() + ": Deposited Skulls: ^5" + self.depoSkulls);
    self thread destroyOnDeath(txt);
    for (;;) {
        for (;;) {
            txt.y = 30 + (self getEntityNumber() * 10);
            skulls = self.depoSkulls;
            wait .05;
            if (skulls != self.depoSkulls)
                break;
        }
        txt setText(self getName() + ": Deposited Skulls: ^5" + self.depoSkulls);
        wait .05;
    }
}

destroyOnDeath(hud) {
    self waittill_any("death", "disconnect");
    hud destroyElem();
}

initRainPour() {
    collectedNukes = 0;
    misses = 0;
    speed = 6;
    count = 0;
    count2 = 0;
    bar = createTeamBar((1, 1, 1), 300, 6);
    bar setPoint("CENTER", "BOTTOM", 0, -50);
    speedTxt = createServerText(getFont(), 1.3, "CENTER", "BOTTOM", 0, -65, 1, 1, "SPEED: ^2200");
    self setInstructions("Nukes Missed: 0   -   Lobby Nukes Collected: 0");
    for (;;) {
        amount = getPlayers().size;
        nuke = [];
        for (m = 0; m < amount; m++) {
            nuke[m] = spawnSM((randomIntRange(-370, 180), randomIntRange(-300, 180), 1200), "zombie_bomb", (90, 0, 0));
            if (!isDefined(level.rainDifficulty)) {
                for (t = 0; t < getPlayers().size; t++)
                    nuke[m] setInvisibleToPlayer(getPlayers()[t]);
                nuke[m] setVisibleToPlayer(getPlayers()[m]);
            }
            playFxOnTag(level._effect["powerup_on"], nuke[m], "tag_origin");
            nuke[m] moveTo((nuke[m].origin[0], nuke[m].origin[1], 0), speed);
            nuke[m] playSound("weap_pnzr_fire");
        }
        count2++;
        level thread rainPourCapture(nuke);
        wait(speed);
        for (m = 0; m < nuke.size; m++) {
            if (!isDefined(nuke[m])) {
                collectedNukes++;
                continue;
            }
            misses += 16;
            count++;
            if (count == 10)
                misses = 1000;
            playFx(loadFx("explosions/default_explosion"), nuke[m].origin);
            playSoundAtPosition("grenade_explode", nuke[m].origin);
            for (e = 0; e < getPlayers().size; e++)
                getPlayers()[e] doDamage(misses, nuke[m].origin, undefined, undefined, "riflebullet");
            if (!isDefined(level.rainDifficulty))
                iPrintLn("--- ^2" + getPlayers()[m] getName() + " ^7--- Missed a Nuke!");
            nuke[m] delete();
        }
        array_thread(getPlayers(), ::setInstructions, "Nukes Missed: " + count + "   -   Lobby Nukes Collected: " + collectedNukes);
        level notify("rainpour_captureover");
        speed -= .2;
        if (speed < 3)
            speed += .2;
        actualSpeed = ceil(1200 / speed);
        if (count2 <= 15) {
            bar.bar scaleOverTime(1, count2 * 20, bar.height);
            bar.bar fadeOverTime(1);
            speedTxt setText("SPEED: ^2" + actualSpeed);
        }
        wait .05;
    }
}

rainPourCapture(nuke) {
    level endon("rainpour_captureover");
    for (;;) {
        for (m = 0; m < nuke.size; m++)
            for (e = 0; e < getPlayers().size; e++)
                if (distance(getPlayers()[e] getTagOrigin("j_head"), nuke[m].origin) < 60) {
                    playSoundAtPosition("powerup_grabbed", nuke[m].origin);
                    playFx(loadFx("misc/fx_zombie_powerup_grab"), nuke[m].origin);
                    playFx(loadFx("misc/fx_zombie_powerup_wave"), nuke[m].origin);
                    nuke[m] delete();
                }
        wait .05;
    }
}

rainDif() {
    if (!isDefined(level.rainDifficulty)) {
        level.rainDifficulty = true;
        self updateMenu("rain", "Difficulty [^1Hard^7]", 0, true);
    } else {
        level.rainDifficulty = undefined;
        self updateMenu("rain", "Difficulty [^2Easy^7]", 0, true);
    }
    for (a = 0; a < getPlayers().size; a++) {
        player = getPlayers()[a];
        if (player getPrimaryMenu() == "rain")
            player refreshMenu();
    }
}

teslaFreezeTags_main() {
    self endon("death");
    self endon("disconnect");
    self disableWeaponCycling();
    self disableOffhandWeapons();
    self allowProne(false);
    self thread tft_keepHealth();
    self giveWeapon("tesla_gun_zm");
    self switchToWeapon("tesla_gun_zm");
    self giveMaxAmmo("tesla_gun_zm");
    self.teslaTags = 0;
    self.teslaFreeze_tagsHud = createServerText(getFont(), 1, "LEFT", "LEFT", 60, 80 + (self getEntityNumber() * 10), 1, 1, "^2" + self getName() + ": ^7[" + self.teslaTags + "] Tags");
    oldWinner = 0;
    self thread tft_detection();
    if (self == getPlayers()[0]) {
        createServerText(getFont(), 1.2, "LEFT", "LEFT", 60, 70, 1, 1, "^6Player Tesla Tags:");
        leaderHud = createServerText(getFont(), 1.2, "LEFT", "LEFT", 60, 80 + (getPlayers().size * 10), 1, 1, "^6Current Leader: " + getPlayers()[0] getName());
        for (;;) {
            tags = self.teslaTags;
            index = 0;
            for (m = 0; m < getPlayers().size; m++) {
                tempTags = getPlayers()[m].teslaTags;
                if (tempTags > tags) {
                    tags = tempTags;
                    index = m;
                }
            }
            if (index != oldWinner) {
                oldWinner = index;
                leaderHud setText("^6Current Leader: " + getPlayers()[index] getName());
            }
            wait .05;
        }
    }
}

tft_detection() {
    self endon("death");
    self endon("disconnect");
    for (;;) {
        self waittill("weapon_pvp_attack", attacker, weapon, damage, mod);
        if (mod != "MOD_PROJECTILE" && mod != "MOD_PROJECTILE_SPLASH")
            continue;
        if (attacker == self)
            continue;
        attacker.teslaTags++;
        attacker.teslaFreeze_tagsHud setText("^2" + attacker getName() + ": ^7[" + attacker.teslaTags + "] Tags");
        quotes = strTok("Tagged;Zapped;Electrocuted;Shocked;Stunned;Tasered", ";");
        iPrintln("^2" + attacker getName() + " ^7> " + quotes[randomInt(quotes.size)] + " > ^2" + self getName());
        attacker thread pickSpawnPoints();
        if (attacker.teslaTags == (getPlayers().size * 10))
            array_thread(getPlayers(), ::tft_endGame, attacker getName());
    }
}

tft_endGame(winner) {
    self freezeControls(true);
    self welcomeText("^1" + level.patch, "^2" + winner + " ^7Is The Winner! -- ^2Created By: ^7" + level.patchCreator);
    self suicide();
}

tft_keepHealth() {
    self endon("death");
    self endon("disconnect");
    for (;;) {
        self.maxhealth = 100;
        self.health = self.maxhealth;
        wait .05;
    }
}