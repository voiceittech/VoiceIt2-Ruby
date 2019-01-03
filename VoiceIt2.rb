#!/usr/bin/env ruby
require 'rest-client'
require 'cgi'

class VoiceIt2

  def initialize(key, tok)
    @BASE_URL = URI('https://api.voiceit.io/')
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
      :url => @BASE_URL.to_s + 'users' + @notification_url,
      :user => @api_key,
      :password => @api_token,
      :headers => {
        platformId: '35'
      }).execute
    rescue => e
        e.response
  end

  def createUser
    return RestClient::Request.new(
      :method => :post,
      :url => @BASE_URL.to_s + 'users' + @notification_url,
      :user => @api_key,
      :password => @api_token,
      :headers => {
        platformId: '35'
      }).execute
    rescue => e
        e.response
  end

  def checkUserExists(userId)
    return RestClient::Request.new(
      :method => :get,
      :url => @BASE_URL.to_s + 'users/' + userId + @notification_url,
      :user => @api_key,
      :password => @api_token,
      :headers => {
        platformId: '35'
      }).execute
    rescue => e
        e.response
  end

  def deleteUser(userId)
    return RestClient::Request.new(
      :method => :delete,
      :url => @BASE_URL.to_s + 'users/' + userId + @notification_url,
      :user => @api_key,
      :password => @api_token,
      :headers => {
        platformId: '35'
      }).execute

    rescue => e
        e.response
  end

  def getGroupsForUser(userId)
    return RestClient::Request.new(
      :method => :get,
      :url => @BASE_URL.to_s + 'users/' + userId + '/groups' + @notification_url,
      :user => @api_key,
      :password => @api_token,
      :headers => {
        platformId: '35'
      }).execute

    rescue => e
        e.response
  end

  def getAllVoiceEnrollments(userId)
    return RestClient::Request.new(
      :method => :get,
      :url => @BASE_URL.to_s + 'enrollments/voice/' + userId + @notification_url,
      :user => @api_key,
      :password => @api_token,
      :headers => {
        platformId: '35'
      }).execute

    rescue => e
        e.response
  end

  def getAllVideoEnrollments(userId)
    return RestClient::Request.new(
      :method => :get,
      :url => @BASE_URL.to_s + 'enrollments/video/' + userId + @notification_url,
      :user => @api_key,
      :password => @api_token,
      :headers => {
        platformId: '35'
      }).execute

    rescue => e
        e.response
  end

  def deleteAllEnrollments(userId)
    return RestClient::Request.new(
      :method => :delete,
      :url => @BASE_URL.to_s + 'enrollments/' + userId + '/all' + @notification_url,
      :user => @api_key,
      :password => @api_token,
      :headers => {
        platformId: '35'
      }).execute

    rescue => e
        e.response
  end

  def deleteAllVoiceEnrollments(userId)
    return RestClient::Request.new(
      :method => :delete,
      :url => @BASE_URL.to_s + 'enrollments/' + userId + '/voice' + @notification_url,
      :user => @api_key,
      :password => @api_token,
      :headers => {
        platformId: '35'
      }).execute

    rescue => e
        e.response
  end

  def deleteAllFaceEnrollments(userId)
    return RestClient::Request.new(
      :method => :delete,
      :url => @BASE_URL.to_s + 'enrollments/' + userId + '/face' + @notification_url,
      :user => @api_key,
      :password => @api_token,
      :headers => {
        platformId: '35'
      }).execute

    rescue => e
        e.response
  end

  def deleteAllVideoEnrollments(userId)
    return RestClient::Request.new(
      :method => :delete,
      :url => @BASE_URL.to_s + 'enrollments/' + userId + '/video' + @notification_url,
      :user => @api_key,
      :password => @api_token,
      :headers => {
        platformId: '35'
      }).execute

    rescue => e
        e.response
  end

  def getAllFaceEnrollments(userId)
    return RestClient::Request.new(
      :method => :get,
      :url => @BASE_URL.to_s + 'enrollments/face/' + userId + @notification_url,
      :user => @api_key,
      :password => @api_token,
      :headers => {
        platformId: '35'
      }).execute

    rescue => e
        e.response
  end

  def createVoiceEnrollment(userId, contentLanguage, phrase, filePath)
      return RestClient::Request.new(
        :method => :post,
        :url => @BASE_URL.to_s + 'enrollments/voice' + @notification_url,
        :user => @api_key,
        :password => @api_token,
        :headers => {
          platformId: '35'
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
      :url => @BASE_URL.to_s + 'enrollments/voice/byUrl' + @notification_url,
      :user => @api_key,
      :password => @api_token,
      :headers => {
        platformId: '35'
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
      :url => @BASE_URL.to_s + 'enrollments/face' + @notification_url,
      :user => @api_key,
      :password => @api_token,
      :headers => {
        platformId: '35'
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
      :url => @BASE_URL.to_s + 'enrollments/face/byUrl' + @notification_url,
      :user => @api_key,
      :password => @api_token,
      :headers => {
        platformId: '35'
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
      :url => @BASE_URL.to_s + 'enrollments/video' + @notification_url,
      :user => @api_key,
      :password => @api_token,
      :headers => {
        platformId: '35'
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
      :url => @BASE_URL.to_s + 'enrollments/video/byUrl' + @notification_url,
      :user => @api_key,
      :password => @api_token,
      :headers => {
        platformId: '35'
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

  def deleteFaceEnrollment(userId, faceEnrollmentId)
    return RestClient::Request.new(
      :method => :delete,
      :url => @BASE_URL.to_s + 'enrollments/face/' + userId + '/' + faceEnrollmentId.to_s + @notification_url,
      :user => @api_key,
      :password => @api_token,
      :headers => {
        platformId: '35'
      }).execute
    rescue => e
        e.response
  end

  def deleteVoiceEnrollment(userId, voiceEnrollmentId)
    return RestClient::Request.new(
      :method => :delete,
      :url => @BASE_URL.to_s + 'enrollments/voice/' + userId + '/' + voiceEnrollmentId.to_s + @notification_url,
      :user => @api_key,
      :password => @api_token,
      :headers => {
        platformId: '35'
      }).execute
    rescue => e
        e.response
  end

  def deleteVideoEnrollment(userId, enrollmentId)
    return RestClient::Request.new(
      :method => :delete,
      :url => @BASE_URL.to_s + 'enrollments/video/' + userId + '/' + enrollmentId.to_s + @notification_url,
      :user => @api_key,
      :password => @api_token,
      :headers => {
        platformId: '35'
      }).execute

    rescue => e
        e.response
  end

  def getAllGroups()
    return RestClient::Request.new(
      :method => :get,
      :url => @BASE_URL.to_s + 'groups' + @notification_url,
      :user => @api_key,
      :password => @api_token,
      :headers => {
        platformId: '35'
      }).execute
    rescue => e
        e.response
  end

  def getPhrases(contentLanguage)
    return RestClient::Request.new(
      :method => :get,
      :url => @BASE_URL.to_s + 'phrases/' + contentLanguage + @notification_url,
      :user => @api_key,
      :password => @api_token,
      :headers => {
        platformId: '35'
      }).execute
    rescue => e
        e.response
  end

  def getGroup(groupId)
    return RestClient::Request.new(
      :method => :get,
      :url => @BASE_URL.to_s + 'groups/' + groupId + @notification_url,
      :user => @api_key,
      :password => @api_token,
      :headers => {
        platformId: '35'
      }).execute
    rescue => e
        e.response
  end

  def groupExists(groupId)
    return RestClient::Request.new(
      :method => :get,
      :url => @BASE_URL.to_s + 'groups/' + groupId + '/exists' + @notification_url,
      :user => @api_key,
      :password => @api_token,
      :headers => {
        platformId: '35'
      }).execute
    rescue => e
        e.response
  end

  def createGroup(description)
    return RestClient::Request.new(
      :method => :post,
      :url => @BASE_URL.to_s + 'groups' + @notification_url,
      :user => @api_key,
      :password => @api_token,
      :headers => {
        platformId: '35'
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
      :url => @BASE_URL.to_s + 'groups/addUser' + @notification_url,
      :user => @api_key,
      :password => @api_token,
      :headers => {
        platformId: '35'
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
      :url => @BASE_URL.to_s + 'groups/removeUser' + @notification_url,
      :user => @api_key,
      :password => @api_token,
      :headers => {
        platformId: '35'
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
      :url => @BASE_URL.to_s + 'groups/' + groupId + @notification_url,
      :user => @api_key,
      :password => @api_token,
      :headers => {
        platformId: '35'
      }).execute
    rescue => e
        e.response
  end

  def voiceVerification(userId, contentLanguage, phrase, filePath)
    return  RestClient::Request.new(
      :method => :post,
      :url => @BASE_URL.to_s + 'verification/voice' + @notification_url,
      :user => @api_key,
      :password => @api_token,
      :headers => {
        platformId: '35'
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
      :url => @BASE_URL.to_s + 'verification/voice/byUrl' + @notification_url,
      :user => @api_key,
      :password => @api_token,
      :headers => {
        platformId: '35'
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
      :url => @BASE_URL.to_s + 'verification/face' + @notification_url,
      :user => @api_key,
      :password => @api_token,
      :headers => {
        platformId: '35'
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
      :url => @BASE_URL.to_s + 'verification/face/byUrl' + @notification_url,
      :user => @api_key,
      :password => @api_token,
      :headers => {
        platformId: '35'
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
      :url => @BASE_URL.to_s + 'verification/video' + @notification_url,
      :user => @api_key,
      :password => @api_token,
      :headers => {
        platformId: '35'
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
      :url => @BASE_URL.to_s + 'verification/video/byUrl' + @notification_url,
      :user => @api_key,
      :password => @api_token,
      :headers => {
        platformId: '35'
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
      :url => @BASE_URL.to_s + 'identification/voice' + @notification_url,
      :user => @api_key,
      :password => @api_token,
      :headers => {
        platformId: '35'
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
      :url => @BASE_URL.to_s + 'identification/voice/byUrl' + @notification_url,
      :user => @api_key,
      :password => @api_token,
      :headers => {
        platformId: '35'
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
      :url => @BASE_URL.to_s + 'identification/face' + @notification_url,
      :user => @api_key,
      :password => @api_token,
      :headers => {
        platformId: '35'
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
      :url => @BASE_URL.to_s + 'identification/face/byUrl' + @notification_url,
      :user => @api_key,
      :password => @api_token,
      :headers => {
        platformId: '35'
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
      :url => @BASE_URL.to_s + 'identification/video' + @notification_url,
      :user => @api_key,
      :password => @api_token,
      :headers => {
        platformId: '35'
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
      :url => @BASE_URL.to_s + 'identification/video/byUrl' + @notification_url,
      :user => @api_key,
      :password => @api_token,
      :headers => {
        platformId: '35'
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

  def createUserToken(userId, timeOut)
    if @notification_url == ''
      return RestClient::Request.new(
        :method => :post,
        :url => @BASE_URL.to_s + 'users/' + userId + '/token?timeOut=' + timeOut.to_s,
        :user => @api_key,
        :password => @api_token,
        :headers => {
          platformId: '35'
        }).execute
    else
      return RestClient::Request.new(
        :method => :post,
        :url => @BASE_URL.to_s + 'users/' + userId + '/token' + @notification_url + '&timeOut=' + timeOut.to_s,
        :user => @api_key,
        :password => @api_token,
        :headers => {
          platformId: '35'
        }).execute
    end
    rescue => e
        e.response
  end

  attr_reader :BASE_URL
  attr_reader :notification_url
  attr_reader :api_key
  attr_reader :api_token

end
