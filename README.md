H5 App of Baocai
================

### 目标
1.  Write once, run anywhere
1.  用 React 重构 H5/M站/微信/App
1.  业务逻辑与前端页面分离
1.  提高前端控件的重用度
1.  最大化全端并行迭代效率

### How to start
1.  安装 [node](https://nodejs.org)
1.  命令行执行 `npm install`
1.  命令行执行 `npm run server`
1.  浏览器访问 [http://localhost:2999](http://localhost:2999)

### 与微信融合
`make buildWechat src=...`，其中 `src` 指向微信代码目录，如 `...WebApp/trunk/resources/web`

### 代码结构
```shell
|-index.html
|-src
|  |-apps               # 整合产品页面到各端
|  |  |-mobile
|  |-components         # 纯 React 控件
|  |  |-navigator
|  |-css                # 样式表
|  |-pages              # 页面及业务逻辑
|  |  |-home
|  |  |  |-models       # 业务逻辑 (Model)
|  |  |  |  |-actions
|  |  |  |  |-reducers
|  |  |  |-views        # 产品页面 (View & Controller)
|  |  |-invest
|  |  |-login
```