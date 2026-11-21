# Skill 交付闭环与本机复用验收（2026-11-21）

负责人：小灵。来源：Lilith 本轮追问“你的任务为什么不做好？”及“原因是什么？以后不要犯错”。

## 原因与交付门槛

此前 W47 完成了来源审核和周六接收闭环，却没有继续核实本机已有能力并推进可执行候选；候选数量不能代表可用能力数量。收到“有没有新增”时，应先回答正式卡片与实际可用状态，再补候选。

以后每项按以下顺序推进并留证据：
1. 核对当前真实安装、版本或内容指纹；复用已有文件，不能把未由本轮安装误写成机器未安装。
2. 完成对应范围的实际调用，检查输出是否适合任务；exit 0 只证明执行成功。
3. 按现有分类和永久 ID 接入，保留所有旧 ID、News 和复制记录。
4. 分开记录 GitHub 合并、构建、桌面生效、真实复制与实际调用；未验部分保持未验。
5. 一个候选受阻时，继续其他有明确可执行步骤的候选；待办须有具体下一步。不能用审核清单作为整个任务的交付终点。

## UI UX Pro Max：复用本机已有能力

本轮观察到已有 ~/.agents/skills/ui-ux-pro-max，未安装、升级或覆盖。
本机 SKILL.md 内容有 React Native 项目限定，与 W47 固定上游版本不能视为相同；保留原文件，未宣称已升级到 2.15.0。
以下只核验本机现有内容：

| 文件 | SHA-256 |
|---|---|
| SKILL.md | 9bd26c52dfd10dfd613dd3cc85df217dc25a172e380bde41fdfa6fedda288b2a |
| scripts/search.py | 6a565f960a672e16dd064ccadd3406db999bfd1a4bff4d609b36a8d4c6450b86 |
| scripts/core.py | 772b4d567c7a948c5d4a10343473b4123fec04238d250c9ffce31d0733f752c0 |
| scripts/design_system.py | f7a21e83739c5ac6ca3738846220f6a9eb7f3c1ae7a44989c5aaa2061ca60310 |

直接审查调用路径：Python 标准库与本地 CSV 检索；持久写入仅在明确选项分支，本轮未使用。使用 PYTHONDONTWRITEBYTECODE=1 避免在原 Skill 目录生成字节码。

实际执行：
- search.py 'fintech mobile banking professional clear' --design-system -f markdown -p 'Palette acceptance'：exit 0，返回结构、风格、颜色、字体和检查项。
- search.py 'search feedback keyboard loading' --domain ux -n 3 --json：exit 0，返回3条 loading/keyboard 规范。

输出质量发现：银行 App 查询仍返回 Contact Sales / Hero 等营销页结构；配色段也不完全符合文字色彩策略。结果只能作为检索资料，须按目标平台和既有规范筛选，不能直接视作方案或可访问性认证。本机 Skill 的限定也不构成修改 Palette 或其他项目栈的授权。

## 工作台接入范围

新增永久 ID ui-ux-pro-max，复用“系统”分类（显示“定系统”），标题“设计资料检索（配色/字体/规范）”。按实际已验范围限定为只读查询，提示先发现本机入口，再核对平台/品牌/项目规范，排除矛盾建议。不自动安装、修改项目、启用 hook 或持久写入设计系统。
该卡仅提供调用指令，不捆绑或镜像旧本机 Skill；其他机器仍须有兼容入口。原55卡及存储代码不改，新增后为56卡，新卡采用既有 News 规则。
build 121 为本次候选；构建与桌面状态以最终回执为准，不强退正在使用的 build120。正式界面复制、旧55卡逐卡验收及其他候选未由本次命令代替。

## 其他候选

design-taste-frontend 本机目录同样存在，版本、依赖、hook与实际调用仍待核；不再笼统写成本机未安装。
W47 记录中的“本轮安装0”仍成立，但不代表本机全局不存在。
Apple许可、Modern固定CLI、Stitch远端数据权限等原审核限制保留；未据此全量安装或新增卡。

## 本轮验证回执

- 独立目录构建 exit 0，候选 Info.plist build121；未启动测试实例、未改正式 App。
- 候选二进制 SHA256：5439af31679d56e5b4ec74af8bdd3baf13c293c690b0b1c82181bff5b3301e04（本轮独立编译产物；更新器另行编译须记录其自身哈希）。
- 56个唯一ID；删去新ID后，原55个ID与顺序逐项匹配；NEWS_STATE片段逐字相同。
- 本机旧版 SKILL.md SHA256：9bd26c52dfd10dfd613dd3cc85df217dc25a172e380bde41fdfa6fedda288b2a；search.py：6a565f960a672e16dd064ccadd3406db999bfd1a4bff4d609b36a8d4c6450b86。未将其声称为W47上游固定提交版本。
- 正式App读取为build120，health/receipt仍指向57f54aa；不将候选编译成功写成已安装121。
