// Feather disable all

function InterfaceTrace(_string)
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
                warning: false,
            });
        }
    }
}