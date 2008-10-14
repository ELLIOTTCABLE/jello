# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{Jello}
  s.version = "4"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["elliottcable"]
  s.date = %q{2008-10-13}
  s.default_executable = %q{jello}
  s.description = %q{A library to watch the OS X pasteboard, and process/modify incoming pastes.}
  s.email = ["Jello@elliottcable.com"]
  s.executables = ["jello"]
  s.extra_rdoc_files = ["bin/jello", "lib/jello/core_ext/kernel.rb", "lib/jello/logger.rb", "lib/jello/mould.rb", "lib/jello/pasteboard.rb", "lib/jello.rb", "README.markdown"]
  s.files = ["bin/jello", "lib/jello/core_ext/kernel.rb", "lib/jello/logger.rb", "lib/jello/mould.rb", "lib/jello/pasteboard.rb", "lib/jello.rb", "moulds/fail.rb", "moulds/grabup_fixer.rb", "moulds/say.rb", "moulds/shortener.rb", "Rakefile.rb", "README.markdown", "spec/jello_spec.rb", ".manifest", "jello.gemspec"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/elliottcable/jello}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Jello", "--main", "README.markdown"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{jello}
  s.rubygems_version = %q{1.3.0}
  s.summary = %q{A library to watch the OS X pasteboard, and process/modify incoming pastes.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<elliottcable-echoe>, [">= 0", "= 3.0.2"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<rcov>, [">= 0"])
      s.add_development_dependency(%q<yard>, [">= 0"])
      s.add_development_dependency(%q<stringray>, [">= 0"])
    else
      s.add_dependency(%q<elliottcable-echoe>, [">= 0", "= 3.0.2"])
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<rcov>, [">= 0"])
      s.add_dependency(%q<yard>, [">= 0"])
      s.add_dependency(%q<stringray>, [">= 0"])
    end
  else
    s.add_dependency(%q<elliottcable-echoe>, [">= 0", "= 3.0.2"])
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<rcov>, [">= 0"])
    s.add_dependency(%q<yard>, [">= 0"])
    s.add_dependency(%q<stringray>, [">= 0"])
  end
end
