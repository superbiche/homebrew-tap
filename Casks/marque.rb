cask "marque" do
  version "0.4.9"
  sha256 "ecc1c4a63bd9a78ff819752c8193cf7b22cdb1dcc61ba477c79f802748a30955"

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
