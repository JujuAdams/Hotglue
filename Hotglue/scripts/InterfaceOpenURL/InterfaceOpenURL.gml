// Feather disable all

/// @param url

function InterfaceOpenURL(_url)
{
    if (InterfaceGuessURLIsRemote(_url))
    {
        url_open(_url);
    }
    else
    {
        HotglueExecuteShell(filename_dir(_url), "");
    }
}