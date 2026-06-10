cask "equilotl" do
  arch arm: "arm64", intel: "x64"

  version "2.2.5"
  sha256 arm:   "4d22cf97031c60681b39d74a809806a1172f47a2a71b1bfe89497f1e6b738e9c",
         intel: "713ee358e86520b8b33a72dd5c4574de8bf0fa652706b4d55eb1f0302a823520"

  url "https://github.com/Equicord/Equilotl/releases/download/v#{version}/Equilotl-darwin-#{arch}.zip"
  name "Equilotl"
  desc "Cross platform gui app for installing Equicord"
  homepage "https://github.com/Equicord/Equilotl"

  livecheck do
    url :homepage
    strategy :github_latest
  end

  depends_on macos: :big_sur

  app "Equilotl.app"

  zap trash: "~/Library/Application Support/Equicord"
end
