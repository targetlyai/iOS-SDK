Pod::Spec.new do |spec|
  spec.name = "Targetly-iOS"
  spec.version = "0.1.0"
  spec.license = { :type => "MIT", :file => "LICENSE" }
  spec.summary = "Targetly is a powerful and pure Swift implemented library for personalization of push notifications."
  spec.homepage = "https://github.com/targetlyai/iOS-SDK" 
  spec.authors = { 'TargetlyAI Software Foundation' => 'info@targetly.ai' }
  spec.source = { :git => "https://github.com/targetlyai/iOS-SDK.git", :tag => spec.version }

  spec.ios.deployment_target = '10.0'

  spec.swift_versions = ['5.1', '5.2', '5.3']

  spec.source_files  = ["Targetly/**/*.swift"]
  spec.exclude_files = "Targetly/Targetly-Demo/"

end