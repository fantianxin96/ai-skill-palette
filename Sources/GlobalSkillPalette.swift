import Cocoa
import Carbon
import SwiftUI

struct Skill {
    let category: String
    let stage: String
    let icon: String
    let title: String
    let command: String
    let detail: String
    let prompt: String
}

final class PromptStore {
    static let skills: [Skill] = [
        Skill(
            category: "想清楚",
            stage: "开始前",
            icon: "🧶",
            title: "需求来源综合（找线索）",
            command: "$i-synthesize",
            detail: "反馈、访谈、竞品、机会点",
            prompt: "请使用 $i-synthesize，帮我把这些用户反馈、想法、竞品观察或聊天记录综合成产品洞察。请先区分事实、假设和个人感受，再提炼高频主题、真实用户问题、情绪动机、机会点和下一步可以验证的设计方向。不要直接跳到方案。"
        ),
        Skill(
            category: "想清楚",
            stage: "开始前",
            icon: "📄",
            title: "产品 Brief 定义（定方向）",
            command: "$i-shape",
            detail: "定位、用户、MVP、边界、成功标准",
            prompt: "请使用 $i-shape，帮我为当前项目生成一份轻量产品 brief。先不要写代码，请先梳理：产品定位、目标用户、核心场景、用户痛点、核心任务、MVP 范围、不做什么、成功标准、关键约束，以及后续新开 AI 对话时可以直接贴上的项目说明。"
        ),
        Skill(
            category: "想清楚",
            stage: "开始前",
            icon: "🧭",
            title: "单功能需求梳理（理功能）",
            command: "$i-shape",
            detail: "单个功能的用户、场景、优先级",
            prompt: "请使用 $i-shape，以产品经理视角帮我理清这个单个功能需求。先不要写代码，先帮我梳理：目标用户、核心场景、用户路径、必须保留的体验、可以砍掉的复杂度、优先级、验收标准，以及你认为更好的产品建议。最后给我一个清晰的功能 brief 和下一步执行建议。"
        ),
        Skill(
            category: "想清楚",
            stage: "开始前",
            icon: "🧱",
            title: "产品结构草图（拆模块）",
            command: "$i-shape",
            detail: "页面模块、输入输出、信息架构",
            prompt: "请使用 $i-shape，基于刚刚的产品定义，继续做产品结构草图。先不要写代码，也不要做视觉设计。这一步只回答“产品由哪些页面/模块组成”，不要细化单条用户操作路径，也不要砍 MVP 范围。请梳理：1. 页面/模块清单；2. 每个页面/模块的职责；3. 每个页面/模块的输入、处理、输出；4. 页面/模块之间的数据和依赖关系；5. 哪些模块容易被混淆，需要命名或边界说明；6. 最后给我一版清晰的信息架构树和模块关系图。"
        ),
        Skill(
            category: "想清楚",
            stage: "开始前",
            icon: "🎯",
            title: "MVP 范围切分（切 v1）",
            command: "$i-shape",
            detail: "先做什么、砍掉什么、后做什么",
            prompt: "请使用 $i-shape，基于已经列出的产品结构、功能清单或页面模块，帮我做 MVP 范围切分。先不要重新规划页面结构，也不要写代码。如果信息不足，请先问我最多 3 个关键问题；如果信息足够，请直接输出：1. v1 必须保留的核心闭环；2. 可以合并的页面/模块；3. 可以先用手动、半自动或低保真方式代替的能力；4. 明确后置到 v1.1/v2 的功能；5. 第一版最小可验证路径；6. 第一版验收标准；7. 为了不把产品做散必须坚持的体验原则。"
        ),
        Skill(
            category: "想清楚",
            stage: "开始前",
            icon: "🗺️",
            title: "页面路径规划（走流程）",
            command: "$i-shape",
            detail: "单条任务流、状态、反馈、异常路径",
            prompt: "【本次规划目标：把这里替换成当前任务流，例如“首次使用成功路径 / 导入到导出 / 注册完成支付”】\n\n请使用 $i-shape，基于已确定的产品结构，帮我规划这条核心任务流的页面路径。先不要写代码，也不要重新设计产品模块。请先确认或复述本次要规划的用户目标；如果目标不明确，请先问我最多 3 个关键问题。然后聚焦这一个用户目标，梳理用户从进入、理解、操作、反馈到完成的具体步骤。请列出：1. 每一步出现的页面、弹窗或局部状态；2. 用户在每一步要完成的动作；3. 系统在每一步要给出的反馈；4. 空/loading/成功/失败状态；5. 异常路径和恢复方式；6. 容易漏掉的边界情况；7. 容易让用户困惑的节点和引导建议。最后给我一版可用于原型的任务流转。"
        ),
        Skill(
            category: "想清楚",
            stage: "开始前",
            icon: "🧩",
            title: "从需求到上线路线（看全局）",
            command: "flow",
            detail: "需求、页面、设计、实现、验收",
            prompt: "请按 UX / 产品设计师的 AI 工作流帮我推进这个功能：1. 先用 $i-shape 梳理需求和用户路径；2. 再列页面清单和 MVP 范围；3. 如果已有满意页面，使用 $i-system 定设计基准；4. 实现前给出任务拆分；5. 上线前使用 $i-audit / $i-handoff 做验收。先给路线图和下一步，不要直接写代码。"
        ),
        Skill(
            category: "评审",
            stage: "评审时",
            icon: "🔍",
            title: "UI/UX 设计评审（找问题）",
            command: "$i-critique",
            detail: "层级、信息、情绪、反 AI 味",
            prompt: "请使用 $i-critique，对当前页面/功能做一次 UI/UX 设计评审。请从视觉层级、信息架构、当前目标设备体验、交互反馈、情绪感受、反 AI 味、可用性问题来评估。先给评分和优先级问题，不要直接改代码。"
        ),
        Skill(
            category: "评审",
            stage: "评审时",
            icon: "🖱️",
            title: "Web 交互状态检查",
            command: "$i-web-interact",
            detail: "hover、focus、键盘、浏览器状态",
            prompt: "请使用 $i-web-interact，对当前 Web 页面/产品做一次交互状态检查。请重点检查 hover、active/pressed、focus、disabled、selected、dropdown/popover、modal/toast、loading/success/error/retry、键盘操作、cursor 提示和响应式状态。先给交互完整度评分和优先级问题，不要直接加动效。"
        ),
        Skill(
            category: "评审",
            stage: "评审时",
            icon: "📲",
            title: "App 触控手感检查",
            command: "$i-app-interact",
            detail: "tap、手势、底部弹层、安全区",
            prompt: "请使用 $i-app-interact，对当前移动端 App 页面/流程做一次触控手感检查。请重点检查 tap/pressed、selected、disabled、loading/success/error/retry、滑动/拖拽/长按、底部弹层、导航转场、键盘弹起、安全区、触控热区、系统手势冲突和反馈闭环。先给交互完整度评分和优先级问题，不要直接加动效。"
        ),
        Skill(
            category: "系统",
            stage: "定系统",
            icon: "📌",
            title: "从满意页提炼规范",
            command: "$i-system",
            detail: "提取字体、颜色、间距、组件",
            prompt: "请使用 $i-system，从当前我已经满意的页面/组件里提取设计系统。请沉淀颜色、字体层级、间距、圆角、阴影、卡片、按钮、弹窗、动效状态、移动端规则和文案语气，写成项目里的 DESIGN.md。目标是让后续第二页、第三页都能延续同一套视觉语言。"
        ),
        Skill(
            category: "系统",
            stage: "定系统",
            icon: "🧭",
            title: "新页面基准确认",
            command: "$i-system",
            detail: "开新页前定规则和边界",
            prompt: "请使用 $i-system，在开始新页面之前，基于项目里的 DESIGN.md 或已满意的参考页面，帮我确认这次新页面应该沿用哪些设计规则。请明确：必须保持一致的字体、颜色、间距、按钮、卡片、弹窗和文案语气；可以根据页面功能变化的部分；以及本页不能破坏的设计边界。先给基准清单，不要直接写代码。"
        ),
        Skill(
            category: "系统",
            stage: "定系统",
            icon: "🧷",
            title: "风格漂移校准",
            command: "$i-consistency",
            detail: "字体、颜色、间距、组件、状态",
            prompt: "请使用 $i-consistency，基于项目中的 DESIGN.md 或我已经满意的第一页，检查当前页面是否与参考页面保持一致。重点看字体层级、颜色、间距、卡片、按钮、弹窗、hover/active/loading 状态、移动端表现和文案语气。先给一致性评分和优先级问题；如果需要修改，请只做对齐，不要重新设计。"
        ),
        Skill(
            category: "系统",
            stage: "定系统",
            icon: "🗂️",
            title: "阶段复盘升级系统",
            command: "$i-system",
            detail: "更新 DESIGN.md 和组件规则",
            prompt: "请使用 $i-system，对当前项目做一次阶段性设计系统复盘。请检查实际页面里已经稳定复用的颜色、字体、间距、组件、状态、移动端规则和文案语气，并更新 DESIGN.md：保留有效规则，删掉没有继续使用的规则，补充新出现的组件状态和边界情况。先列出建议改动，再更新文档。"
        ),
        Skill(
            category: "设计",
            stage: "打磨中",
            icon: "🔤",
            title: "字体层级打磨",
            command: "$i-typeset",
            detail: "字体、字号、字重、行高",
            prompt: "请使用 $i-typeset，重点优化当前界面的字体、字号、字重、行高和文本层级。请先指出哪里显得不精致，再动手修改。中文优先考虑 PingFang SC 的自然层级，不要使用生硬的粗体堆叠。"
        ),
        Skill(
            category: "设计",
            stage: "打磨中",
            icon: "📐",
            title: "布局节奏优化",
            command: "$i-layout",
            detail: "间距、对齐、呼吸感、一屏呈现",
            prompt: "请使用 $i-layout，优化当前界面的布局、间距、对齐、视觉节奏和移动端一屏呈现。请重点检查是否拥挤、是否太平均、按钮和内容之间是否有呼吸感。"
        ),
        Skill(
            category: "设计",
            stage: "上线前",
            icon: "✨",
            title: "最终质感收尾",
            command: "$i-polish",
            detail: "对齐、状态、对比度、移动端细节",
            prompt: "请使用 $i-polish，做最终质感收尾。重点检查对齐、间距、对比度、hover/active/loading/empty 状态、移动端细节、文本是否溢出、动效是否自然。请小步改，不要大改结构。"
        ),
        Skill(
            category: "表达",
            stage: "打磨中",
            icon: "💬",
            title: "文案表达优化",
            command: "$i-clarify",
            detail: "按钮、提示、说明、错误信息",
            prompt: "请使用 $i-clarify，优化当前界面的文案、按钮文字、提示语和错误/分享提示。目标是更自然、更容易懂、更有人味，不要像说明书。先给修改建议，再执行。"
        ),
        Skill(
            category: "设计",
            stage: "打磨中",
            icon: "🎨",
            title: "色彩氛围优化",
            command: "$i-colorize",
            detail: "柔和、克制、有层次",
            prompt: "请使用 $i-colorize，优化当前界面的色彩系统。目标是更有氛围但不花哨，颜色要柔和、克制、有层次。请检查首页、按钮、卡片、弹窗、弱文本对比度。"
        ),
        Skill(
            category: "调风格",
            stage: "评审时",
            icon: "🪞",
            title: "反 AI 味审美诊断",
            command: "$i-critique",
            detail: "模板感、廉价感、泛化设计",
            prompt: "请使用 $i-critique，专门从“反 AI 味”和审美可信度角度评审当前界面。请指出哪些地方显得模板化、泛化、廉价、过度平均或像默认 AI 产物；再给出优先级最高的 3-5 个改法。先不要直接改代码。"
        ),
        Skill(
            category: "调风格",
            stage: "开始前",
            icon: "🖼️",
            title: "参考图风格提炼",
            command: "$i-impeccable",
            detail: "从灵感图提取可用设计语言",
            prompt: "请使用 $i-impeccable extract，基于我给的参考图或视觉灵感，提炼它的设计语言。请总结：色彩氛围、字体气质、留白节奏、组件形状、插画/图标语法、情绪关键词，以及哪些适合迁移到当前产品、哪些不适合照搬。先输出风格提炼，不要直接改代码。"
        ),
        Skill(
            category: "调风格",
            stage: "打磨中",
            icon: "💎",
            title: "普通页面变高级",
            command: "$i-bolder",
            detail: "保留可用性，提升气质记忆点",
            prompt: "请使用 $i-bolder，把当前页面从“能用但普通”提升到更有审美记忆点。请重点优化视觉层级、节奏、主视觉、空白、组件质感和关键动作存在感；不要堆渐变、装饰和大而空的 hero。先指出普通感来自哪里，再小步修改。"
        ),
        Skill(
            category: "交互",
            stage: "开发中",
            icon: "〰️",
            title: "动效微交互",
            command: "$i-animate",
            detail: "点击、loading、结果出现、弹窗",
            prompt: "请使用 $i-animate，为当前功能增加或优化动效和微交互。重点是点击反馈、loading、结果出现、弹窗开合、按钮状态。动效要自然、有目的，不要炫技。"
        ),
        Skill(
            category: "交互",
            stage: "打磨中",
            icon: "🌟",
            title: "愉悦感细节",
            command: "$i-delight",
            detail: "情绪峰值、记忆点、小惊喜",
            prompt: "请使用 $i-delight，给当前体验增加一点记忆点和愉悦感。请围绕用户完成核心动作时的情绪峰值设计，不要堆装饰。"
        ),
        Skill(
            category: "收敛",
            stage: "收尾时",
            icon: "✂️",
            title: "简化去噪",
            command: "$i-distill",
            detail: "删掉不必要的元素和流程",
            prompt: "请使用 $i-distill，帮我简化当前功能和界面。请指出哪些元素、文案、交互或视觉装饰可以删掉，让核心体验更清楚。先给清单，再小步执行。"
        ),
        Skill(
            category: "适配",
            stage: "开发中",
            icon: "📱",
            title: "移动端适配",
            command: "$i-adapt",
            detail: "手机高度、微信浏览器、安全区",
            prompt: "请使用 $i-adapt，检查并优化移动端适配。重点看不同手机高度、微信内置浏览器、安全区、按钮触控区域、一屏呈现、文本是否挤压或重叠。"
        ),
        Skill(
            category: "工程",
            stage: "上线前",
            icon: "⚡️",
            title: "性能顺滑度",
            command: "$i-optimize",
            detail: "动画、重绘、资源、卡顿",
            prompt: "请使用 $i-optimize，检查当前页面的性能和顺滑度。重点看动画是否 60fps、是否有不必要重绘、移动端是否卡顿、资源是否过重。"
        ),
        Skill(
            category: "工程",
            stage: "上线前",
            icon: "✅",
            title: "可访问性/技术审计",
            command: "$i-audit",
            detail: "对比度、键盘、ARIA、控制台错误",
            prompt: "请使用 $i-audit，做一次技术质量审计。重点检查可访问性、对比度、键盘操作、ARIA、移动端兼容、性能、控制台错误。给出 P0-P3 问题和修复建议。"
        ),
        Skill(
            category: "工程",
            stage: "上线前",
            icon: "🛡️",
            title: "真实场景加固",
            command: "$i-harden",
            detail: "空状态、错误、长文本、边界情况",
            prompt: "请使用 $i-harden，把当前界面加固到更接近真实可用。重点检查空状态、错误状态、长文本溢出、极端内容、加载失败、国际化长度、移动端边界情况。先列出风险，再小步修复。"
        ),
        Skill(
            category: "适配上线",
            stage: "交付前",
            icon: "📦",
            title: "开发交付 Brief",
            command: "$i-handoff",
            detail: "组件、状态、边界、设计意图",
            prompt: "请使用 $i-handoff，把当前页面/功能整理成开发或 AI 继续实现可用的交付 brief。请包含：功能目标、用户路径、页面结构、组件清单、状态清单、响应式要求、可访问性要求、不能改坏的设计意图，以及建议的实现顺序。"
        ),
        Skill(
            category: "适配上线",
            stage: "上线前",
            icon: "🧾",
            title: "验收标准清单",
            command: "$i-handoff",
            detail: "可测试的上线检查项",
            prompt: "请使用 $i-handoff，为当前功能整理一份上线前验收标准。请写成可勾选清单，覆盖视觉一致性、交互状态、移动端、安全区、空/错/loading 状态、文案、可访问性、性能和真实边界情况。每条标准都要能被实际验证。"
        ),
        Skill(
            category: "设计",
            stage: "打磨中",
            icon: "🚀",
            title: "视觉更大胆",
            command: "$i-bolder",
            detail: "太平、太安全、缺少记忆点",
            prompt: "请使用 $i-bolder，让当前设计更有视觉冲击和记忆点。请保持可用性，不要变花哨；重点增强主视觉、层级、节奏和关键动作的存在感。先指出现在为什么显得平，再动手修改。"
        ),
        Skill(
            category: "设计",
            stage: "打磨中",
            icon: "🌙",
            title: "视觉降噪变安静",
            command: "$i-quieter",
            detail: "太吵、太满、太抢注意力",
            prompt: "请使用 $i-quieter，把当前界面调得更安静、更克制、更高级。请降低过强的颜色、阴影、动效和装饰，但保留核心层级和可用性。先指出哪些地方太吵，再小步调整。"
        ),
        Skill(
            category: "交互",
            stage: "打磨中",
            icon: "🪄",
            title: "惊艳实验模式",
            command: "$i-overdrive",
            detail: "高级动效、技术野心、wow moment",
            prompt: "请使用 $i-overdrive，探索一个更惊艳的高完成度版本。可以考虑更强的动效、沉浸式交互、3D/Canvas/Shader 或更复杂的状态编排，但必须服务核心体验。先给方向和风险，再实现最值得的部分。"
        ),
        Skill(
            category: "设计",
            stage: "开始前",
            icon: "🖌️",
            title: "从零做精致界面",
            command: "$i-impeccable",
            detail: "完整页面、组件、产品化界面",
            prompt: "请使用 $i-impeccable craft，为这个功能做一个高质量、可运行、避免 AI 味的界面实现。先确认目标用户、使用场景和设计方向，再开始写代码。"
        ),
        Skill(
            category: "流程",
            stage: "开始前",
            icon: "🧩",
            title: "一条龙：先需求再评审再打磨",
            command: "flow",
            detail: "适合新功能开局",
            prompt: "请按这个顺序帮我推进：1. 使用 $i-shape 先理清产品需求和用户路径；2. 使用 $i-critique 做 UI/UX 评审；3. 根据评审结果选择 $i-typeset / $i-layout / $i-polish 做修改。先不要一上来写代码，先告诉我你理解的目标和优先级。"
        ),
        Skill(
            category: "复盘沉淀",
            stage: "收尾时",
            icon: "🧠",
            title: "AI 协作复盘",
            command: "$i-recap",
            detail: "让新对话别重复踩坑",
            prompt: "请使用 $i-recap，帮我做一次 AI 协作复盘。请总结这次过程中 AI 起初误解了什么、遇到过什么问题、后来怎么解决、哪些文件/命令/决策以后新开对话必须告诉 AI，以及下次开局可以直接贴给 AI 的上下文 brief。"
        ),
        Skill(
            category: "复盘沉淀",
            stage: "收尾时",
            icon: "✍️",
            title: "设计思路复盘",
            command: "$i-recap",
            detail: "记录判断、取舍和学到的东西",
            prompt: "请使用 $i-recap，帮我做一次设计思路复盘。请按时间线整理：最初的问题、我为什么不满意、关键审美/产品判断是什么、哪些尝试被放弃、最终方案为什么更好、我从中学到了什么。语气可以像写给未来自己的设计笔记。"
        ),
        Skill(
            category: "复盘沉淀",
            stage: "收尾时",
            icon: "📝",
            title: "下次开局上下文",
            command: "$i-recap",
            detail: "给新窗口的一段项目说明",
            prompt: "请使用 $i-recap，帮我生成一份可以直接贴到新 AI 对话里的项目上下文。请包含：项目目标、当前版本、重要文件路径、设计方向、已经确定不能改坏的体验、已解决的问题、仍待处理的问题、下一步建议。要求短而完整。"
        ),
        Skill(
            category: "复盘沉淀",
            stage: "收尾时",
            icon: "📣",
            title: "社交媒体整理",
            command: "$i-recap",
            detail: "把项目过程写成分享内容",
            prompt: "请使用 $i-recap，帮我把这个项目过程整理成一篇适合发社交媒体的设计/AI 协作分享。请保留真实转折和学习，不要写成营销稿；结构包含：我想解决什么、过程中踩到什么坑、关键转折、最后沉淀的方法、对其他设计师有什么启发。"
        )
    ]
}

