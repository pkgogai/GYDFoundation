# App瘦身-图片批量压缩工具-TinyPNG的批处理

## 前言

App瘦身是老生常谈了，图片压缩算是一种最没有技术含量，但效果也最好的方法。
图片压缩的工具有很多，有比这个更好也更方便的，但这里使用TinyPNG，原因有2个，一是很久以前就在用，经过了时间的考验，二是出于兴趣给自己写了专用的工具，用起来也很方便。
最近在整理8年来的代码，就将这个工具的代码重构一下，并开放到github上供有同样兴趣的人互相学习。

最后：tinypng是个好网址，每月有500次的免费次数。身为一个程序猿，看到这个限制自然会忍不住把工具写成了可以设置多个key，但这只涉及兴趣，可以讨论和学习。实际上500次已经足够大家使用了，很少有项目每月增加500张图片这么多，就算偶尔超出，收费也并不贵。大家有条件的话尽量付费使用。

## 项目

https://github.com/pkgogai/GYDFoundation/blob/master/GYDShellTools/Code/批量图片压缩/GYDShellTinifyTools.h

## 流程

准备工作：
1. 从官网申请key。https://tinypng.com/developers
2. 准备图片所在目录的路径，会深度遍历处理。
3. 再准备一个用来记录处理情况的文件路径，处理结果会保存到这里，以便每次只做增量处理。

工具执行步骤：
1. 输入参数：
    - key: 权限，有多个key的话用逗号分隔。
    - path: 图片路径。
    - log: 记录文件路径。
2. 准备图片：
    - 遍历路径找出所有png图片。
    - 使用记录文件筛选出没处理过的图片。
    - 从大到小排序。
3. 处理图片：
    - 使用官网api处理每张图片。
    - 一个Key次数用尽则换下一个Key。
    - 成功后直接替换原文件。
    - 保存记录。
4. 结束情况：
    - 处理完成。
    - 所有key的次数用尽。
    - 出错：网络、文件读写等错误。

## 实现

#### 官方API

官网上还有更简单的api，但因为床铺对我的眷恋，没有进行尝试。
https://api.tinify.com/shrink
POST
header填充 Authorization : Basic base64(api:$"key")，伪代码：
```
key = 网站上申请到的key;
token = base64("api:"+key);
header["Authorization"] = "Basic " + token;
```
body为图片文件数据。

处理成功的返回
```
    {
         input =     {
             size = 91733;
             type = "image/png";
         };
         output =     {
             height = 1334;
             ratio = "0.2585";
             size = 23711;
             type = "image/png";
             url = "https://api.tinify.com/output/gah3v1eexhmty1gt8ujhjfhge2gbf1g2";
             width = 750;
         };
     }
```
处理失败的情况我们只关注一个，http状态码429表示次数用光。

#### 记录处理结果

对于处理结果，这里只记录一个md5，没必要记录文件名等其它信息。如果真有没压缩的图片和压缩过的图片不一样，md5却相同，遇到这种千年难遇的情况也只是少压一个文件而已，无伤大雅。
文件格式：plist，结构：字典，文件的md5为key，value如表：

值 | 说明 | 判定条件
--- | --- | ---
-1 | 已压缩到极致 | 压缩后md5没有变化
0 | 没处理 | 这种情况不会记录，所以不存在
1 | 已压缩 | 至少经过经过了1次压缩（原本想记录压缩次数，但后来感觉没必要）

注：不用数据库的原因是，文本文件记录更利于git处理。

#### 源码接口

刚发现是否深度遍历的参数忘记处理了，现在必定深度遍历。
```
@interface GYDShellTinifyTools : NSObject
/** 权限 */
@property (nonatomic, copy, nullable) NSArray<NSString *> *apiKeys;

/** 压缩一张图片，如果换别的压缩工具，就修改这里吧 */
- (nullable NSData *)imageDataForCompressImageData:(nonnull NSData *)imageData output:(out NSString * _Nullable * _Nullable)output;

/**
 批量压缩一个目录中的图片并直接替换
 @param path 目录路径
 @param resursive 目录是否递归查找
 @param filePath 记录处理状态到文件，以便下次跳过已处理的文件
 */
- (BOOL)compressImagesAtPath:(nonnull NSString *)path resursive:(BOOL)resursive historyFile:(nullable NSString *)filePath;

@end
```
