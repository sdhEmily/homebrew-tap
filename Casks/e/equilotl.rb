cask "equilotl" do
  version "2.1.5"
  sha256 "6b1dbad0c79e34e3f3f9ce18750da1a2f44460a14f5996535080ae76ba73e6a2"

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
