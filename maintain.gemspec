# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{maintain}
  s.version = "0.1.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Flip Sasser"]
  s.date = %q{2010-04-23}
  s.description = %q{
      Maintain is a simple state machine mixin for Ruby objects. It supports comparisons, bitmasks,
      and hooks that really work. It can be used for multiple attributes and will always do its best to
      stay out of your way and let your code drive the machine, and not vice versa.
    }
  s.email = %q{flip@x451.com}
  s.extra_rdoc_files = [
    "README.markdown"
  ]
  s.files = [
     "README.markdown",
     "Rakefile",
     "VERSION",
     "lib/maintain.rb",
     "lib/maintain/bitmask_value.rb",
     "lib/maintain/integer_value.rb",
     "lib/maintain/maintainer.rb",
     "lib/maintain/value.rb",
     "spec/active_record_spec.rb",
     "spec/aggregates_spec.rb",
     "spec/bitwise_spec.rb",
     "spec/comparing_state_spec.rb",
     "spec/defining_states_spec.rb",
     "spec/hooks_spec.rb",
     "spec/integer_spec.rb",
     "spec/maintain_spec.rb",
     "spec/object_spec.rb",
     "spec/proxy_spec.rb",
     "spec/setting_state_spec.rb"
  ]
  s.homepage = %q{http://github.com/flipsasser/maintain}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{A Ruby state machine that lets your code do the driving}
  s.test_files = [
    "spec/active_record_spec.rb",
     "spec/aggregates_spec.rb",
     "spec/bitwise_spec.rb",
     "spec/comparing_state_spec.rb",
     "spec/defining_states_spec.rb",
     "spec/hooks_spec.rb",
     "spec/integer_spec.rb",
     "spec/maintain_spec.rb",
     "spec/object_spec.rb",
     "spec/proxy_spec.rb",
     "spec/setting_state_spec.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end

