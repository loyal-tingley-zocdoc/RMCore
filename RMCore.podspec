Pod::Spec.new do |spec|
    spec.name           = 'RMCore'
    spec.version        = '0.0.1'
    spec.summary	= 'Grab bag of utilities'
    spec.homepage       = 'http://github.com/rmannion/RMCore'
    spec.license        = { :type => 'MIT', :file => 'LICENSE' }
    spec.author         = { 'Ryan Mannion' => 'rmannion@gmail.com' }
    spec.platform       = :ios, '8.0'
    spec.source         = { :git => 'https://github.com/rmannion/RMCore.git', :tag => '0.0.1' }
    spec.source_files   = 'RMCore', 'RMCore/**/*.{h,m}'
    spec.exclude_files  = 'RMCore/Exclude'

    spec.dependency 'Bond', '~> 4.0'
end
