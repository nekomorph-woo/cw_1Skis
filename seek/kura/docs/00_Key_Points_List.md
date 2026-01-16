# 关键点列表 - Kura (蔵) 项目

> 从 `brainstorm.md` 提取的核心信息点
>
> 生成时间: 2025-01-16

---

## 1. 项目名称与定位

### 候选名称
- **Kura (蔵)** - 日式"仓库"，寓意数据珍宝的存储和保护 ⭐ 推荐
- Cocoon (茧) - 孵化与保护
- Origami (折り紙) - 折纸，AI 生成代码的完美隐喻
- SparkBox - 灵感盒
- MindForge - 思维熔炉

### 项目定位
**本地优先的 AI 驱动微应用构造器平台**

- 本地化运行，保护隐私
- AI 快速生成满足小需求的微应用
- 支持 Git 同步到远端
- 模块化架构，支持公共模块复用
- 轻量化，无 Node.js 依赖

---

## 2. 核心概念

### 2.1 技术架构
**前后端分离架构**
- **后端 (Bun)**: 文件读写、API 服务、静态资源服务
- **前端 (浏览器)**: UI 渲染、交互逻辑、微应用运行

### 2.2 "两个大脑"模型
| 角色 | 位置 | 能力 | 限制 |
|------|------|------|------|
| 仓库管理员 (Bun) | 操作系统进程 | 读写文件、运行 Git | 无界面能力 |
| 柜台店员 (浏览器) | WebView 内核 | UI 渲染、事件处理 | 受沙箱限制 |

---

## 3. 技术栈选型

### 3.1 核心技术
| 组件 | 技术选型 | 理由 |
|------|----------|------|
| 后端运行时 | **Bun** | 高性能、轻量、可打包成 EXE |
| 前端框架 | **Alpine.js** | 轻量、响应式、无需编译 |
| 样式方案 | **Tailwind + DaisyUI** | 标准化、CDN 模式 |
| 模块系统 | **ES Modules + Import Maps** | 原生支持、无需构建工具 |

### 3.2 为什么选择 Bun？
1. **用 Zig 编写** - 直接调用操作系统内核，性能极高
2. **JavaScriptCore 引擎** - 启动快、内存占用低
3. **All-in-One 设计** - 打包器、编译器、运行时一体化
4. **可打包成 EXE** - `bun build --compile`

### 3.3 为什么不选 Node.js？
- 臃肿、生成大量 `node_modules`
- 启动慢、内存占用高
- 需要复杂构建工具链

---

## 4. 目录结构设计

### 4.1 标准工作区结构
```
/workspace
├── apps/              # 有界面的微应用 (UI)
│   ├── calculator/
│   │   ├── index.html
│   │   ├── logic.js
│   │   └── style.css (可选)
│   └── todo-list/
├── shared/            # 无界面的公共模块 (Headless)
│   ├── date-utils.js
│   ├── ai-sdk.js
│   └── theme.js
└── vibe-config.json   # 工作区配置
```

### 4.2 壳应用 (Kura Shell) 结构
```
KuraStation/
├── apps/              # 用户工作区 (可配置路径)
├── public/            # 壳应用前端
│   ├── index.html     # Dashboard 主界面
│   └── style.css
├── server.js          # Bun 服务器核心
├── VibeStation.exe    # 打包后的可执行文件
└── vibe-config.json   # 全局配置
```

---

## 5. Import Maps 模块化设计

### 5.1 核心理念
**浏览器的"本地 DNS"** - 将路径映射到虚拟命名空间

### 5.2 配置示例
```html
<script type="importmap">
{
  "imports": {
    "@shared/": "/api/shared-modules/",
    "@sys/": "/api/system-api/",
    "@app/logic": "./logic.js"
  }
}
</script>
```

### 5.3 使用方式
```javascript
// 无论应用在文件夹的哪一层，永远都能找到模块
import { formatDate } from "@shared/date-utils.js";
import { askAI } from "@sys/core.js";
```

### 5.4 优势
- **解耦**: 重构文件夹结构时只需改映射配置
- **清晰**: `@` 前缀明确标识外部依赖
- **标准化**: 符合现代浏览器原生标准

---

## 6. 微应用标准

### 6.1 标准文件结构
```
apps/calculator/
├── index.html      # 骨架 + Tailwind + Alpine 绑定
├── logic.js        # 纯业务逻辑 + 状态数据 (ES Module)
└── style.css       # (可选) 自定义样式
```

### 6.2 代码规范
**HTML (声明式)**
```html
<div x-data="app" class="p-10 card bg-base-100 shadow-xl">
    <h1 x-text="title"></h1>
    <button class="btn btn-primary" @click="increment()">+1</button>
</div>
```

**JS (响应式)**
```javascript
export default () => ({
    title: '我的超级计算器',
    count: 0,
    init() { console.log('应用已启动'); },
    increment() { this.count++; }
})
```

---

## 7. 多标签页设计

### 7.1 核心原则
**DOM 驻留 (Keep-Alive) + CSS 显隐切换**

### 7.2 实现方式
- 使用 `x-show` 而非 `x-if` - 只切换 `display: none`，不销毁 DOM
- 每个 Tab 对应一个 `<iframe>` - 完全隔离
- 状态保持 - 切换 Tab 时应用状态不丢失

