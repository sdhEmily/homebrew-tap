cask "equilotl" do
  arch arm: "arm64", intel: "x64"

  version "2.3.2"
  sha256 arm:   "2997000f8ddea3d2f1b37759b2f725c50a14580b7ee4357f307f82088c9e9e01",
         intel: "3872982be8406cd594aca8162f8e1033794506d6f42dc3bb4b80d8648ff6de6e"

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
