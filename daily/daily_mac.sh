export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.7.0_21.jdk/Contents/Home
export ANDROID_HOME=/usr/local/ADK
export MAVEN_HOME=/usr/share/maven
export NODEJS_HOME=/usr/local/bin
export PATH=$PATH:$JAVA_HOME/bin:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$MAVEN_HOME/bin:$NODEJS_HOME

#print all environment
#set

#kill Safari process before open it
pkill -9 Safari

#clear Safari cache

rm -Rf ~/Library/Caches/Apple\ -\ Safari\ -\ Safari\ Extensions\ Gallery; \
rm -Rf ~/Library/Caches/Metadata/Safari; \
rm -Rf ~/Library/Caches/com.apple.Safari; \
rm -Rf ~/Library/Caches/com.apple.WebKit.PluginProcess; \
rm -Rf ~/Library/Cookies/Cookies.binarycookies; \

#clear environment

sudo rm -rf /Volumes/Server\ HD/Library/Internet\ Plug-Ins/ericssonPlayer.plugin
sudo rm -rf ~/Library/Internet\ Plug-Ins/ericssonPlayer.plugin

cd ${WORKSPACE}

#sudo installer -pkg ../../voPlugins/Ericsson\ Player\ Plugin\ 3.12.0.68700-signed.pkg -target /

#upgrade to Ericsson Player Plugin 3.12.20.pkg(20140915)
sudo installer -pkg ../../voPlugins/Ericsson\ Player\ Plugin\ 3.12.20.pkg -target /

#sudo mv /Volumes/Server\ HD/Library/Internet\ Plug-Ins/ericssonPlayer.plugin ~/Library/Internet\ Plug-Ins/

#cd ~/Library/Internet\ Plug-Ins/

#sudo chown -R MSTV:staff *

#open Safari browser with the portal url
open -a safari http://10.170.78.136:18081/portal-root-war/index_mock.html
