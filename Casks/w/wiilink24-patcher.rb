cask "wiilink24-patcher" do
  arch arm: "arm64", intel: "x64"

  version "1.5.1"
  sha256 arm:   "66989f9aa6d895c7ef95201dbee6ddc6f8375fee85bc892d6b7172201faa50f1",
         intel: "5526bc92ddc6891c601bc52d26dddde01eed99d9c68bc25dd31ba881cda8fb47"

  url "https://github.com/WiiLink24/WiiLink-Patcher-GUI/releases/download/v#{version}/WiiLinkPatcherGUI-macOS-#{arch}.tar.gz"
  name "WiiLink Patcher GUI"
  desc "GUI Utility to patch Wii applications for use with WiiLink"
  homepage "https://github.com/WiiLink24/WiiLink-Patcher-GUI"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :big_sur"

  app "WiiLinkPatcherGUI.app"
end
