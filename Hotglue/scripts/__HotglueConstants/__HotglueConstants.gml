// Feather disable all

// As per `https://docs.github.com/en/rest/releases/releases`
#macro HOTGLUE_MAX_GITHUB_RELEASES  100

#macro HOTGLUE_AUTH_CACHE_DIRECTORY     (game_save_id + "cache/auth/")
#macro HOTGLUE_UNZIP_CACHE_DIRECTORY    (game_save_id + "cache/unzip/")
#macro HOTGLUE_RELEASE_CACHE_DIRECTORY  (game_save_id + "cache/releases/")
#macro HOTGLUE_TEMP_CACHE_DIRECTORY     (game_save_id + "cache/temp/")

#macro HOTGLUE_GITHUB_AUTH_SCOPE  ""

#macro HOTGLUE_FAVORITES_CHANNEL  "@favorites"
#macro HOTGLUE_LOCALS_CHANNEL  "@locals"

#macro HOTGLUE_REPOSITORY_LOCAL   "local"
#macro HOTGLUE_REPOSITORY_GITHUB  "github"