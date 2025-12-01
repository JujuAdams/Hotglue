// Feather disable all

/// @param url
/// @param variant
/// @param [default]

function SourceGetName(_url, _variant, _default = undefined)
{
    var _source = SourceGet(_url, _variant);
    return (_source == undefined)? _default : _source.__name;
}