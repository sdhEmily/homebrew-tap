cask "playcover-community@nightly" do
  version "1675"
  sha256 "2723f2e4e1007543c85fa969dfd47dfe0c38e28bcf7fc61e454c59f6ab6b6782"

  url "https://nightly.link/PlayCover/PlayCover/workflows/2.nightly_release/develop/PlayCover_nightly_#{version}.dmg.zip"
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
