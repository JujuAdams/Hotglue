// Feather disable all

function LogCopyToClipboard()
{
    static _logArrayStatic = __LogSystem().__logArray;
    
    var _logArray = _logArrayStatic;
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