# Polar Outpost 夜間優化待辦（PM 規格）
目標：讓遊戲的畫面、手感與介面更接近參考廣告（.pm/ref/*.jpg）。保持單一 index.html＋assets/ 資料夾、不用建置工具、手機與電腦都能玩、localStorage 存檔相容。
每輪只做一個項目，做完勾選。

- [x] R1 畫面風格：（先加入網址參數 ?autostart=1 時略過開始畫面直接進入遊戲，方便自動截圖）移除 Fog 與即時陰影，改每個角色/熊/樹底下的半透明黑色圓形 blob shadow；材質改 MeshLambertMaterial/MeshToonMaterial 純色平塗；提高環境光，雪地偏白藍、色彩飽和。主角改綠色毛邊連帽大衣＋紅圍巾，腳下常駐綠色發光光環。
- [ ] R2 戰鬥回饋：靠近熊自動揮棒；被打的熊閃白 0.1 秒；命中出現紅白斜線刀光 sprite（請生成 assets/slash.png 透明背景）；熊死亡冒出 3–4 團白色卡通雲朵粒子（生成 assets/puff.png）後掉落戰利品。
- [ ] R3 疊物與撿取：戰利品用 3D 模型在玩家頭頂疊成單一直柱，移動時彈簧晃動；撿起時飄出綠色粗體「+N」往上淡出。
- [ ] R4 解鎖區與 HUD：地面白色虛線框＋世界座標圖示與所需數量（生成 assets/icon_axe.png、icon_sword.png、icon_meat.png、icon_wood.png、icon_stone.png、icon_gem.png）；資源以拋物線逐個飛入；完成時建築 scale 0→1 overshoot＋黃色星芒；右上角半透明黑色圓角資源面板；搖桿移到右下角，衝刺鍵左下角。
- [ ] R5 打磨：新增石頭與藍寶石資源及其採集點；整體效能與手機觸控檢查；修正前幾輪留下的問題。
