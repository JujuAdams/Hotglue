// Feather disable all

function HotglueGitHubGetAccessTokenAvailable()
{
    static _system = __HotglueSystem();
    
    return (_system.__githubUserAccessToken != undefined);
}