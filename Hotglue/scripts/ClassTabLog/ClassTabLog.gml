// Feather disable all

function ClassTabLog() : ClassTab() constructor
{
    static TabItem = function()
    {
        if (LogGetNewWarnings())
        {
            var _displayName = ((current_time mod 300) < 150)? "! Log !" : "  Log  ";
        }
        else
        {
            var _displayName = "Log";
        }
        
        if (ImGuiBeginTabItem($"{_displayName}###logTab"))
        {
            LogSetNewWarnings(false);
            
            var _logArray = LogGetArray();
            
            if (ImGuiButton("Copy to clipboard"))
            {
                var _string = "";
                
                var _i = 0;
                repeat(array_length(_logArray))
                {
                    var _log = _logArray[_i];
                    _string += $"{date_datetime_string(_log.time)}{_log.warning? " Warning! " : " "}{_log.text}\n";
                    ++_i;
                }
                
                clipboard_set_text(_string);
                LogSetStatus("Copied log to clipboard");
            }
            
            ImGuiBeginTable("logTable", 2, ImGuiTableFlags.BordersInner);
            
            ImGuiTableSetupColumn("time", ImGuiTableColumnFlags.WidthFixed, 150);
            ImGuiTableSetupColumn("message");
            
            var _i = 0;
            repeat(array_length(_logArray))
            {
                var _log = _logArray[_i];
                
                ImGuiTableNextRow();
                
                ImGuiTableNextColumn();
                ImGuiTextColored(date_datetime_string(_log.time), c_gray);
                ImGuiTableNextColumn();
                
                if (_log.warning)
                {
                    ImGuiPushStyleColor(ImGuiCol.Text, INTERFACE_COLOR_RED_TEXT, 1);
                    ImGuiTextWrapped(_log.text);
                    ImGuiPopStyleColor();
                }
                else
                {
                    ImGuiTextWrapped(_log.text);
                }
                
                ++_i;
            }
            
            ImGuiEndTable();
            
            ImGuiEndTabItem();
        }
    }
}