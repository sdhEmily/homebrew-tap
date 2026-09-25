cask "discord@ptb+equicord" do
  version "0.0.259"
  sha256 "8714eb15d67ec28070bafc18f9f97f00914273e161ac52c7519da7f770f6a58d"

  url "https://dl-ptb.discordapp.net/apps/osx/#{version}/DiscordPTB.dmg"
  name "Discord PTB + Equicord"
  desc "Discord PTB with Equicord and OpenAsar preinstalled"
  homepage "https://discord.com/"

  livecheck do
    url "https://discord.com/api/download/ptb?platform=osx"
    strategy :header_match
  end

  conflicts_with cask: "discord@ptb"
  depends_on formula: "equilotl-cli"
  depends_on macos: :monterey

  generated_script "install.sh", content: <<~SH
    #!/bin/sh
    set -e

    source_app="$1"
    target_app="$2"
    equilotl="$3"

    /bin/rm -rf "$target_app"
    /usr/bin/ditto "$source_app" "$target_app"

    printf '==> Circumventing Quarantine\\n'
    /usr/bin/xattr -dr com.apple.quarantine "$target_app"

    /usr/bin/open -gj -a "$target_app"
    /usr/bin/osascript -e 'quit app "Discord PTB"'

    printf '==> Installing OpenAsar\\n'
    "$equilotl" -install-openasar -location "$target_app"

    printf '==> Installing Equicord\\n'
    "$equilotl" -install -location "$target_app"

    printf '==> Disabling Discord updater\\n'
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
  SH
  installer script: {
    executable: "install.sh",
    args:       [
      "#{staged_path}/Discord PTB.app",
      "#{appdir}/Discord PTB.app",
      (formula_opt_bin("equilotl-cli")/"equilotl").to_s,
    ],
  }

  uninstall quit:   "com.hnc.DiscordPTB",
            delete: "#{appdir}/Discord PTB.app"

  zap trash: [
    "~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/com.hnc.discordptb.sfl*",
    "~/Library/Application Support/com.hnc.DiscordPTB.ShipIt",
    "~/Library/Application Support/discordptb",
    "~/Library/Caches/com.hnc.DiscordPTB",
    "~/Library/Preferences/com.hnc.DiscordPTB.plist",
    "~/Library/Saved Application State/com.hnc.DiscordPTB.savedState",
  ]
end
