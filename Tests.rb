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
    ret = JSON.parse(myVoiceIt.expireUserTokens(userId))
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

  def test_sub_accounts()
    viapikey = ENV['VIAPIKEY']
    viapitoken = ENV['VIAPITOKEN']
    myVoiceIt = VoiceIt2.new(viapikey, viapitoken)
    ret = JSON.parse(myVoiceIt.createManagedSubAccount('Test','Ruby', '', '', ''))
    assert_equal(201, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    managedSubAccountAPIKey = ret['apiKey']
    ret = JSON.parse(myVoiceIt.createUnmanagedSubAccount('Test','Ruby', '', '', ''))
    assert_equal(201, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    unmanagedSubAccountAPIKey = ret['apiKey']
    ret = JSON.parse(myVoiceIt.switchSubAccountType(ret['apiKey']))
    assert_equal(200, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    ret = JSON.parse(myVoiceIt.regenerateSubAccountAPIToken(managedSubAccountAPIKey))
    assert_equal(200, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    ret = JSON.parse(myVoiceIt.deleteSubAccount(managedSubAccountAPIKey))
    assert_equal(200, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    ret = JSON.parse(myVoiceIt.deleteSubAccount(unmanagedSubAccountAPIKey))
    assert_equal(200, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
  end

  def test_video() # video enrollment, video verification, video identification, (and by URL respectively)
    # Download files to use
    download_file('https://drive.voiceit.io/files/videoEnrollmentB1.mov', './videoEnrollmentB1.mov')
    download_file('https://drive.voiceit.io/files/videoEnrollmentB2.mov', './videoEnrollmentB2.mov')
    download_file('https://drive.voiceit.io/files/videoEnrollmentB3.mov', './videoEnrollmentB3.mov')
    download_file('https://drive.voiceit.io/files/videoVerificationB1.mov', './videoVerificationB1.mov')
    download_file('https://drive.voiceit.io/files/videoEnrollmentC1.mov', './videoEnrollmentC1.mov')
    download_file('https://drive.voiceit.io/files/videoEnrollmentC2.mov', './videoEnrollmentC2.mov')
    download_file('https://drive.voiceit.io/files/videoEnrollmentC3.mov', './videoEnrollmentC3.mov')

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
      ret = JSON.parse(myVoiceIt.createVideoEnrollment(userId1, 'en-US', 'Never forget tomorrow is a new day', './enrollmentB.mov'))
    rescue => e
      assert_equal("No such file or directory ", e.message.split("@").first)
    end
    ret = JSON.parse(myVoiceIt.createVideoEnrollment(userId1, 'en-US', 'Never forget tomorrow is a new day', './videoEnrollmentB1.mov'))
    assert_equal(201, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    assert_equal(201, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    myVoiceIt.createVideoEnrollment(userId1, 'en-US', 'Never forget tomorrow is a new day', './videoEnrollmentB2.mov')
    ret = JSON.parse(myVoiceIt.createVideoEnrollment(userId1, 'en-US', 'Never forget tomorrow is a new day', './videoEnrollmentB3.mov'))
    assert_equal(201, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    ret = JSON.parse(myVoiceIt.getAllVideoEnrollments(userId1))
    assert_equal(200, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    ret = JSON.parse(myVoiceIt.createVideoEnrollment(userId2, 'en-US', 'Never forget tomorrow is a new day', './videoEnrollmentC1.mov'))
    assert_equal(201, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    ret = JSON.parse(myVoiceIt.createVideoEnrollment(userId2, 'en-US', 'Never forget tomorrow is a new day', './videoEnrollmentC2.mov'))
    assert_equal(201, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    ret = JSON.parse(myVoiceIt.createVideoEnrollment(userId2, 'en-US', 'Never forget tomorrow is a new day', './videoEnrollmentC3.mov'))
    assert_equal(201, ret['status'])
    assert_equal('SUCC', ret['responseCode'])

    # Verify Video
    begin
      ret = JSON.parse(myVoiceIt.videoVerification(userId1, 'en-US', 'Never forget tomorrow is a new day', './videoVerificationB.mov'))
    rescue => e
      assert_equal("No such file or directory ", e.message.split("@").first)
    end
    ret = JSON.parse(myVoiceIt.videoVerification(userId1, 'en-US', 'Never forget tomorrow is a new day', './videoVerificationB1.mov'))
    assert_equal('SUCC', ret['responseCode'])
    assert_equal(200, ret['status'])

    # Identify Video
    begin
      ret = JSON.parse(myVoiceIt.videoIdentification(groupId, 'en-US', 'Never forget tomorrow is a new day', './videoVerificationB.mov'))
    rescue => e
      assert_equal("No such file or directory ", e.message.split("@").first)
    end
    ret = JSON.parse(myVoiceIt.videoIdentification(groupId, 'en-US', 'Never forget tomorrow is a new day', './videoVerificationB1.mov'))
    assert_equal(200, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    assert_equal(userId1, ret['userId'])

    # Recreate users and groups for URL checks
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

    # Video Enrollments by URL
    ret = JSON.parse(myVoiceIt.createVideoEnrollmentByUrl(userId1, 'en-US',  'Never forget tomorrow is a new day','https://drive.voiceit.io/files/videoEnrollmentB1.mov'))
    assert_equal(201, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    ret = JSON.parse(myVoiceIt.createVideoEnrollmentByUrl(userId1, 'en-US',  'Never forget tomorrow is a new day','https://drive.voiceit.io/files/videoEnrollmentB2.mov'))
    assert_equal(201, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    ret = JSON.parse(myVoiceIt.createVideoEnrollmentByUrl(userId1, 'en-US',  'Never forget tomorrow is a new day','https://drive.voiceit.io/files/videoEnrollmentB3.mov'))
    assert_equal(201, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    ret = JSON.parse(myVoiceIt.createVideoEnrollmentByUrl(userId2, 'en-US', 'Never forget tomorrow is a new day', 'https://drive.voiceit.io/files/videoEnrollmentC1.mov'))
    assert_equal(201, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    ret = JSON.parse(myVoiceIt.createVideoEnrollmentByUrl(userId2, 'en-US', 'Never forget tomorrow is a new day', 'https://drive.voiceit.io/files/videoEnrollmentC2.mov'))
    assert_equal(201, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    ret = JSON.parse(myVoiceIt.createVideoEnrollmentByUrl(userId2, 'en-US',  'Never forget tomorrow is a new day','https://drive.voiceit.io/files/videoEnrollmentC3.mov'))
    assert_equal(201, ret['status'])
    assert_equal('SUCC', ret['responseCode'])

    # Verify Video by URL
    ret = JSON.parse(myVoiceIt.videoVerificationByUrl(userId1, 'en-US',  'Never forget tomorrow is a new day','https://drive.voiceit.io/files/videoVerificationB1.mov'))
    assert_equal(200, ret['status'])
    assert_equal('SUCC', ret['responseCode'])

    # Identify Video by URL
    ret = JSON.parse(myVoiceIt.videoIdentificationByUrl(groupId, 'en-US', 'Never forget tomorrow is a new day', 'https://drive.voiceit.io/files/videoVerificationB1.mov'))
    assert_equal(200, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    assert_equal(userId1, ret['userId'])

    #Get all video Enrollments
    ret = JSON.parse(myVoiceIt.getAllVideoEnrollments(userId1))
    assert_equal(200, ret['status'])
    assert_equal('SUCC', ret['responseCode'])

    myVoiceIt.deleteAllEnrollments(userId1)
    myVoiceIt.deleteAllEnrollments(userId2)
    myVoiceIt.deleteUser(userId1)
    myVoiceIt.deleteUser(userId2)
    myVoiceIt.deleteGroup(groupId)

    # Delete files used
    File.delete('./videoEnrollmentB1.mov')
    File.delete('./videoEnrollmentB2.mov')
    File.delete('./videoEnrollmentB3.mov')
    File.delete('./videoVerificationB1.mov')
    File.delete('./videoEnrollmentC1.mov')
    File.delete('./videoEnrollmentC2.mov')
    File.delete('./videoEnrollmentC3.mov')
  end

  def test_voice() # voice enrollment, voice verification, voice identification, (and by URL respectively)
    # Download files to use
    download_file('https://drive.voiceit.io/files/enrollmentA1.wav', './enrollmentA1.wav')
    download_file('https://drive.voiceit.io/files/enrollmentA2.wav', './enrollmentA2.wav')
    download_file('https://drive.voiceit.io/files/enrollmentA3.wav', './enrollmentA3.wav')
    download_file('https://drive.voiceit.io/files/verificationA1.wav', './verificationA1.wav')
    download_file('https://drive.voiceit.io/files/enrollmentC1.wav', './enrollmentC1.wav')
    download_file('https://drive.voiceit.io/files/enrollmentC2.wav', './enrollmentC2.wav')
    download_file('https://drive.voiceit.io/files/enrollmentC3.wav', './enrollmentC3.wav')

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
      ret = JSON.parse(myVoiceIt.createVoiceEnrollment(userId1, 'en-US', 'Never forget tomorrow is a new day', './enrollmentB.wav'))
    rescue => e
      assert_equal("No such file or directory ", e.message.split("@").first)
    end
    ret = JSON.parse(myVoiceIt.createVoiceEnrollment(userId1, 'en-US', 'Never forget tomorrow is a new day', './enrollmentA1.wav'))
    assert_equal(201, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    ret = JSON.parse(myVoiceIt.createVoiceEnrollment(userId1, 'en-US',  'Never forget tomorrow is a new day','./enrollmentA2.wav'))
    assert_equal(201, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    ret = JSON.parse(myVoiceIt.createVoiceEnrollment(userId1, 'en-US',  'Never forget tomorrow is a new day','./enrollmentA3.wav'))
    assert_equal(201, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    ret = JSON.parse(myVoiceIt.createVoiceEnrollment(userId2, 'en-US', 'Never forget tomorrow is a new day', './enrollmentC1.wav'))
    assert_equal(201, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    ret = JSON.parse(myVoiceIt.createVoiceEnrollment(userId2, 'en-US', 'Never forget tomorrow is a new day', './enrollmentC2.wav'))
    assert_equal(201, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    ret = JSON.parse(myVoiceIt.createVoiceEnrollment(userId2, 'en-US', 'Never forget tomorrow is a new day', './enrollmentC3.wav'))
    assert_equal(201, ret['status'])
    assert_equal('SUCC', ret['responseCode'])

    # Verify Voice
    begin
      ret = JSON.parse(myVoiceIt.voiceVerification(userId1, 'en-US', 'Never forget tomorrow is a new day', './verificationB.wav'))
    rescue => e
      assert_equal("No such file or directory ", e.message.split("@").first)
    end
    ret = JSON.parse(myVoiceIt.voiceVerification(userId1, 'en-US',  'Never forget tomorrow is a new day','./verificationA1.wav'))
    assert_equal(200, ret['status'])
    assert_equal('SUCC', ret['responseCode'])

    # Identify Voice
    begin
      ret = JSON.parse(myVoiceIt.voiceIdentification(groupId, 'en-US', 'Never forget tomorrow is a new day', './verificationB.wav'))
    rescue => e
      assert_equal("No such file or directory ", e.message.split("@").first)
    end
    ret = JSON.parse(myVoiceIt.voiceIdentification(groupId, 'en-US', 'Never forget tomorrow is a new day', './verificationA1.wav'))
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
    ret = JSON.parse(myVoiceIt.createVoiceEnrollmentByUrl(userId1, 'en-US',  'Never forget tomorrow is a new day','https://drive.voiceit.io/files/enrollmentA1.wav'))
    assert_equal(201, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    ret = JSON.parse(myVoiceIt.createVoiceEnrollmentByUrl(userId1, 'en-US',  'Never forget tomorrow is a new day','https://drive.voiceit.io/files/enrollmentA2.wav'))
    assert_equal(201, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    ret = JSON.parse(myVoiceIt.createVoiceEnrollmentByUrl(userId1, 'en-US',  'Never forget tomorrow is a new day','https://drive.voiceit.io/files/enrollmentA3.wav'))
    assert_equal(201, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    ret = JSON.parse(myVoiceIt.createVoiceEnrollmentByUrl(userId2, 'en-US',  'Never forget tomorrow is a new day','https://drive.voiceit.io/files/enrollmentC1.wav'))
    assert_equal(201, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    ret = JSON.parse(myVoiceIt.createVoiceEnrollmentByUrl(userId2, 'en-US',  'Never forget tomorrow is a new day','https://drive.voiceit.io/files/enrollmentC2.wav'))
    assert_equal(201, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    ret = JSON.parse(myVoiceIt.createVoiceEnrollmentByUrl(userId2, 'en-US',  'Never forget tomorrow is a new day','https://drive.voiceit.io/files/enrollmentC3.wav'))
    assert_equal(201, ret['status'])
    assert_equal('SUCC', ret['responseCode'])

    # Verify Voice by URL
    ret = JSON.parse(myVoiceIt.voiceVerificationByUrl(userId1, 'en-US', 'Never forget tomorrow is a new day', 'https://drive.voiceit.io/files/verificationA1.wav'))
    assert_equal(200, ret['status'])
    assert_equal('SUCC', ret['responseCode'])

    # Identify Voice by URL
    ret = JSON.parse(myVoiceIt.voiceIdentificationByUrl(groupId, 'en-US', 'Never forget tomorrow is a new day', 'https://drive.voiceit.io/files/verificationA1.wav'))
    assert_equal(200, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    assert_equal(userId1, ret['userId'])


    #Get all voice Enrollments
    ret = JSON.parse(myVoiceIt.getAllVoiceEnrollments(userId1))
    assert_equal(200, ret['status'])
    assert_equal('SUCC', ret['responseCode'])

    myVoiceIt.deleteAllEnrollments(userId1)
    myVoiceIt.deleteAllEnrollments(userId2)
    myVoiceIt.deleteUser(userId1)
    myVoiceIt.deleteUser(userId2)
    myVoiceIt.deleteGroup(groupId)

    # Delete files used
    File.delete('./enrollmentA1.wav')
    File.delete('./enrollmentA2.wav')
    File.delete('./enrollmentA3.wav')
    File.delete('./verificationA1.wav')
    File.delete('./enrollmentC1.wav')
    File.delete('./enrollmentC2.wav')
    File.delete('./enrollmentC3.wav')
  end

  def test_face() # face enrollment, face verification
    # Download files to be used
    download_file('https://drive.voiceit.io/files/faceEnrollmentB1.mp4', './faceEnrollmentB1.mp4')
    download_file('https://drive.voiceit.io/files/faceEnrollmentB2.mp4', './faceEnrollmentB2.mp4')
    download_file('https://drive.voiceit.io/files/faceEnrollmentB3.mp4', './faceEnrollmentB3.mp4')
    download_file('https://drive.voiceit.io/files/faceVerificationB1.mp4', './faceVerificationB1.mp4')
    download_file('https://drive.voiceit.io/files/videoEnrollmentC1.mov', './faceEnrollmentC1.mov')
    download_file('https://drive.voiceit.io/files/faceVerificationC1.mp4', './faceVerificationC1.mp4')

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
      ret = JSON.parse(myVoiceIt.createFaceEnrollment(userId1, './faceEnrollmentB.mp4'))
    rescue => e
      assert_equal("No such file or directory ", e.message.split("@").first)
    end
    ret = JSON.parse(myVoiceIt.createFaceEnrollment(userId1, './faceEnrollmentB1.mp4'))
    assert_equal(201, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    ret = JSON.parse(myVoiceIt.getAllFaceEnrollments(userId1))
    assert_equal(200, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    ret = JSON.parse(myVoiceIt.createFaceEnrollment(userId2, './faceEnrollmentC1.mov'))
    assert_equal(201, ret['status'])
    assert_equal('SUCC', ret['responseCode'])

    # Face Verification
    begin
      ret = JSON.parse(myVoiceIt.faceVerification(userId1, './faceVerificationB.mp4'))
    rescue => e
      assert_equal("No such file or directory ", e.message.split("@").first)
    end
    ret = JSON.parse(myVoiceIt.faceVerification(userId1, './faceVerificationB1.mp4'))
    assert_equal(200, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    ret = JSON.parse(myVoiceIt.faceVerification(userId2, './faceVerificationC1.mp4'))
    assert_equal(200, ret['status'])
    assert_equal('SUCC', ret['responseCode'])

    #Face Identification
    begin
      ret = JSON.parse(myVoiceIt.faceIdentification(groupId, './faceVerificationB.mp4'))
    rescue => e
      assert_equal("No such file or directory ", e.message.split("@").first)
    end
    ret = JSON.parse(myVoiceIt.faceIdentification(groupId, './faceVerificationB1.mp4'))
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
    ret = JSON.parse(myVoiceIt.createFaceEnrollmentByUrl(userId1,'https://drive.voiceit.io/files/faceEnrollmentB1.mp4'))
    assert_equal(201, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    ret = JSON.parse(myVoiceIt.createFaceEnrollmentByUrl(userId2,'https://drive.voiceit.io/files/videoEnrollmentC1.mov'))
    assert_equal(201, ret['status'])
    assert_equal('SUCC', ret['responseCode'])

    #Face Verification by URL
    ret = JSON.parse(myVoiceIt.faceVerificationByUrl(userId1, 'https://drive.voiceit.io/files/faceVerificationB1.mp4'))
    assert_equal(200, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    ret = JSON.parse(myVoiceIt.faceVerificationByUrl(userId2, 'https://drive.voiceit.io/files/faceVerificationC1.mp4'))
    assert_equal(200, ret['status'])
    assert_equal('SUCC', ret['responseCode'])

    #Face Identificaiton by URL
    ret = JSON.parse(myVoiceIt.faceIdentificationByUrl(groupId, 'https://drive.voiceit.io/files/faceVerificationB1.mp4'))
    assert_equal(200, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    assert_equal(userId1, ret['userId'])

    # Delete Face Enrollment
    ret = JSON.parse(myVoiceIt.deleteAllEnrollments(userId1))
    assert_equal(200, ret['status'])
    assert_equal('SUCC', ret['responseCode'])

    #Delete all face enrollments for user
    ret = JSON.parse(myVoiceIt.deleteAllEnrollments(userId1))
    assert_equal(200, ret['status'])
    assert_equal('SUCC', ret['responseCode'])

    myVoiceIt.deleteUser(userId1)
    myVoiceIt.deleteUser(userId2)

    # Delete files used
    File.delete('./faceEnrollmentB1.mp4')
    File.delete('./faceEnrollmentB2.mp4')
    File.delete('./faceEnrollmentB3.mp4')
    File.delete('./faceVerificationB1.mp4')
    File.delete('./faceVerificationC1.mp4')
    File.delete('./faceEnrollmentC1.mov')
  end
end
