function HotglueDatetimeToValue(_datetimeString)
{
    static _cacheDict = {};
    
    _datetimeString = string_trim(_datetimeString);
    
    var _value = _cacheDict[$ _datetimeString];
    if (not is_numeric(_value))
    {
        var _year  = undefined;
        var _month = undefined;
        var _day   = undefined;
    
        var _hour   = 0;
        var _minute = 0;
        var _second = 0;
        
        var _tPos = string_pos("T", _datetimeString);
        if (_tPos > 0)
        {
            var _dateString = string_copy(_datetimeString, 1, _tPos-1);
            var _timeString = string_copy(_datetimeString, _tPos+1, string_length(_datetimeString) - _tPos);
        }
        else
        {
            var _spacePos = string_pos(" ", _datetimeString);
            if ((_spacePos > 0) && (string_count(" ", _datetimeString) == 1))
            {
                var _dateString = string_copy(_datetimeString, 1, _spacePos-1);
                var _timeString = string_copy(_datetimeString, _spacePos+1, string_length(_datetimeString) - _spacePos);
            }
            else
            {
                var _dateString = _datetimeString;
                var _timeString = "";
            }
        }
    
        if (string_count("-", _dateString) != 2)
        {
            __HotglueWarning($"Unsupported number of \"-\" characters ({string_count("-", _dateString)}) in datetime string \"{_datetimeString}\"");
            return 0;
        }
    
        var _ymdArray = string_split(_dateString, "-");
        try
        {
            _year = real(_ymdArray[0]);
        }
        catch(_error)
        {
            __HotglueWarning($"Failed to parse year in datetime string \"{_datetimeString}\"");
            return 0;
        }
    
        try
        {
            _month = real(_ymdArray[1]);
        }
        catch(_error)
        {
            __HotglueWarning($"Failed to parse month in datetime string \"{_datetimeString}\"");
            return 0;
        }
    
        try
        {
            _day = real(_ymdArray[2]);
        }
        catch(_error)
        {
            __HotglueWarning($"Failed to parse day in datetime string \"{_datetimeString}\"");
            return 0;
        }
    
        if (_timeString != "")
        {
            var _zPos     = string_pos("Z", _timeString);
            var _plusPos  = string_pos("+", _timeString);
            var _minusPos = string_pos("-", _timeString);
        
            if (_zPos     == 0) _zPos     = infinity;
            if (_plusPos  == 0) _plusPos  = infinity;
            if (_minusPos == 0) _minusPos = infinity;
        
            var _cutPos = min(_zPos, _plusPos, _minusPos);
            if (not is_infinity(_cutPos))
            {
                var _offsetString = ""; //TODO
                _timeString = string_copy(_timeString, 1, _cutPos-1);
            }
            else
            {
                var _offsetString = "";
            }
        
            var _hmsArray = string_split(_timeString, ":");
            try
            {
                _hour = real(_hmsArray[0]);
            }
            catch(_error)
            {
                __HotglueWarning($"Failed to parse hour in datetime string \"{_datetimeString}\"");
                return 0;
            }
        
            try
            {
                _minute = real(_hmsArray[1]);
            }
            catch(_error)
            {
                __HotglueWarning($"Failed to parse minute in datetime string \"{_datetimeString}\"");
                return 0;
            }
        
            try
            {
                _second = real(_hmsArray[2]);
            }
            catch(_error)
            {
                __HotglueWarning($"Failed to parse second in datetime string \"{_datetimeString}\"");
                return 0;
            }
        }
    
        _value = date_create_datetime(_year, _month, _day, _hour, _minute, _second);
        _cacheDict[$ _datetimeString] = _value;
    }
    
    return _value;
}