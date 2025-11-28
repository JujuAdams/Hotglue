// Feather disable all

/// @param resourceStruct

function __HotglueResourceObject(_resourceStruct) : __HotglueResourceCommon(_resourceStruct) constructor
{
    static resourceType = "object";
    
    static __GetFiles = function(_project, _array = [])
    {
        var _localDirectory = filename_dir(data.path) + "/";
        
        array_push(_array, data.path);
        
        var _yyJson = __GetYYJSON(_project);
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
                    array_push(_array, $"{_localDirectory}{data.name}_{_eventData.eventNum}.gml");
                }
                else
                {
                    array_push(_array, $"{_localDirectory}{_collisionObjectID.name}_{_eventData.eventNum}.gml");
                }
            }
            else
            {
                array_push(_array, $"{_localDirectory}{_eventName}_{_eventData.eventNum}.gml");
            }
            
            ++_i;
        }
    }
    
    static __GetExpandedAssetsSpecific = function(_project, _visitedArray, _visitedDict)
    {
        var _json = __GetYYJSON(_project);
        __HotglueTryExpandingAssetID(_json.spriteId);
        __HotglueTryExpandingAssetID(_json.spriteMaskId);
        __HotglueTryExpandingAssetID(_json.parentObjectId);
    }
}