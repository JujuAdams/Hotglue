// Feather disable all

function __InterfaceProjectViewBuildOverview()
{
    __InputString = method(undefined, function(_pointer, _hint)
    {
        var _oldString = _pointer.__Get();
        var _newString = ImGuiInputTextWithHint($"##{_hint}", _hint, _oldString);
        if (_oldString != _newString)
        {
            _pointer.__Set(_newString);
            __project.__SaveHotglueMetadata();
        }
    });
    
    __InputVersionString = method(undefined, function(_pointer, _hint)
    {
        var _oldString = string(_pointer.__Get());
        
        ImGuiSetNextItemWidth(40);
        var _newString = ImGuiInputTextWithHint($"##{_hint}", _hint, _oldString);
        if (_oldString != _newString)
        {
            var _value = undefined;
            
            if (_newString == "")
            {
                _value = _newString;
            }
            else
            {
                try
                {
                    _value = string_format(floor(abs(real(_newString))), 0, 0);
                }
                catch(_error)
                {
                    
                }
            }
            
            if (_value != undefined)
            {
                _pointer.__Set(_value);
                __project.__SaveHotglueMetadata();
            }
        }
    });
    
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
            ImGuiText("Name");
            ImGuiTableNextColumn();
            __InputString(new __HotglueClassPointer(__project.__hotglueMetadata[0], "name"), "name");
            ImGuiTableNextColumn();
            if (ImGuiSmallButton("Reset##name"))
            {
                __project.__hotglueMetadata[0].name = __project.__yypJson.name;
                __project.__SaveHotglueMetadata();
            }
            
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
            ImGuiText(__project.GetVersionString());
            
            __InputVersionString(new __HotglueClassPointer(__project.__hotglueMetadata[0].version, "major"), "MAJOR");
            ImGuiSameLine();
            ImGuiText(".");
            ImGuiSameLine();
            __InputVersionString(new __HotglueClassPointer(__project.__hotglueMetadata[0].version, "minor"), "Minor");
            ImGuiSameLine();
            ImGuiText(".");
            ImGuiSameLine();
            __InputVersionString(new __HotglueClassPointer(__project.__hotglueMetadata[0].version, "patch"), "patch");
            ImGuiSameLine();
            ImGuiSetNextItemWidth(200);
            __InputString(new __HotglueClassPointer(__project.__hotglueMetadata[0].version, "extension"), "extension");
            ImGuiTableNextColumn();
            if (ImGuiSmallButton("Reset##version"))
            {
                with(__project.__hotglueMetadata[0].version)
                {
                    major = "";
                    minor = "";
                    patch = "";
                    extension = "";
                }
                
                __project.__SaveHotglueMetadata();
            }
            
            ImGuiTableNextRow();
            ImGuiTableNextColumn();
            ImGuiText(".yymps overrides version");
            
            ImGuiTableNextColumn();
            
            var _oldValue = __project.__hotglueMetadata[0].yympsOverridesVersion;
            var _newValue = ImGuiCheckbox($"##yympsOverridesVersion", _oldValue);
            if (_oldValue != _newValue)
            {
                __project.__hotglueMetadata[0].yympsOverridesVersion = _newValue;
                __project.__SaveHotglueMetadata();
            }
            
            ImGuiSameLine();
            ImGuiDummy(20, 0);
            ImGuiSameLine();
            ImGuiTextLink("What is this?");
            if (ImGuiBeginItemTooltip())
            {
                ImGuiText($"Override the Hotglue version with the version specified when exporting a .yymps from the GameMaker IDE.\n\nThis means you don't need to keep updating the Hotglue metadata with every release.");
                ImGuiEndTooltip();
            }
            ImGuiTableNextColumn();
            if (ImGuiSmallButton("Reset##yympsOverridesVersion"))
            {
                __project.__hotglueMetadata[0].yympsOverridesVersion = false;
                __project.__SaveHotglueMetadata();
            }
            
            ImGuiTableNextRow();
            ImGuiTableNextColumn();
            ImGuiText("Origin");
            ImGuiTableNextColumn();
            InterfaceLinkText(__project.GetURL());
            
            ImGuiTableNextRow();
            ImGuiTableNextColumn();
            ImGuiText("Imported");
            ImGuiTableNextColumn();
            
            BuildImportedTable();
            
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
            ImGuiText("Origin");
            ImGuiTableNextColumn();
            InterfaceLinkText(__project.GetURL());
            
            ImGuiTableNextRow();
            ImGuiTableNextColumn();
            ImGuiText("Imported");
            ImGuiTableNextColumn();
            
            BuildImportedTable();
            
            ImGuiEndTable();
            ImGuiPopStyleVar();
        }
    });
    
    BuildImportedTable = method(undefined, function()
    {
        var _cellPadding = 8;
        var _importedArray = __project.GetImported();
        
        if (array_length(_importedArray) <= 0)
        {
            ImGuiBeginDisabled(true);
            ImGuiText("(none)");
            ImGuiEndDisabled();
        }
        else
        {
            ImGuiPopStyleVar();
            ImGuiBeginTable("importedTable", 2);
            
            ImGuiTableSetupColumn("name", ImGuiTableColumnFlags.WidthFixed, 120);
            ImGuiTableSetupColumn("version");
            
            var _i = 0;
            repeat(array_length(_importedArray))
            {
                var _imported = _importedArray[_i];
                
                ImGuiTableNextRow();
                ImGuiTableNextColumn();
                InterfaceLinkText(_imported.name, _imported.origin);
                ImGuiTableNextColumn();
                ImGuiTextWrapped(_imported.version);
                
                ++_i;
            }
            
            ImGuiEndTable();
            ImGuiPushStyleVarY(ImGuiStyleVar.CellPadding, _cellPadding);
        }
    });
}