cask "equilotl" do
  arch arm: "arm64", intel: "x64"

  version "2.4.1"
  sha256 arm:   "daccf5a9b1767f2cb8d206774ff02885085aabba7986835edd2c69ed35d07cc4",
         intel: "f639c655a76431640820136f1d73e47f7aa74ae54f5e0449c5ffc06d8fa0c212"

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
