($:.unshift File.expand_path(File.join( File.dirname(__FILE__), 'lib' ))).uniq!
require 'jello'

require 'fileutils'

# =======================
# = Gem packaging tasks =
# =======================
begin
  require 'echoe'

  task :package => :'package:package'
  task :install => :'package:install'
  task :manifest => :'package:manifest'
  namespace :package do
    Echoe.new('jello', Jello::Version) do |g|
      g.project = 'jello'
      g.author = ['elliottcable']
      g.email = ['Jello@elliottcable.com']
      g.summary = 'A library to watch the OS X pasteboard, and process/modify incoming pastes.'
      g.url = 'http://github.com/elliottcable/jello'
      g.development_dependencies = ['echoe >= 3.0.2', 'rspec', 'rcov', 'yard', 'stringray']
      g.manifest_name = '.manifest'
      g.retain_gemspec = true
      g.rakefile_name = 'Rakefile.rb'
      g.ignore_pattern = /^\.git\/|^meta\/|\.gemspec/
    end

    desc 'tests packaged files to ensure they are all present'
    task :verify => :package do
      # An error message will be displayed if files are missing
      if system %(ruby -e "require 'rubygems'; require 'pkg/jello-#{Jello::Version}/lib/jello'")
        puts "\nThe library files are present"
      end
    end
  end

rescue LoadError
  desc 'You need the `echoe` gem to package Jello'
  task :package
end

begin
  require 'launchdr/task'

  LaunchDr::Task.new :launchd, :bin => 'jello', :arguments => ['grabup', 'shortener']
rescue LoadError
  desc 'You need the `elliottcable-launchdr` gem to generate a launchd property list'
  task :launchd
end

# =======================
# = Spec/Coverage tasks =
# =======================
begin
  require 'spec'
  require 'rcov'
  require 'spec/rake/spectask'

  task :default => :'coverage:run'
  task :coverage => :'coverage:run'
  namespace :coverage do
    Spec::Rake::SpecTask.new(:run) do |t|
      t.spec_opts = ["--format", "specdoc"]
      t.spec_opts << "--colour" unless ENV['CI']
      t.spec_files = Dir['spec/**/*_spec.rb'].sort
      t.libs = ['lib']
      t.rcov = true
      t.rcov_opts = [ '--include-file', '"^lib"', '--exclude-only', '".*"']
      t.rcov_dir = File.join('meta', 'coverage')
    end

    begin
      require 'spec/rake/verify_rcov'
      # For the moment, this is the only way I know of to fix RCov. I may
      # release the fix as it's own gem at some point in the near future.
      require 'stringray/core_ext/spec/rake/verify_rcov'
      RCov::VerifyTask.new(:verify) do |t|
        t.threshold = 50.0
        t.index_html = File.join('meta', 'coverage', 'index.html')
        t.require_exact_threshold = false
      end
    rescue LoadError
      desc 'You need the `stringray` gem to verify coverage'
      task :verify
    end

    task :open do
      system 'open ' + File.join('meta', 'coverage', 'index.html') if PLATFORM['darwin']
    end
  end

rescue LoadError
  desc 'You need the `rcov` and `rspec` gems to run specs/coverage'
  task :coverage
end

# =======================
# = Documentation tasks =
# =======================
begin
  require 'yard'
  require 'yard/rake/yardoc_task'

  task :documentation => :'documentation:generate'
  namespace :documentation do
    YARD::Rake::YardocTask.new :generate do |t|
      t.files   = ['lib/**/*.rb']
      t.options = ['--output-dir', File.join('meta', 'documentation'),
                   '--readme', 'README.markdown']
    end

    YARD::Rake::YardocTask.new :dotyardoc do |t|
      t.files   = ['lib/**/*.rb']
      t.options = ['--no-output',
                   '--readme', 'README.markdown']
    end

    task :open do
      system 'open ' + File.join('meta', 'documentation', 'index.html') if PLATFORM['darwin']
    end
  end

rescue LoadError
  desc 'You need the `yard` gem to generate documentation'
  task :documentation
end

# =========
# = Other =
# =========
desc 'Removes all meta producs'
task :clobber do
  `rm -rf #{File.expand_path(File.join( File.dirname(__FILE__), 'meta' ))}`
end

desc 'Check everything over before commiting'
task :aok => [:'documentation:generate', :'documentation:open',
              :'package:manifest', :'package:package',
              :'coverage:run', :'coverage:verify', :'coverage:open']

task :ci => [:'documentation:generate', :'coverage:run', :'coverage:verify']
