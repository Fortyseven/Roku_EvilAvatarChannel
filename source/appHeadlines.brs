Sub doHeadlines(from as String)
	m.port = CreateObject("roMessagePort")
		
	changeHeadline(0)
	cur_headline = 0
	
	while true
		msg = wait(0, m.port)
		
		if msg.GetType() = 5 then
			if msg.getIndex() = 2
				cur_headline = cur_headline + 1
				if cur_headline >= m.newsitems.count() then cur_headline = 0
			end if
			if msg.getIndex() = 1
				cur_headline = cur_headline - 1
				if cur_headline < 0 then cur_headline = (m.newsitems.count() - 1)
			end if
			
			print "new page = ";cur_headline
			changeHeadline(cur_headline)
		end if
	end while
End Sub

Sub changeHeadline(item_num as Integer)
	m.screen = CreateObject("roParagraphScreen")
	m.screen.setMessagePort(m.port)
	
	item = m.newsitems[item_num]
	
	m.screen.setTitle("Headlines")
	m.screen.addHeaderText(item.title.getText())
	m.screen.addParagraph(item.description.getText())
	m.screen.addButton(2, "Next")
	m.screen.addButton(1, "Prev")
	m.screen.show()
End Sub