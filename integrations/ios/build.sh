#!/bin/sh

#  build.sh
#  BaoCai
#
#  Created by meng on 16/8/23.
#  Copyright © 2016年 Beijing KuaiYiJianKang Management Co., Ltd. All rights reserved.
echo "抱财自动打包工具"
if [ $# == 2 ]
then
config=$1
outpath=$2
echo "config:$config"
echo "output:$outpath"
elif [ $# == 3 ]
then
config=$1
outpath=$2
identity=$3
echo "config:$config"
echo "output:$outpath"
echo "Signing Identity:$identity"
elif [ $# == 4 ]
then
config=$1
outpath=$2
identity=$3
profile=$4
echo "config:$config"
echo "output:$outpath"
echo "Signing Identity:$identity"
echo "Provisioning Profile:$profile"
else
echo "参数错误"
echo "示例："
echo "./build.sh Release /Users/xxx/BaoCai.ipa"
exit
fi
len=${#outpath}


if [ ${outpath:len-1:1} = "/" ]
then
outpath=$outpath"Me365.ipa"
elif [ ${outpath:len-4:4} != ".ipa" ]
then
outpath=$outpath"/BaoCai.ipa"
fi

echo $outpath

#"删除bulid目录"
rm -rf build || exit
rm $outpath
echo "删除bulid目录成功"
#清理工程
xcodebuild clean -target BaoCai -configuration $config || exit
echo "清理工程成功"
echo "开始编译............"
if [ $# == 2 ]
then
echo "xcodebuild -target BaoCai -configuration $config"
xcodebuild -workspace BaoCai.xcworkspace -scheme BaoCai -configuration $config || exit
elif [ $# == 3 ]
then
echo "xcodebuild -target BaoCai -configuration $config CODE_SIGN_IDENTITY='$identity'"
xcodebuild -workspace BaoCai.xcworkspace -scheme BaoCai -configuration $config CODE_SIGN_IDENTITY="$identity" || exit
else
echo "xcodebuild -target BaoCai -configuration $config CODE_SIGN_IDENTITY='$identity'" PROVISIONING_PROFILE="$profile"
xcodebuild -workspace BaoCai.xcworkspace -scheme BaoCai -configuration $config CODE_SIGN_IDENTITY="$identity" PROVISIONING_PROFILE="$profile" || exit
fi
echo "编译成功............!"
echo "打包IPA"
echo "/usr/bin/xcrun -sdk iphoneos PackageApplication    -v build/$config-iphoneos/BaoCai.app  -o $outpath"
/usr/bin/xcrun -sdk iphoneos PackageApplication    -v /Users/meng/Library/Developer/Xcode/DerivedData/BaoCai-brhqbtywospftbgaqeplhevfoqgb/Build/Products/$config-iphoneos/BaoCai.app  -o "$outpath" || exit

echo "打包成功..................!"

