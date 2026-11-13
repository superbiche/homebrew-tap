cask "marque" do
  version "0.4.12"
  sha256 "cf5bb838ac9c1da377a6b1e5cb9772dbb08b2f74e2083d95f0efb92599869ffb"

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
