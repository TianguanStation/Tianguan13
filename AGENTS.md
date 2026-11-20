# 仓库维护

- 改动玩家或管理员能看到的文字、界面、功能或玩法时，在同一提交里更新游戏内「汉化版更新」。用中文写清谁会看到什么变化。
- 在 `html/changelogs/localization/` 写条目，运行 `python3 tools/i18n/compile-localization-changelog.py`。提交前查看暂存差异，确认 `archive/YYYY-MM.yml` 包含本次条目。格式、日期和构建环境见[更新日志说明](html/changelogs/localization/README.md)。
- 共用改动先提交到 SPLURT-zh，再同步到 TianGuan13-splurt。天关专属功能和对应日志直接提交到 TianGuan13-splurt。
