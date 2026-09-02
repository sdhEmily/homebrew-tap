cask "discord@ptb+equicord" do
  version "0.0.257"
  sha256 "5172c10741fa66dab3dbf23d75031bedea5e986587514f4cd97388df8e5d1d85"

  url "https://dl-ptb.discordapp.net/apps/osx/#{version}/DiscordPTB.dmg"
  name "Discord PTB + Equicord"
  desc "Discord PTB with Equicord and OpenAsar preinstalled"
  homepage "https://discord.com/"

  livecheck do
    url "https://discord.com/api/download/ptb?platform=osx"
    strategy :header_match
  end

  conflicts_with cask: "discord@ptb"
  depends_on macos: :monterey
  depends_on formula: "equilotl-cli"

  app "Discord PTB.app"

  postflight do
    # evil hack to bypass gatekeeper
    ohai "Circumventing Quarantine"
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "/Applications/Discord PTB.app"]
    system_command "/usr/bin/open",
                   args: ["-gj", "-a", "/Applications/Discord PTB.app"]
    system_command "/usr/bin/osascript",
                   args: ["-e", 'quit app "Discord PTB"']
    ohai "Installing OpenAsar"
    system_command formula_opt_bin("equilotl-cli")/"equilotl",
                   args: ["-install-openasar", "-location", "/Applications/Discord PTB.app"]
    ohai "Installing Equicord"
    system_command formula_opt_bin("equilotl-cli")/"equilotl",
                   args: ["-install", "-location", "/Applications/Discord PTB.app"]
    ohai "Disabling Discord updater"
    system_command "/usr/bin/python3",
                   args: ["-c", <<~PYTHON]
                     import json, os
                     path = os.path.expanduser("~/Library/Application Support/discordptb/settings.json")
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
    "~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/com.hnc.discordptb.sfl*",
    "~/Library/Application Support/com.hnc.DiscordPTB.ShipIt",
    "~/Library/Application Support/discordptb",
    "~/Library/Caches/com.hnc.DiscordPTB",
    "~/Library/Preferences/com.hnc.DiscordPTB.plist",
    "~/Library/Saved Application State/com.hnc.DiscordPTB.savedState",
  ]
end
