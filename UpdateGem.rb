require 'rest-client'

# Generate required files

# Generate new version string
oldVersion = %x( gem search voiceit2 )[/\((.*?)\)/, 1]
oldVersionArray = oldVersion.split('.')
oldVersionArray[2] = (oldVersionArray[2].to_i + 1).to_s
newVersion = oldVersionArray.join('.')

# Move ./VoiceIt2.rb to ./lib/VoiceIt2
# Dir.mkdir './lib'
# File.rename ./VoiceIt2.rb, ./lib/VoiceIt2.rb

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

system 'gem build VoiceIt2.gemspec'
system 'gem push VoiceIt2' + newVersion + '.gem'
