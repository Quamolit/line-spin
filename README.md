Line Spin
----

### 使用者影响

配对升级正式 Calcit CLI/procs 0.32.1、Phlox 0.8.0、Touch Control 0.0.35、
JS-FFI 0.2.9，传递 Pointed Prompt 0.0.24。模块使用正式 tag，无 alpha/hash。
类型标注通过官方 CLI 迁移；原19个项目定义的完整 code/schema/元数据/测试
与格式化后的原基线一致，几何公式、默认参数、滑块、端点和 hud! 提示不变。

Trail/SpinState/Store 的具名合同及真实状态解码保留，不以伪强转消除开放边界。
生成 JS 仍实际导入 @quamolit/phlox-utils，因此保留该运行依赖。
@triadica/touch-control 0.0.3 仍只提供原 CSS；它与当前 Caps CSS 字节不同，
本轮保留已有样式，不因名字旧就替换。控件代码来自正式 Calcit 模块0.0.35。

### 开发与验收

使用 Node24、Yarn4.18.0、Caps0.1.1，包龄明确60分钟，无版本豁免。

```sh
caps --strict --ci
yarn install --immutable
caps verify --toolchain
calcit --check-only --all-defs
calcit fix --workflow strict --verify
calcit test --require-match
yarn compile
yarn build
yarn dev
```

本地完整 strict、225/225 定义、19/19 公开定义、原两项附带测试、
immutable安装、工具链配对及构建通过，源码unsafe/deprecated均0。
实际IAB拖动steps从200到260，拖动端点从(100,200)到(140,240)，
几何和显示坐标随之变化；刷新恢复默认，控制台无警告/错误。
未宣称其余全部参数、HMR、触控、移动硬件或跨浏览器验收，开放UI/派发边界保留。
Pixi大chunk提示保留，不提高阈值隐藏。

### 前端发布

本地默认相对路径；原生产CDN为 https://cos-sh.tiye.me/Quamolit/line-spin/ 。
PR只检查、构建并保存原artifact，不上传COS/rsync，不宣称已有远端预览。
main或原手动main发布才上传dist/assets，以COS action内置public-base-url校验，
成功后执行原rsync路径。旧main revision守卫、发布条件、串行队列均不变。
Actions改为对应精确正式tag，接受可移动tag风险；不增加上传校验脚本。
不提交compact.cirru/package.cirru/js-out/dist，本轮不合并部署生产。

Workflow: https://github.com/Phlox-GL/phlox-workflow

### License

MIT
