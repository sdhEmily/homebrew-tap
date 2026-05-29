cask "playcover-community@nightly" do
  version "1501"
  sha256 "546c99cca0dba93d36bb33de9c1bb39027bdc485c0e5187f1e8173abeb75d754"

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
