// Feather disable all

/// @param url
/// @param [forceType]

function HotglueEnsureRepository(_url, _type = undefined)
{
    static _repositoryArray = __HotglueSystem().__repositoryArray;
    
    var _repository = HotglueGetRepository(_url);
    if (_repository == undefined)
    {
        if (_type == undefined)
        {
            if (__HotglueGuessURLIsGitHub(_url))
            {
                _type = HOTGLUE_REPOSITORY_GITHUB;
            }
            else if (__HotglueGuessURLIsGist(_url))
            {
                _type = HOTGLUE_REPOSITORY_GIST;
            }
            else if (__HotglueGuessURLIsItch(_url))
            {
                _type = HOTGLUE_REPOSITORY_ITCH;
            }
            else
            {
                _type = HOTGLUE_REPOSITORY_LOCAL;
            }
        }
        
        if (_type == HOTGLUE_REPOSITORY_LOCAL)
        {
            _repository = new __HotglueRepositoryLocal(_url);
        }
        else if (_type == HOTGLUE_REPOSITORY_GITHUB)
        {
            _repository = new __HotglueRepositoryGitHub(_url);
        }
        else if (_type == HOTGLUE_REPOSITORY_GIST)
        {
            _repository = new __HotglueRepositoryGist(_url);
        }
        else if (_type == HOTGLUE_REPOSITORY_ITCH)
        {
            _repository = new __HotglueRepositoryItch(_url);
        }
        else
        {
            __HotglueError($"Repository type \"{_type}\" unhandled");
        }
        
        array_push(_repositoryArray, _repository);
    }
    
    return _repository;
}