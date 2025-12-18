// Feather disable all

/// @param resourceStruct

function __HotglueResourceRoomUI(_resourceStruct) : __HotglueResourceCommon(_resourceStruct) constructor
{
    static resourceType = "ui layer";
    
    static __GetFiles = function(_project, _array = [])
    {
        array_push(_array, data.path);
        
        return _array;
    }
    
    static __GetExpandedAssetsSpecial = function(_project, _visitedArray, _visitedDict)
    {
        var _json = __GetYYJSON(_project);
        
        var _childrenArray = _json.children;
        var _i = 0;
        repeat(array_length(_childrenArray))
        {
            __GetExpandedAssetsRecursive(_childrenArray[_i], _visitedArray, _visitedDict);
            ++_i;
        }
        
        var _childrenArray = _json.viewspaceChildren;
        var _i = 0;
        repeat(array_length(_childrenArray))
        {
            __GetExpandedAssetsRecursive(_childrenArray[_i], _visitedArray, _visitedDict);
            ++_i;
        }
    }
    
    static __GetExpandedAssetsRecursive = function(_nodeData, _visitedArray, _visitedDict)
    {
        var _nodeType = _nodeData.resourceType;
        if (_nodeType == "GMRUILayer")
        {
            //UI layer folder
        }
        else if (_nodeType == "GMRFlexPanel")
        {
            //Flex panel
        }
        else if (_nodeType == "GMRInstance")
        {
            __HotglueTryExpandingAssetID(_nodeData.objectId, _visitedArray, _visitedDict);
            
            // TODO - Handle textures/sprites assigned to instance variable definitions
        }
        
        var _childrenArray = _nodeData[$ "children"];
        if (is_array(_childrenArray))
        {
            var _i = 0;
            repeat(array_length(_childrenArray))
            {
                __GetExpandedAssetsRecursive(_childrenArray[_i], _visitedArray, _visitedDict);
                ++_i;
            }
        }
    }
}