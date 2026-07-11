// Feather disable all

/// @param channelStruct
/// @param url
/// @param [forceType]

function HotglueEnsureRepositoryFromURL(_channelStruct, _url, _type = undefined)
{
    static _repositoryArray = __HotglueSystem().__repositoryArray;
    
    var _repository = HotglueGetRepositoryFromURL(_url);
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
            else if (__HotglueGuessURLIsVerdaccio(_url))
            {
                _type = HOTGLUE_REPOSITORY_VERDACCIO;
            }
            else
            {
                _type = HOTGLUE_REPOSITORY_LOCAL;
            }
        }
        
        if (_type == HOTGLUE_REPOSITORY_LOCAL)
        {
            _repository = new __HotglueRepositoryLocal(_channelStruct, _url);
        }
        else if (_type == HOTGLUE_REPOSITORY_GITHUB)
        {
            _repository = new __HotglueRepositoryGitHub(_channelStruct, _url);
        }
        else if (_type == HOTGLUE_REPOSITORY_GIST)
        {
            _repository = new __HotglueRepositoryGist(_channelStruct, _url);
        }
        else if (_type == HOTGLUE_REPOSITORY_ITCH)
        {
            _repository = new __HotglueRepositoryItch(_channelStruct, _url);
        }
        else if (_type == HOTGLUE_REPOSITORY_VERDACCIO)
        {
            _repository = new __HotglueRepositoryVerdaccio(_channelStruct, _url);
        }
        else
        {
            __HotglueError($"Repository type \"{_type}\" unhandled");
        }
        
        array_push(_repositoryArray, _repository);
    }
    
    return _repository;
}