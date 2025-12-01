// Feather disable all

/// Returns if the source exists. This function can return `true`, `false`, or `undefined` so make
/// sure to handle all cases.
/// 
/// @param url
/// @param variant

function SourceExists(_url, _variant)
{
    static _dictionary = __SourceCacheSystem().__dictionary;
    
    var _source = SourceGet(_url, _variant);
    if (_source == undefined) return false;
    
    return _source.GetExists();
}