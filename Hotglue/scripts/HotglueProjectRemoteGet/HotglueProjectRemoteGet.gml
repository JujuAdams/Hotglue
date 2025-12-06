// Feather disable all

/// @param path

function HotglueProjectRemoteGet(_path)
{
    static _projectBySourceURLDict = __HotglueSystem().__projectBySourceURLDict;
    return _projectBySourceURLDict[$ _path];
}