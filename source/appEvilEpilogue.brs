Function CreateEpilogueList() as Object
	posteritems = []
	
	default_poster = "pkg:/images/large_epilogue.png"
		
	for each item in m.items
		title = str_sanitize( item.title.getText() )
		
		if ( instr(0, title, "Epilogue") > 0 ) then
			description = str_sanitize(item.description.getText())
						
			item = {		
				ShortDescriptionLine1:	title
				ShortDescriptionLine2:	description
				HDPosterUrl:		default_poster
				SDPosterUrl:		default_poster
				Artist:			""
				Title:			title    	
				feedurl:		item.enclosure@url
				streamformat:		"m4v"
				picture:		default_poster
			}
			
			posteritems.push( item )
		end if
	next
	
	return posteritems
End Function


Function DoEvilEpilogue(from as string) as Integer

	eps = createEpilogueList()
	selected_item = 0

	while true
		screen = uitkPreShowPosterMenu(from, "Evil Epilogue")
		selected_item = uitkDoPosterMenu(eps, screen, selected_item)
	
		if selected_item = -1 exit while
		
		ShowVideoScreen( eps[selected_item] )
	end while		


	'ps_port = CreateObject("roMessagePort")
	'poster_screen = CreateObject("roPosterScreen")
	'poster_screen.setMessagePort(ps_port)
	'
	'poster_screen.setListStyle("flat-episodic-16x9")
	'poster_screen.setListDisplayMode("best-fit")
	'poster_screen.setTitle("Evil Epilogue")
	'poster_screen.show()
	'
	'poster_screen.setContentList(createEpilogueList())
	'
	'while true
	'	msg = wait( 0, poster_screen.getMessagePort() )
	'	if msg.isScreenClosed() then return -1
	'end while
	
	'ShortDescriptionLine1
	'ShortDescriptionLine2
	
	
	'episode_list = CreateEpilogueList()
	'Pscreen = StartPosterScreen(episode_list, from, "Episodes")
	
	' Handle event message loop	    
	'while true
	'	song = Pscreen.GetSelection(0)
	'
	'	if song = -1 exit while
	'    
	'	ShowVideoScreen(episode_list.posteritems[song])
	'end while
End Function


Sub ShowVideoScreen(episode as Object)

	'print episode.feedurl
	port = CreateObject("roMessagePort")
	screen = CreateObject("roVideoScreen")

	? "============= "
	episode.stream = {
		url:		episode.feedurl
		bitrate: 	1500
		quality: 	false
		contentid:	episode.feedurl
		StreamQualities: ["SD", "HD"]
	}

	screen.SetContent(episode)
	screen.setMessagePort(port)
		
	screen.setPositionNotificationPeriod(30)	
	
	screen.show()
	
	while true
		msg = wait(0, port)
	    
		if type(msg) = "roVideoScreenEvent" then
			print "showHomeScreen | msg = "; msg.getMessage() " | index = "; msg.GetIndex()
			if msg.isScreenClosed()
			    print "Screen closed"
			    exit while
			elseif msg.isRequestFailed()
			    print "Video request failure: "; msg.GetIndex(); " " msg.GetData() 
			elseif msg.isStatusMessage()
			    print "Video status: "; msg.GetIndex(); " " msg.GetData() 
			elseif msg.isButtonPressed()
			    print "Button pressed: "; msg.GetIndex(); " " msg.GetData()
			elseif msg.isPlaybackPosition() then
			    'nowpos = msg.GetIndex()
			    'RegWrite(episode.stream.contentid, ""+nowpos)
			else
			    print "Unexpected event type: "; msg.GetType()
			end if
		else
		    print "Unexpected message class: "; type(msg)
		end if
end while
	

End Sub