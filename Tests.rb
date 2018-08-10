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
    ret = JSON.parse(myVoiceIt.deleteUser(userId))
    assert_equal(200, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    ret = JSON.parse(myVoiceIt.deleteGroup(groupId))
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
    ret = JSON.parse(myVoiceIt.createVideoEnrollment(userId1, 'en-US', './videoEnrollmentArmaan1.mov'))
    assert_equal(201, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    enrollmentId1 = ret['id']
    ret = JSON.parse(myVoiceIt.createVideoEnrollment(userId1, 'en-US', './videoEnrollmentArmaan2.mov'))
    assert_equal(201, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    enrollmentId2 = ret['id']
    ret = JSON.parse(myVoiceIt.createVideoEnrollment(userId1, 'en-US', './videoEnrollmentArmaan3.mov'))
    assert_equal(201, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    enrollmentId3 = ret['id']
    ret = JSON.parse(myVoiceIt.createVideoEnrollment(userId2, 'en-US', './videoEnrollmentStephen1.mov'))
    assert_equal(201, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    ret = JSON.parse(myVoiceIt.createVideoEnrollment(userId2, 'en-US', './videoEnrollmentStephen2.mov'))
    assert_equal(201, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    ret = JSON.parse(myVoiceIt.createVideoEnrollment(userId2, 'en-US', './videoEnrollmentStephen3.mov'))
    assert_equal(201, ret['status'])
    assert_equal('SUCC', ret['responseCode'])

    # Verify Video
    ret = JSON.parse(myVoiceIt.videoVerification(userId1, 'en-US', './videoVerificationArmaan1.mov'))
    assert_equal(200, ret['status'])
    assert_equal('SUCC', ret['responseCode'])

    # Identify Video
    ret = JSON.parse(myVoiceIt.videoIdentification(groupId, 'en-US', './videoVerificationArmaan1.mov'))
    assert_equal(200, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    assert_equal(userId1, ret['userId'])

    # Delete Enrollments
    ret = JSON.parse(myVoiceIt.deleteEnrollmentForUser(userId1, enrollmentId1))
    assert_equal(200, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    ret = JSON.parse(myVoiceIt.deleteEnrollmentForUser(userId1, enrollmentId2))
    assert_equal(200, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    ret = JSON.parse(myVoiceIt.deleteEnrollmentForUser(userId1, enrollmentId3))
    assert_equal(200, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    ret = JSON.parse(myVoiceIt.deleteAllEnrollmentsForUser(userId2))
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
    ret = JSON.parse(myVoiceIt.createVideoEnrollmentByUrl(userId1, 'en-US', 'https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/videoEnrollmentArmaan1.mov'))
    assert_equal(201, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    enrollmentId1 = ret['id']
    ret = JSON.parse(myVoiceIt.createVideoEnrollmentByUrl(userId1, 'en-US', 'https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/videoEnrollmentArmaan2.mov'))
    assert_equal(201, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    enrollmentId2 = ret['id']
    ret = JSON.parse(myVoiceIt.createVideoEnrollmentByUrl(userId1, 'en-US', 'https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/videoEnrollmentArmaan3.mov'))
    assert_equal(201, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    enrollmentId3 = ret['id']
    ret = JSON.parse(myVoiceIt.createVideoEnrollmentByUrl(userId2, 'en-US', 'https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/videoEnrollmentStephen1.mov'))
    assert_equal(201, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    ret = JSON.parse(myVoiceIt.createVideoEnrollmentByUrl(userId2, 'en-US', 'https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/videoEnrollmentStephen2.mov'))
    assert_equal(201, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    ret = JSON.parse(myVoiceIt.createVideoEnrollmentByUrl(userId2, 'en-US', 'https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/videoEnrollmentStephen3.mov'))
    assert_equal(201, ret['status'])
    assert_equal('SUCC', ret['responseCode'])

    # Verify Video by URL
    ret = JSON.parse(myVoiceIt.videoVerificationByUrl(userId1, 'en-US', 'https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/videoVerificationArmaan1.mov'))
    assert_equal(200, ret['status'])
    assert_equal('SUCC', ret['responseCode'])

    # Identify Video by URL
    ret = JSON.parse(myVoiceIt.videoIdentificationByUrl(groupId, 'en-US', 'https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/videoVerificationArmaan1.mov'))
    assert_equal(200, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    assert_equal(userId1, ret['userId'])

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
    download_file('https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/enrollmentArmaan1.wav', './enrollmentArmaan1.wav')
    download_file('https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/enrollmentArmaan2.wav', './enrollmentArmaan2.wav')
    download_file('https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/enrollmentArmaan3.wav', './enrollmentArmaan3.wav')
    download_file('https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/verificationArmaan1.wav', './verificationArmaan1.wav')
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
    ret = JSON.parse(myVoiceIt.createVoiceEnrollment(userId1, 'en-US', './enrollmentArmaan1.wav'))
    assert_equal(201, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    ret = JSON.parse(myVoiceIt.createVoiceEnrollment(userId1, 'en-US', './enrollmentArmaan2.wav'))
    assert_equal(201, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    ret = JSON.parse(myVoiceIt.createVoiceEnrollment(userId1, 'en-US', './enrollmentArmaan3.wav'))
    assert_equal(201, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    ret = JSON.parse(myVoiceIt.createVoiceEnrollment(userId2, 'en-US', './enrollmentArmaan1.wav'))
    assert_equal(201, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    ret = JSON.parse(myVoiceIt.createVoiceEnrollment(userId2, 'en-US', './enrollmentArmaan2.wav'))
    assert_equal(201, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    ret = JSON.parse(myVoiceIt.createVoiceEnrollment(userId2, 'en-US', './enrollmentArmaan3.wav'))
    assert_equal(201, ret['status'])
    assert_equal('SUCC', ret['responseCode'])

    # Verify Voice
    ret = JSON.parse(myVoiceIt.voiceVerification(userId1, 'en-US', './verificationArmaan1.wav'))
    assert_equal(200, ret['status'])
    assert_equal('SUCC', ret['responseCode'])

    # Identify Voice
    ret = JSON.parse(myVoiceIt.voiceIdentification(groupId, 'en-US', './verificationArmaan1.wav'))
    puts ret
    assert_equal(200, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    assert_equal(userId1, ret['userId'])

    # For URL
    # Create new users and groups
    myVoiceIt.deleteAllEnrollmentsForUser(userId1)
    myVoiceIt.deleteAllEnrollmentsForUser(userId2)
    myVoiceIt.deleteUser(userId1)
    myVoiceIt.deleteUser(userId2)
    myVoiceIt.deleteGroup(groupId)
    userId1 = JSON.parse(myVoiceIt.createUser())['userId']
    userId2 = JSON.parse(myVoiceIt.createUser())['userId']
    groupId = JSON.parse(myVoiceIt.createGroup('Sample Group Description'))['groupId']
    myVoiceIt.addUserToGroup(groupId, userId1)
    myVoiceIt.addUserToGroup(groupId, userId2)
    puts userId1
    puts userId2

    # Voice Enrollments by URL
    ret = JSON.parse(myVoiceIt.createVoiceEnrollmentByUrl(userId1, 'en-US', 'https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/enrollmentArmaan1.wav'))
    assert_equal(201, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    ret = JSON.parse(myVoiceIt.createVoiceEnrollmentByUrl(userId1, 'en-US', 'https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/enrollmentArmaan2.wav'))
    assert_equal(201, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    ret = JSON.parse(myVoiceIt.createVoiceEnrollmentByUrl(userId1, 'en-US', 'https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/enrollmentArmaan3.wav'))
    assert_equal(201, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    ret = JSON.parse(myVoiceIt.createVoiceEnrollmentByUrl(userId2, 'en-US', 'https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/enrollmentArmaan1.wav'))
    assert_equal(201, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    ret = JSON.parse(myVoiceIt.createVoiceEnrollmentByUrl(userId2, 'en-US', 'https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/enrollmentArmaan2.wav'))
    assert_equal(201, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    ret = JSON.parse(myVoiceIt.createVoiceEnrollmentByUrl(userId2, 'en-US', 'https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/enrollmentArmaan3.wav'))
    assert_equal(201, ret['status'])
    assert_equal('SUCC', ret['responseCode'])

    # Verify Voice by URL
    ret = JSON.parse(myVoiceIt.voiceVerificationByUrl(userId1, 'en-US', 'https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/verificationArmaan1.wav'))
    assert_equal(200, ret['status'])
    assert_equal('SUCC', ret['responseCode'])

    # Identify Voice by URL
    ret = JSON.parse(myVoiceIt.voiceIdentificationByUrl(groupId, 'en-US', 'https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/verificationArmaan1.wav'))
    puts ret
    assert_equal(200, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    assert_equal(userId1, ret['userId'])

    myVoiceIt.deleteUser(userId1)
    myVoiceIt.deleteUser(userId2)
    myVoiceIt.deleteGroup(groupId)

    # Delete files used
    File.delete('./enrollmentArmaan1.wav')
    File.delete('./enrollmentArmaan2.wav')
    File.delete('./enrollmentArmaan3.wav')
    File.delete('./verificationArmaan1.wav')
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

    viapikey = ENV['VIAPIKEY']
    viapitoken = ENV['VIAPITOKEN']
    myVoiceIt = VoiceIt2.new(viapikey, viapitoken)
    userId = JSON.parse(myVoiceIt.createUser())['userId']

    # Face Enrollments
    ret = JSON.parse(myVoiceIt.createFaceEnrollment(userId, './faceEnrollmentArmaan1.mp4'))
    assert_equal(201, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    faceEnrollmentId1 = ret['faceEnrollmentId']
    ret = JSON.parse(myVoiceIt.createFaceEnrollment(userId, './faceEnrollmentArmaan2.mp4'))
    assert_equal(201, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    faceEnrollmentId2 = ret['faceEnrollmentId']
    ret = JSON.parse(myVoiceIt.createFaceEnrollment(userId, './faceEnrollmentArmaan3.mp4'))
    assert_equal(201, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    faceEnrollmentId3 = ret['faceEnrollmentId']

    # Face Verification
    ret = JSON.parse(myVoiceIt.faceVerification(userId, './faceVerificationArmaan1.mp4'))
    assert_equal(200, ret['status'])
    assert_equal('SUCC', ret['responseCode'])

    # Delete Face Enrollment
    ret = JSON.parse(myVoiceIt.deleteFaceEnrollment(userId, faceEnrollmentId1))
    assert_equal(200, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    ret = JSON.parse(myVoiceIt.deleteFaceEnrollment(userId, faceEnrollmentId2))
    assert_equal(200, ret['status'])
    assert_equal('SUCC', ret['responseCode'])
    ret = JSON.parse(myVoiceIt.deleteFaceEnrollment(userId, faceEnrollmentId3))
    assert_equal(200, ret['status'])
    assert_equal('SUCC', ret['responseCode'])

    myVoiceIt.deleteUser(userId)

    # Delete files used
    File.delete('./faceEnrollmentArmaan1.mp4')
    File.delete('./faceEnrollmentArmaan2.mp4')
    File.delete('./faceEnrollmentArmaan3.mp4')
    File.delete('./faceVerificationArmaan1.mp4')
  end

end
