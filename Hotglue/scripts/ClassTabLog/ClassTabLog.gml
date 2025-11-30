// Feather disable all

function ClassTabLog() : ClassTab() constructor
{
    logArray = [];
    newWarnings = false;
    warningArray = [];
    
    static TabItem = function()
    {
        if (newWarnings)
        {
            var _displayName = ((current_time mod 300) < 150)? "! Log !" : "  Log  ";
        }
        else
        {
            var _displayName = "Log";
        }
        
        if (ImGuiBeginTabItem($"{_displayName}###logTab"))
        {
            newWarnings = false;
            
            ImGuiSetCursorPosY(ImGuiGetCursorPosY() + 3);
            
            if (array_length(warningArray) <= 0)
            {
                ImGuiTextWrapped("No warnings! Yet!");
            }
            else
            {
                var _i = 0;
                repeat(array_length(warningArray))
                {
                    ImGuiTextWrapped(warningArray[_i].text);
                    ++_i;
                }
            }
            
            ImGuiEndTabItem();
        }
    }
}