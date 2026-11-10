cask "discord+@canary" do
  version "0.0.1539"
  sha256 "b96360b3dea90a0f5b9febaf257839daf1da1d72b77fbbfb267d4092c534a9c7"

  url "https://canary.dl2.discordapp.net/distro/app/canary/osx/universal/#{version}/DiscordCanary.dmg"
  name "Discord+ Canary"
  desc "Voice and text chat software with Equicord and OpenAsar preinstalled"
  homepage "https://canary.discord.com/"

  livecheck do
    url "https://discord.com/api/download/canary?platform=osx"
    strategy :header_match
  end

  conflicts_with cask: "discord@canary"
  depends_on formula: "equilotl-cli"
  depends_on macos: :ventura

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
    /usr/bin/osascript -e 'quit app "Discord Canary"'

    printf '==> Installing OpenAsar\\n'
    "$equilotl" -install-openasar -location "$target_app"

    printf '==> Installing Equicord\\n'
    "$equilotl" -install -location "$target_app"

    printf '==> Disabling Discord updater\\n'
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
  SH
  installer script: {
    executable: "install.sh",
    args:       [
      "#{staged_path}/Discord Canary.app",
      "#{appdir}/Discord Canary.app",
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
