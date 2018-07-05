#!/usr/bin/env ruby
require 'rest_client'

class VoiceIt2

  def initialize(key, tok)
    @BASE_URL = URI('https://api.voiceit.io')
    @api_key = key
    @api_token = tok
  end

  def getAllUsers
    return RestClient::Request.new(
      :method => :get,
      :url => @BASE_URL.to_s + '/users',
      :user => @api_key,
      :password => @api_token).execute
    rescue => e
        e.response
  end

  def createUser
    return RestClient::Request.new(
      :method => :post,
      :url => @BASE_URL.to_s + '/users',
      :user => @api_key,
      :password => @api_token).execute
    rescue => e
        e.response
  end

  def checkUserExists(userId)
    return RestClient::Request.new(
      :method => :get,
      :url => @BASE_URL.to_s + '/users/' + userId,
      :user => @api_key,
      :password => @api_token).execute
    rescue => e
        e.response
  end

  def deleteUser(userId)
    return RestClient::Request.new(
      :method => :delete,
      :url => @BASE_URL.to_s + '/users/' + userId,
      :user => @api_key,
      :password => @api_token).execute
    rescue => e
        e.response
  end

  def getGroupsForUser(userId)
    return RestClient::Request.new(
      :method => :get,
      :url => @BASE_URL.to_s + '/users/' + userId + '/groups',
      :user => @api_key,
      :password => @api_token).execute
    rescue => e
        e.response
  end

  def getAllEnrollmentsForUser(userId)
    return RestClient::Request.new(
      :method => :get,
      :url => @BASE_URL.to_s + '/enrollments/' + userId,
      :user => @api_key,
      :password => @api_token).execute
    rescue => e
        e.response
  end

  def deleteAllEnrollmentsForUser(userId)
    return RestClient::Request.new(
      :method => :delete,
      :url => @BASE_URL.to_s + '/enrollments/' + userId + '/all',
      :user => @api_key,
      :password => @api_token).execute
    rescue => e
        e.response
  end

  def getFaceEnrollmentsForUser(userId)
    return RestClient::Request.new(
      :method => :get,
      :url => @BASE_URL.to_s + '/enrollments/face/' + userId,
      :user => @api_key,
      :password => @api_token).execute
    rescue => e
        e.response
  end

  def createVoiceEnrollment(userId, contentLanguage, filePath)
    return  RestClient::Request.new(
      :method => :post,
      :url => @BASE_URL.to_s + '/enrollments',
      :user => @api_key,
      :password => @api_token,
      :payload => {
        :multipart => true,
        :userId => userId,
        :contentLanguage => contentLanguage,
        :recording => File.new(filePath, 'rb')
        }).execute
    rescue => e
        e.response
  end

  def createVoiceEnrollmentByUrl(userId, contentLanguage, fileUrl)
    return  RestClient::Request.new(
      :method => :post,
      :url => @BASE_URL.to_s + '/enrollments/byUrl',
      :user => @api_key,
      :password => @api_token,
      :payload => {
        :multipart => true,
        :userId => userId,
        :contentLanguage => contentLanguage,
        :fileUrl => fileUrl
        }).execute
    rescue => e
        e.response
  end

  def createFaceEnrollment(userId, filePath, doBlinkDetection = false)
    return  RestClient::Request.new(
      :method => :post,
      :url => @BASE_URL.to_s + '/enrollments/face',
      :user => @api_key,
      :password => @api_token,
      :payload => {
        :multipart => true,
        :userId => userId,
        :video => File.new(filePath, 'rb'),
        :doBlinkDetection => doBlinkDetection
        }).execute
    rescue => e
        e.response
  end

  def createVideoEnrollment(userId, contentLanguage, filePath, doBlinkDetection = false)
    return  RestClient::Request.new(
      :method => :post,
      :url => @BASE_URL.to_s + '/enrollments/video',
      :user => @api_key,
      :password => @api_token,
      :payload => {
        :multipart => true,
        :userId => userId,
        :contentLanguage => contentLanguage,
        :video => File.new(filePath, 'rb'),
        :doBlinkDetection => doBlinkDetection
        }).execute
    rescue => e
        e.response
  end

  def createVideoEnrollmentByUrl(userId, contentLanguage, fileUrl, doBlinkDetection = false)
    return  RestClient::Request.new(
      :method => :post,
      :url => @BASE_URL.to_s + '/enrollments/video/byUrl',
      :user => @api_key,
      :password => @api_token,
      :payload => {
        :multipart => true,
        :userId => userId,
        :contentLanguage => contentLanguage,
        :fileUrl => fileUrl,
        :doBlinkDetection => doBlinkDetection
        }).execute
    rescue => e
        e.response
  end

  def deleteFaceEnrollment(userId, faceEnrollmentId)
    return RestClient::Request.new(
      :method => :delete,
      :url => @BASE_URL.to_s + '/enrollments/face/' + userId + '/' + faceEnrollmentId,
      :user => @api_key,
      :password => @api_token).execute
    rescue => e
        e.response
  end

  def deleteEnrollmentForUser(userId, enrollmentId)
    return RestClient::Request.new(
      :method => :delete,
      :url => @BASE_URL.to_s + '/enrollments/' + userId + '/' + enrollmentId,
      :user => @api_key,
      :password => @api_token).execute
    rescue => e
        e.response
  end

  def getAllGroups()
    return RestClient::Request.new(
      :method => :get,
      :url => @BASE_URL.to_s + '/groups',
      :user => @api_key,
      :password => @api_token).execute
    rescue => e
        e.response
  end

  def getGroup(groupId)
    return RestClient::Request.new(
      :method => :get,
      :url => @BASE_URL.to_s + '/groups/' + groupId,
      :user => @api_key,
      :password => @api_token).execute
    rescue => e
        e.response
  end

  def groupExists(groupId)
    return RestClient::Request.new(
      :method => :get,
      :url => @BASE_URL.to_s + '/groups/' + groupId + '/exists',
      :user => @api_key,
      :password => @api_token).execute
    rescue => e
        e.response
  end

  def createGroup(description)
    return RestClient::Request.new(
      :method => :post,
      :url => @BASE_URL.to_s + '/groups',
      :user => @api_key,
      :password => @api_token,
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
      :url => @BASE_URL.to_s + '/groups/addUser',
      :user => @api_key,
      :password => @api_token,
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
      :url => @BASE_URL.to_s + '/groups/removeUser',
      :user => @api_key,
      :password => @api_token,
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
      :url => @BASE_URL.to_s + '/groups/' + groupId,
      :user => @api_key,
      :password => @api_token).execute
    rescue => e
        e.response
  end

  def voiceVerification(userId, contentLanguage, filePath)
    return  RestClient::Request.new(
      :method => :post,
      :url => @BASE_URL.to_s + '/verification',
      :user => @api_key,
      :password => @api_token,
      :payload => {
        :multipart => true,
        :userId => userId,
        :contentLanguage => contentLanguage,
        :recording => File.new(filePath, 'rb')
        }).execute
    rescue => e
        e.response
  end

  def voiceVerificationByUrl(userId, contentLanguage, fileUrl)
    return  RestClient::Request.new(
      :method => :post,
      :url => @BASE_URL.to_s + '/verification/byUrl',
      :user => @api_key,
      :password => @api_token,
      :payload => {
        :multipart => true,
        :userId => userId,
        :contentLanguage => contentLanguage,
        :fileUrl => fileUrl
        }).execute
    rescue => e
        e.response
  end

  def faceVerification(userId, filePath, doBlinkDetection = false)
    return  RestClient::Request.new(
      :method => :post,
      :url => @BASE_URL.to_s + '/verification/face',
      :user => @api_key,
      :password => @api_token,
      :payload => {
        :multipart => true,
        :userId => userId,
        :doBlinkDetection => doBlinkDetection,
        :video => File.new(filePath, 'rb')
        }).execute
    rescue => e
        e.response
  end

  def videoVerification(userId, contentLanguage, filePath, doBlinkDetection = false)
    return  RestClient::Request.new(
      :method => :post,
      :url => @BASE_URL.to_s + '/verification/video',
      :user => @api_key,
      :password => @api_token,
      :payload => {
        :multipart => true,
        :userId => userId,
        :contentLanguage => contentLanguage,
        :doBlinkDetection => doBlinkDetection,
        :video => File.new(filePath, 'rb')
        }).execute
    rescue => e
        e.response
  end

  def videoVerificationByUrl(userId, contentLanguage, fileUrl, doBlinkDetection = false)
    return  RestClient::Request.new(
      :method => :post,
      :url => @BASE_URL.to_s + '/verification/video/byUrl',
      :user => @api_key,
      :password => @api_token,
      :payload => {
        :multipart => true,
        :userId => userId,
        :contentLanguage => contentLanguage,
        :doBlinkDetection => doBlinkDetection,
        :fileUrl => fileUrl
        }).execute
    rescue => e
        e.response
  end

  def voiceIdentification(groupId, contentLanguage, filePath)
    return  RestClient::Request.new(
      :method => :post,
      :url => @BASE_URL.to_s + '/identification',
      :user => @api_key,
      :password => @api_token,
      :payload => {
        :multipart => true,
        :groupId => groupId,
        :contentLanguage => contentLanguage,
        :recording => File.new(filePath, 'rb')
        }).execute
    rescue => e
        e.response
  end

  def voiceIdentificationByUrl(groupId, contentLanguage, fileUrl)
    return  RestClient::Request.new(
      :method => :post,
      :url => @BASE_URL.to_s + '/identification/byUrl',
      :user => @api_key,
      :password => @api_token,
      :payload => {
        :multipart => true,
        :groupId => groupId,
        :contentLanguage => contentLanguage,
        :fileUrl => fileUrl
        }).execute
    rescue => e
        e.response
  end

  def videoIdentification(groupId, contentLanguage, filePath, doBlinkDetection = false)
    return  RestClient::Request.new(
      :method => :post,
      :url => @BASE_URL.to_s + '/identification/video',
      :user => @api_key,
      :password => @api_token,
      :payload => {
        :multipart => true,
        :groupId => groupId,
        :contentLanguage => contentLanguage,
        :doBlinkDetection => doBlinkDetection,
        :video => File.new(filePath, 'rb')
        }).execute
    rescue => e
        e.response
  end

  def videoIdentificationByUrl(groupId, contentLanguage, fileUrl, doBlinkDetection = false)
    return  RestClient::Request.new(
      :method => :post,
      :url => @BASE_URL.to_s + '/identification/video/byUrl',
      :user => @api_key,
      :password => @api_token,
      :payload => {
        :multipart => true,
        :groupId => groupId,
        :contentLanguage => contentLanguage,
        :doBlinkDetection => doBlinkDetection,
        :fileUrl => fileUrl
        }).execute
    rescue => e
        e.response
  end


end
