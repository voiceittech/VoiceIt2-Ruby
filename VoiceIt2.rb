#!/usr/bin/env ruby
require 'rest-client'

class VoiceIt2

  def initialize(key, tok)
    @BASE_URL = URI('https://api.voiceit.io/')
    @api_key = key
    @api_token = tok
  end

  def getAllUsers
    return RestClient::Request.new(
      :method => :get,
      :url => @BASE_URL.to_s + 'users',
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
      :url => @BASE_URL.to_s + 'users',
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
      :url => @BASE_URL.to_s + 'users/' + userId,
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
      :url => @BASE_URL.to_s + 'users/' + userId,
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
      :url => @BASE_URL.to_s + 'users/' + userId + '/groups',
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
      :url => @BASE_URL.to_s + 'enrollments/voice/' + userId,
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
      :url => @BASE_URL.to_s + 'enrollments/video/' + userId,
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
      :url => @BASE_URL.to_s + 'enrollments/' + userId + '/all',
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
      :url => @BASE_URL.to_s + 'enrollments/' + userId + '/voice',
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
      :url => @BASE_URL.to_s + 'enrollments/' + userId + '/face',
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
      :url => @BASE_URL.to_s + 'enrollments/' + userId + '/video',
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
      :url => @BASE_URL.to_s + 'enrollments/face/' + userId,
      :user => @api_key,
      :password => @api_token
      :headers => {
        platformId: '35'
      }).execute

    rescue => e
        e.response
  end

  def createVoiceEnrollment(userId, contentLanguage, phrase, filePath)
      return RestClient::Request.new(
        :method => :post,
        :url => @BASE_URL.to_s + 'enrollments/voice',
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
      :url => @BASE_URL.to_s + 'enrollments/voice/byUrl',
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
      :url => @BASE_URL.to_s + 'enrollments/face',
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
      :url => @BASE_URL.to_s + 'enrollments/face/byUrl',
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

  def createVideoEnrollment(userId, contentLanguage,  phrase, filePath,doBlinkDetection = false)
    return  RestClient::Request.new(
      :method => :post,
      :url => @BASE_URL.to_s + 'enrollments/video',
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
      :url => @BASE_URL.to_s + 'enrollments/video/byUrl',
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
      :url => @BASE_URL.to_s + 'enrollments/face/' + userId + '/' + faceEnrollmentId.to_s,
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
      :url => @BASE_URL.to_s + 'enrollments/voice/' + userId + '/' + voiceEnrollmentId.to_s,
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
      :url => @BASE_URL.to_s + 'enrollments/video/' + userId + '/' + enrollmentId.to_s,
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
      :url => @BASE_URL.to_s + 'groups',
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
      :url => @BASE_URL.to_s + 'phrases/' + contentLanguage,
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
      :url => @BASE_URL.to_s + 'groups/' + groupId,
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
      :url => @BASE_URL.to_s + 'groups/' + groupId + '/exists',
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
      :url => @BASE_URL.to_s + 'groups',
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
      :url => @BASE_URL.to_s + 'groups/addUser',
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
      :url => @BASE_URL.to_s + 'groups/removeUser',
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
      :url => @BASE_URL.to_s + 'groups/' + groupId,
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
      :url => @BASE_URL.to_s + 'verification/voice',
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
      :url => @BASE_URL.to_s + 'verification/voice/byUrl',
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
      :url => @BASE_URL.to_s + 'verification/face',
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
      :url => @BASE_URL.to_s + 'verification/face/byUrl',
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
      :url => @BASE_URL.to_s + 'verification/video',
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
      :url => @BASE_URL.to_s + 'verification/video/byUrl',
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
      :url => @BASE_URL.to_s + 'identification/voice',
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
      :url => @BASE_URL.to_s + 'identification/voice/byUrl',
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
      :url => @BASE_URL.to_s + 'identification/face',
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
      :url => @BASE_URL.to_s + 'identification/face/byUrl',
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
      :url => @BASE_URL.to_s + 'identification/video',
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
      :url => @BASE_URL.to_s + 'identification/video/byUrl',
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


end
