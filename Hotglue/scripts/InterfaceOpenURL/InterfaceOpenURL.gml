// Feather disable all

/// @param url

function InterfaceOpenURL(_url)
{
    if (HotglueGuessURLIsRemote(_url))
    {
        url_open(_url);
    }
    else
    {
        HotglueExecuteShell(filename_dir(_url), "");
    }
}