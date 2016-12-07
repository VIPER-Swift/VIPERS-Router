Pod::Spec.new do |s|
  s.name             = 'VIPERS-Router'
  s.version          = '0.1.0'
  s.summary          = 'Router implementation used by the iOS application framework "VIPERS".'

  s.description      = <<-DESC
A router is an object that maps from a routeable item (an object conforming to the empty protocol RoutableProtocol) to a specific Route-Description (an object conforming to the empty protocol RouteDescriptionProtocol). It therefore uses a RouteDefinition (an object conforming to an empty RouteDefinitionProtocol) to map from a Routable to a RouteDescription.
                       DESC

  s.homepage         = 'https://github.com/VIPER-Swift/VIPERS-Router'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Jan Bartel' => 'barteljan@yahoo.de' }
  s.source           = { :git => 'https://github.com/VIPER-Swift/VIPERS-Router.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'VIPERS-Router/Classes/**/*'

  s.dependency 'VIPERS-Router-Protocol'
  s.dependency 'VIPERS-Converter-Protocol'

end
