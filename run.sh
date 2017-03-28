# ************************************************************
#
# This step will build your project
#
#   Variables used:
#     $FLOW_ENABLE_FAILURE
#			$FLOW_ANDROID_GRADLE_TASK 选择或者指定gradle任务
#			$FLOW_ANDROID_GRADLEW_PATH  手动指定工程build.gradle的路径（可选）
#     $FLOW_ANDROID_GRADLE_BUILD_PATH 手动指定工程build.gradle的路径（可选）
#   Outputs:
#
# ************************************************************
#For Test
# FLOW_ANDROID_GRADLE_TASK="build"
# FLOW_ANDROID_GRADLEW_PATH="./"
# FLOW_ANDROID_GRADLE_BUILD_PATH="./"

FLOW_BUILD_PROJECT_PATH=$FLOW_CURRENT_PROJECT_PATH

#进入工程目录下
cd $FLOW_BUILD_PROJECT_PATH
GARDLE_SCRIPT=''

#判断工程是否是基于gradle构建
BUILDGRADLEFILE=$(find . -name gradlew -print -quit 2>&1)
if [[ -z $BUILDGRADLEFILE ]]; then
  echo -e "
   ${ANSI_RED}WARNING: Your project maybe not base on gradle.${ANSI_RESET}
  "
fi

#判断是否是手动指定 gradlew 路径
if [[ -z $BUILDGRADLEFILE ]]; then
    GARDLE_SCRIPT+="gradle"
    echo -e "${ANSI_RED}WARNING: Can not find gradlew in your project. flow.ci will use environment gradle. Maybe cause error. ${ANSI_RESET}"
else
	echo "flow.ci will be use gradlew in your project."

	if [[ -z $FLOW_ANDROID_GRADLEW_PATH ]]; then
	    FLOW_ANDROID_GRADLEW_PATH=./
	fi

    cd $FLOW_ANDROID_GRADLEW_PATH
    FLOW_ANDROID_GRADLEW_PATH=$(pwd)"/gradlew"
    chmod +x $FLOW_ANDROID_GRADLEW_PATH
	GARDLE_SCRIPT+="$FLOW_ANDROID_GRADLEW_PATH"
fi

if [[ -z $FLOW_ANDROID_GRADLE_BUILD_PATH ]]; then
	echo "Not Config build Path, flow.ci will build project root as default."
	FLOW_ANDROID_GRADLE_BUILD_PATH=$(find . -name build.gradle -print -quit 2>&1)
else
	echo "Config build Path, flow.ci will build from $FLOW_ANDROID_GRADLE_BUILD_PATH in your project."
	cd $FLOW_BUILD_PROJECT_PATH"/"$FLOW_ANDROID_GRADLE_BUILD_PATH
fi

if [[ -z $FLOW_ANDROID_GRADLE_TASK ]]; then
	FLOW_ANDROID_GRADLE_TASK="build"
	echo "Not Config Android Gradle Task, flow.ci will be run default $GARDLE_SCRIPT $FLOW_ANDROID_GRADLE_TASK task."
else
	echo "Android Gradle Task has been configed, flow.ci will be run $GARDLE_SCRIPT $FLOW_ANDROID_GRADLE_TASK."
fi

export org.gradle.jvmargs=-Xmx5g -Xms5g

flow_cmd "$GARDLE_SCRIPT clean" --echo --assert
flow_cmd "$GARDLE_SCRIPT $FLOW_ANDROID_GRADLE_TASK" --echo --assert

# Print APK files
array=$(find $FLOW_BUILD_PROJECT_PATH -name *.apk 2>&1)
for file in ${array[@]}
do
 echo "=== Generated APK: $file"
done
