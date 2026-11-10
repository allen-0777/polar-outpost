# 大改版：換成 CC0 卡通 3D 模型 + 拉遠鏡頭 + 精簡 UI + 高飽和配色

目標：讓畫面明顯接近附圖（參考手機廣告，特別是 ref_04 的構圖）。附圖風格：圓潤 Q 版卡通、層層積雪的鮮藍色圓錐雪松組成密林、飽和粉橘色道路、非常白的雪地、高對比明亮光線、只有右上角小資源計數器。

## 1. 換模型（最重要）
模型已經下載好放在 `assets/models/`（全部 Kenney CC0，見 assets/models/LICENSES.md，**不要刪改這些 glb/png**）。每個資料夾內 glb 以相對路徑引用 `Textures/colormap.png`，GLTFLoader 會自動載入。
- 用 GLTFLoader 載入：`https://cdn.jsdelivr.net/npm/three@0.170.0/examples/jsm/loaders/GLTFLoader.js`（版本必須跟現在 three.module.js 0.170.0 一致；GLTFLoader 內部 `import ... from 'three'`，所以要加 `<script type="importmap">` 把 `"three"` 指到同一個 three.module.js 網址，並把現在的動態 import 改成與 importmap 相同的 URL，確保只有一份 THREE）。也要有 unpkg 備援或至少在載入失敗時退回現有的程式碼幾何模型（fallback），遊戲不能壞。
- 在開始遊戲前（或 boot 時）先 preload 所有需要的模型（Promise.all，加 timeout 8 秒），之後用 `SkeletonUtils.clone`（examples/jsm/utils/SkeletonUtils.js）複製有骨架的角色，靜態物件用 `.clone()`；大量樹用 InstancedMesh 或直接 clone 都可，但要注意效能（手機）。
- 設定 `window.__models = {loaded: <成功數>, failed: <失敗數>, fallback: <bool>}` 讓我驗證。
- 對應：
  - 主角：`kenney-mini-characters/character-soldier.glb`（綠色毛帽綠衣，很接近參考的綠大衣）。動畫 clips 有 idle / walk / sprint / attack-melee-right / pick-up 等，用 AnimationMixer：站著 idle、移動 walk 或 sprint、攻擊時播 attack-melee-right（LoopOnce，淡入淡出）。右手掛 `weapon-sword.glb`（找名稱含 hand/arm 的骨骼 attach，找不到就掛在角色右前方）。保留紅圍巾感：可在脖子位置加一個小紅色 torus 圍巾。主角腳下綠色光環保留。
  - 北極熊：`kenney-cube-pets/animal-polar.glb`，放大到比主角大（約主角 1.4 倍高），有 idle / walk / run 動畫；移動時播 walk。受擊閃白效果要套到新模型上（例如暫時改 emissive）。
  - 雪松：`kenney-holiday-kit-blue/tree-snow-a/b/c.glb`（已改成藍色）。隨機大小 0.9–1.6 倍、隨機旋轉。
  - 石頭：`kenney-holiday-kit/rocks-large/medium/small.glb`；雪堆 `snow-pile.glb`。
  - 圍欄：`kenney-holiday-kit/cabin-fence.glb`，沿道路兩側排一整排（像參考圖中道路邊的木圍欄）。
  - 攤位／櫃台：用 `kenney-survival-kit/workbench.glb`、`box.glb`、`box-large.glb`、`barrel.glb`、`chest.glb`、`kenney-holiday-kit/bench.glb` 組成木頭攤位，取代現在方塊攤位。木材堆用 `resource-wood.glb`、`tree-log.glb`。
  - 客人 NPC：`kenney-mini-characters/character-male-a/-c, character-female-b/-d.glb`，排成一條蜿蜒長隊（參考圖左下角那排藍綠色客人），播 idle 動畫（每個隨機 time offset）；把它們的衣服調成藍綠色系（clone material，material.color 乘上淡青色如 #8fd3e8 即可）。
  - 裝飾：lantern、sled、snowman、signpost、campfire-pit、penguin 零星放幾個。
- 角色和熊仍保留圓形 blob shadow。
- 模型的實際大小請用 Box3 量測後正規化到合適的世界尺寸（主角約現在主角的高度）。
- 掉落物（肉、木頭、金幣）與頭頂疊物可保留現有做法，但如果合適可以用 `resource-wood.glb` 當木頭。

## 2. 鏡頭
- 拉遠：可視範圍大約是現在的 1.8–2.2 倍，讓一個手機畫面能看到上方整片藍色森林、斜向的粉橘道路、攤位、左下的排隊客人、右下石頭（構圖參考 ref_04）。保持正交俯視斜角。
- 角色在畫面上看起來比現在小，但仍清楚（大約螢幕高度的 8–10%）。

## 3. 密度
- 道路兩側和遠處種很多樹形成密林邊緣（至少 120 棵以上，越遠越密），石頭 15+ 個、雪堆、小道具散布。
- 不要擋住道路和遊玩區域；可砍的樹仍要能被砍。

## 4. UI 精簡（像參考圖）
- 右上角：一排小巧的資源計數（圖示 + 數字，用 assets/icon_*.png），半透明深色小膠囊，整體寬度不超過 ~110px。
- 移除或預設隱藏：大的任務面板（quest-box）、區域標籤（location）、wordmark 標題、toast 長條提示泡泡（可改成很小、1.5 秒消失，或直接不顯示）、world-prompt、keycap 提示、mobile-label 文字。
- 衝刺、升級按鈕縮小（約 52px 圓形 icon 按鈕），放在左下不突兀。搖桿保持右下但縮小一點、更透明。
- 音樂/暫停按鈕可縮小放在右上資源下方。

## 5. 配色與光線
- 道路：飽和粉橘 #f0a07a ~ #e98b6a，邊緣稍深。
- 雪地：非常白 #f4f8fc，可有極淡的藍色陰影區塊。
- 光線：明亮，HemisphereLight + DirectionalLight，整體高對比、不灰；renderer toneMapping 可用 ACESFilmic 或 none，曝光調亮。模型的 colormap 材質建議換成 MeshLambertMaterial 或保留 Standard 但 roughness 1、metalness 0，避免灰暗。
- 背景色淺藍白。

## 必須保留且正常運作
搖桿（右下）、鍵盤 WASD/方向鍵移動、自動攻擊、熊、肉/木頭/金幣、頭頂疊物 + "+N" 飄字、解鎖區（白色虛線框 + 金幣拋物線飛入 + 彈出動畫）、升級、R2 刀光/煙霧特效、`?autostart=1`（跳過開始畫面直接開始）、存檔。

## 規則
只改 index.html（可新增 assets/ 下的小檔案，但不要改 assets/models/ 內容）。不要 git commit。完成後把 `<script type="module">` 內容抽出來用 `node --check` 檢查語法。最後用 3–5 行列出修改內容。
