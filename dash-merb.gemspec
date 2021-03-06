# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{dash-merb}
  s.version = "0.8.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["FiveRuns Development Team"]
  s.date = %q{2009-03-20}
  s.description = %q{Provides an API to send metrics from Merb 1.0+ applications to the FiveRuns Dash service}
  s.email = %q{dev@fiveruns.com}
  s.extra_rdoc_files = ["README.rdoc"]
  s.files = ["README.rdoc", "VERSION.yml", "lib/fiveruns", "lib/fiveruns/dash", "lib/fiveruns/dash/merb", "lib/fiveruns/dash/merb/recipe.rb", "lib/fiveruns/dash/merb.rb", "lib/fiveruns-dash-merb.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/fiveruns/dash-merb}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{FiveRuns Dash library for Merb}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<fiveruns-dash-ruby>, [">= 0.8.0"])
      s.add_runtime_dependency(%q<merb-core>, [">= 1.0.0"])
    else
      s.add_dependency(%q<fiveruns-dash-ruby>, [">= 0.8.0"])
      s.add_dependency(%q<merb-core>, [">= 1.0.0"])
    end
  else
    s.add_dependency(%q<fiveruns-dash-ruby>, [">= 0.8.0"])
    s.add_dependency(%q<merb-core>, [">= 1.0.0"])
  end
end
