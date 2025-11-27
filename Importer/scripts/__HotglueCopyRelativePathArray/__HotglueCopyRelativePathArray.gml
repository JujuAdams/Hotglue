// Feather disable all

/// @param destinationDirectory
/// @param sourceDirectory
/// @param relativePathArray

function __HotglueCopyRelativePathArray(_destinationDirectory, _sourceDirectory, _relativePathArray)
{
    if (GM_is_sandboxed)
    {
        __HotglueError("Please disable sandboxing for this platform.");
    }
    
    var _i = 0;
    repeat(array_length(_relativePathArray))
    {
        var _relativePath = _relativePathArray[_i];
        file_copy(_sourceDirectory + _relativePath, _destinationDirectory + _relativePath);
        ++_i;
    }
}