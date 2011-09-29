#!/usr/bin/env rake
require "bundler/gem_tasks"
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.pattern = "specs/**/*_spec.rb"
  t.verbose = true
  t.libs << "specs"
end

task default: :test
