source 'https://rubygems.org'

ruby '3.0.3'
gem 'minitest'

gem 'mutant-minitest' # , '~> 0.8.24'
# Run this command to run mutant-minitest:
# bundle exec mutant run --include lib --require './gilded_rose.rb' --use minitest -- 'Inventory::BackstagePass'
# bundle exec mutant run --include lib --require './gilded_rose.rb' --use minitest -- 'Inventory::Quality'
# bundle exec mutant run --include lib --require './gilded_rose.rb' --use minitest -- 'Inventory*'

source 'https://oss:dOrNgEmlTycsVqJtCwfYpbP3fInu5Nu8@gem.mutant.dev' do
  gem 'mutant-license'
end

gem 'simplecov', require: false, group: :test # To see coverage report => [open coverage/index.html]
