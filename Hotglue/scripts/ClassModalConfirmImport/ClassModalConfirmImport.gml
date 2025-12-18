// Feather disable all

/// @param importTab
/// @param importMode

function ClassModalConfirmImport(_importTab, _importMode) constructor
{
    __importTab  = _importTab;
    __importMode = _importMode;
    
    __loadPending = false;
    __loadSuccessful = true;
    
    __job = undefined;
    
    if (__importMode == "local project")
    {
        __job = __importTab.__destinationProject.JobImportFrom(__importTab.__directProject, __importTab.__directView.GetAssetArray());
    }
    else if (__importMode == "loose files")
    {
        __job = __importTab.__destinationProject.JobImportFromLooseFiles(__importTab.GetLooseFileArray());
    }
    else
    {
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
                            __job = __importTab.__destinationProject.JobImportAsLibrary(_project);
                            
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
    
    if (__job != undefined)
    {
        __job.BuildReport();
    }
    
    
    
    static Build = function()
    {
        var _name = $"##modal_{string(ptr(self))}";
        
        ImGuiOpenPopup(_name);
        ImGuiSetNextWindowSize(0.5*oInterface.context.GetRegion().width, 0.666*oInterface.context.GetRegion().height);
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
            ImGuiBeginDisabled(__loadPending || (not __loadSuccessful) || (__job == undefined));
            if (ImGuiButton("Import"))
            {
                var _success = false;
                try
                {
                    __job.Execute();
                    _success = true;
                }
                catch(_error)
                {
                    LogWarning(json_stringify(_error, true));
                }
                
                __job = undefined;
                
                var _message = "Operation complete.";
                if (_success)
                {
                    if (__importMode == "local project")
                    {
                        _message = $"Imported files from \"{__importTab.__destinationProject.GetPath()}\" successfully.";
                    }
                    else if (__importMode == "loose files")
                    {
                        _message = $"Imported loose files successfully.";
                    }
                    else if (__importMode == "channels")
                    {
                        _message = $"Imported files from \"{__importTab.GetSelectedRelease().GetWebURL()}\" successfully.";
                    }
                }
                else
                {
                    if (__importMode == "local project")
                    {
                        _message = $"An error occurred whilst importing files from \"{__importTab.__destinationProject.GetPath()}\".";
                    }
                    else if (__importMode == "loose files")
                    {
                        _message = $"An error occurred whilst importing loose files.";
                    }
                    else if (__importMode == "channels")
                    {
                        _message = $"An error occurred whilst importing files from \"{__importTab.GetSelectedRelease().GetWebURL()}\".";
                    }
                }
                
                oInterface.popUpStruct = new ClassModalMessage(_message);
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
                
                var _func = function(_title, _array)
                {
                    if (ImGuiCollapsingHeader($"{_title} ({array_length(_array)})"))
                    {
                        if (array_length(_array) <= 0)
                        {
                            ImGuiText($"(No {string_lower(_title)})");
                        }
                        else
                        {
                            ImGuiText($"{array_length(_array)} {string_lower(_title)}:");
                            
                            var _i = 0;
                            repeat(array_length(_array))
                            {
                                ImGuiText(_array[_i]);
                                ++_i;
                            }
                        }
                    }
                }
                
                _func("Conflicts",  __job.GetConflictArray());
                _func("Additions",  __job.GetAddArray());
                _func("Overwrites", __job.GetOverwriteArray());
                _func("Deletions",  __job.GetDeleteArray());
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