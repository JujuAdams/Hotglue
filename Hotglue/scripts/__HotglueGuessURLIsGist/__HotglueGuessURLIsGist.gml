// Feather disable all

/// @param url

function __HotglueGuessURLIsGist(_url)
{
    return (string_pos("gist.github.com/", _url) > 0);
}