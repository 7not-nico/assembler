**Mainland China and Taiwan diverge sharply on which games CS students use for modding-based learning — MC Java modding dominates the mainland; structured coding games dominate Taiwan; English-language sources confirm MC scale but miss the CS-education framing.**

---
id: MANIFEST.CHINESE.CS.MODDING.PREFS
title: Cross-Region Analysis of Chinese CS Student Modding Preferences
summary: |
  Mainland China overwhelmingly favors Minecraft (Java Edition) modding
  for CS learning, backed by NetEase's institutional SDK pipeline and
  university-level modding courses. Taiwan rejects this pattern — MC is
  treated as creativity tool while CodeCombat and Screeps serve as primary
  CS learning games. International sources confirm MC modding volume in
  China but do not distinguish the CS-education use case from general
  modding culture.
tags: [china, modding, cs-education, cross-region, investigation]
tables: [Fundamentals, Meta-analyses, By Region, Gaps]
---

## Fundamentals

Chinese CS education prioritizes career-relevant languages (Java, JavaScript, Python). This drives game preference:
- **Java** = Minecraft modding (Forge/Fabric/NeoForge bytecode)
- **JavaScript** = Screeps (persistent MMO AI), CodinGame (bot programming)
- **Python** = CodeCombat (Western) / NetEase MC Mod SDK (China-specific)

Mainland China has an institutional modding pipeline absent elsewhere — NetEase (网易) operates Minecraft China with a formal developer program (Python Mod SDK, Apollo server framework, monetization). East China Normal University (ECNU) runs a Minecraft club teaching Java modding as formal coursework on Bilibili.

## Meta-analyses

| ID | Topic | Method | Finding |
|----|-------|--------|---------|
| MA.CHINESE.MC.DOMINANCE | MC modding as CS learning | xsearch zh-CN (MC百科, Bilibili, Zhihu, NetEase dev portal) | MC is #1 in Mainland CN — institutional backing, university courses, largest mod wiki |
| MA.TAIWAN.CODING.GAMES | Taiwan CS game preference | xsearch zh-TW (104 Learning, AI4kids, school sites) | CodeCombat and Screeps preferred; MC scored low as CS tool |
| MA.INTL.CONFIRMATION | International sources on CN modding | xsearch en (ACM, CurseForge, GitHub) | Confirm MC modding volume in China but lack CS-education framing |

## By Region

| Region | #1 Game | #2 Game | #3 Game | Pathway |
|--------|---------|---------|---------|---------|
| Mainland China | Minecraft (Java) | Screeps | CodeCombat | Modding → Java skills → employability |
| Taiwan | CodeCombat | Screeps | Codingame | Structured puzzles → Python/JS → general CS |
| International | Minecraft | Factorio | RimWorld | Sandbox modding → systems thinking |

### Gap: Mainland China sources exist primarily on Chinese-language platforms (MC百科, Bilibili, Zhihu, NetEase) with limited English-language documentation of the CS-education use case. Taiwan sources exist on Taiwanese education blogs and school sites. No single study compares both regions directly.

## Gaps

| ID | Description | Severity | Status |
|----|-------------|----------|--------|
| GAP.CHINESE.MODDING.STUDY | No peer-reviewed study comparing CN vs TW CS modding preferences | high | native_surveys_absent |
| GAP.MC.CS.FRAMING | English sources lack CS-education framing for MC modding in China | medium | surfaced_disabled |
| GAP.TW.MODDING.DATA | Taiwan sources on modding-as-CS-learning are sparse | medium | sources_absent |
| GAP.FACTORIO.CN.DEPTH | Factorio Chinese community size unquantified | low | searched_disabled |
