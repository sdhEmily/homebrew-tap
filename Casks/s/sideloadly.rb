cask "sideloadly" do
  version "0.71.0"
  sha256 :no_check

  url "https://sideloadly.io/SideloadlySetup.dmg"
  name "Sideloadly"
  desc "Sideload IPA files onto Apple devices"
  homepage "https://sideloadly.io/"

  livecheck do
    url :homepage
    regex(/What's new in v?(\d+(?:\.\d+)+)/i)
  end

  auto_updates true
  depends_on :macos

  app "Sideloadly.app"

  zap launchctl: "io.sideloadly.daemon",
      trash:     [
        "~/Library/Application Support/sideloadly",
        "~/Library/Caches/sideloadly",
        "~/Library/LaunchAgents/io.sideloadly.daemon.plist",
      ]
end
