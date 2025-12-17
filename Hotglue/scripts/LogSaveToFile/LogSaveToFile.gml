// Feather disable all

/// @path

function LogSaveToFile(_path)
{
    static _logArrayStatic = __LogSystem().__logArray;
    
    var _logArray = _logArrayStatic;
    
    var _buffer = buffer_create(1024, buffer_grow, 1);
    var _i = 0;
    repeat(array_length(_logArray))
    {
        var _log = _logArray[_i];
        
        buffer_write(_buffer, buffer_text, date_datetime_string(_log.time));
        buffer_write(_buffer, buffer_text, _log.warning? " Warning! " : " ");
        buffer_write(_buffer, buffer_text, _log.text);
        buffer_write(_buffer, buffer_text, "\n");
        
        ++_i;
    }
    
    buffer_save_ext(_buffer, _path, 0, buffer_tell(_buffer));
    buffer_delete(_buffer);
    
    LogSetStatus($"Saved log to \"{_path}\"");
}