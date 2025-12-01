// Feather disable all

function ClassChannelLocal() : ClassTab() constructor
{
    __linkArray = [];
    __selectedLink = undefined;
    
    static TabItem = function()
    {
        if (ImGuiBeginTabItem("Local"))
        {
            Build();
            ImGuiEndTabItem();
        }
    }
    
    static Build = function()
    {
        var _linkArray = __linkArray;
        
        ImGuiBeginChild("leftPaneOuter", 250, undefined, ImGuiChildFlags.Border);
        
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
                    array_push(_linkArray, _link);
                    InterfaceStatus($"Added local link \"{_path}\"");
                    
                    if (array_length(_linkArray) == 1)
                    {
                        __selectedLink = _link;
                    }
                }
                else
                {
                    InterfaceStatus($"Extension \"{_extension}\" unsupported ({_path})");
                }
            }
        }
        
        ImGuiBeginChild("leftPaneInner");
        
        if (array_length(_linkArray) <= 0)
        {
            ImGuiTextWrapped("No links have been added.");
        }
        else
        {
            var _i = 0;
            repeat(array_length(_linkArray))
            {
                var _link = _linkArray[_i];
                if (ImGuiSelectable(_link.GetName(), __selectedLink == _link))
                {
                    __selectedLink = _link;
                }
                
                ++_i;
            }
        }
        
        ImGuiEndChild();
        ImGuiEndChild();
        
        ImGuiSameLine();
        ImGuiBeginChild("rightPane", undefined, undefined, ImGuiChildFlags.Border);
        
        if (__selectedLink == undefined)
        {
            ImGuiText("Please select a link from the left-hand side.");
        }
        else
        {
            if (not __selectedLink.GetMetadataExists())
            {
                ImGuiTextColored("\"hotglue.json\" metadata file not found.", INTERFACE_COLOR_RED_TEXT);
                ImGuiSameLine();
                ImGuiTextLink("Click here to create \"hotglue.json\" and start editing metadata.");
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
        
        ImGuiEndChild();
    }
}