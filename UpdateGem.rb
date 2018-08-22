require 'rest-client'

# Generate required files

# Generate new version string
oldVersion = %x( gem search voiceit2 )[/\((.*?)\)/, 1]
oldVersionArray = oldVersion.split('.')
commit = %x( git log -1 --pretty=%B | head -n 1 )
if commit.include? "RELEASE"


  system 'gem build VoiceIt2.gemspec'
  system 'gem push VoiceIt2-' + newVersion + '.gem'
  if commit.include? "RELEASEMAJOR"
    oldVersionArray[0] = (oldVersionArray[0].to_i + 1).to_s
    oldVersionArray[1] = '0'
    oldVersionArray[2] = '0'
  elsif commit.include? "RELEASEMINOR"
    oldVersionArray[1] = (oldVersionArray[1].to_i + 1).to_s
    oldVersionArray[2] = '0'
  elsif commit.include? "RELEASEPATCH"
    oldVersionArray[2] = (oldVersionArray[2].to_i + 1).to_s
  else
    puts "Must specify RELEASEMAJOR, RELEASEMINOR, or RELEASEPATCH in the title."
    exit(1)
  end

  newVersion = oldVersionArray.join('.')
  date = Time.now.strftime("%Y-%m-%d")
  # Generate Gemspec file
  gemspec = "Gem::Specification.new do |s|
    s.name        = 'VoiceIt2'
    s.version     = '" + newVersion + "'
    s.date        = '" + date + "'
    s.summary     = 'VoiceIt Api 2'
    s.description = 'A wrapper for VoiceIt API 2'
    s.authors     = ['StephenAkers']
    s.email       = 'stephen@voiceit.io'
    s.files       = ['./VoiceIt2.rb']
    s.homepage    =
      'http://rubygems.org/gems/hola'
    s.license       = 'MIT'
  end"
  File.open('./VoiceIt2.gemspec', 'w') { |file| file.write(gemspec) }
end
