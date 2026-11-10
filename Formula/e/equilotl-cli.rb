class EquilotlCli < Formula
  desc "Cross platform CLI app for installing Equicord"
  homepage "https://github.com/Equicord/Equilotl"

  url "https://github.com/Equicord/Equilotl/releases/download/v2.3.1/EquilotlCli-universal"
  sha256 "72451970bee9c25c6fbbde3becff85f0c5abef7550bae0d31f174ef2189a6e09"

  livecheck do
    url :stable
    strategy :github_latest
  end

  def install
    bin.install Dir["*"].first => "equilotl"
  end

  test do
    assert_predicate bin/"equilotl", :executable?
  end
end
