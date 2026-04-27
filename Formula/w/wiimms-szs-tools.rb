class WiimmsSzsTools < Formula
  desc "Tool to manipulate various Mario Kart Wii files"
  homepage "https://szs.wiimm.de"
  url "https://szs.wiimm.de/download/szs-v#{version}-mac64.tar.gz"
  version "2.42a-r8989"
  sha256 "57a24af66b9152f775f6b075cbfa477d3f645e65e071c5bff1d9712c352fb50f"

  livecheck do
    url :homepage
    regex(/szs-v(\d+\.\d+\w+-r\d+)-mac64/i)
  end

  def install
    bin.install Dir["bin/*"]
  end
end
