# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'unify_app' do
  # Uncomment the next line if you're using Swift or would like to use dynamic frameworks
  use_frameworks!

  # Pods for unify_app
  pod 'Firebase/Core'
  pod 'FirebaseUI'
  pod 'Firebase/Database'

  # Firebase dependencies
  pod 'FBSDKCoreKit'
  pod 'FBSDKLoginKit'

end

post_install do |installer|
    copy_pods_resources_path = "Pods/Target Support Files/Pods-unify_app/Pods-unify_app-resources.sh"
    string_to_replace = '--compile "${BUILT_PRODUCTS_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"'
    assets_compile_with_app_icon_arguments = '--compile "${BUILT_PRODUCTS_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}" --app-icon "${ASSETCATALOG_COMPILER_APPICON_NAME}" --output-partial-info-plist "${BUILD_DIR}/assetcatalog_generated_info.plist"'
    text = File.read(copy_pods_resources_path)
    new_contents = text.gsub(string_to_replace, assets_compile_with_app_icon_arguments)
    File.open(copy_pods_resources_path, "w") {|file| file.puts new_contents }
end
