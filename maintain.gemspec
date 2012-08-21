# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "maintain"
  s.version = "0.2.23"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Flip Sasser"]
  s.date = "2012-08-21"
  s.description = "\n      Maintain is a simple state machine mixin for Ruby objects. It supports comparisons, bitmasks,\n      and hooks that really work. It can be used for multiple attributes and will always do its best to\n      stay out of your way and let your code drive the machine, and not vice versa.\n    "
  s.email = "flip@x451.com"
  s.extra_rdoc_files = [
    "README.markdown"
  ]
  s.files = [
    ".rspec",
    "CHANGES",
    "README.markdown",
    "Rakefile",
    "VERSION",
    "autotest/discover.rb",
    "lib/maintain.rb",
    "lib/maintain/backend.rb",
    "lib/maintain/backend/active_record.rb",
    "lib/maintain/backend/base.rb",
    "lib/maintain/backend/data_mapper.rb",
    "lib/maintain/bitmask_value.rb",
    "lib/maintain/integer_value.rb",
    "lib/maintain/maintainer.rb",
    "lib/maintain/value.rb",
    "maintain.gemspec",
    "spec/active_record_spec.rb",
    "spec/aggregates_spec.rb",
    "spec/bitwise_spec.rb",
    "spec/class_methods_spec.rb",
    "spec/comparing_state_spec.rb",
    "spec/data_mapper_spec.rb",
    "spec/defining_states_spec.rb",
    "spec/hooks_spec.rb",
    "spec/integer_spec.rb",
    "spec/maintain_spec.rb",
    "spec/object_spec.rb",
    "spec/proxy_spec.rb",
    "spec/setting_state_spec.rb",
    "spec/spec.opts",
    "spec/spec_helper.rb",
    "spec/subclass_spec.rb"
  ]
  s.homepage = "http://github.com/flipsasser/maintain"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.24"
  s.summary = "A Ruby state machine that lets your code do the driving"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end

