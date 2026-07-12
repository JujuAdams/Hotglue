// Feather disable all

/// @param url

function HotglueGetChannelExistsByURL(_url)
{
    return (HotglueGetChannelByURL(_url) != undefined);
}