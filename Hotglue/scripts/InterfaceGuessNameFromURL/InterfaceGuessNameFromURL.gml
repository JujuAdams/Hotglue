// Feather disable all

/// @param url

function InterfaceGuessNameFromURL(_url)
{
    var _urlLength = string_length(_url);
    if (string_char_at(_url, _urlLength) == "/")
    {
        _url = string_delete(_url, 1, _urlLength);
    }
    
    if (HotglueGuessURLIsRemote(_url))
    {
        var _pos = string_last_pos("/", _url);
        if (_pos <= 0) return _url;
        
        var _prevPos = string_last_pos_ext("/", _url, _pos);
        if (_pos <= 0) return _url;
        
        return string_copy(_url, _prevPos, _urlLength+1 - _prevPos);
    }
    else
    {
        return filename_name(_url);
    }
}