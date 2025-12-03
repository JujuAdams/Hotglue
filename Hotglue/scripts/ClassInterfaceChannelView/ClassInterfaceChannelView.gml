// Feather disable all

/// @param channel

function ClassInterfaceChannelView(_channel) constructor
{
    __channel = _channel;
    
    __selectedRepository = undefined;
    
    
    
    static TabItem = function()
    {
        if (ImGuiBeginTabItem(__channel.GetName()))
        {
            BuildHeader();
            BuildLeftPanel();
            
            ImGuiSameLine();
            ImGuiBeginChild("rightPane", undefined, undefined, ImGuiChildFlags.Border);
            
            if (__selectedContent == undefined)
            {
                ImGuiText("No content selected.");
            }
            else
            {
                BuildRightPanel();
            }
            
            ImGuiEndChild();
            ImGuiEndTabItem();
        }
    }
    
    static BuildHeader = function()
    {
        //var _linkArray = __channel.GetRepositoryArray();
        //array_resize(_linkArray, 0);
        //
        //var _favoriteURLArray = InterfaceSettingGet("favoriteLinks");
        //var _i = 0;
        //repeat(array_length(_favoriteURLArray))
        //{
        //    var _url = _favoriteURLArray[_i];
        //    array_push(_linkArray, new ClassLink(_url, _url));
        //    ++_i;
        //}
        //
        //LogTrace($"Rebuilt favourited links");
        //
        //if (__selectedLink != undefined)
        //{
        //    var _selectedURL = __selectedLink.GetURL();
        //    __selectedLink = undefined;
        //    
        //    var _i = 0;
        //    repeat(array_length(_linkArray))
        //    {
        //        if (_linkArray[_i].GetURL() == _selectedURL)
        //        {
        //            __selectedLink = _linkArray[_i];
        //            break;
        //        }
        //        
        //        ++_i;
        //    }
        //}
    }
    
    static BuildLeftPanel = function()
    {
        ImGuiBeginChild("leftPaneOuter", 250, undefined, ImGuiChildFlags.Border);
        
        BuildLeftPanelHeader();
        
        ImGuiBeginChild("leftPaneInner");
        
        var _linkArray = __linkArray;
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
                if (ImGuiSelectable(_link.GetName(), __selectedContent == _link))
                {
                    __selectedContent = _link;
                }
                
                ++_i;
            }
        }
        
        ImGuiEndChild();
        ImGuiEndChild();
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