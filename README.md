
Line Spin
----

### 使用者影响

默认几何参数、滑块、拖拽点和原服务器目录保持不变。升级后请重启开发服务并刷新页面，不沿用旧 procs 或 Vite 缓存。
线段结果现在是固定 `start` / `end` 字段的 `Trail`，不再对必需坐标做可选 Map 查询；原回归的四组坐标与零步数结果不变。
内部 `SpinState` / `Store` 通过 `struct?` 和 `struct-match` 检查后原样使用，不把已经构造好的 Struct 再交给 Map decoder。
这保留名义定义和原值；不是转 Map、复制后再强转的兼容方案。

当前候选 CLI / `@calcit/procs` 精确配对正式 **0.30.1**，正式图由 Linux CI 验收，不使用本地旧 CLI 编译正式图，也不将单平台验收当作所有后端的兼容保证。
Calcit 模块使用正式 Phlox 0.7.17、touch-control 0.0.32、js-ffi 0.2.5，以及传递依赖 Pointed Prompt 0.0.20，不使用 main/hash 或 alpha 模块版本。
其中 Phlox 包含混合状态游标修复，滑块和根状态可以共存。

npm 的 `@triadica/touch-control` 仅用于原 CSS，生成 JS 没有导入其控制器；稳定 0.0.3 与原 0.0.4-a1 的该 CSS 字节完全一致，因此改用稳定版，而不是替换运行中的控制器 API。
同时删除已不再使用的 procs 0.29.0 安装例外，不新增全局安全豁免。

### 开发与检查

使用 Node.js 24、Yarn 4.18.0、Vite 8.3.4。准备好 manifest 声明的正式模块后：

```sh
yarn install --immutable
calcit --check-only --all-defs
calcit fix --workflow strict --verify
calcit test --require-match
yarn compile
yarn build
yarn dev
```

两项原定义内测试保留，几何期望只适配具名结果，坐标不改；操作测试补充恢复同一个 Store 的身份断言。不增加独立验证脚本、concurrently、质量预算豁免或编译器规则。
CI 解析和验证正式依赖，检查 canonical、完整 strict、全部定义、原测试及应用 unsafe/deprecated=0。
控件的异构状态 Map 和 dispatch 输入仍是明确的 Dynamic 边界，不宣称全部类型债务清零。
`assoc-in` 的通用返回值在写回 Store 前检查为 `Map<Tag,Dynamic>`，没有放宽 Store 字段合同。
Pixi bundle 的大 chunk 提示保留，不提高阈值隐藏。

`calcit.cirru` 只用 Calcit editor/CLI 修改，`deps.cirru` 是依赖清单。不提交 `compact.cirru`、`package.cirru`、`js-out/` 或 `dist/`。

### 前端发布

本地默认相对路径，CI 通过 `VITE_BASE_URL=https://cos-sh.tiye.me/Quamolit/line-spin/` 构建 CDN 引用。
PR 只检查和构建，不上传 COS、不执行 rsync，也没有已上传的预览；仅保留相对路径的原始构建 artifact，供隔离的本地页面验收。生产构建继续使用上述绝对 CDN 路径。
main push 或原手动 main 发布先上传 `dist/assets`；COS Action 的 `public-base-url` 启用内置逐文件内容校验，成功后再执行原目录的 rsync。
没有额外 curl 或上传验证脚本，不修改后端路径。旧 main revision 跳过发布，同分支任务串行、不互相取消；不承诺与 main 原子同步。
合并前须确认本仓库已获 `COS_BUCKET`、`COS_SECRET_ID`、`COS_SECRET_KEY` 和原 `rsync_private_key` 授权；PR 构建通过不等于远端上传或生产部署已验证。

### Workflow

Workflow https://github.com/Phlox-GL/phlox-workflow

### License

MIT
