# 游戏内更新日志

游戏内「更新日志」窗口按来源分开显示。

- 「汉化版更新」读取 `html/changelogs/localization/archive/YYYY-MM.yml`，记录与 SPLURT-zh 共用的汉化、功能与修复。2026-11-09 的条目是随移植保留的 Bubberstation 汉化历史。
- 「天关更新」读取 `html/changelogs/tianguan/archive/YYYY-MM.yml`，记录天关独有的功能、玩法与修复。

NovaSector 的完整汉化历史由 [NovaSector 汉化仓库](https://github.com/sernseek/NovaSector/tree/master/html/changelogs/localization/archive) 维护。从 Nova 移植功能时，在这里记录 SPLURT 引入该功能的日期、玩家可见的变化和来源。只在 Nova 上线的改动请留在原仓库。

## 新增条目

1. 在对应的条目目录（`html/changelogs/localization/` 或 `html/changelogs/tianguan/`）新建一个 `.yml`（文件名随意，`example` 与 `.` 开头的会被忽略），格式与 `html/changelogs/example.yml` 相同：

   ```yaml
   author: "sernseek"
   delete-after: True
   changes:
     - bugfix: "修复……"
     - rscadd: "新增……"
   ```

   可选字段 `date: YYYY-MM-DD` 用于把改动记到它实际上线的日期，不写则记为当天。
   条目类型与上游相同：`bugfix` `rscadd` `rscdel` `qol` `spellcheck` `balance` `code_imp` `refactor` `config` `admin` `server` `image` `sound` `map` 等。

2. 运行对应目录的命令，编译进月份文件。脚本会删掉 `delete-after: True` 的源文件。

   ```sh
   nix-shell -p 'python3.withPackages (ps: [ps.pyyaml])' --run 'python3 tools/i18n/compile-localization-changelog.py html/changelogs/localization'
   nix-shell -p 'python3.withPackages (ps: [ps.pyyaml])' --run 'python3 tools/i18n/compile-localization-changelog.py html/changelogs/tianguan'
   ```

3. 连同 `archive/` 的改动一起提交。

## 上游更新日志的翻译

「更新日志」页签里 /tg/、Bubberstation 和 SPLURT 的条目在中文服下显示机翻译文，译文在 `upstream/<locale>/YYYY-MM.json`（英文原文 → 译文，每月一张）。
同步上游时运行 `bun tools/i18n/changelog-mt.ts` 翻译新增条目（只处理 2026-09 及以后的月份，已翻过的不重复翻），产物随同步一起提交。
前端读取三个上游的英文月档，按原文查表替换，查不到的条目显示英文；译文不进 `strings/i18n` 目录。
