cask "spotify@1.2.45.454" do
  arch arm: "arm64", intel: "x86_64"

  version "1.2.45.454.gc16ec9f6"
  sha256 arm:   "e4a8de4c3433e77cfb4d8262ebc11c3b922fa9e8c9a13ecc85c5795a97f54342",
         intel: "e68916d9d641442ea37c8c3ebffffd27c4c0ba3ac5aecd65409e0ed2f8bb7c8b"

  url "https://loadspot.amd64fox1.workers.dev/download/spotify-autoupdate-#{version}-#{arch}.tbz"
  name "Spotify"
  desc "Music streaming service"
  homepage "https://www.spotify.com/"

  livecheck do
    skip
  end

  depends_on :macos

  app "Spotify.app"

  preflight_steps do
    mkdir_p "Spotify.app"
    move "Contents", "Spotify.app/Contents"
  end

  postflight_steps do
    mkdir_p "/Users/{{user}}/Library/Application Support/Spotify"
    mkdir_p "/Users/{{user}}/Library/Application Support/Spotify/PersistentCache"
    mkdir_p "/Users/{{user}}/Library/Application Support/Spotify/PersistentCache/Update"

    run "/usr/bin/chflags",
        args:           [
          "uchg",
          "/Users/{{user}}/Library/Application Support/Spotify/PersistentCache/Update",
        ],
        writable_paths: [
          "/Users/{{user}}/Library/Application Support/Spotify/PersistentCache",
        ]
  end

  uninstall_preflight_steps do
    if_path_exists "/Users/{{user}}/Library/Application Support/Spotify/PersistentCache/Update" do
      run "/usr/bin/chflags",
          args:           [
            "nouchg",
            "/Users/{{user}}/Library/Application Support/Spotify/PersistentCache/Update",
          ],
          writable_paths: [
            "/Users/{{user}}/Library/Application Support/Spotify/PersistentCache",
          ],
          must_succeed:   false
    end
  end

  uninstall launchctl: [
              "com.spotify.client.startuphelper",
              "com.spotify.webhelper",
            ],
            quit:      "com.spotify.client"

  zap trash: [
    "~/Library/Application Support/Spotify",
    "~/Library/Caches/com.spotify.client",
    "~/Library/Caches/com.spotify.client.helper",
    "~/Library/Cookies/com.spotify.client.binarycookies",
    "~/Library/HTTPStorages/com.spotify.client",
    "~/Library/Logs/Spotify",
    "~/Library/Preferences/com.spotify.client.helper.plist",
    "~/Library/Preferences/com.spotify.client.plist",
    "~/Library/Saved Application State/com.spotify.client.savedState",
  ]
end
