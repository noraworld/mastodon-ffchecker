# Mastodon FF-Checker

Copy sample files about environment and excluded users, and replace with your own information.

```sh
$ cp .env.sample .env
$ cp excluded_users.json.sample excluded_users.json
```

You have to clone the Mastodon API library from my forked repository because current original library has a bug.

```sh
$ git clone -b fix-array-param https://github.com/noraworld/mastodon-api
```

Then put `lib` under `mastodon-ffchecker`.

Enter the following command to run:

```sh
$ ruby src/main.rb
```
