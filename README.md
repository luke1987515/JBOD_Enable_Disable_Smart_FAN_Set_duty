# AIC JBOD 風扇管理與調速工具

此資料夾包含用於管理與設定 **AIC JBOD 擴充晶片 (Expander Controller)** 風扇控制模式與手動轉速的批次檔工具。

---

## 🛠️ 主要工具

### 📌 [JBOD_Fan_Controller_Tool.bat](file:///c:/Users/Administrator/Downloads/JBOD_Enable_Disable_Smart_FAN_Set_duty/JBOD_Fan_Controller_Tool.bat) (推薦使用)
這是整合了所有功能的單一互動式工具，擁有全自動偵測與防錯機制。雙擊執行後，會提供以下選單：

1. **`[1] Enable Smart Fan (Auto Detect)`**：
   * **功能**：自動偵測系統中所有 AIC JBOD 機箱，並將其切換回**智慧自動調速模式**（由機箱內部溫控機制自動決定轉速）。
2. **`[2] Disable Smart Fan and Set Fan Duty (Auto Detect)`**：
   * **功能**：自動偵測所有 AIC JBOD 機箱，並**停用**其智慧調速功能，緊接著提示您輸入手動轉速值（Duty Level）。
   * **手動轉速範圍**：可輸入 `1` 至 `7` 之間的整數（`7` 為全速/最高速，`1` 為最低速）。
3. **`[3] Exit`**：
   * 離開程式。

---

## 💾 備用舊腳本 (已保留備用)
如果您需要單獨、手動指定特定的 SCSI 裝置位址，可以使用以下保留的舊版腳本：
* **[Enable_Smart_FAN.bat](file:///c:/Users/Administrator/Downloads/JBOD_Enable_Disable_Smart_FAN_Set_duty/Enable_Smart_FAN.bat)**：手動輸入 SCSI 位址來啟用智慧調速。
* **[Disable_Smart _FAN.bat](file:///c:/Users/Administrator/Downloads/JBOD_Enable_Disable_Smart_FAN_Set_duty/Disable_Smart%20_FAN.bat)**：手動輸入 SCSI 位址來停用智慧調速。
* **[JBOD_Enable_Disable Smart FAN.bat](file:///c:/Users/Administrator/Downloads/JBOD_Enable_Disable_Smart_FAN_Set_duty/JBOD_Enable_Disable%20Smart%20FAN.bat)**：舊版自動啟用/停用智慧風扇選單。
* **[JBOD_Set Fan duty.bat](file:///c:/Users/Administrator/Downloads/JBOD_Enable_Disable_Smart_FAN_Set_duty/JBOD_Set%20Fan%20duty.bat)**：舊版自動設定轉速（僅支援設定單一機箱）。

---

## 📋 系統需求與依賴
這些批次檔依賴 SCSI Enclosure Services (SES) 工具包：
* **`sg_scan`**：用來掃描與發現 SAS/SCSI 拓撲中的 AIC 擴充器裝置。
* **`sg_ses`**：用來對外殼服務（SES）的 `CoolingElement00` 元件發送控制指令。
* *請確保系統中已安裝 `sg3_utils` 並已將其執行檔路徑加入系統的環境變數 (PATH) 中。*

---

## ⚠️ 注意事項
1. **設定手動轉速前，務必先停用智慧調速**（即使用 `[2]` 選項），否則手動設定的值會立刻被機箱的溫控韌體自動覆蓋而失效。
2. 調整至低轉速時，請密切注意硬碟與系統溫度，避免散熱不足導致硬體損壞。
