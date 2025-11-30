// Feather disable all

function ClassTabProject() : ClassTab() constructor
{
    __destinationProject = undefined;
    __destinationView = undefined;
    
    __directProject = undefined;
    __directView = undefined;
    
    __looseFileArray = [];
    
    static TabItem = function()
    {
        if (ImGuiBeginTabItem("Project"))
        {
            var _importButtonSize = 70;
            var _bigPaneSize = 0.5*(ImGuiGetWindowWidth() - _importButtonSize) - 16;
            
            ImGuiBeginChild("sourceOuterPane", _bigPaneSize);
            
            ImGuiBeginTabBar("sourceTabBar");
            
            if (ImGuiBeginTabItem("Local Project"))
            {
                ImGuiBeginChild("sourceInnerPane", undefined, undefined, ImGuiChildFlags.Border);
                
                if (__directProject != undefined)
                {
                    ImGuiText(__directProject.GetPath());
                    ImGuiSameLine();
                    if (ImGuiSmallButton("Close"))
                    {
                        InterfaceStatus($"Closed \"{__directProject.GetPath()}\"");
                        __directProject = undefined;
                        __directView = undefined;
                    }
                    else
                    {
                        __directView.BuildAsSource(__destinationProject);
                    }
                }
                else
                {
                    ImGuiText("No project loaded.");
                    
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
                                    
                                    InterfaceStatus($"Loaded \"{_path}\"");
                                }
                                catch(_error)
                                {
                                    InterfaceWarning(_error[$ "message"] ?? string(_error));
                                    InterfaceWarning($"Failed to load \"{_path}\"");
                                    
                                    __directProject = undefined;
                                    __directView = undefined;
                                }
                            }
                            else if (filename_ext(_path) == ".gml")
                            {
                                InterfaceStatus($"Loaded \"{_path}\"");
                            }
                            else
                            {
                                InterfaceStatus($"File type not supported \"{_path}\"");
                            }
                        }
                    }
                }
                
                ImGuiEndChild();
                
                ImGuiEndTabItem();
            }
            
            if (ImGuiBeginTabItem("Loose Files"))
            {
                ImGuiBeginChild("sourceInnerPane", undefined, undefined, ImGuiChildFlags.Border);
                
                if (ImGuiButton("Add File..."))
                {
                    var _path = get_open_filename("*.*", "");
                    if (_path != "")
                    {
                        try
                        {
                            var _looseFile = HotglueLoadGML(_path);
                            
                            if (array_get_index(__looseFileArray, _path) < 0)
                            {
                                array_push(__looseFileArray, new ClassInterfaceFileView(_looseFile));
                                InterfaceTrace("Loaded \"{_path}\"");
                            }
                            else
                            {
                                InterfaceTrace("\"{_path}\" has already been loaded");
                            }
                        }
                        catch(_error)
                        {
                            InterfaceWarning(_error[$ "message"] ?? string(_error));
                            InterfaceWarning($"Failed to load \"{_path}\"");
                        }
                    }
                }
                
                var _i = 0;
                repeat(array_length(__looseFileArray))
                {
                    var _looseFile = __looseFileArray[_i];
                    
                    if (ImGuiSmallButton($"x###{ptr(_looseFile)}"))
                    {
                        array_delete(__looseFileArray, _i, 1);
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
            
            if (ImGuiBeginTabItem("Imported Libraries"))
            {
                ImGuiBeginChild("sourceInnerPane", undefined, undefined, ImGuiChildFlags.Border);
                
                if (__destinationProject != undefined)
                {
                    ImGuiText("No destination project loaded.");
                }
                else
                {
                    
                }
                
                ImGuiEndChild();
                
                ImGuiEndTabItem();
            }
            
            if (ImGuiBeginTabItem("Channels"))
            {
                ImGuiBeginChild("sourceInnerPane", undefined, undefined, ImGuiChildFlags.Border);
                ImGuiEndChild();
                
                ImGuiEndTabItem();
            }
            
            ImGuiEndTabBar();
            
            ImGuiEndChild();
            
            ImGuiSameLine();
            ImGuiBeginChild("middlePane", _importButtonSize);
            ImGuiSetCursorPosY(ImGuiGetContentRegionMaxY()/2 - 10);
            ImGuiButton("Import ->");
            ImGuiEndChild();
            ImGuiSameLine();
            
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
                        InterfaceStatus($"Closed \"{__destinationProject.GetPath()}\"");
                        __destinationProject = undefined;
                        __destinationView = undefined;
                    }
                    else
                    {
                    }
                    
                    ImGuiEndChild();
                    
                    ImGuiEndTabItem();
                }
                
                if (ImGuiBeginTabItem("Resources"))
                {
                    ImGuiBeginChild("destinationInnerPane", undefined, undefined, ImGuiChildFlags.Border);
                    
                    if (__destinationView != undefined)
                    {
                        __destinationView.BuildAsDestination(is_struct(__directProject)? __directProject : __looseFileArray);
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
                            
                            InterfaceStatus($"Loaded \"{_path}\"");
                        }
                        catch(_error)
                        {
                            InterfaceWarning(_error[$ "message"] ?? string(_error));
                            InterfaceWarning($"Failed to load \"{_path}\"");
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