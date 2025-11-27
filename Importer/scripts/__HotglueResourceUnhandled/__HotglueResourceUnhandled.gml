// Feather disable all

/// @param resourceStruct

function __HotglueResourceUnhandled(_resourceStruct) constructor
{
    static _system = __HotglueSystem();
    static type = "resource";
    static resourceType = "unhandled";
    static implemented = false;
    
    name = $"resource:{_resourceStruct.name}";
    data = _resourceStruct;
    
    static __VerifyFileUnzipped = function(_projectDirectory, _emptyBuffer)
    {
        //Do nothing
    }
    
    static __Copy = function(_sourceProjectDirectory, _destinationProjectDirectory)
    {
        //Do nothing
    }
    
    static __FixYYReferences = function(_project)
    {
        //Do nothing
    }
    
    static __InsertIntoYYP = function(_project)
    {
        //Do nothing
    }
}