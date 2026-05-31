// Feather disable all

/// @param url

function __HotglueGuessURLIsVerdaccio(_url)
{
    return (string_pos("/verdaccio/", _url) > 0);
}