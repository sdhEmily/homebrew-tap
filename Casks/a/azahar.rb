cask "azahar" do
  arch arm: "arm64", intel: "x86_64"

  version "2126.1.2"
  sha256 arm:   "38a4515cd979d5293d66cac38197f14d69c311368f3a0fcb547fe5b658ef1ca7",
         intel: "4f0ec5ac57b7664cfdac52f49b5f2280872da7a40a1b4362a5f96900b15b84ea"

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
