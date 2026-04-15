cask "devkitpro" do
  version "6.0.2"
  sha256 "da74156211cd3d8664ba7fb95544fbc0a2fbef1dd87b1a6bfafb30d2d446cd30"

  url "https://github.com/devkitPro/pacman/releases/download/v#{version}/devkitpro-pacman-installer.pkg"
  name "devkitPro"
  desc "Package manager for devkitPro Nintendo toolchains"
  homepage "https://github.com/devkitPro/pacman"

  livecheck do
    url :url
    strategy :github_latest
  end

  pkg "devkitpro-pacman-installer.pkg"

  uninstall launchctl: "devkit.env",
            pkgutil:   [
              "org.devkitpro.launchagent",
              "org.devkitpro.pacman-scripts",
              "org.devkitpro.pacman.arm64",
            ],
            delete:    [
              "/opt/devkitpro",
              "/private/etc/paths.d/devkitpro-tools",
              "/usr/local/bin/dkp-makepkg",
              "/usr/local/bin/dkp-md5sum",
              "/usr/local/bin/dkp-pacman",
              "/usr/local/bin/dkp-pacman-key",
              "/usr/local/bin/dkp-repo-add",
              "/usr/local/bin/dkp-repo-remove",
            ]

  caveats <<~EOS
    dkp-pacman requires sudo to be used.
  EOS
end
