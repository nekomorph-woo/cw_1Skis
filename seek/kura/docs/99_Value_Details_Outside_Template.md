# Value Details Outside Template Scope

> **生成日期**: 2026-01-17
> **输入文件**: `brainstorm.md`
> **模板方案**: 方案 A + 方案 B
> **生成者**: Doc-Architect Skill

本文档记录了从原始头脑风暴文档中提取的、有价值但未包含在标准化模板中的内容，以便未来参考和迭代使用。

---

## Generation Context

- **Input File**: `D:/Coding/neko-codebase/cw_1Skis/seek/kura/brainstorm.md`
- **Template Scheme**: 方案 A (通用工程文档) + 方案 B (简化通用模板)
- **Generated On**: 2026-01-17
- **Total Source Tokens**: 34,944
- **Total Documents Generated**: 6

---

## Future Considerations

| 想法 | 描述 | 潜在价值 |
|------|-------------|------------|
| **模块市场机制** | 建立一个去中心化的微应用和模块市场，用户可以分享和发现他人的作品 | 从"工具"变成"平台"，形成生态效应 |
| **应用间通信** | 实现微应用之间的数据传递和消息通信机制 | 支持更复杂的工作流组合 |
| **视觉锚定模式** | 用户可以在截图上画圈标注，让 AI 理解上下文 | 对于不懂代码的用户更友好 |
| **离线模式** | 支持使用本地 AI 模型 (如 Ollama) 实现完全离线 | 保护隐私，无需网络 |
| **云端同步选项** | 除了 Git，提供端到端加密的云端同步选项 | 便利性和隐私的平衡 |
| **应用模板库** | 提供预制的应用模板，用户可以直接使用或修改 | 降低使用门槛 |
| **性能分析面板** | 显示每个应用的内存占用、CPU 使用情况 | 帮助用户优化资源使用 |
| **快捷键支持** | 为常用操作定义快捷键 | 提升效率 |
| **主题定制** | 允许用户自定义壳应用的主题和配色 | 个性化体验 |
| **多语言支持** | 国际化界面，支持多语言 | 扩大用户范围 |

---

## Alternative Approaches

| 方案 | 未采用原因 | 何时重新考虑 |
|------|------------|--------------|
| **Electron** | 体积大 (150MB+)、资源占用高 | 如果需要更强大的系统集成能力 |
| **纯 Web 应用 (无后端)** | 无法访问本地文件系统，功能受限 | 如果 File System Access API 功能更完善 |
| **Tauri** | 需要 Rust 知识，学习曲线陡峭 | 如果有团队熟悉 Rust 生态 |
| **云端 No-Code 平台** | 数据隐私问题，依赖服务器 | 如果用户不介意数据上云，需要协作功能 |
| **Vue/React 框架** | 需要构建步骤，不符合"零依赖"原则 | 如果微应用复杂度显著提高 |
| **Server-Side Rendering** | 增加后端复杂度，降低灵活性 | 如果需要 SEO 或首屏性能优化 |

---

## Implementation Details

| 细节 | 上下文 | 来源参考 |
|------|---------|-----------|
| **Bun 编译命令** | `bun build --compile --minify --sourcemap ./server.js --outfile VibeStation` | brainstorm.md 行 1175-1178 |
| **Import Maps 注入方式** | 动态拼接 HTML，在 `<head>` 中注入 `<script type="importmap">` | brainstorm.md 行 2196-2234 |
| **DOM 驻留实现** | 使用 Alpine.js 的 `x-show` 而非 `x-if`，保持 DOM 存在 | brainstorm.md 行 2559-2565 |
| **相对路径映射** | `@app/logic` 映射到 `./logic.js`，在每个 iframe 中解析为不同路径 | brainstorm.md 行 2292-2299 |
| **错误捕获机制** | 监听 iframe 的 `window.onerror`，提取错误信息发送给 AI | brainstorm.md 行 3012-3017 |
| **WebView 自动打开** | 使用 `spawn` 命令自动打开浏览器 (Windows: `msedge --app=...`) | brainstorm.md 行 3220-3226 |
| **Alpine 初始化** | 使用 `document.addEventListener('alpine:init')` 挂载数据 | brainstorm.md 行 2228-2230 |

