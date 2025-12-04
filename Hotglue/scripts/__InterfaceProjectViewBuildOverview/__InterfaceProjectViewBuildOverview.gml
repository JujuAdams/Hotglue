// Feather disable all

function __InterfaceProjectViewBuildOverview()
{
    BuildOverview = method(undefined, function()
    {
        var _editable = __project.GetEditable();
        if (not __project.GetHotglueMetadataExists())
        {
            if (_editable)
            {
                ImGuiTextColored("No Hotglue metadata found in project.", INTERFACE_COLOR_RED_TEXT, 1);
                ImGuiSameLine();
                if (ImGuiButton("Create Hotglue metadata"))
                {
                    __project.EnsureHotglueMetadata();
                }
                
                _editable = false;
            }
            else
            {
                ImGuiTextColored("No Hotglue metadata found in project.", INTERFACE_COLOR_RED_TEXT, 1);
            }
        }
        
        if (_editable)
        {
            ///////
            // Editable
            ///////
            
            var _cellPadding = 8;
            
            ImGuiPushStyleVarY(ImGuiStyleVar.CellPadding, _cellPadding);
            ImGuiBeginTable("overviewTable", 3, ImGuiTableFlags.RowBg);
            
            ImGuiTableSetupColumn("field", ImGuiTableColumnFlags.WidthFixed, 180);
            ImGuiTableSetupColumn("value");
            ImGuiTableSetupColumn("button", ImGuiTableColumnFlags.WidthFixed, 50);
            
            ImGuiTableNextRow();
            ImGuiTableNextColumn();
            ImGuiText("* Favourite *");
            ImGuiTableNextColumn();
            ImGuiCheckbox("##favorite", false);
            
            ImGuiTableNextRow();
            ImGuiTableNextColumn();
            ImGuiText("Name");
            ImGuiTableNextColumn();
            ImGuiTextWrapped(__project.GetName());
            ImGuiTableNextColumn();
            ImGuiSmallButton("Reset##name");
            
            ImGuiTableNextRow();
            ImGuiTableNextColumn();
            
            ImGuiTextLink("Semantic Version");
            var _clicked = ImGuiIsItemClicked();
            if (ImGuiBeginItemTooltip())
            {
                ImGuiText($"Open \"https://semver.org/\"");
                ImGuiEndTooltip();
            }
            
            if (_clicked)
            {
                url_open("https://semver.org/");
            }
            
            ImGuiTableNextColumn();
            ImGuiText("0.0.0-alpha");
            //ImGuiText(GetVersionString());
            ImGuiSetNextItemWidth(40);
            ImGuiInputTextWithHint("##semverMajor", "MAJOR", "");
            ImGuiSameLine();
            ImGuiText(".");
            ImGuiSameLine();
            ImGuiSetNextItemWidth(40);
            ImGuiInputTextWithHint("##semverMinor", "Minor", "");
            ImGuiSameLine();
            ImGuiText(".");
            ImGuiSameLine();
            ImGuiSetNextItemWidth(40);
            ImGuiInputTextWithHint("##semverPatch", "patch", "");
            ImGuiSameLine();
            ImGuiSetNextItemWidth(200);
            ImGuiInputTextWithHint("##semverExt", "-extension", "");
            ImGuiTableNextColumn();
            ImGuiSmallButton("Reset##version");
            
            ImGuiTableNextRow();
            ImGuiTableNextColumn();
            ImGuiText(".yymps overrides version");
            
            ImGuiTableNextColumn();
            ImGuiCheckbox("##yympsOverridesVersion", true);
            ImGuiSameLine();
            ImGuiTextLink("What is this?");
            if (ImGuiBeginItemTooltip())
            {
                ImGuiText($"Enable to allow .yymps exports to override the version set in \"hotglue.json\".\nThis makes .yymps export more convenient.");
                ImGuiEndTooltip();
            }
            
            ImGuiTableNextRow();
            ImGuiTableNextColumn();
            ImGuiText("URL");
            ImGuiTableNextColumn();
            
            ImGuiTextLink(__project.GetURL());
            var _clicked = ImGuiIsItemClicked();
            if (ImGuiBeginItemTooltip())
            {
                ImGuiText($"Open \"{__project.GetURL()}\"");
                ImGuiEndTooltip();
            }
            
            if (_clicked)
            {
                if (InterfaceGuessURLIsRemote(__project.GetURL()))
                {
                    url_open(__project.GetURL());
                }
                else
                {
                    execute_shell_simple(filename_dir(__project.GetURL()));
                }
            }
            
            ImGuiTableNextRow();
            ImGuiTableNextColumn();
            ImGuiText("Dependencies");
            ImGuiTableNextColumn();
            
            //var _dependenciesArray = GetDependencies();
            //
            //ImGuiPopStyleVar();
            //ImGuiBeginTable("overviewTable", 2);
            //
            //ImGuiTableSetupColumn("name", ImGuiTableColumnFlags.WidthFixed, 120);
            //ImGuiTableSetupColumn("version");
            //
            //var _i = 0;
            //repeat(array_length(_dependenciesArray))
            //{
            //    var _dependency = _dependenciesArray[_i];
            //    
            //    ImGuiTableNextRow();
            //    ImGuiTableNextColumn();
            //    
            //    ImGuiTextLink(_dependency.name);
            //    var _clicked = ImGuiIsItemClicked();
            //    if (ImGuiBeginItemTooltip())
            //    {
            //        ImGuiText($"Open \"{_dependency.url}\"");
            //        ImGuiEndTooltip();
            //    }
            //    
            //    if (_clicked)
            //    {
            //        if (InterfaceGuessURLIsRemote(_dependency.url))
            //        {
            //            url_open(GetURL());
            //        }
            //        else
            //        {
            //            execute_shell_simple(filename_dir(_dependency.url));
            //        }
            //    }
            //    
            //    ImGuiTableNextColumn();
            //    ImGuiTextWrapped(_dependency.version);
            //    
            //    ++_i;
            //}
            //
            //ImGuiEndTable();
            //ImGuiPushStyleVarY(ImGuiStyleVar.CellPadding, _cellPadding);
            
            ImGuiTableNextRow();
            ImGuiTableNextColumn();
            
            ImGuiTextLink("Scripting");
            var _clicked = ImGuiIsItemClicked();
            if (ImGuiBeginItemTooltip())
            {
                ImGuiText($"Edit scripting");
                ImGuiEndTooltip();
            }
            
            if (_clicked)
            {
                
            }
            
            ImGuiTableNextColumn();
            
            ImGuiBeginDisabled(true);
            ImGuiCheckbox("Before import", true);
            ImGuiSameLine();
            ImGuiSetCursorPosX(ImGuiGetCursorPosX() + 5)
            ImGuiCheckbox("After import", true);
            ImGuiEndDisabled();
            
            ImGuiEndTable();
            ImGuiPopStyleVar();
        }
        else
        {
            ///////
            // View
            ///////
            
            var _cellPadding = 8;
            
            ImGuiPushStyleVarY(ImGuiStyleVar.CellPadding, _cellPadding);
            ImGuiBeginTable("overviewTable", 2, ImGuiTableFlags.RowBg);
            
            ImGuiTableSetupColumn("field", ImGuiTableColumnFlags.WidthFixed, 130);
            ImGuiTableSetupColumn("value");
            
            ImGuiTableNextRow();
            ImGuiTableNextColumn();
            ImGuiText("* Favourite *");
            ImGuiTableNextColumn();
            
            ImGuiCheckbox("##favorite", false);
            
            //var _favoriteArray = InterfaceSettingGet("favoriteLinks");
            //var _oldFavorite = (array_get_index(_favoriteArray, GetURL()) >= 0);
            //var _newFavorite = ImGuiCheckbox("##favorite", _oldFavorite);
            //if (_newFavorite != _oldFavorite)
            //{
            //    if (_newFavorite)
            //    {
            //        array_push(InterfaceSettingGet("favoriteLinks"), GetURL());
            //        LogTraceAndStatus($"Favourited \"{GetURL()}\"");
            //    }
            //    else
            //    {
            //        var _index = array_get_index(_favoriteArray, GetURL());
            //        if (_index >= 0) array_delete(_favoriteArray, _index, 1);
            //        LogTraceAndStatus($"Unfavourited \"{GetURL()}\"");
            //    }
            //    
            //    oInterface.favoritesTab.dirty = true;
            //    InterfaceSettingsSave();
            //}
            
            ImGuiTableNextRow();
            ImGuiTableNextColumn();
            ImGuiText("Name");
            ImGuiTableNextColumn();
            ImGuiTextWrapped(__project.GetName());
            
            ImGuiTableNextRow();
            ImGuiTableNextColumn();
            
            ImGuiTextLink("Semantic Version");
            var _clicked = ImGuiIsItemClicked();
            if (ImGuiBeginItemTooltip())
            {
                ImGuiText($"Open \"https://semver.org/\"");
                ImGuiEndTooltip();
            }
            
            if (_clicked)
            {
                url_open("https://semver.org/");
            }
            
            ImGuiTableNextColumn();
            
            ImGuiText("0.0.0-alpha");
            //ImGuiText(GetVersionString());
            
            ImGuiTableNextRow();
            ImGuiTableNextColumn();
            ImGuiText("URL");
            ImGuiTableNextColumn();
            
            ImGuiTextLink(__project.GetURL());
            var _clicked = ImGuiIsItemClicked();
            if (ImGuiBeginItemTooltip())
            {
                ImGuiText($"Open \"{__project.GetURL()}\"");
                ImGuiEndTooltip();
            }
            
            if (_clicked)
            {
                if (InterfaceGuessURLIsRemote(__project.GetURL()))
                {
                    url_open(__project.GetURL());
                }
                else
                {
                    execute_shell_simple(filename_dir(__project.GetURL()));
                }
            }
            
            ImGuiTableNextRow();
            ImGuiTableNextColumn();
            ImGuiText("Dependencies");
            ImGuiTableNextColumn();
            
            //var _dependenciesArray = GetDependencies();
            //
            //ImGuiPopStyleVar();
            //ImGuiBeginTable("overviewTable", 2);
            //
            //ImGuiTableSetupColumn("name", ImGuiTableColumnFlags.WidthFixed, 120);
            //ImGuiTableSetupColumn("version");
            //
            //var _i = 0;
            //repeat(array_length(_dependenciesArray))
            //{
            //    var _dependency = _dependenciesArray[_i];
            //    
            //    ImGuiTableNextRow();
            //    ImGuiTableNextColumn();
            //    
            //    ImGuiTextLink(_dependency.name);
            //    var _clicked = ImGuiIsItemClicked();
            //    if (ImGuiBeginItemTooltip())
            //    {
            //        ImGuiText($"Open \"{_dependency.url}\"");
            //        ImGuiEndTooltip();
            //    }
            //    
            //    if (_clicked)
            //    {
            //        if (InterfaceGuessURLIsRemote(_dependency.url))
            //        {
            //            url_open(GetURL());
            //        }
            //        else
            //        {
            //            execute_shell_simple(filename_dir(_dependency.url));
            //        }
            //    }
            //    
            //    ImGuiTableNextColumn();
            //    ImGuiTextWrapped(_dependency.version);
            //    
            //    ++_i;
            //}
            //
            //ImGuiEndTable();
            //ImGuiPushStyleVarY(ImGuiStyleVar.CellPadding, _cellPadding);
            
            ImGuiTableNextRow();
            ImGuiTableNextColumn();
            
            ImGuiTextLink("Scripting");
            var _clicked = ImGuiIsItemClicked();
            if (ImGuiBeginItemTooltip())
            {
                ImGuiText($"View scripting");
                ImGuiEndTooltip();
            }
            
            if (_clicked)
            {
                
            }
            
            ImGuiTableNextColumn();
            
            ImGuiBeginDisabled(true);
            ImGuiCheckbox("Before import", true);
            ImGuiSameLine();
            ImGuiSetCursorPosX(ImGuiGetCursorPosX() + 5)
            ImGuiCheckbox("After import", true);
            ImGuiEndDisabled();
            
            ImGuiEndTable();
            ImGuiPopStyleVar();
        }
    });
}