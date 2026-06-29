cask "azahar" do
  arch arm: "arm64", intel: "x86_64"

  version "2125.1.3"
  sha256 arm:   "bec0e28a4592b073ec285510935c24353bdae28bb443961d441ab768d66ffdac",
         intel: "9874f90982ea17cb12379c303fd63dd7cd169f64e3fdf8fb3852bae1b27d1f75"

  url "https://github.com/azahar-emu/azahar/releases/download/#{version}/azahar-macos-#{arch}-#{version}.zip"
  name "Azahar"
  desc "Open source Nintendo 3DS emulator"
  homepage "https://github.com/azahar-emu/azahar"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: :ventura

  app "azahar-macos-#{arch}-#{version}/Azahar.app"

  zap trash: "~/Library/Application Support/Azahar"
end
