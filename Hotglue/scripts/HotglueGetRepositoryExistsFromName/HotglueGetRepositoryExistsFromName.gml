// Feather disable all

/// @param name

function HotglueGetRepositoryExistsFromName(_name)
{
    return (HotglueGetRepositoryFromName(_name) != undefined);
}