cask "equilotl" do
  version "2.3.1"
  sha256 "569c259db152df8edb7533a16641b146bf8d82615bba4924e24734fffe811733"

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
