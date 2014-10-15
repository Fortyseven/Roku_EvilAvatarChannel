Sub Main()
	print "Entering Main"
	
	' Set up the basic color scheme
	SetTheme()
	
	' Create a list of audio programs to put in the selection screen
	Categories = CreateCategories()
	
	' Display the selection screen
	Pscreen = StartPosterScreen(Categories,"","Home")

	' Force displaying it so we're not showing the loading screen
	' on top of the Roku channels menu
	Pscreen.show()
	
	' Show loading screen while fetching RSS feed
	wait_screen = CreateObject("roOneLineDialog")
	wait_screen.setTitle("Fetching latest content...")
	wait_screen.showBusyAnimation()
	wait_screen.show()

	m.items = GetListFromFeed("http://shotgunpodcast.com/feed/")
	'm.newsitems = GetListFromFeed("http://www.evilavatar.com/forums/external.php?forumids=2")

	wait_screen.close()

	'hack
	'DoHeadlines("Hack")
	
	while true
	    Category = Pscreen.GetSelection(0)    ' returns a selection
	    if Category = -1 then
		return
	    endif
	    Categories.PosterItems[Category].Process("Home")
	end while
	
	print "Exiting Main"
End Sub

Function CreateCategories()	
	'aa = CreateObject("roAssociativeArray")
	
	aa = {
		PosterItems: [
			'{
			'	ShortDescriptionLine1:	"Latest Headlines"
			'	ShortDescriptionLine2:	""
			'	HDPosterUrl:		"pkg:/images/channel.png"
			'	SDPosterUrl:		"pkg:/images/channel.png"
			'	Process:		DoHeadlines
			'},
			{
				ShortDescriptionLine1:	"Shotgun Podcast"
				ShortDescriptionLine2:	"Updated Mondays - Call-in Line: (619) 573-6699"
				HDPosterUrl:		"pkg:/images/large_shotgun.png"
				SDPosterUrl:		"pkg:/images/large_shotgun.png"
				Process:		DoShotgunPodcast
			},
			{
				ShortDescriptionLine1:	"Evil Epilogue"
				ShortDescriptionLine2:	"The Gaming Week in Review"
				HDPosterUrl:		"pkg:/images/large_epilogue.png"
				SDPosterUrl:		"pkg:/images/large_epilogue.png"
				Process:		DoEvilEpilogue
			}
		]
	}
		
	return aa
End Function



Sub setTheme()
	app = CreateObject("roAppManager")

	theme = {
		OverhangOffsetSD_X:	"72",
		OverhangOffsetSD_Y:	"25",
		OverhangSliceSD:	"pkg:/images/Overhang_BackgroundSlice_Blue_SD43.png",
		OverhangLogoSD:		"pkg:/images/Logo_Overhang_Roku_SDK_SD43.png",
		
		'OverhangOffsetHD_X:	"123",
		'OverhangOffsetHD_Y:	"28",
		'OverhangSliceHD:	"pkg:/images/Overhang_BackgroundSlice_Blue_SD43.png",
		OverhangSliceHD:	"pkg:/images/new_overhang_hd.png"
		'OverhangLogoHD:		"pkg:/images/Logo_Overhang_Roku_SDK_HD.png",
		
		BackgroundColor:	"#000000",
		PosterScreenLine1Text:	"#FFFF00",
		ParagraphBodyrText:	"#FFFF00",
		
		SpringboardArtistLabel: "",
		SpringboardArtistColor: "#000000",
	}
	
	app.SetTheme(theme)
End Sub

REM ******************************************************
REM
REM Show audio screen
REM
REM Upon entering screen, should start playing first audio stream
REM
REM ******************************************************
Sub Show_Audio_Screen(song as Object, prevLoc as string)

	Audio = AudioInit()
	picture = song.HDPosterUrl
	
	print "picture at:"; picture
		
	o = {
	    HDPosterUrl:	picture,
	    SDPosterUrl:	picture,
	    Title:		song.shortdescriptionline1,
	    Description:	song.shortdescriptionline2,
	    contenttype:	"episode"
	}
	    
	if (song.artist > "")
		o.Description = o.Description + chr(10) + "by: " + song.artist
	endif
	    
	scr = create_springboard(Audio.port, prevLoc)
	scr.reloadButtons(0) 'set buttons for state "playing"
	scr.screen.SetTitle("Screen Title")
	
	scr.screen.SetContent(o)
	
	scr.Show()
	
	' start playing
	
	Audio.setupSong(song.feedurl, song.streamformat)
	Audio.audioplayer.setNext(0)
	Audio.setPlayState(0)		' start playing
	    
	while true
		msg = Audio.getMsgEvents(20000, "roSpringboardScreenEvent")
	
		if type(msg) = "roAudioPlayerEvent"  then	' event from audio player
			if msg.isStatusMessage() then
				message = msg.getMessage()
				print "AudioPlayer Status Event - " message
				if message = "end of playlist"
					print "end of playlist (obsolete status msg event)"
					' ignore
				else if message = "end of stream"
					print "done playing this song (obsolete status msg event)"
					'audio.setPlayState(0)	' stop the player, wait for user input
					'scr.ReloadButtons(0)    ' set button to allow play start
				endif
			else if msg.isListItemSelected() then
					print "starting song:"; msg.GetIndex()
			else if msg.isRequestSucceeded()
				print "ending song:"; msg.GetIndex()
				audio.setPlayState(0)	' stop the player, wait for user input
				scr.ReloadButtons(0)    ' set button to allow play start
			else if msg.isRequestFailed()
				print "failed to play song:"; msg.GetData()
			else if msg.isFullResult()
				print "FullResult: End of Playlist"
			else if msg.isPaused()
				print "Paused"
			else if msg.isResumed()
				print "Resumed"
			else
				print "ignored event type:"; msg.getType()
		endif
		else if type(msg) = "roSpringboardScreenEvent" then	' event from user
			if msg.isScreenClosed()
				print "Show_Audio_Screen: screen close - return"
				Audio.setPlayState(0)
				return
			endif
			
			if msg.isRemoteKeyPressed() then
				button = msg.GetIndex()
				print "Remote Key button = "; button
			else if msg.isButtonPressed() then
				button = msg.GetIndex()
				print "button index="; button
				if button = 1 'pause or resume
					if Audio.isPlayState < 2	' stopped or paused?
						if (Audio.isPlayState = 0)
						Audio.audioplayer.setNext(0)
					endif
					newstate = 2  ' now playing
				else 'started
					newstate = 1 ' now paused
				endif
			else if button = 2 ' stop
				newstate = 0 ' now stopped
			endif
			audio.setPlayState(newstate)
			scr.ReloadButtons(newstate)
			scr.Show()
			endif
		endif
	end while
End Sub
