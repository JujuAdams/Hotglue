// Feather disable all

function InterfaceGitHubAuthFlow()
{
    LogTraceAndStatus("Starting GitHub authorization flow. Please check your web browser.");
    HotglueGitHubWebAuthFlow(function(_success)
    {
        if (_success)
        {
            LogTraceAndStatus("GitHub access token acquired.");
        }
        else
        {
            LogWarning("Failed to acquire GitHub access token.");
        }
    });
}