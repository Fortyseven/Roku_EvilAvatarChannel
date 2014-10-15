Function CreateShotgunEpisodeList() as Object
	aa = {
		posteritems:	[]
	}
	
	default_poster = "pkg:/images/large_shotgun.png"
		
	for each item in m.items
		title = str_sanitize( item.title.getText() )
		
		if ( instr(0, title, "Epilogue") = 0 ) then
			desc = str_sanitize(item.description.getText())
			regex = CreateObject("roRegEx")
			
			song = CreateSong( item.title.getText(), desc, "",  "mp3",  item.enclosure@url,  default_poster)
			aa.posteritems.push(song)
		end if
	next
	
	return aa
End Function


Sub DoShotgunPodcast(from as string)
    'Put up poster screen to pick an episode to play
    episode_list = CreateShotgunEpisodeList()
    Pscreen = StartPosterScreen(episode_list, from, "Shotgun")

    while true
        song = Pscreen.GetSelection(0)
        
	if song = -1 exit while
	
        Show_Audio_Screen(episode_list.posteritems[song], "Episodes")
    end while
End Sub