---

## User Insights

| 洞察 | 来源 | 影响 |
|------|------|------------|
| **用户讨厌 Node.js** | 用户明确表示 "Node 很不喜欢" | 采用 Bun 作为运行时，避免 Node.js 生态 |
| **用户想要"双击即用"** | 用户希望直接双击 index.html 或 EXE 使用 | 提供 EXE 打包方案 |
| **用户关注数据隐私** | 用户提到 "保护隐私" 是核心需求 | 采用本地优先架构，数据不上云 |
| **用户想要模块化演进** | 用户主动提出模块化作为未来方向 | 提前设计 @shared 模块系统 |
| **用户认可 AI 能力** | 用户认为在"智能强的大模型上，简直小儿科" | 重点放在工程化落地，而非 AI 能力验证 |

---

## Edge Cases

| 场景 | 描述 | 处理考虑 |
|------|-------------|---------------------|
| **打开 50+ 标签页** | 用户同时打开大量应用 | 实现自动销毁最久未使用标签的策略 |
| **工作区路径不存在** | 用户配置的工作区路径被删除或移动 | 启动时检测，回退到默认路径并提示用户 |
| **AI 生成失败** | API 超时或返回错误 | 保留用户输入，提供重试按钮，显示友好错误信息 |
| **应用代码有语法错误** | AI 生成的代码无法运行 | 捕获错误，自动发送给 AI 修正 |
| **应用间 CSS 冲突** | 多个应用同时加载时的样式问题 | 使用 iframe 隔离，避免冲突 |
| **Git 合并冲突** | 多台电脑同步时出现冲突 | 提示用户手动解决，保留两个版本 |
| **网络断开时使用** | 无网络时 AI 功能不可用 | 显示离线模式提示，保留基本功能 |

---

## Dependencies

| 依赖 | 类型 | 影响 |
|------|------|------------|
| **Import Maps 浏览器支持** | 技术依赖 | 需要 Chrome 89+, Safari 16.4+ |
| **File System Access API** | 技术依赖 | 限制文件访问方式，需要用户授权 |
| **AI API 稳定性** | 服务依赖 | 影响核心功能 (代码生成) |
| **Bun 版本更新** | 技术依赖 | 可能引入 Breaking Changes |
| **WebView2 (Windows)** | 系统依赖 | Windows 10/11 系统自带 |
| **系统 Git 命令** | 外部依赖 | 用于版本控制和同步 |

---

## Open Questions

| 问题 | 优先级 | 建议解决方案 |
|------|--------|--------------|
| **Q1: 使用哪个 AI 模型？** | P0 | 支持用户自定义，默认推荐 GPT-4o 或 Claude 3.5 Sonnet |
| **Q2: 如何实现增量修改？** | P1 | 使用 AST 解析代码，定位修改位置，进行精准替换 |
| **Q3: 是否支持离线模式？** | P2 | 集成本地 AI 模型 (如 Ollama)，作为可选项 |
| **Q4: 模块市场的商业模式？** | P2 | 去中心化 (基于 Git) 或中心化 (官方市场) 待定 |
| **Q5: 如何处理应用版本升级？** | P2 | 使用 Git 管理版本，支持升级和回滚 |
| **Q6: 是否支持移动端？** | P2 | 使用 PWA 或 Tauri Mobile，长期计划 |
| **Q7: 如何衡量 AI 生成质量？** | P1 | 收集成功率、修正次数等指标 |
| **Q8: 是否提供应用调试工具？** | P2 | 集成浏览器 DevTools，提供简化版调试面板 |

---

## Code Snippets (保留备用)

### 1. Bun 服务器核心代码

```javascript
import { serve } from "bun";
import { readdir, write } from "node:fs/promises";
import { join } from "node:path";

const PORT = 3000;

serve({
  port: PORT,
  async fetch(req) {
    const url = new URL(req.url);

    // API: 获取应用列表
    if (url.pathname === "/api/apps") {
      const entries = await readdir("./workspace/apps", { withFileTypes: true });
      const apps = entries.filter(e => e.isDirectory()).map(e => e.name);
      return Response.json(apps);
    }

    // API: 保存文件
    if (url.pathname === "/api/save" && req.method === "POST") {
      const { path, content } = await req.json();
      await write(join("./workspace", path), content);
      return new Response("Saved");
    }

    // 静态文件服务
    return new Response("Not Found", { status: 404 });
  },
});
```

