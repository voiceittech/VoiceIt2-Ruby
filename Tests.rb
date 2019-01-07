require './VoiceIt2.rb'
require 'json'
require "test/unit"
require 'open-uri'

class TestVoiceIt2 < Test::Unit::TestCase

  def download_file(link, filename)
    File.open(filename, "wb") do |saved_file|
      open(link, "rb") do |read_file|
        saved_file.write(read_file.read)
      end
    end
  end

  def test_notification_url() # test webhook URL's
    viapikey = ENV['VIAPIKEY']
    viapitoken = ENV['VIAPITOKEN']
    myVoiceIt = VoiceIt2.new(viapikey, viapitoken)
    if ENV['BOXFUSE_ENV'] == 'voiceittest'
      File.write(ENV['HOME'] + '/' + 'platformVersion', VoiceIt2::VERSION)
    end
    myVoiceIt.addNotificationUrl('https://voiceit.io')
    assert_equal(myVoiceIt.notification_url, "?notificationURL=https%3A%2F%2Fvoiceit.io")
    myVoiceIt.removeNotificationUrl()
    assert_equal(myVoiceIt.notification_url, '')
  end

  def test_users_groups() # get all users, get all groups, create user, create group, add user to group, remove user from group, delete user delete group
    viapikey = ENV['VIAPIKEY']
    viapitoken = ENV['VIAPITOKEN']
    myVoiceIt = VoiceIt2.new(viapikey, viapitoken)
    ret = JSON.parse(myVoiceIt.createUser())
    assert_equal(201, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    userId = ret['userId']
    ret = JSON.parse(myVoiceIt.checkUserExists(userId))
    assert_equal(200, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    ret = JSON.parse(myVoiceIt.getAllUsers())
    assert_equal(200, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    assert_operator 0, :<=, ret['users'].length
    ret = JSON.parse(myVoiceIt.createGroup('Sample Group Description'))
    assert_equal(201, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    groupId = ret['groupId']
    ret = JSON.parse(myVoiceIt.getAllGroups())
    assert_equal(200, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    assert_operator 0, :<=, ret['groups'].length
    ret = JSON.parse(myVoiceIt.checkUserExists(userId))
    assert_equal(200, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    ret = JSON.parse(myVoiceIt.getGroup(groupId))
    assert_equal(200, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    ret = JSON.parse(myVoiceIt.groupExists(userId))
    assert_equal(200, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    ret = JSON.parse(myVoiceIt.addUserToGroup(groupId, userId))
    assert_equal(200, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    ret = JSON.parse(myVoiceIt.getGroupsForUser(userId))
    assert_equal(200, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    assert_operator 0, :<=, ret['groups'].length
    ret = JSON.parse(myVoiceIt.removeUserFromGroup(groupId, userId))
    assert_equal(200, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    ret = JSON.parse(myVoiceIt.createUserToken(userId, 5))
    assert_equal(201, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    ret = JSON.parse(myVoiceIt.getPhrases('en-US'))
    assert_equal(200, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    ret = JSON.parse(myVoiceIt.deleteUser(userId))
    assert_equal(200, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    ret = JSON.parse(myVoiceIt.deleteGroup(groupId))
    assert_equal(200, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    ret = JSON.parse(myVoiceIt.getPhrases('en-US'))
    assert_equal(200, ret['status'])
    assert_equal('SUCC', ret['responseCode'])

  end

  def test_video() # video enrollment, video verification, video identification, delete video enrollment (and by URL respectively)
    # Download files to use
    download_file('https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/videoEnrollmentArmaan1.mov', './videoEnrollmentArmaan1.mov')
    download_file('https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/videoEnrollmentArmaan2.mov', './videoEnrollmentArmaan2.mov')
    download_file('https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/videoEnrollmentArmaan3.mov', './videoEnrollmentArmaan3.mov')
    download_file('https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/videoVerificationArmaan1.mov', './videoVerificationArmaan1.mov')
    download_file('https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/videoEnrollmentStephen1.mov', './videoEnrollmentStephen1.mov')
    download_file('https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/videoEnrollmentStephen2.mov', './videoEnrollmentStephen2.mov')
    download_file('https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/videoEnrollmentStephen3.mov', './videoEnrollmentStephen3.mov')

    viapikey = ENV['VIAPIKEY']
    viapitoken = ENV['VIAPITOKEN']
    myVoiceIt = VoiceIt2.new(viapikey, viapitoken)
    userId1 = JSON.parse(myVoiceIt.createUser())['userId']
    userId2 = JSON.parse(myVoiceIt.createUser())['userId']
    groupId = JSON.parse(myVoiceIt.createGroup('Sample Group Description'))['groupId']
    myVoiceIt.addUserToGroup(groupId, userId1)
    myVoiceIt.addUserToGroup(groupId, userId2)

    # Video Enrollments
    begin
      ret = JSON.parse(myVoiceIt.createVideoEnrollment(userId1, 'en-US', 'Never forget tomorrow is a new day', './enrollmentArmaan.mov'))
    rescue => e
      assert_equal("No such file or directory ", e.message.split("@").first)
    end
    ret = JSON.parse(myVoiceIt.createVideoEnrollment(userId1, 'en-US', 'Never forget tomorrow is a new day', './videoEnrollmentArmaan1.mov'))
    assert_equal(201, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    enrollmentId1 = ret['id']
    ret = JSON.parse(myVoiceIt.createVideoEnrollment(userId1, 'en-US', 'Never forget tomorrow is a new day', './videoEnrollmentArmaan2.mov'))
    assert_equal(201, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    ret = JSON.parse(myVoiceIt.createVideoEnrollment(userId1, 'en-US', 'Never forget tomorrow is a new day', './videoEnrollmentArmaan3.mov'))
    assert_equal(201, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    ret = JSON.parse(myVoiceIt.getAllVideoEnrollments(userId1))
    assert_equal(200, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    assert_equal(3, ret['count'])
    ret = JSON.parse(myVoiceIt.createVideoEnrollment(userId2, 'en-US', 'Never forget tomorrow is a new day', './videoEnrollmentStephen1.mov'))
    assert_equal(201, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    ret = JSON.parse(myVoiceIt.createVideoEnrollment(userId2, 'en-US', 'Never forget tomorrow is a new day', './videoEnrollmentStephen2.mov'))
    assert_equal(201, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    ret = JSON.parse(myVoiceIt.createVideoEnrollment(userId2, 'en-US', 'Never forget tomorrow is a new day', './videoEnrollmentStephen3.mov'))
    assert_equal(201, ret['status'])
    assert_equal('SUCC', ret['responseCode'])

    # Verify Video
    begin
      ret = JSON.parse(myVoiceIt.videoVerification(userId1, 'en-US', 'Never forget tomorrow is a new day', './videoVerificationArmaan.mov'))
    rescue => e
      assert_equal("No such file or directory ", e.message.split("@").first)
    end
    ret = JSON.parse(myVoiceIt.videoVerification(userId1, 'en-US', 'Never forget tomorrow is a new day', './videoVerificationArmaan1.mov'))
    assert_equal(200, ret['status'])
    assert_equal('SUCC', ret['responseCode'])

    # Identify Video
    begin
      ret = JSON.parse(myVoiceIt.videoIdentification(groupId, 'en-US', 'Never forget tomorrow is a new day', './videoVerificationArmaan.mov'))
    rescue => e
      assert_equal("No such file or directory ", e.message.split("@").first)
    end
    ret = JSON.parse(myVoiceIt.videoIdentification(groupId, 'en-US', 'Never forget tomorrow is a new day', './videoVerificationArmaan1.mov'))
    assert_equal(200, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    assert_equal(userId1, ret['userId'])

    # Delete Enrollments
    ret = JSON.parse(myVoiceIt.deleteAllEnrollments(userId2))
    assert_equal(200, ret['status'])
    assert_equal('SUCC', ret['responseCode'])

    # Recreate users and groups for URL checks
    myVoiceIt.deleteUser(userId1)
    myVoiceIt.deleteUser(userId2)
    myVoiceIt.deleteGroup(groupId)
    userId1 = JSON.parse(myVoiceIt.createUser())['userId']
    userId2 = JSON.parse(myVoiceIt.createUser())['userId']
    groupId = JSON.parse(myVoiceIt.createGroup('Sample Group Description'))['groupId']
    myVoiceIt.addUserToGroup(groupId, userId1)
    myVoiceIt.addUserToGroup(groupId, userId2)

    # Video Enrollments by URL
    ret = JSON.parse(myVoiceIt.createVideoEnrollmentByUrl(userId1, 'en-US',  'Never forget tomorrow is a new day','https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/videoEnrollmentArmaan1.mov'))
    assert_equal(201, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    enrollmentId1 = ret['id']
    ret = JSON.parse(myVoiceIt.createVideoEnrollmentByUrl(userId1, 'en-US',  'Never forget tomorrow is a new day','https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/videoEnrollmentArmaan2.mov'))
    assert_equal(201, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    ret = JSON.parse(myVoiceIt.createVideoEnrollmentByUrl(userId1, 'en-US',  'Never forget tomorrow is a new day','https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/videoEnrollmentArmaan3.mov'))
    assert_equal(201, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    ret = JSON.parse(myVoiceIt.createVideoEnrollmentByUrl(userId2, 'en-US', 'Never forget tomorrow is a new day', 'https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/videoEnrollmentStephen1.mov'))
    assert_equal(201, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    ret = JSON.parse(myVoiceIt.createVideoEnrollmentByUrl(userId2, 'en-US', 'Never forget tomorrow is a new day', 'https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/videoEnrollmentStephen2.mov'))
    assert_equal(201, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    ret = JSON.parse(myVoiceIt.createVideoEnrollmentByUrl(userId2, 'en-US',  'Never forget tomorrow is a new day','https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/videoEnrollmentStephen3.mov'))
    assert_equal(201, ret['status'])
    assert_equal('SUCC', ret['responseCode'])

    # Verify Video by URL
    ret = JSON.parse(myVoiceIt.videoVerificationByUrl(userId1, 'en-US',  'Never forget tomorrow is a new day','https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/videoVerificationArmaan1.mov'))
    assert_equal(200, ret['status'])
    assert_equal('SUCC', ret['responseCode'])

    # Identify Video by URL
    ret = JSON.parse(myVoiceIt.videoIdentificationByUrl(groupId, 'en-US', 'Never forget tomorrow is a new day', 'https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/videoVerificationArmaan1.mov'))
    assert_equal(200, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    assert_equal(userId1, ret['userId'])

    #Get all video Enrollments
    ret = JSON.parse(myVoiceIt.getAllVideoEnrollments(userId1))
    assert_equal(200, ret['status'])
    assert_equal('SUCC', ret['responseCode'])

    #Delete video enrollment for user
    ret = JSON.parse(myVoiceIt.deleteVideoEnrollment(userId1, enrollmentId1))
    assert_equal(200, ret['status'])
    assert_equal('SUCC', ret['responseCode'])

    #Delete All Video Enrollments for user
    ret = JSON.parse(myVoiceIt.deleteAllVideoEnrollments(userId1))
    assert_equal(200, ret['status'])
    assert_equal('SUCC', ret['responseCode'])

    myVoiceIt.deleteUser(userId1)
    myVoiceIt.deleteUser(userId2)
    myVoiceIt.deleteGroup(groupId)

    # Delete files used
    File.delete('./videoEnrollmentArmaan1.mov')
    File.delete('./videoEnrollmentArmaan2.mov')
    File.delete('./videoEnrollmentArmaan3.mov')
    File.delete('./videoVerificationArmaan1.mov')
    File.delete('./videoEnrollmentStephen1.mov')
    File.delete('./videoEnrollmentStephen2.mov')
    File.delete('./videoEnrollmentStephen3.mov')
  end

  def test_voice() # voice enrollment, voice verification, voice identification, delete video enrollment  (and by URL respectively)
    # Download files to use
    download_file('https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/enrollmentNoel1.wav', './enrollmentNoel1.wav')
    download_file('https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/enrollmentNoel2.wav', './enrollmentNoel2.wav')
    download_file('https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/enrollmentNoel3.wav', './enrollmentNoel3.wav')
    download_file('https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/verificationNoel1.wav', './verificationNoel1.wav')
    download_file('https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/enrollmentStephen1.wav', './enrollmentStephen1.wav')
    download_file('https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/enrollmentStephen2.wav', './enrollmentStephen2.wav')
    download_file('https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/enrollmentStephen3.wav', './enrollmentStephen3.wav')

    viapikey = ENV['VIAPIKEY']
    viapitoken = ENV['VIAPITOKEN']
    myVoiceIt = VoiceIt2.new(viapikey, viapitoken)
    userId1 = JSON.parse(myVoiceIt.createUser())['userId']
    userId2 = JSON.parse(myVoiceIt.createUser())['userId']
    groupId = JSON.parse(myVoiceIt.createGroup('Sample Group Description'))['groupId']
    myVoiceIt.addUserToGroup(groupId, userId1)
    myVoiceIt.addUserToGroup(groupId, userId2)

    # Voice Enrollments
    begin
      ret = JSON.parse(myVoiceIt.createVoiceEnrollment(userId1, 'en-US', 'Never forget tomorrow is a new day', './enrollmentArmaan.wav'))
    rescue => e
      assert_equal("No such file or directory ", e.message.split("@").first)
    end
    ret = JSON.parse(myVoiceIt.createVoiceEnrollment(userId1, 'en-US', 'Never forget tomorrow is a new day', './enrollmentNoel1.wav'))
    assert_equal(201, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    ret = JSON.parse(myVoiceIt.createVoiceEnrollment(userId1, 'en-US',  'Never forget tomorrow is a new day','./enrollmentNoel2.wav'))
    assert_equal(201, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    ret = JSON.parse(myVoiceIt.createVoiceEnrollment(userId1, 'en-US',  'Never forget tomorrow is a new day','./enrollmentNoel3.wav'))
    assert_equal(201, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    ret = JSON.parse(myVoiceIt.createVoiceEnrollment(userId2, 'en-US', 'Never forget tomorrow is a new day', './enrollmentStephen1.wav'))
    assert_equal(201, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    ret = JSON.parse(myVoiceIt.createVoiceEnrollment(userId2, 'en-US', 'Never forget tomorrow is a new day', './enrollmentStephen2.wav'))
    assert_equal(201, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    ret = JSON.parse(myVoiceIt.createVoiceEnrollment(userId2, 'en-US', 'Never forget tomorrow is a new day', './enrollmentStephen3.wav'))
    assert_equal(201, ret['status'])
    assert_equal('SUCC', ret['responseCode'])

    # Verify Voice
    begin
      ret = JSON.parse(myVoiceIt.voiceVerification(userId1, 'en-US', 'Never forget tomorrow is a new day', './verificationArmaan.wav'))
    rescue => e
      assert_equal("No such file or directory ", e.message.split("@").first)
    end
    ret = JSON.parse(myVoiceIt.voiceVerification(userId1, 'en-US',  'Never forget tomorrow is a new day','./verificationNoel1.wav'))
    assert_equal(200, ret['status'])
    assert_equal('SUCC', ret['responseCode'])

    # Identify Voice
    begin
      ret = JSON.parse(myVoiceIt.voiceIdentification(groupId, 'en-US', 'Never forget tomorrow is a new day', './verificationArmaan.wav'))
    rescue => e
      assert_equal("No such file or directory ", e.message.split("@").first)
    end
    ret = JSON.parse(myVoiceIt.voiceIdentification(groupId, 'en-US', 'Never forget tomorrow is a new day', './verificationNoel1.wav'))
    assert_equal(200, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    assert_equal(userId1, ret['userId'])

    # For URL
    # Create new users and groups
    myVoiceIt.deleteAllEnrollments(userId1)
    myVoiceIt.deleteAllEnrollments(userId2)
    myVoiceIt.deleteUser(userId1)
    myVoiceIt.deleteUser(userId2)
    myVoiceIt.deleteGroup(groupId)
    userId1 = JSON.parse(myVoiceIt.createUser())['userId']
    userId2 = JSON.parse(myVoiceIt.createUser())['userId']
    groupId = JSON.parse(myVoiceIt.createGroup('Sample Group Description'))['groupId']
    myVoiceIt.addUserToGroup(groupId, userId1)
    myVoiceIt.addUserToGroup(groupId, userId2)

    # Voice Enrollments by URL
    ret = JSON.parse(myVoiceIt.createVoiceEnrollmentByUrl(userId1, 'en-US',  'Never forget tomorrow is a new day','https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/enrollmentNoel1.wav'))
    assert_equal(201, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    ret = JSON.parse(myVoiceIt.createVoiceEnrollmentByUrl(userId1, 'en-US',  'Never forget tomorrow is a new day','https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/enrollmentNoel2.wav'))
    assert_equal(201, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    ret = JSON.parse(myVoiceIt.createVoiceEnrollmentByUrl(userId1, 'en-US',  'Never forget tomorrow is a new day','https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/enrollmentNoel3.wav'))
    assert_equal(201, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    voiceEnrollmentId1 =  ret['id']
    ret = JSON.parse(myVoiceIt.createVoiceEnrollmentByUrl(userId2, 'en-US',  'Never forget tomorrow is a new day','https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/enrollmentStephen1.wav'))
    assert_equal(201, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    ret = JSON.parse(myVoiceIt.createVoiceEnrollmentByUrl(userId2, 'en-US',  'Never forget tomorrow is a new day','https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/enrollmentStephen2.wav'))
    assert_equal(201, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    ret = JSON.parse(myVoiceIt.createVoiceEnrollmentByUrl(userId2, 'en-US',  'Never forget tomorrow is a new day','https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/enrollmentStephen3.wav'))
    assert_equal(201, ret['status'])
    assert_equal('SUCC', ret['responseCode'])

    # Verify Voice by URL
    ret = JSON.parse(myVoiceIt.voiceVerificationByUrl(userId1, 'en-US', 'Never forget tomorrow is a new day', 'https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/verificationNoel1.wav'))
    assert_equal(200, ret['status'])
    assert_equal('SUCC', ret['responseCode'])

    # Identify Voice by URL
    ret = JSON.parse(myVoiceIt.voiceIdentificationByUrl(groupId, 'en-US', 'Never forget tomorrow is a new day', 'https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/verificationNoel1.wav'))
    assert_equal(200, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    assert_equal(userId1, ret['userId'])

    # Delete Voice Enrollment
    ret = JSON.parse(myVoiceIt.deleteVoiceEnrollment(userId1, voiceEnrollmentId1))
    assert_equal(200, ret['status'])
    assert_equal('SUCC', ret['responseCode'])


    #Delete all voice enrollments for user
    ret = JSON.parse(myVoiceIt.deleteAllVoiceEnrollments(userId1))
    assert_equal(200, ret['status'])
    assert_equal('SUCC', ret['responseCode'])

    #Get all voice Enrollments
    ret = JSON.parse(myVoiceIt.getAllVoiceEnrollments(userId1))
    assert_equal(200, ret['status'])
    assert_equal('SUCC', ret['responseCode'])

    myVoiceIt.deleteUser(userId1)
    myVoiceIt.deleteUser(userId2)
    myVoiceIt.deleteGroup(groupId)

    # Delete files used
    File.delete('./enrollmentNoel1.wav')
    File.delete('./enrollmentNoel2.wav')
    File.delete('./enrollmentNoel3.wav')
    File.delete('./verificationNoel1.wav')
    File.delete('./enrollmentStephen1.wav')
    File.delete('./enrollmentStephen2.wav')
    File.delete('./enrollmentStephen3.wav')
  end

  def test_face() # face enrollment, face verification, and delete face enrollment
    # Download files to be used
    download_file('https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/faceEnrollmentArmaan1.mp4', './faceEnrollmentArmaan1.mp4')
    download_file('https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/faceEnrollmentArmaan2.mp4', './faceEnrollmentArmaan2.mp4')
    download_file('https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/faceEnrollmentArmaan3.mp4', './faceEnrollmentArmaan3.mp4')
    download_file('https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/faceVerificationArmaan1.mp4', './faceVerificationArmaan1.mp4')
    download_file('https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/videoEnrollmentStephen1.mov', './faceEnrollmentStephen1.mov')
    download_file('https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/faceVerificationStephen1.mp4', './faceVerificationStephen1.mp4')

    viapikey = ENV['VIAPIKEY']
    viapitoken = ENV['VIAPITOKEN']
    myVoiceIt = VoiceIt2.new(viapikey, viapitoken)
    userId1 = JSON.parse(myVoiceIt.createUser())['userId']
    userId2 = JSON.parse(myVoiceIt.createUser())['userId']
    groupId = JSON.parse(myVoiceIt.createGroup('Sample Group Description'))['groupId']
    myVoiceIt.addUserToGroup(groupId, userId1)
    myVoiceIt.addUserToGroup(groupId, userId2)

    # Face Enrollments
    begin
      ret = JSON.parse(myVoiceIt.createFaceEnrollment(userId1, './faceEnrollmentArmaan.mp4'))
    rescue => e
      assert_equal("No such file or directory ", e.message.split("@").first)
    end
    ret = JSON.parse(myVoiceIt.createFaceEnrollment(userId1, './faceEnrollmentArmaan1.mp4'))
    assert_equal(201, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    ret = JSON.parse(myVoiceIt.getAllFaceEnrollments(userId1))
    assert_equal(200, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    assert_equal(1, ret['count'])
    ret = JSON.parse(myVoiceIt.createFaceEnrollment(userId2, './faceEnrollmentStephen1.mov'))
    assert_equal(201, ret['status'])
    assert_equal('SUCC', ret['responseCode'])

    # Face Verification
    begin
      ret = JSON.parse(myVoiceIt.faceVerification(userId1, './faceVerificationArmaan.mp4'))
    rescue => e
      assert_equal("No such file or directory ", e.message.split("@").first)
    end
    ret = JSON.parse(myVoiceIt.faceVerification(userId1, './faceVerificationArmaan1.mp4'))
    assert_equal(200, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    ret = JSON.parse(myVoiceIt.faceVerification(userId2, './faceVerificationStephen1.mp4'))
    assert_equal(200, ret['status'])
    assert_equal('SUCC', ret['responseCode'])

    #Face Identification
    begin
      ret = JSON.parse(myVoiceIt.faceIdentification(groupId, './faceVerificationArmaan.mp4'))
    rescue => e
      assert_equal("No such file or directory ", e.message.split("@").first)
    end
    ret = JSON.parse(myVoiceIt.faceIdentification(groupId, './faceVerificationArmaan1.mp4'))
    assert_equal(200, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    assert_equal(userId1, ret['userId'])

    #Prep For URL Calls
    ret = JSON.parse(myVoiceIt.deleteAllEnrollments(userId1))
    assert_equal(200, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    ret = JSON.parse(myVoiceIt.deleteAllEnrollments(userId2))
    assert_equal(200, ret['status'])
    assert_equal('SUCC', ret['responseCode'])

    #Face Enrollments by URL
    ret = JSON.parse(myVoiceIt.createFaceEnrollmentByUrl(userId1,'https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/faceEnrollmentArmaan1.mp4'))
    assert_equal(201, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    faceEnrollmentId1 = ret['faceEnrollmentId']
    ret = JSON.parse(myVoiceIt.createFaceEnrollmentByUrl(userId2,'https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/videoEnrollmentStephen1.mov'))
    assert_equal(201, ret['status'])
    assert_equal('SUCC', ret['responseCode'])

    #Face Verification by URL
    ret = JSON.parse(myVoiceIt.faceVerificationByUrl(userId1, 'https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/faceVerificationArmaan1.mp4'))
    assert_equal(200, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    ret = JSON.parse(myVoiceIt.faceVerificationByUrl(userId2, 'https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/faceVerificationStephen1.mp4'))
    assert_equal(200, ret['status'])
    assert_equal('SUCC', ret['responseCode'])

    #Face Identificaiton by URL
    ret = JSON.parse(myVoiceIt.faceIdentificationByUrl(groupId, 'https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/faceVerificationArmaan1.mp4'))
    assert_equal(200, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    assert_equal(userId1, ret['userId'])

    # Delete Face Enrollment
    ret = JSON.parse(myVoiceIt.deleteFaceEnrollment(userId1, faceEnrollmentId1))
    assert_equal(200, ret['status'])
    assert_equal('SUCC', ret['responseCode'])

    #Delete all face enrollments for user
    ret = JSON.parse(myVoiceIt.deleteAllFaceEnrollments(userId1))
    assert_equal(200, ret['status'])
    assert_equal('SUCC', ret['responseCode'])

    myVoiceIt.deleteUser(userId1)
    myVoiceIt.deleteUser(userId2)

    # Delete files used
    File.delete('./faceEnrollmentArmaan1.mp4')
    File.delete('./faceEnrollmentArmaan2.mp4')
    File.delete('./faceEnrollmentArmaan3.mp4')
    File.delete('./faceVerificationArmaan1.mp4')
    File.delete('./faceVerificationStephen1.mp4')
    File.delete('./faceEnrollmentStephen1.mov')
  end
end
