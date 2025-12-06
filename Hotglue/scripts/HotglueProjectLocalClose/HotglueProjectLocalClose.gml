// Feather disable all

/// @param path

function HotglueProjectLocalClose(_path)
{
    static _projectByPathDict = __HotglueSystem().__projectByPathDict;
    
    var _project = HotglueProjectLocalGet(_path);
    if (_project != undefined)
    {
        _project.__DeleteGlobalReferences();
    }
}