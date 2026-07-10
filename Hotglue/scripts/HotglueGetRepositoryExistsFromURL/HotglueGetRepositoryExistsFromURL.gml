// Feather disable all

/// @param url

function HotglueGetRepositoryExistsFromURL(_url)
{
    return (HotglueGetRepositoryFromURL(_url) != undefined);
}