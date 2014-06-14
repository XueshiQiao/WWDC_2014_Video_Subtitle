#!/usr/bin/ruby

docPath = "."
#exclude . and .. folder
folders = Dir.entries(docPath).select{|folder| folder.to_i > 0}

folders.each{ |folder|
 	
	sequenceFilePath = docPath + "/" +  folder
	sequenceFiles = Dir.entries(sequenceFilePath).select{|file| file.length > 12}
	fileCount = sequenceFiles.count

	webvttFileHome = docPath + "/srts/"
	Dir.mkdir(webvttFileHome) unless File.exists?(webvttFileHome)

	webvttFile = webvttFileHome + folder + ".webvtt"
	f = File.new(webvttFile, "w") 
	#combine sequence files to xxx.srt, xxx is video num, such as 210.srt.
	
	# ls | xargs -t -I % -R 10 "awk -v RS="" '{gsub("\n", "-Z"); print}' % | awk '$0 !~/^WEB/ {print $0}' | uniq | awk '{printf "\n%s-Z%s", NR,$0 }'  | awk -v ORS="\n\n" '{gsub("-Z", "\n"); print}' >> {%}.srt
	for i in 0..fileCount-1
		out = File.open(sequenceFilePath + "/" + "fileSequence" + i.to_s + ".webvtt", "r");
		f.write(out.read);
		out.close;
	end	 

	#original: awk -v RS="" '{gsub("\n", "-Z"); print}' xxx | awk '$0 !~/^WEB/ {print $0}' | uniq | awk '{printf "\n%s-Z%s", NR,$0 }'  | awk -v ORS="\n\n" '{gsub("-Z", "\n"); print}' >> FILENAME_.srt
	translateToSrtCmd = "awk -v RS=\"\" '{gsub(\"\\n\", \"-Z\"); print}' " + webvttFile + " | awk '$0 !~/^WEB/ {print $0}' | uniq | awk '{printf \"\\n%s-Z%s\", NR,$0 }'  | awk -v ORS=\"\\n\\n\" '{gsub(\"-Z\", \"\\n\"); print}' >> " + webvttFileHome + folder + ".srt"
	
	#uncomment to debug
	#print translateToSrtCmd
	system(translateToSrtCmd)
	removeWebvttFileCmd = "rm " + webvttFile
	system(removeWebvttFileCmd)
	
	f.close

	print "Folder:" + folder + " finished \n" 
}