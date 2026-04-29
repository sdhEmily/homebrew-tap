cask "equilotl" do
  version "2.1.7"
  sha256 "d950c869699670a2c3ae8d0b867541b52270c64641dab2a6900334a567066437"

  url "https://github.com/Equicord/Equilotl/releases/download/v#{version}/Equilotl.MacOS.zip"
  name "Equilotl"
  desc "Cross platform gui app for installing Equicord"
  homepage "https://github.com/Equicord/Equilotl"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "Equilotl.app"

  zap trash: "~/Library/Application Support/Equicord"

  caveats do
    requires_rosetta
  end
end