struct SceneGroup: Identifiable {
    let id: String
    let title: String
    let subtitle: String
    let icon: String
}

let sceneGroups: [SceneGroup] = [
    SceneGroup(id: "全部", title: "全部", subtitle: "所有提示词", icon: "command"),
    SceneGroup(id: "想清楚", title: "想清楚", subtitle: "需求目标路径", icon: "diamond"),
    SceneGroup(id: "找问题", title: "找问题", subtitle: "评审和诊断", icon: "magnifyingglass"),
    SceneGroup(id: "定系统", title: "定系统", subtitle: "风格规则一致", icon: "pin"),
    SceneGroup(id: "调排版", title: "调排版", subtitle: "字体布局文案", icon: "text.alignleft"),
    SceneGroup(id: "调风格", title: "调风格", subtitle: "色彩质感性格", icon: "paintpalette"),
    SceneGroup(id: "调交互", title: "调交互", subtitle: "动效反馈惊喜", icon: "waveform"),
    SceneGroup(id: "适配上线", title: "适配上线", subtitle: "手机性能加固", icon: "checkmark.seal"),
    SceneGroup(id: "复盘沉淀", title: "复盘沉淀", subtitle: "去噪和记下来", icon: "scissors")
]

extension Skill {
    var scene: String {
        if sceneGroups.contains(where: { $0.id == category }) {
            return category
        }

        switch command {
        case "$i-shape", "$i-impeccable", "flow":
            return "想清楚"
        case "$i-critique", "$i-web-interact", "$i-app-interact":
            return "找问题"
        case "$i-system", "$i-consistency":
            return "定系统"
        case "$i-typeset", "$i-layout", "$i-clarify":
            return "调排版"
        case "$i-colorize", "$i-bolder", "$i-quieter", "$i-polish":
            return "调风格"
        case "$i-animate", "$i-delight", "$i-overdrive":
            return "调交互"
        case "$i-adapt", "$i-optimize", "$i-audit", "$i-harden", "$i-handoff":
            return "适配上线"
        case "$i-distill", "$i-recap":
            return "复盘沉淀"
        default:
            return category
        }
    }
}

