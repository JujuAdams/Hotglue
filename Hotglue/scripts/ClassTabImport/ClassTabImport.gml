// Feather disable all

function ClassTabImport() : ClassTab() constructor
{
    static __name = "Import";
    
    __destinationProject = undefined;
    __destinationView = undefined;
    
    __directProject = undefined;
    __directView = undefined;
    
    __selectedChannel = undefined;
    
    __looseFileViewArray = [];
    
    
    
    static ImportLocalProject = function()
    {
        __destinationProject.ImportFrom(__directProject, __directView.GetAssetArray());
    }
    
    static ImportLooseFiles = function()
    {
        LogTraceAndStatus($"Starting import of loose files into \"{__destinationProject.GetPath()}\"");
        __destinationProject.ImportFromLooseFiles(GetLooseFileArray());
        LogTraceAndStatus($"Finished importing loose files into \"{__destinationProject.GetPath()}\"");
    }
    
    static ImportChannels = function()
    {
        var _selectedRelease = GetSelectedRelease();
        if (_selectedRelease != undefined)
        {
            __destinationProject.EnsureHotglueMetadata();
            
            _selectedRelease.LoadProject(function(_project, _success)
            {
                if (_success)
                {
                    if (_project.GetLoadedSuccessfully())
                    {
                        __destinationProject.ImportAsLibrary(_project);
                        LogTraceAndStatus("Imported release successfully.");
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
    
    static GetLooseFileArray = function()
    {
        var _looseFileViewArray = __looseFileViewArray;
        var _looseFileArray = array_create(array_length(_looseFileViewArray));
        
        var _i = 0;
        repeat(array_length(_looseFileViewArray))
        {
            _looseFileArray[@ _i] = _looseFileViewArray[_i].__file;
            ++_i;
        }
        
        return _looseFileArray;
    }
    
    static GetSelectedRelease = function()
    {
        var _selectedRelease = undefined;
        
        if (__selectedChannel != undefined)
        {
            var _channel = HotglueGetChannelByIndex(__selectedChannel);
            var _channelView = InterfaceEnsureChannelView(_channel);
            if (_channelView != undefined)
            {
                var _selectedRepository = _channelView.__selectedRepository;
                if (_selectedRepository != undefined)
                {
                    _selectedRelease = InterfaceEnsureRepositoryView(_selectedRepository).__selectedRelease;
                }
            }
        }
        
        return _selectedRelease;
    }
    
    static TabItem = function()
    {
        if (ImGuiBeginTabItem(__name, undefined, (oInterface.forceSelectedTab == __name)? ImGuiTabItemFlags.SetSelected : undefined))
        {
            var _importMode = undefined;
            
            var _importButtonSize = 70;
            var _bigPaneSize = 0.5*(ImGuiGetWindowWidth() - _importButtonSize) - 16;
            
            ImGuiBeginChild("sourceOuterPane", _bigPaneSize);
            
            ImGuiBeginTabBar("sourceTabBar");
            
            if (ImGuiBeginTabItem("Local Project"))
            {
                _importMode = "local project";
                
                ImGuiBeginChild("sourceInnerPane", undefined, undefined, ImGuiChildFlags.Border);
                
                if (__directProject != undefined)
                {
                    ImGuiText(__directProject.GetPath());
                    
                    ImGuiSameLine();
                    if (ImGuiSmallButton("Refresh"))
                    {
                        __directProject.Refresh();
                    }
                    
                    ImGuiSameLine();
                    if (ImGuiSmallButton("Close"))
                    {
                        LogTraceAndStatus($"Closed \"{__directProject.GetPath()}\"");
                        __directProject = undefined;
                        __directView = undefined;
                    }
                    else
                    {
                        ImGuiBeginChild("sourceProjectPane");
                        __directView.BuildTreeAsSource(__destinationProject);
                        ImGuiEndChild();
                    }
                }
                else
                {
                    ImGuiText("No source project loaded.");
                    
                    if (ImGuiButton("Load project..."))
                    {
                        var _path = get_open_filename("GameMaker Project (.yyp)|*.yyp", "");
                        if (_path != "")
                        {
                            if (filename_ext(_path) == ".yyp")
                            {
                                try
                                {
                                    __directProject = HotglueProjectLocalEnsure(_path);
                                    __directView = new ClassInterfaceProjectView(__directProject);
                                    
                                    LogTraceAndStatus($"Loaded \"{_path}\"");
                                }
                                catch(_error)
                                {
                                    LogWarning(json_stringify(_error, true));
                                    LogWarning($"Failed to load \"{_path}\"");
                                    
                                    __directProject = undefined;
                                    __directView = undefined;
                                }
                            }
                            else
                            {
                                LogTraceAndStatus($"File type not supported \"{_path}\"");
                            }
                        }
                    }
                }
                
                ImGuiEndChild();
                ImGuiEndTabItem();
            }
            
            if (ImGuiBeginTabItem("Loose Files"))
            {
                _importMode = "loose files";
                
                ImGuiBeginChild("sourceInnerPane", undefined, undefined, ImGuiChildFlags.Border);
                
                if (ImGuiButton("Add File..."))
                {
                    var _path = get_open_filename("*.*", "");
                    if (_path != "")
                    {
                        try
                        {
                            var _looseFile = HotglueLoadLooseFile(_path);
                            
                            if (array_get_index(__looseFileViewArray, _path) < 0)
                            {
                                array_push(__looseFileViewArray, new ClassInterfaceFileView(_looseFile));
                                LogTrace($"Loaded \"{_path}\"");
                            }
                            else
                            {
                                LogTrace($"\"{_path}\" has already been loaded");
                            }
                        }
                        catch(_error)
                        {
                            LogWarning(json_stringify(_error, true));
                            LogWarning($"Failed to load \"{_path}\"");
                        }
                    }
                }
                
                var _i = 0;
                repeat(array_length(__looseFileViewArray))
                {
                    var _looseFile = __looseFileViewArray[_i];
                    
                    if (ImGuiButton($"X##{ptr(_looseFile)}"))
                    {
                        array_delete(__looseFileViewArray, _i, 1);
                    }
                    else
                    {
                        ImGuiSameLine();
                        _looseFile.Build(__destinationProject);
                        ++_i;
                    }
                }
                
                ImGuiEndChild();
                
                ImGuiEndTabItem();
            }
            
            if (ImGuiBeginTabItem("Channels"))
            {
                _importMode = "channels";
                
                __selectedChannel = undefined;
                
                ImGuiBeginChild("sourceInnerPane");
                ImGuiBeginTabBar("tabBar");
                
                var _i = 0;
                repeat(HotglueGetChannelCount())
                {
                    if (InterfaceEnsureChannelView(HotglueGetChannelByIndex(_i)).BuildForImport())
                    {
                        __selectedChannel = _i;
                    }
                    
                    ++_i;
                }
                
                ImGuiEndTabBar();
                ImGuiEndChild();
                
                ImGuiEndTabItem();
            }
            
            ImGuiEndTabBar();
            
            ImGuiEndChild();
            
            ///////
            // The import button!
            ///////
            
            ImGuiSameLine();
            ImGuiBeginChild("middlePane", _importButtonSize);
            ImGuiSetCursorPosY(ImGuiGetContentRegionMaxY()/2 - 10);
            
            if (_importMode == "local project")
            {
                ImGuiBeginDisabled((__directProject == undefined) || (__directView == undefined) || (__directView.GetSelectedCount() <= 0) || (__destinationProject == undefined));
            }
            else if (_importMode == "loose files")
            {
                ImGuiBeginDisabled((array_length(__looseFileViewArray) <= 0) || (__destinationProject == undefined));
            }
            else if (_importMode == "channels")
            {
                ImGuiBeginDisabled((GetSelectedRelease() == undefined) || (__destinationProject == undefined));
            }
            else
            {
                ImGuiBeginDisabled(false);
            }
            
            if (ImGuiButton("Import ->"))
            {
                oInterface.popUpStruct = new ClassModalConfirmImport(self, _importMode);
            }
            
            ImGuiEndDisabled();
            
            ImGuiEndChild();
            ImGuiSameLine();
            
            ///////
            // Destination project
            ///////
            
            ImGuiBeginChild("destinationOuterPane", _bigPaneSize);
            
            if (__destinationProject != undefined)
            {
                ImGuiBeginTabBar("destinationTabBar");
                
                if (ImGuiBeginTabItem("Overview"))
                {
                    ImGuiBeginChild("destinationInnerPane", undefined, undefined, ImGuiChildFlags.Border);
                    
                    ImGuiText(__destinationProject.GetPath());
                    ImGuiSameLine();
                    if (ImGuiSmallButton("Close"))
                    {
                        __destinationProject = undefined;
                        __destinationView = undefined;
                    }
                    
                    ImGuiNewLine();
                    
                    if (__destinationView != undefined)
                    {
                        __destinationView.BuildOverview();
                    }
                    
                    ImGuiEndChild();
                    ImGuiEndTabItem();
                }
                
                if (ImGuiBeginTabItem("Resources"))
                {
                    ImGuiBeginChild("destinationInnerPane", undefined, undefined, ImGuiChildFlags.Border);
                    
                    if (__destinationView != undefined)
                    {
                        __destinationView.BuildTreeAsDestination(is_struct(__directProject)? __directProject : __looseFileViewArray);
                    }
                    
                    ImGuiEndChild();
                    
                    ImGuiEndTabItem();
                }
                
                ImGuiEndTabBar();
            }
            else
            {
                var _openPath = "";
                
                ImGuiBeginChild("destinationInnerPane", undefined, undefined, ImGuiChildFlags.Border);
                
                ImGuiText("No destination project opened.");
                if (ImGuiButton("Open .yyp project..."))
                {
                    _openPath = get_open_filename("GameMaker Project (*.yyp)|*.yyp", "");
                }
                
                ImGuiNewLine();
                ImGuiText("Recently opened:");
                ImGuiIndent();
                
                var _recentArray = InterfaceRecentGetArray();
                if (array_length(_recentArray) <= 0)
                {
                    ImGuiText("(No recently opened projects)");
                }
                else
                {
                    var _i = 0;
                    repeat(array_length(_recentArray))
                    {
                        if (ImGuiButton(_recentArray[_i]))
                        {
                            _openPath = _recentArray[_i];
                        }
                        
                        ++_i;
                    }
                }
                
                ImGuiUnindent();
                ImGuiEndChild();
                
                if (_openPath != "")
                {
                    if (filename_ext(_openPath) == ".yyp")
                    {
                        try
                        {
                            __destinationProject = HotglueProjectLocalEnsure(_openPath);
                            __destinationView = new ClassInterfaceProjectView(__destinationProject);
                                
                            LogTraceAndStatus($"Loaded \"{_openPath}\"");
                        }
                        catch(_error)
                        {
                            LogWarning(json_stringify(_error, true));
                            LogWarning($"Failed to load \"{_openPath}\"");
                            __destinationProject = undefined;
                            __destinationView = undefined;
                        }
                        
                        if (__destinationProject != undefined)
                        {
                            InterfaceRecentPush(_openPath);
                        }
                    }
                    else
                    {
                        LogTraceAndStatus($"File type not supported \"{_openPath}\"");
                    }
                }
            }
            
            ImGuiEndChild();
            
            ImGuiEndTabItem();
        }
    }
}