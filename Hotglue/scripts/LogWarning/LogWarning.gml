// Feather disable all

function LogWarning(_string)
{
    static _logArray = __LogSystem().__logArray;
    
    var _currentDateTime = date_current_datetime();
    show_debug_message($"{date_datetime_string(_currentDateTime)} {_string}");
    
    array_push(_logArray, {
        time: _currentDateTime,
        text: _string,
        warning: true,
    });
    
    with(oInterface)
    {
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