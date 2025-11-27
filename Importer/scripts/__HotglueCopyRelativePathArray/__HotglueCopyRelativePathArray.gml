// Feather disable all

/// @param destinationDirectory
/// @param sourceDirectory
/// @param relativePathArray

function __HotglueCopyRelativePathArray(_destinationDirectory, _sourceDirectory, _relativePathArray)
{
    static _emptyBuffer = buffer_create(0, buffer_fixed, 1);
    
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
            buffer_save(_emptyBuffer, _sourceDirectory + _relativePath);
        }
        
        ++_i;
    }
}