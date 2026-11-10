cask "discord+@ptb" do
  version "0.0.269"
  sha256 "1ddf362f5a162ae7142af63f682162cdfaef7b4ccf5403cdc5bded5e00244ee9"

  url "https://ptb.dl2.discordapp.net/apps/osx/#{version}/DiscordPTB.zip"
  name "Discord+ PTB"
  desc "Voice and text chat software with Equicord and OpenAsar preinstalled"
  homepage "https://discord.com/"

  livecheck do
    url "https://discord.com/api/updates/ptb?platform=osx"
    strategy :json do |json|
      json["name"]
    end
  end

  conflicts_with cask: "discord@ptb"
  depends_on formula: "equilotl-cli"
  depends_on macos: :ventura

  app "Discord PTB.app"
  generated_script "patch.sh", content: <<~SH
    #!/bin/sh
    set -e

    discord="$1"
    equilotl="$2"

    printf 'Disabling Host Updates\\n'
    /usr/bin/python3 -c '
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
    '

    printf 'Circumventing Quarantine\\n'
    /usr/bin/xattr -dr com.apple.quarantine "$discord"
    /usr/bin/open -gj -a "$discord"
    /usr/bin/osascript -e 'quit app "Discord PTB"'

    printf 'Installing OpenAsar\\n'
    "$equilotl" -install-openasar -location "$discord"

    printf 'Installing Equicord\\n'
    "$equilotl" -install -location "$discord"
  SH
  installer script: {
    executable: "patch.sh",
    args:       [
      "#{staged_path}/Discord PTB.app",
      (formula_opt_bin("equilotl-cli")/"equilotl").to_s,
    ],
  }

  zap trash: [
    "~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/com.hnc.discordptb.sfl*",
    "~/Library/Application Support/com.hnc.DiscordPTB.ShipIt",
    "~/Library/Application Support/discordptb",
    "~/Library/Caches/com.hnc.DiscordPTB",
    "~/Library/Preferences/com.hnc.DiscordPTB.plist",
    "~/Library/Saved Application State/com.hnc.DiscordPTB.savedState",
  ]
end
