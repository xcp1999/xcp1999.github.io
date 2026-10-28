# 本地环境与预览

## 已做的配置

- 使用 mise 安装独立的 Ruby 3.3.13，位置在 `~/.local/share/mise/installs/ruby/3.3.13`；mise 位于 `~/.local/bin/mise`。无需 conda、Homebrew，也没有修改系统 Ruby 或全局 shell 配置。
- 安装 Bundler 2.5.23，更新旧模板的依赖锁定文件以兼容当前 Ruby/macOS；项目依赖位于 `vendor/bundle/`，已加入 Git 忽略。
- `.ruby-version`、本地启动脚本和 GitHub Actions 统一使用 Ruby 3.3.13。`run_server.sh` 自动选择环境，不用手动激活虚拟环境。
- 本机已有 Xcode Command Line Tools，直接复用。此文档和启动脚本已从网页构建中排除。
- 修正 `_config.yml` 的仓库归属与主页地址。实测安装空间约 470 MB（mise、Ruby、项目依赖和 mise 缓存合计），不含原本已有的编译工具。

## 平时如何查看

在 VS Code 终端执行：

```bash
cd ~/repo/xcp1999.github.io
bash run_server.sh
```

看到服务启动后，在浏览器打开 http://127.0.0.1:4000/ 。保持终端运行，修改页面并保存会自动重新构建，浏览器自动刷新；修改 `_config.yml` 后按 Ctrl+C 停止，再运行上述命令。退出预览也按 Ctrl+C。

同一时间只启动一个预览进程；重复启动会占用网页端口 4000 和自动刷新端口 35729。请在原来的终端按 Ctrl+C 停止后再启动。脚本显式设置仓库名称，避免元数据插件把 SSH 地址中的 `:443` 错认成仓库所有者。

只编译、不启动服务：

```bash
bash run_server.sh build
```

按线上生产模式编译时，使用 `JEKYLL_ENV=production bash run_server.sh build`。

输出在 `_site/`，这是生成文件，不要直接编辑或提交。若 4000 端口被占用，可以运行 `bash run_server.sh --port 4001`，改用 http://127.0.0.1:4001/ 。

## 以后安装或恢复依赖

本机已安装完成，不需要每次执行。若删除了 `vendor/bundle/`，运行：

```bash
cd ~/repo/xcp1999.github.io
BUNDLE_PATH=vendor/bundle ~/.local/bin/mise exec ruby@3.3.13 -- bundle _2.5.23_ install
```

在另一台兼容的电脑上，先从 https://mise.jdx.dev/getting-started.html 安装 mise，再执行：

```bash
~/.local/bin/mise install ruby@3.3.13
~/.local/bin/mise exec ruby@3.3.13 -- gem install bundler -v 2.5.23 --no-document
```

然后按上面的命令安装项目依赖、启动预览。不要直接使用 macOS 自带的 `bundle` 命令，否则可能调用系统旧 Ruby。

## 发布与本地预览的区别

本地预览不会更新公开网站。修改满意后提交、推送源码，GitHub Actions 才会构建并部署线上网页；本次环境配置未代为 commit、push 或发布。

若看到 GitHub Metadata 的未认证或 API 限流警告，只要后面显示 `done`、`Server running` 即已成功；这是联网读取仓库元信息的提示，不需要为本地预览提供 GitHub 密钥。
