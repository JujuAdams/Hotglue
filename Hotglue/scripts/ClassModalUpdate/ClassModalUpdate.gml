// Feather disable all

/// @param project
/// @param packageName
/// @param currentReleaseName

function ClassModalUpdate(_project, _packageName, _currentReleaseName) constructor
{
    __project            = _project;
    __packageName        = _packageName;
    __currentReleaseName = _currentReleaseName;
    
    __error                = false;
    __seenReleases         = false;
    __selectedRelease      = undefined;
    __selectedReleaseIndex = undefined;
    
    
    
    static Build = function()
    {
        var _repository = __project.GetRepositoryForPackage(__packageName);
        var _releaseArray = is_struct(_repository)? _repository.GetReleases() : undefined;
                    
        var _name = $"Update##modal_{string(ptr(self))}";
        
        ImGuiOpenPopup(_name);
        ImGuiSetNextWindowSize(0.5*oInterface.context.GetRegion().width, 0.666*oInterface.context.GetRegion().height);
        var _result = ImGuiBeginPopupModal(_name, true);
        if (_result & ImGuiReturnMask.Return)
        {
            ImGuiTextWrapped($"Currently imported release for package \"{__packageName}\" is \"{__currentReleaseName}\".");
            
            if ((not is_struct(_repository)) || (not _repository.GetReleasesCollected()))
            {
                ImGuiText($"Checking for updates to \"{__packageName}\", please wait ...");
            }
            else
            {
                if (not __seenReleases)
                {
                    __seenReleases = true;
                    
                    var _i = 0;
                    repeat(array_length(_releaseArray))
                    {
                        if (_releaseArray[_i].GetName() == __currentReleaseName)
                        {
                            __selectedRelease = _releaseArray[_i];
                            __selectedReleaseIndex = _i;
                            break;
                        }
                        
                        ++_i;
                    }
                    
                    if (__selectedRelease == undefined)
                    {
                        __HotglueWarning($"Failed to find release \"{__currentReleaseName}\" in releases for \"{__packageName}\"");
                        __error = true;
                    }
                }
                
                ImGuiNewLine();
                
                if (__error)
                {
                    ImGuiText($"Failed to find release \"{__currentReleaseName}\" in releases for \"{__packageName}\".");
                }
                else
                {
                    if (is_instanceof(_repository, __HotglueRepositoryGitHub))
                    {
                        ImGuiText($"Found {__selectedReleaseIndex} newer releases");
                    }
                    else
                    {
                        ImGuiText($"Found {__selectedReleaseIndex} newer downloads");
                    }
                    
                    ImGuiSameLine();
                    ImGuiSetNextItemWidth(ImGuiGetWindowWidth()/3);
                    
                    if (ImGuiBeginCombo($"##combo_{ptr(self)}", (__selectedRelease == undefined)? "No release selected" : __selectedRelease.GetName(), ImGuiComboFlags.None))
                    {
                        var _i = 0;
                        repeat(array_length(_releaseArray))
                        {
                            var _release = _releaseArray[_i];
                            
                            if (_i < __selectedReleaseIndex)
                            {
                                ImGuiPushStyleColor(ImGuiCol.Text, INTERFACE_COLOR_GREEN_TEXT, 1);
                            }
                            else if (_i > __selectedReleaseIndex)
                            {
                                ImGuiPushStyleColor(ImGuiCol.Text, INTERFACE_COLOR_RED_TEXT, 1);
                            }
                            
                            if (ImGuiSelectable(_release.GetName(), (__selectedRelease == _release)))
                            {
                                __selectedRelease = _release;
                            }
                            
                            if (_i != __selectedReleaseIndex)
                            {
                                ImGuiPopStyleColor();
                            }
                            
                            ++_i;
                        }
                        
                        ImGuiEndCombo();
                    }
                    
                    if (_repository != undefined)
                    {
                        ImGuiBeginChild("patchNotesPane", undefined, ImGuiGetContentRegionAvailY() - 24, ImGuiChildFlags.Border);
                        
                        var _description = __selectedRelease.GetDescription();
                        if ((_description == undefined) || (_description == ""))
                        {
                            ImGuiText("No release description found or description empty.");
                        }
                        else
                        {
                            ImGuiTextWrapped(_description);
                        }
                        
                        ImGuiEndChild();
                    }
                }
            }
            
            if (ImGuiButton("Abort"))
            {
                oInterface.popUpStruct = undefined;
            }
            
            ImGuiSameLine(undefined, 50);
            
            ImGuiBeginDisabled((not is_struct(_repository)) || (not is_struct(__selectedRelease)) || (__currentReleaseName == __selectedRelease.GetName()) || __error);
            if (ImGuiButton($"Upgrade \"{__currentReleaseName}\" -> \"{is_struct(__selectedRelease)? __selectedRelease.GetName() : "???"}\""))
            {
                var _modal = new ClassModalConfirmJob(__project.JobEmpty(), true);
                oInterface.popUpStruct = _modal;
                
                with(_modal)
                {
                    __loadPending = true;
                    __loadSuccessful = false;
                    
                    other.__selectedRelease.LoadContent(function(_struct, _success)
                    {
                        __loadPending = false;
                        __loadSuccessful = false;
                        
                        if (_success)
                        {
                            if (is_instanceof(_struct, __HotglueProject))
                            {
                                if (_struct.GetLoadedSuccessfully())
                                {
                                    if (_struct.GetIsPackage())
                                    {
                                        oInterface.popUpStruct.__packageEditForce = true;
                                        __job.SetPackageFromProject(_struct);
                                    }
                                    
                                    __job.SetImportFrom(_struct, _struct.__quickAssetArray);
                                    __job.BuildReport();
                                    
                                    __loadSuccessful = true;
                                    LogTraceAndStatus("Loaded release successfully as a project.");
                                }
                                else
                                {
                                    LogWarning("Failed to load project file for release. Please check the log for further information.");
                                }
                            }
                            else if (is_instanceof(_struct, __HotglueLooseFile))
                            {
                                __job.SetImportLooseFile(_struct);
                                __job.BuildReport();
                                
                                __loadSuccessful = true;
                                LogTraceAndStatus("Loaded release successfully as a loose file.");
                            }
                            else
                            {
                                LogWarning("Release content invalid. Please check the log for further information.");
                            }
                        }
                        else
                        {
                            LogWarning("Failed to load content for release. Please check the log for further information.");
                        }
                    });
                }
            }
            ImGuiEndDisabled();
            
            ImGuiEndPopup();
            
            return true;
        }
        else
        {
            return false;
        }
    }
}