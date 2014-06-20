#!/bin/sh

gradleFilePath="$1"

if [ -z "$gradleFilePath" ]; then
  echo "Missing $1 parameter for gradleFilePath"
  exit 1
fi

isProjectInfoTask=`grep "task(projectInfo)" $gradleFilePath`

if [ ! -z "$isProjectInfoTask" ]; then
  echo "already have projectInfo task, done!"
  exit 0
fi

(cat <<'EOT'

task(projectInfo) << {

  def path = project.hasProperty('outputFilePath') ? outputFilePath : 'projectInfo.json'

  def output = new File(path)
  output.text = '{' +
      '    "project": {' +
      '        "group": "'+project.group +'",' +
      '        "name": "'+project.name+'",' +
      '        "version": "'+project.version+'",' +
      '        "description": "'+project.description+'"' +
      '    }' +
      '}'
}

EOT
) >> $gradleFilePath