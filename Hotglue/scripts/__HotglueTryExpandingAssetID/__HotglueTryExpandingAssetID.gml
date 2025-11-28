// Feather disable all

function __HotglueTryExpandingAssetID(_assetID, _visitedArray, _visitedDict)
{
    if (is_struct(_assetID))
    {
        var _spriteAssetName = $"resource:{_assetID.name}";
        if (not variable_struct_exists(_visitedDict, _spriteAssetName))
        {
            array_push(_visitedArray, _spriteAssetName);
            _visitedDict[$ _spriteAssetName] = true;
        }
    }
}