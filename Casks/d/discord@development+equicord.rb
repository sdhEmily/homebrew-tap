cask "discord@development+equicord" do
  version "1.0.1021"
  sha256 "91b387c2e20013f3358f1cf192c94be6d9445f70cba36b82ab66a9cf2be7d718"

  url "https://dl-development.discordapp.net/apps/osx/#{version}/DiscordDevelopment.dmg"
  name "Discord Development + Equicord"
  desc "Discord Development with Equicord and OpenAsar preinstalled"
  homepage "https://discord.com/"

  livecheck do
    url "https://discord.com/api/download/development?platform=osx"
    strategy :header_match
  end

  conflicts_with cask: "discord@development"
  depends_on macos: :monterey
  depends_on formula: "equilotl-cli"

  app "Discord Development.app"

  postflight do
    # evil hack to bypass gatekeeper
    ohai "Circumventing Quarantine"
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "/Applications/Discord Development.app"]
    system_command "/usr/bin/open",
                   args: ["-gj", "-a", "/Applications/Discord Development.app"]
    system_command "/usr/bin/osascript",
                   args: ["-e", 'quit app "Discord Development"']
    ohai "Installing OpenAsar"
    system_command formula_opt_bin("equilotl-cli")/"equilotl",
                   args: ["-install-openasar", "-location", "/Applications/Discord Development.app"]
    ohai "Installing Equicord"
    system_command formula_opt_bin("equilotl-cli")/"equilotl",
                   args: ["-install", "-location", "/Applications/Discord Development.app"]
    ohai "Disabling Discord updater"
    system_command "/usr/bin/python3",
                   args: ["-c", <<~PYTHON]
                     import json, os
                     path = os.path.expanduser("~/Library/Application Support/discorddevelopment/settings.json")
                     if os.path.exists(path):
                         with open(path) as f:
                             settings = json.load(f)
                     else:
                         os.makedirs(os.path.dirname(path), exist_ok=True)
                         settings = {}

                     settings["SKIP_HOST_UPDATE"] = True

                     with open(path, "w") as f:
                         json.dump(settings, f, indent=2)
                   PYTHON
  end

  zap trash: [
    "~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/com.hnc.discorddevelopment.sfl*",
    "~/Library/Application Support/discorddevelopment",
    "~/Library/Caches/com.hnc.DiscordDevelopment",
    "~/Library/Caches/com.hnc.DiscordDevelopment.ShipIt",
    "~/Library/Cookies/com.hnc.DiscordDevelopment.binarycookies",
    "~/Library/Preferences/com.hnc.DiscordDevelopment.helper.plist",
    "~/Library/Preferences/com.hnc.DiscordDevelopment.plist",
    "~/Library/Saved Application State/com.hnc.DiscordDevelopment.savedState",
  ]
end
