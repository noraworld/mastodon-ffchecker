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

followers = []
client.followers(id).each do |f|
  followers.push f.id
end

not_followed_ids = followings - followers

f = File.open('excluded_users.json')
s = f.read
f.close
excluded_users = JSON.parse(s)['users']

if not_followed_ids.empty?
  return
end

username = client.account(id).acct
not_followed_list = ""

not_followed_ids.each do |nf|
  nf = client.account(nf)
  not_followed_acct = nf.acct

  unless excluded_users.include? not_followed_acct
    if nf.display_name.empty?
      not_followed_list += "- " + nf.username + " (" + nf.acct + ")\n"
    else
      not_followed_list += "- " + nf.display_name + " (" + nf.acct + ")\n"
    end
  end
end

if not_followed_list.empty?
  return
end

if not_followed_ids.length === 1
  message = 'The following user is followed by you, but not following you.'
elsif not_followed_ids.length >= 2
  message = 'The following users are followed by you, but not following you.'
end

text = "@" + username + " " + message + "\n\n" + not_followed_list

client.create_status(text, nil, [], 'direct')
