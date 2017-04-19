# ************************************************************
#
# This step will build your project
#
#   Variables used:
#     $FLOW_ANDROID_GRADLE_TASK 选择或者指定gradle任务
#
# ************************************************************

FLOW_BUILD_PROJECT_PATH=$FLOW_CURRENT_PROJECT_PATH

#进入工程目录下
cd $FLOW_BUILD_PROJECT_PATH
gradle_cmd='gradlew'

#判断工程是否是基于gradlew构建
gradlew_file=$(find . -name gradlew -print -quit 2>&1)

if [[ -z $gradlew_file ]]; then
  echo -e "${ANSI_RED}WARNING: Your project maybe not base on gradle.${ANSI_RESET}"
fi

# Check gradlew path
if [[ -z $gradlew_file ]]; then
    gradle_cmd="gradle"
    echo -e "${ANSI_RED}WARNING: Can not find gradlew in your project. flow.ci will use environment gradle. Maybe cause error. ${ANSI_RESET}"

else
    echo "flow.ci will be use gradlew in your project."
    gradlew_path=$(pwd)"/gradlew"
    chmod +x $gradlew_path
fi

# Check gradle task
if [[ -z $FLOW_ANDROID_GRADLE_TASK ]]; then
  FLOW_ANDROID_GRADLE_TASK="build"
  echo "flow.ci will be run $gradle_cmd $FLOW_ANDROID_GRADLE_TASK as default"
else
  echo "flow.ci will be run $gradle_cmd $FLOW_ANDROID_GRADLE_TASK"
fi

# Set JVM memory
echo "org.gradle.jvmargs=-Xmx5g -Xms5g" >> ~/.gradle/gradle.properties
flow_cmd "$gradle_cmd $FLOW_ANDROID_GRADLE_TASK" --echo --assert

# Print APK files
array=$(find $FLOW_BUILD_PROJECT_PATH -name *.apk 2>&1)
for file in ${array[@]}
do
 echo "=== Generated APK: $file"
done
