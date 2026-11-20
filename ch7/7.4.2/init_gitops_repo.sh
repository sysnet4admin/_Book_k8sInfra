#!/usr/bin/env bash

GH_USER="$1"

if [ -z "$GH_USER" ]; then
  read -p "GitHub username: " GH_USER
fi

if [ -z "$GH_USER" ]; then
  echo "A GitHub username is required."
  exit 1
fi

# Reject anything but a plain username so the URL can only ever be <user>/gitops.
if ! printf '%s' "$GH_USER" | grep -qE '^[A-Za-z0-9-]+$'; then
  echo "Invalid GitHub username: $GH_USER"
  exit 1
fi

# Repo is fixed to <user>/gitops so this script can never touch another repository.
GIT_URL="https://github.com/${GH_USER}/gitops"

# Start from a clean ~/gitops so the clone always matches the given URL.
if [ -d ~/gitops ]; then
  echo "Remove existing ~/gitops."
  rm -rf ~/gitops
fi

echo "[1/5] Clone $GIT_URL into ~/gitops."
if ! git clone "$GIT_URL" ~/gitops; then
  echo ""
  echo "Clone failed: $GIT_URL"
  echo "  - Check the GitHub username: $GH_USER"
  echo "  - Make sure a repository named 'gitops' exists under that account."
  echo "    Create it on GitHub as a public repo with a README.md, then rerun."
  echo "  - This step runs before login, so the 'gitops' repo must be public."
  exit 1
fi

echo ""
echo "[2/5] Issue a GitHub Personal Access Token (PAT)."
cat <<'GUIDE'
  깃옵스 실습은 매니페스트를 수정한 뒤 git push 로 반영하므로 토큰이 필요합니다.

  1. GitHub 로그인 > 우측 상단 프로필 > Settings
  2. 좌측 맨 아래 Developer settings
  3. Personal access tokens > Tokens (classic) > Generate new token (classic)
  4. Note(용도) 입력, Expiration(만료) 설정
  5. Select scopes 에서 repo 항목 전체 체크
  6. Generate token 클릭 후 표시되는 토큰을 복사
     (이 화면을 벗어나면 토큰을 다시 볼 수 없습니다)
GUIDE
echo ""

echo "GitHub user: $GH_USER  (repo: $GIT_URL)"
while true; do
  read -s -p "GitHub token (hidden): " GH_TOKEN
  echo ""
  if printf '%s' "$GH_TOKEN" | grep -qE '^ghp_[A-Za-z0-9]{36}$'; then
    break
  fi
  echo "WARNING: not a classic PAT format (expected 'ghp_' + 36 chars). Please re-enter."
done

# Confirm the token was captured (show only the first 4 chars).
echo "token entered: ${GH_TOKEN:0:4}***"

echo ""
echo "[3/5] Configure commit author and credentials."
GIT_NAME="$GH_USER"
read -p "Commit author email: " GIT_EMAIL

if [ -z "$GIT_EMAIL" ]; then
  echo "Commit author email is required."
  exit 1
fi

git config --global user.name "$GIT_NAME"
git config --global user.email "$GIT_EMAIL"
echo "commit author name: $GIT_NAME (from GitHub username)"

echo "https://${GH_USER}:${GH_TOKEN}@github.com" > ~/.git-cred
chmod 600 ~/.git-cred
git config --global credential.helper "store --file ~/.git-cred"

echo ""
echo "[4/5] Reset the repo to README.md only."
if [ ! -f ~/gitops/README.md ]; then
  echo "  No README.md in repo; skipping cleanup."
elif [ -z "$(git -C ~/gitops ls-files | grep -vx 'README.md')" ]; then
  echo "  Repo already clean (only README.md)."
else
  echo "  Found files other than README.md:"
  git -C ~/gitops ls-files | grep -vx 'README.md' | sed 's/^/    - /'
  git -C ~/gitops ls-files -z | grep -zvx 'README.md' | xargs -0 -r git -C ~/gitops rm -q --
  git -C ~/gitops commit -q -m "chore: reset gitops repo to README.md only"
  git -C ~/gitops push -q
  echo "  Removed the above files and pushed the cleanup."
fi

echo ""
echo "[5/5] Verify GitOps environment."
FAILED=0
check() {
  local label="$1"; shift
  if "$@" >/dev/null 2>&1; then
    printf "  [ OK ] %s\n" "$label"
  else
    printf "  [FAIL] %s\n" "$label"
    FAILED=1
  fi
}

check "repo cloned (~/gitops)"            test -d "$HOME/gitops/.git"
check "commit author name set"           bash -c '[ -n "$(git config --global user.name)" ]'
check "commit author email set"          bash -c '[ -n "$(git config --global user.email)" ]'
check "credential file (~/.git-cred)"     test -f "$HOME/.git-cred"
check "credential helper registered"     bash -c 'git config --global credential.helper | grep -q "\.git-cred"'
check "repo contains only README.md"      bash -c '[ -z "$(git -C "$HOME/gitops" ls-files | grep -vx README.md)" ]'
check "GitHub authentication (ls-remote)" git -C "$HOME/gitops" ls-remote

if [ "$FAILED" -ne 0 ]; then
  echo ""
  echo "Some checks failed. Fix the items above and run again."
  exit 1
fi

echo ""
echo "=================================================="
echo " GitOps environment is ready."
echo "=================================================="
echo " repo path : ~/gitops"
echo " repoURL   : $(git -C ~/gitops remote get-url origin)"
echo " author    : $GIT_NAME <$GIT_EMAIL>"
echo " credential: ~/.git-cred (registered)"
echo "=================================================="
