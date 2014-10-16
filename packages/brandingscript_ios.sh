###Package iOS app use the Branding Script###

################################Mac mini############################################################
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.7.0_21.jdk/Contents/Home
export ANT_HOME=/System/Library/Java/apache-ant-1.9.3
export ANDROID_HOME=/usr/local/ADK
export MAVEN_HOME=/usr/share/maven
export NODEJS_HOME=/usr/local/bin
export TERM=xterm
export PATH=$PATH:$ANT_HOME/bin:$JAVA_HOME/bin:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$MAVEN_HOME/bin:$NODEJS_HOME
#####################################################################################################

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

git checkout $TagName

echo ""
echo "----------------------------execute install Finalizer-----------------------------------------"

full_finalizer=""
base_finalizer=""
echo "---------------------------------------------------"
if [ -f ${WORKSPACE}/Mobile/iOS/Finalizer-*-macosx-x86.tar.gz ]
then
    full_finalizer=$(ls ${WORKSPACE}/Mobile/iOS/Finalizer-*-macosx-x86.tar.gz)
    base_finalizer=$(basename $full_finalizer)
    echo ${full_finalizer}
    echo ${base_finalizer%.tar.gz}
    if [ ! -f $full_finalizer ]
    then
       cp -fr $full_finalizer /usr/local/jenkins/Finalizer/
    fi
    tar -zxvf /usr/local/jenkins/Finalizer/$base_finalizer
    echo 'y'|sudo /usr/local/jenkins/Finalizer/${base_finalizer%.tar.gz}/Xcode/install-xcode-finalizer-wrapper.sh
fi

echo ""
echo "----------------------------execute BrandingScript process-----------------------------------------"

echo "switch to branding path"
cd ${WORKSPACE}/Mobile/iOS
echo "current path :" `pwd`
echo ""
echo "delete and clean compile environment"

if [ -d ${WORKSPACE}/Mobile/iOS/BrandingScript ]
then
   rm -rf ${WORKSPACE}/Mobile/iOS/BrandingScript
fi

mkdir ${WORKSPACE}/Mobile/iOS/BrandingScript

if [ -d ~/Desktop/iOS-package ]
then 
   rm -rf ~/Desktop/iOS-package
fi

echo ""
echo "----------------------------execute Package process-----------------------------------------"

xcodebuild -scheme Package build

ls -la ~/Desktop/iOS-package

echo copy the files to BrandingScript 
cp -fr ~/Desktop/iOS-package/* ${WORKSPACE}/Mobile/iOS/BrandingScript/

cd ${WORKSPACE}/Mobile/iOS/BrandingScript/

tar -zxvf Resources-iOS.tar.gz

mkdir ${WORKSPACE}/Mobile/iOS/BrandingScript/Resources/iOS/Libraries/VisualOn

cp -fr  ${WORKSPACE}/Common/VO/iOS/Include/*.h ${WORKSPACE}/Mobile/iOS/BrandingScript/Resources/iOS/Libraries/VisualOn
cp -fr ${WORKSPACE}/Common/VO/iOS/Libs/*.a ${WORKSPACE}/Mobile/iOS/BrandingScript/Resources/iOS/Libraries/VisualOn
cp -fr ${WORKSPACE}/Common/VO/iOS/SamplePlayer/libViewRightWebiOS.a-armv7.fin  ${WORKSPACE}/Mobile/iOS/BrandingScript/Resources/iOS/Libraries/VisualOn
cp -fr ${WORKSPACE}/Common/VO/iOS/SamplePlayer/cap.xml ${WORKSPACE}/Mobile/iOS/BrandingScript/Resources/iOS/Libraries/VisualOn
cp -fr ${WORKSPACE}/Common/VO/iOS/SamplePlayer/LoadLibControl/* ${WORKSPACE}/Mobile/iOS/BrandingScript/Resources/iOS/Libraries/VisualOn
cp -fr ${WORKSPACE}/Common/VO/iOS/SamplePlayer/License/voVidDec.dat  ${WORKSPACE}/Mobile/iOS/BrandingScript/Resources/Common

echo ""
echo "-----------------------------insert the customized parameters-----------------------------------------"

sed -i '' "s/<string name=\"portal_server_url\">.*<\/string>/<string name=\"portal_server_url\">http:\/\/$portal_server_url<\/string>/" ${WORKSPACE}/Mobile/iOS/BrandingScript/Resources/Common/config.xml
sed -i '' "s/<string name=\"drm_server_ip_value\">.*<\/string>/<string name=\"drm_server_ip_value\">$drm_server_ip_value<\/string>/" ${WORKSPACE}/Mobile/iOS/BrandingScript/Resources/Common/config.xml
sed -i '' "s/<string name=\"drm_server_port_value\">.*<\/string>/<string name=\"drm_server_port_value\">$drm_server_port_value<\/string>/" ${WORKSPACE}/Mobile/iOS/BrandingScript/Resources/Common/config.xml
sed -i '' "s/<string name=\"license_text\">.*<\/string>/<string name=\"license_text\">$license_text<\/string>/" ${WORKSPACE}/Mobile/iOS/BrandingScript/Resources/Common/config.xml
sed -i '' "s/<string name=\"video_resumable_value\">.*<\/string>/<string name=\"video_resumable_value\">$video_resumable_value<\/string>/" ${WORKSPACE}/Mobile/iOS/BrandingScript/Resources/Common/config.xml
sed -i '' "s/<string name=\"user_agent_extended_description\">.*<\/string>/<string name=\"user_agent_extended_description\">$user_agent_extended_description<\/string>/" ${WORKSPACE}/Mobile/iOS/BrandingScript/Resources/Common/config.xml

echo ${WORKSPACE}/Mobile/iOS/BrandingScript/Resources/iOS


sed -i '' "s/<string name=\"distribution_certificate\">.*<\/string>/<string name=\"distribution_certificate\">$distribution_certificate<\/string>/" ${WORKSPACE}/Mobile/iOS/BrandingScript/Resources/iOS/config-ios.xml


provisioning_profile=$(echo $provisioning_profile|sed 's/\//\\\//g')
echo $provisioning_profile

sed -i '' "s/<string name=\"provisioning_profile\">[^>]*</<string name=\"provisioning_profile\">$provisioning_profile</" ${WORKSPACE}/Mobile/iOS/BrandingScript/Resources/iOS/config-ios.xml

echo ""
echo "-----------------------------execute keychain process-----------------------------------------"

security unlock-keychain -p MSTV /Users/MSTV/Library/Keychains/login.keychain

echo ""
echo "-----------------------------execute BrandingScript shell process-----------------------------------------"


cd ${WORKSPACE}/Mobile/iOS/BrandingScript/
echo ""
./build_branded_ipa.sh Resources
echo ""
echo "The BrandingScript job executed end"


