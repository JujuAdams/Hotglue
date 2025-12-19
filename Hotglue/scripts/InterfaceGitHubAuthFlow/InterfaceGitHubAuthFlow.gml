// Feather disable all

/// @param [forceWeb=false]

function InterfaceGitHubAuthFlow(_forceWeb = false)
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
    },
    _forceWeb);
}