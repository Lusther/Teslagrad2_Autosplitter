state("Teslagrad 2")
{
    bool blink__unlocked : "GameAssembly.dll", 0x3199E90, 0xB8, 0x10, 0x44;
    bool blue_cloak__unlocked : "GameAssembly.dll", 0x3199E90, 0xB8, 0x10, 0x45;
    bool waterblink__unlocked : "GameAssembly.dll", 0x3199E90, 0xB8, 0x10, 0x46;
    bool mjolnir__unlocked : "GameAssembly.dll", 0x3199E90, 0xB8, 0x10, 0x47;
    bool power_slide__unlocked : "GameAssembly.dll", 0x3199E90, 0xB8, 0x10, 0x48;
    bool axe__unlocked : "GameAssembly.dll", 0x3199E90, 0xB8, 0x10, 0x49;
    bool blink_wire_axe__unlocked : "GameAssembly.dll", 0x3199E90, 0xB8, 0x10, 0x4a;
    bool red_cloak__unlocked : "GameAssembly.dll", 0x3199E90, 0xB8, 0x10, 0x4b;
    bool omni_blink__unlocked : "GameAssembly.dll", 0x3199E90, 0xB8, 0x10, 0x4c;
    bool double_jump__unlocked : "GameAssembly.dll", 0x3199E90, 0xB8, 0x10, 0x4d;

    bool hulder__bossfight_beaten : "GameAssembly.dll", 0x3199E90, 0xB8, 0x10, 0x51;
    bool moose__bossfight_beaten : "GameAssembly.dll", 0x3199E90, 0xB8, 0x10, 0x52;
    bool fafnir__bossfight_beaten : "GameAssembly.dll", 0x3199E90, 0xB8, 0x10, 0x53;
    bool halvtann__bossfight_beaten : "GameAssembly.dll", 0x3199E90, 0xB8, 0x10, 0x54;
    bool galvan__bossfight_beaten : "GameAssembly.dll", 0x3199E90, 0xB8, 0x10, 0x55;
    bool troll__bossfight_beaten : "GameAssembly.dll", 0x3199E90, 0xB8, 0x10, 0x56;

    bool secrets_map__unlocked : "GameAssembly.dll", 0x3199E90, 0xB8, 0x10, 0x4e;

    string40 timeSpent : "GameAssembly.dll", 0x3199E90, 0xB8, 0x10, 0x28, 0x14;
    string255 current_scene : "GameAssembly.dll", 0x315AE88, 0xB8, 0x00, 0x28, 0x10, 0x14;

    int scroll_count : "GameAssembly.dll", 0x3199E90, 0xB8, 0x10, 0x80, 0x18;

    bool in_elenor_fight : "GameAssembly.dll", 0x315AE88, 0xB8, 0x69;

    int saveSlotCount : "GameAssembly.dll",  0x316B208, 0xB8, 0x0, 0x10, 0x18
}

start
{
    return current.timeSpent == "00:00:00";
}

reset
{
    return current.saveSlotCount < old.saveSlotCount;
}

split
{
    bool collected_31 = false;
    bool collected_47 = false;
    bool collected_53 = false;
    bool collected_69 = false;
    if (vars.last_scroll_watcher != null && current.scroll_count != 0) {
        collected_31 = vars.last_scroll_watcher.Current == 31 && vars.last_scroll_watcher.Old != 31;
        collected_47 = vars.last_scroll_watcher.Current == 47 && vars.last_scroll_watcher.Old != 47;
        collected_53 = vars.last_scroll_watcher.Current == 53 && vars.last_scroll_watcher.Old != 53;
        collected_69 = vars.last_scroll_watcher.Current == 69 && vars.last_scroll_watcher.Old != 69;
    }

    bool elenor_is_dead = false;
    if (current.in_elenor_fight) {
        if (vars.searching_task.IsCompleted) {
            elenor_is_dead = vars.watchers["magnet1_health"].Current == 0f && 
            vars.watchers["magnet2_health"].Current == 0f && 
            vars.watchers["magnet3_health"].Current == 0f;
        }
    }

    return (
        (current.blink__unlocked && !old.blink__unlocked) && settings["blink"] ||
        (current.blue_cloak__unlocked && !old.blue_cloak__unlocked) && settings["blue_cloak"] ||
        (current.waterblink__unlocked && !old.waterblink__unlocked) && settings["waterblink"] ||
        (current.mjolnir__unlocked && !old.mjolnir__unlocked) && settings["mjolnir"] ||
        (current.power_slide__unlocked && !old.power_slide__unlocked) && settings["power_slide"] ||
        (current.axe__unlocked && !old.axe__unlocked) && settings["axe"] ||
        (current.blink_wire_axe__unlocked && !old.blink_wire_axe__unlocked) && settings["blink_wire_axe"] ||
        (current.red_cloak__unlocked && !old.red_cloak__unlocked) && settings["red_cloak"] ||
        (current.omni_blink__unlocked && !old.omni_blink__unlocked) && settings["omni_blink"] ||
        (current.double_jump__unlocked && !old.double_jump__unlocked) && settings["double_jump"] ||
        (current.secrets_map__unlocked && !old.secrets_map__unlocked) && settings["secrets_map"] ||
        
        (current.hulder__bossfight_beaten && !old.hulder__bossfight_beaten) && settings["hulder"] ||
        (current.moose__bossfight_beaten && !old.moose__bossfight_beaten) && settings["moose"] ||
        (current.fafnir__bossfight_beaten && !old.fafnir__bossfight_beaten) && settings["fafnir"] ||
        (current.halvtann__bossfight_beaten && !old.halvtann__bossfight_beaten) && settings["halvtann"] ||
        (current.galvan__bossfight_beaten && !old.galvan__bossfight_beaten) && settings["galvan"] ||
        (current.troll__bossfight_beaten && !old.troll__bossfight_beaten) && settings["troll"] ||

        (collected_31 && settings["31"]) ||
        (collected_47 && settings["47"]) ||
        (collected_53 && settings["53"]) ||
        (collected_69 && settings["69"]) ||

        (elenor_is_dead && settings["elenor"])

    );
}

