
# android_build Step
Android build task

### INPUTS
* `FLOW_ENABLE_FAILURE` - 
* `FLOW_ANDROID_GRADLE_TASK` - 
* `FLOW_ANDROID_GRADLEW_PATH` - 
* `FLOW_ANDROID_GRADLE_BUILD_PATH` - 

## EXAMPLE 

```yml
steps:
  - name: android_build
    enable: true
    failure: true
    plugin:
      name: android_build
      inputs:
        - FLOW_ENABLE_FAILURE=$FLOW_ENABLE_FAILURE
        - FLOW_ANDROID_GRADLE_TASK=$FLOW_ANDROID_GRADLE_TASK
        - FLOW_ANDROID_GRADLEW_PATH=$FLOW_ANDROID_GRADLEW_PATH
        - FLOW_ANDROID_GRADLE_BUILD_PATH=$FLOW_ANDROID_GRADLE_BUILD_PATH
```
