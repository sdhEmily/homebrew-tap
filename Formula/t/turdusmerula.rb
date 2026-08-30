class Turdusmerula < Formula
  desc "Tethered/untethered iDevice downgrade utility"
  homepage "https://sep.lol/"
  url "https://sep.lol/files/releases/v1.3r3/721382e5b616c761ecf15ae315aa812def9fc9d6c91d05d75d0322f4606fd8d4cfff8144d33a7e7e703b50096a7c411a/turdus_m3rula_v1.3_1fc7203b_macosx.tar.gz"
  version "1.3r3"
  sha256 "21acd38b6213c2f25f3fe6fb5b46047e1f9a7fdc67b641cb11c425b64113a7bd"

  livecheck do
    url :homepage
    regex(%r{/files/releases/v([\d.]+r\d+)/}i)
  end

  def install
    bin.install "bin/turdus_merula", "bin/turdusra1n"
  end
end
