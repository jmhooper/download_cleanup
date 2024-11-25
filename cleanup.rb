#!/usr/bin/env ruby

require 'fileutils'

downloads_dir = File.expand_path("~/Downloads")
Dir.foreach(downloads_dir) do |file|
  next if file == '.' || file == '..'
  FileUtils.rm_rf(File.join(downloads_dir, file))
end
