inhibit_all_warnings!
use_frameworks!

abstract_target 'HexagonalMap' do
    
    target 'HexagonalMapBasic' do
        
        platform :ios, '10.0'
        
        pod 'SCLAlertView'
        pod 'Buckets', '~> 2.0'
        pod 'HexagonalMap', :git => 'https://github.com/mrommel/hexagonal-map.git', :tag => '0.0.16'
    end
    
    target 'HexagonalMapBasicTests' do
        
        platform :ios, '10.0'
        
        pod 'Buckets', '~> 2.0'
    end
    
    target 'HexagonalMapBuilder' do
        
        platform :osx, '10.12'
        
        pod 'HexagonalMap', :git => 'https://github.com/mrommel/hexagonal-map.git', :tag => '0.0.16'
    end
end