startup
{
    vars.Log = (Action<object>)((output) => print("[Process ASL] " + output));

    vars.last_scroll_watcher = null;

    vars.scanTarget = new SigScanTarget(-0x20, "000000410000F0410000F0410000A041000000009A99193E0000003FAE47E13D????????0000F042");
    vars.watchers = new MemoryWatcherList();
    vars.destructible_magnet_controller_adress = IntPtr.Zero;

    vars.find_magnet_controller_fn = new Action<Process>((g) => {
        print("Start Searching Magnet Controller");
        foreach (var page in g.MemoryPages()) {
            var scanner = new SignatureScanner(g, page.BaseAddress, (int)page.RegionSize);
            vars.destructible_magnet_controller_adress = scanner.Scan(vars.scanTarget);
            if (vars.destructible_magnet_controller_adress != IntPtr.Zero) {
                break;
            }
        }

        vars.watchers.Add(new MemoryWatcher<float>(new DeepPointer(vars.destructible_magnet_controller_adress + 0x18, 0x20, 0x10, 0x90)) { Name = "magnet1_health" });
        vars.watchers.Add(new MemoryWatcher<float>(new DeepPointer(vars.destructible_magnet_controller_adress + 0x18, 0x28, 0x10, 0x90)) { Name = "magnet2_health" });
        vars.watchers.Add(new MemoryWatcher<float>(new DeepPointer(vars.destructible_magnet_controller_adress + 0x18, 0x30, 0x10, 0x90)) { Name = "magnet3_health" });

        vars.Log("Finished Searching Magnet Controller : " + vars.destructible_magnet_controller_adress);
    });

    // Settings =============================================================
    settings.Add("skills", true, "Skills");

    settings.Add("blink", false, "Blink", "skills");
    settings.Add("blue_cloak", false, "Blue Cloak", "skills");
    settings.Add("waterblink", false, "Water Blink", "skills");
    settings.Add("mjolnir", false, "Mjolnir", "skills");
    settings.Add("power_slide", false, "Power Slide", "skills");
    settings.Add("axe", false, "Axe", "skills");
    settings.Add("blink_wire_axe", false, "Blink Wire Axe", "skills");
    settings.Add("red_cloak", false, "Red Cloak", "skills");
    settings.Add("omni_blink", false, "OmniBlink", "skills");
    settings.Add("double_jump", false, "Double Jump", "skills");
    settings.Add("secrets_map", false, "Secrets Map", "skills");

    settings.Add("bosses", true, "Bosses");

    settings.Add("hulder", false, "Hulder", "bosses");
    settings.Add("moose", false, "Moose", "bosses");
    settings.Add("fafnir", false, "Fafnir", "bosses");
    settings.Add("halvtann", false, "Halvtann", "bosses");
    settings.Add("galvan", false, "Galvan", "bosses");
    settings.Add("elenor", false, "Elenor", "bosses");
    settings.Add("troll", false, "Troll", "bosses");

    settings.Add("scrolls", true, "Scrolls");

    settings.Add("31", false, "31", "scrolls");
    settings.Add("47", false, "47", "scrolls");
    settings.Add("53", false, "53", "scrolls");
    settings.Add("69", false, "69", "scrolls");
    // ===========================================================================
}

update
{
    // Move Pointer to last element of scrolls list
    if (current.scroll_count != old.scroll_count) {
        DeepPointer last_scroll_pointer = new DeepPointer("GameAssembly.dll", 0x3199E90, 0xB8, 0x10, 0x80, 0x10, 0x20 + (current.scroll_count - 1) * 0x4);
        vars.last_scroll_watcher = new MemoryWatcher<int>(last_scroll_pointer);
    }

    // Update last scroll watcher 
    if (vars.last_scroll_watcher != null) {
        vars.last_scroll_watcher.Update(game);
    }

    // Find destructible_magnet_controller when entering Elenor Fight
    if (current.in_elenor_fight && !old.in_elenor_fight) {
        vars.searching_task = System.Threading.Tasks.Task.Run(() => {vars.find_magnet_controller_fn(game);});
    }

    // Update Magnet watchers in Elenor Fight
    if (current.in_elenor_fight) {
        if (vars.searching_task.IsCompleted) {
            vars.watchers.UpdateAll(game);
        }
    }

    // Clean destructible_magnet_controller element when exiting Elenor fight
    if (!current.in_elenor_fight && old.in_elenor_fight) {
        vars.watchers.Clear();
        vars.destructible_magnet_controller_adress = IntPtr.Zero;
    }
}
 