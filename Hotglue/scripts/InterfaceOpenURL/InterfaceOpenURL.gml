// Feather disable all

/// @param url

function InterfaceOpenURL(_url)
{
    if (InterfaceGuessURLIsRemote(_url))
    {
        url_open(_url);
    }
    else if (HotglueGetExecuteShellAvailable())
    {
        execute_shell_simple(filename_dir(_url));
    }
}