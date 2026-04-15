cask "jockey" do
  version "1.0.6"
  sha256 "af550c2b3d0e022f7370fbb6fb0c5ecd5001143284e4f003af609c9347ea5f93"

  url "https://github.com/othyn/macos-jockey/releases/download/v#{version}/Jockey.zip"
  name "Jockey"
  desc "Menu bar app that keeps your SMB network shares mounted"
  homepage "https://github.com/othyn/macos-jockey"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :sequoia"

  app "Jockey.app"

  zap trash: "~/Library/Preferences/com.othyn.jockey.plist"

  caveats do
    <<~EOS
      This app isn't notarized, so it might be blocked on first run.

      If you get an "App not opened" popup, go to:
        System Settings → Privacy & Security → Allow Anyway

      Or remove the quarantine flag:
        xattr -d com.apple.quarantine /Applications/Jockey.app
    EOS
  end
end
