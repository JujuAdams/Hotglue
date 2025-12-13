// Feather disable all

function ClassModal() constructor
{
    static Build = function()
    {
        var _name = $"modal_{string(ptr(self))}";
        
        ImGuiOpenPopup(_name);
        var _result = ImGuiBeginPopupModal(_name, true);
        if (_result & ImGuiReturnMask.Return)
        {
            ImGuiText("Hello!");
            ImGuiEndPopup();
            
            return true;
        }
        else
        {
            return false;
        }
    }
}