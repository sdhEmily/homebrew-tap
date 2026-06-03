cask "equilotl" do
  arch arm: "arm64", intel: "x64"

  version "2.2.4"
  sha256 arm:   "64d9f45d94831c86973005c726856e41ed8eb6e4cef7c468afeab3d8396853dd",
         intel: "3fcab0917f06537703b6955d267ceba3b45232ed89c3b626f820e4714a96b33c"

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
