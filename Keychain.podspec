Pod::Spec.new do |s|
    s.name            = "Keychain"
    s.version         = "1.0.4"
    s.summary         = "Keychain SDK that will be used for enhancing work wih Keychaon."
    s.homepage        = "https://github.com/IBM/ios-keychain.git"
    s.license         = "TBD"
    s.author          = { "Daniel Mandea" => "daniel.mandea@yahoo.com" }
    s.platform        = :ios, "12.3"
    s.swift_version   = "5.1"
    s.requires_arc    = true
    s.source          = { :git => "https://github.com/IBM/ios-keychain.git", :tag => s.version.to_s }
    s.source_files    = "Sources/**/*.{h,m,swift}"
end
