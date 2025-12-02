// Feather disable all

function ClassChannelFavorites() : __ClassChannelCommon("* Favourites *") constructor
{
    dirty = true;
    
    __linkArray = [];
    __selectedLink = undefined;
    
    static BuildHeader = function()
    {
        if (not dirty) return;
        dirty = false;
        
        var _linkArray = __linkArray;
        array_resize(_linkArray, 0);
        
        var _favoriteURLArray = InterfaceSettingGet("favoriteLinks");
        var _i = 0;
        repeat(array_length(_favoriteURLArray))
        {
            var _url = _favoriteURLArray[_i];
            array_push(_linkArray, new ClassLink(_url, _url));
            ++_i;
        }
        
        LogTrace($"Rebuilt favourited links");
        
        if (__selectedLink != undefined)
        {
            var _selectedURL = __selectedLink.GetURL();
            __selectedLink = undefined;
            
            var _i = 0;
            repeat(array_length(_linkArray))
            {
                if (_linkArray[_i].GetURL() == _selectedURL)
                {
                    __selectedLink = _linkArray[_i];
                    break;
                }
                
                ++_i;
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