cask "playcover-community@nightly" do
  version "1531"
  sha256 "13f5f8a56b84a6b0d451131affd91cda5a754ca26aa7a05583d84d236d26bad9"

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
