/// @param gameMakerTime

function HotglueTimeGameMakerToDOSTime(_gameMakerTime)
{
    return (date_get_hour(_gameMakerTime) << 11) | (date_get_minute(_gameMakerTime) << 5) | (date_get_second(_gameMakerTime) div 2);
}