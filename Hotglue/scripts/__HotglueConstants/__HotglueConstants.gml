// Feather disable all

// As per `https://docs.github.com/en/rest/releases/releases`
#macro HOTGLUE_MAX_GITHUB_RELEASES  100

#macro HOTGLUE_AUTH_CACHE_DIRECTORY     (game_save_id + "auth/")
#macro HOTGLUE_UNZIP_CACHE_DIRECTORY    (HotglueGetCachePath() + "unzip/")
#macro HOTGLUE_RELEASE_CACHE_DIRECTORY  (HotglueGetCachePath() + "releases/")
#macro HOTGLUE_TEMP_CACHE_DIRECTORY     (HotglueGetCachePath() + "temp/")

#macro HOTGLUE_GITHUB_AUTH_SCOPE  ""

#macro HOTGLUE_FAVORITES_CHANNEL  "@favorites"
#macro HOTGLUE_LOCALS_CHANNEL  "@locals"

#macro HOTGLUE_CHANNEL_JSON         "JSON"
#macro HOTGLUE_CHANNEL_DIRECTORY    "Directory"
#macro HOTGLUE_CHANNEL_GMK          "GameMaker Kitchen"
#macro HOTGLUE_CHANNEL_GITHUB_USER  "GitHub User"

#macro HOTGLUE_REPOSITORY_LOCAL   "local"
#macro HOTGLUE_REPOSITORY_GITHUB  "github"

#macro HOTGLUE_DEFAULT_PATH_CACHE        game_save_id + "cache/"
#macro HOTGLUE_DEFAULT_PATH_PROJECTTOOL  "C:/Program Files/GameMaker/packages/project-tool-win-x64/ProjectTool.exe"