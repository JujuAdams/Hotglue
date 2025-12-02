// Feather disable all

function InterfaceGitHubAuthFlow()
{
    InterfaceStatus("Starting GitHub authorization flow. Please check your web browser.");
    HotglueGitHubWebAuthFlow(function(_success)
    {
        if (_success)
        {
            InterfaceStatus("GitHub access token acquired.");
        }
        else
        {
            InterfaceWarning("Failed to acquire GitHub access token.");
        }
    });
}