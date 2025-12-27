// Feather disable all

function ClassModalNewChannel() constructor
{
    __type = HOTGLUE_CHANNEL_JSON;
    __name = "Hotglue-Index";
    __url  = "https://raw.githubusercontent.com/JujuAdams/Hotglue-Index/refs/heads/main/github.json";
    
    
    
    static Build = function()
    {
        var _name = $"##modal_{string(ptr(self))}";
        
        ImGuiOpenPopup(_name);
        ImGuiSetNextWindowSize(oInterface.context.GetRegion().width/2, oInterface.context.GetRegion().height/3);
        var _result = ImGuiBeginPopupModal(_name, true);
        if (_result & ImGuiReturnMask.Return)
        {
            ImGuiText("Name:");
            ImGuiSetNextItemWidth(ImGuiGetContentRegionAvailX());
            __name = ImGuiInputText("##name", __name);
            
            ImGuiNewLine();
            
            ImGuiText("URL / Path:");
            ImGuiSetNextItemWidth(ImGuiGetContentRegionAvailX());
            __url  = ImGuiInputText("##url", __url);
            
            ImGuiNewLine();
            
            ImGuiText("Parser Type:");
            ImGuiSetNextItemWidth(ImGuiGetContentRegionAvailX());
            if (ImGuiBeginCombo($"##combo", __type, ImGuiComboFlags.None))
            {
                if (ImGuiSelectable(HOTGLUE_CHANNEL_JSON, (__type == HOTGLUE_CHANNEL_JSON)))
                {
                    __type = HOTGLUE_CHANNEL_JSON;
                }
                
                if (ImGuiSelectable(HOTGLUE_CHANNEL_DIRECTORY, (__type == HOTGLUE_CHANNEL_DIRECTORY)))
                {
                    __type = HOTGLUE_CHANNEL_DIRECTORY;
                }
                
                if (ImGuiSelectable(HOTGLUE_CHANNEL_GMK, (__type == HOTGLUE_CHANNEL_GMK)))
                {
                    __type = HOTGLUE_CHANNEL_GMK;
                }
                
                if (ImGuiSelectable(HOTGLUE_CHANNEL_GITHUB_USER, (__type == HOTGLUE_CHANNEL_GITHUB_USER)))
                {
                    __type = HOTGLUE_CHANNEL_GITHUB_USER;
                }
                
                if (ImGuiSelectable(HOTGLUE_CHANNEL_GITHUB_ORG, (__type == HOTGLUE_CHANNEL_GITHUB_ORG)))
                {
                    __type = HOTGLUE_CHANNEL_GITHUB_ORG;
                }
                
                ImGuiEndCombo();
            }
            
            ImGuiNewLine();
            
            if (ImGuiButton("Cancel"))
            {
                oInterface.popUpStruct = undefined;
            }
            
            ImGuiSameLine(undefined, 20);
            
            if (ImGuiButton("Add channel"))
            {
                var _channel = HotglueEnsureRemoteChannel(__type, __name, __url, false);
                _channel.Refresh();
                
                InterfaceSettingsSave();
                
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