// Feather disable all

/// @param includedFileStruct

function __HotglueIncludedFile(_includedFileStruct) constructor
{
    static _system = __HotglueSystem();
    static type = "included file";
    static implemented = true;
    
    var _includedFileName = _includedFileStruct.filePath + "/" + _includedFileStruct.name;
    if (string_copy(_includedFileName, 1, 10) == "datafiles/")
    {
        _includedFileName = string_delete(_includedFileName, 1, 10);
    }
    
    name =  $"included:{_includedFileName}";
    data =  _includedFileStruct;
    
    static __VerifyFileUnzipped = function(_projectDirectory, _emptyBuffer)
    {
        var _path = _projectDirectory + data.filePath + "/" + data.name;
        if (not file_exists(_path))
        {
            __HotglueTrace($"Warning! Included file \"{_path}\" not found, creating an empty file in its place");
            buffer_save(_emptyBuffer, _path);
        }
    }
    
    static __Copy = function(_sourceProjectDirectory, _destinationProjectDirectory)
    {
        var _destinationPath = _destinationProjectDirectory + data.filePath + "/" + data.name;
        var _sourcePath = _sourceProjectDirectory + data.filePath + "/" + data.name;
        
        file_copy(_sourcePath, _destinationPath);
    }
    
    static __FixYYReferences = function(_project)
    {
        //Do nothing!
    }
    
    static __InsertIntoYYP = function(_project)
    {
        //TODO
    }
    
    static __GetExpandedAssets = function(_project, _visitedArray, _visitedDict)
    {
        //Do nothing!
    }
}