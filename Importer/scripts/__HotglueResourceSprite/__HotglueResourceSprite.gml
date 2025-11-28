// Feather disable all

/// @param resourceStruct

function __HotglueResourceSprite(_resourceStruct) : __HotglueResourceCommon(_resourceStruct) constructor
{
    static resourceType = "sprite";
    static implemented  = true;
    
    static __CopySpecific = function(_destinationDirectory, _sourceDirectory)
    {
        var _resourceName = filename_change_ext(filename_name(data.path), "");
        var _copyArray = [ $"{_resourceName}.yy" ];
        
        var _sourcePath = _sourceDirectory + _copyArray[0];
        
        var _buffer = buffer_load(_sourcePath);
        var _yyString = buffer_read(_buffer, buffer_text);
        buffer_delete(_buffer);
        
        var _yyJson = json_parse(_yyString);
        var _frameArray = _yyJson.frames;
        var _layerArray = _yyJson.layers;
        
        var _i = 0;
        repeat(array_length(_frameArray))
        {
            var _frameName = _frameArray[_i].name;
            
            array_push(_copyArray, $"{_frameName}.png");
            
            var _j = 0;
            repeat(array_length(_layerArray))
            {
                array_push(_copyArray, $"layers/{_frameName}/{_layerArray[_i].name}.png");
                ++_j;
            }
            
            ++_i;
        }
        
        __HotglueCopyRelativePathArray(_destinationDirectory, _sourceDirectory, _copyArray);
    }
    
    static __GetExpandedAssetsSpecific = function(_project, _visitedArray, _visitedDict)
    {
        //Do nothing!
    }
}