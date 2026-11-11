# superbiche/homebrew-tap

Homebrew casks for projects maintained by [@superbiche](https://github.com/superbiche).

## marque

[Marque](https://github.com/superbiche/marque) is a desktop markdown viewer with folder workspaces.

```sh
brew tap superbiche/tap
brew trust superbiche/tap   # Homebrew 6 and later load a third-party tap only once it is trusted
brew install --cask superbiche/tap/marque
```

The cask installs `Marque.app` and the `marque` command (`marque FILE` or `marque FOLDER`).

Marque is ad-hoc signed but not notarized, so macOS blocks its first launch: open it once, then allow it in System Settings → Privacy & Security → Open Anyway. That is also why it lives in this tap: Homebrew's official cask repository accepts only apps that pass Gatekeeper.

## How the cask is updated

A daily workflow ([`update.yml`](.github/workflows/update.yml)) reads the latest marque release and changes the cask only when:

- the release's `SHA256SUMS` and the `.dmg` both carry GitHub build provenance from marque's release workflow for that tag (`gh attestation verify --signer-workflow superbiche/marque/.github/workflows/release.yml --source-ref refs/tags/<tag>`);
- the `.dmg` matches `SHA256SUMS`;
- the updated cask installs on a macOS runner, the app's signature verifies, and the `marque` command points into the app.

GitHub pauses scheduled workflows after 60 days without repository activity; running the workflow by hand resumes it.