struct PaletteColors {
    static let ink = Color(red: 0.22, green: 0.19, blue: 0.27)
    static let body = Color(red: 0.39, green: 0.35, blue: 0.43)
    static let muted = Color(red: 0.53, green: 0.48, blue: 0.57)
    static let faint = Color(red: 0.68, green: 0.62, blue: 0.71)
    static let panel = Color(red: 1.00, green: 0.985, blue: 0.992)
    static let rose = Color(red: 0.95, green: 0.43, blue: 0.56)
    static let roseSoft = Color(red: 1.00, green: 0.88, blue: 0.92)
    static let purple = Color(red: 0.50, green: 0.40, blue: 0.61)
    static let stroke = Color(red: 0.76, green: 0.67, blue: 0.78).opacity(0.18)
}

enum AppVersion {
    static let display = "v1.0"
    static let windowTitle = "AI Skill Palette v1.0"
}

struct SkillPaletteView: View {
    let onClose: () -> Void
    @State private var query = ""
    @State private var selectedScene = "全部"
    @State private var copiedTitle: String?

    private var filteredSkills: [Skill] {
        let q = query.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        return PromptStore.skills.filter { skill in
            if !q.isEmpty {
                return [skill.title, skill.command, skill.detail, skill.prompt, skill.scene].contains { $0.lowercased().contains(q) }
            }

            return selectedScene == "全部" || skill.scene == selectedScene
        }
    }

