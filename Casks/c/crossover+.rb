cask "crossover+" do
  version "26.3.0"
  sha256 "8688e0848c4e5f79f1cc351cb52d32447da00c6c00cfd3b4bb2d164d44589a26"

  url "https://media.codeweavers.com/pub/crossover/cxmac/demo/crossover-#{version}.zip"
  name "CrossOver+"
  desc "Pre-patched tool to run Windows software"
  homepage "https://www.codeweavers.com/products/crossover-mac/"

  livecheck do
    url "https://www.codeweavers.com/xml/versions/cxmac.xml"
    strategy :sparkle, &:short_version
  end

  auto_updates true
  conflicts_with cask: "crossover"
  depends_on :macos

  app "CrossOver.app"
  generated_script "croslic.sh", content: <<~'SH'
    #!/bin/sh -e
    openssl genrsa -out key.pem 2048
    openssl rsa -in key.pem -outform PEM -pubout -out $1/Contents/SharedSupport/CrossOver/share/crossover/data/tie.pub
    rm -f ~/Library/Preferences/com.codeweavers.CrossOver.license ~/Library/Preferences/com.codeweavers.CrossOver.sha256
    printf "[crossmac]\ncustomer=user\nemail=user@apple.com\nexpires=2030/01/01\n[license]\nid=a4xdUZD2bWB00tQI" > ~/Library/Preferences/com.codeweavers.CrossOver.license
    openssl dgst -sha256 -sign key.pem -out ~/Library/Preferences/com.codeweavers.CrossOver.sha256 ~/Library/Preferences/com.codeweavers.CrossOver.license
    rm key.pem
    cat > "$1/Contents/Resources/libcxsetup-v3.py" <<'PY'
    import os
    import traceback

    import appdetector
    import bottlemanagement
    import bottlequery
    import bottlewrapper
    import c4profilesmanager
    import cddetector
    import cxproduct
    import cxaiengine
    import cxmenu
    import demoutils
    import iconutils
    import installtask
    import ratingutils
    import webtoken

    import fileupdate

    def is_really_signed(datafile, sigfile = (None,)):
        return True

    fileupdate.is_signed = is_really_signed

    class CXSetup(Foundation.NSObject):

        @classmethod
        def setEnvValue_forKey_(cls, value, key):
            os.environ[key] = value

        @classmethod
        def unsetEnvValueForKey_(cls, key):
            if key in os.environ:
                del os.environ[key]

        @classmethod
        def bottleCategory_(cls, category):
            return installtask.__dict__['CAT_' + category]

        @classmethod
        def dependencyReason_(cls, reason):
            return installtask.__dict__['REASON_' + reason]

        @classmethod
        def dependencyOverride_(cls, override):
            return installtask.__dict__['OVERRIDE_' + override]

        @classmethod
        def bottleStatus_(cls, status):
            return bottlewrapper.BottleWrapper.__dict__['STATUS_' + status]
    PY
    codesign --force --sign - "$1"
  SH
  installer script: {
    executable: "croslic.sh",
    args:       ["#{staged_path}/CrossOver.app"],
  }

  uninstall quit: "com.codeweavers.CrossOver"

  zap trash: [
    "~/Applications/CrossOver",
    "~/Library/Application Support/CrashReporter/CrossOver*",
    "~/Library/Application Support/CrossOver",
    "~/Library/Caches/Cleanup At Startup/CrossOver CD Helper.app",
    "~/Library/Caches/com.apple.helpd/Generated/CrossOver Help*",
    "~/Library/Caches/com.codeweavers.CrossOver",
    "~/Library/Caches/CrossOver",
    "~/Library/Cookies/com.codeweavers.CrossOver.binarycookies",
    "~/Library/HTTPStorages/com.codeweavers.CrossOver*",
    "~/Library/Logs/CrossOver",
    "~/Library/Logs/DiagnosticReports/CrossOver*",
    "~/Library/Preferences/com.codeweavers.*",
    "~/Library/Saved Application State/com.codeweavers.CrossOver*",
  ]
end
