// Feather disable all

function InterfaceWarning(_string)
{
    var _currentDateTime = date_current_datetime();
    show_debug_message($"{date_datetime_string(_currentDateTime)} Warning! {_string}");
    
    with(oInterface)
    {
        with(logTab)
        {
            newWarnings = true;
            array_push(logArray, {
                time: _currentDateTime,
                text: _string,
                warning: true,
            });
        }
        
        status = new (function(_string) constructor
        {
            __string = _string;
            
            static Build = function()
            {
                ImGuiTextColored(__string, INTERFACE_COLOR_RED_TEXT);
            }
        })($"Warning! {_string}");
    }
}