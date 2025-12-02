// Feather disable all

/// @param url

function HotglueGetChannelExists(_url)
{
    return (HotglueGetChannelByURL(_url) != undefined);
}