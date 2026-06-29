cask "discord+equicord" do
  on_catalina :or_older do
    version "0.0.336"
    sha256 "470fc7ad490d7ad42f01632af16dee69fbec6e3db7e3f79af4f2ee246e382398"

    livecheck do
      skip "Legacy version"
    end
  end
  on_big_sur :or_newer do
    version "0.0.397"
    sha256 "6f453b7078ebfa7aeb7d5b241e7e1ae009f14943f549c1b70e9329b89ba0f057"

    livecheck do
      url "https://discord.com/api/download/stable?platform=osx"
      strategy :header_match
    end
  end

  url "https://dl.discordapp.net/apps/osx/#{version}/Discord.dmg",
      verified: "dl.discordapp.net/"
  name "Discord + Equicord"
  desc "Discord with Equicord and OpenAsar preinstalled"
  homepage "https://discord.com/"

  conflicts_with cask: "discord"
  depends_on formula: "equilotl-cli"
  depends_on :macos

  app "Discord.app"

  postflight do
    # evil hack to bypass gatekeeper
    ohai "Circumventing Quarantine"
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "/Applications/Discord.app"]
    system_command "/usr/bin/open",
                   args: ["-gj", "-a", "/Applications/Discord.app"]
    system_command "/usr/bin/osascript",
                   args: ["-e", 'quit app "Discord"']
    ohai "Installing Equicord & OpenAsar"
    system_command formula_opt_bin("equilotl-cli")/"equilotl",
                   args: ["-install", "-install-openasar", "-location", "/Applications/Discord.app"]
  end

  uninstall quit: [
    "com.hnc.Discord",
    "com.hnc.Discord.helper.Plugin",
    "com.hnc.Discord.helper.Renderer",
  ]

  zap trash: [
    "~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/com.hnc.discord.sfl*",
    "~/Library/Application Support/discord",
    "~/Library/Application Support/Equicord",
    "~/Library/Application%20Support/discord",
    "~/Library/Caches/com.hnc.Discord",
    "~/Library/Caches/com.hnc.Discord.ShipIt",
    "~/Library/Cookies/com.hnc.Discord.binarycookies",
    "~/Library/HTTPStorages/com.hnc.Discord",
    "~/Library/HTTPStorages/com.hnc.Discord.binarycookies",
    "~/Library/Preferences/com.hnc.Discord.helper.plist",
    "~/Library/Preferences/com.hnc.Discord.plist",
    "~/Library/Saved Application State/com.hnc.Discord.savedState",
  ]
end
