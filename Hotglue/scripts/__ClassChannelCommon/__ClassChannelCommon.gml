// Feather disable all

/// @param displayName
/// @param url

function __ClassChannelCommon(_displayName)
{
    __displayName = _displayName;
    
    __linkArray = [];
    __selectedLink = undefined;
    
    static GetDisplayName = function()
    {
        return __displayName;
    }
    
    static TabItem = function()
    {
        if (ImGuiBeginTabItem(__displayName))
        {
            Build();
            ImGuiEndTabItem();
        }
    }
    
    static Refresh = function()
    {
        //Do nothing by default
    }
    
    static Build = function()
    {
        BuildHeader();
        BuildLeftPanel();
        
        ImGuiSameLine();
        ImGuiBeginChild("rightPane", undefined, undefined, ImGuiChildFlags.Border);
        
        if (__selectedLink == undefined)
        {
            ImGuiText("No link selected.");
        }
        else
        {
            BuildRightPanel();
        }
        
        ImGuiEndChild();
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
                if (ImGuiSelectable(_link.GetName(), __selectedLink == _link))
                {
                    __selectedLink = _link;
                }
                
                ++_i;
            }
        }
        
        ImGuiEndChild();
        ImGuiEndChild();
    }
    
    static BuildHeader = function()
    {
        //Do nothing
    }
    
    static BuildLeftPanelHeader = function()
    {
        //Do nothing
    }
    
    static BuildRightPanel = function()
    {
        ImGuiText($"\"{__selectedLink.GetName()}\" selected.");
    }
}