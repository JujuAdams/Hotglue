// Feather disable all

/// @param url
/// @param variant
/// @param [default=false]

function SourceGetRemote(_url, _variant, _default = false)
{
    var _source = SourceGet(_url, _variant);
    return (_source == undefined)? _default : _source.__remote;
}