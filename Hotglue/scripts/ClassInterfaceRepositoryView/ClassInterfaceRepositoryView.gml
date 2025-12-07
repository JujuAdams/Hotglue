// Feather disable all

/// @param repository

function ClassInterfaceRepositoryView(_repository) constructor
{
    __repository = _repository;
    
    __selectedRelease = undefined;
    __selectedProject = undefined;
    __projectView = undefined;
    
    static BuildRepositoryDescription = function(_height)
    {
        ImGuiTextLinkOpenURL(__repository.GetURL(), __repository.GetURL());
        ImGuiNewLine();
        
        ImGuiBeginChild("repoDescription", undefined, _height);
        
        var _readme = __repository.GetReadme();
        if (_readme == undefined)
        {
            ImGuiText("Fetching README.md, please wait...");
        }
        else
        {
            ImGuiTextWrapped(_readme);
        }
        
        ImGuiEndChild();
    }
    
    static BuildReleaseDescription = function(_showDownloadButton)
    {
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
            ImGuiSameLine();
            ImGuiSetNextItemWidth(ImGuiGetWindowWidth()/3);
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
            
            if ((__selectedRelease != undefined) && (not __selectedRelease.GetStable()))
            {
                ImGuiSameLine();
                ImGuiTextColored("Pre-release", INTERFACE_COLOR_RED_TEXT);
            }
            
            ImGuiBeginDisabled(__selectedRelease == undefined);
            
            if (_showDownloadButton)
            {
                ImGuiSameLine();
                if (ImGuiButton("Download release"))
                {
                    LogTraceAndStatus($"Downloading release \"{__selectedRelease.GetWebURL()}\"");
                    __selectedRelease.Download(function(_release, _success, _localURL)
                    {
                        if (_success)
                        {
                            LogTraceAndStatus($"Downloaded \"{_release.GetWebURL()}\" successfully");
                            
                            var _filename = get_open_filename($"{filename_ext(_localURL)}|{filename_ext(_localURL)}", filename_name(__selectedRelease.GetPrimaryAssetURL()));
                            if (_filename != "")
                            {
                                file_copy(_filename, _localURL);
                                LogTraceAndStatus($"Copied \"{_localURL}\" to \"{_filename}\"");
                            }
                        }
                    });
                }
            }
            
            ImGuiEndDisabled();
            
            ImGuiBeginChild("releaseDecriptionPane");
            if (__selectedRelease == undefined)
            {
                ImGuiText("No release selected.");
            }
            else
            {
                var _description = __selectedRelease.GetDescription();
                if ((_description == undefined) || (_description == ""))
                {
                    ImGuiText("No release description found or description empty.");
                }
                else
                {
                    ImGuiTextWrapped(_description);
                }
            }
            ImGuiEndChild();
        }
    }
    
    static BuildForProjectTab = function()
    {
        if (is_instanceof(__repository, __HotglueRepositoryLocal))
        {
            //TODO
        }
        else
        {
            BuildRepositoryDescription(0.45*ImGuiGetWindowHeight());
            
            ImGuiBeginChild("releasePane", undefined, undefined, ImGuiChildFlags.Border);
            BuildReleaseDescription(false);
            ImGuiEndChild();
        }
    }
    
    static BuildForChannelTab = function()
    {
        if (is_instanceof(__repository, __HotglueRepositoryLocal))
        {
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
                ImGuiNewLine();
                ImGuiBeginChild("projectPreview");
                ImGuiBeginTabBar("projectPreviewTabBar");
                
                if (ImGuiBeginTabItem("Overview"))
                {
                    __projectView.BuildOverview();
                    ImGuiEndTabItem();
                }
                
                if (ImGuiBeginTabItem("Resources"))
                {
                    __projectView.BuildTreeAsDestination();
                    ImGuiEndTabItem();
                }
                
                ImGuiEndTabBar();
                ImGuiEndChild();
            }
        }
        else
        {
            ImGuiNewLine();
            ImGuiText(__repository.GetName());
            BuildRepositoryDescription(0.45*ImGuiGetWindowHeight());
            ImGuiNewLine();
            
            ImGuiBeginChild("releasePane", undefined, undefined, ImGuiChildFlags.Border);
            BuildReleaseDescription(true);
            ImGuiEndChild();
            
            //ImGuiBeginDisabled(__selectedRelease == undefined);
            //
            //ImGuiNewLine();
            //
            //if (ImGuiButton("Download into cache"))
            //{
            //    __selectedRelease.Download(function(_release, _success, _localURL)
            //    {
            //        LogTraceAndStatus($"Downloaded \"{_release.GetWebURL()}\" successfully");
            //    });
            //}
            //
            //if (__selectedRelease != undefined)
            //{
            //    if (__selectedRelease.GetDownloaded())
            //    {
            //        ImGuiSameLine();
            //        ImGuiText($"Download successful");
            //    }
            //}
            //
            //if (ImGuiButton("Open project"))
            //{
            //    __selectedRelease.LoadProject(function(_project, _success)
            //    {
            //        if (_success)
            //        {
            //            LogTraceAndStatus($"Loaded project successfully for release \"{__selectedRelease.GetWebURL()}\"");
            //            __selectedProject = _project;
            //            __projectView = new ClassInterfaceProjectView(_project);
            //        }
            //        else
            //        {
            //            LogWarning($"Failed to load project for release \"{__selectedRelease.GetWebURL()}\"");
            //            __selectedProject = undefined;
            //            __projectView = undefined;
            //        }
            //    });
            //}
            //
            //ImGuiEndDisabled();
            
            //if (__projectView != undefined)
            //{
            //    ImGuiNewLine();
            //    ImGuiBeginChild("projectPreview");
            //    ImGuiBeginTabBar("projectPreviewTabBar");
            //    
            //    if (ImGuiBeginTabItem("Overview"))
            //    {
            //        __projectView.BuildOverview();
            //        ImGuiEndTabItem();
            //    }
            //    
            //    if (ImGuiBeginTabItem("Resources"))
            //    {
            //        __projectView.BuildTreeAsDestination();
            //        ImGuiEndTabItem();
            //    }
            //    
            //    ImGuiEndTabBar();
            //    ImGuiEndChild();
            //}
        }
    }
}