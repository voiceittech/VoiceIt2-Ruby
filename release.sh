#!/bin/bash
commit=$(git log -1 --pretty=%B | head -n 1)
version=$(echo $(gem search voiceit2 | awk 'NR==1{print $2}' | tr -d "()") | tr "." "\n")
set -- $version
major=$1
minor=$2
patch=$3
wrapperplatformversion=$(cat ~/platformVersion)
reponame=$(basename $(git remote get-url origin) | sed 's/.\{4\}$//')
date=$(date "+%Y-%m-%d")

if [[ $commit = *"RELEASE"* ]];
then
  if [[ $major = "" ]] || [[ $minor = "" ]] || [[ $patch = "" ]];
  then
    curl -X POST -H 'Content-type: application/json' --data '{
      "icon_url": "https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/TravisCI-Mascot-1.png",
      "username": "Release Wrapper Gate",
        "attachments": [
            {
                "text": "Packaging '$reponame' failed because script could not get current version",
                "color": "danger"
            }
        ]
    }' 'https://hooks.slack.com/services/'$SLACKPARAM1'/'$SLACKPARAM2'/'$SLACKPARAM3
    echo "Unable to get current version: cannot release." 1>&2
    exit 1
  fi

  echo 'old version='$major'.'$minor'.'$patch

  if [[ $commit = *"RELEASEMAJOR"* ]];
  then
    releasetype="RELEASEMAJOR"
    major=$(($major+1))
    minor=0
    patch=0
  elif [[ $commit = *"RELEASEMINOR"* ]];
  then
    releasetype="RELEASEMINOR"
    minor=$(($minor+1))
    patch=0
  elif [[ $commit = *"RELEASEPATCH"* ]];
  then
    releasetype="RELEASEPATCH"
    patch=$(($patch+1))
  else
    curl -X POST -H 'Content-type: application/json' --data '{
      "icon_url": "https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/TravisCI-Mascot-1.png",
      "username": "Release Wrapper Gate",
        "attachments": [
            {
                "text": "Packaging '$reponame' failed. You need to specify RELEASEMAJOR, RELEASEMINOR, or RELEASEPATCH in the commit title",
                "color": "danger"
            }
        ]
    }' 'https://hooks.slack.com/services/'$SLACKPARAM1'/'$SLACKPARAM2'/'$SLACKPARAM3
    echo "Must specify RELEASEMAJOR, RELEASEMINOR, or RELEASEPATCH in the title." 1>&2
    exit 1
  fi

  echo 'new version='$major'.'$minor'.'$patch
  version=''$major'.'$minor'.'$patch
  if [[ $wrapperplatformversion = $version ]];
  then
    echo "Gem::Specification.new do |s|
      s.name        = 'VoiceIt2'
      s.version     = '"$version"'
      s.date        = '"$date"'
      s.summary     = 'VoiceIt Api 2'
      s.description = 'A wrapper for VoiceIt API 2'
      s.authors     = ['StephenAkers']
      s.email       = 'stephen@voiceit.io'
      s.files       = ['./VoiceIt2.rb']
      s.homepage    =
        'https://voiceit.io'
      s.license       = 'MIT'
      s.metadata       = {'documentation_uri' => 'https://api.voiceit.io?ruby'}
    end" > ./VoiceIt2.gemspec
    gem build VoiceIt2.gemspec
    gem push "VoiceIt2-"$version".gem" 1>&2

    if [ "$?" != "0" ]
    then
      curl -X POST -H 'Content-type: application/json' --data '{
        "icon_url": "https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/TravisCI-Mascot-1.png",
        "username": "Release Wrapper Gate",
          "attachments": [
              {
                  "text": "Packaging '$reponame' version '$version' failed.",
                  "color": "danger"
              }
          ]
      }' 'https://hooks.slack.com/services/'$SLACKPARAM1'/'$SLACKPARAM2'/'$SLACKPARAM3
      exit 1
    fi

    curl -X POST -H 'Content-type: application/json' --data '{
      "icon_url": "https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/TravisCI-Mascot-1.png",
      "username": "Release Wrapper Gate",
        "attachments": [
            {
                "text": "Packaging '$reponame' version '$version' succeeded.",
                "color": "good"
            }
        ]
    }' 'https://hooks.slack.com/services/'$SLACKPARAM1'/'$SLACKPARAM2'/'$SLACKPARAM3


    # Just the git commit message title
    title=$(git log -1 --pretty=%B | head -n 1)
    git checkout master
    # Save the messages into an array called message
    IFS=$'\n' message=($(git log -1 --pretty=%B | sed -e '1,2d'))

    if [[ $title = *"SENDEMAIL"* ]];
    then
      formattedmessages=''
      for i in "${message[@]}"
      do
        formattedmessages=$formattedmessages'|'$i
      done

      json='{"authenticationPassword":"'$EMAILAUTHPASS'", "messages" : "'$formattedmessages'", "packageManaged": "true", "instructions": "gem update VoiceIt2"}'
      curl -X POST -H "Content-Type: application/json" -d $json "https://api.voiceit.io/platform/35"
    fi
    exit 0

  else
    curl -X POST -H 'Content-type: application/json' --data '{
      "icon_url": "https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/TravisCI-Mascot-1.png",
      "username": "Release Wrapper Gate",
        "attachments": [
            {
                "text": "Packaging '$reponame' version '$version' failed because the specified release version to update package management (specified by including '$releasetype' in the commit title) does not match the platform version inside the wrapper ('$wrapperplatformversion').",
                "color": "danger"
            }
        ]
    }' 'https://hooks.slack.com/services/'$SLACKPARAM1'/'$SLACKPARAM2'/'$SLACKPARAM3
    echo "Specified release version to update package management (specified by including "$releasetype" in the commit title) does not match the platform version in wrapper source." 1>&2
    exit 1
  fi
fi
