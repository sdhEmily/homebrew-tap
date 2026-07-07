cask "spotify@1.2.45.454" do
  arch arm: "arm64", intel: "x86_64"

  version "1.2.45.454.gc16ec9f6"
  sha256 arm:   "e4a8de4c3433e77cfb4d8262ebc11c3b922fa9e8c9a13ecc85c5795a97f54342",
         intel: "e68916d9d641442ea37c8c3ebffffd27c4c0ba3ac5aecd65409e0ed2f8bb7c8b"

  url "https://loadspot.amd64fox1.workers.dev/download/spotify-autoupdate-#{version}-#{arch}.tbz",
      verified: "loadspot.amd64fox1.workers.dev/"
  name "Spotify"
  desc "Music streaming service"
  homepage "https://www.spotify.com/"

  livecheck do
    skip
  end

  depends_on macos: :big_sur

  app "Spotify.app"

  preflight do
    app_dir = staged_path/"Spotify.app"
    app_dir.mkpath
    (staged_path/"Contents").rename(app_dir/"Contents")
  end

  postflight do
    ohai "Blocking Updates"
    update_dir = "#{Dir.home}/Library/Application Support/Spotify/PersistentCache/Update"
    system_command "/bin/mkdir", args: ["-p", update_dir]
    system_command "/usr/bin/chflags", args: ["uchg", update_dir]
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
