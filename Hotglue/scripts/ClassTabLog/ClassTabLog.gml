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
                LogCopyToClipboard();
            }
            
            ImGuiSameLine(undefined, 20);
            if (ImGuiButton("Save to file..."))
            {
                var _path = get_save_filename("*.txt", "log.txt");
                if (_path != "")
                {
                    LogSaveToFile(_path);
                }
            }
            
            ImGuiBeginChild("logPane");
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
            ImGuiEndChild();
            
            ImGuiEndTabItem();
        }
    }
}