class Legacyioskit < Formula
  desc "All-in-one tool to restore/downgrade, save blobs & jailbreak legacy iOS devices"
  homepage "https://github.com/LukeZGD/Legacy-iOS-Kit"
  # dummy download lol
  url "https://raw.githubusercontent.com/LukeZGD/Legacy-iOS-Kit/03e0fdfb18f07cd3c0867a38ea05149208cfc551/.gitattributes",
      using: :nounzip
  version "latest"
  sha256 "1ca25e0ceec752dcf5d8acab4d587e692cf4880bc678acf81574016e10eaa9e7"
  license "GPL-3.0-only"

  livecheck do
    skip
  end

  def install
    system "git", "clone", "--filter=blob:none", "https://github.com/LukeZGD/Legacy-iOS-Kit", "kit"
    libexec.install Pathname("kit").children

    restore_sh = (libexec/"restore.sh").read
    sw_vers_str = Utils.safe_popen_read("sw_vers", "-productVersion").strip
    major, minor, = sw_vers_str.split(".").map(&:to_i)

    minver_block = restore_sh[/case \$mac_minver in(.*?)esac/m, 1]
    majver_block = restore_sh[/case \$mac_majver in(.*?)esac/m, 1]
    block, lookup_ver = (major == 10) ? [minver_block, minor] : [majver_block, major]
    mac_name = block[/^\s*#{lookup_ver}\s*\)\s*mac_name="([^"]+)"/, 1]
    odie "couldn't find a macOS codename for #{sw_vers_str} in restore.sh" unless mac_name

    mac_model = Utils.safe_popen_read("sysctl", "-n", "hw.model").strip
    platform_ver = "#{mac_model} - #{mac_name} #{sw_vers_str}"

    (libexec/"saved").mkpath
    (libexec/"saved/firstrun").write("#{platform_ver}\n")

    (bin/"legacyioskit").write <<~EOS
      #!/bin/bash
      cd "#{libexec}" || exit 1
      exec ./restore.sh "$@"
    EOS
    (bin/"legacyioskit").chmod 0755
  end

  def post_install
    Dir.chdir(libexec) do
      system "git", "reset", "--hard"
    end
  end
end
