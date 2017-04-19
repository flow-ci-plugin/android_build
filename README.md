
# android_build Step
Android build task

### INPUTS
* `FLOW_ANDROID_GRADLE_TASK` - 

## EXAMPLE 

```yml
steps:
  - name: android_build
    enable: true
    failure: true
    plugin:
      name: android_build
      inputs:
        - FLOW_ANDROID_GRADLE_TASK=$FLOW_ANDROID_GRADLE_TASK
```
