### 智能合约开发课程项目

* 各个课程对应的代码在 projects 目录中
* manager.sh 为 docker 环境管理脚本

####  docker 环境使用

先安装 docker

1. 运行容器:

    `sh manager.sh run` 容器在后台运行

2. 附加到容器中工作

    `sh manager attach` 进入到容器中，即可工作

3.  停止容器

    `sh manager stop` 

### 作业提交

大家 fork 本项目到自己的项目下，在自己的项目中，可选任意分支开发（建议 master），开发完成后，PR 到本项目对应的分支中。

> 如何提交作业: https://www.youtube.com/watch?v=X5tLHiYkHIU&t=40s

> 如何更新代码: https://www.youtube.com/watch?v=G_DpaJaFvUc

#### 更新代码

> 以 bob 为例
>
> bob 的 repo: `bob/Team_A`
>
> team 的 repo: `ggl-smt-4th/Team_A`

1. 将 `bob/Team_A` 拉取到本地

    ```bash
    $ git clone https://github.com/bob/Team_A.git
    ```

2. 进入本地的 `Team_A` 目录，添加一个新的remote repo

    ```bash
    $ cd Team_A

    # 下面命令中的 team-repo 可以换成其它名称
    $ git remote add team-repo https://github.com/ggl-smt-4th/Team_A.git

    # 输入下面的命令检查下是否成功，看到新加入的 team-repo 即为成功
    $ git remote -v
    ```

2. 更新代码

    ```bash
    # 拉取 team-repo 中的master分支里的代码
    $ git pull team-repo master

    # or
    $ git fetch team-repo
    $ git merge team-repo/master

    # or
    $ git fetch team-repo
    $ git rebase team-repo/master
    ```

    > 三种操作任选一种

3. 处理可能出现的代码冲突，自行解决下

4. 将代码更新到 `bob/Team_A`

    ```bash
    $ git push origin master
    ```

