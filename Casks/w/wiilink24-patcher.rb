cask "wiilink24-patcher" do
  arch arm: "arm64", intel: "x64"

  version "1.5.3"
  sha256 arm:   "d560a2e0bdef37764da6b957e8d811a73ee6b7bbf2fb237d5d3177ae9546558d",
         intel: "751f431f2b62b77e3ac9eb75220fb079007de7c57c082b76fa09344337fdedca"

  url "https://github.com/WiiLink24/WiiLink-Patcher-GUI/releases/download/v#{version}/WiiLinkPatcherGUI-macOS-#{arch}.tar.gz"
  name "WiiLink Patcher GUI"
  desc "GUI Utility to patch Wii applications for use with WiiLink"
  homepage "https://github.com/WiiLink24/WiiLink-Patcher-GUI"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :big_sur

  app "WiiLinkPatcherGUI.app"
end
