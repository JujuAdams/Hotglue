// Feather disable all

function ClassTabInspector() : ClassTab() constructor
{
    static __name = "Project Inspector";
    
    __project = undefined;
    __view = undefined;
    
    static MenuItem = function()
    {
        if (ImGuiBeginMenu(__name))
        {
            var _openPath = "";
            
            if (ImGuiMenuItem("Open project..."))
            {
                _openPath = get_open_filename("GameMaker Project (*.yyp)|*.yyp", "");
            }
            
            ImGuiSeparator();
            
            var _recentArray = InterfaceRecentGetArray();
            if (array_length(_recentArray) <= 0)
            {
                ImGuiBeginDisabled(true);
                ImGuiText("(No recent projects)");
                ImGuiEndDisabled();
            }
            else
            {
                ImGuiBeginDisabled(true);
                ImGuiText("Recent projects:");
                ImGuiEndDisabled();
                
                var _i = 0;
                repeat(array_length(_recentArray))
                {
                    if (ImGuiMenuItem(_recentArray[_i]))
                    {
                        _openPath = _recentArray[_i];
                    }
                    
                    ++_i;
                }
            }
            
            if (_openPath != "")
            {
                if (filename_ext(_openPath) != ".yyp")
                {
                    LogWarning($"Unsupported file extension \"{filename_ext(_openPath)}\" for project inspector");
                }
                else
                {
                    __project = HotglueProjectLocalEnsure(_openPath);
                    __view = new ClassInterfaceProjectView(__project);
                    LogTraceAndStatus($"Loaded \"{__project.GetPath()}\" for inspection");
                    InterfaceRecentPush(_openPath);
                    
                    other.menuFocus = self;
                }
            }
            
            ImGuiEndMenu();
        }
    }
    
    static Build = function()
    {
        if (__project == undefined)
        {
            var _openPath = "";
            
            ImGuiText("No project opened.");
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
            
            if (_openPath != "")
            {
                if (filename_ext(_openPath) != ".yyp")
                {
                    LogWarning($"Unsupported file extension \"{filename_ext(_openPath)}\" for project inspector");
                }
                else
                {
                    __project = HotglueProjectLocalEnsure(_openPath);
                    __view = new ClassInterfaceProjectView(__project);
                    LogTraceAndStatus($"Loaded \"{__project.GetPath()}\" for inspection");
                    InterfaceRecentPush(_openPath);
                }
            }
        }
        else
        {
            ImGuiText(__project.GetPath());
            
            ImGuiSameLine();
            if (ImGuiSmallButton("Refresh"))
            {
                __project.Raefresh();
            }
            
            ImGuiSameLine();
            if (ImGuiSmallButton("Close"))
            {
                LogTraceAndStatus($"Closed \"{__project.GetPath()}\"");
                
                __project = undefined;
                __view = undefined;
            }
            
            if (__project != undefined)
            {
                ImGuiBeginChild("leftPane", oInterface.context.Display.Width*0.66 - 6, undefined, ImGuiChildFlags.Border);
                __view.BuildOverview();
                ImGuiEndChild();
                
                ImGuiSameLine();
                
                ImGuiBeginChild("rightPane", undefined, undefined, ImGuiChildFlags.Border);
                __view.BuildTreeAsDestination();
                ImGuiEndChild();
            }
        }
    }
}