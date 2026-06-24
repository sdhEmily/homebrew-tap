cask "cinny" do
  version "4.12.5"
  sha256 "4da936e6411d8318653baa56d7027ef5cc6debd997fb28651c00ef507e581410"

  url "https://github.com/cinnyapp/cinny-desktop/releases/download/v#{version}/Cinny_desktop-universal.dmg",
      verified: "github.com/cinnyapp/cinny-desktop/releases/download/"
  name "Cinny"
  desc "Yet another matrix client for desktop"
  homepage "https://cinny.in/"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on :macos

  app "Cinny.app"

  zap trash: [
    "~/Library/Application Support/in.cinny.app",
    "~/Library/Caches/in.cinny.app",
    "~/Library/WebKit/in.cinny.app",
  ]

  caveats do
    <<~EOS
      This app isn't notarized, so it might be blocked on first run.

      If you get an "App not opened" popup, go to:
        System Settings → Privacy & Security → Allow Anyway

      Or remove the quarantine flag:
        xattr -d com.apple.quarantine /Applications/Cinny.app
    EOS
  end
end
