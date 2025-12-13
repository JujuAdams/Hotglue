// Feather disable all

/// @param name
/// @param url

function __HotglueChannelFavorites(_name, _url) : __HotglueChannelLocal(_name, _url) constructor
{
    static __isFavorites = true;
    static __isRemote = false;
}