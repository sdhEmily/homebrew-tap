cask "equilotl" do
  arch arm: "arm64", intel: "x64"

  version "2.2.2"
  sha256 arm:   "334532e01c2c75337fa12cfcf0d3450c93b1347f2292e94804b7abe2a4993b88",
         intel: "c86224881c0fe1e4985d92dfb88c1b5b6da2d879ae7685d6938e82837cd74da0"

  url "https://github.com/Equicord/Equilotl/releases/download/v#{version}/Equilotl-darwin-#{arch}.zip"
  name "Equilotl"
  desc "Cross platform gui app for installing Equicord"
  homepage "https://github.com/Equicord/Equilotl"

  livecheck do
    url :homepage
    strategy :github_latest
  end

  depends_on macos: ">= :big_sur"

  app "Equilotl.app"

  zap trash: "~/Library/Application Support/Equicord"
end
