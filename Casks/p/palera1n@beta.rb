cask "palera1n@beta" do
  version "3.0.0-beta.2"
  sha256 "8cfb4c843317c09c43a3fe3edeb7f03e736ff436fff4f3fb4f587d9346168881"

  url "https://github.com/palera1n/palera1n/releases/download/v#{version}/palera1n-macos-universal.dmg"
  name "palera1n"
  desc "Jailbreak for A8 through A11 and T2 devices"
  homepage "https://palera.in/"

  livecheck do
    url :url
    regex(/^v(3\.\d+(?:\.\d+)*(?:-(?:alpha|beta|rc)(?:\.\d+)?)?)$/i)

    strategy :github_releases do |json, regex|
      json.filter_map do |release|
        next if release["draft"]

        match = release["tag_name"]&.match(regex)
        next if match.blank?

        match[1]
      end
    end
  end

  depends_on :macos

  app "palera1n.app"

  zap trash: "~/Library/Preferences/palera1n.plist"
end
