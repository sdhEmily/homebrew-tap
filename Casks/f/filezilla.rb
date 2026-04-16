cask "filezilla" do
  arch arm: "arm64", intel: "x86_64"

  version "3.69.5"
  sha256 arm:   "db321dbd303da69e094d509942945531aae2f4736393792be92505bc35958956",
         intel: "f8ecd64e6b92b8a8f6761e1e690b2884c0ab67c2ba7d06194ad117cb0dc05f78"

  url "https://cdn.ftpclient-mirror.org/mac/#{arch}/FileZilla_#{version}_macos-#{arch}.app.tar.bz2",
      verified: "cdn.ftpclient-mirror.org/mac/"
  name "FileZilla"
  desc "Free FTP, FTPS and SFTP client"
  homepage "https://filezilla-project.org/"

  livecheck do
    url "https://cdn.ftpclient-mirror.org/latest.json"
    strategy :json do |json|
      json["version"]
    end
  end

  auto_updates true

  app "FileZilla.app"

  zap trash: [
    "~/.config/filezilla",
    "~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/de.filezilla.sfl*",
    "~/Library/Preferences/de.filezilla.plist",
    "~/Library/Saved Application State/de.filezilla.savedState",
  ]
end
