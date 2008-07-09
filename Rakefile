require 'rake'
require 'hanna/rdoctask'
require 'spec/rake/spectask'
 
desc "Run all specs"
Spec::Rake::SpecTask.new(:spec) do |t|
   t.spec_files = FileList['spec/*.rb']
   t.spec_opts = ['--color']
end
 
desc "generate rdoc documentation"
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_files.include('README.rdoc', 'LICENSE', 'TODO').
    include('lib/**/*.rb')

  rdoc.main = "README.rdoc"
  rdoc.rdoc_dir = 'doc' # rdoc output folder
end

desc "run rspec + rcov"
Spec::Rake::SpecTask.new("spec:rcov") do |t|
  t.spec_files = FileList['spec/**/*_spec.rb']
  t.rcov_opts = ['--exclude', "spec/,rcov.rb,rspec.rb,spec*,gems*"]
  t.rcov = true
  t.rcov_dir = 'doc/coverage'
end
 
task :default => :spec