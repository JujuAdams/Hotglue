// Feather disable all

/// @param string

function __HotglueStripHTML(_string)
{
    var _array = string_split(_string, "<");
    
    var _i = 0;
    repeat(array_length(_array))
    {
        var _substring = _array[_i];
        
        var _pos = string_pos(">", _substring);
        if (_pos > 0)
        {
            var _tagContent = string_copy(_substring, 1, _pos-1);
            
            _substring = string_delete(_substring, 1, _pos);
            
            //Hack!
            if (_tagContent == "/p")
            {
                _substring = " \r\n" + _substring;
            }
        }
        
        _substring = string_replace_all(_substring, "&lt;"  , "<");
        _substring = string_replace_all(_substring, "&gt;"  , ">");
        _substring = string_replace_all(_substring, "&amp;" , "&");
        _substring = string_replace_all(_substring, "&apos;", "'");
        _substring = string_replace_all(_substring, "&#x27;", "'");
        _substring = string_replace_all(_substring, "&quot;", "\"");
        _substring = string_replace_all(_substring, "&nbsp;", chr(0xa0));
        
        _array[@ _i] = _substring;
        
        ++_i;
    }
    
    _string = string_concat_ext(_array);
    
    return _string;
}