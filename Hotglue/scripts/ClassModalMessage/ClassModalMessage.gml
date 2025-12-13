// Feather disable all

/// @param message

function ClassModalMessage(_message) constructor
{
    __message = _message;
    
    
    
    static Build = function()
    {
        var _name = $"##modal_{string(ptr(self))}";
        
        ImGuiOpenPopup(_name);
        ImGuiSetNextWindowSize(oInterface.context.GetRegion().width/3, oInterface.context.GetRegion().height/3);
        var _result = ImGuiBeginPopupModal(_name, true);
        if (_result & ImGuiReturnMask.Return)
        {
            ImGuiTextWrapped(__message);
            ImGuiNewLine();
            if (ImGuiButton("OK"))
            {
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