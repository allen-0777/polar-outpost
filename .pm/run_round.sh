#!/usr/bin/env bash
# 用法: .pm/run_round.sh <spec檔>  —— 交給 Codex 實作一輪，檢查通過才部署
set -uo pipefail
cd /workspace/polar-outpost
SPEC="$1"; TS=$(date +%Y%m%d-%H%M); LOG=.pm/logs/$TS; mkdir -p "$LOG"
git pull -q --rebase || true
PRE=$(git rev-parse HEAD)
IMGS=$(ls .pm/ref/*.jpg | head -6 | tr '\n' ',' | sed 's/,$//')
timeout 50m codex exec -s workspace-write --skip-git-repo-check -C /workspace/polar-outpost -i "$IMGS" "$(cat "$SPEC")

規則：附圖是參考遊戲畫面。只改 index.html 與 assets/（素材請自己生成並存成檔案，用相對路徑載入，PNG 或 SVG，單檔 < 300KB）。不要改 .pm/ 以外的說明檔、不要 git commit。完成後用 node 檢查 module script 語法，並在最後用 3–5 行列出修改內容。" > "$LOG/codex.txt" 2>&1
echo "codex exit $?" >> "$LOG/codex.txt"
# 檢查1：module script 語法
python3 - <<'PY' > "$LOG/check.txt" 2>&1
import re,subprocess,sys
h=open('index.html',encoding='utf-8').read()
ms=re.findall(r'<script type="module"[^>]*>(.*?)</script>',h,re.S)
open('/tmp/_po.mjs','w').write('\n'.join(ms))
r=subprocess.run(['node','--check','/tmp/_po.mjs'],capture_output=True,text=True)
print('syntax', 'ok' if r.returncode==0 else 'FAIL', r.stderr[:500]); sys.exit(r.returncode)
PY
SYN=$?
# 檢查2：無頭瀏覽器截圖＋console 錯誤
(python3 -m http.server 8765 >/dev/null 2>&1 &) ; sleep 1
timeout 60 google-chrome --headless=new --no-sandbox --use-gl=swiftshader --enable-unsafe-swiftshader --window-size=430,860 --virtual-time-budget=8000 --screenshot="$LOG/shot_mobile.png" http://127.0.0.1:8765/index.html?autostart=1 >/dev/null 2>&1
timeout 60 google-chrome --headless=new --no-sandbox --use-gl=swiftshader --enable-unsafe-swiftshader --window-size=1280,800 --virtual-time-budget=8000 --screenshot="$LOG/shot_desktop.png" http://127.0.0.1:8765/index.html?autostart=1 >/dev/null 2>&1
timeout 60 google-chrome --headless=new --no-sandbox --use-gl=swiftshader --enable-unsafe-swiftshader --virtual-time-budget=8000 --enable-logging=stderr --v=0 --dump-dom http://127.0.0.1:8765/index.html?autostart=1 2> "$LOG/console.txt" >/dev/null
pkill -f "http.server 8765" || true
ERRS=$(grep -ciE 'Uncaught|SyntaxError|TypeError|ReferenceError' "$LOG/console.txt")
echo "syntax_rc=$SYN console_errors=$ERRS" | tee -a "$LOG/check.txt"
CHG=$(git status --porcelain index.html assets 2>/dev/null)
if [ "$SYN" = 0 ] && [ "$ERRS" = 0 ] && [ -n "$CHG" ]; then
  git add index.html assets .pm 2>/dev/null; git commit -qm "Night round $TS: $(head -1 "$SPEC" | cut -c1-60)" && git tag "night-$TS" && git push -q --follow-tags origin main && echo "DEPLOYED $(git rev-parse --short HEAD)" | tee -a "$LOG/check.txt"
else
  git checkout -- index.html 2>/dev/null; git clean -fdq assets 2>/dev/null; echo "REVERTED (pre=$PRE)" | tee -a "$LOG/check.txt"
fi