### 7.3 数据结构
```javascript
{
    activeTabId: 'home',
    tabs: [
        { id: 'home', name: '主页', url: '/welcome.html', icon: '🏠' },
        { id: 'app-123', name: '计算器', url: '/apps/calculator/index.html', icon: '🧮' }
    ]
}
```

---

## 8. Server.js 核心路由

### 8.1 路由设计
| 路径 | 功能 | 处理 |
|------|------|------|
| `/` | 壳应用主页 | 返回 `dashboard.html` |
| `/apps/*/index.html` | 微应用主页 | 注入标准头部后返回 |
| `/apps/*` | 微应用资源 | 直接返回文件 |
| `/api/shared/*` | 公共模块 | 映射到 `/workspace/shared/*` |
| `/api/workspace` | 工作区管理 | GET/POST 配置 |

### 8.2 HTML 注入机制
当请求微应用 HTML 时，Server 自动注入：
1. Import Maps 配置
2. Tailwind + DaisyUI CDN
3. Alpine.js CDN
4. 自动挂载逻辑脚本

---

## 9. 动态工作区设计

### 9.1 配置文件
```json
{
    "workspace": "./apps"  // 可配置为任意绝对路径
}
```

### 9.2 特点
- 工作区路径可动态配置
- 支持切换不同项目文件夹
- 持久化存储配置
- 非侵入性设计

---

## 10. 部署方案

### 10.1 开发阶段
```bash
bun run server.js
# 浏览器打开 http://localhost:3000
```

### 10.2 打包成 EXE
```bash
bun build --compile --minify ./server.js --outfile VibeStation
```

### 10.3 交付结构
```
VibeStation/
├── apps/               # 用户工作区
├── public/             # 壳应用 UI
└── VibeStation.exe     # 自带 Bun 引擎的启动器 (~90MB)
```

### 10.4 原生窗口方案
**方案 A**: Edge `--app` 模式 (快速)
```javascript
Bun.spawn(["msedge", `--app=http://localhost:3000`]);
```

**方案 B**: Electrobun/WebView (推荐)
- 真正的原生窗口
- 体积更小 (30-50MB)
- 独立图标和任务栏

---

## 11. AI 代码生成策略

### 11.1 核心难点
1. **前后端边界模糊** - AI 易混淆 Bun API 和浏览器 API
2. **增量修改** - "手术刀级"精准修改 vs 全量重写
3. **调试闭环** - 如何捕获并反馈错误给 AI

### 11.2 解决方案
1. **强约束 DSL** - 给 AI 提供固定模板
2. **元数据优先** - 先生成 `manifest.json` 确认需求
3. **上下文注入** - 每次请求附带《Kura 开发文档》
4. **DOM 锚定** - 点击元素获取精确代码上下文

### 11.3 上下文精确化
**方案一**: DOM 锚定 (推荐)
```javascript
// 获取用户点击的元素代码
const codeSnippet = targetEl.outerHTML;
// 发送给 AI: "把这个选中的元素改为红色"
```

**方案二**: 视觉锚定
- 截图 + 画圈标记
- 利用 GPT-4o 视觉能力
- 适合布局和美感调整

---

## 12. 业务价值演进

### 12.1 阶段一: 工具箱 (Utility Box)
- 主打: 快
- 场景: 格式转换、正则提取、简单计算

### 12.2 阶段二: 工作流引擎 (Workflow)
- 主打: 连接
- 核心: 应用 A 输出 → 应用 B 输入

### 12.3 阶段三: 私有生态 (Ecosystem)
- 主打: 共享
- 核心: 基于 Git 的微应用市场

---

## 13. 关键决策点

### 13.1 已确定
- ✅ 项目名称: Kura (蔵)
- ✅ 后端: Bun
- ✅ 前端: Alpine.js + Tailwind + DaisyUI
- ✅ 模块化: Import Maps
- ✅ 架构: 前后端分离 + iframe 隔离

### 13.2 待讨论
- ⏳ AI Provider 选择 (OpenAI / DeepSeek / Claude)
- ⏳ 打包方案最终选择 (Edge --app vs Electrobun)
- ⏳ 模块市场实现机制
- ⏳ 应用间通信协议

---

## 14. 问题点清单

### 14.1 技术问题
- [ ] 如何实现 iframe 间的高效通信？
- [ ] 如何处理大量 Tab 打开的内存问题？
- [ ] 如何实现 AI 代码的错误自动修复？

### 14.2 架构问题
- [ ] 公共模块版本冲突如何处理？
- [ ] 如何实现应用的热更新？
- [ ] 如何设计应用间的依赖声明？

### 14.3 产品问题
- [ ] 如何降低非技术用户的使用门槛？
- [ ] 如何设计 AI 交互的最佳体验？
- [ ] 如何建立微应用的质量标准？

---

## 15. 新概念/术语表

| 术语 | 英文 | 解释 |
|------|------|------|
| 仓库管理员 | Warehouse Manager | Bun 后端，负责文件操作 |
| 柜台店员 | Shop Assistant | 浏览器前端，负责 UI 展示 |
| Import Maps | 导入映射 | 浏览器原生模块路径映射机制 |
| DOM 驻留 | Keep-Alive | 切换时不销毁 DOM，只隐藏 |
| 视觉锚定 | Visual Grounding | 通过截图+画圈辅助 AI 理解上下文 |
| Just-in-Time Software | 即时软件 | 需要时生成，用完即走的软件模式 |

---

*文档版本: 1.0*
*提取源文件: `seek/kura/brainstorm.md`*
