pipeline {
  agent any

  options {
    timeout(time: 60, unit: 'MINUTES')
    buildDiscarder(logRotator(numToKeepStr: '14'))
  }

  stages {
    stage('Verify visu-gml') {
      steps {
        script {
          String revision = "main"
          String overrideDependencies = """
          {
            "visu": {
              "revision": "${env.GIT_COMMIT}"
            }
          }
          """.stripIndent()

          def buildJob = build(
            job: 'visu-project/verify',
            propagate: true,
            wait: true,
            parameters: [
              string(name: 'GIT_REVISION', value: revision),
              string(name: 'OVERRIDE_DEPENDENCIES', value: overrideDependencies),
            ]
          )
        }
      }
    }
  }
}
