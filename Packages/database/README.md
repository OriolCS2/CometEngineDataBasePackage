# Comet Engine DataBase Package

Stop writing save/load code by hand with the **Comet Engine DataBase Package**. Define your game data as tables inside the editor, hit **Generate**, and the package writes all the serialization scripts for you — ready to save and load global settings and per-slot game files.

<div align="center">
  <a href="https://github.com/OriolCS2/CometEngineDataBasePackage">
    <img src="https://img.shields.io/badge/GitHub-Repository-blue?style=for-the-badge&logo=github" alt="GitHub Repo" />
  </a>
  <a href="https://www.cometengine.org">
    <img src="https://img.shields.io/badge/Comet_Engine-Website-orange?style=for-the-badge&logo=target" alt="Comet Engine Website" />
  </a>
  <a href="https://www.cometengine.org/marketplace/database">
    <img src="https://img.shields.io/badge/Marketplace-Package-brightgreen?style=for-the-badge&logo=googleplay" alt="Marketplace Package" />
  </a>
</div>

---

## 🚀 Quick Start Tutorial

Follow these steps to set up the database system in your project.

### 1. Configure the directories
Open the Comet Editor and navigate to **Project Settings > DataBase**.
*   **Initial Directory DDBB:** where the generated scripts will be written (default `DDBB/DDBB/`).
*   **Initial Tables Directory DDBB:** where you will author your tables (default `DDBB/Editor/`).

Click **Create Directories** to create both folders at once.

![DataBase Project Settings](https://raw.githubusercontent.com/OriolCS2/CometEngineDataBasePackage/main/TutorialImages/Tuto1.png)

### 2. Create your tables
Go to the tables directory you just configured and create as many tables as you need: **Right click > Create > DataManager > TableDDBB**.

You can organize them freely in subfolders — tables do **not** need to live in the same folder, and the folder structure you use is mirrored in the generated scripts directory.

![Create Table](https://raw.githubusercontent.com/OriolCS2/CometEngineDataBasePackage/main/TutorialImages/tuto2.png)

### 3. Configure the table
Select a table and configure it from the Inspector:

*   **Is Root:** when enabled, the table is added to the root database and can be queried directly (think of it as a singleton). A non-root table is a building block meant to be used *by* other tables — for example an `ItemData` table (name + numeric id) would not be root, while the `PlayerData` inventory table that stores `ItemData` entries would be.
*   **Save Load Mode:**
    *   `SLOT` — data that belongs to a single save file, so you can have several games saved in parallel (player progress, inventory…).
    *   `GLOBAL` — data shared across every save file (audio settings, control bindings…).
*   **Fields:** add every field the table holds. Supported types include `int`, `uint`, `float`, `bool`, `string`, `Vector2`, `Vector2i`, `Vector3`, `Vector3i`, `Color`, enums and other tables — plus the **array** and **dictionary** variant of each one.

![Table Inspector](https://raw.githubusercontent.com/OriolCS2/CometEngineDataBasePackage/main/TutorialImages/tuto3.png)

### 4. Generate the scripts
Your tables are used to automatically generate the scripts that carry all this information and perform the save/load. To generate them, click **Generate** in a table's Inspector or go to **DDBB > Generate** in the main menu bar.

![Generate](https://raw.githubusercontent.com/OriolCS2/CometEngineDataBasePackage/main/TutorialImages/tuto4.png)

### 5. Review the generated scripts
Once generated, the scripts directory will contain:

*   **`DDBB.as`** — the root file holding every table marked as **Is Root**, so you can reach them quickly, and exposing the save/load entry points for both global data and slots.
*   **`<TableName>DDBB.as`** — one script per table, with its fields and its `Save`/`Load` implementation.

![Generated Scripts](https://raw.githubusercontent.com/OriolCS2/CometEngineDataBasePackage/main/TutorialImages/tuto5.png)

### 6. Extend your tables with code
Every script is "duplicated" by a matching **`<TableName>ExtensionDDBB.as`**. This is *your* file: the extension class inherits (mixin) from the generated table, so it already has all of its properties available, and anything you add there is **not serialized**.

Use it to add helper variables and methods — like a quick check to know whether the player can afford a purchase, written right on the table that owns the money field:

![Extension Script](https://raw.githubusercontent.com/OriolCS2/CometEngineDataBasePackage/main/TutorialImages/tuto6.png)

*Extension files are never overwritten when you regenerate, so your code is safe.*

### 7. Access the database at runtime
Create a script that holds a `DDBB::DDBBExtension` object and assign it to **Project Settings > Unique Instances** so it is reachable from anywhere.

![DataManager Script](https://raw.githubusercontent.com/OriolCS2/CometEngineDataBasePackage/main/TutorialImages/tuto7.png)

From there, any root table is one property away:

```cpp
DataManager::get.dataBase.PlayerData.money
```

---

## 💻 Scripting API

Interact with the database via code using the following methods:

| Property / Method | Description |
| :--- | :--- |
| `dataBase.<TableName>` | Direct access to any table marked as **Is Root**. |
| `dataBase.SaveGlobal(JsonObject toSave)` | Writes every `GLOBAL` root table into the given Json object. |
| `dataBase.LoadGlobal(JsonObject toLoad)` | Restores every `GLOBAL` root table from the given Json object. |
| `dataBase.SaveSlot(JsonObject toSave)` | Writes every `SLOT` root table into the given Json object. |
| `dataBase.LoadSlot(JsonObject toLoad)` | Restores every `SLOT` root table from the given Json object. |
| `<table>.Save(JsonObject toSave)` | Saves a single table, at any depth. |
| `<table>.Load(JsonObject toLoad)` | Loads a single table, at any depth. |

Pair them with `Json::JsonObject::FileToJson()` and `App::GetPersistentPath()` to read and write your `.sav` files, using a different file per slot.

---

## ✨ Extra Features

### Main Menu Bar
The **DDBB** menu provides quick access to essential tools:
*   **Create Table:** create a new table without browsing to the tables folder.
*   **Generate:** regenerate every script after changing your tables.
*   **Tables Viewer:** open the dedicated table window.

### Tables Viewer
A dedicated window to browse and manage every table in your project at a glance. It includes:
*   **Full list:** all your tables in one place, no matter which folder they live in.
*   **Search:** quickly find a table by name.
*   **Editing:** create, edit and remove tables — and generate — without leaving the window.

![Tables Viewer](https://raw.githubusercontent.com/OriolCS2/CometEngineDataBasePackage/main/TutorialImages/tuto8.png)
