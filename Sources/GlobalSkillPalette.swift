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
            category: "需求",
            stage: "开始前",
            icon: "🧭",
            title: "产品经理需求梳理",
            command: "$i-shape",
            detail: "用户、场景、路径、优先级",
            prompt: "请使用 $i-shape，以产品经理视角帮我理清这个功能需求。先不要写代码，先帮我梳理：目标用户、核心场景、用户路径、必须保留的体验、可以砍掉的复杂度、以及你认为更好的产品建议。最后给我一个清晰的需求 brief 和下一步执行建议。"
        ),
        Skill(
            category: "评审",
            stage: "评审时",
            icon: "🔍",
            title: "UI/UX 设计评审",
            command: "$i-critique",
            detail: "层级、信息、情绪、反 AI 味",
            prompt: "请使用 $i-critique，对当前页面/功能做一次 UI/UX 设计评审。请从视觉层级、信息架构、移动端体验、交互反馈、情绪感受、反 AI 味、可用性问题来评估。先给评分和优先级问题，不要直接改代码。"
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
    SceneGroup(id: "调排版", title: "调排版", subtitle: "字体布局文案", icon: "text.alignleft"),
    SceneGroup(id: "调风格", title: "调风格", subtitle: "色彩质感性格", icon: "paintpalette"),
    SceneGroup(id: "调交互", title: "调交互", subtitle: "动效反馈惊喜", icon: "waveform"),
    SceneGroup(id: "适配上线", title: "适配上线", subtitle: "手机性能加固", icon: "checkmark.seal"),
    SceneGroup(id: "删减沉淀", title: "删减沉淀", subtitle: "去噪和复盘", icon: "scissors")
]

extension Skill {
    var scene: String {
        switch command {
        case "$i-shape", "$i-impeccable", "flow":
            return "想清楚"
        case "$i-critique":
            return "找问题"
        case "$i-typeset", "$i-layout", "$i-clarify":
            return "调排版"
        case "$i-colorize", "$i-bolder", "$i-quieter", "$i-polish":
            return "调风格"
        case "$i-animate", "$i-delight", "$i-overdrive":
            return "调交互"
        case "$i-adapt", "$i-optimize", "$i-audit", "$i-harden":
            return "适配上线"
        case "$i-distill":
            return "删减沉淀"
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
        .frame(width: 720, height: 600)
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

                    HStack(spacing: 10) {
                        sidebarIcon(group.icon, isSelected: isSelected)
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
                    .frame(maxWidth: .infinity, minHeight: 48, maxHeight: 48, alignment: .leading)
                    .background(isSelected ? PaletteColors.roseSoft.opacity(0.62) : Color.clear, in: RoundedRectangle(cornerRadius: 15, style: .continuous))
                    .contentShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                    .onTapGesture {
                        selectedScene = group.id
                    }
                    .accessibilityElement(children: .ignore)
                    .accessibilityAddTraits(.isButton)
                    .accessibilityLabel("\(group.title)，\(group.subtitle)")
                }
            }

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
            TextField("全局搜索：需求、评审、字体、布局、动效...", text: $query)
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

        return Button {
            copy(skill)
        } label: {
            HStack(alignment: .center, spacing: 13) {
                skillIcon(skill.icon, isCopied: isCopied)

                VStack(alignment: .leading, spacing: 7) {
                    HStack(alignment: .top, spacing: 10) {
                        Text(skill.title)
                            .font(.custom("PingFang SC", size: 15).weight(.semibold))
                            .foregroundStyle(PaletteColors.ink)
                            .lineLimit(1)
                        Spacer()
                        copyBadge(isCopied: isCopied)
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
            .background((isCopied ? PaletteColors.roseSoft.opacity(0.72) : Color.white.opacity(0.84)), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(isCopied ? PaletteColors.rose.opacity(0.34) : PaletteColors.stroke, lineWidth: 1)
            )
            .shadow(color: Color(red: 0.32, green: 0.25, blue: 0.39).opacity(isCopied ? 0.075 : 0.042), radius: 12, x: 0, y: 6)
            .contentShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
        .buttonStyle(.plain)
        .help("点击复制：\(skill.title)")
    }

    private func sidebarIcon(_ name: String, isSelected: Bool) -> some View {
        Image(systemName: name)
            .font(.system(size: 12, weight: .semibold))
            .symbolRenderingMode(.monochrome)
            .foregroundStyle(isSelected ? PaletteColors.rose : PaletteColors.muted)
            .frame(width: 25, height: 25)
            .background(isSelected ? Color.white.opacity(0.88) : Color.white.opacity(0.42), in: Circle())
    }

    private func skillIcon(_ name: String, isCopied: Bool) -> some View {
        Text(name)
            .font(.system(size: 20))
            .frame(width: 38, height: 38)
            .background((isCopied ? Color.white.opacity(0.68) : Color.white.opacity(0.58)), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(Color.white.opacity(0.70), lineWidth: 1)
            )
    }

    private func copyBadge(isCopied: Bool) -> some View {
        HStack(spacing: 4) {
            Image(systemName: isCopied ? "checkmark.circle.fill" : "doc.on.doc")
                .font(.system(size: 10.5, weight: .semibold))
            Text(isCopied ? "已复制" : "复制")
                .font(.custom("PingFang SC", size: 11).weight(.medium))
        }
        .foregroundStyle(isCopied ? PaletteColors.rose : PaletteColors.muted)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color.white.opacity(isCopied ? 0.72 : 0.54), in: Capsule())
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

final class PaletteController: NSObject {
    private let panel: NSPanel

    override init() {
        panel = NSPanel(
            contentRect: NSRect(x: 0, y: 0, width: 720, height: 600),
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
