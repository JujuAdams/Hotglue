// Feather disable all

/// @param destinationDirectory
/// @param sourceDirectory
/// @param relativePathArray

function __HotglueCopyRelativePathArray(_destinationDirectory, _sourceDirectory, _relativePathArray)
{
    var _i = 0;
    repeat(array_length(_relativePathArray))
    {
        var _relativePath = _relativePathArray[_i];
        
        if (file_exists(_sourceDirectory + _relativePath))
        {
            file_copy(_sourceDirectory + _relativePath, _destinationDirectory + _relativePath);
        }
        else
        {
            __HotglueError($"Could not find \"{_sourceDirectory + _relativePath}\"");
        }
        
        ++_i;
    }
}