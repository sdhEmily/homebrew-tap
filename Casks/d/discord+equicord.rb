cask "discord+equicord" do
  on_big_sur :or_older do
    version "0.0.402"
    sha256 "568293a1f65fab2244b5acdac282b88b6f00efd87defd76cc77185d1b9caba64"

    url "https://dl.discordapp.net/apps/osx/0.0.402/Discord.dmg"

    livecheck do
      skip "Legacy version"
    end
  end
  on_monterey :or_newer do
    version "0.0.422"
    sha256 "6fedd6856cbc48656704dfc718d52114e12ffae9ae904d429ae6e1ded2081fa2"

    url "https://stable.dl2.discordapp.net/distro/app/stable/osx/universal/#{version}/Discord.dmg"

    livecheck do
      url "https://updates.discord.com/distributions/app/manifests/latest?channel=stable&platform=osx&arch=x64"
      strategy :json do |json|
        json.dig("full", "host_version")&.join(".")
      end
    end
  end

  name "Discord + Equicord"
  desc "Voice and text chat software with Equicord and OpenAsar preinstalled"
  homepage "https://discord.com/"

  conflicts_with cask: "discord"
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
    /usr/bin/osascript -e 'quit app "Discord"'

    printf '==> Installing OpenAsar\\n'
    "$equilotl" -install-openasar -location "$target_app"

    printf '==> Installing Equicord\\n'
    "$equilotl" -install -location "$target_app"

    printf '==> Disabling Discord updater\\n'
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
  SH
  installer script: {
    executable: "install.sh",
    args:       [
      "#{staged_path}/Discord.app",
      "#{appdir}/Discord.app",
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
