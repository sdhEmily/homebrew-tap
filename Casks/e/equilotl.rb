cask "equilotl" do
  arch arm: "arm64", intel: "x64"

  version "2.2.6"
  sha256 arm:   "0ad89ae8e8bf652a6e61329c3ae12e97b0380ff3ca563ad258a10c84a47ef716",
         intel: "72ca0dbb2452299ed41b7517646a273e4b05c3f5e4e94df270b4e3fb2fc5fa75"

  url "https://github.com/Equicord/Equilotl/releases/download/v#{version}/Equilotl-darwin-#{arch}.zip"
  name "Equilotl"
  desc "Cross platform GUI app for installing Equicord"
  homepage "https://github.com/Equicord/Equilotl"

  livecheck do
    url :homepage
    strategy :github_latest
  end

  depends_on macos: :big_sur

  app "Equilotl.app"

  zap trash: "~/Library/Application Support/Equicord"
end
