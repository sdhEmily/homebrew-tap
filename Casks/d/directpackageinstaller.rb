cask "directpackageinstaller" do
  arch arm: "ARM64", intel: "X64"

  version "8.4.0"
  sha256 arm:   "0b9011dca9563f05cf37eb8643f2639951117aa109a519826b5fcfa1e432e0fd",
         intel: "e58d9609f4a3b164f91ec1f2eaf98382625418f9c1af4d58f7ce6b8d000dc02c"

  # current macos build is broken so we beta lol
  url "https://github.com/sdhEmily/DirectPackageInstaller/releases/download/beta/OSX-#{arch}-APP.zip"
  name "DirectPackageInstaller"
  desc "Send Direct PKG URLs to your PS4"
  homepage "https://github.com/marcussacana/DirectPackageInstaller"

  livecheck do
    skip
    # hopefully can fill when upstream is fixed
  end

  depends_on :macos

  app "DirectPackageInstaller.app"

  zap trash: "~/.config/DirectPackageInstaller/"
end
