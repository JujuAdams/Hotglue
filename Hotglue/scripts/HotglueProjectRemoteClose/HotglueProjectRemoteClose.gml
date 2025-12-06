// Feather disable all

/// @param path

function HotglueProjectRemoteClose(_path)
{
    static _projectBySourceURLDict = __HotglueSystem().__projectBySourceURLDict;
    
    var _project = HotglueProjectRemoteGet(_sourceURL);
    if (_project != undefined)
    {
        _project.__DeleteGlobalReferences();
    }
}