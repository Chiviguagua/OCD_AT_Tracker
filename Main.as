// Plugin state
bool showMainWindow = false;
bool showProgressBarWindow = true;
bool loaded = false;
dictionary savedPBs;
uint completedMaps = 0;

void RenderMenu() {
    if (UI::BeginMenu("AT Tracker")) {
        if (UI::Button(showMainWindow ? "Hide Tracker Window" : "Show Tracker Window")) {
            showMainWindow = !showMainWindow;
        }
        if (UI::Button(showProgressBarWindow ? "Hide Progress Bar" : "Show Progress Bar")) {
            showProgressBarWindow = !showProgressBarWindow;
        }
        UI::EndMenu();
    }
}

void RenderInterface() {
    if (!loaded) {
        LoadPBs();
        loaded = true;
    }

    completedMaps = 0;

    // Render progress bar
    if (showProgressBarWindow) {
        float pct = float(completedMaps) / float(maps.Length);
        string label = completedMaps + " / " + maps.Length;

        vec4 barColor = completedMaps >= 20
            ? vec4(1.0f, 0.84f, 0.0f, 1.0f)   // Gold
            : vec4(0.94f, 0.38f, 0.0f, 1.0f); // #F06000

        UI::PushStyleColor(UI::Col::WindowBg, vec4(0, 0, 0, 0));
        UI::PushStyleColor(UI::Col::PlotHistogram, barColor);

        bool visible = true;
        if (UI::Begin("OCD AT Progress Bar", visible,
            UI::WindowFlags::NoTitleBar |
            UI::WindowFlags::NoScrollbar |
            UI::WindowFlags::NoCollapse |
            UI::WindowFlags::AlwaysAutoResize
        )) {
            UI::ProgressBar(pct, vec2(300, 30), label);
            UI::End();
        }

        UI::PopStyleColor(2);
    }

    // Render tracker window
    if (showMainWindow) {
        UI::SetNextWindowPos(100, 100, UI::Cond::Once);
        UI::Begin("OCD AT Tracker", UI::WindowFlags::AlwaysAutoResize);

        UI::Text("OCD Campaign AT Progress");
        UI::Separator();

        if (UI::BeginTable("atTable", 4, UI::TableFlags::Borders | UI::TableFlags::RowBg)) {
            UI::TableSetupColumn("Map", UI::TableColumnFlags::WidthFixed, 60);
            UI::TableSetupColumn("AT", UI::TableColumnFlags::WidthFixed, 70);
            UI::TableSetupColumn("PB", UI::TableColumnFlags::WidthFixed, 70);
            UI::TableSetupColumn("Delta", UI::TableColumnFlags::WidthFixed, 90);
            UI::TableHeadersRow();

            UI::PushStyleVar(UI::StyleVar::FramePadding, vec2(4, 8));
            for (uint i = 0; i < maps.Length; i++) {
                auto m = maps[i];
                uint pb = GetPB(m.uid);

                UI::TableNextRow();
                UI::TableNextColumn(); UI::Text("Map " + Text::Format("%02d", i + 1));
                UI::TableNextColumn(); UI::Text(Time::Format(m.at));

                UI::TableNextColumn();
                if (pb > 0) {
                    if (pb <= m.at) {
                        UI::PushStyleColor(UI::Col::Text, vec4(0.2f, 1.0f, 0.2f, 1.0f));
                        UI::Text(Time::Format(pb));
                        UI::PopStyleColor();
                    } else {
                        UI::Text(Time::Format(pb));
                    }
                } else {
                    UI::TextDisabled("—");
                }

                UI::TableNextColumn();
                if (pb > 0 && m.at > 0) {
                    if (pb <= m.at) {
                        UI::PushStyleColor(UI::Col::Text, vec4(0.2f, 1.0f, 0.2f, 1.0f));
                        UI::Text("✓");
                        UI::PopStyleColor();
                        completedMaps++;
                    } else {
                        UI::PushStyleColor(UI::Col::Text, vec4(1.0f, 0.4f, 0.4f, 1.0f));
                        UI::Text("+" + Time::Format(pb - m.at));
                        UI::PopStyleColor();
                    }
                } else {
                    UI::TextDisabled("—");
                }
            }
            UI::PopStyleVar();
            UI::EndTable();
        }

        UI::End();
    }
}

// -------------------- Data + PB logic stays unchanged --------------------

class MapData {
    string name;
    string uid;
    uint at;

    MapData(const string &in name, const string &in uid, uint at) {
        this.name = name;
        this.uid = uid;
        this.at = at;
    }
}

