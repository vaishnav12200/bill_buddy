plugins {
    id "com.android.application"
    id "kotlin-android"
    id "dev.flutter.flutter-gradle-plugin"
}

android {
    namespace = "com.example.bill_buddy"
    compileSdk = 33

    defaultConfig {
        applicationId = "com.example.bill_buddy"
        minSdk = 21
        targetSdk = 33
        versionCode = 1
        versionName = "1.0"
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = '17'
    }

    buildTypes {
        release {
            minifyEnabled false
            shrinkResources false
        }
    }
}

flutter {
    source = "../.."
}

apply plugin: 'com.google.gms.google-services'
