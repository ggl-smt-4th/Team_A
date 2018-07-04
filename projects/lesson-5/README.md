## 作业要求

* 按照课程要求，完成基本用户交互界面

## 项目说明

Docker image 已经有可运行项目的所有依赖，`projects/lesson-5` 文件夹中，为 `truffle unbox react` 后的项目，加入了课程中初始代码。

项目可直接运行，运行步骤如下:

1. 在项目根目录： `bash manager.sh run` 运行容器

2. 运行 `bash manager.sh attach` 进入到容器，运行 `ganache-cli`，如账户不够多，eth 不够用，试试：`ganache-cli -a 20 -e 1000`

3. 另开一个终端，cd 到项目根目录，`bash manager.sh attach` 进入到窗口，然后 cd 到 `lesson-5` 目录：

    1. `truffle complie`
    2. `truffle migrate --reset`
    3. `npm run start`

        忽略错误，打开 http://localhost:3000/ 应该可看到界面
