cask "equilotl" do
  version "2.1.8"
  sha256 "b745908593cc610c293fae2cf1a1d2306284d0e7fa5598681b5d60ce41552532"

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
