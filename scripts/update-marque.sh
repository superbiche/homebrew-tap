#!/usr/bin/env bash
# Point Casks/marque.rb at the latest superbiche/marque release, after checking
# that release's provenance: SHA256SUMS and the dmg must carry GitHub build
# provenance from marque's release workflow for that tag, and the dmg must
# match SHA256SUMS. Writes `version=<new version>` to $GITHUB_OUTPUT when the
# cask changed. Needs gh with GH_TOKEN.
set -euo pipefail
repo=superbiche/marque
cask=Casks/marque.rb
fail() { echo "::error::$*" >&2; exit 1; }

tag="$(gh release view --repo "$repo" --json tagName --jq .tagName)"
[[ "$tag" =~ ^v([0-9]+\.[0-9]+\.[0-9]+)$ ]] || fail "latest marque release '$tag' is not a stable vX.Y.Z tag"
version="${BASH_REMATCH[1]}"
current="$(sed -n 's/^  version "\(.*\)"$/\1/p' "$cask")"
if [[ "$version" == "$current" ]]; then
  echo "marque cask is at $current, the latest release"
  exit 0
fi

dmg="Marque_${version}_universal.dmg"
work="$(mktemp -d)"
gh release download "$tag" --repo "$repo" --pattern SHA256SUMS --pattern "$dmg" --dir "$work"
for f in SHA256SUMS "$dmg"; do
  gh attestation verify "$work/$f" --repo "$repo" \
    --signer-workflow "$repo/.github/workflows/release.yml" \
    --source-ref "refs/tags/$tag" >/dev/null \
    || fail "$f of $tag has no valid provenance from $repo's release workflow"
done
sha="$(awk -v f="$dmg" '$2 == f { print $1 }' "$work/SHA256SUMS")"
[[ "$sha" =~ ^[0-9a-f]{64}$ ]] || fail "SHA256SUMS of $tag has no entry for $dmg"
(cd "$work" && sha256sum --quiet --ignore-missing -c SHA256SUMS) || fail "$dmg does not match SHA256SUMS"

sed -i -e "s/^  version \".*\"$/  version \"$version\"/" -e "s/^  sha256 \".*\"$/  sha256 \"$sha\"/" "$cask"
if ! grep -qx "  version \"$version\"" "$cask" || ! grep -qx "  sha256 \"$sha\"" "$cask"; then
  fail "could not rewrite $cask"
fi
echo "marque cask: $current -> $version"
echo "version=$version" >> "${GITHUB_OUTPUT:-/dev/stdout}"
