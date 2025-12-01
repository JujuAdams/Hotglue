// Feather disable all

/// @param url
/// @param variant

function SourceGet(_url, _variant)
{
    static _dictionary = __SourceCacheSystem().__dictionary;
    
    return _dictionary[$ $"{_url} :: {_variant}"];
}