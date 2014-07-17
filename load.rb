require 'pry'
require 'pry-byebug'
require 'date'
require 'json'

def raw_samples(file: raise)
  format  = 's7c2s16' 
  samples = []
  
  open(file, 'rb') do |file|
    while record = file.read(48)
      samples << record.unpack(format) 
    end
  end
  
  samples
end

def formatted_samples(file: raise("provide a filename"))
  raw_samples(file: file).map do |raw_sample|
    year  = raw_sample.shift # years from 1900 eg 114 == 2014
    hour  = raw_sample.shift # hour of year, ordinal time
    sec   = raw_sample.shift # second of hour
    msec  = raw_sample.shift # millisecond of second
    dtime = DateTime.strptime("#{year+1900}-#{hour/24}T#{hour%24}:#{sec/60}:#{sec%60}:#{msec}Z", '%Y-%jT%T:%LZ')
    {
      time:     dtime.to_time,
      mod16:    raw_sample.shift,
      mod60:    raw_sample.shift,
      fdsl:     raw_sample.shift,
      tele:     raw_sample.shift,
      craft:    raw_sample.shift,
      samples:  raw_sample
    }
  end
end

Dir["./data/*.DAT"].each do |file|
  puts formatted_samples(file: file)
end
