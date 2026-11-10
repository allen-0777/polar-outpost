# 冰原獵人（Polar Outpost）— GitHub Pages 版

這是一個不需建置、無伺服器的 Three.js 網頁遊戲。`index.html` 已整合 HTML、CSS、遊戲 JavaScript；Three.js 從 jsDelivr 或 unpkg CDN 載入，瀏覽器需有網路連線。

## 在 GitHub Pages 上發布

1. 登入 GitHub，前往 https://github.com/new ，建立**公開（Public）**儲存庫，名稱建議 `polar-outpost`。如需便於網頁操作，建立時勾選新增 README。
2. 進入新儲存庫 → **Add file** → **Upload files**，上傳本資料夾的 `index.html`（注意：上傳解壓後的 HTML，不是 ZIP），提交至 `main` 分支。
3. 進入儲存庫 **Settings** → **Pages** → **Build and deployment** → **Source: Deploy from a branch**，選取 **Branch: `main` / `(root)`**，按 **Save**。
4. GitHub Pages 發布完成後，網址格式是 `https://<你的GitHub帳號>.github.io/polar-outpost/`。例如帳號為 `allen-0777`，則預期 `https://allen-0777.github.io/polar-outpost/`。這是**預期 URL**，必須完成 GitHub 上述操作後才會有網頁。

## 更新遊戲

只要覆蓋 `main` 分支根目錄的 `index.html`，GitHub Pages 便會自動重新發布。

## 操作

- 手機：左下方虛擬搖桿移動，右下方衝刺。
- 電腦：WASD／方向鍵移動，Shift 衝刺，U 升級，Esc 暫停。
- 遊戲進度保存在瀏覽器 `localStorage`，不同裝置互不共用。

## 注意事項

- 本專案使用 Three.js r170 ES module，不須 Node.js、npm、Vite、伺服器或資料庫。
- 若網站顯示 Three.js 載入失敗，請檢查 CDN 是否受網路限制。
- 本作品參考玩家錄影中的雪地狩獵／經營玩法製作，為非官方原型。

## Credits
3D 模型：Kenney (www.kenney.nl)，CC0 授權，詳見 assets/models/LICENSES.md。
