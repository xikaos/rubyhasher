########### NEWBIE WARNING ##############
# This code was made with the purpose  #
# of me learning the language using    #
# some concepts I learned in college.  #
# So before you start blaming my shitty#
# code, consider I'm an APPRENTICE, A  #
# NOOB, A NEWBIE, A PADAWAN. NO SHAME  #
# ABOUT THIS.                          #
##################--X--#################

#Lovely dependencies
require 'find'
require 'digest'
require 'yaml'
require 'json'

#IMPORTANT: IF YOU WANT AN OUTPUT FILE IN JSON, COMMENT LINE 71 AND UNCOMMENT LINE 72.

#Hash containing the file basename and the associated Hash in hexadecimal 
@hash = {}

#This one I use to say to the getDirs method where to look for the files
puts 'Inform the directory containing the files you want to submit:'
	if File.directory?(usr_dir = gets.chomp)
		$main_dir = usr_dir
	else
		until  File.directory? usr_dir
		puts "#{usr_dir} doesnt seem to be a directory... Maybe you want to type it again:"
		usr_dir = gets.chomp
		end
		$main_dir = usr_dir
	end

puts 'Inform the name of the output file:'
	$file = gets.chomp
	if $file == nil || $file == ''
		$file='result.yaml'
	end

	#Helper method to get all directories and files within the 'dir' directory passed as a parameter
	#Return: Array
	def getDirs  dir
		Find.find(dir)	
	end

	#This one was designed to return the SHA256 hash as a string
	#Now we will use this method to do the file closing, cause we only need the file open to get the hash of it,
	#then we can close it!
	def getHash element
	file = File.new(element)
	hash = Digest::SHA256.file file
	file.close
	return hash.hexdigest 
	end

#It iterates through the 'dir' passed as parameter, verifies if the block argument is a directory and if it does
#skip to the next element. If it doesnt then it actually associate the file path with the respective SHA256 hash
#and merge the resulting hash(key,value) into the final structure
def processFile dir
	dir.each do |file|
		if File.directory?(file) then next;
			else 
				h = {File.basename(file) => getHash(file)}
				@hash.merge!(h)
		end
	end
	@hash
end

#Write to disk
IO.write($file,processFile(getDirs($main_dir)).to_yaml)
#IO.write($file,processFile(getDirs($main_dir)).to_json)