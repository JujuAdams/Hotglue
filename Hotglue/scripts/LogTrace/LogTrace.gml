// Feather disable all

function LogTrace(_string)
{
    static _logArray = __LogSystem().__logArray;
    
    var _currentDateTime = date_current_datetime();
    show_debug_message($"{date_datetime_string(_currentDateTime)} {_string}");
    
    array_push(_logArray, {
        time: _currentDateTime,
        text: _string,
        warning: false,
    });
}