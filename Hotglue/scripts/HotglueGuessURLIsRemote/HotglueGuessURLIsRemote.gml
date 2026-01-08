// Feather disable all

/// @param url

function HotglueGuessURLIsRemote(_url)
{
    _url = string_replace_all(_url, "\\", "/");
    
    var _isRemote = false;
    
    //Search for web protocols
    var _protocolArray = ["http://", "https://", "ftp://", "ftps://"];
    var _i = 0;
    repeat(array_length(_protocolArray))
    {
        var _substring = _protocolArray[_i];
        var _substringLength = string_length(_substring);
        
        if (string_copy(_url, 1, _substringLength) == _substring)
        {
            return true;
        }
        
        ++_i;
    }
    
    if (string_copy(_url, 2, 2) == ":/")
    {
        //Windows-style drive path
        return false;
    }
    else if (string_pos("www.", _url) == 1)
    {
        return true;
    }
    else
    {
        var _firstForeslash = string_pos("/", _url);
        if (_firstForeslash > 0)
        {
            //Search for common top-level domains
            var _domainNameArray = [".com/", ".org/", ".net/", ".co.uk/", ".io/"];
            var _i = 0;
            repeat(array_length(_domainNameArray))
            {
                var _pos = string_pos(_domainNameArray[_i], _url);
                if (_pos < _firstForeslash)
                {
                    return true;
                }
                    
                ++_i;
            }
        }
    }
    
    return false;
}