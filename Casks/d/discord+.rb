cask "discord+" do
  version "0.0.421"
  sha256 "85ac799972df5cc34978359ba720fb61024bd727b64db6c22bd705a1c555015d"

  url "https://stable.dl2.discordapp.net/distro/app/stable/osx/universal/#{version}/Discord.dmg"
  name "Discord+"
  desc "Voice and text chat software with Equicord and OpenAsar preinstalled"
  homepage "https://discord.com/"

  livecheck do
    url "https://updates.discord.com/distributions/app/manifests/latest?install_id=12345678-1234-4234-8234-123456789abc&channel=stable&platform=osx&arch=x64"
    strategy :json do |json|
      json.dig("full", "host_version")&.join(".")
    end
  end

  conflicts_with cask: "discord"
  depends_on formula: "equilotl-cli"
  depends_on macos: :ventura

  generated_script "install.sh", content: <<~SH
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

    #printf 'Installing OpenAsar\\n'
    #"$equilotl" -install-openasar -location "$discord"

    printf 'Installing Equicord\\n'
    "$equilotl" -install -location "$discord"
  SH
  installer script: {
    executable: "install.sh",
    args:       [
      "#{staged_path}/Discord.app",
      (formula_opt_bin("equilotl-cli")/"equilotl").to_s,
    ],
  }

  app "Discord.app"

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