array<MapData@> maps = {
    MapData("01", "ne8PKAb6ibQPf88TEhBu2r4i8Ob", 24098),
    MapData("02", "bdechdNJ0LIekGh_3QqPFE0TMId", 28837),
    MapData("03", "Zq5zT30ovZ8Wa3Nzqugu9Mq1Phm", 24807),
    MapData("04", "wYIc2QAENM7kt9mprFXjNaYZ4J7", 23582),
    MapData("05", "pJS_rt8usbjdS_yfqdUPAhQD5c9", 23118),
    MapData("06", "zg7YJ9UqysKGCOBoI6P4HBnWty8", 33018),
    MapData("07", "YEHcTC4D7Qekk4XG21_DYFPG9pd", 30613),
    MapData("08", "jX7k9xC9ObPGfB3I9OE3ddfkl83", 32332),
    MapData("09", "Xtx8r9cn5q6941lYODbrm4CzLal", 31658),
    MapData("10", "Pc3QHt0tx1Y_EFm86g6CcqCSHl1", 32255),
    MapData("11", "Ak6c_O6JALK2I9A1uuqttad8In5", 38941),
    MapData("12", "u66O3dqlL8NQYeR3R1VVhBeUcYj", 28201),
    MapData("13", "x3cWJDdbVXJv9IF_4Nc0keViWS3", 36633),
    MapData("14", "AE8hmTN3Edh6DTcacVj7OMhoYBm", 42000),
    MapData("15", "IVIzPdiejB1CYSHoysR01Bca80l", 41640),
    MapData("16", "pbohNDBgaYRuJkJmcLed7yvocZ0", 40001),
    MapData("17", "uXIwJDWm0I67T9DSQtrw7lOrCh", 47985),
    MapData("18", "D7jqAV0OKXIPSZLkF10AxybORi1", 47413),
    MapData("19", "OGzJnDcglssHQZn0d5WyOYdD8mk", 41240),
    MapData("20", "UiRXSf9ebgIPw9kHjVlMgjoeDY2", 53281),
    MapData("21", "_QZDeNRqGb3t2CHmcikvWXN6ER1", 44666),
    MapData("22", "t_xBLCOlhEF7DkW_FA8NUojSTle", 43860),
    MapData("23", "4djcSWhKHbfjLpGzggbmSDdSSgc", 45485),
    MapData("24", "CJG1S1sTMXv4J3URLqJNrwvLb9e", 53735),
    MapData("25", "kGjYdQEi2RlX2GQ3RdemITYkqm4", 63930)
};

void SavePBs() {
    IO::File file("PBs.json", IO::FileMode::Write);
    file.WriteLine("{");
    uint count = 0;
    for (uint i = 0; i < maps.Length; i++) {
        auto m = maps[i];
        uint time;
        if (savedPBs.Get(m.uid, time)) {
            file.WriteLine('  "' + m.uid + '": ' + time + (count < maps.Length - 1 ? "," : ""));
            count++;
        }
    }
    file.WriteLine("}");
}

void LoadPBs() {
    if (!IO::FileExists("PBs.json")) return;
    IO::File file("PBs.json", IO::FileMode::Read);
    while (!file.EOF()) {
        string line = file.ReadLine().Trim();
        if (line.StartsWith("\"")) {
            auto parts = line.Split(":");
            if (parts.Length >= 2) {
                string uid = parts[0].Replace("\"", "").Trim();
                string val = parts[1].Replace(",", "").Trim();
                uint pbTime = Text::ParseUInt(val);
                savedPBs.Set(uid, pbTime);
            }
        }
    }
}

uint GetPB(const string &in uid) {
    auto app = cast<CTrackMania@>(GetApp());
    if (app is null || app.RootMap is null) return GetSavedPB(uid);
    if (app.RootMap.MapInfo.MapUid != uid) return GetSavedPB(uid);

    auto playground = cast<CSmArenaClient@>(app.CurrentPlayground);
    if (playground is null || playground.GameTerminals.Length == 0) return GetSavedPB(uid);

    auto player = cast<CSmPlayer@>(playground.GameTerminals[0].GUIPlayer);
    if (player is null || player.ScriptAPI is null) return GetSavedPB(uid);

    auto script = cast<CSmScriptPlayer@>(player.ScriptAPI);
    if (script is null || script.Score is null) return GetSavedPB(uid);

    uint livePB = script.Score.Points;
    uint stored;
    if (!savedPBs.Get(uid, stored) || stored > livePB) {
        savedPBs.Set(uid, livePB);
        SavePBs();
    }

    return livePB;
}

uint GetSavedPB(const string &in uid) {
    uint time;
    if (savedPBs.Get(uid, time)) return time;
    return 0;
}

void Main() {
    while (true) {
        yield();

        auto app = cast<CTrackMania@>(GetApp());
        if (app is null || app.RootMap is null) continue;

        auto playground = cast<CSmArenaClient@>(app.CurrentPlayground);
        if (playground is null || playground.GameTerminals.Length == 0) continue;

        auto player = cast<CSmPlayer@>(playground.GameTerminals[0].GUIPlayer);
        if (player is null || player.ScriptAPI is null) continue;

        auto script = cast<CSmScriptPlayer@>(player.ScriptAPI);
        if (script is null || script.Score is null) continue;

        string uid = app.RootMap.MapInfo.MapUid;
        uint livePB = script.Score.Points;

        uint stored;
        if (!savedPBs.Get(uid, stored) || stored > livePB) {
            savedPBs.Set(uid, livePB);
            SavePBs();
        }
    }
}
