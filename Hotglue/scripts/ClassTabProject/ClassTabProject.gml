// Feather disable all

function ClassTabProject() : ClassTab() constructor
{
    __destinationProject = undefined;
    __destinationView = undefined;
    
    __directProject = undefined;
    __directView = undefined;
    
    __installProject = undefined;
    __installView = undefined;
    
    __looseFileViewArray = [];
    
    static TabItem = function()
    {
        if (ImGuiBeginTabItem("Project"))
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
                                    __directProject = HotglueLoadYYP(_path);
                                    __directView = new ClassInterfaceProjectView(__directProject);
                                    
                                    LogTraceAndStatus($"Loaded \"{_path}\"");
                                }
                                catch(_error)
                                {
                                    LogWarning(_error[$ "message"] ?? string(_error));
                                    LogWarning($"Failed to load \"{_path}\"");
                                    
                                    __directProject = undefined;
                                    __directView = undefined;
                                }
                            }
                            else if (filename_ext(_path) == ".gml")
                            {
                                LogTraceAndStatus($"Loaded \"{_path}\"");
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
                            LogWarning(_error[$ "message"] ?? string(_error));
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
                
                ImGuiBeginChild("sourceInnerPane");
                ImGuiBeginTabBar("tabBar");
                
                var _i = 0;
                repeat(HotglueGetChannelCount())
                {
                    InterfaceEnsureChannelView(HotglueGetChannelByIndex(_i)).BuildHalfViewTab();
                    ++_i;
                }
                
                ImGuiEndTabBar();
                ImGuiEndChild();
                
                ImGuiEndTabItem();
            }
            
            ImGuiEndTabBar();
            
            ImGuiEndChild();
            
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
                ImGuiBeginDisabled((__installProject == undefined) || (__destinationProject == undefined));
            }
            else
            {
                ImGuiBeginDisabled(false);
            }
            
            if (ImGuiButton("Import ->"))
            {
                if (_importMode == "local project")
                {
                    __destinationProject.ImportFrom(__directProject, __directView.GetAssetArray());
                }
                else if (_importMode == "loose files")
                {
                    //Convert the array of loose file views into an array of the loose files themselves
                    var _looseFileViewArray = __looseFileViewArray;
                    var _looseFileArray = array_create(array_length(_looseFileViewArray));
                    var _i = 0;
                    repeat(array_length(_looseFileViewArray))
                    {
                        _looseFileArray[@ _i] = _looseFileViewArray[_i].__file;
                        ++_i;
                    }
                    
                    LogTraceAndStatus($"Starting import of loose files into \"{__destinationProject.GetPath()}\"");
                    __destinationProject.ImportFromLooseFiles(_looseFileArray);
                    LogTraceAndStatus($"Finished importing loose files into \"{__destinationProject.GetPath()}\"");
                }
                else if (_importMode == "channels")
                {
                    __destinationProject.ImportAllFrom(__installProject);
                }
            }
            
            ImGuiEndDisabled();
            
            ImGuiEndChild();
            ImGuiSameLine();
            
            ImGuiBeginChild("destinationOuterPane", _bigPaneSize);
            
            if (__destinationProject != undefined)
            {
                ImGuiBeginTabBar("destinationTabBar");
                
                if (ImGuiBeginTabItem("Overview"))
                {
                    ImGuiBeginChild("destinationInnerPane", undefined, undefined, ImGuiChildFlags.Border);
                    
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
                ImGuiBeginChild("destinationInnerPane", undefined, undefined, ImGuiChildFlags.Border);
                ImGuiText("No destination project loaded.");
                
                if (ImGuiButton("Load project..."))
                {
                    var _path = get_open_filename("GameMaker Project (.yyp)|*.yyp", "");
                    if (_path != "")
                    {
                        try
                        {
                            __destinationProject = HotglueLoadYYP(_path);
                            __destinationView = new ClassInterfaceProjectView(__destinationProject);
                            
                            LogTraceAndStatus($"Loaded \"{_path}\"");
                        }
                        catch(_error)
                        {
                            LogWarning(_error[$ "message"] ?? string(_error));
                            LogWarning($"Failed to load \"{_path}\"");
                            __destinationProject = undefined;
                            __destinationView = undefined;
                        }
                    }
                }
                
                ImGuiEndChild();
            }
            
            ImGuiEndChild();
            
            ImGuiEndTabItem();
        }
    }
}