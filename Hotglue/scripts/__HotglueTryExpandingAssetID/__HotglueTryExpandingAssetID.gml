// Feather disable all

function __HotglueTryExpandingAssetID(_assetID, _visitedArray, _visitedDict)
{
    if (is_struct(_assetID))
    {
        var _assetPID = $"resource:{_assetID.name}";
        if (not variable_struct_exists(_visitedDict, _assetPID))
        {
            array_push(_visitedArray, _assetPID);
            _visitedDict[$ _assetPID] = true;
        }
    }
}