    var body: some View {
        ZStack {
            PaletteColors.panel.ignoresSafeArea()

            VStack(spacing: 0) {
                header
                    .padding(.horizontal, 22)
                    .padding(.top, 18)
                    .padding(.bottom, 14)

                HStack(spacing: 16) {
                    sidebar
                        .frame(width: 166)

                    VStack(spacing: 12) {
                        searchBar
                        skillList
                    }
                }
                .padding(.horizontal, 18)
                .padding(.bottom, 18)
            }

            VStack {
                HStack {
                    Spacer()
                    closeButton
                }
                Spacer()
            }
            .padding(.top, 18)
            .padding(.trailing, 22)

            if let copiedTitle {
                VStack {
                    Spacer()
                    copiedToast(title: copiedTitle)
                        .padding(.bottom, 24)
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .frame(width: 720, height: 620)
        .onAppear {
            selectedScene = "全部"
            query = ""
        }
    }

    private var header: some View {
        HStack(alignment: .top, spacing: 14) {
            VStack(alignment: .leading, spacing: 7) {
                HStack(alignment: .firstTextBaseline, spacing: 8) {
                    Text("灵感指令台")
                        .font(.custom("PingFang SC", size: 25).weight(.semibold))
                        .foregroundStyle(PaletteColors.ink)

                    Text(AppVersion.display)
                        .font(.custom("PingFang SC", size: 12).weight(.medium))
                        .foregroundStyle(PaletteColors.muted)
                        .padding(.horizontal, 7)
                        .padding(.vertical, 3)
                        .background(Color.white.opacity(0.7), in: Capsule())
                }

                Text("给 UX / 产品设计师的 AI 工作流指令台，复制后回 AI 输入框按 ⌘V。")
                    .font(.custom("PingFang SC", size: 12.5).weight(.regular))
                    .foregroundStyle(PaletteColors.muted)
                    .lineLimit(1)
            }

            Spacer()
        }
    }

    private var closeButton: some View {
        Button {
            onClose()
        } label: {
            Image(systemName: "xmark")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(PaletteColors.body)
                .frame(width: 34, height: 34)
                .background(Color.white.opacity(0.76), in: Circle())
                .overlay(
                    Circle()
                        .stroke(PaletteColors.stroke, lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
        .help("关闭")
    }

    private var sidebar: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("问题场景")
                .font(.custom("PingFang SC", size: 12).weight(.medium))
                .foregroundStyle(PaletteColors.muted)
                .padding(.horizontal, 10)
                .padding(.bottom, 2)

            VStack(alignment: .leading, spacing: 5) {
                ForEach(sceneGroups) { group in
                    let isSelected = selectedScene == group.id

                    SidebarRow(group: group, isSelected: isSelected) {
                        selectedScene = group.id
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Spacer()
        }
        .padding(10)
        .background(Color.white.opacity(0.54), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(PaletteColors.stroke, lineWidth: 1)
        )
    }

    private var searchBar: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(PaletteColors.muted)
            TextField("全局搜索：需求、评审、字体、布局、动效、复盘...", text: $query)
                .textFieldStyle(.plain)
                .font(.custom("PingFang SC", size: 14).weight(.regular))
                .foregroundStyle(PaletteColors.ink)
        }
        .padding(.horizontal, 14)
        .frame(height: 42)
        .background(Color.white.opacity(0.76), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(PaletteColors.stroke, lineWidth: 1)
        )
    }

    private var skillList: some View {
        ScrollView {
            LazyVStack(spacing: 8) {
                if filteredSkills.isEmpty {
                    emptyState
                } else {
                    ForEach(filteredSkills, id: \.title) { skill in
                        skillCard(skill)
                    }
                }
            }
            .padding(.vertical, 2)
        }
    }

    private var emptyState: some View {
        VStack(spacing: 8) {
            Text("没有找到对应提示词")
                .font(.custom("PingFang SC", size: 14).weight(.semibold))
                .foregroundStyle(PaletteColors.ink)
            Text("换一个关键词，比如“评审”“字体”“移动端”。")
                .font(.custom("PingFang SC", size: 12).weight(.regular))
                .foregroundStyle(PaletteColors.muted)
        }
        .frame(maxWidth: .infinity, minHeight: 160)
        .background(Color.white.opacity(0.52), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
    }

    private func skillCard(_ skill: Skill) -> some View {
        let isCopied = copiedTitle == skill.title

        return SkillCardRow(skill: skill, isCopied: isCopied) {
            copy(skill)
        }
    }

    private func copiedToast(title: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 14, weight: .bold))
            Text("已复制：\(title)")
                .font(.custom("PingFang SC", size: 13).weight(.semibold))
            Text("回到 AI 输入框按 ⌘V")
                .font(.custom("PingFang SC", size: 12).weight(.regular))
                .opacity(0.82)
        }
        .foregroundStyle(.white)
        .padding(.horizontal, 18)
        .frame(height: 42)
        .background(Color(red: 0.30, green: 0.24, blue: 0.36).opacity(0.96), in: Capsule())
        .shadow(color: .black.opacity(0.18), radius: 18, x: 0, y: 10)
    }

    private func copy(_ skill: Skill) {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(skill.prompt, forType: .string)
        withAnimation(.easeOut(duration: 0.18)) {
            copiedTitle = skill.title
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.4) {
            withAnimation(.easeOut(duration: 0.18)) {
                if copiedTitle == skill.title {
                    copiedTitle = nil
                }
            }
        }
    }
}

struct SidebarRow: View {
    let group: SceneGroup
    let isSelected: Bool
    let onSelect: () -> Void

    @State private var isHovering = false
    @GestureState private var isPressing = false

    var body: some View {
        HStack(spacing: 10) {
            sidebarIcon

            VStack(alignment: .leading, spacing: 2) {
                Text(group.title)
                    .font(.custom("PingFang SC", size: 13).weight(.medium))
                    .foregroundStyle(isSelected ? PaletteColors.ink : PaletteColors.body)
                    .lineLimit(1)
                Text(group.subtitle)
                    .font(.custom("PingFang SC", size: 10.5).weight(.regular))
                    .foregroundStyle(isSelected ? PaletteColors.muted : PaletteColors.faint)
                    .lineLimit(1)
            }

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 10)
        .frame(width: 146, height: 48, alignment: .leading)
        .background(rowBackground, in: RoundedRectangle(cornerRadius: 15, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .stroke(rowStroke, lineWidth: isHovering || isSelected || isPressing ? 1 : 0)
        )
        .shadow(color: Color(red: 0.32, green: 0.25, blue: 0.39).opacity(rowShadowOpacity), radius: isHovering ? 9 : 0, x: 0, y: isHovering ? 4 : 0)
        .scaleEffect(isPressing ? 0.988 : 1.0)
        .offset(y: isHovering && !isPressing ? -0.5 : 0)
        .contentShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
        .onHover { hovering in
            withAnimation(.easeOut(duration: 0.12)) {
                isHovering = hovering
            }
        }
        .gesture(
            DragGesture(minimumDistance: 0)
                .updating($isPressing) { _, state, _ in
                    state = true
                }
                .onEnded { _ in
                    onSelect()
                }
        )
        .animation(.easeOut(duration: 0.14), value: isSelected)
        .animation(.easeOut(duration: 0.10), value: isPressing)
        .accessibilityElement(children: .ignore)
        .accessibilityAddTraits(.isButton)
        .accessibilityLabel("\(group.title)，\(group.subtitle)")
    }

    private var rowBackground: Color {
        if isSelected {
            return PaletteColors.roseSoft.opacity(isPressing ? 0.78 : 0.62)
        }
        if isHovering || isPressing {
            return Color.white.opacity(isPressing ? 0.80 : 0.68)
        }
        return Color.clear
    }

    private var rowStroke: Color {
        if isSelected {
            return PaletteColors.rose.opacity(0.16)
        }
        return PaletteColors.stroke.opacity(isHovering || isPressing ? 1.8 : 1.0)
    }

    private var rowShadowOpacity: Double {
        if isSelected {
            return 0.018
        }
        if isHovering || isPressing {
            return 0.035
        }
        return 0
    }

    private var sidebarIcon: some View {
        Image(systemName: group.icon)
            .font(.system(size: 12, weight: .semibold))
            .symbolRenderingMode(.monochrome)
            .foregroundStyle(isSelected ? PaletteColors.rose : PaletteColors.muted)
            .frame(width: 25, height: 25)
            .background(iconBackground, in: Circle())
    }

    private var iconBackground: Color {
        if isSelected {
            return Color.white.opacity(0.88)
        }
        return Color.white.opacity(0.42)
    }
}

struct SkillCardRow: View {
    let skill: Skill
    let isCopied: Bool
    let onCopy: () -> Void

    @State private var isHovering = false
    @GestureState private var isPressing = false

    var body: some View {
        HStack(alignment: .center, spacing: 13) {
            skillIcon

            VStack(alignment: .leading, spacing: 7) {
                HStack(alignment: .top, spacing: 10) {
                    Text(skill.title)
                        .font(.custom("PingFang SC", size: 15).weight(.semibold))
                        .foregroundStyle(PaletteColors.ink)
                        .lineLimit(1)
                    Spacer()
                    copyBadge
                }

                Text(skill.detail)
                    .font(.custom("PingFang SC", size: 12.5).weight(.regular))
                    .foregroundStyle(PaletteColors.body)
                    .lineLimit(1)

                HStack(spacing: 6) {
                    Text(skill.scene)
                        .font(.custom("PingFang SC", size: 10.5).weight(.regular))
                    Text("·")
                    Text(skill.command)
                        .font(.system(size: 10.5, weight: .medium, design: .monospaced))
                }
                .foregroundStyle(PaletteColors.faint)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(cardBackground, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(cardStroke, lineWidth: isHovering || isCopied ? 1 : 0.8)
        )
        .shadow(color: Color(red: 0.32, green: 0.25, blue: 0.39).opacity(shadowOpacity), radius: isHovering ? 15 : 12, x: 0, y: isHovering ? 8 : 6)
        .scaleEffect(isPressing ? 0.992 : 1.0)
        .offset(y: isHovering && !isPressing ? -1 : 0)
        .contentShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .onHover { hovering in
            withAnimation(.easeOut(duration: 0.13)) {
                isHovering = hovering
            }
        }
        .gesture(
            DragGesture(minimumDistance: 0)
                .updating($isPressing) { _, state, _ in
                    state = true
                }
                .onEnded { _ in
                    onCopy()
                }
        )
        .animation(.easeOut(duration: 0.14), value: isCopied)
        .animation(.easeOut(duration: 0.10), value: isPressing)
        .help("点击复制：\(skill.title)")
        .accessibilityElement(children: .ignore)
        .accessibilityAddTraits(.isButton)
        .accessibilityLabel("复制 \(skill.title)")
    }

    private var cardBackground: Color {
        if isCopied {
            return PaletteColors.roseSoft.opacity(isPressing ? 0.82 : 0.72)
        }
        if isHovering || isPressing {
            return Color.white.opacity(isPressing ? 0.92 : 0.90)
        }
        return Color.white.opacity(0.84)
    }

    private var cardStroke: Color {
        if isCopied {
            return PaletteColors.rose.opacity(0.34)
        }
        if isHovering || isPressing {
            return PaletteColors.rose.opacity(0.14)
        }
        return PaletteColors.stroke
    }

    private var shadowOpacity: Double {
        if isCopied {
            return 0.08
        }
        if isHovering || isPressing {
            return 0.065
        }
        return 0.042
    }

    private var skillIcon: some View {
        Text(skill.icon)
            .font(.system(size: 20))
            .frame(width: 38, height: 38)
            .background(iconBackground, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(Color.white.opacity(isCopied ? 0.82 : 0.70), lineWidth: 1)
            )
    }

    private var iconBackground: Color {
        if isCopied {
            return Color.white.opacity(0.68)
        }
        return Color.white.opacity(0.58)
    }

    private var copyBadge: some View {
        HStack(spacing: 4) {
            Image(systemName: isCopied ? "checkmark.circle.fill" : "doc.on.doc")
                .font(.system(size: 10.5, weight: .semibold))
            Text(isCopied ? "已复制" : "复制")
                .font(.custom("PingFang SC", size: 11).weight(.medium))
        }
        .foregroundStyle(isCopied ? PaletteColors.rose : PaletteColors.muted)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color.white.opacity(isCopied ? 0.74 : 0.54), in: Capsule())
    }
}

final class PaletteController: NSObject {
    private let panel: NSPanel

    override init() {
        panel = NSPanel(
            contentRect: NSRect(x: 0, y: 0, width: 720, height: 620),
            styleMask: [.nonactivatingPanel, .titled, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        super.init()
        configurePanel()
        installContentView()
    }

    func toggle() {
        if panel.isVisible {
            panel.orderOut(nil)
            return
        }
        show()
    }

    func show() {
        installContentView()
        if let screen = NSScreen.main {
            let frame = screen.visibleFrame
            let x = frame.midX - panel.frame.width / 2
            let y = frame.midY - panel.frame.height / 2
            panel.setFrameOrigin(NSPoint(x: x, y: y))
        }
        panel.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }

    private func installContentView() {
        panel.contentView = NSHostingView(rootView: SkillPaletteView { [weak panel] in
            panel?.orderOut(nil)
        })
    }

    private func configurePanel() {
        panel.title = AppVersion.windowTitle
        panel.isReleasedWhenClosed = false
        panel.level = .floating
        panel.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        panel.backgroundColor = NSColor(calibratedRed: 1, green: 0.96, blue: 0.98, alpha: 0.98)
        panel.titlebarAppearsTransparent = true
        panel.standardWindowButton(.miniaturizeButton)?.isHidden = true
        panel.standardWindowButton(.zoomButton)?.isHidden = true
    }
}

final class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem?
    private var palette: PaletteController?
    private var hotKeyRef: EventHotKeyRef?

    func applicationDidFinishLaunching(_ notification: Notification) {
        palette = PaletteController()
        setupStatusItem()
        setupHotkey()
        palette?.show()
    }

    private func setupStatusItem() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        statusItem?.button?.title = "⌘"
        statusItem?.button?.toolTip = "灵感指令台 / AI Skill Palette"

        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "显示 / 隐藏", action: #selector(togglePalette), keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "退出", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        statusItem?.menu = menu
    }

    private func setupHotkey() {
        let hotKeyID = EventHotKeyID(signature: OSType(0x4153504C), id: 1)
        let modifiers = UInt32(cmdKey | shiftKey)
        let keyCode = UInt32(kVK_ANSI_K)
        RegisterEventHotKey(keyCode, modifiers, hotKeyID, GetApplicationEventTarget(), 0, &hotKeyRef)

        var eventType = EventTypeSpec(eventClass: OSType(kEventClassKeyboard), eventKind: UInt32(kEventHotKeyPressed))
        InstallEventHandler(GetApplicationEventTarget(), { _, event, userData in
            guard let userData else { return noErr }
            let app = Unmanaged<AppDelegate>.fromOpaque(userData).takeUnretainedValue()
            app.palette?.toggle()
            return noErr
        }, 1, &eventType, Unmanaged.passUnretained(self).toOpaque(), nil)
    }

    @objc private func togglePalette() {
        palette?.toggle()
    }
}

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.setActivationPolicy(.accessory)
app.run()
