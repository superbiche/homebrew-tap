cask "marque" do
  version "0.4.10"
  sha256 "178623f051925ec746d4a9dbb241574b20b1c8e551772496170bd30c469398d7"

  url "https://github.com/superbiche/marque/releases/download/v#{version}/Marque_#{version}_universal.dmg"
  name "Marque"
  desc "Markdown viewer with folder workspaces"
  homepage "https://github.com/superbiche/marque"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on :macos

  app "Marque.app"
  binary "#{appdir}/Marque.app/Contents/MacOS/marque"

  zap trash: [
    "~/Library/Application Support/marque",
    "~/Library/Caches/me.superbiche.marque",
    "~/Library/Saved Application State/me.superbiche.marque.savedState",
    "~/Library/WebKit/me.superbiche.marque",
  ]

  caveats <<~EOS
    Marque is ad-hoc signed but not notarized: macOS blocks its first launch.
    Open it once, then allow it in System Settings > Privacy & Security >
    Open Anyway.
  EOS
end
