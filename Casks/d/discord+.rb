cask "discord+" do
  version "0.0.421"
  sha256 "b5b5ea949da9fa43ee235eae750e090c841f2ca58672002aa1277a0fb72f447d"

  url "https://stable.dl2.discordapp.net/apps/osx/#{version}/Discord.zip"
  name "Discord+"
  desc "Voice and text chat software with Equicord and OpenAsar preinstalled"
  homepage "https://discord.com/"

  livecheck do
    url "https://discord.com/api/updates/stable?platform=osx"
    strategy :json do |json|
      json["name"]
    end
  end

  conflicts_with cask: "discord"
  depends_on formula: "equilotl-cli"
  depends_on macos: :ventura

  app "Discord.app"
  generated_script "patch.sh", content: <<~SH
    #!/bin/sh
    set -e

    discord="$1"
    equilotl="$2"

    printf 'Disabling Host Updates\\n'
    /usr/bin/python3 -c '
    import json, os
    path = os.path.expanduser("~/Library/Application Support/discord/settings.json")
    if os.path.exists(path):
        with open(path) as f:
            settings = json.load(f)
    else:
        os.makedirs(os.path.dirname(path), exist_ok=True)
        settings = {}

    settings["SKIP_HOST_UPDATE"] = True

    with open(path, "w") as f:
        json.dump(settings, f, indent=2)
    '

    printf 'Circumventing Quarantine\\n'
    /usr/bin/xattr -dr com.apple.quarantine "$discord"
    /usr/bin/open -gj -a "$discord"
    /usr/bin/osascript -e 'quit app "Discord"'

    printf 'Installing OpenAsar\\n'
    "$equilotl" -install-openasar -location "$discord"

    printf 'Installing Equicord\\n'
    "$equilotl" -install -location "$discord"
  SH
  installer script: {
    executable: "patch.sh",
    args:       [
      "#{staged_path}/Discord.app",
      (formula_opt_bin("equilotl-cli")/"equilotl").to_s,
    ],
  }

  uninstall launchctl: "com.discord.discord.ShipIt",
            quit:      [
              "com.hnc.Discord",
              "com.hnc.Discord.helper.Plugin",
              "com.hnc.Discord.helper.Renderer",
            ]

  zap trash: [
    "~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/com.hnc.discord.sfl*",
    "~/Library/Application Support/discord",
    "~/Library/Application%20Support/discord",
    "~/Library/Caches/com.hnc.Discord",
    "~/Library/Caches/com.hnc.Discord.ShipIt",
    "~/Library/Cookies/com.hnc.Discord.binarycookies",
    "~/Library/HTTPStorages/com.hnc.Discord",
    "~/Library/HTTPStorages/com.hnc.Discord.binarycookies",
    "~/Library/Preferences/ByHost/com.discord.discord.ShipIt.*.plist",
    "~/Library/Preferences/com.hnc.Discord.helper.plist",
    "~/Library/Preferences/com.hnc.Discord.plist",
    "~/Library/Saved Application State/com.hnc.Discord.savedState",
  ]
end
