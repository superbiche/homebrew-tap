cask "marque" do
  version "0.4.11"
  sha256 "4952545feeee8b05bb4609ce65240e20bfb0bc38ab46f4e88fc25d541c97378b"

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
