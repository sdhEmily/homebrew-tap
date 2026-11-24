cask "azahar" do
  arch arm: "arm64", intel: "x86_64"

  version "2127.0.1"
  sha256 arm:   "20bc20f5c71e2c10c55876a23e46b77a05af7f93665cddd68eb4d2b8cdc97482",
         intel: "dfcffc38877f2e80807d28fb169d0ebc7024d4bbb7283e80affaac571973d208"

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
