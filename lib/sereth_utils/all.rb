# Ensure the sereth namespace exists
module Sereth; end

raise LoadError, 'Ruquires Ruby 2' if !RUBY_VERSION.match(/^2/)
require 'rubygems'
require 'pry'
require 'andand'

# Use staging for all following code.
require_relative './alias_args'
require_relative './callbacks'