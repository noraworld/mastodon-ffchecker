# Download the Mastodon library from https://github.com/tootsuite/mastodon-api
# and load it from lib to avoid a library specific bug
lib = File.expand_path '../../lib', __FILE__
$LOAD_PATH.unshift lib unless $LOAD_PATH.include? lib

require 'mastodon'
require 'dotenv'

Dotenv.load
client = Mastodon::REST::Client.new base_url: ENV['BASE_URL'], bearer_token: ENV['BEARER_TOKEN']
id = ENV['TARGET_ID']

followings = []
client.following(id).each do |f|
  followings.push f.id
end

not_followed_ids = []
client.relationships(followings).each do |f|
  unless f.followed_by?
    not_followed_ids.push f.id
  end
end

f = File.open('excluded_users.json')
s = f.read
f.close
excluded_users = JSON.parse(s)['users']

not_followed_accts = []

not_followed_ids.each do |nf|
  nf = client.account(nf)
  not_followed_accts.push nf.acct
end

not_followed_list = not_followed_accts - excluded_users
not_followed_list.each do |nf|
  puts nf
end
