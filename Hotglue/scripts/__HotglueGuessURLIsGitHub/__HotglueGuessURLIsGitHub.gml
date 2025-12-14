// Feather disable all

/// @param url

function __HotglueGuessURLIsGitHub(_url)
{
    return (((string_pos("github.com/", _url) > 0) || (string_pos("githubusercontent.com/", _url) > 0)) && (string_pos("//gist.github.com", _url) <= 0));
}