### 2. Import Maps 注入模板

```html
<script type="importmap">
{
  "imports": {
    "@shared/": "/api/shared/",
    "@app/logic": "./logic.js"
  }
}
</script>
```

### 3. Alpine 数据挂载

```javascript
import logic from '@app/logic';

document.addEventListener('alpine:init', () => {
  Alpine.data('app', logic);
});
```

### 4. DOM 锚定实现

```javascript
function enableInspector() {
  const iframe = document.getElementById('appFrame');
  const innerDoc = iframe.contentDocument;

  innerDoc.body.addEventListener('click', (e) => {
    e.preventDefault();
    const codeSnippet = e.target.outerHTML;
    sendToAI(prompt, context = codeSnippet);
  });
}
```

---

## Naming Alternatives (考虑但未采用)

| 名称 | 含义 | 是否采用 | 原因 |
|------|------|----------|------|
| **Kura (蔵)** | 日式仓库，存储和保护的象征 | ✅ 采用 | 符合项目定位，发音简洁 |
| **Cocoon (茧)** | 孵化、保护、蜕变 | ❌ 未采用 | 与 Kura 意象相近，但 Kura 更独特 |
| **Origami (折纸)** | 折纸，从纸张到成品的转化 | ❌ 未采用 | 虽有诗意，但不如 Kura 贴切 |
| **SparkBox (灵感盒)** | 灵感捕捉和存储 | ❌ 未采用 | 偏向工具而非平台 |
| **AtomOS (原子系统)** | 原子化、模块化 | ❌ 未采用 | "OS" 后缀容易被误解为操作系统 |

---

## Technical Decisions Rationale

| 决策 | 选择 | 理由 |
|------|------|------------|
| **运行时** | Bun | 极快性能、零依赖、内置打包 |
| **前端框架** | Alpine.js | 无需编译、文件极小、响应式强大 |
| **样式库** | Tailwind + DaisyUI | 标准化、AI 友好、开箱即用 |
| **模块系统** | Import Maps | 浏览器原生、无需构建工具 |
| **应用隔离** | iframe | 完美的样式和状态隔离 |
| **状态管理** | x-show (DOM 驻留) | 保持应用状态，切换快速 |

---

## References

### 外部资源

| 资源 | 链接 |
|------|------|
| Bun 官方文档 | https://bun.sh |
| Alpine.js 文档 | https://alpinejs.dev |
| Tailwind CSS 文档 | https://tailwindcss.com |
| DaisyUI 文档 | https://daisyui.com |
| Import Maps 规范 | https://github.com/WICG/import-maps |
| isomorphic-git | https://isomorphic-git.org |
| Electrobun | https://github.com/electrobun/electrobun |

### 内部文档

| 文档 | 路径 |
|------|------|
| 原始头脑风暴 | `brainstorm.md` |
| 关键点列表 | `00_Key_Points_List.md` |
| 结构化笔记 | `01_Structured_Notes.md` |
| PRD (方案 A) | `02_A_PRD.md` |
| 系统架构 (方案 A) | `03_A_System_Architecture.md` |
| API 文档 (方案 A) | `04_A_API_Documentation.md` |
| 问题定义 (方案 B) | `05_B_Problem_Definition.md` |
| 解决方案设计 (方案 B) | `06_B_Solution_Design.md` |
| 行动计划 (方案 B) | `07_B_Action_Plan.md` |

---

**统计摘要**

| 类别 | 数量 |
|------|------|
| 未来考虑 | 10 |
| 备选方案 | 5 |
| 实现细节 | 7 |
| 用户洞察 | 5 |
| 边缘情况 | 7 |
| 依赖项 | 6 |
| 未决问题 | 8 |

---

**下一步**: 进入 Phase 5，验证和修正生成的文档。
