// Feather disable all

function InterfaceStatus(_string)
{
    var _currentDateTime = date_current_datetime();
    show_debug_message($"{date_datetime_string(_currentDateTime)} {_string}");
    
    with(oInterface)
    {
        with(logTab)
        {
            array_push(logArray, {
                time: _currentDateTime,
                text: _string,
            });
        }
        
        status = new (function(_string) constructor
        {
            __string = _string;
            
            static Build = function()
            {
                ImGuiText(__string);
            }
        })(_string);
    }
}