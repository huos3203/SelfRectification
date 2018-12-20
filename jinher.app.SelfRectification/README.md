#  要点说明

### 集成讯飞语音合成功能
[demo下载](https://www.xfyun.cn/sdk/dispatcher?app_id=NWMxNzA1ZGQ)
[文档](https://doc.xfyun.cn/msc_ios/集成流程.html)
将demo 中的`iflyMSC.framework`文件40多M，需要单独存储。
### 第一步：获取appid

appid是第三方应用集成讯飞开放平台SDK的身份标识，SDK静态库和appid是绑定的，每款应用必须保持唯一，否则会出现10407错误码。appid在开放平台申请应用时可以获得，下载SDK后可从SDK中sample文件夹的Demo工程里找到（例如: /sample/MSCDemo/MSCDemo/Definition.h 的APPID_VALUE）

### 初始化

初始化示例：

//Appid是应用的身份信息，具有唯一性，初始化时必须要传入Appid。
```
NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@", @"YourAppid"];
[IFlySpeechUtility createUtility:initString];
```

### API
1. 检查项列表
http://192.168.9.158:81/web/#/12?page_id=87
2. 自检项提交图片接口
http://192.168.9.158:81/web/#/12?page_id=89
3. 自检分类点击已完成，预览接口
http://192.168.9.158:81/web/#/12?page_id=90
