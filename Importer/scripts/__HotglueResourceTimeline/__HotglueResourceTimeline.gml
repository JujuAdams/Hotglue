// Feather disable all

/// @param resourceStruct

function __HotglueResourceTimeline(_resourceStruct) : __HotglueResourceCommon(_resourceStruct) constructor
{
    static resourceType = "timeline";
    
    static __CopySpecific = function(_destinationDirectory, _sourceDirectory)
    {
        var _resourceName = filename_change_ext(filename_name(data.path), "");
        var _copyArray = [ $"{_resourceName}.yy" ];
        
        var _sourcePath = _sourceDirectory + _copyArray[0];
        
        var _buffer = buffer_load(_sourcePath);
        var _yyString = buffer_read(_buffer, buffer_text);
        buffer_delete(_buffer);
        
        var _yyJson = json_parse(_yyString);
        var _momentArray = _yyJson.momentList;
        
        var _i = 0;
        repeat(array_length(_momentArray))
        {
            array_push(_copyArray, $"moment_{_momentArray[_i].moment}.gml");
            ++_i;
        }
        
        __HotglueCopyRelativePathArray(_destinationDirectory, _sourceDirectory, _copyArray);
    }
    
    static __GetExpandedAssetsSpecific = function(_project, _visitedArray, _visitedDict)
    {
        //Do nothing!
    }
}