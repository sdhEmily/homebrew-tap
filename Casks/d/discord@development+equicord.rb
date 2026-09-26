cask "discord@development+equicord" do
  version "1.0.1023"
  sha256 "5714dd576ba3dd82bef3d6bc81f174e6bcf244bd45670e3e4c8a7a3f60aa1d58"

  url "https://dl-development.discordapp.net/apps/osx/#{version}/DiscordDevelopment.dmg"
  name "Discord Development + Equicord"
  desc "Discord Development with Equicord and OpenAsar preinstalled"
  homepage "https://discord.com/"

  livecheck do
    url "https://discord.com/api/download/development?platform=osx"
    strategy :header_match
  end

  conflicts_with cask: "discord@development"
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
    /usr/bin/osascript -e 'quit app "Discord Development"'

    printf '==> Installing OpenAsar\\n'
    "$equilotl" -install-openasar -location "$target_app"

    printf '==> Installing Equicord\\n'
    "$equilotl" -install -location "$target_app"

    printf '==> Disabling Discord updater\\n'
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
  SH
  installer script: {
    executable: "install.sh",
    args:       [
      "#{staged_path}/Discord Development.app",
      "#{appdir}/Discord Development.app",
      (formula_opt_bin("equilotl-cli")/"equilotl").to_s,
    ],
  }

  uninstall quit:   "com.hnc.DiscordDevelopment",
            delete: "#{appdir}/Discord Development.app"

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
