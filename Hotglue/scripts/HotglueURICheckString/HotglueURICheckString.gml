// Feather disable all

/// @param string

function HotglueURICheckString(_string)
{
    return (string_copy(string(_string), 1, string_length("hotglue://")) == "hotglue://");
}