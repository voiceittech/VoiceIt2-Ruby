#!/usr/bin/env ruby
require 'rest-client'
require 'cgi'


class VoiceIt2

  BASE_URL = 'https://api.voiceit.io/'
  VERSION = '3.6.1'

  def initialize(key, tok)
    @notification_url = ""
    @api_key = key
    @api_token = tok
  end

  def addNotificationUrl(notificationURL)
    @notification_url = "?notificationURL=" + CGI.escape(notificationURL)
  end

  def removeNotificationUrl()
    @notification_url = ""
  end

  def getAllUsers
    return RestClient::Request.new(
      :method => :get,
      :url => BASE_URL + 'users' + @notification_url,
      :user => @api_key,
      :password => @api_token,
      :headers => {
        platformId: '35',
        platformVersion: VERSION
      }).execute
    rescue => e
        e.response
  end

  def createUser
    return RestClient::Request.new(
      :method => :post,
      :url => BASE_URL + 'users' + @notification_url,
      :user => @api_key,
      :password => @api_token,
      :headers => {
        platformId: '35',
        platformVersion: VERSION
      }).execute
    rescue => e
        e.response
  end

  def checkUserExists(userId)
    return RestClient::Request.new(
      :method => :get,
      :url => BASE_URL + 'users/' + userId + @notification_url,
      :user => @api_key,
      :password => @api_token,
      :headers => {
        platformId: '35',
        platformVersion: VERSION
      }).execute
    rescue => e
        e.response
  end

  def deleteUser(userId)
    return RestClient::Request.new(
      :method => :delete,
      :url => BASE_URL + 'users/' + userId + @notification_url,
      :user => @api_key,
      :password => @api_token,
      :headers => {
        platformId: '35',
        platformVersion: VERSION
      }).execute

    rescue => e
        e.response
  end

  def createManagedSubAccount(firstName, lastName, email, password, contentLanguage)
    return  RestClient::Request.new(
      :method => :post,
      :url => BASE_URL + 'subaccount/managed' + @notification_url,
      :user => @api_key,
      :password => @api_token,
      :headers => {
        platformId: '35',
        platformVersion: VERSION
      },
      :payload => {
        :multipart => true,
        :firstName => firstName,
        :lastName => lastName,
        :email => email,
        :password => password,
        :contentLanguage => contentLanguage,
        }).execute
    rescue => e
      if e.class == Errno::ENOENT
        raise e.message
      else
        e.response
      end
  end

  def switchSubAccountType(subAccountAPIKey)
    return RestClient::Request.new(
      :method => :post,
      :url => BASE_URL + 'subaccount/' + subAccountAPIKey + '/switchType' + @notification_url,
      :user => @api_key,
      :password => @api_token,
      :headers => {
        platformId: '35',
        platformVersion: VERSION
      }).execute
    rescue => e
        e.response
  end

  def createUnmanagedSubAccount(firstName, lastName, email, password, contentLanguage)
    return  RestClient::Request.new(
      :method => :post,
      :url => BASE_URL + 'subaccount/unmanaged' + @notification_url,
      :user => @api_key,
      :password => @api_token,
      :headers => {
        platformId: '35',
        platformVersion: VERSION
      },
      :payload => {
        :multipart => true,
        :firstName => firstName,
        :lastName => lastName,
        :email => email,
        :password => password,
        :contentLanguage => contentLanguage,
        }).execute
    rescue => e
      if e.class == Errno::ENOENT
        raise e.message
      else
        e.response
      end
  end

  def regenerateSubAccountAPIToken(subAccountAPIKey)
    return RestClient::Request.new(
      :method => :post,
      :url => BASE_URL + 'subaccount/' + subAccountAPIKey + @notification_url,
      :user => @api_key,
      :password => @api_token,
      :headers => {
        platformId: '35',
        platformVersion: VERSION
      }).execute
    rescue => e
        e.response
  end

  def deleteSubAccount(subAccountAPIKey)
    return RestClient::Request.new(
      :method => :delete,
      :url => BASE_URL + 'subaccount/' + subAccountAPIKey + @notification_url,
      :user => @api_key,
      :password => @api_token,
      :headers => {
        platformId: '35',
        platformVersion: VERSION
      }).execute

    rescue => e
        e.response
  end

  def getGroupsForUser(userId)
    return RestClient::Request.new(
      :method => :get,
      :url => BASE_URL + 'users/' + userId + '/groups' + @notification_url,
      :user => @api_key,
      :password => @api_token,
      :headers => {
        platformId: '35',
        platformVersion: VERSION
      }).execute

    rescue => e
        e.response
  end

  def getAllVoiceEnrollments(userId)
    return RestClient::Request.new(
      :method => :get,
      :url => BASE_URL + 'enrollments/voice/' + userId + @notification_url,
      :user => @api_key,
      :password => @api_token,
      :headers => {
        platformId: '35',
        platformVersion: VERSION
      }).execute

    rescue => e
        e.response
  end

  def getAllVideoEnrollments(userId)
    return RestClient::Request.new(
      :method => :get,
      :url => BASE_URL + 'enrollments/video/' + userId + @notification_url,
      :user => @api_key,
      :password => @api_token,
      :headers => {
        platformId: '35',
        platformVersion: VERSION
      }).execute

    rescue => e
        e.response
  end

  def deleteAllEnrollments(userId)
    return RestClient::Request.new(
      :method => :delete,
      :url => BASE_URL + 'enrollments/' + userId + '/all' + @notification_url,
      :user => @api_key,
      :password => @api_token,
      :headers => {
        platformId: '35',
        platformVersion: VERSION
      }).execute

    rescue => e
        e.response
  end

  def getAllFaceEnrollments(userId)
    return RestClient::Request.new(
      :method => :get,
      :url => BASE_URL + 'enrollments/face/' + userId + @notification_url,
      :user => @api_key,
      :password => @api_token,
      :headers => {
        platformId: '35',
        platformVersion: VERSION
      }).execute

    rescue => e
        e.response
  end

  def createVoiceEnrollment(userId, contentLanguage, phrase, filePath)
      return RestClient::Request.new(
        :method => :post,
        :url => BASE_URL + 'enrollments/voice' + @notification_url,
        :user => @api_key,
        :password => @api_token,
        :headers => {
          platformId: '35',
          platformVersion: VERSION
        },
        :payload => {
          :multipart => true,
          :phrase => phrase,
          :userId => userId,
          :contentLanguage => contentLanguage,
          :recording => File.new(filePath, 'rb')
          }).execute
      rescue => e
        if e.class == Errno::ENOENT
          raise e.message
        else
          e.response
        end
  end

  def createVoiceEnrollmentByUrl(userId, contentLanguage, phrase, fileUrl)
    return  RestClient::Request.new(
      :method => :post,
      :url => BASE_URL + 'enrollments/voice/byUrl' + @notification_url,
      :user => @api_key,
      :password => @api_token,
      :headers => {
        platformId: '35',
        platformVersion: VERSION
      },
      :payload => {
        :multipart => true,
        :phrase => phrase,
        :userId => userId,
        :contentLanguage => contentLanguage,
        :fileUrl => fileUrl
        }).execute
    rescue => e
      if e.class == Errno::ENOENT
        raise e.message
      else
        e.response
      end
  end

  def createFaceEnrollment(userId,  filePath)
    return  RestClient::Request.new(
      :method => :post,
      :url => BASE_URL + 'enrollments/face' + @notification_url,
      :user => @api_key,
      :password => @api_token,
      :headers => {
        platformId: '35',
        platformVersion: VERSION
      },
      :payload => {
        :multipart => true,
        :userId => userId,
        :video => File.new(filePath, 'rb'),
        }).execute
    rescue => e
      if e.class == Errno::ENOENT
        raise e.message
      else
        e.response
      end
  end

  def createFaceEnrollmentByUrl(userId, fileUrl)
    return  RestClient::Request.new(
      :method => :post,
      :url => BASE_URL + 'enrollments/face/byUrl' + @notification_url,
      :user => @api_key,
      :password => @api_token,
      :headers => {
        platformId: '35',
        platformVersion: VERSION
      },
      :payload => {
        :multipart => true,
        :userId => userId,
        :fileUrl => fileUrl,
        }).execute
    rescue => e
        e.response
  end

  def createVideoEnrollment(userId, contentLanguage,  phrase, filePath)
    return  RestClient::Request.new(
      :method => :post,
      :url => BASE_URL + 'enrollments/video' + @notification_url,
      :user => @api_key,
      :password => @api_token,
      :headers => {
        platformId: '35',
        platformVersion: VERSION
      },
      :payload => {
        :multipart => true,
        :phrase => phrase,
        :userId => userId,
        :contentLanguage => contentLanguage,
        :video => File.new(filePath, 'rb'),
        }).execute
    rescue => e
      if e.class == Errno::ENOENT
        raise e.message
      else
        e.response
      end
  end

  def createVideoEnrollmentByUrl(userId, contentLanguage,  phrase, fileUrl)
    return  RestClient::Request.new(
      :method => :post,
      :url => BASE_URL + 'enrollments/video/byUrl' + @notification_url,
      :user => @api_key,
      :password => @api_token,
      :headers => {
        platformId: '35',
        platformVersion: VERSION
      },
      :payload => {
        :multipart => true,
        :phrase => phrase,
        :userId => userId,
        :contentLanguage => contentLanguage,
        :fileUrl => fileUrl,
        }).execute
    rescue => e
      if e.class == Errno::ENOENT
        raise e.message
      else
        e.response
      end
  end

  def getAllGroups()
    return RestClient::Request.new(
      :method => :get,
      :url => BASE_URL + 'groups' + @notification_url,
      :user => @api_key,
      :password => @api_token,
      :headers => {
        platformId: '35',
        platformVersion: VERSION
      }).execute
    rescue => e
        e.response
  end

  def getPhrases(contentLanguage)
    return RestClient::Request.new(
      :method => :get,
      :url => BASE_URL + 'phrases/' + contentLanguage + @notification_url,
      :user => @api_key,
      :password => @api_token,
      :headers => {
        platformId: '35',
        platformVersion: VERSION
      }).execute
    rescue => e
        e.response
  end

  def getGroup(groupId)
    return RestClient::Request.new(
      :method => :get,
      :url => BASE_URL + 'groups/' + groupId + @notification_url,
      :user => @api_key,
      :password => @api_token,
      :headers => {
        platformId: '35',
        platformVersion: VERSION
      }).execute
    rescue => e
        e.response
  end

  def groupExists(groupId)
    return RestClient::Request.new(
      :method => :get,
      :url => BASE_URL + 'groups/' + groupId + '/exists' + @notification_url,
      :user => @api_key,
      :password => @api_token,
      :headers => {
        platformId: '35',
        platformVersion: VERSION
      }).execute
    rescue => e
        e.response
  end

  def createGroup(description)
    return RestClient::Request.new(
      :method => :post,
      :url => BASE_URL + 'groups' + @notification_url,
      :user => @api_key,
      :password => @api_token,
      :headers => {
        platformId: '35',
        platformVersion: VERSION
      },
      :payload => {
        :multipart => true,
        :description => description
        }).execute
    rescue => e
        e.response
  end

  def addUserToGroup(groupId, userId)
    return RestClient::Request.new(
      :method => :put,
      :url => BASE_URL + 'groups/addUser' + @notification_url,
      :user => @api_key,
      :password => @api_token,
      :headers => {
        platformId: '35',
        platformVersion: VERSION
      },
      :payload => {
        :multipart => true,
        :groupId => groupId,
        :userId => userId
        }).execute
    rescue => e
        e.response
  end

  def removeUserFromGroup(groupId, userId)
    return RestClient::Request.new(
      :method => :put,
      :url => BASE_URL + 'groups/removeUser' + @notification_url,
      :user => @api_key,
      :password => @api_token,
      :headers => {
        platformId: '35',
        platformVersion: VERSION
      },
      :payload => {
        :multipart => true,
        :groupId => groupId,
        :userId => userId
        }).execute
    rescue => e
        e.response
  end

  def deleteGroup(groupId)
    return RestClient::Request.new(
      :method => :delete,
      :url => BASE_URL + 'groups/' + groupId + @notification_url,
      :user => @api_key,
      :password => @api_token,
      :headers => {
        platformId: '35',
        platformVersion: VERSION
      }).execute
    rescue => e
        e.response
  end

  def voiceVerification(userId, contentLanguage, phrase, filePath)
    return  RestClient::Request.new(
      :method => :post,
      :url => BASE_URL + 'verification/voice' + @notification_url,
      :user => @api_key,
      :password => @api_token,
      :headers => {
        platformId: '35',
        platformVersion: VERSION
      },
      :payload => {
        :multipart => true,
        :phrase => phrase,
        :userId => userId,
        :contentLanguage => contentLanguage,
        :recording => File.new(filePath, 'rb')
        }).execute
    rescue => e
      if e.class == Errno::ENOENT
        raise e.message
      else
        e.response
      end
  end

  def voiceVerificationByUrl(userId, contentLanguage, phrase, fileUrl)
    return  RestClient::Request.new(
      :method => :post,
      :url => BASE_URL + 'verification/voice/byUrl' + @notification_url,
      :user => @api_key,
      :password => @api_token,
      :headers => {
        platformId: '35',
        platformVersion: VERSION
      },
      :payload => {
        :multipart => true,
        :phrase => phrase,
        :userId => userId,
        :contentLanguage => contentLanguage,
        :fileUrl => fileUrl
        }).execute
    rescue => e
      if e.class == Errno::ENOENT
        raise e.message
      else
        e.response
      end
  end

  def faceVerification(userId, filePath)
    return  RestClient::Request.new(
      :method => :post,
      :url => BASE_URL + 'verification/face' + @notification_url,
      :user => @api_key,
      :password => @api_token,
      :headers => {
        platformId: '35',
        platformVersion: VERSION
      },
      :payload => {
        :multipart => true,
        :userId => userId,
        :video => File.new(filePath, 'rb')
        }).execute
    rescue => e
      if e.class == Errno::ENOENT
        raise e.message
      else
        e.response
      end
  end

  def faceVerificationByUrl(userId, fileUrl)
    return  RestClient::Request.new(
      :method => :post,
      :url => BASE_URL + 'verification/face/byUrl' + @notification_url,
      :user => @api_key,
      :password => @api_token,
      :headers => {
        platformId: '35',
        platformVersion: VERSION
      },
      :payload => {
        :multipart => true,
        :userId => userId,
        :fileUrl => fileUrl
        }).execute
    rescue => e
        e.response
  end

  def videoVerification(userId, contentLanguage, phrase, filePath)
    return  RestClient::Request.new(
      :method => :post,
      :url => BASE_URL + 'verification/video' + @notification_url,
      :user => @api_key,
      :password => @api_token,
      :headers => {
        platformId: '35',
        platformVersion: VERSION
      },
      :payload => {
        :multipart => true,
        :userId => userId,
        :phrase => phrase,
        :contentLanguage => contentLanguage,
        :video => File.new(filePath, 'rb')
        }).execute
    rescue => e
      if e.class == Errno::ENOENT
        raise e.message
      else
        e.response
      end
  end

  def videoVerificationByUrl(userId, contentLanguage, phrase, fileUrl)
    return  RestClient::Request.new(
      :method => :post,
      :url => BASE_URL + 'verification/video/byUrl' + @notification_url,
      :user => @api_key,
      :password => @api_token,
      :headers => {
        platformId: '35',
        platformVersion: VERSION
      },
      :payload => {
        :multipart => true,
        :phrase => phrase,
        :userId => userId,
        :contentLanguage => contentLanguage,
        :fileUrl => fileUrl
        }).execute
    rescue => e
      if e.class == Errno::ENOENT
        raise e.message
      else
        e.response
      end
  end

  def voiceIdentification(groupId, contentLanguage, phrase, filePath)
    return  RestClient::Request.new(
      :method => :post,
      :url => BASE_URL + 'identification/voice' + @notification_url,
      :user => @api_key,
      :password => @api_token,
      :headers => {
        platformId: '35',
        platformVersion: VERSION
      },
      :payload => {
        :multipart => true,
        :phrase => phrase,
        :groupId => groupId,
        :contentLanguage => contentLanguage,
        :recording => File.new(filePath, 'rb')
        }).execute
    rescue => e
      if e.class == Errno::ENOENT
        raise e.message
      else
        e.response
      end
  end

  def voiceIdentificationByUrl(groupId, contentLanguage, phrase, fileUrl)
    return  RestClient::Request.new(
      :method => :post,
      :url => BASE_URL + 'identification/voice/byUrl' + @notification_url,
      :user => @api_key,
      :password => @api_token,
      :headers => {
        platformId: '35',
        platformVersion: VERSION
      },
      :payload => {
        :multipart => true,
        :phrase => phrase,
        :groupId => groupId,
        :contentLanguage => contentLanguage,
        :fileUrl => fileUrl
        }).execute
    rescue => e
      if e.class == Errno::ENOENT
        raise e.message
      else
        e.response
      end
  end

  def faceIdentification(groupId, filePath)
    return  RestClient::Request.new(
      :method => :post,
      :url => BASE_URL + 'identification/face' + @notification_url,
      :user => @api_key,
      :password => @api_token,
      :headers => {
        platformId: '35',
        platformVersion: VERSION
      },
      :payload => {
        :multipart => true,
        :groupId => groupId,
        :video => File.new(filePath, 'rb')
        }).execute
    rescue => e
      if e.class == Errno::ENOENT
        raise e.message
      else
        e.response
      end
  end

  def faceIdentificationByUrl(groupId,fileUrl)
    return  RestClient::Request.new(
      :method => :post,
      :url => BASE_URL + 'identification/face/byUrl' + @notification_url,
      :user => @api_key,
      :password => @api_token,
      :headers => {
        platformId: '35',
        platformVersion: VERSION
      },
      :payload => {
        :multipart => true,
        :groupId => groupId,
        :fileUrl => fileUrl
        }).execute
    rescue => e
        e.response
  end

  def videoIdentification(groupId, contentLanguage, phrase, filePath)
    return  RestClient::Request.new(
      :method => :post,
      :url => BASE_URL + 'identification/video' + @notification_url,
      :user => @api_key,
      :password => @api_token,
      :headers => {
        platformId: '35',
        platformVersion: VERSION
      },
      :payload => {
        :multipart => true,
        :phrase => phrase,
        :groupId => groupId,
        :contentLanguage => contentLanguage,
        :video => File.new(filePath, 'rb')
        }).execute
    rescue => e
      if e.class == Errno::ENOENT
        raise e.message
      else
        e.response
      end
  end

  def videoIdentificationByUrl(groupId, contentLanguage, phrase, fileUrl)
    return  RestClient::Request.new(
      :method => :post,
      :url => BASE_URL + 'identification/video/byUrl' + @notification_url,
      :user => @api_key,
      :password => @api_token,
      :headers => {
        platformId: '35',
        platformVersion: VERSION
      },
      :payload => {
        :multipart => true,
        :phrase => phrase,
        :groupId => groupId,
        :contentLanguage => contentLanguage,
        :fileUrl => fileUrl
        }).execute
    rescue => e
      if e.class == Errno::ENOENT
        raise e.message
      else
        e.response
      end
  end

  def createUserToken(userId, secondsToTimeout)
    return RestClient::Request.new(
      :method => :post,
      :url => BASE_URL + 'users/' + userId + '/token?timeOut=' + secondsToTimeout.to_s,
      :user => @api_key,
      :password => @api_token,
      :headers => {
        platformId: '35',
        platformVersion: VERSION
      }).execute
    rescue => e
        e.response
  end

  def expireUserTokens(userId)
    return RestClient::Request.new(
      :method => :post,
      :url => BASE_URL + 'users/' + userId + '/expireTokens',
      :user => @api_key,
      :password => @api_token,
      :headers => {
        platformId: '35',
        platformVersion: VERSION
      }).execute
    rescue => e
        e.response
  end

  attr_reader :BASE_URL
  attr_reader :notification_url
  attr_reader :api_key
  attr_reader :api_token

end
