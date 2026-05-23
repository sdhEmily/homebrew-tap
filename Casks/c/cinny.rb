cask "cinny" do
  version "4.12.2"
  sha256 "8c2d665bbaef59bc4382198b50bd5b062d766d22bdd39aeac84e08094f83a275"

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
