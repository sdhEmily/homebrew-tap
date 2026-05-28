cask "equilotl" do
  arch arm: "arm64", intel: "x64"

  version "2.2.3"
  sha256 arm:   "62bfa4a1951cb8d6870817d3aed5036e24edfbb3404040098644c76b4b19aa76",
         intel: "61678eb51057565711e2f843a1642f155c94f54b8600c00c1be2f7abdd2b161f"

  url "https://github.com/Equicord/Equilotl/releases/download/v#{version}/Equilotl-darwin-#{arch}.zip"
  name "Equilotl"
  desc "Cross platform gui app for installing Equicord"
  homepage "https://github.com/Equicord/Equilotl"

  livecheck do
    url :homepage
    strategy :github_latest
  end

  depends_on macos: :big_sur

  app "Equilotl.app"

  zap trash: "~/Library/Application Support/Equicord"
end
