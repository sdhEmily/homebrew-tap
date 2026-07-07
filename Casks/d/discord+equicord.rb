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

  preflight do
    settings_path = File.expand_path("~/Library/Application Support/discord/settings.json")
    system_command "/bin/chmod", args: ["644", settings_path] if File.exist?(settings_path)
    if File.exist?("/Applications/Discord.app/Contents/Resources/app.asar")
      system_command "/bin/chmod",
                     args: ["644", File.expand_path("/Applications/Discord.app/Contents/Resources/app.asar")]
    end
    if File.exist?("/Applications/Discord.app/Contents/Resources/_app.asar")
      system_command "/bin/chmod",
                     args: ["644", File.expand_path("/Applications/Discord.app/Contents/Resources/_app.asar")]

    end
  end

  postflight do
    # evil hack to bypass gatekeeper
    ohai "Circumventing Quarantine"
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "/Applications/Discord.app"]
    system_command "/usr/bin/open",
                   args: ["-gj", "-a", "/Applications/Discord.app"]
    system_command "/usr/bin/osascript",
                   args: ["-e", 'quit app "Discord"']
    ohai "Installing OpenAsar"
    system_command formula_opt_bin("equilotl-cli")/"equilotl",
                   args: ["-install-openasar", "-location", "/Applications/Discord.app"]
    ohai "Installing Equicord"
    system_command formula_opt_bin("equilotl-cli")/"equilotl",
                   args: ["-install", "-location", "/Applications/Discord.app"]
    ohai "Patching settings.json"
    system_command "/usr/bin/python3",
                   args: ["-c", <<~PYTHON]
                     import json, os
                     path = os.path.expanduser("~/Library/Application Support/discord/settings.json")
                     if os.path.exists(path):
                         with open(path) as f:
                             settings = json.load(f)
                     else:
                         os.makedirs(os.path.dirname(path), exist_ok=True)
                         settings = {
                             "DANGEROUS_ENABLE_DEVTOOLS_ONLY_ENABLE_IF_YOU_KNOW_WHAT_YOURE_DOING": True,
                             "BACKGROUND_COLOR": "#2c2d32",
                             "offloadAdmControls": True,
                             "DESKTOP_TTI_REMOVE_V8_CACHE_CLEAR": True,
                             "DESKTOP_TTI_DNSTCP_WARMUP": True,
                             "DESKTOP_TTI_UPDATE_BACKOFF_MAX_MS": 3000,
                             "chromiumSwitches": {},
                             "IS_MAXIMIZED": True,
                             "IS_MINIMIZED": False,
                         }

                     settings["USE_NEW_UPDATER"] = False
                     if "openasar" not in settings:
                         settings["openasar"] = {"setup": True}

                     with open(path, "w") as f:
                         json.dump(settings, f, indent=2)
                   PYTHON
    system_command "/bin/chmod",
                   args: ["444", File.expand_path("~/Library/Application Support/discord/settings.json")]
    ohai "Locking asar"
    system_command "/bin/chmod",
                   args: ["444", File.expand_path("/Applications/Discord.app/Contents/Resources/app.asar")]
    system_command "/bin/chmod",
                   args: ["444", File.expand_path("/Applications/Discord.app/Contents/Resources/_app.asar")]
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
