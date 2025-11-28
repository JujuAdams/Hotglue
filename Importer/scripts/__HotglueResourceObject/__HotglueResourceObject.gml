// Feather disable all

/// @param resourceStruct

function __HotglueResourceObject(_resourceStruct) : __HotglueResourceCommon(_resourceStruct) constructor
{
    static resourceType = "object";
    static implemented  = true;
    
    static __CopySpecific = function(_destinationDirectory, _sourceDirectory)
    {
        // TODO - Pull in referenced assets too maybe?
        
        var _resourceName = filename_change_ext(filename_name(data.path), "");
        var _copyArray = [ $"{_resourceName}.yy" ];
        
        var _sourcePath = _sourceDirectory + _copyArray[0];
        
        var _buffer = buffer_load(_sourcePath);
        var _yyString = buffer_read(_buffer, buffer_text);
        buffer_delete(_buffer);
        
        var _yyJson = json_parse(_yyString);
        var _eventArray = _yyJson.eventList;
        
        var _i = 0;
        repeat(array_length(_eventArray))
        {
            var _eventData = _eventArray[_i];
            
            switch(_eventData.eventType)
            {
                case  0: var _eventName = "Create"; break;
                case  1: var _eventName = "Destroy"; break;
                case  2: var _eventName = "Alarm"; break;
                case  3: var _eventName = "Step"; break;
                case  4: var _eventName = "Collision"; break;
                case  5: var _eventName = "Keyboard"; break;
                case  6: var _eventName = "Mouse"; break;
                case  7: var _eventName = "Other"; break;
                case  8: var _eventName = "Draw"; break;
                case  9: var _eventName = "KeyPress"; break;
                case 10: var _eventName = "KeyRelease"; break;
                case 12: var _eventName = "CleanUp"; break;
                case 13: var _eventName = "Gesture"; break;
                
                default:
                    __HotglueError($"Unhandled eventType {_eventData.eventType}");
                break;
            }
            
            if (_eventData.eventType == 4)
            {
                //Special case for collisions
                
                var _collisionObjectID = _yyJson[$ "collisionObjectId"];
                if (_collisionObjectID == undefined)
                {
                    array_push(_copyArray, $"{data.name}_{_eventData.eventNum}.gml");
                }
                else
                {
                    array_push(_copyArray, $"{_collisionObjectID.name}_{_eventData.eventNum}.gml");
                }
            }
            else
            {
                array_push(_copyArray, $"{_eventName}_{_eventData.eventNum}.gml");
            }
            
            ++_i;
        }
        
        __HotglueCopyRelativePathArray(_destinationDirectory, _sourceDirectory, _copyArray);
    }
    
    static __GetExpandedAssetsSpecific = function(_project, _visitedArray, _visitedDict)
    {
        var _absolutePath = filename_dir(_project.__projectPath) + "/" + data.path;
        
        var _buffer = buffer_load(_absolutePath);
        var _string = buffer_read(_buffer, buffer_text);
        buffer_delete(_buffer);
        
        var _json = json_parse(_string);
        
        var _spriteData = _json.spriteId;
        if (is_struct(_spriteData))
        {
            var _spriteAssetName = $"resource:{_spriteData.name}";
            if (not variable_struct_exists(_visitedDict, _spriteAssetName))
            {
                array_push(_visitedArray, _spriteAssetName);
                _visitedDict[$ _spriteAssetName] = true;
            }
        }
        
        var _maskData = _json.spriteMaskId;
        if (is_struct(_maskData))
        {
            var _maskAssetName = $"resource:{_maskData.name}";
            if (not variable_struct_exists(_visitedDict, _maskAssetName))
            {
                array_push(_visitedArray, _maskAssetName);
                _visitedDict[$ _maskAssetName] = true;
            }
        }
        
        var _parentData = _json.parentObjectId;
        if (is_struct(_parentData))
        {
            var _parentAssetName = $"resource:{_parentData.name}";
            if (not variable_struct_exists(_visitedDict, _parentAssetName))
            {
                array_push(_visitedArray, _parentAssetName);
                _visitedDict[$ _parentAssetName] = true;
            }
        }
    }
}