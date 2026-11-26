cask "equilotl" do
  arch arm: "arm64", intel: "x64"

  version "2.4.0"
  sha256 arm:   "e0f536823ad7f7b2c195ca1f28850426194550e6003d32ffbfcb524229f77cc3",
         intel: "432b02d61ce13d7c59573abbfa797c103a9fff730a9fd034aa7a7a7e18f1a9c7"

  url "https://github.com/Equicord/Equilotl/releases/download/v#{version}/Equilotl-#{arch}.dmg"
  name "Equilotl"
  desc "Cross platform GUI app for installing Equicord"
  homepage "https://github.com/Equicord/Equilotl"

  livecheck do
    url :homepage
    strategy :github_latest
  end

  depends_on :macos

  app "Equilotl.app"

  zap trash: "~/Library/Application Support/Equicord"
end
