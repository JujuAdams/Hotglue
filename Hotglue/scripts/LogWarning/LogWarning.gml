// Feather disable all

function LogWarning(_string)
{
    static _system   = __LogSystem();
    static _logArray = _system.__logArray;
    
    var _currentDateTime = date_current_datetime();
    show_debug_message($"{date_datetime_string(_currentDateTime)} {_string}");
    
    array_push(_logArray, {
        time: _currentDateTime,
        text: _string,
        warning: true,
    });
    
    LogSetNewWarnings(true);
    LogSetStatus(_string);
}