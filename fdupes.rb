#!/usr/bin/env ruby
require "digest"

directory = Dir.pwd + "/" + ARGV[0]
file_list = Dir.entries(directory)

file_hashes = Hash.new()

for file in file_list
	if File.file?(file)
		file_hash = Digest::SHA256.file(file).hexdigest

		if file_hashes[file_hash] == nil
			file_hashes[file_hash] = [file]
		else
			file_hashes[file_hash].push(file)
		end
	end
end

duplicates = []

file_hashes.each_value do |value|
	if value.length > 1
		for file1 in value
			for file2 in value
				if file1 != file2 && File.size(file1) == File.size(file2) && IO.readlines(file1) == IO.readlines(file2)
					duplicates.push([file1, file2].sort)
				end
			end
		end
	end
end

duplicates = duplicates.uniq

puts duplicates[0] if duplicates.length > 0

for i in (1..duplicates.length-1)
	puts "\n"
	puts duplicates[i]
end