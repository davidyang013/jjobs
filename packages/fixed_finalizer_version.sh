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
    cd /usr/local/jenkins/Finalizer
    tar -zxvf /usr/local/jenkins/Finalizer/$base_finalizer
    echo 'y'|sudo /usr/local/jenkins/Finalizer/${base_finalizer%.tar.gz}/Xcode/install-xcode-finalizer-wrapper.sh
fi

echo ""