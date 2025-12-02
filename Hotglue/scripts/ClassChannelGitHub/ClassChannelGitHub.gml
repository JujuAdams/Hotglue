// Feather disable all

// https://api.github.com/repos/jujuadams/dotobj/pulls
// https://api.github.com/repos/JujuAdams/dotobj/pulls/12
// https://api.github.com/repos/cicadian/dotobj_merge/contents
// https://raw.githubusercontent.com/cicadian/dotobj_merge/master/README.md

function ClassChannelGitHub() : __ClassChannelCommon("GitHub") constructor
{
    __url = "";
    
    static GetURL = function()
    {
        return __url;
    }
    
    static SetURL = function(_url, _allowRefresh = true)
    {
        if (_url != __url)
        {
            __url = _url;
            
            if (_allowRefresh)
            {
                Refresh();
            }
        }
        
        return self;
    }
    
    static BuildHeader = function()
    {
        ImGuiText(__url);
        ImGuiSameLine();
        ImGuiSetCursorPosX(ImGuiGetCursorPosX() + 20);
        if (ImGuiButton("Refresh"))
        {
            Refresh();
        }
    }
    
    static BuildRightPanel = function()
    {
        if (not __selectedLink.GetMetadataExists())
        {
            ImGuiTextColored("\"Hotglue Metadata\" Note asset not found.", INTERFACE_COLOR_RED_TEXT);
            ImGuiNewLine();
        }
            
        __selectedLink.BuildForView();
        
        ImGuiNewLine();
        if (ImGuiButton("Refresh"))
        {
            
        }
    }
}