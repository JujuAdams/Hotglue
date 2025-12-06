// Feather disable all

/// @param path

function HotglueProjectLocalGet(_path)
{
    static _projectByPathDict = __HotglueSystem().__projectByPathDict;
    return _projectByPathDict[$ _path];
}