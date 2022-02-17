#!/usr/bin/env ruby
require 'rest-client'
require 'cgi'


class VoiceIt2

  VERSION = '3.7.0'

  def initialize(key, tok, custom_url: 'https://api.voiceit.io')
    @base_url = custom_url
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
      :url => @base_url + '/users' + @notification_url,
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
      :url => @base_url + '/users' + @notification_url,
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
      :url => @base_url + '/users/' + userId + @notification_url,
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
      :url => @base_url + '/users/' + userId + @notification_url,
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
      :url => @base_url + '/subaccount/managed' + @notification_url,
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
      :url => @base_url + '/subaccount/' + subAccountAPIKey + '/switchType' + @notification_url,
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
      :url => @base_url + '/subaccount/unmanaged' + @notification_url,
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
      :url => @base_url + '/subaccount/' + subAccountAPIKey + @notification_url,
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
      :url => @base_url + '/subaccount/' + subAccountAPIKey + @notification_url,
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
      :url => @base_url + '/users/' + userId + '/groups' + @notification_url,
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
      :url => @base_url + '/enrollments/voice/' + userId + @notification_url,
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
      :url => @base_url + '/enrollments/video/' + userId + @notification_url,
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
      :url => @base_url + '/enrollments/' + userId + '/all' + @notification_url,
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
      :url => @base_url + '/enrollments/face/' + userId + @notification_url,
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
        :url => @base_url + '/enrollments/voice' + @notification_url,
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
      :url => @base_url + '/enrollments/voice/byUrl' + @notification_url,
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
      :url => @base_url + '/enrollments/face' + @notification_url,
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
      :url => @base_url + '/enrollments/face/byUrl' + @notification_url,
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
      :url => @base_url + '/enrollments/video' + @notification_url,
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
      :url => @base_url + '/enrollments/video/byUrl' + @notification_url,
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
      :url => @base_url + '/groups' + @notification_url,
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
      :url => @base_url + '/phrases/' + contentLanguage + @notification_url,
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
      :url => @base_url + '/groups/' + groupId + @notification_url,
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
      :url => @base_url + '/groups/' + groupId + '/exists' + @notification_url,
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
      :url => @base_url + '/groups' + @notification_url,
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
      :url => @base_url + '/groups/addUser' + @notification_url,
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
      :url => @base_url + '/groups/removeUser' + @notification_url,
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
      :url => @base_url + '/groups/' + groupId + @notification_url,
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
      :url => @base_url + '/verification/voice' + @notification_url,
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
      :url => @base_url + '/verification/voice/byUrl' + @notification_url,
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
      :url => @base_url + '/verification/face' + @notification_url,
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
      :url => @base_url + '/verification/face/byUrl' + @notification_url,
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
      :url => @base_url + '/verification/video' + @notification_url,
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
      :url => @base_url + '/verification/video/byUrl' + @notification_url,
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
      :url => @base_url + '/identification/voice' + @notification_url,
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
      :url => @base_url + '/identification/voice/byUrl' + @notification_url,
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
      :url => @base_url + '/identification/face' + @notification_url,
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
      :url => @base_url + '/identification/face/byUrl' + @notification_url,
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
      :url => @base_url + '/identification/video' + @notification_url,
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
      :url => @base_url + '/identification/video/byUrl' + @notification_url,
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
      :url => @base_url + '/users/' + userId + '/token?timeOut=' + secondsToTimeout.to_s,
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
      :url => @base_url + '/users/' + userId + '/expireTokens',
      :user => @api_key,
      :password => @api_token,
      :headers => {
        platformId: '35',
        platformVersion: VERSION
      }).execute
    rescue => e
        e.response
  end

  attr_reader :base_url
  attr_reader :notification_url
  attr_reader :api_key
  attr_reader :api_token

end
