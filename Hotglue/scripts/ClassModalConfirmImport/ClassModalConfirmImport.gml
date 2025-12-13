// Feather disable all

/// @param importTab
/// @param importMode

function ClassModalConfirmImport(_importTab, _importMode) constructor
{
    __importTab  = _importTab;
    __importMode = _importMode;
    
    if (__importMode == "local project")
    {
        var _assetArray = __importTab.__directProject.GetAssets();
        __conflictArray = __importTab.__destinationProject.GetConflictingExt(_assetArray);
    }
    else if (__importMode == "loose files")
    {
        var _looseFileArray = __importTab.GetLooseFileArray();
        __conflictArray = __importTab.__destinationProject.GetConflictingLooseFiles(_looseFileArray);
    }
    else if (__importMode == "channels")
    {
        //TODO
    }
    else
    {
        __conflictArray = [];
    }
    
    
    static Build = function()
    {
        var _name = $"##modal_{string(ptr(self))}";
        
        ImGuiOpenPopup(_name);
        ImGuiSetNextWindowSize(oInterface.context.GetRegion().width/3, oInterface.context.GetRegion().height/2);
        var _result = ImGuiBeginPopupModal(_name, true);
        if (_result & ImGuiReturnMask.Return)
        {
            ImGuiText("Are you sure you want to import?");
            
            ImGuiNewLine();
            if (ImGuiButton("Import"))
            {
                if (__importMode == "local project")
                {
                    __importTab.ImportLocalProject();
                }
                else if (__importMode == "loose files")
                {
                    __importTab.ImportLooseFiles();
                }
                else if (__importMode == "channels")
                {
                    __importTab.ImportChannels();
                }
                
                oInterface.popUpStruct = undefined;
            }
            
            ImGuiSameLine(undefined, 20);
            if (ImGuiButton("Abort"))
            {
                oInterface.popUpStruct = undefined;
            }
            
            ImGuiNewLine();
            
            if (array_length(__conflictArray) <= 0)
            {
                ImGuiText("(No conflicts)");
            }
            else
            {
                var _conflictArray = __conflictArray;
                ImGuiText($"{array_length(_conflictArray)} conflicts:");
                
                if (array_length(_conflictArray) > 5)
                {
                    ImGuiSameLine();
                    ImGuiText(" (Only first 500 conflicts shown)");
                }
                
                ImGuiBeginChild("frame");
                
                var _i = 0;
                repeat(min(500, array_length(_conflictArray)))
                {
                    ImGuiText(_conflictArray[_i]);
                    ++_i;
                }
                
                ImGuiEndChild();
            }
            
            ImGuiEndPopup();
            
            return true;
        }
        else
        {
            return false;
        }
    }
}