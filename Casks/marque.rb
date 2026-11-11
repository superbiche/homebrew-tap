cask "marque" do
  version "0.4.8"
  sha256 "7d98fe11c32d7e1190a32218382b7343df41a4a0329d5a608b27b826f77c2024"

  url "https://github.com/superbiche/marque/releases/download/v#{version}/Marque_#{version}_universal.dmg"
  name "Marque"
  desc "Markdown viewer with folder workspaces"
  homepage "https://github.com/superbiche/marque"

  livecheck do
    url :url
    strategy :github_latest
  end

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
