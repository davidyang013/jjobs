#!/bin/sh -x
###Build Android app use the Branding script###

################################Mac mini############################################################
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.7.0_51.jdk/Contents/Home
export ANT_HOME=/Users/david/repo/homebrew/Cellar/ant/1.9.4
export ANDROID_HOME=/Users/david/Applications/adt-bundle-mac-x86_64-20140321/sdk
export MAVEN_HOME=/Users/david/Applications/apache-maven-3.2.1
export NODEJS_HOME=/usr/local/bin
export TERM=xterm
export PATH=$PATH:$ANT_HOME/bin:$JAVA_HOME/bin:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$MAVEN_HOME/bin:$NODEJS_HOME
#####################################################################################################
WORKSPACE="/Users/david/Desktop/1"
portal_server_url="10.170.78.135"
drm_server_ip_value="10.170.78.80"
drm_server_port_value="80"
license_text="VOTRUST_ERICSSON"
video_resumable_value="true"
user_agent_extended_description=""
package_name="com.customer.brand.tvclient"
package_version="1.0"
package_code="1"
keystore_path="/Users/david/Desktop/1/Mobile/Android/android.keystore"
key_alias="android.keystore"


#Print the operation step
echo ""
echo "#################################################"
echo "-------Jenkins ENVIRONMENT-----------"
echo "#################################################"
env|sort
echo ""
ps -ef|grep $USER
echo "-------JAVA/MAVEN/ANT VERSIONS-------"
java -version
mvn -v

echo "WORKSPACE : " ${WORKSPACE}
echo ""
echo "JAVA_HOME : " ${JAVA_HOME}
echo ""
echo "PATH : " ${PATH}
echo ""
echo "##################################################"
echo ""

#git checkout $TagName

echo "switch to branding path"
cd ${WORKSPACE}/Mobile/Android/android-scripts/Branding
echo "current path :" `pwd`
echo ""
echo "delete and clean compile environment"
rm -rf Resources*
rm -rf Branding-*
rm -rf *.gz
rm -rf *.apk
echo "the current file list :" `ls -la`
echo ""
echo "-----------------------------insert the customized parameters-----------------------------------------"
sed -i '' "s/<string name=\"portal_server_url\">.*<\/string>/<string name=\"portal_server_url\">http:\/\/$portal_server_url<\/string>/" config.xml

sed -i '' "s/<string name=\"drm_server_ip_value\">.*<\/string>/<string name=\"drm_server_ip_value\">$drm_server_ip_value<\/string>/" config.xml

sed -i '' "s/<string name=\"drm_server_port_value\">.*<\/string>/<string name=\"drm_server_port_value\">$drm_server_port_value<\/string>/" config.xml

sed -i '' "s/<string name=\"license_text\">.*<\/string>/<string name=\"license_text\">$license_text<\/string>/" config.xml

sed -i '' "s/<string name=\"video_resumable_value\">.*<\/string>/<string name=\"video_resumable_value\">$video_resumable_value<\/string>/" config.xml

sed -i '' "s/<string name=\"user_agent_extended_description\">.*<\/string>/<string name=\"user_agent_extended_description\">$user_agent_extended_description<\/string>/" config.xml

sed -i '' "s/<string name=\"package_name\">.*<\/string>/<string name=\"package_name\">$package_name<\/string>/" config-android.xml

sed -i '' "s/<string name=\"package_version\">.*<\/string>/<string name=\"package_version\">$package_version<\/string>/" config-android.xml

sed -i '' "s/<string name=\"package_code\">.*<\/string>/<string name=\"package_code\">$package_code<\/string>/" config-android.xml

#sed -i '' "s/<string name=\"keystore_path\">*<\/string>/<string name=\"keystore_path\">$keystore_path<\/string>/" config-android.xml
#sed -i '' "s/<string name=\"key_alias\">*<\/string>/<string name=\"key_alias\">$key_alias<\/string>/" config-android.xml

sed -i '' "s,<string name=\"keystore_path\">[^>]*<,<string name=\"keystore_path\">$keystore_path<," config-android.xml
sed -i '' "s/<string name=\"key_alias\">[^>]*</<string name=\"key_alias\">$key_alias</" config-android.xml
echo "--------------------------------------------------------------------------------------------------------"
echo ""
echo "############execute the script build_exporter_android.sh#######################"
echo ""
sh build_exporter_android.sh
echo ""
echo "###############################################################################" 

echo "###################insert the password jar signer##############################"
echo ""
sed -i '' '/^jarsigner/ s/-keystore/-storepass android -keypass android -keystore/' build_branded_apk.sh
echo ""
echo "###############################################################################"
echo ""
echo "###################unpack the Resources-Android.tar.gz#########################"
echo ""
tar -xvf Resources-Android.tar.gz
echo "###############################################################################"
echo ""
echo "############switch the path to Resource########################################"
echo ""
cd Resources
echo ""
echo "#############################mkdir the folder for Library#####################"

mkdir ${WORKSPACE}/Mobile/Android/android-scripts/Branding/Resources/Android/Libraries/VisualOn
mkdir ${WORKSPACE}/Mobile/Android/android-scripts/Branding/Resources/Android/Libraries/VisualOn/armeabi
echo "################################check the libraries###########################"
ls -la ${WORKSPACE}/Common/VO/Android/Jar/

ls -la  ${WORKSPACE}/Mobile/Android/android-scripts/Branding/Resources/Android/Libraries/VisualOn/armeabi/
echo ""
echo "#############################copy the libraries###############################"
cd ${WORKSPACE}/Common/VO/Android/Jar/

cp *.jar ${WORKSPACE}/Mobile/Android/android-scripts/Branding/Resources/Android/Libraries/VisualOn/

cd  ${WORKSPACE}/Common/VO/Android/Libs/
cp *.so ${WORKSPACE}/Mobile/Android/android-scripts/Branding/Resources/Android/Libraries/VisualOn/armeabi/
echo ""
echo "###########################copy the voVidDec.dat##############################"
echo ""
cp -f ${WORKSPACE}/Common/VO/Android/License/voVidDec.dat ${WORKSPACE}/Mobile/Android/android-scripts/Branding/Resources/Common/
echo ""
echo "##############################################################################"
echo ""
echo "###############switch the path and execute build_branded_apk.sh###############"
echo ""
cd ${WORKSPACE}/Mobile/Android/android-scripts/Branding/
echo ""
./build_branded_apk.sh Resources
echo ""
echo "The BrandingScript job executed end"

apk=$(ls ${WORKSPACE}/Mobile/Android/android-scripts/Branding|grep apk$)
echo "apk:" $apk
path=${WORKSPACE}/Mobile/Android/android-scripts/Branding/$apk
echo $path
