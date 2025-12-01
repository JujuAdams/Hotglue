// Feather disable all

/// @param url
/// @param variant
/// @param name
/// @param remote

function SourceEnsure(_url, _variant, _name, _remote)
{
    static _dictionary = __SourceCacheSystem().__dictionary;
    static _array      = __SourceCacheSystem().__array;
    
    var _key = $"{__url} :: {__variant}";
    var _source = _dictionary[$ _key];
    
    if (_source == undefined)
    {
        _source = new __ClassSource(_url, _variant, _name, _remote);
        
        _dictionary[$ _key] = _source;
        array_push(_array, _source);
    }
    
    return _source;
}