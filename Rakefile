require 'rake/rdoctask'

# Make me some RDoc (use Allison, because it's pretty)
Rake::RDocTask.new do |rdoc|
	files = ['README.markdown', 'LICENSE', 'lib/*.rb', 'test/*.rb']
	rdoc.rdoc_files.add(files)
	rdoc.main = 'README.markdown'
	rdoc.title = 'SOAuth'
	#rdoc.template = ''
	rdoc.rdoc_dir = './doc'
	rdoc.options << '--line-numbers' << '--inline-source'
end