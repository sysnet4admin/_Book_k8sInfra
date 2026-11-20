# headlamp
## installation
### Windows
### https://winstall.app/apps/Headlamp.Headlamp
### winget install --id=Headlamp.Headlamp  -e
winget install headlamp -v 0.41.0

### MacOS
### Homebrew cask 저장소 정책 변경으로 로컬 .rb 파일 설치 시 HOMEBREW_DEVELOPER=1 필요
### https://formulae.brew.sh/cask/headlamp
export HOMEBREW_DEVELOPER=1
brew install --cask ./headlamp-v0.41.0/headlamp.rb

### MacOS — Gatekeeper 경고 해결 ("Apple cannot check it for malicious software")
### 방법 1: 우클릭 → Open → Open
### 방법 2: System Settings → Privacy & Security → Open Anyway
