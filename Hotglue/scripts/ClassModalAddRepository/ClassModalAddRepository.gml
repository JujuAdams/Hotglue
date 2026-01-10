// Feather disable all

/// @param path

function ClassModalAddRepository(_path) constructor
{
    __path = _path;
    
    
    
    static Build = function()
    {
        var _name = $"Add repository##modal_{string(ptr(self))}";
        
        ImGuiOpenPopup(_name);
        ImGuiSetNextWindowSize(oInterface.context.GetRegion().width/2, oInterface.context.GetRegion().height/3);
        var _result = ImGuiBeginPopupModal(_name);
        if (_result & ImGuiReturnMask.Return)
        {
            ImGuiTextWrapped($"Hotglue has received a request to add the following path as a repository:");
            ImGuiNewLine();
            ImGuiTextWrapped($"{__path}");
            ImGuiNewLine();
            ImGuiTextWrapped($"If you accept, this repository can be found in the \"Custom\" channel.");
            ImGuiNewLine();
            
            if (ImGuiButton("Cancel"))
            {
                oInterface.popUpStruct = undefined;
            }
            
            ImGuiSameLine(undefined, 20);
            
            if (ImGuiButton("Accept"))
            {
                HotglueGetChannelByURL(HOTGLUE_CUSTOM_CHANNEL).AddRepository(__path);
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