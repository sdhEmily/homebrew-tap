cask "azahar" do
  arch arm: "arm64", intel: "x86_64"

  version "2127.0"
  sha256 arm:   "a9a8825a219d769b0fc4fd266c1c74658d0a1dfc269bcc8e759b9617eb9ded30",
         intel: "fed3959c083dac5477c1a7dac2059564d21fb7c64104e4624d7e5f9fab501676"

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
