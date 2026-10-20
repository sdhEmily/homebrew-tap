cask "jdownloader+" do
  arch arm: "aarch64", intel: "amd64"

  version :latest
  sha256 :no_check

  url "https://installer.jdownloader.org/homebrew/latest/JDownloader2Setup_macos-#{arch}_v21.dmg"
  name "JDownloader+"
  desc "Download manager with config improvements"
  homepage "https://jdownloader.org/"

  conflicts_with cask: "jdownloader"
  depends_on :macos

  generated_script "install.sh", content: <<~'SH'
    #!/bin/sh
    set -e

    installer="$1"
    jd_dir="/opt/homebrew/libexec/jdownloader+"
    app_bundle="$2"
    custom_icon="$3"

    printf '==> Preparing JDownloader install directory\n'
    /bin/mkdir -p "$jd_dir"

    printf '==> Installing JDownloader\n'

    "$installer" \
      -dir "$jd_dir" \
      -q \
      -Dinstall4j.suppressStdout=true \
      -Dinstall4j.debug=false \
      '-VcreateDesktopLinkAction$Boolean=false' \
      '-VaddToDockAction$Boolean=false'

    printf '==> Removing duplicate JDownloader application shortcut\n'
    /bin/rm -rf "$HOME/Applications/JDownloader2.app"

    printf '==> Enabling native macOS system appearance\n'

    vmoptions="$jd_dir/JDownloader2.vmoptions"
    /usr/bin/touch "$vmoptions"

    if ! /usr/bin/grep \
      -Fqx \
      -- '-Dapple.awt.application.appearance=system' \
      "$vmoptions"; then
      printf '%s\n' \
        '-Dapple.awt.application.appearance=system' \
        >> "$vmoptions"
    fi

    tmp_dir="$(/usr/bin/mktemp -d)"
    trap '/bin/rm -rf "$tmp_dir"' EXIT

    printf '==> Downloading Material Darker\n'

    /usr/bin/curl \
      -fsSL \
      -H 'Accept: application/vnd.github+json' \
      'https://api.github.com/repos/vizenc/material-darker-jdownloader/releases/latest' \
      -o "$tmp_dir/release.json"

    theme_url="$(
      /usr/bin/python3 - "$tmp_dir/release.json" <<'PYTHON'
    import json
    import sys

    with open(sys.argv[1], encoding="utf-8") as f:
        release = json.load(f)

    for asset in release.get("assets", []):
        name = asset.get("name", "")
        if name.lower().endswith(".zip"):
            print(asset["browser_download_url"])
            break
    else:
        raise SystemExit("No Material Darker ZIP release asset found")
    PYTHON
    )"

    /usr/bin/curl \
      -fL \
      "$theme_url" \
      -o "$tmp_dir/material-darker.zip"

    printf '==> Extracting Material Darker\n'

    /bin/mkdir -p "$tmp_dir/material-darker"

    /usr/bin/ditto \
      -x \
      -k \
      "$tmp_dir/material-darker.zip" \
      "$tmp_dir/material-darker"

    backup="$(
      /usr/bin/find "$tmp_dir/material-darker" \
        -type f \
        -name 'cfg.jd2backup' \
        -print \
        -quit
    )"

    flatlaf="$(
      /usr/bin/find "$tmp_dir/material-darker" \
        -type f \
        -name 'flatlaf.jar' \
        -print \
        -quit
    )"

    images="$(
      /usr/bin/find "$tmp_dir/material-darker" \
        -type d \
        -name 'images' \
        -print \
        -quit
    )"

    if [ -z "$backup" ]; then
      printf 'Error: cfg.jd2backup was not found\n' >&2
      exit 1
    fi

    if [ -z "$flatlaf" ]; then
      printf 'Error: flatlaf.jar was not found\n' >&2
      exit 1
    fi

    if [ -z "$images" ]; then
      printf 'Error: Material Darker images directory was not found\n' >&2
      exit 1
    fi

    printf '==> Extracting Material Darker FlatLaf configuration\n'

    backup_dir="$tmp_dir/material-config"
    /bin/mkdir -p "$backup_dir"

    /usr/bin/ditto \
      -x \
      -k \
      "$backup" \
      "$backup_dir"

    flatdark_config="$(
      /usr/bin/find "$backup_dir" \
        -type f \
        -path '*/cfg/laf/FlatDarkLaf.json' \
        -print \
        -quit
    )"

    if [ -z "$flatdark_config" ]; then
      printf 'Error: cfg/laf/FlatDarkLaf.json was not found in cfg.jd2backup\n' >&2
      exit 1
    fi

    printf '==> Installing Material Darker FlatLaf configuration\n'

    /bin/mkdir -p "$jd_dir/cfg/laf"

    /bin/cp -f \
      "$flatdark_config" \
      "$jd_dir/cfg/laf/FlatDarkLaf.json"

    printf '==> Applying JDownloader+ configuration overrides\n'

    /usr/bin/python3 - "$jd_dir" <<'PYTHON'
    import json
    import os
    import sys

    jd_dir = sys.argv[1]

    patches = {
        "cfg/org.jdownloader.settings.GraphicalUserInterfaceSettings.json": {
            "lookandfeeltheme": "FLATLAF_DARK",
            "premiumalertetacolumnenabled": False,
            "premiumalerttaskcolumnenabled": False,
            "premiumalertspeedcolumnenabled": False,
            "specialdealoboomdialogvisibleonstartup": False,
            "specialdealsenabled": False,
            "donatebuttonstate": "AUTO_HIDDEN",
            "donatebuttonlatestautochange": 9_223_372_036_854_775_807,
            "bannerenabled": False,
            "updateavailabledialogenabled": False,
            "clipboardskipconfirmdialogenabled": True,
            "clipboardmonitored": False,
        },
        "cfg/org.jdownloader.gui.views.linkgrabber.addlinksdialog.LinkgrabberSettings.json": {
            "subfolderthreshold": 2,
            "uselastdownloaddestinationasdefault": False,
        },
        "cfg/org.jdownloader.updatev2.UpdateSettings.json": {
            "autoinstallifidle": True,
        },
        "cfg/org.jdownloader.extensions.extraction.ExtractionExtension.json": {
            "deletearchivefilesafterextractionaction": "RECYCLE",
        }
    }

    for relative_path, values in patches.items():
        path = os.path.join(jd_dir, relative_path)
        os.makedirs(os.path.dirname(path), exist_ok=True)

        try:
            with open(path, encoding="utf-8") as f:
                data = json.load(f)
        except (OSError, json.JSONDecodeError):
            data = {}

        data.update(values)

        with open(path, "w", encoding="utf-8") as f:
            json.dump(data, f, indent=2)
            f.write("\n")

    extensions_path = os.path.join(jd_dir, "update/versioninfo/JD/extensions.installed.json")
    try:
        with open(extensions_path, encoding="utf-8") as f:
            extensions = json.load(f)
        if not isinstance(extensions, list):
            extensions = []
    except (OSError, json.JSONDecodeError):
        extensions = []

    if "flatlaf-themes" not in extensions:
        extensions.append("flatlaf-themes")

    os.makedirs(os.path.dirname(extensions_path), exist_ok=True)
    with open(extensions_path, "w", encoding="utf-8") as f:
        json.dump(extensions, f, indent=2)
        f.write("\n")
    PYTHON

    printf '==> Installing Material Darker FlatLaf\n'

    /bin/mkdir -p "$jd_dir/libs/laf"

    /bin/cp -f \
      "$flatlaf" \
      "$jd_dir/libs/laf/flatlaf.jar"

    printf '==> Installing Material Darker images\n'

    /bin/mkdir -p \
      "$jd_dir/themes/standard/org/jdownloader"

    /bin/rm -rf \
      "$jd_dir/themes/standard/org/jdownloader/images"

    /usr/bin/ditto \
      "$images" \
      "$jd_dir/themes/standard/org/jdownloader/images"

    if [ ! -f "$custom_icon" ]; then
      printf 'Error: Custom icon not found at %s\n' "$custom_icon" >&2
      exit 1
    fi

    printf '==> Installing custom JDownloader runtime icon\n'

    runtime_logo="$jd_dir/themes/standard/org/jdownloader/images/logo/jd_logo_128_128.png"

    /bin/mkdir -p \
      "$jd_dir/themes/standard/org/jdownloader/images/logo"

    /usr/bin/sips \
      -s format png \
      -z 128 128 \
      "$custom_icon" \
      --out "$runtime_logo" \
      >/dev/null

    if [ ! -e "$app_bundle" ]; then
      installed_app="$jd_dir/JDownloader2.app"

      if [ -e "$installed_app" ]; then
        /bin/mkdir -p "$(/usr/bin/dirname "$app_bundle")"
        /bin/ln -s "$installed_app" "$app_bundle"
      fi
    fi

    if [ -e "$app_bundle" ]; then
      printf '==> Installing custom macOS app icon\n'

      info_plist="$app_bundle/Contents/Info.plist"

      icon_name="$(
        /usr/libexec/PlistBuddy \
          -c 'Print :CFBundleIconFile' \
          "$info_plist" \
          2>/dev/null || true
      )"

      if [ -n "$icon_name" ]; then
        case "$icon_name" in
          *.icns)
            ;;
          *)
            icon_name="${icon_name}.icns"
            ;;
        esac

        /bin/cp -f \
          "$custom_icon" \
          "$app_bundle/Contents/Resources/$icon_name"

        /usr/bin/touch "$app_bundle"

        /usr/bin/codesign \
          --force \
          --deep \
          --sign - \
          "$app_bundle" \
          >/dev/null 2>&1 || true

        lsregister='/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister'

        if [ -x "$lsregister" ]; then
          "$lsregister" \
            -f \
            "$app_bundle" \
            >/dev/null 2>&1 || true
        fi
      else
        printf 'Warning: Could not determine JDownloader app icon filename\n' >&2
      fi
    else
      printf 'Warning: JDownloader2.app could not be located\n' >&2
    fi
  SH
  installer script: {
    executable:   "install.sh",
    args:         [
      "#{staged_path}/JDownloader 2 Installer.app/Contents/MacOS/JavaApplicationStub",
      "#{appdir}/JDownloader2.app",
      "#{__dir__}/JDownloader2.icns",
    ],
    print_stderr: false,
  }

  uninstall delete: [
    "/Applications/JDownloader2.app",
    "/opt/homebrew/libexec/jdownloader+",
  ]

  zap trash: "~/Library/Preferences/org.jdownloader.launcher.plist"
end
