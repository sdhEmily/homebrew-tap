cask "rewindps4" do
  version "1.0.1"
  sha256 "d14acb3ec361875059720fc7f87ef6c312ab6376bb09969248b56cf4588c09c1"

  url "https://github.com/AuntAnt/RewindPS4_macOS/releases/download/#{version}/RewindPS4_macOS.app.zip"
  name "RewindPS4"
  desc "Proxy server to downgrade PS4 titles"
  homepage "https://github.com/AuntAnt/RewindPS4_macOS"

  livecheck do
    url :homepage
    strategy :github_latest
  end

  depends_on :macos

  app "RewindPS4.app"
  generated_script "rename.sh", content: <<~SH
    #!/bin/sh
    mv "$1/RewindPS4_macOS.app" "$1/RewindPS4.app"
  SH
  installer script: {
    executable: "rename.sh",
    args:       [
      staged_path.to_s,
    ],
  }

  zap trash: [
    "~/Library/Caches/com.ant.kzmn.RewindPS4-macOS",
    "~/Library/HTTPStorages/com.ant.kzmn.RewindPS4-macOS",
    "~/Library/Preferences/com.ant.kzmn.RewindPS4-macOS.plist",
  ]
end
