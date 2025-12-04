// Feather disable all

function ClassTabInspector() : ClassTab() constructor
{
    __project = undefined;
    __view = undefined;
    
    static TabItem = function()
    {
        if (ImGuiBeginTabItem("Inspector"))
        {
            if (__project == undefined)
            {
                ImGuiText("No project loaded.");
                if (ImGuiButton("Load .yyp project..."))
                {
                    var _path = get_open_filename("GameMaker Project (*.yyp)|*.yyp", "");
                    if (_path != "")
                    {
                        if (filename_ext(_path) != ".yyp")
                        {
                            LogWarning($"Unsupported file extension \"{filename_ext(_path)}\" for project inspector");
                        }
                        else
                        {
                            __project = HotglueLoadYYP(_path);
                            __view = new ClassInterfaceProjectView(__project);
                            LogTraceAndStatus($"Loaded \"{__project.GetPath()}\" for inspection");
                        }
                    }
                }
            }
            else
            {
                ImGuiText(__project.GetPath());
                ImGuiSameLine();
                if (ImGuiButton("Close"))
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
            
            ImGuiEndTabItem();
        }
    }
}