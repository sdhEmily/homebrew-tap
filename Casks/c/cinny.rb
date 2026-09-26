cask "cinny" do
  version "4.12.7"
  sha256 "2e1d8796248615ca127fa3f72b29d87c562f9b469253f17bad6b25ca38fca89b"

  url "https://github.com/cinnyapp/cinny-desktop/releases/download/v#{version}/Cinny_desktop-universal.dmg"
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
