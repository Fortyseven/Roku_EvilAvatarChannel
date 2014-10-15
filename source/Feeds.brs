Function GetListFromFeed(feed_url) As Object
	print "GetListFromFeed: ";feed_url
	
	http = CreateObject("roUrlTransfer")
	http.SetUrl(feed_url)	
	xml$ = http.GetToString()
		
	rss = CreateObject("roXMLElement")
	if not rss.Parse(xml$) then stop
	
	print "rss@version=";rss@version
		
	return rss.channel.item
End Function
