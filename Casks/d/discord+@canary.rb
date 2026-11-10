cask "discord+@canary" do
  version "0.0.1428"
  sha256 "c6a38799e3d6ddd0f6dd8ffbc7e592f3ffc8d3ee0f1e0668131a9b328d0ce8fc"

  url "https://canary.dl2.discordapp.net/apps/osx/#{version}/DiscordCanary.zip"
  name "Discord+ Canary"
  desc "Voice and text chat software with Equicord and OpenAsar preinstalled"
  homepage "https://canary.discord.com/"

  livecheck do
    url "https://discord.com/api/updates/canary?platform=osx"
    strategy :json do |json|
      json["name"]
    end
  end

  conflicts_with cask: "discord@canary"
  depends_on formula: "equilotl-cli"
  depends_on macos: :ventura

  app "Discord Canary.app"
  generated_script "patch.sh", content: <<~SH
    #!/bin/sh
    set -e

    discord="$1"
    equilotl="$2"

    printf 'Disabling Host Updates\\n'
    /usr/bin/python3 -c '
    import json, os
    path = os.path.expanduser("~/Library/Application Support/discordcanary/settings.json")
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
    /usr/bin/osascript -e 'quit app "Discord Canary"'

    printf 'Installing OpenAsar\\n'
    "$equilotl" -install-openasar -location "$discord"

    printf 'Installing Equicord\\n'
    "$equilotl" -install -location "$discord"
  SH
  installer script: {
    executable: "patch.sh",
    args:       [
      "#{staged_path}/Discord Canary.app",
      (formula_opt_bin("equilotl-cli")/"equilotl").to_s,
    ],
  }

  uninstall launchctl: "com.discord.discord.ShipIt",
            quit:      "com.hnc.DiscordCanary"

  zap trash: [
    "~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/com.hnc.discordcanary.sfl*",
    "~/Library/Application Support/discordcanary",
    "~/Library/Caches/com.hnc.DiscordCanary",
    "~/Library/Caches/com.hnc.DiscordCanary.ShipIt",
    "~/Library/Cookies/com.hnc.DiscordCanary.binarycookies",
    "~/Library/Preferences/com.hnc.DiscordCanary.helper.plist",
    "~/Library/Preferences/com.hnc.DiscordCanary.plist",
    "~/Library/Saved Application State/com.hnc.DiscordCanary.savedState",
  ]
end
