# frozen_string_literal: true

require "yard"

YARD::Rake::YardocTask.new do |t|
  t.files = ["lib/**/*.rb"] # optional
  # t.options = ['--markdown', '--extra', '--opts'] # optional
  # t.stats_options = ['--list-undoc']         # optional
end

task ghpages: :yard do
  require "fileutils"
  FileUtils.rm_rf "/tmp/doc"
  FileUtils.mv "doc", "/tmp"
  FileUtils.rm_rf "*"
  FileUtils.cp_r Dir.glob("/tmp/doc/*"), "."
  `git add .`
  `git commit -m "Pages"`
  `git push origin master:gh-pages --force`
  `git reset --hard HEAD~1`
end
