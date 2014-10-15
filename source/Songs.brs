'**********************************************************
'**  Audio Player Example Application - Audio Playback
'**  November 2009
'**  Copyright (c) 2009 Roku Inc. All Rights Reserved.
'**********************************************************

REM ****************************************************************
REM Create a Song Item
REM return the Song as a Poster Item
REM ****************************************************************
Function CreateSong(title as string, description as string, artist as string, streamformat as string, feedurl as string, imagelocation as string) as Object
	return  {		
		ShortDescriptionLine1:	title
		ShortDescriptionLine2:	description
		HDPosterUrl:		imagelocation
		SDPosterUrl:		imagelocation
		Artist:			artist
		Title:			title    		' Song name
		feedurl:		feedurl
		streamformat:		streamformat
		picture:		imagelocation      ' default audioscreen picture to PosterScreen Image		
	}
End Function
