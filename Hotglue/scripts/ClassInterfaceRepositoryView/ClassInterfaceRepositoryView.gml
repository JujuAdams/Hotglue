// Feather disable all

/// @param repository

function ClassInterfaceRepositoryView(_repository) constructor
{
    __repository = _repository;
    
    __selectedRelease = undefined;
    __selectedProject = undefined;
    __projectView = undefined;
    
    static Build = function()
    {
        var _hotglueJSON = __repository.GetHotglueJSON();
        if (_hotglueJSON == undefined)
        {
            ImGuiText("Fetching hotglue.json, please wait...");
        }
        else
        {
            ImGuiText(json_stringify(_hotglueJSON, true));
        }
        
        ImGuiNewLine();
        
        var _releaseArray = __repository.GetReleases();
        if (_releaseArray == undefined)
        {
            ImGuiText("Fetching releases, please wait...");
        }
        else
        {
            if (__selectedRelease == undefined)
            {
                __selectedRelease = array_first(_releaseArray);
            }
            
            ImGuiText($"Found {array_length(_releaseArray)} releases (max {HOTGLUE_MAX_GITHUB_RELEASES})");
            
            if (ImGuiBeginCombo($"##combo_{ptr(self)}", (__selectedRelease == undefined)? "None selected" : __selectedRelease.GetName(), ImGuiComboFlags.None))
            {
                var _i = 0;
                repeat(array_length(_releaseArray))
                {
                    var _release = _releaseArray[_i];
                    if (ImGuiSelectable($"{_release.GetName()}##{ptr(_release)}", (__selectedRelease == _release)))
                    {
                        __selectedRelease = _release;
                    }
                    
                    ++_i;
                }
                
                ImGuiEndCombo();
            }
            
            ImGuiBeginDisabled(__selectedRelease == undefined);
            
            ImGuiNewLine();
            
            if (ImGuiButton("Download into cache"))
            {
                __selectedRelease.Download(function(_release, _success, _localURL)
                {
                    LogTraceAndStatus($"Downloaded \"{_release.GetWebURL()}\" successfully");
                });
            }
            
            if (__selectedRelease != undefined)
            {
                if (__selectedRelease.GetDownloaded())
                {
                    ImGuiSameLine();
                    ImGuiText($"Download successful");
                }
            }
            
            if (ImGuiButton("Open project"))
            {
                __selectedRelease.LoadProject(function(_project, _success)
                {
                    if (_success)
                    {
                        LogTraceAndStatus($"Loaded project successfully for release \"{__selectedRelease.GetWebURL()}\"");
                        __selectedProject = _project;
                        __projectView = new ClassInterfaceProjectView(_project);
                    }
                    else
                    {
                        LogWarning($"Failed to load project for release \"{__selectedRelease.GetWebURL()}\"");
                        __selectedProject = undefined;
                        __projectView = undefined;
                    }
                });
            }
            
            ImGuiEndDisabled();
            
            if (__projectView != undefined)
            {
                ImGuiBeginChild("projectPreview", undefined, undefined, ImGuiChildFlags.Border);
                __projectView.BuildTreeAsDestination();
                ImGuiEndChild();
            }
        }
    }
}