cask "azahar" do
  arch arm: "arm64", intel: "x86_64"

  version "2125.1"
  sha256 arm:   "f79d66cb9eee4de13cd136e0afb988b6033402e7558e6764c0a802a59cc9a2a9",
         intel: "91959e5bde224ff93310c44fbf5c5e45b43f1f77003790ae207977310c962f03"

  url "https://github.com/azahar-emu/azahar/releases/download/#{version}/azahar-macos-#{arch}-#{version}.zip"
  name "Azahar"
  desc "Open source Nintendo 3DS emulator"
  homepage "https://github.com/azahar-emu/azahar"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :ventura"

  app "azahar-macos-#{arch}-#{version}/Azahar.app"

  zap trash: "~/Library/Application Support/Azahar"
end
