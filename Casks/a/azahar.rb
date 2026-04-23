cask "azahar" do
  arch arm: "arm64", intel: "x86_64"

  version "2125.1.1"
  sha256 arm:   "b7fb5e06b10e95ca230ed2757d9f6df5d35208df4db4fe51046e1f1d3099f285",
         intel: "6841124361c2d0e95278a73ddbe8eaa5c7461ba14493f21daf830a7365dac487"

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
