cask "equilotl" do
  arch arm: "arm64", intel: "x64"

  version "2.2.1"
  sha256 arm:   "0a835de73f192e32c1fb6bb35345360bb87724980a5f92ba84dc2ada720b4d3d",
         intel: "2d59a45aab018f21e2b41ba7406311c174cde22ce0ccb76691a210c07bb7f1ee"

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
