// Feather disable all

function __HotglueExpandFolder(_inPath, _visitedArray, _visitedDict)
{
    if (_inPath == "") return;
    
    var _assetName = $"folder:{_inPath}";
    
    if (not variable_struct_exists(_visitedDict, _assetName))
    {
        _visitedDict[$ _assetName] = true;
        array_push(_visitedArray, _assetName);
    }
    
    __HotglueExpandFolder(filename_dir(_inPath), _visitedArray, _visitedDict);
}