class EquilotlCli < Formula
  desc "Cross platform CLI app for installing Equicord"
  homepage "https://github.com/Equicord/Equilotl"

  url "https://github.com/Equicord/Equilotl/releases/download/v2.3.0/EquilotlCli-universal"
  sha256 "b64c28a15d3a4774b4bd68e7a4d0703aa92331ea678199dbef497f6916f90ad5"

  livecheck do
    url :stable
    strategy :github_latest
  end

  def install
    bin.install Dir["*"].first => "equilotl"
  end
end
