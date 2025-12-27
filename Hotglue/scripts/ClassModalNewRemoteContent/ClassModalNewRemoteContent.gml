// Feather disable all

function ClassModalNewRemoteContent() constructor
{
    __url = "https://github.com/jujuadams/scribble";
    
    
    
    static Build = function()
    {
        var _name = $"##modal_{string(ptr(self))}";
        
        ImGuiOpenPopup(_name);
        ImGuiSetNextWindowSize(oInterface.context.GetRegion().width/2, oInterface.context.GetRegion().height/4);
        var _result = ImGuiBeginPopupModal(_name, true);
        if (_result & ImGuiReturnMask.Return)
        {
            ImGuiText("URL:");
            ImGuiSetNextItemWidth(ImGuiGetContentRegionAvailX());
            __url  = ImGuiInputText("##url", __url);
            
            ImGuiNewLine();
            
            ImGuiTextColored("Only GitHub URLs are supported at this time.", INTERFACE_COLOR_ORANGE_TEXT, 1);
            
            ImGuiNewLine();
            
            if (ImGuiButton("Cancel"))
            {
                oInterface.popUpStruct = undefined;
            }
            
            ImGuiSameLine(undefined, 20);
            
            if (ImGuiButton("Add remote content"))
            {
                HotglueGetChannelByURL(HOTGLUE_CUSTOM_CHANNEL).AddRepository(__url);
                oInterface.popUpStruct = undefined;
            }
            
            ImGuiEndPopup();
            
            return true;
        }
        else
        {
            return false;
        }
    }
}