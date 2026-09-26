cask "equilotl" do
  version "2.3.0"
  sha256 "6ffd4f59bf8b5bf97f0419fe6a893555d9b4bb6e375df59bf1eb69cb5287dd0f"

  url "https://github.com/Equicord/Equilotl/releases/download/v#{version}/Equilotl.dmg"
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
