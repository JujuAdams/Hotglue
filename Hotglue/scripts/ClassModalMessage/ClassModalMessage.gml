// Feather disable all

/// @param message
/// @param callback

function ClassModalMessage(_message, _callback) constructor
{
    __message  = _message;
    __callback = _callback;
    
    
    static Build = function()
    {
        var _name = $"##modal_{string(ptr(self))}";
        
        ImGuiOpenPopup(_name);
        ImGuiSetNextWindowSize(oInterface.context.GetRegion().width/3, oInterface.context.GetRegion().height/3);
        var _result = ImGuiBeginPopupModal(_name);
        if (_result & ImGuiReturnMask.Return)
        {
            ImGuiTextWrapped(__message);
            ImGuiNewLine();
            if (ImGuiButton("OK"))
            {
                oInterface.popUpStruct = undefined;
                
                if (is_callable(__callback))
                {
                    __callback();
                }
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