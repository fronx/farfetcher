#! /usr/bin/env ruby
require 'rubygems'
require 'git'

def fetch(rep)
  puts("#{rep}: git fetch origin")
  g = Git.open("/Users/francois/projects/#{rep}")
  g.remote('origin').fetch
end

while true do
  puts "- #{Time.now} -"
  %w(rep1 rep2).each { |rep| fetch(rep) }
  puts '.'
  sleep 30
end