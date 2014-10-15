Function str_sanitize(inn as String) as String
	out = str_replace(inn, "&#8217;", "'")
	out = str_replace(out, "&#8242;", "'")
	out = str_replace(out, "&#8220;", chr(34))
	out = str_replace(out, "&#8221;", chr(34))
	out = str_replace(out, "&#8243;", chr(34))
	out = str_replace(out, "&#038;", "&")
	
	return out
End Function


Function str_replace(inn as String, old_text as String, new_text as String)
	reg = CreateObject("roRegex", old_text, "i")
	return reg.ReplaceAll(inn, new_text)
End Function