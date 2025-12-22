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
        var _readOnly = __project.GetReadOnly();
        
        if (not __project.GetHotglueMetadataExists())
        {
            ImGuiTextColored("No Hotglue metadata found in project.", INTERFACE_COLOR_ORANGE_TEXT, 1);
        }
        
        if (_readOnly)
        {
            ImGuiTextColored("Project is read-only.", INTERFACE_COLOR_RED_TEXT, 1);
        }
        
        var _cellPadding = 8;
        
        ImGuiPushStyleVarY(ImGuiStyleVar.CellPadding, _cellPadding);
        ImGuiBeginTable("overviewTable", 2, ImGuiTableFlags.RowBg | ImGuiTableFlags.Borders);
        
        ImGuiTableSetupColumn("field", ImGuiTableColumnFlags.WidthFixed, 70);
        ImGuiTableSetupColumn("value");
        
        ImGuiTableNextRow();
        ImGuiTableNextColumn();
        ImGuiText("Origin");
        ImGuiTableNextColumn();
        InterfaceLinkText(__project.GetURL());
        
        ImGuiTableNextRow();
        ImGuiTableNextColumn();
        ImGuiText("Name");
        ImGuiTableNextColumn();
        ImGuiText(__project.GetName());
        
        ImGuiTableNextRow();
        ImGuiTableNextColumn();
        ImGuiText("Version");
        ImGuiTableNextColumn();
        ImGuiText(__project.GetVersionString());
        
        ImGuiTableNextRow();
        ImGuiTableNextColumn();
        ImGuiText("Imported");
        ImGuiTableNextColumn();
        BuildImportedTable();
        
        ImGuiEndTable();
        ImGuiPopStyleVar();
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
            ImGuiBeginTable("importedTable", 3);
            
            ImGuiTableSetupColumn("name");
            ImGuiTableSetupColumn("verify", ImGuiTableColumnFlags.WidthFixed, 50);
            ImGuiTableSetupColumn("delete", ImGuiTableColumnFlags.WidthFixed, 50);
            
            var _deleteIndex = undefined;
            var _i = 0;
            repeat(array_length(_importedArray))
            {
                var _imported = _importedArray[_i];
                
                ImGuiTableNextRow();
                ImGuiTableNextColumn();
                InterfaceLinkText(_imported.name, _imported.origin);
                ImGuiSameLine();
                ImGuiTextWrapped(_imported.version);
                
                ImGuiTableNextColumn();
                if (ImGuiSmallButton("Verify"))
                {
                    if (__project.VerifyLibrary(_imported.name))
                    {
                        var _message = $"Verified all assets exist for \"{_imported.name}\".";
                    }
                    else
                    {
                        var _message = $"Failed to verify all assets exist for \"{_imported.name}\". Please check the log for more information.";
                    }
                    
                    oInterface.popUpStruct = new ClassModalMessage(_message);
                }
                
                ImGuiTableNextColumn();
                if (ImGuiSmallButton("Delete"))
                {
                    _deleteIndex = _i;
                }
                
                ++_i;
            }
            
            if (_deleteIndex != undefined)
            {
                oInterface.popUpStruct = new ClassModalConfirmLibraryDelete(__project, _imported.name);
            }
            
            ImGuiEndTable();
            ImGuiPushStyleVarY(ImGuiStyleVar.CellPadding, _cellPadding);
        }
    });
}