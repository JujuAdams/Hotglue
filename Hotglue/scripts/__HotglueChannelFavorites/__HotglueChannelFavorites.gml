// Feather disable all

/// @param name
/// @param url
/// @param protected

function __HotglueChannelFavorites(_name, _url, _protected) : __HotglueChannelLocal(_name, _url, _protected) constructor
{
    static __isFavorites = true;
}