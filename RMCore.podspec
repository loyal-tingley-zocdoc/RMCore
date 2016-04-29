Pod::Spec.new do |spec|
    spec.name           = 'RMCore'
    spec.version        = '0.0.1'
    spec.homepage       = 'http://github.com/rmannion/RMCore'
    spec.license        = { :type => 'MIT', :file => 'LICENSE' }
    spec.author         = { 'Ryan Mannion' => 'rmannion@gmail.com' }
    spec.platform       = :ios, '7.0'
    spec.source         = { :git => 'http://github.com/rmannion/RMCore.git', :tag => '0.0.1' }
    spec.source_files   = 'Classes', 'Classes/**/*.{h,m}'
    spec.exclude_files  = 'Classes/Exclude'
    spec.dependency	= 'Bond', '~> 4.0'
end
