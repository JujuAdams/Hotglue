// Feather disable all

function __InterfaceProjectViewBuildOverview()
{
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
            ImGuiBeginTable("importedTable", 2);
            
            ImGuiTableSetupColumn("name");
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
                if (ImGuiSmallButton($"Delete##{_i}"))
                {
                    _deleteIndex = _i;
                }
                
                ++_i;
            }
            
            if (_deleteIndex != undefined)
            {
                var _installedData = _importedArray[_deleteIndex];
                var _job = __project.JobDeleteLibrary(_installedData.name, _installedData.version, _installedData.origin);
                _job.BuildReport();
                oInterface.popUpStruct = new ClassModalConfirmJob(_job, true);
            }
            
            ImGuiEndTable();
            ImGuiPushStyleVarY(ImGuiStyleVar.CellPadding, _cellPadding);
        }
    });
}