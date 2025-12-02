// Feather disable all

function HotglueGetGitHubAccessTokenAvailable()
{
    static _system = __HotglueSystem();
    
    return (_system.__githubUserAccessToken != undefined);
}