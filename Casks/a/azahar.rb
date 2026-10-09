cask "azahar" do
  arch arm: "arm64", intel: "x86_64"

  version "2126.2"
  sha256 arm:   "c24dec2bd5111b7d79513d686c5aece6612cdbf9737b2e6ea99cfc426f1d4aef",
         intel: "b3f87eca11ffcccf929c80abeea976f00917be81444d49f48d3dc7ceb3627947"

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
