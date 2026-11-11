cask "discord+@development" do
  version "1.0.1027"
  sha256 "24acb3c20c947dbb9a73bd29007919d1d05ab5586ccedc8873f3afa283646061"

  url "https://development.dl2.discordapp.net/apps/osx/#{version}/DiscordDevelopment.zip"
  name "Discord+ Development"
  desc "Voice and text chat software with Equicord and OpenAsar preinstalled"
  homepage "https://discord.com/"

  livecheck do
    url "https://discord.com/api/updates/development?platform=osx"
    strategy :json do |json|
      json["name"]
    end
  end

  conflicts_with cask: "discord@development"
  depends_on formula: "equilotl-cli"
  depends_on macos: :ventura

  app "Discord Development.app"
  generated_script "patch.sh", content: <<~SH
    #!/bin/sh
    set -e

    discord="$1"
    equilotl="$2"

    printf 'Disabling Host Updates\\n'
    /usr/bin/python3 -c '
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
    '

    printf 'Circumventing Quarantine\\n'
    /usr/bin/xattr -dr com.apple.quarantine "$discord"
    /usr/bin/open -gj -a "$discord"
    /usr/bin/osascript -e 'quit app "Discord Development"'

    printf 'Installing OpenAsar\\n'
    "$equilotl" -install-openasar -location "$discord"

    printf 'Installing Equicord\\n'
    "$equilotl" -install -location "$discord"
  SH
  installer script: {
    executable: "patch.sh",
    args:       [
      "#{staged_path}/Discord Development.app",
      (formula_opt_bin("equilotl-cli")/"equilotl").to_s,
    ],
  }

  uninstall launchctl: "com.discord.discord.ShipIt",
            quit:      "com.hnc.DiscordDevelopment"

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
