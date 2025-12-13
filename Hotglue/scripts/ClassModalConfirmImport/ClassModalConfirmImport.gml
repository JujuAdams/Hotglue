// Feather disable all

/// @param importTab
/// @param importMode

function ClassModalConfirmImport(_importTab, _importMode) constructor
{
    __importTab  = _importTab;
    __importMode = _importMode;
    
    __loadPending = false;
    __loadSuccessful = true;
    
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
    else
    {
        __conflictArray = [];
        
        if (__importMode == "channels")
        {
            var _selectedRelease = __importTab.GetSelectedRelease();
            if (_selectedRelease != undefined)
            {
                __loadPending = true;
                __loadSuccessful = false;
                
                _selectedRelease.LoadProject(function(_project, _success)
                {
                    __loadPending = false;
                    
                    if (_success)
                    {
                        if (_project.GetLoadedSuccessfully())
                        {
                            var _assetArray = _project.GetAssets();
                            __conflictArray = __importTab.__destinationProject.GetConflictingExt(_assetArray);
                            
                            __loadSuccessful = true;
                            LogTraceAndStatus("Loaded release successfully.");
                        }
                        else
                        {
                            LogWarning("Failed to load project file for release. Please check the log for further information.");
                        }
                    }
                    else
                    {
                        LogWarning("Failed to load project file for release. Please check the log for further information.");
                    }
                });
            }
        }
    }
    
    
    
    static Build = function()
    {
        var _name = $"##modal_{string(ptr(self))}";
        
        ImGuiOpenPopup(_name);
        ImGuiSetNextWindowSize(oInterface.context.GetRegion().width/3, oInterface.context.GetRegion().height/2);
        var _result = ImGuiBeginPopupModal(_name, true);
        if (_result & ImGuiReturnMask.Return)
        {
            if ((not __loadPending) && (not __loadSuccessful))
            {
                ImGuiTextColored("Failed to load release project.", INTERFACE_COLOR_RED_TEXT);
                ImGuiText("Please check the log for more information.");
            }
            else if (__loadPending)
            {
                ImGuiText("Loading release project, please wait...");
            }
            else
            {
                ImGuiText("Are you sure you want to import?");
            }
            
            ImGuiNewLine();
            ImGuiBeginDisabled(__loadPending || (not __loadSuccessful));
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
            ImGuiEndDisabled();
            
            ImGuiSameLine(undefined, 20);
            if (ImGuiButton("Abort"))
            {
                oInterface.popUpStruct = undefined;
            }
            
            if ((not __loadPending) && __loadSuccessful)
            {
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