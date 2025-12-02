// Feather disable all

function ClassChannelLocal() : __ClassChannelCommon("Local") constructor
{
    static BuildLeftPanelHeader = function()
    {
        if (ImGuiButton("Add new link..."))
        {
            var _path = get_open_filename("*.*", "");
            if (_path != "")
            {
                var _extension = filename_ext(_path);
                if ((_extension == ".yyp")
                ||  (_extension == ".yymps")
                ||  (_extension == ".yyz"))
                {
                    var _link = new ClassLink(_path, filename_name(_path));
                    array_push(__linkArray, _link);
                    LogTraceAndStatus($"Added local link \"{_path}\"");
                    
                    if (array_length(__linkArray) == 1)
                    {
                        __selectedLink = _link;
                    }
                }
                else
                {
                    LogTraceAndStatus($"File extension \"{_extension}\" unsupported ({_path})");
                }
            }
        }
    }
    
    static BuildRightPanel = function()
    {
        if (not __selectedLink.GetMetadataExists())
        {
            ImGuiTextColored("\"Hotglue Metadata\" Note asset not found.", INTERFACE_COLOR_RED_TEXT);
            
            if (__selectedLink.GetEdittable())
            {
                ImGuiSameLine();
                ImGuiTextLink("Click here to create metadata.");
            }
            
            ImGuiNewLine();
            
            __selectedLink.BuildForView();
        }
        else
        {
            __selectedLink.BuildForEdit();
        }
        
        ImGuiNewLine();
        if (ImGuiButton("Refresh"))
        {
            
        }
        
        ImGuiSameLine();
        if (ImGuiButton("Remove from list"))
        {
            
        }
    }
}