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
    __importMode = undefined;
    
    
    
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
    
    static MenuItem = function()
    {
        if (ImGuiBeginMenu(__name))
        {
            if (ImGuiBeginMenu("Channels"))
            {
                var _i = 0;
                repeat(HotglueGetChannelCount())
                {
                    var _channel = HotglueGetChannelByIndex(_i);
                    if (ImGuiMenuItem($"{_channel.GetName()}###channel{_i}"))
                    {
                        __selectedChannel = _i;
                        __importMode = "channels";
                        other.menuFocus = self;
                    }
                    
                    ++_i;
                }
                
                ImGuiEndMenu();
            }
            
            if (ImGuiMenuItem("From local project"))
            {
                __importMode = "direct from project";
                other.menuFocus = self;
            }
            
            if (ImGuiMenuItem("From loose files"))
            {
                __importMode = "loose files";
                other.menuFocus = self;
            }
            
            ImGuiEndMenu();
        }
    }
    
    static Build = function()
    {
        var _importButtonSize = 70;
        var _bigPaneSize = 0.5*(ImGuiGetWindowWidth() - _importButtonSize) - 16;
        
        ImGuiBeginChild("sourceOuterPane", _bigPaneSize);
        
        if (__importMode == "channels")
        {
            if (__selectedChannel != undefined)
            {
                InterfaceEnsureChannelView(HotglueGetChannelByIndex(__selectedChannel)).BuildForImport();
            }
            else
            {
                ImGuiText("No channel selected. Please use the menubar above.");
            }
        }
        
        if (__importMode == "direct from project")
        {
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
                var _openPath = "";
                
                ImGuiText("No source project opened.");
                
                if (ImGuiButton("Load project..."))
                {
                    _openPath = get_open_filename("GameMaker Project (.yyp)|*.yyp", "");
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
                
                if (_openPath != "")
                {
                    if (filename_ext(_openPath) == ".yyp")
                    {
                        try
                        {
                            __directProject = HotglueProjectLocalEnsure(_openPath);
                            __directView = new ClassInterfaceProjectView(__directProject);
                            
                            LogTraceAndStatus($"Loaded \"{_openPath}\"");
                        }
                        catch(_error)
                        {
                            LogWarning(json_stringify(_error, true));
                            LogWarning($"Failed to load \"{_openPath}\"");
                             
                            __directProject = undefined;
                            __directView = undefined;
                        }
                    }
                    else
                    {
                        LogTraceAndStatus($"File type not supported \"{_openPath}\"");
                    }
                }
            }
            
            ImGuiEndChild();
        }
        
        if (__importMode == "loose files")
        {
            ImGuiBeginChild("sourceInnerPane", undefined, undefined, ImGuiChildFlags.Border);
            
            if (ImGuiButton("Add loose file..."))
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
            
            if (array_length(__looseFileViewArray) <= 0)
            {
                ImGuiNewLine();
                ImGuiText("No loose files have been added.");
            }
            else
            {
                ImGuiNewLine();
                
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
            }
            
            ImGuiEndChild();
        }
        
        ImGuiEndChild();
        
        ///////
        // The import button!
        ///////
        
        ImGuiSameLine();
        ImGuiBeginChild("middlePane", _importButtonSize);
        ImGuiSetCursorPosY(ImGuiGetContentRegionMaxY()/2 - 10);
        
        ImGuiBeginDisabled((__destinationProject == undefined) || __destinationProject.GetReadOnly());
        
        if (__importMode == "direct from project")
        {
            ImGuiBeginDisabled((__directProject == undefined) || (__directView == undefined) || (__directView.GetSelectedCount() <= 0));
        }
        else if (__importMode == "loose files")
        {
            ImGuiBeginDisabled((array_length(__looseFileViewArray) <= 0));
        }
        else if (__importMode == "channels")
        {
            ImGuiBeginDisabled((GetSelectedRelease() == undefined));
        }
        else
        {
            ImGuiBeginDisabled(false);
        }
        
        if (ImGuiButton("Import ->"))
        {
            oInterface.popUpStruct = new ClassModalConfirmImport(self, __importMode);
        }
        
        ImGuiEndDisabled();
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
                
                ImGuiText(__destinationProject.GetURL());
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
                        if (__destinationProject.GetReadOnly())
                        {
                            oInterface.popUpStruct = new ClassModalMessage($"Project is from an old version of GameMaker ({__destinationProject.GetYYPOriginalVersion()}) and has been opened in read-only mode.");
                        }
                        else
                        {
                            InterfaceRecentPush(_openPath);
                        }
                    }
                }
                else
                {
                    LogTraceAndStatus($"File type not supported \"{_openPath}\"");
                }
            }
        }
        
        ImGuiEndChild();
    }
}