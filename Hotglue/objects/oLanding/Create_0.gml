// Feather disable all

HotglueSetTraceHandler(InterfaceTrace);
HotglueSetWarningHandler(InterfaceWarning);
HotglueClearUnzipCache();

//if (debug_mode)
//{
//    HotglueClearReleaseCache();
//}

//HotglueChannelRead("https://raw.githubusercontent.com/JujuAdams/Hotglue-Index/refs/heads/main/github.json",
//function(_channel, _success)
//{
//    var _linkArray = _channel.GetURLArray();
//    var _i = 0;
//    repeat(array_length(_linkArray))
//    {
//        HotglueGitHubRepositoryRead(_linkArray[_i],
//        function(_repository)
//        {
//            var _latestStable = _repository.GetLatestStable();
//            if (is_struct(_latestStable))
//            {
//                _latestStable.LoadProject(function(_project, _success)
//                {
//                    if (_success && is_struct(_project))
//                    {
//                        InterfaceStatus($"Loaded \"{_project.GetPath()}\"");
//                        execute_shell_simple(filename_dir(_project.GetPath()));
//                    }
//                });
//            }
//        });
//        
//        ++_i;
//    }
//});

//TODO - CLI

instance_destroy();
instance_create_depth(0, 0, 0, oInterface);

