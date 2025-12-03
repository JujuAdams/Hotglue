// Feather disable all

/// @param repository

function InterfaceEnsureRepositoryView(_repository)
{
    with(oInterface)
    {
        var _repositoryView = repositoryViewDict[$ ptr(_repository)];
        if (_repositoryView == undefined)
        {
            var _repositoryView = new ClassInterfaceRepositoryView(_repository);
            repositoryViewDict[$ ptr(_repository)] = _repositoryView;
        }
        
        return _repositoryView;
    }
    
    return undefined;
}