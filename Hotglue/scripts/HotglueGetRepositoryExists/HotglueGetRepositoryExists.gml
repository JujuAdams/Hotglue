// Feather disable all

/// @param url

function HotglueGetRepositoryExists(_url)
{
    return (HotglueGetRepository(_url) != undefined);
}