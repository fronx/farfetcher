#! /usr/bin/env ruby
require 'rubygems'
require 'git'

class String
  def red
    "\033[0;31m" + self + "\033[0m"
  end
end

class Fetcher
  attr_reader :path, :reps_remotes

  PAUSE = 15 # seconds

  def init
    config = YAML.load(File.read(File.dirname(__FILE__) + '/reps.yml'))
    @path = config.delete('path') || raise('no project path configured! (reps.yml)')
    @reps_remotes = __reps_remotes(config)
    self
  end

  def fetch_all
    puts "- #{Time.now} -"
    reps_remotes.each do |rep, remotes|
      puts "#{rep}:"
      remotes.each do |remote|
        begin
          fetch rep, remote
        rescue => e
          puts e.inspect.red
        end
      end
    end
    puts '.'
    sleep PAUSE
  end

  def fetch(rep, remote = 'origin')
    puts("  - #{remote}")
    g = Git.open("#{path}#{rep}")
    g.remote(remote).prune
    g.remote(remote).fetch
  end

private

  def __reps_remotes(config)
    if all = config.delete('all')
      config.keys.each do |key|
        config.merge!(key => (config[key] || []) + all)
      end
    end
    config
  end
end

f = Fetcher.new
f.init.fetch_all while true
