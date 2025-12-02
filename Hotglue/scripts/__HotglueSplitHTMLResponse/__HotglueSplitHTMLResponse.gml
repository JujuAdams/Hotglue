// Feather disable all

/// @param string

function __HotglueSplitHTMLResponse(_string)
{
    var _struct = {};
    
    var _splitArray = string_split(_string, "&");
    var _i = 0;
    repeat(array_length(_splitArray))
    {
        var _innerSplitArray = string_split(_splitArray[_i], "=", undefined, 1);
        _struct[$ _innerSplitArray[0]] = _innerSplitArray[1];
        ++_i;
    }
    
    return _struct;
}