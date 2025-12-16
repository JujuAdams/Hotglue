// Feather disable all

/// @param sourceURL

function HotglueProjectRemoteGet(_sourceURL)
{
    static _projectBySourceURLDict = __HotglueSystem().__projectBySourceURLDict;
    return _projectBySourceURLDict[$ _sourceURL];
}