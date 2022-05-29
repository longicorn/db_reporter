require "bundler/setup"
require "db_reporter"

namespace :db_reporter do
  namespace :generate do
    desc "generate markdown"
    task :markdown, ['output'] do |task, args|
      markdown = DbReporter::Document::Markdown.generate

      dirname = File.dirname(args['output'])
      FileUtils.mkdir_p(dirname)
      File.open(args['output'], 'w') do |f|
        f.write(markdown)
      end
    end
  end
end
