// Feather disable all

/// @param url

function HotglueGetRepository(_url)
{
    static _repositoryArray = __HotglueSystem().__repositoryArray;
    
    var _i = 0;
    repeat(array_length(_repositoryArray))
    {
        if (_repositoryArray[_i].GetURL() == _url)
        {
            return _repositoryArray[_i];
        }
        
        ++_i;
    }
    
    return undefined;
}