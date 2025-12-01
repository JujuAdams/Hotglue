// Feather disable all

/// @param url
/// @param variant

function SourceInDictionary(_url, _variant)
{
    static _dictionary = __SourceCacheSystem().__dictionary;
    
    return struct_exists(_dictionary, $"{_url} :: {_variant}");
}