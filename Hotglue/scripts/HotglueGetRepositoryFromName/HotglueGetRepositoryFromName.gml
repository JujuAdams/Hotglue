// Feather disable all

/// @param name

function HotglueGetRepositoryFromName(_name)
{
    static _repositoryArray = __HotglueSystem().__repositoryArray;
    
    var _i = 0;
    repeat(array_length(_repositoryArray))
    {
        if (_repositoryArray[_i].GetName() == _name)
        {
            return _repositoryArray[_i];
        }
        
        ++_i;
    }
    
    return undefined;
}