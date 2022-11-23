# ngonx-proxy-docker
## 简介
通过手动编译nginx，加入ngx_http_proxy_connect_module模块。支持http(s)协议代理，默认开启basic_auth认证。

## 使用
1. 拉取镜像：docker pull shukuang/nginx-proxy:1.22.1
2. 默认配置见default.conf,默认密码文件htpasswd，默认用户名密码为：zs/nginx.zs
3. 启动：docker run -d --name nginx-proxy -p 8888:80 shukuang/nginx-proxy:1.22.1
4. 如需自定义配置，需挂载/etc/nginx/conf.d目录
```
1. 拷贝default.conf到/your/path,并修改成自己的配置，并在/your/path生成自己的用户名密码文件，名字和basic_auth保持一次
2. basic_auth生成方式：服务器安装httpd-tools, 运行：htpasswd -cb htpasswd（用户名/密码文件） 用户名 密码
3. docker run -d --name nginx-proxy -p 8888:80 -v /your/path:/etc/nginx/conf.d shukuang/nginx-proxy:1.22.1 
```
5. 服务器安装完毕，使用python、java或者其他语言使用代理
```
# 以python requests为例
import requests
from requests.auth import HTTPBasicAuth
proxy = {
    "http":"http://your_ip:8888",
    "https":"http://your_ip:8888"
}
requests.get(url="",proxies=proxy,auth=HTTPBasicAuth("zs","nginx.zs"))
```
6. 经测试，有些网站会报401错误，这个应该是nginx代理模块的问题，暂时没办法解决，或者尝试注释掉basic_auth认证的配置，没有密码的代理服务器可能很快会被大佬盯上，变成别人的免费代理。
7. 别忘了star
