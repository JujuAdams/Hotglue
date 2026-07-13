// Feather disable all

/// @param url

function __HotglueGuessURLIsVerdaccio(_url)
{
    if (string_pos("/verdaccio/", _url) > 0)
    {
        return true;
    }
    
    if (string_pos("/gmpm.", _url) > 0)
    {
        return true;
    }
    
    return false;
}