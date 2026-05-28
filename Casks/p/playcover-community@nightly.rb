cask "playcover-community@nightly" do
  version "1500"
  sha256 "aad0b8704a9f54883a4a33dd3b910760eaa84a301de3d740f46824ae1b033449"

  url "https://nightly.link/PlayCover/PlayCover/workflows/2.nightly_release/develop/PlayCover_nightly_#{version}.dmg.zip",
      verified: "nightly.link/PlayCover/PlayCover/workflows/2.nightly_release/"
  name "PlayCover"
  desc "Sideload iOS apps and games"
  homepage "https://github.com/PlayCover/PlayCover"

  livecheck do
    url "https://nightly.link/PlayCover/PlayCover/workflows/2.nightly_release/develop?preview"
    regex(/PlayCover_nightly_(\d+)\.dmg/i)
  end

  auto_updates true
  conflicts_with cask: ["playcover-community", "playcover-community@beta"]
  depends_on arch: :arm64
  depends_on macos: :monterey

  app "PlayCover.app"

  zap trash: [
    "~/Library/Application Support/io.playcover.PlayCover",
    "~/Library/Caches/io.playcover.PlayCover",
    "~/Library/Containers/io.playcover.PlayCover",
    "~/Library/Frameworks/PlayTools.framework",
    "~/Library/Preferences/io.playcover.PlayCover.plist",
    "~/Library/Saved Application State/io.playcover.PlayCover.savedState",
  ]
end
