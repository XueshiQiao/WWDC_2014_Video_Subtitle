import requests
import os, re, sys
 
# "http://devstreaming.apple.com/videos/wwdc/2014/403xxksrj0qs8c0/403/403_hd_intermediate_swift.mov?dl=1">HD</a>

RE_SD_VIDEO = re.compile(
  r'<a href="(http://devstreaming.apple.com/videos/wwdc/2014/.*mov)\?dl=1">HD</a>')
RE_WEBVTT = re.compile(r'fileSequence[0-9]+\.webvtt')
 
# stdin: dump of https://developer.apple.com/wwdc/videos/
for l in sys.stdin:
	# print "==" + l
	m = RE_SD_VIDEO.search(l)
	if not m:
		# print "not found"
		continue

	video_url = m.group(1)
	print "downloading subtitle of video [" + video_url + "]"
	
	
	video_dir = video_url[:video_url.rindex('/')]
	session = video_dir[video_dir.rindex('/') + 1:]
	print video_dir + '/subtitles/eng/prog_index.m3u8'
	prog_index = requests.get(video_dir + '/subtitles/eng/prog_index.m3u8')
 
	# os.mkdir(session)

	if not os.access(session, os.F_OK):
		print "folder not exists, create it " + session
		os.mkdir(session)
	else:
		print "folder exists " + session

	webvtt_names = RE_WEBVTT.findall(prog_index.text)
	for webvtt_name in webvtt_names:
		webvtt_file_path = os.path.join(session, webvtt_name)
		if not os.access(webvtt_file_path, os.F_OK):
			print "file not exists, download it " + webvtt_file_path
			webvtt = requests.get(video_dir + '/subtitles/eng/' + webvtt_name)
			open(os.path.join(session, webvtt_name), 'w').write(webvtt.text)
		else:
			print "file exists, do nothing " + webvtt_file_path
